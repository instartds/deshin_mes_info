<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmr100ukrv_kd"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 -->
	<t:ExtComboStore comboType="AU" comboCode="P001"/> <!-- 진행상태 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" /><!--창고-->

	<t:ExtComboStore comboType="AU" comboCode="B024"/> <!-- 입고담당 -->
	<t:ExtComboStore comboType="AU" comboCode="P003"/> <!-- 불량유형 -->
	<t:ExtComboStore comboType="AU" comboCode="P002"/> <!-- 특기사항 분류 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var BsaCodeInfo = {
	gsManageLotNoYN: '${gsManageLotNoYN}',     // 작업지시와 생산실적 LOT 연계여부 설정 값
	gsChkProdtDateYN: '${gsChkProdtDateYN}',   // 착수예정일 체크여부
	glEndRate: '${glEndRate}',
	gsSumTypeCell: '${gsSumTypeCell}',          // 재고합산유형 : 창고 Cell 합산
    gsMoldCode   : '${gsMoldCode}',             // 작업지시 설비여부
    gsEquipCode  : '${gsEquipCode}'             // 작업지시 금형여부

};
/*var output ='';
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);*/


var activeTabId2 = 's_pmr100ukrv_kdMasterStore3';
var outDivCode = UserInfo.divCode;
var checkDraftStatus = false;
var outouProdtSave; // 생산실적 자동입고
var masterSelectIdx = 0;    //
var detailSelectIdx = 0;
function appMain() {

	var isMoldCode = false;
    if(BsaCodeInfo.gsMoldCode=='N') {
        isMoldCode = true;
    }

    var isEquipCode = false;
    if(BsaCodeInfo.gsEquipCode=='N') {
        isEquipCode = true;
    }

	var gsSumTypeCell = false;
    if(BsaCodeInfo.gsSumTypeCell =='N')    {
        gsSumTypeCell = true;
    }
	//창고에 따른 창고cell 콤보load..
//    var cbStore = Unilite.createStore('WhCellComboStoreGrid',{
//        autoLoad: false,
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
//            var param= panelSearch.getValues();
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

    //창고에 따른 창고cell 콤보load..
//    var cbStore2 = Unilite.createStore('WhCellComboStoreGrid2',{
//        autoLoad: false,
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
//            var param= panelSearch.getValues();
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

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 작업실적 등록
		api: {
			read: 's_pmr100ukrv_kdService.selectDetailList'
		}
	});

//	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 작업지시별 등록
//		api: {
//			read: 's_pmr100ukrv_kdService.selectDetailList2',
//			update: 's_pmr100ukrv_kdService.updateDetail',
//			create: 's_pmr100ukrv_kdService.insertDetail',
//			destroy: 's_pmr100ukrv_kdService.deleteDetail',
//			syncAll: 's_pmr100ukrv_kdService.saveAll'
//		}
//	});

	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 공정별 등록1
		api: {
			read: 's_pmr100ukrv_kdService.selectDetailList3',
			update: 's_pmr100ukrv_kdService.updateDetail3',
			create: 's_pmr100ukrv_kdService.insertDetail3',
			destroy: 's_pmr100ukrv_kdService.deleteDetail3',
			syncAll: 's_pmr100ukrv_kdService.saveAll3'
		}
	});

	var directProxy4 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 공정별 등록2
		api: {
            read: 's_pmr100ukrv_kdService.selectDetailList4',
            update: 's_pmr100ukrv_kdService.updateDetail4',
            create: 's_pmr100ukrv_kdService.insertDetail4',
            destroy: 's_pmr100ukrv_kdService.deleteDetail4',
            syncAll: 's_pmr100ukrv_kdService.saveAll4'
        }
	});

	var directProxy5 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 불량내역 등록
		api: {
			read: 's_pmr100ukrv_kdService.selectDetailList5',
			update: 's_pmr100ukrv_kdService.updateDetail5',
			create: 's_pmr100ukrv_kdService.insertDetail5',
			destroy: 's_pmr100ukrv_kdService.deleteDetail5',
			syncAll: 's_pmr100ukrv_kdService.saveAll5'
		}
	});

	var directProxy6 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 특기사항 등록
		api: {
			read: 's_pmr100ukrv_kdService.selectDetailList6',
			update: 's_pmr100ukrv_kdService.updateDetail6',
			create: 's_pmr100ukrv_kdService.insertDetail6',
			destroy: 's_pmr100ukrv_kdService.deleteDetail6',
			syncAll: 's_pmr100ukrv_kdService.saveAll6'
		}
	});

	var panelSearch = Unilite.createSearchPanel('s_pmr100ukrv_kdpanelSearch', {
		collapsed: UserInfo.appOption.collapseLeftSearch,
		title: '검색조건',
    	defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
		hidden:true,
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
		        name:'DIV_CODE',
		        xtype: 'uniCombobox',
		        comboType:'BOR120' ,
		        allowBlank:false,
			    value: UserInfo.divCode,
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {
			      		panelResult.setValue('DIV_CODE', newValue);
			     	}
			    }
		    },{
		        fieldLabel: '착수예정일',
				xtype: 'uniDateRangefield',
				startFieldName: 'PRODT_START_DATE_FR',
				endFieldName:'PRODT_START_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				textFieldWidth:170,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('PRODT_START_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('PRODT_START_DATE_TO',newValue);
			    	}
			    }
			},{
				xtype: 'radiogroup',
				fieldLabel: ' ',
				id: 'rdoSelect',
				items: [{
					boxLabel: '전체',
					width: 60,
					name: 'CONTROL_STATUS',
					inputValue: '',
					checked: true
				},{
					boxLabel : '진행',
					width: 60,
					name: 'CONTROL_STATUS',
					inputValue: '2'
				},{
					boxLabel : '마감',
					width: 60,
					name: 'CONTROL_STATUS',
					inputValue: '8'
				},{
					boxLabel : '완료',
					width: 60,
					name: 'CONTROL_STATUS',
					inputValue: '9'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('CONTROL_STATUS').setValue(newValue.CONTROL_STATUS);
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
			},
			Unilite.popup('DIV_PUMOK',{
					fieldLabel: '품목코드',
					validateBlank:false,
					textFieldName: 'ITEM_NAME',
					valueFieldName: 'ITEM_CODE',
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
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),{
                fieldLabel: '작업지시번호',
                xtype: 'uniTextfield',
                name: 'WKORD_NUM',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('WKORD_NUM', newValue);
                    }
                }
            },{
                fieldLabel: 'LOT_NO',
                xtype: 'uniTextfield',
                name: 'LOT_NO',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('LOT_NO', newValue);
                    }
                }
            },{
                fieldLabel: '품번',
                xtype: 'uniTextfield',
                name: 'SPEC',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('SPEC', newValue);
                    }
                }
            },{
                fieldLabel: '작업지시번호TEMP',
                xtype: 'uniTextfield',
                name: 'WKORD_NUM_TEMP',
                hidden: true
            },{
		 		fieldLabel: '작업지시량',
		 		xtype: 'uniTextfield',
		 		name: 'WKORD_Q',
		        holdable: 'hold',
		 		hidden: true
			},{
		 		fieldLabel: '공정코드',
		 		xtype: 'uniTextfield',
		 		name: 'PROG_WORK_CODE',
		        holdable: 'hold',
		 		hidden: true
			},{
		 		fieldLabel: '품목코드',
		 		xtype: 'uniTextfield',
		 		name: 'ITEM_CODE1',
		        holdable: 'hold',
		 		hidden: true
			},{
		 		fieldLabel: '생산실적번호',
		 		xtype: 'uniTextfield',
		 		name: 'PRODT_NUM',
		        holdable: 'hold',
		 		hidden: true
			},{
		 		fieldLabel: 'RESULT_TYPE',
		 		xtype: 'uniTextfield',
		 		name: 'RESULT_TYPE',
		 		hidden: true
			},{
                fieldLabel: 'RESULT_YN',
                xtype: 'uniTextfield',
                name: 'RESULT_YN',
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
		},
		setLoadRecord: function(record) {
			var me = this;
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
		        fieldLabel: '사업장',
		        name:'DIV_CODE',
		        xtype: 'uniCombobox',
		        comboType:'BOR120' ,
		        allowBlank:false,
			    value: UserInfo.divCode,
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {
			      		panelSearch.setValue('DIV_CODE', newValue);
			     	}
			    }
		    },{
		        fieldLabel: '착수예정일',
				xtype: 'uniDateRangefield',
				startFieldName: 'PRODT_START_DATE_FR',
				endFieldName:'PRODT_START_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				textFieldWidth:170,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('PRODT_START_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('PRODT_START_DATE_TO',newValue);
			    	}
			    }
			},{
				xtype: 'radiogroup',
				fieldLabel: ' ',
				id: 'rdoSelect2',
				items: [{
					boxLabel: '전체',
					width: 60,
					name: 'CONTROL_STATUS',
					inputValue: '',
					checked: true
				},{
					boxLabel : '진행',
					width: 60,
					name: 'CONTROL_STATUS',
					inputValue: '2'
				},{
					boxLabel : '마감',
					width: 60,
					name: 'CONTROL_STATUS',
					inputValue: '8'
				},{
					boxLabel : '완료',
					width: 60,
					name: 'CONTROL_STATUS',
					inputValue: '9'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.getField('CONTROL_STATUS').setValue(newValue.CONTROL_STATUS);
					}
				}
			},{
                fieldLabel: 'LOT_NO',
                xtype: 'uniTextfield',
                name: 'LOT_NO',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                    	panelSearch.setValue('LOT_NO', newValue);
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
			},
			Unilite.popup('DIV_PUMOK',{
					fieldLabel: '품목코드',
					validateBlank:false,
					textFieldName: 'ITEM_NAME',
					valueFieldName: 'ITEM_CODE',
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
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),{
                fieldLabel: '작업지시번호',
                xtype: 'uniTextfield',
                name: 'WKORD_NUM',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('WKORD_NUM', newValue);
                    }
                }
            },{
                fieldLabel: '품번',
                xtype: 'uniTextfield',
                name: 'SPEC',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                    	panelSearch.setValue('SPEC', newValue);
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

	Unilite.defineModel('s_pmr100ukrv_kdDetailModel', {
	    fields: [
	    	{name: 'CONTROL_STATUS'  	,text: '상태'			,type:'string' , comboType:"AU", comboCode:"P001"},
			{name: 'WKORD_NUM'       	,text: '작업지시번호'	,type:'string'},
			{name: 'ITEM_CODE'       	,text: '품목코드'		,type:'string'},
			{name: 'ITEM_NAME'       	,text: '품목명'		    ,type:'string'},
			{name: 'SPEC'            	,text: '규격'			,type:'string'},
			{name: 'STOCK_UNIT'      	,text: '단위'			,type:'string'},
			{name: 'WKORD_Q'         	,text: '작업지시량'		,type:'uniQty'},
			{name: 'PRODT_START_DATE'	,text: '착수예정일'		,type:'uniDate'},
			{name: 'PRODT_END_DATE'  	,text: '작업완료일'		,type:'uniDate'},
			{name: 'REMARK'          	,text: '비고'			,type:'string'},
			{name: 'PROJECT_NO'      	,text: '프로젝트번호'	,type:'string'},
//			{name: 'PJT_CODE'        	,text: '프로젝트번호'	,type:'string'},
			//Hidden: true
			{name: 'PROG_WORK_CODE'  	,text: '공정코드'		,type:'string'},
			{name: 'WORK_SHOP_CODE'  	,text: '작업장코드'		,type:'string'},
			{name: 'WORK_Q'      	 	,text: '작업량'		    ,type:'uniQty'},
			{name: 'PRODT_Q'         	,text: '생산량'		    ,type:'uniQty'},
			{name: 'WK_PLAN_NUM'	 	,text: '작업계획번호'	,type:'string'},
			{name: 'LINE_END_YN'  	 	,text: '최종공정유무'	,type:'string'},
			{name: 'WORK_END_YN'     	,text: '마감여부'		,type:'string'},
			{name: 'LINE_SEQ'      	 	,text: '공정순서'		,type:'string'},
			{name: 'PROG_UNIT'       	,text: '공정실적단위'	,type:'string'},
			{name: 'PROG_UNIT_Q'     	,text: '공정원단위량'	,type:'uniQty'},
			{name: 'OUT_METH'        	,text: '출고방법'		,type:'string'},
			{name: 'AB'					,text: ' '			    ,type:'string'},
			{name: 'LOT_NO'  			,text: 'LOT NO'		    ,type:'string'},
			{name: 'RESULT_YN'          ,text: '입고방법'		,type:'string'},
			{name: 'INSPEC_YN'  		,text: '입고방법'		,type:'string'},
			{name: 'WH_CODE'          	,text: '기준창고'		,type:'string'},
			{name: 'BASIS_P'      		,text: '재고금액'		,type:'string'},
			{name: 'PROD_WH_CODE'      		,text: '가공창고'		,type:'string'},
			{name: 'PROD_WH_CELL_CODE'      		,text: '가공창고CELL'		,type:'string'}
		]
	});

	var directMasterStore = Unilite.createStore('s_pmr100ukrv_kddirectMasterStore', {
		model: 's_pmr100ukrv_kdDetailModel',
		autoLoad: false,
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: false,		// 수정 모드 사용
			deletable: false,		// 삭제 가능 여부
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
         listeners:{
             load: function(store, records, successful, eOpts) {
                  masterGrid.getSelectionModel().select(masterSelectIdx);
                  if(directMasterStore.count() == 0) {
                      panelSearch.setAllFieldsReadOnly(false)
                      panelResult.setAllFieldsReadOnly(false)
                      masterGrid3.reset();
                      masterGrid4.reset();
                      masterGrid5.reset();
                      masterGrid6.reset();

                      directMasterStore3.clearData();
                      directMasterStore4.clearData();
                      directMasterStore5.clearData();
                      directMasterStore6.clearData();
                  }
             },
             remove: function(store, record, index, isMove, eOpts) {
                if(directMasterStore.count() == 0) {
                	panelSearch.setAllFieldsReadOnly(false)
                    panelResult.setAllFieldsReadOnly(false)
                }
             }
         }
	});

	/**
     * Master Grid1 정의(Grid Panel)
     * @type
     */

    var masterGrid = Unilite.createGrid('s_pmr100ukrv_kdGrid', {
    	layout: 'fit',
        region:'center',
        uniOpt: {
			expandLastColumn: false,
			onLoadSelectFirst: false,
			useRowNumberer: false

        },
    	store: directMasterStore,
        selModel: 'rowmodel',
        columns: [
			{dataIndex: 'CONTROL_STATUS'  	, width: 80 },
			{dataIndex: 'WKORD_NUM'        	, width: 120 },
			{dataIndex: 'ITEM_CODE'       	, width: 100},
			{dataIndex: 'ITEM_NAME'       	, width: 220},
			{dataIndex: 'SPEC'            	, width: 120},
			{dataIndex: 'STOCK_UNIT'       	, width: 80 },
			{dataIndex: 'WKORD_Q'         	, width: 100 },
			{dataIndex: 'PRODT_START_DATE'	, width: 100},
			{dataIndex: 'PRODT_END_DATE'  	, width: 100},
			{dataIndex: 'REMARK'          	, width: 160},
			{dataIndex: 'PROJECT_NO'      	, width: 133},
//			{dataIndex: 'PJT_CODE'        	, width: 133},

			{dataIndex: 'PROG_WORK_CODE' 	, width: 100 ,hidden:true},
			{dataIndex: 'WORK_SHOP_CODE' 	, width: 100 ,hidden:true},
			{dataIndex: 'WORK_Q'      		, width: 100 ,hidden:true},
			{dataIndex: 'PRODT_Q'        	, width: 100 ,hidden:true},
			{dataIndex: 'WK_PLAN_NUM'		, width: 100 ,hidden:true},
			{dataIndex: 'LINE_END_YN'  		, width: 100 ,hidden:true},
			{dataIndex: 'WORK_END_YN'    	, width: 100 ,hidden:true},
			{dataIndex: 'LINE_SEQ'      	, width: 100 ,hidden:true},
			{dataIndex: 'PROG_UNIT'      	, width: 100 ,hidden:true},
			{dataIndex: 'PROG_UNIT_Q'    	, width: 100 ,hidden:true},
			{dataIndex: 'OUT_METH'       	, width: 100 ,hidden:true},
			{dataIndex: 'AB'				, width: 100 ,hidden:true},
			{dataIndex: 'LOT_NO'  			, width: 133},
			{dataIndex: 'RESULT_YN'      	, width: 100 ,hidden:true},
			{dataIndex: 'INSPEC_YN'  		, width: 100 ,hidden:true},
			{dataIndex: 'WH_CODE'        	, width: 100 ,hidden:true},
			{dataIndex: 'BASIS_P'      		, width: 100 ,hidden:true},
			{dataIndex: 'PROD_WH_CODE'      		, width: 100 ,hidden:true},
			{dataIndex: 'PROD_WH_CELL_CODE'  		, width: 100 ,hidden:true}
		],
        listeners: {
        	beforeedit: function( editor, e, eOpts ) {
				if(e.record.phantom == false) {
        		 	return false;
        		} else {
					return false;
				}
			},
			selectionchange:function( model1, selected, eOpts ){
       			if(selected.length > 0)	{
	        		var record = selected[0];
	        		this.returnCell(record);
//	        		directMasterStore2.loadData({})
//					directMasterStore2.loadStoreRecords(record);
//	        		masterSelectedIdx =
	        		var activeTabId = tab.getActiveTab().getId();
	        		if(activeTabId == 's_pmr100ukrv_kdGrid3_1') {
    					directMasterStore3.loadData({})
    					directMasterStore3.loadStoreRecords(record);
	        		} else if(activeTabId == 's_pmr100ukrv_kdGrid5') {
    					directMasterStore5.loadData({})
    					directMasterStore5.loadStoreRecords(record);
	        		} else if(activeTabId == 's_pmr100ukrv_kdGrid6') {
    					directMasterStore6.loadData({})
    					directMasterStore6.loadStoreRecords(record);
	        		}
       			}
          	},
          	select: function(grid, selectRecord, index, rowIndex, eOpts ){
                masterSelectIdx = index;
//                detailSelectIdx = 0;
          	},
            cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
                UniAppManager.setToolbarButtons(['delete', 'newData'], false);
            },
            render: function(grid, eOpts) {
                var girdNm = grid.getItemId();
                grid.getEl().on('click', function(e, t, eOpt) {
                    UniAppManager.setToolbarButtons(['delete', 'newData'], false);
                    var prevGrid3 = Ext.getCmp('s_pmr100ukrv_kdGrid3');
                    var prevGrid4 = Ext.getCmp('s_pmr100ukrv_kdGrid4');
                    var prevGrid5 = Ext.getCmp('s_pmr100ukrv_kdGrid5');
                    var prevGrid6 = Ext.getCmp('s_pmr100ukrv_kdGrid6');
                    grid.changeFocusCls(prevGrid3);
                    grid.changeFocusCls(prevGrid4);
                    grid.changeFocusCls(prevGrid5);
                    grid.changeFocusCls(prevGrid6);
                });
            }
       	},
       	returnCell: function(record){
        	var wkordNum	    = record.get("WKORD_NUM");
        	var wkordQ		    = record.get("WKORD_Q");
        	var progWorkCode    = record.get("PROG_WORK_CODE");
        	var itemCode	    = record.get("ITEM_CODE");
        	var prodtNum	    = record.get("PRODT_NUM");
            var resultYn        = record.get("RESULT_YN");
            panelSearch.setValues({'WKORD_NUM_TEMP':wkordNum});
            panelSearch.setValues({'WKORD_Q':wkordQ});
            panelSearch.setValues({'PROG_WORK_CODE':progWorkCode});
            panelSearch.setValues({'ITEM_CODE1':itemCode});
            panelSearch.setValues({'PRODT_NUM':prodtNum});
            panelSearch.setValues({'RESULT_YN':resultYn});
        }/*,
		disabledLinkButtons: function(b) {
       		this.down('#refTool').menu.down('#requestBtn').setDisabled(b);
		}*/

    });


	/**
	 *  작업지시별등록 정의
	 * @type
	 */

