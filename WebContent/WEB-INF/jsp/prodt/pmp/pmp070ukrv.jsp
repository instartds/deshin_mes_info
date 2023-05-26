<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmp070ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="pmp070ukrv" /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="WU" />                  <!-- 작업장  -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}

.x-change-cell_yellow {
background-color: #fcfac5;
}

.x-change-cell_dackgray {
background-color: #A6A6A6;
}
</style>
<script type="text/javascript" >

var SearchInfoWindow;	//

var BsaCodeInfo = {
	ConfirmPeriod: '${ConfirmPeriod}',    // 확정기간
	PrePeriod    : '${PrePeriod}',        // 예정기간
	gsAutoYN     : '${gsAutoYN}',         // 생산자동채번여부
	gsChildStockPopYN : '${gsChildStockPopYN}'  // 자재부족수량 팝업 호출여부
};
//var output ='';
//for(var key in BsaCodeInfo){
//	output += key + '  :  ' + BsaCodeInfo[key] + '\n';
//}
//alert(output);


function appMain() {

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'pmp070ukrvService.selectDetailList',
			update: 'pmp070ukrvService.updateDetail',
			create: 'pmp070ukrvService.insertDetail',
			destroy: 'pmp070ukrvService.deleteDetail',
			syncAll: 'pmp070ukrvService.saveAll'
		}
	});
	var panelSearch = Unilite.createSearchPanel('searchForm',{
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
            Unilite.popup('DIV_PUMOK',{
                    fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
                    validateBlank:false,
                    valueFieldName: 'ITEM_CODE_FR',
                    textFieldName: 'ITEM_NAME_FR',
                    listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {						
							panelResult.setValue('ITEM_CODE_FR', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME_FR', '');
								panelSearch.setValue('ITEM_NAME_FR', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {
							panelResult.setValue('ITEM_NAME_FR', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE_FR', '');
								panelSearch.setValue('ITEM_CODE_FR', '');
							}
						}
                    }
            }),
            Unilite.popup('DIV_PUMOK',{
                    fieldLabel: '~',
                    validateBlank:false,
                    valueFieldName: 'ITEM_CODE_TO',
                    textFieldName: 'ITEM_NAME_TO',
                    listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {						
							panelResult.setValue('ITEM_CODE_TO', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME_TO', '');
								panelSearch.setValue('ITEM_NAME_TO', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {
							panelResult.setValue('ITEM_NAME_TO', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE_TO', '');
								panelSearch.setValue('ITEM_CODE_TO', '');
							}
						}
                    }
            }),{
		        fieldLabel: '<t:message code="system.label.product.planperiod" default="계획기간"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'PLAN_FR_DATE',
				endFieldName: 'PLAN_TO_DATE',
				startDate: UniDate.get('today'),
				endDate: moment().add('day',BsaCodeInfo.PrePeriod).format('YYYYMMDD'),
				allowBlank:false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('PLAN_FR_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('PLAN_TO_DATE',newValue);
			    	}
			    }
			},{
		        fieldLabel: '<t:message code="system.label.product.confirmperiod" default="확정기간"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_CONFIRM_DATE',
				endFieldName: 'TO_CONFIRM_DATE',
				startDate: UniDate.get('today'),
				endDate: moment().add('day',BsaCodeInfo.ConfirmPeriod).format('YYYYMMDD'),
				allowBlank:false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_CONFIRM_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_CONFIRM_DATE',newValue);
			    	}
			    }
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

	var panelResult = Unilite.createSearchForm('panelResultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
		        fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		colspan: 2,
        		allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
		    },{
		        fieldLabel: '<t:message code="system.label.product.planperiod" default="계획기간"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'PLAN_FR_DATE',
				endFieldName: 'PLAN_TO_DATE',
				startDate: UniDate.get('today'),
                colspan: 2,
				endDate: moment().add('day',BsaCodeInfo.PrePeriod).format('YYYYMMDD'),
				allowBlank:false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('PLAN_FR_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('PLAN_TO_DATE',newValue);
			    	}
			    }
			},
		 	Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					validateBlank:false,
					valueFieldName: 'ITEM_CODE_FR',
					textFieldName: 'ITEM_NAME_FR',
                    listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {
							panelSearch.setValue('ITEM_CODE_FR', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME_FR', '');
								panelSearch.setValue('ITEM_NAME_FR', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {
							panelSearch.setValue('ITEM_NAME_FR', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE_FR', '');
								panelSearch.setValue('ITEM_CODE_FR', '');
							}
						}
                    }
			}),
			Unilite.popup('DIV_PUMOK',{
					fieldLabel: '~',
                    labelWidth:15,
					validateBlank:false,
					valueFieldName: 'ITEM_CODE_TO',
					textFieldName: 'ITEM_NAME_TO',
					listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {						
							panelSearch.setValue('ITEM_CODE_TO', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME_TO', '');
								panelSearch.setValue('ITEM_NAME_TO', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {
							panelSearch.setValue('ITEM_NAME_TO', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE_TO', '');
								panelSearch.setValue('ITEM_CODE_TO', '');
							}
						}
					}
			}),{
		        fieldLabel: '<t:message code="system.label.product.confirmperiod" default="확정기간"/>',
				xtype: 'uniDateRangefield',
                colspan: 2,
				startFieldName: 'FR_CONFIRM_DATE',
				endFieldName: 'TO_CONFIRM_DATE',
				startDate: UniDate.get('today'),
				endDate: moment().add('day',BsaCodeInfo.ConfirmPeriod).format('YYYYMMDD'),
				allowBlank:false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('FR_CONFIRM_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('TO_CONFIRM_DATE',newValue);
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



	/**
	 * 제조오더의 디테일 정보를 가지고 있는 Model 정의
	 * @type
	 */
	Unilite.defineModel('pmp070ukrvDetailModel', {
	    fields: [
	    	{name: 'FLAG'               	,text: '<t:message code="system.label.product.selection" default="선택"/>'				,type: 'string'},
			{name: 'COMP_CODE'       		,text: '<t:message code="system.label.product.compcode" default="법인코드"/>'  		    ,type: 'string'},
			{name: 'DIV_CODE'           	,text: '<t:message code="system.label.product.division" default="사업장"/>'	 		    ,type: 'string'},
			{name: 'ORDER_REQ_NUM'   		,text: '<t:message code="system.label.product.orderno" default="오더번호"/>'   		,type: 'string'},
			{name: 'MOTHER_CODE'       		,text: '<t:message code="system.label.product.parentitem" default="모품목"/>'    		    ,type: 'string'},
			{name: 'WORK_SHOP_CODE'  		,text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'   		,type: 'string'},
			{name: 'WORK_SHOP_NAME'  		,text: '<t:message code="system.label.product.workcentername" default="작업장명"/>' 		    ,type: 'string'},
			{name: 'DAY_NIGHT'       		,text: '<t:message code="system.label.product.daynightclass" default="주야구분"/>'     		,type: 'string'},
			{name: 'ITEM_CODE'       		,text: '<t:message code="system.label.product.item" default="품목"/>'    		,type: 'string'},
			{name: 'ITEM_NAME'       		,text: '<t:message code="system.label.product.itemname" default="품목명"/>'    		    ,type: 'string'},
			{name: 'SPEC'            		,text: '<t:message code="system.label.product.spec" default="규격"/>'    			,type: 'string'},
			{name: 'CHILD_ITEM_CODE' 		,text: '<t:message code="system.label.product.childitemcode" default="자품목코드"/>'    		,type: 'string'},
			{name: 'ORDER_STATE'     		,text: '<t:message code="system.label.product.confirmstatus" default="확정상태"/>'    		,type: 'string'},
			{name: 'ORDER_PLAN_Q'    		,text: '<t:message code="system.label.product.orderqty" default="오더량"/>'    		,type: 'uniQty'},
			{name: 'ORDER_PRODT_Q'   		,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'    		,type: 'uniQty'},
			{name: 'REMAINDER_Q'     		,text: '<t:message code="system.label.product.balanceqty" default="잔량"/>'   			,type: 'uniQty'},
			{name: 'START_DATE'      		,text: '<t:message code="system.label.product.planstartdate" default="계획시작일"/>'  		,type: 'uniDate'},
			{name: 'END_DATE'        		,text: '<t:message code="system.label.product.planenddate" default="계획종료일"/>'	 		,type: 'uniDate'},
			{name: 'MAX_PRODT_Q'     		,text: '<t:message code="system.label.product.maximumproductqty" default="최대생산량"/>'  		,type: 'uniQty'},
			{name: 'MIN_PRODT_Q'     		,text: '<t:message code="system.label.product.mininumproductqty" default="최소생산량"/>'	 		,type: 'uniQty'},
			{name: 'ORDER_NUM'       		,text: '<t:message code="system.label.product.sono" default="수주번호"/>'    		,type: 'string'},
			{name: 'PROJECT_NO'      		,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'    	,type: 'string'},
			{name: 'PJT_CODE'				,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'    	,type: 'string'},
			{name: 'DVRY_DATE'       		,text: '<t:message code="system.label.product.estimateddiliverydate" default="예상납기일"/>'    		,type: 'uniDate'},
			{name: 'PROD_END_DATE'   		,text: '<t:message code="system.label.product.productionrequestdate" default="생산요청일"/>'    		,type: 'uniDate'},
			{name: 'ORDER_Q'         		,text: '<t:message code="system.label.product.soqty" default="수주량"/>'    		    ,type: 'uniQty'},
			{name: 'WKORD_NUM'       		,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'   	,type: 'string'},
			{name: 'PRODT_START_DATE'		,text: '<t:message code="system.label.product.productionorderdate" default="생산지시일"/>'  		,type: 'uniDate'},
			{name: 'PRODT_END_DATE'  		,text: '<t:message code="system.label.product.productionfinishdate" default="생산완료일"/>'	 		,type: 'uniDate'},
			{name: 'PRODT_Q'         		,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'  			,type: 'uniQty'},
			{name: 'WK_PLAN_NUM'     		,text: '<t:message code="system.label.product.planno" default="계획번호"/>'	 		,type: 'string'},
			{name: 'STATUS'         		,text: '<t:message code="system.label.product.productionstatus2" default="생산상태"/>'   		,type: 'string'},
			{name: 'REMARK'          		,text: '<t:message code="system.label.product.specialremark" default="특기사항"/>'   		,type: 'string'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var detailStore = Unilite.createStore('pmp070ukrvDetailStore', {
		model: 'pmp070ukrvDetailModel',
		autoLoad: false,
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: true,		// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		proxy: directProxy,

		loadStoreRecords: function() {

			var param= panelResult.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		UniAppManager.setToolbarButtons(['newData', 'save'], true);
           	}
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

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
					config = {
							params: [paramMaster],
							success: function(batch, option) {

								panelSearch.getForm().wasDirty = false;
								panelSearch.resetDirtyStatus();
								console.log("set was dirty to false");
								UniAppManager.setToolbarButtons('save', false);
							 }
					};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('pmp070ukrvGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				// alert(Msg.sMB083);
			}
		}
	});

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */

    var masterGrid = Unilite.createGrid('pmp070ukrvGrid', {
    	layout: 'fit',
        region:'center',
        uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false,
			useGroupSummary: false,
			useContextMenu: false
        },
        tbar: [{
			name: '',
			xtype:'button',
			text : '<t:message code="system.label.product.temporarysave" default="임시저장"/>',
			width: 70,
			handler : function(){
			}
       }],
    	store: detailStore,
    	selModel: Ext.create('Ext.selection.CheckboxModel', {
        	checkOnly: false,
        	toggleOnClick: false,
        	listeners: {
        		beforeselect: function(rowSelection, record, index, eOpts) {
        			if(record.get('ORDER_STATE') == '-1' || record.get('ORDER_REQ_NUM') == ''){
		          		UniAppManager.setToolbarButtons('newData', false);
		          		//masterGrid.startEdit(record , 'ORDER_PLAN_Q');  // ORDER_PLAN_Q 으로 focus 설정
	          		}else{
	          			UniAppManager.setToolbarButtons('newData', true);
          			}
        		},
				select: function(grid, record, index, eOpts ){

	          	},
				deselect:  function(grid, record, index, eOpts ){
        		}
        	}
        }),
		uniOpt:{
	        onLoadSelectFirst : false
	    },
	    features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
        columns: [
			{dataIndex: 'FLAG'            			, width: 40  , hidden: true},
			{dataIndex: 'COMP_CODE'       			, width: 33  , hidden: true},
			{dataIndex: 'DIV_CODE'        			, width: 33  , hidden: true},
			{dataIndex: 'ORDER_REQ_NUM'   			, width: 133 , hidden: true},
			{dataIndex: 'MOTHER_CODE'     			, width: 133 , hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'  			, width: 100 },
			{dataIndex: 'WORK_SHOP_NAME'  			, width: 200 , hidden: true},
			{dataIndex: 'DAY_NIGHT'       			, width: 66  , hidden: true},
			{dataIndex: 'ITEM_CODE'       			, width: 110  ,
			summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
            		return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.product.totalamount" default="합계"/>');
            }},
			{dataIndex: 'ITEM_NAME'       			, width: 200},
			{dataIndex: 'SPEC'            			, width: 130},
			{dataIndex: 'CHILD_ITEM_CODE' 			, width: 120},
			{dataIndex: 'ORDER_STATE'     			, width: 80 , hidden: true },
			{dataIndex: 'ORDER_PLAN_Q'    			, width: 70  , summaryType: 'sum',
				renderer: function(value, metaData, record) {
					if(record.get("ORDER_STATE") == '-1'){
						metaData.tdCls = 'x-change-cell_dackgray';
					}
					else{
						metaData.tdCls = 'x-change-cell_yellow';
					}
					//return value;
					return Ext.util.Format.number(value,'0,000.00');
				}
			},
			{dataIndex: 'ORDER_PRODT_Q'   			, width: 70  , summaryType: 'sum'},
			{dataIndex: 'REMAINDER_Q'     			, width: 70  , summaryType: 'sum'},
			{dataIndex: 'START_DATE'      			, width: 93},
			{dataIndex: 'END_DATE'        			, width: 93},
			{dataIndex: 'MAX_PRODT_Q'     			, width: 80},
			{dataIndex: 'MIN_PRODT_Q'     			, width: 80},
			{dataIndex: 'ORDER_NUM'       			, width: 120},
			{dataIndex: 'PROJECT_NO'      			, width: 93},
//			{dataIndex: 'PJT_CODE'					, width: 93},
			{dataIndex: 'DVRY_DATE'       			, width: 80},
			{dataIndex: 'PROD_END_DATE'   			, width: 80 , hidden: true },
			{dataIndex: 'ORDER_Q'         			, width: 70},
			{dataIndex: 'WKORD_NUM'       			, width: 120},
			{dataIndex: 'PRODT_START_DATE'			, width: 80 , hidden: true },
			{dataIndex: 'PRODT_END_DATE'  			, width: 120, hidden: true },
			{dataIndex: 'PRODT_Q'         			, width: 70, hidden: true},
			{dataIndex: 'WK_PLAN_NUM'     			, width: 120, hidden: true },
			{dataIndex: 'STATUS'         			, width: 80 , hidden: true },
			{dataIndex: 'REMARK'          			, width: 200}
		],
		listeners: {
			beforeedit : function( editor, e, eOpts ) {
				if(e.field=='WKORD_NUM'){
					if(BsaCodeInfo.gsAutoYN = "N"){
						if(e.record.data.ORDER_STATE == '-1'){
							return false;
						}else{
							return true;
						}
					}else{
						return false;
					}
				}else if(e.field=='WORK_SHOP_CODE' || e.field=='START_DATE' || e.field=='END_DATE'){
					if(e.record.data.ORDER_STATE == '-1'){
						return false;
					}else{
						return true;
					}
				}else if(e.field=='REMARK'){
					return true;
				}else if(e.field=='ORDER_PLAN_Q' || e.field=='FLAG'){
					if(e.record.data.ORDER_STATE == '-1'){
						return false;
					}else{
						return true;
					}
				}else{
					return false;
				}
				//// * txtStatus.Value = SMP812 Or txtStatus.Value = SMP816 를 구분 지어서 조건문에 추가 해야함.

//TEST			if(e.record.data.ORDER_STATE == '-1' || e.record.data.ORDER_REQ_NUM == ''){
//				}
//
//
//				if(/*e.record.data.STATUS == '8' || e.record.data.STATUS == '9' || */e.record.data.ORDER_STATE == '-1' ){
//					if(BsaCodeInfo.gsAutoYN = "N"){
//						if(e.field=='WKORD_NUM') return false;
//					}else {
//						if(e.field=='WKORD_NUM') return false;
//					}
//				}else if(/*e.record.data.STATUS == '8' || e.record.data.STATUS == '9' || */e.record.data.ORDER_STATE == '-1'){
//					if (UniUtils.indexOf(e.field,
//											['WORK_SHOP_CODE','START_DATE','END_DATE']) )
//							return false;
//
//				}
//				else(UniUtils.indexOf(e.field,
//											['WKORD_NUM','WORK_SHOP_CODE','START_DATE','END_DATE']) )
////											['COMP_CODE','DIV_CODE','MOTHER_CODE','WORK_SHOP_NAME','DAY_NIGHT',
////											 'ITEM_CODE','ITEM_NAME','SPEC','CHILD_ITEM_CODE','ORDER_STATE','ORDER_PLAN_Q','ORDER_PRODT_Q',
////											 'REMAINDER_Q','MAX_PRODT_Q','MIN_PRODT_Q','ORDER_NUM','PROJECT_NO','PJT_CODE','DVRY_DATE',
////											 'PROD_END_DATE','ORDER_Q','WKORD_NUM','PRODT_START_DATE','PRODT_END_DATE','WK_PLAN_NUM','STATUS']) )
//							return false;
//				},
			},
		    cellclick: function( viewTable, td, cellIndex, record, tr, rowIndex, e, eOpts , colName) {
	        	this.returnCell(record, colName);
	   		}
       	},
       	returnCell: function(record, colName){
       		var cellValue      = record.get(colName);
       		var orderState     = record.get("ORDER_STATE");
       		var status         = record.get("STATUS");

       		var workShopName   = record.get("WORK_SHOP_CODE");
       		var itemCode       = record.get("ITEM_CODE");
       		var startDate      = record.get("START_DATE");
       		var orderPlanQ     = record.get("ORDER_PLAN_Q");
       		var orderNum       = record.get("ORDER_NUM");
       		var dvryDate       = record.get("DVRY_DATE");
       		var prodEndDate    = record.get("PROD_END_DATE");
       		var orderQ         = record.get("ORDER_Q");

       		//Call ProductInfoSearch() 함수에서 추출 해온 작업지시번호, 생산지시일, 생산완료일, 생산량
       		var wkordNum       = record.get("WKORD_NUM");
       		var prodtStartDate = record.get("PRODT_START_DATE");
       		var prodtEndDate   = record.get("PRODT_END_DATE");
       		var prodtQ    	   = record.get("PRODT_Q");
       		var status         = record.get("STATUS");

       		// 확정된 계획일 경우는 생산정보를 보여준다
       		if(orderState == '-1'){
   				panelSearch.setValues({'WORK_CENTER':workShopName});          // 작업장
   				panelSearch.setValues({'ITEM':itemCode});                     // 품목
   				panelSearch.setValues({'DATE':startDate});                    // 일자
   				panelSearch.setValues({'QTY':orderPlanQ});                    // 수량
   				panelSearch.setValues({'ORDER_NO':orderNum});                 // 수주번호
   				panelSearch.setValues({'EXCEPT_DATE':dvryDate});              // 예상납기일
   				panelSearch.setValues({'REQUEST_DATE':prodEndDate});          // 생산완료요청일
   				panelSearch.setValues({'ORDER_QTY':orderQ});                  // 수주량

   				if(BsaCodeInfo.gsAutoYN == 'N'){
   					panelSearch.setValues({'WKORD_NUM':wkordNum});             // 작업지시번호
   				}

   				// Sub ProductInfoSearch()
   				panelSearch.setValues({'WKORD_NUM':wkordNum});
   				panelSearch.setValues({'PRODUCT_START_DATE':prodtStartDate});  // 생산지시일
   				panelSearch.setValues({'PRODUCT_END_DATE':prodtEndDate});      // 생산완료일
   				panelSearch.setValues({'PRODUCT_QTY':prodtQ});                 // 생산량
   				panelSearch.setValues({'STATUS':status});

   			}else{
   				panelSearch.setValues({'WORK_CENTER':workShopName});
   				panelSearch.setValues({'ITEM':itemCode});
   				panelSearch.setValues({'DATE':startDate});
   				panelSearch.setValues({'QTY':orderPlanQ});
   				if(BsaCodeInfo.gsAutoYN == 'N'){
   					panelSearch.setValues({'WKORD_NUM':wkordNum});
   				}
   				else{
   					panelSearch.setValues({'WKORD_NUM':''});
   				}
   				panelSearch.setValues({'PRODUCT_START_DATE':''});
       			panelSearch.setValues({'PRODUCT_END_DATE':''});
       			panelSearch.setValues({'PRODUCT_QTY':''});
       			panelSearch.setValues({'STATUS':status});
       			panelSearch.setValues({'ORDER_QTY':''});
       			panelSearch.setValues({'ORDER_NO':orderNum});
       			panelSearch.setValues({'EXCEPT_DATE':dvryDate});
       			panelSearch.setValues({'REQUEST_DATE':prodtEndDate});
       			panelSearch.setValues({'ORDER_QTY':orderQ});
       		}
       	},
		disabledLinkButtons: function(b) {
       		//this.down('#procTool').menu.down('#temporarySaveBtn').setDisabled(b);
		}
    });

   Unilite.Main ({
		borderItems: [{
         	region:'center',
         	layout: 'border',
         	border: false,
         	items:[
           		masterGrid, panelResult
         	]
      	},
      	panelSearch
      	],
		id: 'pmp070skrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons([ 'prev', 'next','reset'], true);
			UniAppManager.setToolbarButtons(['newData'], false);
			this.setDefault();

		},
		onQueryButtonDown: function() {
			panelSearch.setAllFieldsReadOnly(false);

			detailStore.loadStoreRecords();
			// 조회시 상단내용 지운다.
			panelSearch.setValue('WORK_CENTER','');
			panelSearch.setValue('ITEM','');
			panelSearch.setValue('DATE','');
			panelSearch.setValue('QTY','');
			panelSearch.setValue('ORDER_NO','');
			panelSearch.setValue('EXCEPT_DATE','');
			panelSearch.setValue('REQUEST_DATE','');
			panelSearch.setValue('ORDER_QTY','');
			panelSearch.setValue('WK_ORDER_NO','');
			panelSearch.setValue('PRODUCT_START_DATE','');
			panelSearch.setValue('PRODUCT_END_DATE','');
			panelSearch.setValue('PRODUCT_QTY','');
			panelSearch.setValue('STATUS','');
		},
		onNewDataButtonDown: function( )	{
			var record = masterGrid.getSelectedRecord();


//			if(selRecord) {
//				var r = record.copy().data;
//				console.log('copy record: ', r);
//				r.ORDER_REQ_NUM =  '';
//				r.ORDER_PLAN_Q = '';

//				var itemCode = masterGrid.getSelectedRecord('ITEM_CODE');


				var r = {
					FLAG: record.get('FLAG'),
					COMP_CODE: record.get('COMP_CODE'),
					DIV_CODE: record.get('DIV_CODE'),
					ORDER_REQ_NUM: '',
					MOTHER_CODE: record.get('MOTHER_CODE'),
					WORK_SHOP_CODE: record.get('WORK_SHOP_CODE'),
					WORK_SHOP_NAME: record.get('WORK_SHOP_NAME'),
					DAY_NIGHT: record.get('DAY_NIGHT'),
					ITEM_CODE: record.get('ITEM_CODE'),
					ITEM_NAME: record.get('ITEM_NAME'),
					SPEC: record.get('SPEC'),
					CHILD_ITEM_CODE: record.get('CHILD_ITEM_CODE'),
					ORDER_STATE: record.get('ORDER_STATE'),
					ORDER_PLAN_Q: '',
					ORDER_PRODT_Q: record.get('ORDER_PRODT_Q'),
					REMAINDER_Q: record.get('REMAINDER_Q'),
					START_DATE: record.get('START_DATE'),
					END_DATE: record.get('END_DATE'),
					MAX_PRODT_Q: record.get('MAX_PRODT_Q'),
					MIN_PRODT_Q: record.get('MIN_PRODT_Q'),
					ORDER_NUM: record.get('ORDER_NUM'),
					PROJECT_NO: record.get('PROJECT_NO'),
					PJT_CODE: record.get('PJT_CODE'),
					DVRY_DATE: record.get('DVRY_DATE'),
					PROD_END_DATE: record.get('PROD_END_DATE'),
					ORDER_Q: record.get('ORDER_Q'),
					WKORD_NUM: record.get('WKORD_NUM'),
					PRODT_START_DATE: record.get('PRODT_START_DATE'),
					PRODT_END_DATE: record.get('PRODT_END_DATE'),
					PRODT_Q: record.get('PRODT_Q'),
					WK_PLAN_NUM: record.get('WK_PLAN_NUM'),
					STATUS: record.get('STATUS'),
					REMARK: record.get('REMARK')
				}


				// -- 필요한 로직 -- //
				// 1. 복사 대상(U)을 선택 한 후, 복사를 할 경우(N) "ORDER_REQ_NUM" "ORDER_PLAN_Q" 는 빈값으로 들어오며, focus으로 지정 된다.                 -- O

				// 2. 오더 수량의 데이터를 입력 하기 전 까지 그리드에 다른 Row를 선택 할 수 없다. (단, 0 을 초과한 값을 입력을 해야 한다.)                                -- X

				// 3. 0 을 초과한 값을 입력 하였을 경우, 복사 대상(U)의 오더수량은 복사한 행(N)의 오더수량만큼 마이너스 계산 된다. ( N의 오더수량  100 일 경우 U의 오더수량은 -100) -- X

				// 4. 복사 한 행(N)의 오더수량은 0을 초과한 값 을 입력 해야 하며, 복사한 행(U)의 오더수량 이하 만큼 입력이 가능하다.                                    -- X

				// 5. 복사 대상(U)의 오더수량이 0 일 경우 추가는 가능 하지만 복사한 행(N) 오더수량을 0을 초과하여 입력 할 수 없기 때문에, "삭제"를 해야 진행이 가능하다.           -- X

				// 6. 복사 대상의 행(N)은 복사(추가)가 불가능 하다.                                                                               -- O
//			}
			masterGrid.createRow(r);
		},
		onResetButtonDown: function() {
			//this.suspendEvents();
			panelSearch.clearForm();
			panelResult.clearForm();

			panelSearch.setAllFieldsReadOnly(false);
			masterGrid.reset();

			this.fnInitBinding();

		},
		onSaveDataButtonDown: function(config) {
			detailStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				if(selRow.get('ORDER_STATE') == '-1' ) {
					alert('<t:message code="system.message.product.message044" default="확정된 오더는 삭제를 할 수 없습니다."/>');
				}else {
					masterGrid.deleteSelectedRow();
				}
			}
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('pmp070ukrvAdvanceSerch');
			if(as.isHidden())	{
				as.show();
			} else {
				as.hide()
			}
		},
		setDefault: function() {
        	panelSearch.setValue('DIV_CODE',UserInfo.divCode);
        	panelSearch.setValue('PLAN_FR_DATE',UniDate.get('today'));
        	panelSearch.setValue('PLAN_TO_DATE',moment().add('day',BsaCodeInfo.PrePeriod).format('YYYYMMDD'));
        	panelSearch.setValue('FR_CONFIRM_DATE',UniDate.get('today'));
        	panelSearch.setValue('TO_CONFIRM_DATE',moment().add('day',BsaCodeInfo.ConfirmPeriod).format('YYYYMMDD'));

        	panelResult.setValue('DIV_CODE',UserInfo.divCode);
        	panelResult.setValue('PLAN_FR_DATE',UniDate.get('today'));
        	panelResult.setValue('PLAN_TO_DATE',moment().add('day',BsaCodeInfo.PrePeriod).format('YYYYMMDD'));
        	panelResult.setValue('FR_CONFIRM_DATE',UniDate.get('today'));
        	panelResult.setValue('TO_CONFIRM_DATE',moment().add('day',BsaCodeInfo.ConfirmPeriod).format('YYYYMMDD'));

			UniAppManager.setToolbarButtons('save', false);
		},
        checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});

    /**
	 * Validation
	 */
	Unilite.createValidator('validator01', {
		store: detailStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {

				case "ORDER_PLAN_Q" : // 주간 오더 수량

				var motherCode = record.get('MOTHER_CODE'); /* 모코드 */

					if(newValue < 0 ){
						//0 이상 입력 하세요.
						rv='<t:message code="system.message.product.message023" default="입력한 값이 0보다 큰 수이어야 합니다."/>';
						//record.get('ORDER_PLAN_Q').focus();
						break;
					}

					var orderState = record.get('ORDER_STATE');
					var prodtQ = record.get('PRODT_Q');

					if (orderState == '-1'){
						if(newValue == 0){
						rv='<t:message code="system.message.product.message049" default="확정된 오더는 0 으로  할 수 없습니다."/>';
						//확정된 오더는 0 으로  할 수 없습니다.

						break;
						}
						if(newValue <= prodtQ ){
							rv='<t:message code="system.message.product.message050" default="생산량보다 커야 합니다."/>';
							//생산량보다 커야 합니다.

							break;
						}
						break;
					}



				/*	var copyRow = masterGrid.getSelectedRecord();
					if(copyRow.phantom )	{

						if(newValue < copyRow.get('ORDER_PLAN_Q')){
							rv =
						}
					}*/

////					var orderPlanQ = record.get('ORDER_PLAN_Q');
////					if (newValue < orderPlanQ){

////						//원본수량보다 작아야  합니다.
////						break;
////					}
////					if (newValue < 0)

////				if(record.get('ORDER_STATE') == '-1' || record.get('ORDER_REQ_NUM') == ''){

					break;

				case "START_DATE" : // 계획시작일
					if(new Date() > newValue){
						rv='<t:message code="system.message.product.message045" default="과거의 일자로 이동 할 수 없습니다."/>';
						//과거의 일자로 이동 할 수 없습니다.
						break;
					}

				case "END_DATE"   : // 계획종료일
					if(new Date() > newValue){
						rv='<t:message code="system.message.product.message045" default="과거의 일자로 이동 할 수 없습니다."/>';
						//과거의 일자로 이동 할 수 없습니다.
						break;
					}

			}
			return rv;
		}
	}); // validator

	Unilite.createValidator('validator02', {
		forms: {'formA:':panelSearch},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;
			// 계획기간
			var frPlanDate = form.getField('PLAN_FR_DATE').getSubmitValue();  // 계획기간 FR
			var toPlanDate = form.getField('PLAN_TO_DATE').getSubmitValue();  // 계획기간 TO
			// 확정기간
			var frConfirmDate = form.getField('FR_CONFIRM_DATE').getSubmitValue();  // 확정기간 FR
			var toConfirmDate = form.getField('TO_CONFIRM_DATE').getSubmitValue();  // 확정기간 TO

			switch(fieldName) {
				case "FR_CONFIRM_DATE" : // 확정기간 FR
					if(frConfirmDate < frPlanDate){
						alert('<t:message code="system.message.product.message046" default="확정일자는 계획일자보다 커야 합니다."/>');
						//확정일자는 계획일자보다 커야 합니다.
						panelSearch.setValue('FR_CONFIRM_DATE',frPlanDate);
						panelResult.setValue('FR_CONFIRM_DATE',frPlanDate);
						panelSearch.getField('FR_CONFIRM_DATE').focus();
						break;
					}
					if(frConfirmDate > toConfirmDate){

						alert('<t:message code="system.message.product.message047" default="확정시작일은 확정종료일 보다 작아야 합니다."/>');
							//확정시작일은 확정종료일 보다 작아야 합니다.
						panelSearch.setValue('FR_CONFIRM_DATE',toConfirmDate);
						panelResult.setValue('FR_CONFIRM_DATE',toConfirmDate);
						panelSearch.getField('FR_CONFIRM_DATE').focus();
						break;

					}
						//alert("newValue:"+newValue);
						var confirmPlus = UniDate.add(UniDate.extParseDate(newValue), { days: BsaCodeInfo.ConfirmPeriod });
						panelSearch.setValue('TO_CONFIRM_DATE',confirmPlus);
						panelResult.setValue('TO_CONFIRM_DATE',confirmPlus);


				case "TO_CONFIRM_DATE" :

					if(toConfirmDate < frPlanDate){
						alert('<t:message code="system.message.product.message046" default="확정일자는 계획일자보다 커야 합니다."/>');
							//확정일자는 계획일자보다 커야 합니다.
						panelSearch.setValue('TO_CONFIRM_DATE',frPlanDate);
						panelResult.setValue('TO_CONFIRM_DATE',frPlanDate);
						panelSearch.getField('TO_CONFIRM_DATE').focus();
						break;
					}
					if(toConfirmDate > toPlanDate){
						alert('<t:message code="system.message.product.message047" default="확정시작일은 확정종료일 보다 작아야 합니다."/>');
							//확정종료일자는 계획종료일 보다 작거나 같아야 한다.
						panelSearch.setValue('TO_CONFIRM_DATE',toPlanDate);
						panelResult.setValue('TO_CONFIRM_DATE',toPlanDate);
						panelSearch.getField('TO_CONFIRM_DATE').focus();
						break;
					}
					if(frConfirmDate > toConfirmDate){
						alert('<t:message code="system.message.product.message048" default="확정종료일은 확정시작일 보다 커야 합니다."/>');
							//확정종료일은 확정시작일 보다 커야 합니다.
						panelSearch.setValue('TO_CONFIRM_DATE',frConfirmDate);
						panelResult.setValue('TO_CONFIRM_DATE',frConfirmDate);
						panelSearch.getField('TO_CONFIRM_DATE').focus();
							break;
					}break;

				case "PLAN_FR_DATE" : //
					var planPlus = UniDate.add(UniDate.extParseDate(newValue), { days: BsaCodeInfo.PrePeriod });
					panelSearch.setValue('PLAN_TO_DATE' ,planPlus);
					panelResult.setValue('PLAN_TO_DATE' ,planPlus);
					UniAppManager.app.onQueryButtonDown();

					break;
			}
			return rv;
		}
	}); // validator02


	Unilite.createValidator('validator03', {
		forms: {'formA:':panelResult},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;
			// 계획기간
			var frPlanDate = form.getField('PLAN_FR_DATE').getSubmitValue();  // 계획기간 FR
			var toPlanDate = form.getField('PLAN_TO_DATE').getSubmitValue();  // 계획기간 TO
			// 확정기간
			var frConfirmDate = form.getField('FR_CONFIRM_DATE').getSubmitValue();  // 확정기간 FR
			var toConfirmDate = form.getField('TO_CONFIRM_DATE').getSubmitValue();  // 확정기간 TO

			switch(fieldName) {
				case "FR_CONFIRM_DATE" : // 확정기간 FR
					if(frConfirmDate < frPlanDate){
						alert('<t:message code="system.message.product.message046" default="확정일자는 계획일자보다 커야 합니다."/>');
						//확정일자는 계획일자보다 커야 합니다.
						panelSearch.setValue('FR_CONFIRM_DATE',frPlanDate);
						panelResult.setValue('FR_CONFIRM_DATE',frPlanDate);
						panelResult.getField('FR_CONFIRM_DATE').focus();
						break;
					}
					if(frConfirmDate > toConfirmDate){

						alert('<t:message code="system.message.product.message047" default="확정시작일은 확정종료일 보다 작아야 합니다."/>');
							//확정시작일은 확정종료일 보다 작아야 합니다.
						panelSearch.setValue('FR_CONFIRM_DATE',toConfirmDate);
						panelResult.setValue('FR_CONFIRM_DATE',toConfirmDate);
						panelResult.getField('FR_CONFIRM_DATE').focus();
						break;

					}
						//alert("newValue:"+newValue);
						var confirmPlus = UniDate.add(UniDate.extParseDate(newValue), { days: BsaCodeInfo.ConfirmPeriod });
						panelSearch.setValue('TO_CONFIRM_DATE',confirmPlus);
						panelResult.setValue('TO_CONFIRM_DATE',confirmPlus);


				case "TO_CONFIRM_DATE" :

					if(toConfirmDate < frPlanDate){
						alert('<t:message code="system.message.product.message046" default="확정일자는 계획일자보다 커야 합니다."/>');
							//확정일자는 계획일자보다 커야 합니다.
						panelSearch.setValue('TO_CONFIRM_DATE',frPlanDate);
						panelResult.setValue('TO_CONFIRM_DATE',frPlanDate);
						panelResult.getField('TO_CONFIRM_DATE').focus();
						break;
					}
					if(toConfirmDate > toPlanDate){
						alert('<t:message code="system.message.product.message047" default="확정시작일은 확정종료일 보다 작아야 합니다."/>');
							//확정종료일자는 계획종료일 보다 작거나 같아야 한다.
						panelSearch.setValue('TO_CONFIRM_DATE',toPlanDate);
						panelResult.setValue('TO_CONFIRM_DATE',toPlanDate);
						panelResult.getField('TO_CONFIRM_DATE').focus();
						break;
					}
					if(frConfirmDate > toConfirmDate){
						alert('<t:message code="system.message.product.message048" default="확정종료일은 확정시작일 보다 커야 합니다."/>');
							//확정종료일은 확정시작일 보다 커야 합니다.
						panelSearch.setValue('TO_CONFIRM_DATE',frConfirmDate);
						panelResult.setValue('TO_CONFIRM_DATE',frConfirmDate);
						panelResult.getField('TO_CONFIRM_DATE').focus();
							break;
					}break;

				case "PLAN_FR_DATE" : //
					var planPlus = UniDate.add(UniDate.extParseDate(newValue), { days: BsaCodeInfo.PrePeriod });
					panelSearch.setValue('PLAN_TO_DATE' ,planPlus);
					panelResult.setValue('PLAN_TO_DATE' ,planPlus);
					UniAppManager.app.onQueryButtonDown();

					break;
			}
			return rv;
		}
	}); // validator03
}
</script>