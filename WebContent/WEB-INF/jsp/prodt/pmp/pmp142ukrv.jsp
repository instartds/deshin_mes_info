<%--
'   프로그램명 : 예외출고등록(생산)
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
<t:appConfig pgmId="pmp142ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 					  <!-- 사업장 -->
    <t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 -->
    	<t:ExtComboStore comboType="WU" />										<!-- 작업장-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >


var BsaCodeInfo = {

};

var outDivCode = UserInfo.divCode;
var checkDraftStatus = false;

function appMain() {

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'pmp142ukrvService.selectDetailList'/*,
			update: 'pmp142ukrvService.updateDetail',
			create: 'pmp142ukrvService.insertDetail',
			destroy: 'pmp142ukrvService.deleteDetail',
			syncAll: 'pmp142ukrvService.saveAll'*/
		}
	});

	var masterForm = Unilite.createSearchPanel('pmp142ukrvMasterForm', {
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
	   		items : [{
		       	fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
		       	name:'DIV_CODE',
		       	xtype: 'uniCombobox',
		       	comboType:'BOR120',
		       	allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
	      	 },{
	      	 	fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
	      	 	xtype: 'uniDateRangefield',
	      	 	startFieldName: 'PRODT_START_DATE_FR',
				endFieldName: 'PRODT_START_DATE_TO',
	      	 	width: 315,
	      	 	startDate: UniDate.get('todayOfLastWeek'),
	      	 	endDate: UniDate.get('today'),
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
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType: 'WU',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WORK_SHOP_CODE', newValue);
					}
				}
			},{
				xtype: 'uniTextfield',
				name: 'WKORD_NUM',
				fieldLabel:'<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {
			      		panelResult.setValue('WKORD_NUM', newValue);
			     	}
			    }
			},
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.product.parentitemcode" default="모품목코드"/>',
					validateBlank:false,
					textFieldName:'PITEM_NAME',
					valueFieldName:'PITEM_CODE',
		        	listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								panelResult.setValue('PITEM_CODE', masterForm.getValue('PITEM_CODE'));
								panelResult.setValue('PITEM_NAME', masterForm.getValue('PITEM_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('PITEM_CODE', '');
							panelResult.setValue('PITEM_NAME', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
						}
					}
			}),
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.product.materialitemcode" default="자재품목코드"/>',
					validateBlank:false,
					textFieldName: 'CITEM_NAME',
					valueFieldName: 'CITEM_CODE',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								panelResult.setValue('CITEM_CODE', masterForm.getValue('CITEM_CODE'));
								panelResult.setValue('CITEM_NAME', masterForm.getValue('CITEM_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('CITEM_CODE', '');
							panelResult.setValue('CITEM_NAME', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
						}
					}
			}),{
				xtype: 'radiogroup',
            	fieldLabel: '<t:message code="system.label.product.itemaccount" default="품목계정"/>',
            	//id: 'ITEM_ACCOUNT',
            	//name:'ITEM_ACCOUNT',
            	labelWidth:90,
            	items: [{
            		boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
            		width: 60,
            		name: 'ITEM_ACCOUNT',
            		inputValue: '',
            		checked: true
            	},{
            		boxLabel: '제품',
            		width: 60,
            		name: 'ITEM_ACCOUNT' ,
            		inputValue: '10'
            	},{
            		boxLabel: '반제품',
            		width: 60,
            		name: 'ITEM_ACCOUNT' ,
            		inputValue: '20'
            	}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('ITEM_ACCOUNT').setValue(newValue.ITEM_ACCOUNT);
					}
				}
            },{
				xtype: 'radiogroup',
            	fieldLabel: '<t:message code="system.label.product.workorderstatus" default="작업지시현황"/>',
            	//id: 'WKORD_STATUS',
            	//name:'WKORD_STATUS',
            	labelWidth:90,
				items: [{
					boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
					width: 60,
					name: 'WKORD_STATUS',
					inputValue: '',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.product.process" default="진행"/>',
					width: 60,
					name: 'WKORD_STATUS',
					inputValue: '2'
				},{
					boxLabel: '<t:message code="system.label.product.closing" default="마감"/>',
					width: 60,
					name: 'WKORD_STATUS',
					inputValue: '8'
				},{
					boxLabel: '<t:message code="system.label.product.completion" default="완료"/>',
					width: 60,
					name: 'WKORD_STATUS' ,
					inputValue: '9'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('WKORD_STATUS').setValue(newValue.WKORD_STATUS);
					}
				}
			},{
				xtype: 'radiogroup',
        	 	fieldLabel: '출고상태',
        	  	//id: 'OUT_STATUS',
        	  	//name:'OUT_STATUS',
              	labelWidth:90,
				items: [{
					boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
					width: 60,
					name: 'OUT_STATUS',
					inputValue: '',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.product.process" default="진행"/>',
					width: 60,
					name: 'OUT_STATUS' ,
					inputValue: '3'
				},{
					boxLabel: '<t:message code="system.label.product.completion" default="완료"/>',
					width: 60,
					name: 'OUT_STATUS' ,
					inputValue: '9'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('OUT_STATUS').setValue(newValue.OUT_STATUS);
						UniAppManager.app.onQueryButtonDown();
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
		},
		setLoadRecord: function(record) {
			var me = this;
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});//End of var masterForm = Unilite.createSearchForm('searchForm', {

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
		       	fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
		       	name:'DIV_CODE',
		       	xtype: 'uniCombobox',
		       	comboType:'BOR120',
		       	allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('DIV_CODE', newValue);
					}
				}
	      	 },{
	      	 	fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
	      	 	xtype: 'uniDateRangefield',
	      	 	startFieldName: 'PRODT_START_DATE_FR',
				endFieldName: 'PRODT_START_DATE_TO',
	      	 	width: 315,
	      	 	startDate: UniDate.get('todayOfLastWeek'),
	      	 	endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						masterForm.setValue('PRODT_START_DATE_FR',newValue);
						//panelResult.getField('ISSUE_REQ_DATE_FR').validate();

                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		masterForm.setValue('PRODT_START_DATE_TO',newValue);
			    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();
			    	}
			    }
			},{
				xtype: 'radiogroup',
            	fieldLabel: '<t:message code="system.label.product.itemaccount" default="품목계정"/>',
            	//id: 'ITEM_ACCOUNT2',
            	//name:'ITEM_ACCOUNT',
            	labelWidth:90,
            	items: [{
            		boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
            		width: 60,
            		name: 'ITEM_ACCOUNT',
            		inputValue: '',
            		checked: true
            	},{
            		boxLabel: '제품',
            		width: 60,
            		name: 'ITEM_ACCOUNT' ,
            		inputValue: '10'
            	},{
            		boxLabel: '반제품',
            		width: 60,
            		name: 'ITEM_ACCOUNT' ,
            		inputValue: '20'
            	}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.getField('ITEM_ACCOUNT').setValue(newValue.ITEM_ACCOUNT);
					}
				}
            },{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType: 'WU',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('WORK_SHOP_CODE', newValue);
					}
				}
			},
				Unilite.popup('ITEM',{
					fieldLabel: '<t:message code="system.label.product.parentitemcode" default="모품목코드"/>',
					validateBlank:false,
					textFieldName:'PITEM_NAME',
					valueFieldName:'PITEM_CODE',
		        	listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								masterForm.setValue('PITEM_CODE', panelResult.getValue('PITEM_CODE'));
								masterForm.setValue('PITEM_NAME', panelResult.getValue('PITEM_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
							masterForm.setValue('PITEM_CODE', '');
							masterForm.setValue('PITEM_NAME', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
						}
					}
			}),{
				xtype: 'radiogroup',
            	fieldLabel: '<t:message code="system.label.product.workorderstatus" default="작업지시현황"/>',
            	//id: 'WKORD_STATUS',
            	//name:'WKORD_STATUS',
            	labelWidth:90,
				items: [{
					boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
					width: 60,
					name: 'WKORD_STATUS',
					inputValue: '',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.product.process" default="진행"/>',
					width: 60,
					name: 'WKORD_STATUS',
					inputValue: '2'
				},{
					boxLabel: '<t:message code="system.label.product.closing" default="마감"/>',
					width: 60,
					name: 'WKORD_STATUS',
					inputValue: '8'
				},{
					boxLabel: '<t:message code="system.label.product.completion" default="완료"/>',
					width: 60,
					name: 'WKORD_STATUS' ,
					inputValue: '9'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.getField('WKORD_STATUS').setValue(newValue.WKORD_STATUS);
					}
				}
			},{
				xtype: 'uniTextfield',
				name: 'WKORD_NUM',
				fieldLabel:'<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {
			      		masterForm.setValue('WKORD_NUM', newValue);
			     	}
			    }
			},
				Unilite.popup('ITEM',{
					fieldLabel: '<t:message code="system.label.product.materialitemcode" default="자재품목코드"/>',
					validateBlank:false,
					textFieldName: 'CITEM_NAME',
					valueFieldName: 'CITEM_CODE',
		        	listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								masterForm.setValue('CITEM_CODE', panelResult.getValue('CITEM_CODE'));
								masterForm.setValue('CITEM_NAME', panelResult.getValue('CITEM_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
							masterForm.setValue('CITEM_CODE', '');
							masterForm.setValue('CITEM_NAME', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
						}
					}
			}),{
				xtype: 'radiogroup',
        	 	fieldLabel: '출고상태',
        	  	//id: 'OUT_STATUS',
        	  	//name:'OUT_STATUS',
              	labelWidth:90,
				items: [{
					boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
					width: 60,
					name: 'OUT_STATUS',
					inputValue: '',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.product.process" default="진행"/>',
					width: 60,
					name: 'OUT_STATUS' ,
					inputValue: '3'
				},{
					boxLabel: '<t:message code="system.label.product.completion" default="완료"/>',
					width: 60,
					name: 'OUT_STATUS' ,
					inputValue: '9'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.getField('OUT_STATUS').setValue(newValue.OUT_STATUS);
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
	 *   Model 정의
	 * @type
	 */
	Unilite.defineModel('pmp142ukrvDetailModel', {
		fields: [
			{name: 'COMP_CODE'        	, text: 'COMP_CODE'		, type:'string'},
			{name: 'DIV_CODE'         	, text: '<t:message code="system.label.product.division" default="사업장"/>'      	, type:'string'},
			{name: 'WKORD_STATUS'     	, text:'<t:message code="system.label.product.status" default="상태"/>'     	, type:'string'},
			{name: 'WKORD_STATUS_NAME'	, text: '<t:message code="system.label.product.status" default="상태"/>'       		, type:'string'},
			{name: 'WORK_SHOP_CODE'   	, text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'   		, type:'string'},
			{name: 'WORK_SHOP_NAME'   	, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'      	, type:'string'},
			{name: 'WKORD_NUM'        	, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'  	, type:'string'},
			{name: 'PITEM_CODE'       	, text: '<t:message code="system.label.product.item" default="품목"/>'     	, type:'string'},
			{name: 'PITEM_NAME'       	, text: '<t:message code="system.label.product.itemnamespec" default="품명 / 규격"/>'    	, type:'string'},
			{name: 'OPITEM_NAME'      	, text: '<t:message code="system.label.product.itemname" default="품목명"/>'        	, type:'string'},
			{name: 'STOCK_UNIT'       	, text: '<t:message code="system.label.product.unit" default="단위"/>'        	, type:'string'},
			{name: 'WKORD_Q'          	, text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'    	, type:'uniQty'},
			{name: 'PRODT_START_DATE' 	, text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'    	, type:'uniDate'},
			{name: 'PRODT_END_DATE'   	, text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'		, type:'uniDate'},
			{name: 'CITEM_CODE'       	, text: '<t:message code="system.label.product.materialitemcode" default="자재품목코드"/>'  	, type:'string'},
			{name: 'CITEM_NAME'       	, text: '<t:message code="system.label.product.materialitemanamespec" default="자재품명/규격"/>'		, type:'string'},
			{name: 'OCITEM_NAME'      	, text: '자재 품명'    		, type:'string'},
			{name: 'CSTOCK_UNIT'      	, text: '<t:message code="system.label.product.unit" default="단위"/>'         	, type:'string'},
			{name: 'UNIT_Q'           	, text: '<t:message code="system.label.product.originunitqty" default="원단위량"/>'      	, type:'uniQty'},
			{name: 'ALLOCK_Q'         	, text: '<t:message code="system.label.product.allocationqty" default="예약량"/>'		 	, type:'uniQty'},
			{name: 'OUTSTOCK_REQ_DATE'	, text: '<t:message code="system.label.product.issuerequestdate" default="출고요청일"/>'    	, type:'uniDate'},
			{name: 'INOUT_GUBUN'        , text: '<t:message code="system.label.product.classfication" default="구분"/>'           , type:'string'},
			{name: 'GOOD_STOCK_Q'       , text: '요청창고재고'      , type:'uniQty'},
			{name: 'WH_CODE'          	, text: '요청창고코드'  	, type:'string'},
			{name: 'WH_CODE_NAME'     	, text: '<t:message code="system.label.product.requestwarehouse" default="요청창고"/>'    		, type:'string'},
			{name: 'OUT_METH'         	, text: '출고방법코드'  	, type:'string'},
			{name: 'OUT_METH_NAME'    	, text: '<t:message code="system.label.product.issuemethod" default="출고방법"/>'    		, type:'string'},
			{name: 'GOOD_STOCK_Q'     	, text: '요청창고재고'  	, type:'uniQty'},
			{name: 'OUTSTOCK_REQ_Q'   	, text: '<t:message code="system.label.product.issuerequestqty" default="출고요청량"/>'    	, type:'uniQty'},
			{name: 'OUTSTOCK_Q'       	, text: '<t:message code="system.label.product.issueqty" default="출고량"/>'        	, type:'uniQty'},
			{name: 'OVER_OUTSTOCK_Q'    , text: '<t:message code="system.label.product.exceptionissueinput" default="예외출고량입력"/>'		, type:'uniQty'},
			{name: 'PRODT_Q'          	, text: '<t:message code="system.label.product.productioninputqty" default="생산투입량"/>'    	, type:'uniQty'},
			{name: 'UN_OUTSTOCK_Q'    	, text: '<t:message code="system.label.product.unissuedqty" default="미출고량"/>'      	, type:'uniQty'},
			{name: 'UN_PRODT_Q'       	, text: '<t:message code="system.label.product.productionnotinputqty" default="생산미투입량"/>'  	, type:'uniQty'},
			{name: 'MINI_PACK_Q'      	, text: '<t:message code="system.label.product.minimumpackagingunit" default="최소포장단위"/>'  	, type:'string'},
			//Hidden: true
			{name: 'SORT_FLD'           , text: ' '    			, type:'string'},
			{name: 'INOUT_NUM'          , text: ' '    			, type:'uniQty'},
			{name: 'INOUT_SEQ'    		, text: ' '      		, type:'string'},
			{name: 'INOUT_DATE'       	, text: ' '  			, type:'uniDate'},
			{name: 'GUBUN'      		, text: ' '  			, type:'string'}
		]
	});		//End of Unilite.defineModel('pmp142ukrvModel', {

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var detailStore = Unilite.createStore('pmp142ukrvDetailStore', {
		model: 'pmp142ukrvDetailModel',
		autoLoad: false,
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: true,		// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
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
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
				config = {
						params: [paramMaster],
						success: function(batch, option) {

							masterForm.getForm().wasDirty = false;
							masterForm.resetDirtyStatus();
							console.log("set was dirty to false");
							UniAppManager.setToolbarButtons('save', false);
						 }
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('pmp142ukrvGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		groupField: 'WKORD_NUM'
	});

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
    var masterGrid = Unilite.createGrid('pmp142ukrvGrid', {
    	layout: 'fit',
        region:'center',
        uniOpt: {
			expandLastColumn: false,
		 	useRowNumberer: false,
		 	useContextMenu: false
        },
    	store: detailStore,
    	features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
    	    {id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true}
    	],
        columns: [{
        	text: '작업지시 내역',
        	columns:[
				{dataIndex: 'WKORD_NUM'				, width: 100,
	        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				       return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.product.subtotal" default="소계"/>', '<t:message code="system.label.product.total" default="총계"/>');
	            	}
	            },
			    {dataIndex: 'WKORD_STATUS_NAME'		, width: 53	},
			    {dataIndex: 'WORK_SHOP_NAME'		, width: 66 },
			    {dataIndex: 'PITEM_CODE'			, width: 66 },
			    {dataIndex: 'PITEM_NAME'			, width: 100},
			    {dataIndex: 'STOCK_UNIT'			, width: 53 },
			    {dataIndex: 'WKORD_Q'				, width: 80 },
			    {dataIndex: 'PRODT_START_DATE'		, width: 80 },
			    {dataIndex: 'PRODT_END_DATE'		, width: 82 }
			]},{
			text: '자재예약 내역',
        	columns: [
        		{dataIndex: 'CITEM_CODE'			, width: 100}
			]},{
			text: '자재예약 내역',
        	columns: [
			    {dataIndex: 'CITEM_NAME'			, width: 100 },
			    {dataIndex: 'CSTOCK_UNIT'			, width: 53	 },
			    {dataIndex: 'UNIT_Q'				, width: 80	 },
			    {dataIndex: 'ALLOCK_Q'				, width: 80	, summaryType: 'sum' }
			 ]},{
			text: '작업지시 내역',
        	columns: [
        		{dataIndex: 'OUTSTOCK_REQ_DATE'		, width: 80},
			    {dataIndex: 'WH_CODE_NAME'			, width: 80},
			    {dataIndex: 'OUT_METH_NAME'			, width: 80},
			    {dataIndex: 'INOUT_GUBUN'        	, width: 60},
				{dataIndex: 'GOOD_STOCK_Q'      	, width: 100 , summaryType: 'sum'},
        		{dataIndex: 'OUTSTOCK_REQ_Q'		, width: 100 , summaryType: 'sum'},
    			{dataIndex: 'OUTSTOCK_Q'			, width: 100 , summaryType: 'sum'},
    			{dataIndex: 'OVER_OUTSTOCK_Q'		, width: 93},
    			{dataIndex: 'PRODT_Q'				, width: 100 , summaryType: 'sum'},
    			{dataIndex: 'UN_OUTSTOCK_Q'			, width: 100 , summaryType: 'sum'},
    			{dataIndex: 'UN_PRODT_Q'			, width: 100 , summaryType: 'sum'},
    			{dataIndex: 'MINI_PACK_Q'			, width: 100}
    		]},
				{dataIndex: 'COMP_CODE'      		, width: 0		, hidden:true},
				{dataIndex: 'DIV_CODE'       		, width: 0		, hidden:true},
				{dataIndex: 'WKORD_STATUS'   		, width: 0		, hidden:true},
				{dataIndex: 'WORK_SHOP_CODE'		, width: 0		, hidden:true},
				{dataIndex: 'WH_CODE'        		, width: 0		, hidden:true},
				{dataIndex: 'OUT_METH'       		, width: 0		, hidden:true},
				{dataIndex: 'OPITEM_NAME'    		, width: 0		, hidden:true},
				{dataIndex: 'OCITEM_NAME'    		, width: 0		, hidden:true},
				{dataIndex: 'SORT_FLD'    			, width: 0		, hidden:true},
				{dataIndex: 'GUBUN'    				, width: 0		, hidden:true},
				{dataIndex: 'INOUT_NUM' 	   		, width: 100	, hidden:true},
				{dataIndex: 'INOUT_SEQ'    			, width: 0		, hidden:true},
				{dataIndex: 'INOUT_DATE'    		, width: 0		, hidden:true}

        ],
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
      			if(e.record.phantom == false) {
	        		if(UniUtils.indexOf(e.field, ['OVER_OUTSTOCK_Q']))
					{
						return true;
      				} else {
      					return false;
      				}
	        	}
        	}
       	}
    });

    Unilite.Main({
		id: 'pmp142ukrvApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			masterForm
		],
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['prev', 'next'], true);
			UniAppManager.setToolbarButtons(['newData', 'reset'], false); // 추가, 초기화 비활성화
			this.setDefault();
		},
		onQueryButtonDown: function() {
			masterForm.setAllFieldsReadOnly(false);
			detailStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			this.suspendEvents();
			masterForm.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			masterGrid.reset();

			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			detailStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				if(selRow.get('INOUT_NUM') == '') {
					//alert('');
				} else {
					masterGrid.deleteSelectedRow();
				}
			} else {//if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				if(selRow.get('INOUT_NUM') == '') {
					//alert('');
				} else {
					masterGrid.deleteSelectedRow();
				}
			}
		},
		rejectSave: function() {
			var rowIndex = masterGrid.getSelectedRowIndex();
			masterGrid.select(rowIndex);
			detailStore.rejectChanges();

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
			detailStore.onStoreActionEnable();

		},
		confirmSaveData: function(config)	{
			var fp = Ext.getCmp('pmp142ukrvFileUploadPanel');
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
        	masterForm.setValue('PRODT_START_DATE_FR',UniDate.get('todayOfLastWeek'));
        	masterForm.setValue('PRODT_START_DATE_TO',new Date());
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);

		}
	});
}
</script>