//	Unilite.defineModel('s_pmr100ukrv_kdModel2', {  //Pmr100ns3v.htm
//	    fields: [
//	    	{name: 'PRODT_DATE'  	,text: '생산일'				,type:'uniDate'},
//			{name: 'PRODT_Q'     	,text: '생산량'				,type:'uniQty', allowBlank:false},
//			{name: 'GOOD_PRODT_Q'	,text: '양품량'				,type:'uniQty', allowBlank:false},
//			{name: 'BAD_PRODT_Q'  	,text: '불량량'				,type:'uniQty', allowBlank:false},
//			{name: 'MAN_HOUR'    	,text: '투입공수'				,type:'uniQty', allowBlank:false},
//			{name: 'WKORD_Q'     	,text: '작업지시량'				,type:'uniQty'},
//			{name: 'PRODT_SUM'   	,text: '생산누계'				,type:'uniQty'},
//			{name: 'JAN_Q'       	,text: '생산잔량'				,type:'uniQty'},
//			{name: 'IN_STOCK_Q'  	,text: '입고수량'				,type:'uniQty'},
//			{name: 'LOT_NO'      	,text: 'LOT NO'				,type:'string'},
//			{name: 'REMARK'      	,text: '비고'					,type:'string'},
//			{name: 'PROJECT_NO'  	,text: '관리번호'				,type:'string'},
////			{name: 'PJT_CODE'    	,text: '프로젝트번호'			,type:'string'},
//			{name: 'FR_SERIAL_NO'	,text: 'SERIAL NO(FR)'		,type:'string'},
//			{name: 'TO_SERIAL_NO'	,text: 'SERIAL NO(TO)'		,type:'string'},
//			//Hidden:true
//			{name: 'NEW_DATA'		,text: 'NEW레코드'			,type:'string'},
//			{name: 'PRODT_NUM'  	,text: '생산실적번호'			,type:'string'},
//			{name: 'PROG_WORK_CODE' ,text: '공정코드'				,type:'string'},
//			{name: 'UPDATE_DB_USER' ,text: '수정자'				,type:'string'},
//			{name: 'UPDATE_DB_TIME' ,text: '수정일'				,type:'uniDate'},
//			{name: 'COMP_CODE'      ,text: '회사코드'				,type:'string'},
//			{name: 'DIV_CODE' 		,text: '사업장'				,type:'string'},
//			{name: 'WORK_SHOP_CODE' ,text: '작업장'				,type:'string'},
//			{name: 'ITEM_CODE'		,text: '품목코드'				,type:'string'},
//			{name: 'CONTROL_STATUS' ,text: 'CONTROL_STATUS'		,type:'string'},
//			{name: 'GOOD_WH_CODE'   ,text: '양품입고창고'			,type:'string'},
//			{name: 'GOOD_PRSN' 		,text: '양품입고담당'			,type:'string'},
//			{name: 'BAD_WH_CODE' 	,text: '불량입고창고'			,type:'string'},
//			{name: 'BAD_PRSN'		,text: '불량입고담당'			,type:'string'}
//
//		]
//	});

	/**
	 *  공정별등록 정의 center
	 * @type
	 */

	Unilite.defineModel('s_pmr100ukrv_kdModel3', {  //Pmr100ns1v.htm
	    fields: [
            {name: 'FLAG'               ,text: 'FLAG'                   ,type:'string', defaultValue: 'N'},
	    	{name: 'SEQ'           	    ,text: '순번'					,type:'string'},
			{name: 'PROG_WORK_NAME'	    ,text: '공정명'				    ,type:'string'},
			{name: 'PROG_UNIT'     	    ,text: '단위'					,type:'string'},
			{name: 'PROG_WKORD_Q'       ,text: '작업지시량'				,type:'uniQty'},
			{name: 'SUM_Q'         	    ,text: '생산누계'				,type:'uniQty'},
			{name: 'PRODT_DATE'    	    ,text: '생산일'				    ,type:'uniDate', allowBlank:false},
			{name: 'PASS_Q'        	    ,text: '생산량'				    ,type:'uniQty', allowBlank:false},
			{name: 'ORIGIN_PASS_Q'      ,text: 'ORIGIN_PASS_Q'    ,type:'uniQty'},
			{name: 'GOOD_WORK_Q'   	    ,text: '양품량'				    ,type:'uniQty'},
			{name: 'BAD_WORK_Q'    	    ,text: '불량량'				    ,type:'uniQty'},
			{name: 'MAN_HOUR'      	    ,text: '투입공수'				,type:'uniQty', allowBlank:false, defaultValue: 1},
			{name: 'JAN_Q'         	    ,text: '생산잔량'				,type:'uniQty'},
			{name: 'LOT_NO'        	    ,text: 'LOT NO'				    ,type:'string'},
			{name: 'FR_SERIAL_NO'  	    ,text: 'SERIAL NO(FR)'		    ,type:'string'},
			{name: 'TO_SERIAL_NO'  	    ,text: 'SERIAL NO(TO)'		    ,type:'string'},
            {name: 'EQUIP_CODE'         ,text: '설비코드'               ,type:'string', allowBlank: true},
            {name: 'EQUIP_NAME'         ,text: '설비명'                 ,type:'string', allowBlank: true},
            {name: 'MOLD_CODE'          ,text: '금형코드'               ,type:'string', allowBlank: true},
            {name: 'MOLD_NAME'          ,text: '금형명'                 ,type:'string', allowBlank: true},
            {name: 'NOW_DEPR'           ,text: '타발수'                 ,type:'int'},
            {name: 'CAVITY'         ,text: 'CAVITY'                 ,type:'uniQty'},
			{name: 'REMARK'        	    ,text: '비고'					,type:'string'},
			//Hidden: true
			{name: 'DIV_CODE'      	     ,text: '사업장코드'			,type:'string'},
			{name: 'PROG_WORK_CODE'      ,text: '공정코드'				,type:'string'},
			{name: 'WORK_Q'        	     ,text: '작업량'				,type:'string'},
			{name: 'WKORD_NUM'  	     ,text: '작업지시번호'			,type:'string'},
			{name: 'LINE_END_YN'  	     ,text: '최종여부'				,type:'string'},
			{name: 'WK_PLAN_NUM'         ,text: '계획번호'				,type:'string'},
			{name: 'PRODT_NUM'  	     ,text: '생산실적번호'			,type:'string'},
			{name: 'CONTROL_STATUS'      ,text: '작업실적상태'			,type:'string'},
			{name: 'UPDATE_DB_USER'      ,text: '수정자'				,type:'string'},
			{name: 'UPDATE_DB_TIME'      ,text: '수정일'				,type:'uniDate'},
			{name: 'COMP_CODE'           ,text: '회사코드'				,type:'string'},
			{name: 'GOOD_WH_CODE'        ,text: '양품입고창고'			,type:'string'},
			{name: 'GOOD_WH_CELL_CODE'   ,text: '양품입고CELL창고'      ,type:'string'},
			{name: 'GOOD_PRSN' 		     ,text: '양품입고담당'			,type:'string'},
            {name: 'GOOD_Q'              ,text: '양품량'                ,type:'uniQty'},
			{name: 'BAD_WH_CODE' 	     ,text: '불량입고창고'			,type:'string'},
            {name: 'BAD_WH_CELL_CODE'    ,text: '불량입고CELL창고'      ,type:'string'},
			{name: 'BAD_PRSN'		     ,text: '불량입고담당'			,type:'string'},
            {name: 'BAD_Q'               ,text: '불량량'                ,type:'uniQty'},
            {name: 'PRODT_TYPE'          ,text: '작업일보등록유형'      ,type:'string'}

		]
	});

	/**
	 *  공정별등록 정의 east
	 * @type
	 */

	Unilite.defineModel('s_pmr100ukrv_kdModel4', {  //Pmr100ns1v.htm
	    fields: [
	    	{name: 'PRODT_NUM'   	,text: '생산번호'				,type:'string'},
			{name: 'PRODT_DATE'  	,text: '생산일'				    ,type:'uniDate'},
			{name: 'PASS_Q'      	,text: '생산량'				    ,type:'uniQty'},
			{name: 'GOOD_WORK_Q'  	,text: '양품량'				    ,type:'uniQty'},
			{name: 'BAD_WORK_Q'  	,text: '불량량'				    ,type:'uniQty'},
			{name: 'MAN_HOUR'    	,text: '투입공수'				,type:'uniQty'},
			{name: 'IN_STOCK_Q'  	,text: '입고수량'				,type:'uniQty'},
			{name: 'LOT_NO'      	,text: 'LOT NO'				    ,type:'string'},
			{name: 'FR_SERIAL_NO'	,text: 'SERIAL NO(FR)'		    ,type:'string'},
			{name: 'TO_SERIAL_NO'	,text: 'SERIAL NO(TO)'		    ,type:'string'},
			{name: 'EQUIP_CODE'     ,text: '설비코드'               ,type:'string'},
            {name: 'EQUIP_NAME'     ,text: '설비명'                 ,type:'string'},
            {name: 'MOLD_CODE'      ,text: '금형코드'               ,type:'string'},
            {name: 'MOLD_NAME'      ,text: '금형명'                 ,type:'string'},
            {name: 'NOW_DEPR'       ,text: '타발수'                 ,type:'int'},
			{name: 'REMARK'      	,text: '비고'					,type:'string'},
			//Hidden: true
			{name: 'DIV_CODE'  		,text: '사업장코드'				,type:'string'},
			{name: 'PROG_WKORD_Q'  	,text: ''					    ,type:'uniQty'},
			{name: 'CAL_PASS_Q'    	,text: ''					    ,type:'uniQty'},
			{name: 'PROG_WORK_CODE' ,text: '공정코드'				,type:'string'},
			{name: 'WKORD_NUM'      ,text: '작업지시번호'			,type:'string'},
			{name: 'WK_PLAN_NUM'	,text: '계획번호'				,type:'string'},
			{name: 'LINE_END_YN'  	,text: '최종여부'				,type:'string'},
			{name: 'COMP_CODE'      ,text: '회사코드'				,type:'string'}
		]
	});

	/**
	 *  불량내역등록
	 * @type
	 */

	Unilite.defineModel('s_pmr100ukrv_kdModel5', {
	    fields: [
	    	{name: 'WKORD_NUM'     		,text: '작업지시번호'		,type:'string', allowBlank:false},
			{name: 'PROG_WORK_NAME'		,text: '공정명'			    ,type:'string', allowBlank:false},
			{name: 'PRODT_DATE'    		,text: '발생일'			    ,type:'uniDate', allowBlank:false},
			{name: 'BAD_CODE'       	,text: '불량유형'			,type:'string', allowBlank:false, comboType: 'AU', comboCode: 'P003'},
			{name: 'BAD_Q'         		,text: '수량'				,type:'uniQty', allowBlank:false},
			{name: 'REMARK'				,text: '문제점 및 대책'		,type:'string'},
			//Hidden : true
			{name: 'DIV_CODE'     		,text: '사업장코드'			,type:'string'},
			{name: 'WORK_SHOP_CODE'		,text: '작업장코드'			,type:'string'},
			{name: 'PROG_WORK_CODE'    	,text: '공정코드'			,type:'string'},
			{name: 'ITEM_CODE'       	,text: '품목명'			    ,type:'string'},
			{name: 'UPDATE_DB_USER'     ,text: '수정자'			    ,type:'string'},
			{name: 'UPDATE_DB_TIME'		,text: '수정일'			    ,type:'uniDate'},
			{name: 'COMP_CODE'			,text: '회사코드'			,type:'string'}
		]
	});

	/**
	 * 특기사항등록
	 * @type
	 */

	Unilite.defineModel('s_pmr100ukrv_kdModel6', {
	    fields: [
	    	{name: 'WKORD_NUM'     	,text: '작업지시번호'		,type:'string'},
			{name: 'PROG_WORK_NAME'	,text: '공정명'			    ,type:'string', allowBlank:false},
			{name: 'PRODT_DATE'    	,text: '발생일'			    ,type:'uniDate', allowBlank:false},
			{name: 'CTL_CD1'        ,text: '특기사항 분류'		,type:'string', allowBlank:false, comboType: 'AU', comboCode: 'P002'},
			{name: 'TROUBLE_TIME'  	,text: '발생시간'			,type:'int'},
			{name: 'TROUBLE'       	,text: '요약'				,type:'string'},
			{name: 'TROUBLE_CS'    	,text: '원인'				,type:'string'},
			{name: 'ANSWER'			,text: '조치'				,type:'string'},
			{name: 'SEQ'           	,text: '순번'				,type:'int'},
			//Hidden : true
			{name: 'DIV_CODE'        ,text: '사업장코드'		,type:'string'},
			{name: 'WORK_SHOP_CODE'  ,text: '작업장코드'		,type:'string'},
			{name: 'PROG_WORK_CODE'  ,text: '공정코드'			,type:'string'},
			{name: 'UPDATE_DB_USER'  ,text: '수정자'			,type:'string'},
			{name: 'UPDATE_DB_TIME'	 ,text: '수정일'			,type:'uniDate'},
			{name: 'COMP_CODE'       ,text: '회사코드'			,type:'string'}
		]
	});




//	var directMasterStore2 = Unilite.createStore('s_pmr100ukrv_kdMasterStore2',{
//		model: 's_pmr100ukrv_kdModel2',
//		uniOpt: {
//            isMaster: true,			// 상위 버튼 연결
//            editable: true,			// 수정 모드 사용
//            deletable:true,			// 삭제 가능 여부
//	        useNavi : false			// prev | newxt 버튼 사용
//        },
//        autoLoad: false,
//        proxy: directProxy2,
//        loadStoreRecords : function()	{
//			var param= panelSearch.getValues();
//			console.log(param);
//			this.load({
//				params : param
//			});
//		},
//		saveStore : function(config)	{
//			var inValidRecs = this.getInvalidRecords();
//			var toCreate = this.getNewRecords();
//       		var toUpdate = this.getUpdatedRecords();
//       		var toDelete = this.getRemovedRecords();
//       		var list = [].concat(toUpdate, toCreate);
//       		console.log("inValidRecords : ", inValidRecs);
//			console.log("list:", list);
//
//			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
//
//			//1. 마스터 정보 파라미터 구성
//			var paramMaster= panelSearch.getValues();	//syncAll 수정
//			if(inValidRecs.length == 0) {
//				config = {
//					params: [paramMaster],
//					success: function(batch, option) {
//						//2.마스터 정보(Server 측 처리 시 가공)
//					/*	var master = batch.operations[0].getResultSet();
//						panelSearch.setValue("INOUT_NUM", master.INOUT_NUM);
//						*/
//						//3.기타 처리
//						panelSearch.getForm().wasDirty = false;
//						panelSearch.resetDirtyStatus();
//						console.log("set was dirty to false");
//						UniAppManager.setToolbarButtons('save', false);
//					}
//				};
//				this.syncAllDirect(config);
//			} else {
//                var grid = Ext.getCmp('s_pmr100ukrv_kdGrid2');
//                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
//			}
//		},
//		listeners:{
//			load: function(store, records, successful, eOpts) {
//				 var divCode	  = panelSearch.getValue('DIV_CODE');
//	        	 var workShopCode = panelSearch.getValue('WORK_SHOP_CODE');
//	        	 var itemCode	  = panelSearch.getValue('ITEM_CODE');
//	        	 var controlStatus= panelSearch.getValue('CONTROL_STATUS');
//	        	 for(var i=0; i<records.length; i++) {
//					records[i].DIV_CODE = divCode;
//				}
//				store.insert(0, records);
//			}
//		}
//	});

	var directMasterStore3 = Unilite.createStore('s_pmr100ukrv_kdMasterStore3',{
		model: 's_pmr100ukrv_kdModel3',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결
            editable: true,			// 수정 모드 사용
            deletable:true,			// 삭제 가능 여부
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy3,
        loadStoreRecords : function()	{
			var param= panelSearch.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
       		console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);

			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {

				var record1 = masterGrid.getSelectedRecord();
                var record2 = masterGrid3.getSelectedRecord();
                var fnCal = 0;
                var A = record2.get('PROG_WKORD_Q');
                var B = record2.get('SUM_Q');
                var C = record2.get('PASS_Q');
                var D = record2.get('LINE_END_YN');
                if(D == 'Y') {
                    fnCal = ((B + C) / A) * 100
                } else {
                    fnCal = 0;
                }
                if(fnCal > (100 * (BsaCodeInfo.glEndRate / 100))) {
                    alert('초과 생산 실적 범위를 벗어났습니다.');
                    return false;
                } else {
                    ///////////////////////////////////////////////////////
                }

                if((fnCal >= '100') || (fnCal < '100') && record1.get('CONTROL_STATUS') == '9') {
                    if(confirm('완료하시겠습니까?')) {
                        record2.set('CONTROL_STATUS', '9');
                    } else {
                        if(record1.get('CONTROL_STATUS') == '9') {
                            record2.set('CONTROL_STATUS', '3');
                        }
                        return false;
                    }
                }
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						/*var records = masterGrid3.getStore().getData();
						Ext.each(records, function(record,i) {
							masterGrid3.setOutouProdtSave(record);
						});*/
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
//						directMasterStore3.loadStoreRecords();
						directMasterStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('s_pmr100ukrv_kdGrid3');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
         listeners:{
             load: function(store, records, successful, eOpts) {
                  masterGrid3.getSelectionModel().select(detailSelectIdx);
             }
         }
	});

	var directMasterStore4 = Unilite.createStore('s_pmr100ukrv_kdMasterStore4',{
		model: 's_pmr100ukrv_kdModel4',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결
            editable: true,			// 수정 모드 사용
            deletable:true,			// 삭제 가능 여부
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
		proxy: directProxy4,
        loadStoreRecords : function()	{
			var param= panelSearch.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
        listeners:{
            load:function(store, records, successful, eOpts)    {
//                var record = masterGrid3.getSelectedRecord();
//                if(store.data.length == '0') {
//                    record.set('FLAG', 'N');
//                } else if(record.get('JAN_Q') != 0 && store.data.length != '0') {
//                    record.set('FLAG', 'U');
//                } else {
//                    record.set('FLAG', '');
//                }
            }
        },
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
       		console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);

			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
					/*	var master = batch.operations[0].getResultSet();
						panelSearch.setValue("INOUT_NUM", master.INOUT_NUM);
						*/
						//3.기타 처리
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
//						directMasterStore3.loadStoreRecords();
						directMasterStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('s_pmr100ukrv_kdGrid4');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	var directMasterStore5 = Unilite.createStore('s_pmr100ukrv_kdMasterStore5',{
		model: 's_pmr100ukrv_kdModel5',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결
            editable: true,			// 수정 모드 사용
            deletable:true,			// 삭제 가능 여부
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy5,
        loadStoreRecords : function(record)	{
			var param= panelSearch.getValues();
			param.WKORD_NUM = record.data.WKORD_NUM;
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
       		console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);

			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
					/*	var master = batch.operations[0].getResultSet();
						panelSearch.setValue("INOUT_NUM", master.INOUT_NUM);
						*/
						//3.기타 처리
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
//						UniAppManager.app.onQueryButtonDown();
					}
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('s_pmr100ukrv_kdGrid5');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	var directMasterStore6 = Unilite.createStore('s_pmr100ukrv_kdMasterStore6',{
		model: 's_pmr100ukrv_kdModel6',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결
            editable: true,			// 수정 모드 사용
            deletable:true,			// 삭제 가능 여부
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy6,
        loadStoreRecords : function()	{
			var param= panelSearch.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();
       		var toDelete = this.getRemovedRecords();
//       		var list = [].concat(toUpdate, toCreate);
       		console.log("inValidRecords : ", inValidRecs);
//			console.log("list:", list);

			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
					/*	var master = batch.operations[0].getResultSet();
						panelSearch.setValue("INOUT_NUM", master.INOUT_NUM);
						*/
						//3.기타 처리
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
//						UniAppManager.app.onQueryButtonDown();
					}
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('s_pmr100ukrv_kdGrid6');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

//	var masterGrid2 = Unilite.createGrid('s_pmr100ukrv_kdGrid2', {
//    	layout : 'fit',
//    	region:'center',
//    	title : '작업지시별등록',
//        store : directMasterStore2,
//        uniOpt:{	expandLastColumn: false,
//        			useRowNumberer: true,
//                    useMultipleSorting: true
//        },
//    	features: [
//    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
//    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: false}
//    	],
//        columns: [
//			{dataIndex: 'PRODT_DATE'   		, width: 80},
//			{dataIndex: 'PRODT_Q'      		, width: 93},
//			{dataIndex: 'GOOD_PRODT_Q'  	, width: 93},
//			{dataIndex: 'BAD_PRODT_Q'  		, width: 93},
//			{dataIndex: 'MAN_HOUR'     		, width: 93},
//			{dataIndex: 'WKORD_Q'      		, width: 93 , hidden: true},
//			{dataIndex: 'PRODT_SUM'    		, width: 93},
//			{dataIndex: 'JAN_Q'        		, width: 93},
//			{dataIndex: 'IN_STOCK_Q'    	, width: 93},
//			{dataIndex: 'LOT_NO'       		, width: 93},
//			{dataIndex: 'REMARK'       		, width: 133},
//			{dataIndex: 'PROJECT_NO'    	, width: 93},
////			{dataIndex: 'PJT_CODE'     		, width: 93},
//			{dataIndex: 'FR_SERIAL_NO' 		, width: 105},
//			{dataIndex: 'TO_SERIAL_NO'  	, width: 105},
//			{dataIndex: 'NEW_DATA'       	, width: 90 , hidden: true},
//			{dataIndex: 'PRODT_NUM'       	, width: 90 , hidden: true},
//			{dataIndex: 'PROG_WORK_CODE'    , width: 80 , hidden: true},
//			{dataIndex: 'UPDATE_DB_USER'    , width: 80 , hidden: true},
//			{dataIndex: 'UPDATE_DB_TIME' 	, width: 80 , hidden: true},
//			{dataIndex: 'COMP_CODE'  		, width: 80 , hidden: true},
//			{dataIndex: 'DIV_CODE'   		, width: 80, hidden: true},
//			{dataIndex: 'WORK_SHOP_CODE'   	, width: 80, hidden: true},
//			{dataIndex: 'ITEM_CODE'   		, width: 80, hidden: true},
//			{dataIndex: 'CONTROL_STATUS'	, width: 80, hidden: true},
//			{dataIndex: 'GOOD_WH_CODE'   	, width: 80, hidden: true},
//			{dataIndex: 'GOOD_PRSN' 		, width: 80, hidden: true},
//			{dataIndex: 'BAD_WH_CODE' 		, width: 80, hidden: true},
//			{dataIndex: 'BAD_PRSN'			, width: 80, hidden: true}
//		],
//		listeners :{
//			beforeedit  : function( editor, e, eOpts ) {
//				if(e.record.phantom == false) {
//        		 	if(UniUtils.indexOf(e.field))
//				   	{
//						return false;
//      				} else {
//      					return false;
//      				}
//        		} else {
//					if(UniUtils.indexOf(e.field, ['PRODT_Q', 'GOOD_PRODT_Q', 'BAD_PRODT_Q', 'MAN_HOUR', 'LOT_NO', 'REMARK', 'FR_SERIAL_NO', 'TO_SERIAL_NO']))
//					{
//						return true;
//					} else {
//						return false;
//					}
//				}
//        	},
//            select: function() {
//                var count = masterGrid2.getStore().getCount();
//                var record = masterGrid2.getSelectedRecord();
//                if(count > 0) {
//                    UniAppManager.setToolbarButtons(['newData', 'delete'], true);
//                } else {
//                    UniAppManager.setToolbarButtons(['newData', 'delete'], false);
//                }
//            },
//            cellclick: function() {
//                var count = masterGrid2.getStore().getCount();
//                var record = masterGrid2.getSelectedRecord();
//                if(count > 0) {
//                    UniAppManager.setToolbarButtons(['newData', 'delete'], true);
//                } else {
//                    UniAppManager.setToolbarButtons(['newData', 'delete'], false);
//                }
//            }
//        },
//        setOutouProdtSave: function(grdRecord) {
//        	grdRecord.set('GOOD_WH_CODE'  	, outouProdtSaveSearch.getValue('GOOD_WH_CODE'));
//        	grdRecord.set('GOOD_PRSN' 		, outouProdtSaveSearch.getValue('GOOD_PRSN'));
//        	grdRecord.set('BAD_WH_CODE' 	, outouProdtSaveSearch.getValue('BAD_WH_CODE'));
//        	grdRecord.set('BAD_PRSN'		, outouProdtSaveSearch.getValue('BAD_PRSN'));
//        }
//    });

    var masterGrid3 = Unilite.createGrid('s_pmr100ukrv_kdGrid3', {
    	split: true,
    	layout : 'fit',
    	region:'center',
    	title : '공정별등록',
        store : directMasterStore3,
        flex: 2,
//        id: 's_pmr100ukrv_kdGrid3',
        uniOpt:{	expandLastColumn: false,
        			useRowNumberer: true,
                    onLoadSelectFirst: true,
                    useMultipleSorting: true,
                    userToolbar: false
        },
    	features: [
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: false}
    	],
        columns: [
			//{dataIndex: 'SEQ'           		, width: 35},
//            {dataIndex: 'CAVITY'                  , width: 35, hidden: false},
            {dataIndex: 'FLAG'                  , width: 35, hidden: true},
            {dataIndex: 'PRODT_NUM'             , width: 100, hidden: true},
			{dataIndex: 'PROG_WORK_NAME'		, width: 130},
			{dataIndex: 'PROG_UNIT'      		, width: 100},
			{dataIndex: 'PROG_WKORD_Q'  		, width: 100},
			{dataIndex: 'SUM_Q'         		, width: 100},
			{dataIndex: 'PRODT_DATE'    		, width: 100},
			{dataIndex: 'PASS_Q'        		, width: 100},
			{dataIndex: 'ORIGIN_PASS_Q'         , width: 100, hidden: true},
			{dataIndex: 'GOOD_WORK_Q'   		, width: 100},
			{dataIndex: 'BAD_WORK_Q'     		, width: 100},
			{dataIndex: 'MAN_HOUR'      		, width: 80},
			{dataIndex: 'JAN_Q'         		, width: 100},
			{dataIndex: 'LOT_NO'         		, width: 120},
			{dataIndex: 'FR_SERIAL_NO'  		, width: 106, hidden: true},
			{dataIndex: 'TO_SERIAL_NO'  		, width: 106, hidden: true},
			{dataIndex: 'EQUIP_CODE'                  ,       width: 110, hidden: isEquipCode
                ,'editor' : Unilite.popup('EQUIP_CODE_G',{textFieldName:'EQUIP_CODE', textFieldWidth:100, DBtextFieldName: 'EQUIP_CODE',
			    			autoPopup: true,
                            listeners: {'onSelected': {
                                    fn: function(records, type) {
                                        grdRecord = masterGrid3.getSelectedRecord();

                                        grdRecord.set('EQUIP_CODE', record.EQUIP_CODE);
                                        grdRecord.set('EQUIP_NAME', record.EQUIP_NAME);
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    grdRecord = masterGrid3.getSelectedRecord();

                                    grdRecord.set('EQUIP_CODE', '');
                                    grdRecord.set('EQUIP_NAME', '');
                                },
                                applyextparam: function(popup){
                                    var param =  panelSearch.getValues();
                                    record = masterGrid.getSelectedRecord();
                                    popup.setExtParam({'DIV_CODE': param.DIV_CODE});
                                    popup.setExtParam({'ITEM_CODE': param.ITEM_CODE});
                                    popup.setExtParam({'PROG_WORK_CODE': record.get('PROG_WORK_CODE')});
                                }
                            }
                })
            },
            {dataIndex: 'EQUIP_NAME'                  ,       width: 200, hidden: isEquipCode
                ,'editor' : Unilite.popup('EQUIP_CODE_G',{textFieldName:'EQUIP_NAME', textFieldWidth:100, DBtextFieldName: 'EQUIP_NAME',
			    			autoPopup: true,
                            listeners: {'onSelected': {
                                    fn: function(records, type) {
                                        grdRecord = masterGrid3.getSelectedRecord();

                                        grdRecord.set('EQUIP_CODE', record.EQUIP_CODE);
                                        grdRecord.set('EQUIP_NAME', record.EQUIP_NAME);
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    grdRecord = masterGrid3.getSelectedRecord();

                                    grdRecord.set('EQUIP_CODE', '');
                                    grdRecord.set('EQUIP_NAME', '');
                                },
                                applyextparam: function(popup){
                                    var param =  panelSearch.getValues();
                                    record = masterGrid.getSelectedRecord();
                                    popup.setExtParam({'DIV_CODE': param.DIV_CODE});
                                    popup.setExtParam({'ITEM_CODE': param.ITEM_CODE});
                                    popup.setExtParam({'PROG_WORK_CODE': record.get('PROG_WORK_CODE')});
                                }
                            }
                })
            },
            {dataIndex: 'MOLD_CODE'                  ,       width: 110, hidden: isMoldCode
                ,'editor' : Unilite.popup('MOLD_CODE_G',{textFieldName:'MOLD_CODE', textFieldWidth:100, DBtextFieldName: 'MOLD_CODE',
			    			autoPopup: true,
                            listeners: {'onSelected': {
                                    fn: function(records, type) {
                                        grdRecord = masterGrid3.getSelectedRecord();
                                        grdRecord.set('MOLD_CODE', record.MOLD_CODE);
                                        grdRecord.set('MOLD_NAME', record.MOLD_NAME);
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    grdRecord = masterGrid3.getSelectedRecord();
                                    grdRecord.set('MOLD_CODE', '');
                                    grdRecord.set('MOLD_NAME', '');
                                },
                                applyextparam: function(popup){
                                    var param =  panelSearch.getValues();
                                    record = masterGrid.getSelectedRecord();
                                    popup.setExtParam({'DIV_CODE': param.DIV_CODE});
                                    popup.setExtParam({'ITEM_CODE': param.ITEM_CODE});
                                    popup.setExtParam({'PROG_WORK_CODE': record.get('PROG_WORK_CODE')});
                                }
                            }
                })
            },
            {dataIndex: 'MOLD_NAME'                  ,       width: 200, hidden: isMoldCode
                ,'editor' : Unilite.popup('MOLD_CODE_G',{textFieldName:'MOLD_NAME', textFieldWidth:100, DBtextFieldName: 'MOLD_NAME',
			    			autoPopup: true,
                            listeners: {'onSelected': {
                                    fn: function(records, type) {
                                        grdRecord = masterGrid3.getSelectedRecord();

                                        grdRecord.set('MOLD_CODE', record.MOLD_CODE);
                                        grdRecord.set('MOLD_NAME', record.MOLD_NAME);
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    grdRecord = masterGrid3.getSelectedRecord();

                                    grdRecord.set('MOLD_CODE', '');
                                    grdRecord.set('MOLD_NAME', '');
                                },
                                applyextparam: function(popup){
                                    var param =  panelSearch.getValues();
                                    record = masterGrid.getSelectedRecord();
                                    popup.setExtParam({'DIV_CODE': param.DIV_CODE});
                                    popup.setExtParam({'ITEM_CODE': param.ITEM_CODE});
                                    popup.setExtParam({'PROG_WORK_CODE': record.get('PROG_WORK_CODE')});
                                }
                            }
                })
            },
            {dataIndex: 'NOW_DEPR'              , width: 80},
			{dataIndex: 'REMARK'         		, width: 93},

			{dataIndex: 'DIV_CODE'        		, width: 100, hidden: true},
			{dataIndex: 'PROG_WORK_CODE'  		, width: 100, hidden: true},
			{dataIndex: 'WORK_Q'           		, width: 100, hidden: true},
			{dataIndex: 'WKORD_NUM'  	  		, width: 100, hidden: true},
			{dataIndex: 'LINE_END_YN'  	  		, width: 100, hidden: true},
			{dataIndex: 'WK_PLAN_NUM'      		, width: 100, hidden: true},
			{dataIndex: 'CONTROL_STATUS'  		, width: 100, hidden: true},
			{dataIndex: 'UPDATE_DB_USER'   		, width: 100, hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'  		, width: 100, hidden: true},
			{dataIndex: 'COMP_CODE'       		, width: 100, hidden: true},
			{dataIndex: 'GOOD_WH_CODE'   		, width: 100, hidden: true},
            {dataIndex: 'GOOD_WH_CELL_CODE'     , width: 100, hidden: true},
			{dataIndex: 'GOOD_PRSN' 			, width: 100, hidden: true},
            {dataIndex: 'GOOD_Q'                , width: 100, hidden: true},
			{dataIndex: 'BAD_WH_CODE' 			, width: 100, hidden: true},
            {dataIndex: 'BAD_WH_CELL_CODE'      , width: 100, hidden: true},
			{dataIndex: 'BAD_PRSN'				, width: 100, hidden: true},
            {dataIndex: 'BAD_Q'                 , width: 100, hidden: true},
            {dataIndex: 'PRODT_TYPE'            , width: 100, hidden: true}
		],
		listeners :{
			beforeedit  : function( editor, e, eOpts ) {
				var record = e.record;
				if(record.get("CONTROL_STATUS") == '2') {
            		if(UniUtils.indexOf(e.field, ['PRODT_DATE', 'PASS_Q', 'GOOD_WORK_Q', 'BAD_WORK_Q', 'MAN_HOUR', 'LOT_NO', 'FR_SERIAL_NO', 'TO_SERIAL_NO',
            		                              'EQUIP_CODE', 'MOLD_CODE', 'NOW_DEPR']))
                    {
                        return true;
                    } else {
                        return false;
                    }
				} else if(record.get("CONTROL_STATUS") == '9') {
					if(UniUtils.indexOf(e.field, ['LOT_NO', 'FR_SERIAL_NO', 'TO_SERIAL_NO', 'EQUIP_CODE', 'MOLD_CODE', 'NOW_DEPR']))
                    {
                        return true;
                    } else {
                        return false;
                    }
				} else {
					if(UniUtils.indexOf(e.field))
                    {
                        return false;
                    }
				}
        	},
			selectionchange:function( model1, selected, eOpts ){
       			if(selected.length > 0)	{
	        		var record = selected[0];
	        		this.returnCell(record);
	        		directMasterStore4.loadData({})
					directMasterStore4.loadStoreRecords(record);
       			}
          	},
            select: function(grid, selectRecord, index, rowIndex, eOpts ){
               detailSelectIdx = index;
            },
            cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
            	activeTabId2 = 's_pmr100ukrv_kdMasterStore3';
                UniAppManager.setToolbarButtons(['newData', 'delete'], false);
            },
            render: function(grid, eOpts) {
            	activeTabId2 = 's_pmr100ukrv_kdMasterStore3';
                var girdNm = grid.getItemId();
                grid.getEl().on('click', function(e, t, eOpt) {
                    UniAppManager.setToolbarButtons(['newData', 'delete'], false);
                    var prevGrid = Ext.getCmp('s_pmr100ukrv_kdGrid');
                    var prevGrid4 = Ext.getCmp('s_pmr100ukrv_kdGrid4');
                    var prevGrid5 = Ext.getCmp('s_pmr100ukrv_kdGrid5');
                    var prevGrid6 = Ext.getCmp('s_pmr100ukrv_kdGrid6');
                    grid.changeFocusCls(prevGrid);
                    grid.changeFocusCls(prevGrid4);
                    grid.changeFocusCls(prevGrid5);
                    grid.changeFocusCls(prevGrid6);
                });
            }
       	},
        setOutouProdtSave: function(record) {
//        	record.set('GOOD_WH_CODE'  	       , outouProdtSaveSearch.getValue('GOOD_WH_CODE'));
//        	record.set('GOOD_WH_CELL_CODE'     , outouProdtSaveSearch.getValue('GOOD_WH_CELL_CODE'));
//        	record.set('GOOD_PRSN' 		       , outouProdtSaveSearch.getValue('GOOD_PRSN'));
//        	record.set('BAD_WH_CODE' 	       , outouProdtSaveSearch.getValue('BAD_WH_CODE'));
//        	record.set('BAD_WH_CELL_CODE'      , outouProdtSaveSearch.getValue('BAD_WH_CELL_CODE'));
//        	record.set('BAD_PRSN'		       , outouProdtSaveSearch.getValue('BAD_PRSN'));
            record.set('PRODT_TYPE'            , '1');
        },
       	returnCell: function(record) {
        	var wkordNum	= record.get("WKORD_NUM");
        	var wkordQ		= record.get("WKORD_Q");
        	var progWorkCode = record.get("PROG_WORK_CODE");
            panelSearch.setValues({'WKORD_NUM_TEMP':wkordNum});
            panelSearch.setValues({'WKORD_Q':wkordQ});
            panelSearch.setValues({'PROG_WORK_CODE':progWorkCode});
        }
    });

    var masterGrid4 = Unilite.createGrid('s_pmr100ukrv_kdGrid4', {
    	split: true,
    	layout : 'fit',
    	region:'center',
    	title : '공정별등록내역',
    	flex: 1,
        store : directMasterStore4,
//        id: 's_pmr100ukrv_kdGrid4',
        uniOpt:{	expandLastColumn: false,
        			useRowNumberer: true,
                    onLoadSelectFirst: true,
                    useMultipleSorting: true,
                    userToolbar:false
        },
    	features: [
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: false}
    	],
        columns: [
			{dataIndex: 'PRODT_NUM'    		, width: 100},
			{dataIndex: 'PRODT_DATE'   		, width: 100},
			{dataIndex: 'PASS_Q'        	, width: 100},
			{dataIndex: 'GOOD_WORK_Q'  		, width: 100},
			{dataIndex: 'BAD_WORK_Q'   		, width: 100},
			{dataIndex: 'MAN_HOUR'     		, width: 80},
			{dataIndex: 'IN_STOCK_Q'   		, width: 100},
			{dataIndex: 'LOT_NO'       		, width: 120},
			{dataIndex: 'FR_SERIAL_NO'  	, width: 106, hidden: true},
			{dataIndex: 'TO_SERIAL_NO' 		, width: 106, hidden: true},
            {dataIndex: 'EQUIP_CODE'        , width: 100},
            {dataIndex: 'EQUIP_NAME'        , width: 200},
            {dataIndex: 'MOLD_CODE'         , width: 100},
            {dataIndex: 'MOLD_NAME'         , width: 200},
            {dataIndex: 'NOW_DEPR'          , width: 80},
			{dataIndex: 'REMARK'       		, width: 80},

			{dataIndex: 'DIV_CODE'  		, width: 66 , hidden: true},
			{dataIndex: 'PROG_WKORD_Q'   	, width: 100 , hidden: true},
			{dataIndex: 'CAL_PASS_Q'     	, width: 100 , hidden: true},
			{dataIndex: 'PROG_WORK_CODE' 	, width: 66 , hidden: true},
			{dataIndex: 'WKORD_NUM'      	, width: 120 , hidden: true},
			{dataIndex: 'WK_PLAN_NUM'	 	, width: 120 , hidden: true},
			{dataIndex: 'LINE_END_YN'  	  	, width: 106, hidden: true},
			{dataIndex: 'COMP_CODE'      	, width: 106, hidden: true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
                return false
            },
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				activeTabId2 = 's_pmr100ukrv_kdMasterStore4';
				var record = masterGrid.getSelectedRecord();
				var count = masterGrid.getStore().getCount();
                if(count > 0 && !Ext.isEmpty(record)) {
                    if(record.get("CONTROL_STATUS") == '8') {
                        UniAppManager.setToolbarButtons(['delete'], false);
                    } else {
                    	UniAppManager.setToolbarButtons(['delete'], true);
                    }
                } else {

                }
            },
            render: function(grid, eOpts) {
            	activeTabId2 = 's_pmr100ukrv_kdMasterStore4';
                var girdNm = grid.getItemId();
                grid.getEl().on('click', function(e, t, eOpt) {
                    var record = masterGrid.getSelectedRecord();
                    if(!Ext.isEmpty(record) && record.get("CONTROL_STATUS") == '8') {
                        UniAppManager.setToolbarButtons(['delete'], false);
                    } else {
                        UniAppManager.setToolbarButtons(['delete'], true);
                    }
                    var prevGrid = Ext.getCmp('s_pmr100ukrv_kdGrid');
                    var prevGrid3 = Ext.getCmp('s_pmr100ukrv_kdGrid3');
                    var prevGrid5 = Ext.getCmp('s_pmr100ukrv_kdGrid5');
                    var prevGrid6 = Ext.getCmp('s_pmr100ukrv_kdGrid6');

                    grid.changeFocusCls(prevGrid);
                    grid.changeFocusCls(prevGrid3);
                    grid.changeFocusCls(prevGrid5);
                    grid.changeFocusCls(prevGrid6);
                });
            }
		}
    });

    var masterGrid5 = Unilite.createGrid('s_pmr100ukrv_kdGrid5', {
    	layout : 'fit',
    	region:'center',
    	title : '불량내역등록',
        store : directMasterStore5,
        id: 's_pmr100ukrv_kdGrid5',
        uniOpt:{	expandLastColumn: false,
        			useRowNumberer: true,
                    onLoadSelectFirst: true,
                    useMultipleSorting: true
        },
    	features: [
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: false}
    	],
        columns: [
			{dataIndex: 'WKORD_NUM'     	, width: 120},
            {dataIndex: 'PROG_WORK_CODE'    , width: 100, hidden: true},
			{dataIndex: 'PROG_WORK_NAME'	, width: 166,
              'editor': Unilite.popup('PROG_WORK_CODE_G',{
                    textFieldName : 'PROG_WORK_NAME',
                    DBtextFieldName : 'PROG_WORK_NAME',
			    	autoPopup: true,
                    listeners: { 'onSelected': {
                        fn: function(records, type  ){
                            var grdRecord = masterGrid5.uniOpt.currentRecord;
                            grdRecord.set('PROG_WORK_CODE',records[0]['PROG_WORK_CODE']);
                            grdRecord.set('PROG_WORK_NAME',records[0]['PROG_WORK_NAME']);
                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid5.uniOpt.currentRecord;
                            grdRecord.set('PROG_WORK_CODE','');
                            grdRecord.set('PROG_WORK_NAME','');
                      },
                      applyextparam: function(popup){
                            var param =  panelSearch.getValues();
                            record = masterGrid.getSelectedRecord();
                            popup.setExtParam({'DIV_CODE': param.DIV_CODE});
                            popup.setExtParam({'ITEM_CODE': record.get('ITEM_CODE')});
                            popup.setExtParam({'WORK_SHOP_CODE': record.get('WORK_SHOP_CODE')});
                      }
                    }
                })
            },
			{dataIndex: 'PRODT_DATE'    	, width: 100},
			{dataIndex: 'BAD_CODE'       	, width: 106},
			{dataIndex: 'BAD_Q'         	, width: 100},
			{dataIndex: 'REMARK'			, width: 800},

			{dataIndex: 'DIV_CODE'     		, width: 0 , hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 0 , hidden: true},
			{dataIndex: 'PROG_WORK_CODE' 	, width: 0 , hidden: true},
			{dataIndex: 'ITEM_CODE'       	, width: 0 , hidden: true},
			{dataIndex: 'UPDATE_DB_USER' 	, width: 0 , hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'	, width: 0 , hidden: true},
			{dataIndex: 'COMP_CODE'		    , width: 0 , hidden: true}
		],
		listeners :{
			beforeedit  : function( editor, e, eOpts ) {
        		if(!e.record.phantom){
        			if (UniUtils.indexOf(e.field,
        									['PROG_WORK_CODE','PROG_WORK_NAME','PRODT_DATE','BAD_CODE']))
        				return false
        		}if(!e.record.phantom||e.record.phantom){
        			if (UniUtils.indexOf(e.field,
        									['WKORD_NUM']))
        				return false
        		}
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
                UniAppManager.setToolbarButtons(['delete', 'newData'], true);
            },
            render: function(grid, eOpts) {
                var girdNm = grid.getItemId();
                grid.getEl().on('click', function(e, t, eOpt) {
                	var count = masterGrid.getStore().getCount();
                	if(count == 0) {
                        UniAppManager.setToolbarButtons(['delete', 'newData'], false);
                	} else {
                		UniAppManager.setToolbarButtons(['delete', 'newData'], true);
                	}
                	var prevGrid = Ext.getCmp('s_pmr100ukrv_kdGrid');
                	var prevGrid3 = Ext.getCmp('s_pmr100ukrv_kdGrid3');
                	var prevGrid4 = Ext.getCmp('s_pmr100ukrv_kdGrid4');
                	var prevGrid6 = Ext.getCmp('s_pmr100ukrv_kdGrid6');
                	grid.changeFocusCls(prevGrid);
                	grid.changeFocusCls(prevGrid3);
                	grid.changeFocusCls(prevGrid4);
                	grid.changeFocusCls(prevGrid6);

                });
            }
		}
    });

    var masterGrid6 = Unilite.createGrid('s_pmr100ukrv_kdGrid6', {
    	layout : 'fit',
    	region:'center',
    	title : '특기사항등록',
        store : directMasterStore6,
        id: 's_pmr100ukrv_kdGrid6',
        uniOpt:{	expandLastColumn: false,
        			useRowNumberer: true,
                    onLoadSelectFirst: true,
                    useMultipleSorting: true
        },
    	features: [
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: false}
    	],
        columns: [
			{dataIndex: 'WKORD_NUM'     		, width: 120 , hidden: true},
			{dataIndex: 'PROG_WORK_CODE' , width: 100, hidden: true},
			{dataIndex: 'PROG_WORK_NAME' , width: 166,
              'editor': Unilite.popup('PROG_WORK_CODE_G',{
                    textFieldName : 'PROG_WORK_NAME',
                    DBtextFieldName : 'PROG_WORK_NAME',
		    		autoPopup: true,
                    listeners: { 'onSelected': {
                        fn: function(records, type  ){
                            var grdRecord = masterGrid5.uniOpt.currentRecord;
                            grdRecord.set('PROG_WORK_CODE',records[0]['PROG_WORK_CODE']);
                            grdRecord.set('PROG_WORK_NAME',records[0]['PROG_WORK_NAME']);
                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid5.uniOpt.currentRecord;
                            grdRecord.set('PROG_WORK_CODE','');
                            grdRecord.set('PROG_WORK_NAME','');
                      },
                      applyextparam: function(popup){
                            var param =  panelSearch.getValues();
                            record = masterGrid.getSelectedRecord();
                            popup.setExtParam({'DIV_CODE': param.DIV_CODE});
                            popup.setExtParam({'ITEM_CODE': record.get('ITEM_CODE')});
                            popup.setExtParam({'WORK_SHOP_CODE': record.get('WORK_SHOP_CODE')});
                      }
                    }
                })
            },
			{dataIndex: 'PRODT_DATE'     		, width: 100},
			{dataIndex: 'CTL_CD1'       		, width: 106},
			{dataIndex: 'TROUBLE_TIME'  		, width: 100},
			{dataIndex: 'TROUBLE'       		, width: 166},
			{dataIndex: 'TROUBLE_CS'    		, width: 166},
			{dataIndex: 'ANSWER'				, width: 800},
			{dataIndex: 'SEQ'           		, width: 50, hidden: true},
			//Hidden : true
			{dataIndex: 'DIV_CODE'  			, width: 0 , hidden:true},
			{dataIndex: 'WORK_SHOP_CODE'       	, width: 0 , hidden:true},
			{dataIndex: 'PROG_WORK_CODE'    	, width: 0 , hidden:true},
			{dataIndex: 'UPDATE_DB_USER'		, width: 0 , hidden:true},
			{dataIndex: 'UPDATE_DB_TIME'  		, width: 0 , hidden:true},
			{dataIndex: 'COMP_CODE'       		, width: 0 , hidden:true}
		],
		listeners :{
			beforeedit  : function( editor, e, eOpts ) {
        		if(!e.record.phantom){
        			if (UniUtils.indexOf(e.field,
        									['PROG_WORK_CODE','PROG_WORK_NAME','PRODT_DATE','CTL_CD1']))
        				return false
        		}if(!e.record.phantom||e.record.phantom){
        			if (UniUtils.indexOf(e.field,
        									['WKORD_NUM']))
        				return false
        		}
			},
            cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
                UniAppManager.setToolbarButtons(['delete', 'newData'], true);
            },
            render: function(grid, eOpts) {
                var girdNm = grid.getItemId();
                grid.getEl().on('click', function(e, t, eOpt) {
                    var count = masterGrid.getStore().getCount();
                    if(count == 0) {
                        UniAppManager.setToolbarButtons(['delete', 'newData'], false);
                    } else {
                        UniAppManager.setToolbarButtons(['delete', 'newData'], true);
                    }
                    var prevGrid = Ext.getCmp('s_pmr100ukrv_kdGrid');
                    var prevGrid3 = Ext.getCmp('s_pmr100ukrv_kdGrid3');
                    var prevGrid4 = Ext.getCmp('s_pmr100ukrv_kdGrid4');
                    var prevGrid5 = Ext.getCmp('s_pmr100ukrv_kdGrid5');
   					grid.changeFocusCls(prevGrid);
   					grid.changeFocusCls(prevGrid3);
   					grid.changeFocusCls(prevGrid4);
   					grid.changeFocusCls(prevGrid5);
                });
            }
		}
    });

    var tab = Unilite.createTabPanel('tabPanel',{
    	split: true,
    	border : false,
    	region:'south',
	    items: [
	         {	layout: {type: 'hbox', align: 'stretch'},
	          	title : '공정별등록' ,
                id: 's_pmr100ukrv_kdGrid3_1',
	          	items: [
	          		masterGrid3,
	        		masterGrid4
	        	]
	         },
	         masterGrid5,
	         masterGrid6
	    ]
    });

    var outouProdtSaveSearch = Unilite.createSearchForm('outouProdtSaveForm', {		// 생산실적 자동입고
    	layout: {type : 'uniTable', columns : 2},
        items:[
        	{
				xtype: 'container',
				html: '※ 양품입고',
				colspan: 2,
				style: {
					color: 'blue'
				},
				margin: '20 5 5 5'
			},{
				fieldLabel: '입고창고',
				name:'GOOD_WH_CODE',
//		    	allowBlank: false,
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
                child: 'GOOD_WH_CELL_CODE',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
//                        cbStore.loadStoreRecords(newValue);
                    }
                }
			},{
                fieldLabel: '입고CELL창고',
                name:'GOOD_WH_CELL_CODE',
//                allowBlank: gsSumTypeCell,
                store: Ext.data.StoreManager.lookup('whCellList'),
                xtype: 'uniCombobox',
                hidden: gsSumTypeCell
            },{
				fieldLabel: '입고담당',
				name:'GOOD_PRSN',
//		    	allowBlank: false,
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B024'
			},{
				fieldLabel: '양품수량',
				name:'GOOD_Q',
				xtype: 'uniTextfield',
				readOnly: true
			},{
				xtype: 'container',
				html: '※ 불량입고',
				colspan: 2,
				style: {
					color: 'blue'
				},
                margin: '20 5 5 5'
			},{
				fieldLabel: '입고창고',
				name:'BAD_WH_CODE',
//		    	allowBlank: false,
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
                child: 'BAD_WH_CELL_CODE',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
//                        cbStore2.loadStoreRecords(newValue);
                    }
                }
			},{
                fieldLabel: '입고CELL창고',
                name:'BAD_WH_CELL_CODE',
                store: Ext.data.StoreManager.lookup('whCellList'),
//                allowBlank: gsSumTypeCell,
                xtype: 'uniCombobox',
//                store: cbStore2,
                hidden: gsSumTypeCell
            },{
				fieldLabel: '입고담당',
				name:'BAD_PRSN',
//		    	allowBlank: false,
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B024'
			},{
				fieldLabel: '불량수량',
				name:'BAD_Q',
				xtype: 'uniTextfield',
                readOnly: true
			},{
                xtype: 'container',
                html: '',
                colspan: 2,
                style: {
                    color: 'blue'
                },
                margin: '20 5 5 5'
            }
        ],
        beforeshow: function( panel, eOpts )    {
            var record = masterGrid3.getSelectedRecord();
            outouProdtSaveSearch.setValue('GOOD_WH_CODE'         , record.data.GOOD_WH_CODE);
            outouProdtSaveSearch.setValue('GOOD_WH_CELL_CODE'    , record.data.GOOD_WH_CELL_CODE);
            outouProdtSaveSearch.setValue('GOOD_PRSN'            , record.data.GOOD_PRSN);
            outouProdtSaveSearch.setValue('GOOD_Q'               , record.data.GOOD_Q);
            outouProdtSaveSearch.setValue('BAD_WH_CODE'          , record.data.BAD_WH_CODE);
            outouProdtSaveSearch.setValue('BAD_WH_CELL_CODE'     , record.data.BAD_WH_CELL_CODE);
            outouProdtSaveSearch.setValue('BAD_PRSN'             , record.data.BAD_PRSN);
            outouProdtSaveSearch.setValue('BAD_Q'                , record.data.BAD_Q);
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

    function openoutouProdtSave() { 	// 생산실적 자동입고
    	if(!outouProdtSave) {
            var record = masterGrid3.getSelectedRecord();
            outouProdtSaveSearch.setValue('GOOD_Q'               ,record.get('GOOD_WORK_Q'));
            outouProdtSaveSearch.setValue('BAD_Q'                ,record.get('BAD_WORK_Q'));
            outouProdtSaveSearch.setValue('GOOD_WH_CODE'         ,record.get('GOOD_WH_CODE'));
            outouProdtSaveSearch.setValue('GOOD_WH_CELL_CODE'    ,record.get('GOOD_WH_CELL_CODE'));
            outouProdtSaveSearch.setValue('GOOD_PRSN'            ,record.get('GOOD_PRSN'));
            outouProdtSaveSearch.setValue('BAD_WH_CODE'          ,record.get('BAD_WH_CODE'));
            outouProdtSaveSearch.setValue('BAD_WH_CELL_CODE'     ,record.get('BAD_WH_CELL_CODE'));
            outouProdtSaveSearch.setValue('BAD_PRSN'             ,record.get('BAD_PRSN'));

			outouProdtSave = Ext.create('widget.uniDetailWindow', {
                title: '생산실적 자동입고',
                width: 580,
                height: 280,
                layout: {type:'vbox', align:'stretch'},
                items: [outouProdtSaveSearch],
                tbar:  ['->',
					{itemId : 'saveBtn',
					text: '확인',
					handler: function() {
		    			var activeTabId = tab.getActiveTab().getId();
//						if(activeTabId == 's_pmr100ukrv_kdGrid2') {	// 작업지시별 등록
//							if(outouProdtSaveSearch.setAllFieldsReadOnly(true) == false){
//								return false;
//							} else {
//								var records = masterGrid2.getStore().getNewRecords();
//								Ext.each(records, function(record,i) {
//									masterGrid2.setOutouProdtSave(record);
//								});
//								outouProdtSave.hide();
//								directMasterStore2.saveStore();
//							}
//						}
//						if(activeTabId2 == 's_pmr100ukrv_kdGrid3') {	// 공정별 등록
//							if(outouProdtSaveSearch.setAllFieldsReadOnly(true) == false){
//								return false;
//							} else {
//								var records = masterGrid3.getStore().getData();
//								Ext.each(records, function(record,i) {
//									masterGrid3.setOutouProdtSave(record);
//								});
//								outouProdtSave.hide();
//								directMasterStore3.saveStore();
//							}
//						}
		    			if(!Ext.isEmpty(outouProdtSaveSearch.getValue('GOOD_Q'))){
		    			   if(Ext.isEmpty(outouProdtSaveSearch.getValue('GOOD_WH_CODE'))){
		    			       alert('입고창고는 필수 입니다.');
		    			       return false;
		    			   }
		    			   if(Ext.isEmpty(outouProdtSaveSearch.getValue('GOOD_WH_CELL_CODE'))){
                               alert('입고CELL창고는 필수 입니다.');
                               return false;
                           }
		    			   if(Ext.isEmpty(outouProdtSaveSearch.getValue('GOOD_PRSN'))){
                               alert('입고담당자는 필수 입니다.');
                               return false;
                           }
		    			}

		    			if(!Ext.isEmpty(outouProdtSaveSearch.getValue('BAD_Q'))){
                           if(Ext.isEmpty(outouProdtSaveSearch.getValue('BAD_WH_CODE'))){
                               alert('입고창고는 필수 입니다.');
                               return false;
                           }
                           if(Ext.isEmpty(outouProdtSaveSearch.getValue('BAD_WH_CELL_CODE'))){
                               alert('입고CELL창고는 필수 입니다.');
                               return false;
                           }
                           if(Ext.isEmpty(outouProdtSaveSearch.getValue('BAD_PRSN'))){
                               alert('입고담당자는 필수 입니다.');
                               return false;
                           }
                        }
//		    			var records = directMasterStore3.data.items;
		    			var record = masterGrid3.getSelectedRecord();

		    			var goodWhCode      = outouProdtSaveSearch.getValue('GOOD_WH_CODE');
                        var goodWhCellCode  = outouProdtSaveSearch.getValue('GOOD_WH_CELL_CODE');
                        var goodPrsn        = outouProdtSaveSearch.getValue('GOOD_PRSN');
                        var goodQ           = outouProdtSaveSearch.getValue('GOOD_Q');
                        var badWhCode       = outouProdtSaveSearch.getValue('BAD_WH_CODE');
                        var badWhCellCode   = outouProdtSaveSearch.getValue('BAD_WH_CELL_CODE');
                        var badPrsn         = outouProdtSaveSearch.getValue('BAD_PRSN');
                        var badQ            = outouProdtSaveSearch.getValue('BAD_Q');

                        record.set('GOOD_WH_CODE'       , goodWhCode);
                        record.set('GOOD_WH_CELL_CODE'  , goodWhCellCode);
                        record.set('GOOD_PRSN'          , goodPrsn);
                        record.set('GOOD_Q'             , goodQ);
                        record.set('BAD_WH_CODE'        , badWhCode);
                        record.set('BAD_WH_CELL_CODE'   , badWhCellCode);
                        record.set('BAD_PRSN'           , badPrsn);
                        record.set('BAD_Q'              , badQ);

//                        Ext.each(records, function(record, i) {
//                            record.set('GOOD_WH_CODE'       , goodWhCode);
//                            record.set('GOOD_WH_CELL_CODE'  , goodWhCellCode);
//                            record.set('GOOD_PRSN'          , goodPrsn);
//                            record.set('GOOD_Q'             , goodQ);
//                            record.set('BAD_WH_CODE'        , badWhCode);
//                            record.set('BAD_WH_CELL_CODE'   , badWhCellCode);
//                            record.set('BAD_PRSN'           , badPrsn);
//                            record.set('BAD_Q'              , badQ);
//                        });


//                        Ext.each(records, function(record, i) {
//                            masterGrid3.setOutouProdtSave(record);
//                        });
                        if(outouProdtSaveSearch.setAllFieldsReadOnly(true) == false){
                            return false;
                        } else {
                            outouProdtSave.hide();
                            directMasterStore3.saveStore();
                        }
		    		},
					disabled: false
					}, {
						itemId : 'CloseBtn',
						text: '닫기',
						handler: function() {
							outouProdtSave.hide();
						}
					}
				],
				listeners: {beforehide: function(me, eOpt)
					{
						outouProdtSaveSearch.clearForm();
                	},
                	beforeshow: function( panel, eOpts )	{
                		var activeTabId = tab.getActiveTab().getId();
//						if(activeTabId == 's_pmr100ukrv_kdGrid2') {	// 작업지시별 등록
//	                		var record = masterGrid2.getSelectedRecord();
//	                		outouProdtSaveSearch.setValue('GOOD_Q',record.get('GOOD_PRODT_Q'));
//	                		outouProdtSaveSearch.setValue('BAD_Q',record.get('BAD_PRODT_Q'));
//						}
						if(activeTabId2 == 's_pmr100ukrv_kdMasterStore3') {	// 공정 등록
	                		var record = masterGrid3.getSelectedRecord();
	                		outouProdtSaveSearch.setValue('GOOD_Q'               ,record.get('GOOD_WORK_Q'));
	                		outouProdtSaveSearch.setValue('BAD_Q'                ,record.get('BAD_WORK_Q'));
                            outouProdtSaveSearch.setValue('GOOD_WH_CODE'         ,record.get('GOOD_WH_CODE'));
                            outouProdtSaveSearch.setValue('GOOD_WH_CELL_CODE'    ,record.get('GOOD_WH_CELL_CODE'));
                            outouProdtSaveSearch.setValue('GOOD_PRSN'            ,record.get('GOOD_PRSN'));
                            outouProdtSaveSearch.setValue('BAD_WH_CODE'          ,record.get('BAD_WH_CODE'));
                            outouProdtSaveSearch.setValue('BAD_WH_CELL_CODE'     ,record.get('BAD_WH_CELL_CODE'));
                            outouProdtSaveSearch.setValue('BAD_PRSN'             ,record.get('BAD_PRSN'));
						}
                	}
				}
			})
    	}
    	outouProdtSave.center();
		outouProdtSave.show();
    }

    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
    		border : false,
			items:[
				masterGrid, tab, panelResult
			]
		},
			panelSearch
		],
		id: 's_pmr100ukrv_kdApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
            UniAppManager.setToolbarButtons(['newData'], false);
//			masterGrid.disabledLinkButtons(false);
			this.setDefault();
		},
		onQueryButtonDown: function() {
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
            if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
            masterSelectIdx = 0;
            directMasterStore.loadStoreRecords();
			var count = masterGrid.getStore().getCount();
            var record = masterGrid.getSelectedRecord();
            if(count > 0) {
                UniAppManager.setToolbarButtons(['newData', 'delete'], true);
            } else {
                UniAppManager.setToolbarButtons(['newData', 'delete'], false);
            }
		},
		onNewDataButtonDown: function()	{
			//if(!this.checkForNewDetail()) return false;
			var activeTabId = tab.getActiveTab().getId();
			/*if(activeTabId == 's_pmr100ukrv_kdGrid2') {
				var record = masterGrid.getSelectedRecord();
				 var wkordNum = panelSearch.getValue('WKORD_NUM');
				 //var prodtNum = panelSearch.getValue('PRODT_NUM');
				 var seq = directMasterStore.max('PRODT_Q');
            	 if(!seq) seq = 1;
            	 else  seq += 1;
            	 var prodtDate    = panelSearch.getValue('PRODT_START_DATE_TO');
            	 var progWorkCode = record.get('PROG_WORK_CODE');
            	 var wkordQ       = record.get('WKORD_Q');
            	 var prodtQ       = 0; //생산량
            	 var goodProdtQ   = 0; //양품량
            	 var badProdtQ    = 0; //불량량
            	 var manHour      = 0; //투입공수
            	 var lotNo        = record.get('LOT_NO');
            	 var remark       = record.get('REMARK');
            	 var projectNo    = record.get('PROJECT_NO');
//            	 var pjtCode      = record.get('PJT_CODE');
            	 var divCode	  = panelSearch.getValue('DIV_CODE');
            	 var workShopCode = panelSearch.getValue('WORK_SHOP_CODE');
            	 var itemCode	  = panelSearch.getValue('ITEM_CODE1');
            	 var controlStatus= Ext.getCmp('rdoSelect').getChecked()[0].inputValue
            	 var newData	  = 'N';

				 var r = {
					WKORD_NUM		 :wkordNum,
					//PRODT_NUM		 :prodtNum,
					PRODT_Q			 :seq,
					PRODT_DATE       :prodtDate,
					PROG_WORK_CODE   :progWorkCode,
					WKORD_Q          :wkordQ,
					PRODT_Q          :prodtQ,
					GOOD_PRODT_Q     :goodProdtQ,
					BAD_PRODT_Q      :badProdtQ,
					MAN_HOUR         :manHour,
					LOT_NO           :lotNo,
					REMARK           :remark,
					PROJECT_NO       :projectNo,
//					PJT_CODE         :pjtCode,
					DIV_CODE		 :divCode,
					WORK_SHOP_CODE	 :workShopCode,
					ITEM_CODE		 :itemCode,
					CONTROL_STATUS	 :controlStatus,
					NEW_DATA		 :newData
					//COMP_CODE        :compCode
		        };
		        masterGrid2.createRow(r, 'PRODT_Q', masterGrid2.getStore().getCount() - 1);
			} else*/ if(activeTabId == 's_pmr100ukrv_kdGrid5') {
				 var record = masterGrid.getSelectedRecord();
            	 var divCode    	= panelSearch.getValue('DIV_CODE');
            	 var prodtDate 		= UniDate.get('today');
            	 var workShopcode   = record.get('WORK_SHOP_CODE');
            	 var wkordNum       = record.get('WKORD_NUM');
            	 var itemCode   	= record.get('ITEM_CODE');
            	 var progWorkName   = '';
            	 var badCode   		= '';
            	 var badQ   		= 0;
            	 var remark   		= '';

            	 var r = {
					DIV_CODE				: divCode,
					PRODT_DATE				: prodtDate,
					WORK_SHOP_CODE       	: workShopcode,
					WKORD_NUM   			: wkordNum,
					ITEM_CODE     			: itemCode,
					PROG_WORK_NAME			: progWorkName,
					BAD_CODE				: badCode,
					BAD_Q					: badQ,
					REMARK					: remark
					//COMP_CODE        		:compCode
		        };
		        masterGrid5.createRow(r);
			} else if(activeTabId == 's_pmr100ukrv_kdGrid6') {
				var record = masterGrid.getSelectedRecord();
				 var divCode    	= panelSearch.getValue('DIV_CODE');
            	 var prodtDate 		= UniDate.get('today');
            	 var workShopcode   = record.get('WORK_SHOP_CODE');
            	 var wkordNum       = record.get('WKORD_NUM');
            	 var itemCode   	= record.get('ITEM_CODE');
            	 var progWorkName	= '';
            	 var ctlCd1			= '';
            	 var troubleTime	= '';
            	 var trouble		= '';
            	 var troubleCs		= '';
            	 var answer			= '';
            	 var seq = directMasterStore6.max('SEQ');
                    if(!seq) seq = 1;
                    else  seq += 1;

            	 var r = {
					DIV_CODE				: divCode,
					PRODT_DATE				: prodtDate,
					WORK_SHOP_CODE       	: workShopcode,
					WKORD_NUM   			: wkordNum,
					ITEM_CODE     			: itemCode,
					PROG_WORK_NAME			: progWorkName,
					CTL_CD1					: ctlCd1,
					TROUBLE_TIME			: troubleTime,
					TROUBLE					: trouble,
					TROUBLE_CS				: troubleCs,
					ANSWER					: answer,
					SEQ                     : seq
					//COMP_CODE        		:compCode
		        };
		        masterGrid6.createRow(r);
			}
				panelSearch.setAllFieldsReadOnly(false);
		},
		onResetButtonDown: function() {		// 새로고침 버튼
			this.suspendEvents();
			panelSearch.reset();
			panelResult.reset();
			panelResult.reset();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
//			masterGrid2.reset();
			masterGrid3.reset();
			masterGrid4.reset();
			masterGrid5.reset();
			masterGrid6.reset();
			this.fnInitBinding();
			directMasterStore.clearData();
//			directMasterStore2.clearData();
			directMasterStore3.clearData();
			directMasterStore4.clearData();
			directMasterStore5.clearData();
			directMasterStore6.clearData();
		},
		onDeleteDataButtonDown: function() {
			var activeTabId = tab.getActiveTab().getId();
			/*if(activeTabId == 's_pmr100ukrv_kdGrid2') {
				var selRow = masterGrid2.getSelectedRecord();
				if(selRow.phantom === true)	{
					masterGrid2.deleteSelectedRow();
				}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					masterGrid2.deleteSelectedRow();
				}
			} else*/
			if(activeTabId == 's_pmr100ukrv_kdGrid3_1') {    // 공정별 등록
                if(activeTabId2 == 's_pmr100ukrv_kdMasterStore4') {
                	var record = masterGrid.getSelectedRecord();
//                    if(record.get("CONTROL_STATUS") == '9' && record.get("RESULT_YN") == "2") {
//                        if(confirm('입고가 진행되었습니다. 입고내역도 삭제하시겠습니까?')) {
//                            var selRow = masterGrid4.getSelectedRecord();
//                            if(selRow) {
//                                masterGrid4.deleteSelectedRow();
//                            }
//                        }
//                    } else {
                    if(directMasterStore3.isDirty()) {
                    	alert(Msg.sMB154);
                    	return false
                    }
                    if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                        var selRow = masterGrid4.getSelectedRecord();
                        if(selRow) {
                            masterGrid4.deleteSelectedRow();
                            UniAppManager.setToolbarButtons('delete', false);
                            UniAppManager.setToolbarButtons('save', true);
                        }
                    }
//                    }
                }
			} else if(activeTabId == 's_pmr100ukrv_kdGrid5') {
				var selRow = masterGrid5.getSelectedRecord();
				if(selRow.phantom === true)	{
					masterGrid5.deleteSelectedRow();
				}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					masterGrid5.deleteSelectedRow();
				}
			} else if(activeTabId == 's_pmr100ukrv_kdGrid6') {
				var selRow = masterGrid6.getSelectedRecord();
				if(selRow.phantom === true)	{
					masterGrid6.deleteSelectedRow();
				}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					masterGrid6.deleteSelectedRow();
				}
			}

		},
		onSaveDataButtonDown: function(config) {
			var activeTabId = tab.getActiveTab().getId();
//			var newData = masterGrid2.getStore().getNewRecords();
			var newData2 = masterGrid3.getStore().getNewRecords();
			var record = masterGrid.getSelectedRecord();
			var resultYn = record.get("RESULT_YN");
			var updateData		= directMasterStore3.getUpdatedRecords();	//공정별 등록 그리드의 수정된 데이터
			//directMasterStore.saveStore();
			/*if(activeTabId == 's_pmr100ukrv_kdGrid2') {	// 작업지시별 등록
				panelSearch.setValue('RESULT_TYPE', "1");
				if(newData && newData.length > 0) {
					openoutouProdtSave();
				} else {
					directMasterStore2.saveStore();
				}
			}*/
			if(activeTabId == 's_pmr100ukrv_kdGrid3_1') {	// 공정별 등록
				if(activeTabId2 == 's_pmr100ukrv_kdMasterStore3') {
                    panelSearch.setValue('RESULT_TYPE', "2");
                    if(resultYn == '2') {
                    	if(updateData && updateData.length > 0) {
                    		var cnt = 0;
							Ext.each(updateData, function(updateRecord,i) {
								if(updateRecord.get('LINE_END_YN') == 'Y'){
									cnt = cnt + 1;
								}
							});
							if(cnt > 0){
								openoutouProdtSave();
							}else{
								directMasterStore3.saveStore();
							}

                    	}
                    } else {
                        directMasterStore3.saveStore();
//                        UniAppManager.app.onQueryButtonDown();
//                    	var store = masterGrid3.getStore();
//                        Ext.each(store.data.items, function(record, index) {
//                            record.set('PRODT_TYPE', '1');
//                        });
                    }
				} else if(activeTabId2 == 's_pmr100ukrv_kdMasterStore4') {
					panelSearch.setValue('RESULT_TYPE', "2");
                    directMasterStore4.saveStore();
//                    UniAppManager.app.onQueryButtonDown();
				}
			} /*else if(activeTabId == 's_pmr100ukrv_kdGrid4') {
				panelSearch.setValue('RESULT_TYPE', "2");
				directMasterStore4.saveStore();
			}*/ else if(activeTabId == 's_pmr100ukrv_kdGrid5') {	// 불량내역 등록
				panelSearch.setValue('RESULT_TYPE', "3");
				directMasterStore5.saveStore();
//				UniAppManager.app.onQueryButtonDown();
			} else if(activeTabId == 's_pmr100ukrv_kdGrid6') {	// 특기사항 등록
				panelSearch.setValue('RESULT_TYPE', "4");
				directMasterStore6.saveStore();
//				UniAppManager.app.onQueryButtonDown();
			}
//			UniAppManager.app.onQueryButtonDown();
		},
		setDefault: function() {
        	panelSearch.setValue('DIV_CODE',UserInfo.divCode);
        	panelSearch.setValue('PRODT_START_DATE_FR',UniDate.get('startOfMonth'));
        	panelSearch.setValue('PRODT_START_DATE_TO',UniDate.get('today'));
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
        	panelResult.setValue('PRODT_START_DATE_FR',UniDate.get('startOfMonth'));
        	panelResult.setValue('PRODT_START_DATE_TO',UniDate.get('today'));
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
		}
	});

    /**
	 * Validation
	 */
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {

			}
			return rv;
		}
	}); // validator

//	Unilite.createValidator('validator02', {
//		store: directMasterStore2,
//		grid: masterGrid2,
//		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
//			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
//			var rv = true;
//			switch(fieldName) {
//				case "PRODT_Q" :	// 생산량
//					if(newValue < '0') {
//						rv= Msg.sMB076;
//						break;
//					}
//					record.set('GOOD_PRODT_Q', newValue);
//				break;
//
//				case "GOOD_PRODT_Q" :	// 양품량
//					var record1 = masterGrid2.getSelectedRecord();
//					if(newValue > record1.get('PRODT_Q')) {
//						alert("양품량은 생산량보다 클수는 없습니다.");
//						break;
//					}
//					record.set('BAD_PRODT_Q', record.get('PRODT_Q') - newValue);
//				break;
//
//				case "BAD_PRODT_Q" :	// 불량량
//					if(newValue > "PRODT_Q") {
//						alert("불량량은 생산량보다 클수는 없습니다.");
//						break;
//					}
//					record.set('GOOD_PRODT_Q', record.get('PRODT_Q') - newValue);
//				break;
//
//				case "MAN_HOUR" :	// 투입공수
//					if(newValue < '0') {
//						rv= Msg.sMB076;
//						break;
//					}
//				break;
//			}
//			return rv;
//		}
//	}); // validator

	Unilite.createValidator('validator03', {
		store: directMasterStore3,
		grid: masterGrid3,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "PASS_Q" :	// 생산량
					if(newValue < '0') {
						rv= Msg.sMB076;
						break;
					}
					var record1 = masterGrid.getSelectedRecord();
                    var wkordQ = record1.get("WKORD_Q");
                    if(newValue > wkordQ || newValue > record.get('JAN_Q')) {
                    	rv = "초과 생산 실적 범위를 벗어났습니다.";
                    	break;
                    } else {
                       var totRec = directMasterStore3.data.items;
                       var HavePassQ = false;
                       Ext.each(totRec, function(rec, index){
                            if(rec.get('ORIGIN_PASS_Q') > 0){
                                HavePassQ = true;
                                return false;
                            }
                       });
                     //  if(record.get('LINE_END_YN') == "Y" && !HavePassQ){//최종공정 이면서 모든 공정별 생산량이 없을시 모든 공정에 수량을 set해준다..
                            Ext.each(totRec, function(rec, index){
                               rec.set('PASS_Q', newValue);
                               rec.set('WORK_Q', newValue);
                               rec.set('GOOD_WORK_Q', newValue);
                               rec.set('BAD_WORK_Q', newValue - rec.get('GOOD_WORK_Q'));
                               rec.set('NOW_DEPR', newValue * rec.get('CAVITY'));
                           });
                   //   }else{
                   //       record.set('WORK_Q', newValue);
                   //        record.set('GOOD_WORK_Q', newValue);
                   //       record.set('BAD_WORK_Q', newValue - record.get('GOOD_WORK_Q'));
                   //        record.set('NOW_DEPR', newValue * record.get('CAVITY'));
                   //   }

                    }

				break;
				case "PRODT_DATE" :	//생산일자
					 var records = directMasterStore3.data.items;
					  Ext.each(records, function(record, index){
						  record.set('PRODT_DATE', newValue);
                      });

					break;
				case "GOOD_WORK_Q" :	// 양품량
					if(newValue > record.get('PASS_Q')) {
						rv = "양품량은 생산량보다 클수는 없습니다.";
						break;
					}
					record.set('BAD_WORK_Q', record.get('PASS_Q') - newValue);
                    record.set('PASS_Q', record.get('BAD_WORK_Q') + newValue);
				break;

				case "BAD_WORK_Q" :	// 불량량
					if(newValue > record.get('PASS_Q')) {
						rv = "불량량은 생산량보다 클수는 없습니다.";
						break;
					}
					record.set('GOOD_WORK_Q', record.get('PASS_Q') - newValue);
                    record.set('PASS_Q', record.get('GOOD_WORK_Q') + newValue);
				break;

				case "MAN_HOUR" :	// 투입공수
					if(newValue < '0') {
						rv= Msg.sMB076;
						break;
					}
				break;
			}
			return rv;
		}
	});

	Unilite.createValidator('validator05', {
		store: directMasterStore5,
		grid: masterGrid5,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "BAD_Q" :	// 수량
					if(newValue < '0') {
						rv= Msg.sMB076;
						break;
					}
				break;
			}
			return rv;
		}
	});

	Unilite.createValidator('validator06', {
		store: directMasterStore6,
		grid: masterGrid6,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "TROUBLE_TIME" :	// 발생시간
					if(newValue < '0') {
						rv= Msg.sMB076;
						break;
					}
				break;
			}
			return rv;
		}
	});
}
</script>