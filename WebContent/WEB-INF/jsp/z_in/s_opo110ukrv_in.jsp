<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_opo110ukrv_in"  >
<t:ExtComboStore comboType="BOR120" pgmId="s_opo110ukrv_in"/> 				<!-- 사업장 -->
//<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />	<!--창고-->
<t:ExtComboStore comboType="OU" storeId="whList" />   					<!--입고창고(사용여부 Y) -->
<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />	<!--창고Cell-->
//<t:ExtComboStore items="${COMBO_WH_LIST2}" storeId="whList2"/>       <!--창고-->
<t:ExtComboStore comboType="OU" storeId="whList2" />   					<!--출고창고(사용여부 Y) -->
<t:ExtComboStore items="${COMBO_WH_CELL_LIST2}" storeId="whCellList2" /><!--창고Cell-->
<t:ExtComboStore comboType="AU" comboCode="B024" /> 					<!--담당자-->
<t:ExtComboStore comboType="AU" comboCode="B013" /> 					<!--단위-->
<t:ExtComboStore comboType="AU" comboCode="B021" /> 					<!--양불구분-->
<t:ExtComboStore comboType="AU" comboCode="B020" /> 					<!--품목계정-->
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

var SearchInfoWindow; // 검색창
var outDivCode = UserInfo.divCode;
var MoveReleaseWindow; // 이동출고 참조
var gsWhCode = '';		//창고코드

var BsaCodeInfo = {	// 컨트롤러에서 값을 받아옴
	// 입고내역 셋팅(메인)
	gsInvstatus: 		'${gsInvstatus}',
	gsMoneyUnit: 		'${gsMoneyUnit}',
	gsManageLotNoYN: 	'${gsManageLotNoYN}',
	gsSumTypeLot:		'${gsSumTypeLot}',
	gsSumTypeCell:		'${gsSumTypeCell}',
	gsAutotype:			'${gsAutotype}'
};

var sumtypeCell = true; //재고합산유형 : 창고 Cell 합산에 따라 컬럼설정
if(BsaCodeInfo.gsSumTypeCell =='Y') {
    sumtypeCell = false;
}
//var output =''; 	// 입고내역 셋팅 값 확인 alert
//for(var key in BsaCodeInfo){
//	output += key + '  :  ' + BsaCodeInfo[key] + '\n';
//}
//alert(output);

function appMain() {
	var Autotype = true;
	if(BsaCodeInfo.gsAutotype =='N')	{
		Autotype = false;
	}
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_opo110ukrv_inService.selectMaster',
			update: 's_opo110ukrv_inService.updateDetail',
			create: 's_opo110ukrv_inService.insertDetail',
			destroy: 's_opo110ukrv_inService.deleteDetail',
			syncAll: 's_opo110ukrv_inService.saveAll'
		}
	});

	var panelSearch = Unilite.createSearchPanel('s_opo110ukrv_inMasterForm',{		// 메인
		title: '<t:message code="system.label.inventory.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.inventory.basisinfo" default="기본정보"/>',
			itemId: 'search_panel1',
       		layout: {type: 'uniTable', columns: 1},
       		defaultType: 'uniTextfield',
	    	items: [{
        		fieldLabel: '<t:message code="system.label.inventory.receiptdivision" default="입고사업장"/>',
        		name: 'DIV_CODE',
    			value: UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
				holdable: 'hold',
				child:'WH_CODE',
        		allowBlank:false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
        	},{
                fieldLabel: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>',
                name: 'WH_CODE',
                xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('whList'),
                child: 'WH_CELL_CODE',
                holdable: 'hold',
                listeners: {
                    change: function(combo, newValue, oldValue, eOpts) {
                        panelResult.setValue('WH_CODE', newValue);
                    }
                }
            },{
                fieldLabel: '감마의뢰번호',
                name:'INOUT_NUM2',
                xtype: 'uniTextfield',
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('INOUT_NUM2', newValue);
                    }
                }
            },{
                fieldLabel: '<t:message code="system.label.inventory.receiptwarehousecell2" default="입고창고Cell"/>',
                name: 'WH_CELL_CODE',
                xtype:'uniCombobox',
                hidden: true,
                store: Ext.data.StoreManager.lookup('whCellList'),
                holdable: 'hold',
                listeners: {
                    change: function(combo, newValue, oldValue, eOpts) {
                        panelResult.setValue('WH_CELL_CODE', newValue);
                    }
                }
            }
        	,{
				fieldLabel: '<t:message code="system.label.inventory.receiptdate" default="입고일"/>',
				name: 'INOUT_DATE',
				xtype: 'uniDatefield',
				value: UniDate.get('today'),
				holdable: 'hold',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_DATE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.receiptno" default="입고번호"/>',
				name:'INOUT_NUM',
				xtype: 'uniTextfield',
				readOnly: Autotype,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_NUM', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.charger" default="담당자"/>',
				name:'INOUT_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B024',
				holdable: 'hold',
    			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_PRSN', newValue);
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
					alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
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
	}); //End of var masterForm = Unilite.createSearchForm('searchForm',{

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
        		fieldLabel: '<t:message code="system.label.inventory.receiptdivision" default="입고사업장"/>',
        		name		: 'DIV_CODE',
    			value		: UserInfo.divCode,
        		xtype		: 'uniCombobox',
        		comboType	: 'BOR120',
				child		: 'WH_CODE',
				holdable	: 'hold',
        		allowBlank:false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
//						var field = masterForm.getField('INOUT_PRSN');
//						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
        	},
        	{
                fieldLabel: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>',
                name: 'WH_CODE',
                xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('whList'),
                child: 'WH_CELL_CODE',
                holdable: 'hold',
                allowBlank:false,
                listeners: {
                    change: function(combo, newValue, oldValue, eOpts) {
                       panelSearch.setValue('WH_CODE', newValue);
                    }
                }
            },
			{
				fieldLabel: '<t:message code="system.label.inventory.receiptdate" default="입고일"/>',
				name: 'INOUT_DATE',
				xtype: 'uniDatefield',
				value: UniDate.get('today'),
				holdable: 'hold',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('INOUT_DATE', newValue);
					}
				}
			},
			{
				fieldLabel: '<t:message code="system.label.inventory.charger" default="담당자"/>',
				name:'INOUT_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B024',
				holdable: 'hold',
    			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('INOUT_PRSN', newValue);
					}
				}
			},{
                fieldLabel: '감마의뢰번호',
                name:'INOUT_NUM2',
                xtype: 'uniTextfield',
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('INOUT_NUM2', newValue);
                    },
                    specialkey: function(elm, e){
                    	if(!panelResult.getInvalidMessage()) return;   //필수체크
                    	if(!Ext.isEmpty(panelResult.getValue('INOUT_NUM2'))){
                    		var param= panelSearch.getValues();
                            if (e.getKey() == e.ENTER) {
                            	s_opo110ukrv_inService.selectDetail3(param, function(provider, response) {
                                    if(!Ext.isEmpty(provider)){                            
                                        Ext.each(provider, function(record,i) {
                                            UniAppManager.app.onNewDataButtonDown();
                                            masterGrid.setEstiData(record);
                                        });
                                    }
                            	});
                            	panelSearch.setValue('INOUT_NUM2', '');
                            	panelResult.setValue('INOUT_NUM2', '');
                            	panelResult.getField('INOUT_NUM2').focus();
                                //UniAppManager.app.onQueryButtonDown();
                            }
                    	}
                    }
                }
            },
			{
                fieldLabel: '<t:message code="system.label.inventory.receiptwarehousecell2" default="입고창고Cell"/>',
                name: 'WH_CELL_CODE',
                xtype:'uniCombobox',
                hidden : true,
                store: Ext.data.StoreManager.lookup('whCellList'),
                holdable: 'hold',
                listeners: {
                    change: function(combo, newValue, oldValue, eOpts) {
                        panelSearch.setValue('WH_CELL_CODE', newValue);
                    }
                }
            },
            {
				fieldLabel: '<t:message code="system.label.inventory.receiptno" default="입고번호"/>',
				name:'INOUT_NUM',
				xtype: 'uniTextfield',				
				readOnly: Autotype,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('INOUT_NUM', newValue);
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
					alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
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

	var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {		// 검색 팝업창
		layout: {type: 'uniTable', columns : 2},
	    trackResetOnLoad: true,
	    items: [{
			    fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
			    name:'DIV_CODE',
		        allowBlank: false,
			    xtype: 'uniCombobox',
			    comboType:'BOR120',
			    holdable: 'hold',
				child:'WH_CODE',
			    value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
//						var field = orderNoSearch.getField('INOUT_PRSN');
//						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
					}
				}
		   },{
				fieldLabel: '<t:message code="system.label.inventory.receiptdate" default="입고일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_INOUT_DATE',
				endFieldName: 'TO_INOUT_DATE',
				width: 350,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today')
			},
			Unilite.popup('DIV_PUMOK',{
		        	fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
		        	valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
		        	listeners: {
						onClear: function(type)	{
							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
		   }),{
				fieldLabel: '<t:message code="system.label.inventory.charger" default="담당자"/>',
				name:'INOUT_PRSN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B024',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			}
		]
  	}); // createSearchForm

    var otherOrderSearch = Unilite.createSearchForm('otherorderForm', {		//이동출고 참조
    	layout: {type : 'uniTable', columns : 2},
        items:[
        	{
			    fieldLabel: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>',
			    name:'DIV_CODE',
			    xtype: 'uniCombobox',
			    comboType:'BOR120',
			    allowBlank:false,
				child:'WH_CODE',
			    holdable: 'hold',
			    value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
//							var field = otherOrderSearch.getField('INOUT_PRSN');
//							field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					}
				}
		   },
		   {
				fieldLabel: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>',
				name:'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList')
			},{
				fieldLabel: '<t:message code="system.label.inventory.charger" default="담당자"/>',
				name:'INOUT_PRSN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B024',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.issueperiod" default="출고기간"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_INOUT_DATE',
				endFieldName: 'TO_INOUT_DATE',
				width: 350,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today')
			},{
				fieldLabel: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>',
				name:'IN_WH_CODE',
				xtype: 'uniTextfield',
				hidden:true
			}
		]
    });
    //창고에 따른 창고cell 콤보load..
    var cbStore1 = Unilite.createStore('s_opo110ukrv_inComboStore1',{
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

    //창고에 따른 창고cell 콤보load..
    var cbStore2 = Unilite.createStore('s_opo110ukrv_inComboStore2',{
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
	/**
	 *   Model 정의
	 * @type
	 */
	Unilite.defineModel('s_opo110ukrv_inModel', {		// 메인
	    fields: [
	    	{name: 'INOUT_NUM'				,text: '<t:message code="system.label.inventory.tranno" default="수불번호"/>'					,type: 'string'},
	    	{name: 'INOUT_SEQ'				,text: '<t:message code="system.label.inventory.seq" default="순번"/>'						,type: 'int', allowBlank: false},
	    	{name: 'INOUT_TYPE'				,text: '<t:message code="system.label.inventory.trantype1" default="수불타입"/>'					,type: 'string'},
	    	{name: 'INOUT_METH'				,text: '<t:message code="system.label.inventory.tranmethod" default="수불방법"/>'					,type: 'string'},
	    	{name: 'INOUT_TYPE_DETAIL'		,text: '<t:message code="system.label.inventory.trantype" default="수불유형"/>'					,type: 'string'},
//	    	{name: 'DEPT_CODE'				,text: '<t:message code="system.label.inventory.department" default="부서"/>'					,type: 'string'},
//	    	{name: 'DEPT_NAME'				,text: '<t:message code="system.label.inventory.departmentname" default="부서명"/>'					,type: 'string'},
	    	{name: 'ITEM_CODE'				,text: '<t:message code="system.label.inventory.item" default="품목"/>'					,type: 'string', allowBlank: false},
	    	{name: 'ITEM_NAME'				,text: '<t:message code="system.label.inventory.itemname" default="품목명"/>'					,type: 'string'},
	    	{name: 'SPEC'					,text: '<t:message code="system.label.inventory.spec" default="규격"/>'						,type: 'string'},
	    	{name: 'STOCK_UNIT'				,text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>'					,type: 'string', displayField: 'value'},
	    	{name: 'DIV_CODE'				,text: '<t:message code="system.label.inventory.receiptdivision" default="입고사업장"/>'					,type: 'string', allowBlank: false, child: 'WH_CODE'},
	    	{name: 'WH_CODE'                ,text: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>'                  ,type: 'string', store: Ext.data.StoreManager.lookup('whList'), allowBlank: false, child: 'WH_CELL_CODE'},
            {name: 'WH_CELL_CODE'           ,text: '<t:message code="system.label.inventory.receiptwarehousecell2" default="입고창고Cell"/>'              , type: 'string', allowBlank: sumtypeCell, store: Ext.data.StoreManager.lookup('whCellList'), parentNames:['WH_CODE','DIV_CODE']},
	    	{name: 'INOUT_DATE'				,text: '<t:message code="system.label.inventory.transdate" default="수불일"/>'		     	    ,type: 'uniDate'},
	    	{name: 'INOUT_CODE_TYPE'		,text: '<t:message code="system.label.inventory.tranplacedivision" default="수불처구분"/>'					,type: 'string'},
	    	{name: 'TO_DIV_CODE'			,text: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>'					,type: 'string', xtype: 'uniCombobox', comboType: 'BOR120', allowBlank: false, child: 'INOUT_CODE'},
	    	{name: 'INOUT_CODE'             ,text: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>'                  ,type: 'string', store: Ext.data.StoreManager.lookup('whList2'), allowBlank: false, child: 'INOUT_CODE_DETAIL'},
            {name: 'INOUT_CODE_DETAIL'      ,text: '<t:message code="system.label.inventory.issuewarehousecell" default="출고창고Cell"/>'              ,type: 'string', allowBlank: sumtypeCell, store: Ext.data.StoreManager.lookup('whCellList2'), parentNames:['INOUT_CODE','TO_DIV_CODE']},
	    	//{name: 'INOUT_NAME'      		,text: '<t:message code="system.label.inventory.issuewarehousecell" default="출고창고Cell"/>'				,type: 'string'},
	    	{name: 'ITEM_STATUS'			,text: '<t:message code="system.label.inventory.gooddefecttype" default="양불구분"/>'					,type: 'string', comboType: 'AU', comboCode: 'B021', allowBlank: false},
	    	{name: 'INOUT_Q'				,text: '<t:message code="system.label.inventory.receiptqty" default="입고량"/>'					,type: 'uniQty', allowBlank: false},
	    	{name: 'INOUT_FOR_P'			,text: '<t:message code="system.label.inventory.foreigntranprice" default="외화수불단가"/>'				,type: 'uniUnitPrice'},
	    	{name: 'INOUT_FOR_O'			,text: '<t:message code="system.label.inventory.foreigntranamount" default="외화수불금액"/>'				,type: 'uniFC'},
	    	{name: 'EXCHG_RATE_O'			,text: '<t:message code="system.label.inventory.exchangerate" default="환율"/>'						,type: 'string'},
	    	{name: 'INOUT_P'				,text: '<t:message code="system.label.inventory.tranprice" default="수불단가"/>'					,type: 'uniUnitPrice'},
	    	{name: 'INOUT_I'				,text: '<t:message code="system.label.inventory.tranamount" default="수불금액"/>'					,type: 'uniPrice'},
	    	{name: 'MONEY_UNIT'				,text: '<t:message code="system.label.inventory.currencyunit" default="화폐단위"/>'					,type: 'string'},
	    	{name: 'INOUT_PRSN'				,text: '<t:message code="system.label.inventory.charger" default="담당자"/>'					    ,type: 'string', comboType: 'AU', comboCode: 'B024'},
	    	{name: 'BASIS_NUM'				,text: '<t:message code="system.label.inventory.issueno" default="출고번호"/>'					,type: 'string', allowBlank: false},
	    	{name: 'BASIS_SEQ'				,text: '<t:message code="system.label.inventory.basisseq" default="근거순번"/>'					,type: 'string'},
	    	{name: 'LOT_NO'					,text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>'					    ,type: 'string'},
            {name: 'LOT_YN'                 ,text: '<t:message code="system.label.inventory.lotmanageyn" default="LOT관리여부"/>'                ,type: 'string', comboType:'AU', comboCode:'A020'},
	    	{name: 'REMARK'					,text: '<t:message code="system.label.inventory.remarks" default="비고"/>'					    ,type: 'string'},
	    	{name: 'PROJECT_NO'				,text: '<t:message code="system.label.inventory.projectno" default="프로젝트번호"/>'				,type: 'string'},
	    	{name: 'UPDATE_DB_USER'			,text: '<t:message code="system.label.inventory.writer" default="작성자"/>'					    ,type: 'string'},
	    	{name: 'UPDATE_DB_TIME'			,text: '<t:message code="system.label.inventory.writtendate" default="작성일"/>'					,type: 'string'},
	    	{name: 'COMP_CODE'				,text: '<t:message code="system.label.inventory.companycode" default="법인코드"/>'					,type: 'string'},
	    	{name: 'ITEM_ACCOUNT'			,text: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>'					,type: 'string', comboType: 'AU', comboCode: 'B020'},
		    {name: 'PURCHASE_CUSTOM_CODE'	,text: '<t:message code="system.label.inventory.purchaseplace" default="매입처"/>'					,type: 'string'},
		    {name: 'PURCHASE_TYPE'			,text: '<t:message code="system.label.inventory.purchasecondition" default="매입조건"/>'					,type: 'string'},
		    {name: 'SALES_TYPE'				,text: '<t:message code="system.label.inventory.salestype2" default="판매형태"/>'					,type: 'string'},
		    {name: 'PURCHASE_RATE'			,text: '<t:message code="system.label.inventory.purchaserate" default="매입율"/>'					    ,type: 'string'},
		    {name: 'PURCHASE_P'				,text: '<t:message code="system.label.inventory.purchaseprice" default="매입가"/>'					    ,type: 'uniPrice'},
		    {name: 'SALE_P'					,text: '<t:message code="system.label.inventory.price" default="단가"/>'						,type: 'uniUnitPrice'},
		    {name: 'BOX_Q'                  ,text: '<t:message code="system.label.sales.boxqty" default="박스수량"/>'                    , type: 'int', format:'0,000'},
            {name: 'TRNS_RATE'              ,text: '<t:message code="system.label.product.boxrate" default="박스입수"/>'                    , type: 'int', format:'0,000'}

		]
	});

	Unilite.defineModel('orderNoMasterModel', {		// 검색조회창
	    fields: [
	    	{name: 'ITEM_CODE'				, text: '<t:message code="system.label.inventory.item" default="품목"/>'				, type: 'string'},
	    	{name: 'ITEM_NAME'				, text: '<t:message code="system.label.inventory.itemname" default="품목명"/>'				, type: 'string'},
	    	{name: 'SPEC'					, text: '<t:message code="system.label.inventory.spec" default="규격"/>'				, type: 'string'},
	    	{name: 'STOCK_UNIT'				, text: '<t:message code="system.label.inventory.unit" default="단위"/>'				, type: 'string', displayField: 'value'},
	    	{name: 'INOUT_DATE'				, text: '<t:message code="system.label.inventory.receiptdate" default="입고일"/>'				, type: 'uniDate'},
	    	{name: 'INOUT_Q'				, text: '<t:message code="system.label.inventory.qty" default="수량"/>'				, type: 'uniQty'},
	    	{name: 'DIV_CODE'				, text: '<t:message code="system.label.inventory.receiptdivision" default="입고사업장"/>'			, type: 'string'},
	    	{name: 'WH_CODE'				, text: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>'				, type: 'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('whList')},
	    	{name: 'WH_CELL_CODE'			, text: '<t:message code="system.label.inventory.receiptwarehousecell2" default="입고창고Cell"/>'			, type: 'string'},
	    	{name: 'TO_DIV_CODE'			, text: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>'			, type: 'string'},
	    	{name: 'TO_DIV_NAME'			, text: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>'			, type: 'string'},
	    	{name: 'INOUT_CODE'				, text: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>'				, type: 'string'},
	    	{name: 'INOUT_CODE_DETAIL'		, text: '<t:message code="system.label.inventory.issuewarehousecell" default="출고창고Cell"/>'			, type: 'string'},
	    	{name: 'LOT_NO'					, text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>'			, type: 'string'},
	    	{name: 'INOUT_PRSN'				, text: '<t:message code="system.label.inventory.charger" default="담당자"/>'				, type: 'string', comboType: 'AU', comboCode: 'B024'},
	    	{name: 'INOUT_NUM'				, text: '<t:message code="system.label.inventory.receiptno" default="입고번호"/>'				, type: 'string'}
		]
	});

	Unilite.defineModel('s_opo110ukrv_inOTHERModel', {	//이동출고 참조
	    fields: [
			{name: 'ITEM_CODE'					, text: '<t:message code="system.label.inventory.item" default="품목"/>'    			, type: 'string'},
			{name: 'ITEM_NAME'					, text: '<t:message code="system.label.inventory.itemname" default="품목명"/>'    				, type: 'string'},
			{name: 'SPEC'						, text: '<t:message code="system.label.inventory.spec" default="규격"/>'    				, type: 'string'},
			{name: 'STOCK_UNIT'					, text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>'    			, type: 'string', displayField: 'value'},
			{name: 'INOUT_DATE'					, text: '<t:message code="system.label.inventory.issuedate" default="출고일"/>'    			, type: 'uniDate'},
			{name: 'DIV_CODE'					, text: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>'    		, type: 'string', xtype: 'uniCombobox', comboType: 'BOR120'},
			{name: 'WH_CODE'					, text: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>'    		, type: 'string'},
			{name: 'WH_NAME'					, text: '<t:message code="system.label.inventory.issuewarehousename" default="출고창고명"/>'    			, type: 'string'},
			{name: 'WH_CELL_CODE'				, text: '<t:message code="system.label.inventory.issuewarehousecell" default="출고창고Cell"/>'    	, type: 'string'},
			{name: 'WH_CELL_NAME'				, text: '<t:message code="system.label.inventory.issuewarehousecellname" default="출고창고Cell명"/>'    		, type: 'string'},
			{name: 'IN_ITEM_STATUS'				, text: '<t:message code="system.label.inventory.gooddefecttype" default="양불구분"/>'    			, type: 'string', comboType: 'AU', comboCode: 'B021'},
			{name: 'INOUT_Q'					, text: '<t:message code="system.label.inventory.issueqty" default="출고량"/>'    			, type: 'uniQty'},
			{name: 'INOUT_NUM'					, text: '<t:message code="system.label.inventory.issueno" default="출고번호"/>'    			, type: 'string'},
			{name: 'INOUT_SEQ'					, text: '<t:message code="system.label.inventory.issueseq" default="출고순번"/>'    			, type: 'string'},
			{name: 'TO_DIV_CODE'				, text: '<t:message code="system.label.inventory.receiptdivision" default="입고사업장"/>'    		, type: 'string'},
			{name: 'INOUT_CODE'					, text: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>'    			, type: 'string'},
			{name: 'INOUT_CODE_DETAIL'			, text: '<t:message code="system.label.inventory.receiptwarehousecell2" default="입고창고Cell"/>'    		, type: 'string'},
			{name: 'INOUT_P'					, text: '<t:message code="system.label.inventory.price" default="단가"/>'    				, type: 'uniUnitPrice'},
			{name: 'INOUT_I'					, text: '<t:message code="system.label.inventory.amount" default="금액"/>'    				, type: 'uniPrice'},
			{name: 'MONEY_UNIT'					, text: '<t:message code="system.label.inventory.currencyunit" default="화폐단위"/>'    			, type: 'string'},
			{name: 'INOUT_FOR_P'				, text: '<t:message code="system.label.inventory.foreigncurrencyunit" default="외화단가"/>'    			, type: 'uniUnitPrice'},
			{name: 'INOUT_FOR_O'				, text: '<t:message code="system.label.inventory.foreigncurrencyamount" default="외화금액"/>'    			, type: 'uniFC'},
			{name: 'EXCHG_RATE_O'				, text: '<t:message code="system.label.inventory.exchangerate" default="환율"/>'    				, type: 'string'},
			{name: 'LOT_NO'						, text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>'    			, type: 'string'},
			{name: 'REMARK'						, text: '<t:message code="system.label.inventory.remarks" default="비고"/>'    				, type: 'string'},
			{name: 'PROJECT_NO'                 , text: '<t:message code="system.label.inventory.projectno" default="프로젝트번호"/>'          , type: 'string'},
			{name: 'ITEM_ACCOUNT'				, text: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>'    			, type: 'string'},
		    {name: 'PURCHASE_CUSTOM_CODE'		, text: '<t:message code="system.label.inventory.purchaseplace" default="매입처"/>'			, type: 'string'},
		    {name: 'PURCHASE_TYPE'				, text: '<t:message code="system.label.inventory.purchasecondition" default="매입조건"/>'				, type: 'string'},
		    {name: 'SALES_TYPE'					, text: '<t:message code="system.label.inventory.salestype2" default="판매형태"/>'				, type: 'string'},
		    {name: 'PURCHASE_RATE'				, text: '<t:message code="system.label.inventory.purchaserate" default="매입율"/>'				, type: 'string'},
		    {name: 'PURCHASE_P'					, text: '<t:message code="system.label.inventory.purchaseprice" default="매입가"/>'				, type: 'uniPrice'},
		    {name: 'SALE_P'						, text: '<t:message code="system.label.inventory.price" default="단가"/>'					, type: 'uniUnitPrice'},
		    {name: 'BOX_Q'                      ,text: '<t:message code="system.label.sales.boxqty" default="박스수량"/>'                    , type: 'int', format:'0,000'},
            {name: 'TRNS_RATE'                  ,text: '<t:message code="system.label.product.boxrate" default="박스입수"/>'                    , type: 'int', format:'0,000'}
		]
	});

	var directMasterStore1 = Unilite.createStore('s_opo110ukrv_inMasterStore1',{		// 메인
		model: 's_opo110ukrv_inModel',
		uniOpt : {
            	isMaster: true,		// 상위 버튼 연결
            	editable: true,		// 수정 모드 사용
            	deletable: true,	// 삭제 가능 여부
	            useNavi : false		// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
		loadStoreRecords: function() {
			var param= panelSearch.getValues();
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
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
                if(record.get('LOT_YN') == 'Y' && Ext.isEmpty(record.get('LOT_NO'))){
                    alert((index + 1) + '<t:message code="system.message.inventory.message025" default="행의 입력값을 확인해 주세요."/>' + 'LOT NO:'+'<t:message code="system.message.inventory.datacheck003" default="필수입력 항목입니다."/>');
                    isErr = true;
                    return false;
                }
            });
            if(isErr) return false;

			var inoutNum = panelSearch.getValue('INOUT_NUM');
			Ext.each(list, function(record, index) {
				if(record.data['INOUT_NUM'] != inoutNum) {
					record.set('INOUT_NUM', inoutNum);
				}
			})
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

						var master = batch.operations[0].getResultSet();
                        panelSearch.setValue("INOUT_NUM", master.INOUT_NUM);
                        panelResult.setValue("INOUT_NUM", master.INOUT_NUM);
                        var inoutNum = panelSearch.getValue('INOUT_NUM');
                        Ext.each(list, function(record, index) {
                            if(record.data['INOUT_NUM'] != inoutNum) {
                                record.set('INOUT_NUM', inoutNum);
                            }
                        })

                        if(directMasterStore1.getCount() == 0){
                            UniAppManager.app.onResetButtonDown();
                        }else{
                            UniAppManager.app.onQueryButtonDown();
                        }

						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('s_opo110ukrv_inGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});		// End of var directMasterStore1 = Unilite.createStore('s_opo110ukrv_inMasterStore1',{

	var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {	// 검색 팝업창
			model: 'orderNoMasterModel',
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
                	read: 's_opo110ukrv_inService.selectDetail'
                }
            },
            loadStoreRecords: function() {
			var param= orderNoSearch.getValues();
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(orderNoSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log(param);
			this.load({
				params : param
			});
		}
	});		// End of var directMasterStore1 = Unilite.createStore('s_opo110ukrv_inMasterStore1',{

	var otherOrderStore = Unilite.createStore('s_opo110ukrv_inOtherOrderStore', {//이동출고 참조
			model: 's_opo110ukrv_inOTHERModel',
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
                	read: 's_opo110ukrv_inService.selectDetail2'
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

			   								if((record.data['BASIS_NUM'] == item.data['INOUT_NUM'])
			   								&& (record.data['BASIS_SEQ'] == item.data['INOUT_SEQ'])
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
				var param= otherOrderSearch.getValues();
				var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
				var deptCode = UserInfo.deptCode;	//부서코드
				if(authoInfo == "5" && Ext.isEmpty(otherOrderSearch.getValue('DEPT_CODE'))){
					param.DEPT_CODE = deptCode;
				}
				console.log( param );
				this.load({
					params : param
				});
			}
	});
    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */

    var masterGrid = Unilite.createGrid('s_opo110ukrv_inGrid', {		// 메인
    	layout : 'fit',
    	region:'center',
        store : directMasterStore1,
        uniOpt: {
		 	expandLastColumn: true,
		 	useRowNumberer: false,
		 	useContextMenu: true
        },
        tbar: [{
                    itemId: 'MoveReleaseBtn',
                    text: '<div style="color: blue">감마의뢰참조</div>',
                    handler: function() {
                        if(!panelResult.getInvalidMessage()) return;   //필수체크
                        openMoveReleaseWindow();
                    }
                }
		],
    	features: [
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: false}
    	],
    	store: directMasterStore1,
        columns: [
			{dataIndex: 'INOUT_SEQ'				, width: 60},
			{dataIndex: 'TO_DIV_CODE'			, width: 110, hidden: true},
			{dataIndex: 'INOUT_CODE'			, width: 100, hidden: true},
			{dataIndex: 'INOUT_CODE_DETAIL'		, width: 100, hidden: sumtypeCell},
			{dataIndex: 'INOUT_NUM'				, width: 100, hidden: true},
			{dataIndex: 'INOUT_TYPE'			, width: 100, hidden: true},
			{dataIndex: 'INOUT_METH'			, width: 100, hidden: true},
			{dataIndex: 'INOUT_TYPE_DETAIL'		, width: 100, hidden: true},
			{dataIndex: 'ITEM_CODE'                      , width: 120,
                editor: Unilite.popup('DIV_PUMOK_G', {
                                    textFieldName: 'ITEM_CODE',
                                    DBtextFieldName: 'ITEM_CODE',
                                    extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
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
                                                },
                                                applyextparam: function(popup){
                                                    popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                                                }
                                        }
                     })
            },
            {dataIndex: 'ITEM_NAME'                     , width: 200,
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
                                                },
                                                applyextparam: function(popup){
                                                    popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                                                }
                                        }
                    })
            },
            {dataIndex: 'LOT_YN'                , width: 120, hidden: true },
            {dataIndex: 'LOT_NO'                , width: 120,
                editor: Unilite.popup('LOTNO_G', {
                	    autoPopup: true,
                        textFieldName: 'LOTNO_CODE',
                        DBtextFieldName: 'LOTNO_CODE',
						autoPopup: true,
                        listeners: {'onSelected': {
                            fn: function(records, type) {
                                    var rtnRecord;
                                    Ext.each(records, function(record,i) {
                                        if(i==0){
                                            rtnRecord = masterGrid.uniOpt.currentRecord
                                        }else{
                                            rtnRecord = masterGrid.getSelectedRecord()
                                        }
                                    });
                                },
                            scope: this
                            },
                            'onClear': function(type) {
                                masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
                            },
                            applyextparam: function(popup){
                                var record = masterGrid.getSelectedRecord();
                                var divCode = panelSearch.getValue('DIV_CODE');
                                var itemCode = record.get('ITEM_CODE');
                                var itemName = record.get('ITEM_NAME');
                                var whCode = record.get('WH_CODE');
                                popup.setExtParam({'DIV_CODE': divCode, 'ITEM_CODE': itemCode, 'ITEM_NAME': itemName, 'S_WH_CODE': whCode});
                            }
                        }
                })
            },

			{dataIndex: 'SPEC'					, width: 120},
			{dataIndex: 'STOCK_UNIT'			, width: 100, displayField: 'value'},
			{dataIndex: 'DIV_CODE'				, width: 100, hidden: true},
			{dataIndex: 'WH_CODE'				, width: 100, hidden: true},
			{dataIndex: 'WH_CELL_CODE'			, width: 100, hidden: sumtypeCell},
			{dataIndex: 'INOUT_DATE'			, width: 100, hidden: true},
			{dataIndex: 'INOUT_CODE_TYPE'		, width: 100, hidden: true},
			//{dataIndex: 'INOUT_NAME'			, width: 100},
			{dataIndex: 'INOUT_NAME_DETAIL'		, width: 93, hidden: true},
			{dataIndex: 'ITEM_STATUS'			, width: 100},
			{dataIndex: 'INOUT_Q'				, width: 100},
			{dataIndex: 'TRNS_RATE'             , width: 100},
			{dataIndex: 'BOX_Q'                 , width: 100},
			{dataIndex: 'INOUT_FOR_P'			, width: 100, hidden: true},
			{dataIndex: 'INOUT_FOR_O'			, width: 100, hidden: true},
			{dataIndex: 'EXCHG_RATE_O'			, width: 100, hidden: true},
			{dataIndex: 'INOUT_P'				, width: 100, hidden: true},
			{dataIndex: 'INOUT_I'				, width: 100, hidden: true},
			{dataIndex: 'MONEY_UNIT'			, width: 100, hidden: true},
			{dataIndex: 'INOUT_PRSN'			, width: 100},
			{dataIndex: 'BASIS_NUM'				, width: 120, hidden: true},
			{dataIndex: 'BASIS_SEQ'				, width: 100, hidden: true},
			{dataIndex: 'REMARK'				, width: 66},
			{dataIndex: 'PROJECT_NO'			, width: 100},
			{dataIndex: 'UPDATE_DB_USER'		, width: 100, hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'		, width: 100, hidden: true},
			{dataIndex: 'COMP_CODE'				, width: 100, hidden: true},
			{dataIndex: 'ITEM_ACCOUNT'			, width: 100, hidden: true},
			{dataIndex: 'PURCHASE_CUSTOM_CODE'			, width: 100, hidden: true},
			{dataIndex: 'PURCHASE_TYPE'					, width: 100, hidden: true},
			{dataIndex: 'SALES_TYPE'					, width: 100, hidden: true},
			{dataIndex: 'PURCHASE_RATE'					, width: 100, hidden: true},
			{dataIndex: 'PURCHASE_P'					, width: 100, hidden: true},
			{dataIndex: 'SALE_P'						, width: 100, hidden: true}
		],

		listeners: {
			afterrender: function(grid) {	//useContextMenu:true 설정으로 툴바 우측 버튼은 자동 생성되며 그 외 추가할 메뉴  작성
				this.contextMenu.add({
					xtype: 'menuseparator'
				},{
					text: '<t:message code="system.label.inventory.iteminfo" default="품목정보"/>',   iconCls : '',
		        	handler: function(menuItem, event) {
		        		var record = grid.getSelectedRecord();
						var params = {
							ITEM_CODE : record.get('ITEM_CODE')
						}
						var rec = {data : {prgID : 'bpr100ukrv', 'text':''}};
						parent.openTab(rec, '/base/bpr100ukrv.do', params);
		        	}
		        },{
		        	text: '<t:message code="system.label.inventory.custominfo" default="거래처정보"/>',   iconCls : '',
		            handler: function(menuItem, event) {
						var params = {
							CUSTOM_CODE : panelSearch.getValue('CUSTOM_CODE'),
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
	        	panelSearch.setAllFieldsReadOnly(true);
	        }
		},
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				//특정 값에 의해 필터를 할 컬럼에 대해 작성하는 예제.
				record = this.getSelectedRecord();
				if(UniUtils.indexOf(e.field, ['INOUT_SEQ','TO_DIV_CODE', 'WH_CODE', 'WH_CELL_CODE','INOUT_CODE', 'INOUT_CODE_DETAIL', 'ITEM_CODE', 'ITEM_NAME', 'ITEM_STATUS',
											  'INOUT_Q', 'INOUT_PRSN', 'LOT_NO', 'REMARK', 'PROJECT_NO', 'BASIS_NUM','SPEC','STOCK_UNIT','TRNS_RATE','BOX_Q']))
				{
					return false;
  				} else {
  					return true;
  				}

			}
	   	
		},
	    setItemData: function(record, dataClear) {
       		var grdRecord = this.getSelectedRecord();
       		if(dataClear) {
       			grdRecord.set('LOT_NO'				, '');

       		} else {
       			grdRecord.set('LOT_NO'				, record['LOT_NO']);
       		}
		},
		setEstiData: function(record) {						// 이동출고참조 셋팅
       		var grdRecord = this.getSelectedRecord();
       		grdRecord.set('COMP_CODE'			, UserInfo.compCode);
			grdRecord.set('INOUT_TYPE'			, '1');
			grdRecord.set('INOUT_METH'			, '3');
			grdRecord.set('INOUT_TYPE_DETAIL'	, 'GM');
			grdRecord.set('INOUT_CODE_TYPE'		, '2');
			grdRecord.set('INOUT_DATE'			, panelSearch.getValue('INOUT_DATE'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('ITEM_STATUS'			, record['IN_ITEM_STATUS']);
			grdRecord.set('TO_DIV_CODE'			, record['DIV_CODE']);
			grdRecord.set('INOUT_CODE'			, record['WH_CODE']);
			grdRecord.set('INOUT_NAME'			, record['WH_NAME']);
			grdRecord.set('INOUT_CODE_DETAIL'	, record['WH_CELL_CODE']);
			grdRecord.set('INOUT_NAME_DETAIL'	, record['WH_CELL_NAME']);
			grdRecord.set('DIV_CODE'			, record['TO_DIV_CODE']);
			grdRecord.set('WH_CODE'				, panelResult.getValue('WH_CODE'));
			grdRecord.set('WH_CELL_CODE'		, record['INOUT_CODE_DETAIL']);
			grdRecord.set('INOUT_Q'				, record['INOUT_Q']);
			grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);
			grdRecord.set('INOUT_FOR_P'			, record['INOUT_FOR_P']);
			grdRecord.set('INOUT_FOR_O'			, record['INOUT_FOR_O']);
			grdRecord.set('INOUT_P'				, record['INOUT_P']);
			grdRecord.set('INOUT_I'				, record['INOUT_I']);
			grdRecord.set('EXCHG_RATE_O'		, record['EXCHG_RATE_O']);
			grdRecord.set('INOUT_PRSN'			, record['INOUT_PRSN']);
			grdRecord.set('BASIS_NUM'			, record['INOUT_NUM']);
			grdRecord.set('BASIS_SEQ'			, record['INOUT_SEQ']);
			grdRecord.set('LOT_NO'				, record['LOT_NO']);
			grdRecord.set('LOT_YN'              , 'Y');
			grdRecord.set('REMARK'				, record['REMARK']);
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			grdRecord.set('PURCHASE_CUSTOM_CODE', record['PURCHASE_CUSTOM_CODE']);
			grdRecord.set('PURCHASE_TYPE'		, record['PURCHASE_TYPE']);
			grdRecord.set('SALES_TYPE'			, record['SALES_TYPE']);
			grdRecord.set('PURCHASE_RATE'		, record['PURCHASE_RATE']);
			grdRecord.set('PURCHASE_P'			, record['PURCHASE_P']);
			grdRecord.set('SALE_P'				, record['SALE_P']);
			grdRecord.set('TRNS_RATE'           , record['TRNS_RATE']);
			grdRecord.set('BOX_Q'               , record['BOX_Q']);
		}
    });	//End of   var masterGrid1 = Unilite.createGrid('s_opo110ukrv_inGrid1', {

    var orderNoMasterGrid = Unilite.createGrid('s_opo110ukrv_inOrderNoMasterGrid', {	// 검색팝업창
        // title: '기본',
        layout : 'fit',
		store: orderNoMasterStore,
		uniOpt:{
			useRowNumberer: false
		},
        columns:  [
			{ dataIndex: 'ITEM_CODE'			   	,  width: 120},
			{ dataIndex: 'ITEM_NAME'			   	,  width: 133},
			{ dataIndex: 'SPEC'				   		,  width: 133},
			{ dataIndex: 'STOCK_UNIT'			   	,  width: 53, hidden: true, displayField: 'value'},
			{ dataIndex: 'INOUT_DATE'			   	,  width: 80},
			{ dataIndex: 'INOUT_Q'			   		,  width: 80},
			{ dataIndex: 'DIV_CODE'			   		,  width: 80, hidden: true},
			{ dataIndex: 'WH_CODE'			   		,  width: 86},
			{ dataIndex: 'WH_CELL_CODE'		   		,  width: 100, hidden: true},
			{ dataIndex: 'TO_DIV_CODE'		   		,  width: 86, hidden: true},
			{ dataIndex: 'TO_DIV_NAME'		   		,  width: 86},
			{ dataIndex: 'INOUT_CODE'				,  width: 80},
			{ dataIndex: 'INOUT_CODE_DETAIL'		,  width: 100, hidden: true},
			{ dataIndex: 'LOT_NO'					,  width: 106, hidden: true},
			{ dataIndex: 'INOUT_PRSN'				,  width: 53},
			{ dataIndex: 'INOUT_NUM'				,  width: 106}
        ],
        listeners: {
       		onGridDblClick:function(grid, record, cellIndex, colName) {
  				orderNoMasterGrid.returnData(record);
		       	UniAppManager.app.onQueryButtonDown();
		       	SearchInfoWindow.hide();
          		//UniAppManager.setToolbarButtons('save', true);
  			}
        },
        returnData: function(record)   {
            if(Ext.isEmpty(record))	{
          		record = this.getSelectedRecord();
          	}
          	panelSearch.setValues({'DIV_CODE':record.get('DIV_CODE')});
          	panelSearch.setValues({'WH_CODE':record.get('WH_CODE')});
          	panelSearch.setValues({'INOUT_DATE':record.get('INOUT_DATE')});
          	panelSearch.setValues({'INOUT_NUM':record.get('INOUT_NUM')});
          	panelSearch.setValues({'INOUT_PRSN':record.get('INOUT_PRSN')});
        }
    });

    var otherOrderGrid = Unilite.createGrid('s_opo110ukrv_inOtherOrderGrid', {//이동출고 참조
        // title: '기본',
        layout : 'fit',
    	store: otherOrderStore,
    	selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick:false }),
		uniOpt:{
	       	onLoadSelectFirst : false
	    },
        columns: [
			{ dataIndex: 'ITEM_CODE'				,  width: 120},
			{ dataIndex: 'ITEM_NAME'				,  width: 133},
			{ dataIndex: 'SPEC'						,  width: 86},
			{ dataIndex: 'STOCK_UNIT'				,  width: 86, displayField: 'value'},
			{ dataIndex: 'INOUT_DATE'				,  width: 100},
			{ dataIndex: 'DIV_CODE'					,  width: 100},
			{ dataIndex: 'WH_CODE'					,  width: 66, hidden: true},
			{ dataIndex: 'WH_NAME'					,  width: 150},
			{ dataIndex: 'WH_CELL_CODE'				,  width: 66, hidden: true},
			{ dataIndex: 'WH_CELL_NAME'				,  width: 80, hidden: true},
			{ dataIndex: 'IN_ITEM_STATUS'			,  width: 86},
			{ dataIndex: 'INOUT_Q'					,  width: 100},
			{ dataIndex: 'INOUT_NUM'				,  width: 150},
			{ dataIndex: 'INOUT_SEQ'				,  width: 93},
			{ dataIndex: 'TO_DIV_CODE'				,  width: 100, hidden: true},
			{ dataIndex: 'INOUT_CODE'				,  width: 100, hidden: true},
			{ dataIndex: 'INOUT_CODE_DETAIL'		,  width: 100, hidden: true},
			{ dataIndex: 'INOUT_P'					,  width: 100, hidden: true},
			{ dataIndex: 'INOUT_I'					,  width: 100, hidden: true},
			{ dataIndex: 'MONEY_UNIT'				,  width: 100, hidden: true},
			{ dataIndex: 'INOUT_FOR_P'				,  width: 100, hidden: true},
			{ dataIndex: 'INOUT_FOR_O'				,  width: 100, hidden: true},
			{ dataIndex: 'EXCHG_RATE_O'				,  width: 100, hidden: true},
			{ dataIndex: 'LOT_NO'					,  width: 80},
			{ dataIndex: 'REMARK'					,  width: 133},
			{ dataIndex: 'PROJECT_NO'				,  width: 133},
			{ dataIndex: 'ITEM_ACCOUNT'				,  width: 133, hidden: true},
			{ dataIndex: 'TRNS_RATE'              ,  width: 133, hidden: true},
			{ dataIndex: 'BOX_Q'              ,  width: 133, hidden: true},
			{dataIndex: 'PURCHASE_CUSTOM_CODE'			, width: 100, hidden: true},
			{dataIndex: 'PURCHASE_TYPE'					, width: 100, hidden: true},
			{dataIndex: 'SALES_TYPE'					, width: 100, hidden: true},
			{dataIndex: 'PURCHASE_RATE'					, width: 100, hidden: true},
			{dataIndex: 'PURCHASE_P'					, width: 100, hidden: true},
			{dataIndex: 'SALE_P'						, width: 100, hidden: true}
        ],
        listeners: {
          	onGridDblClick:function(grid, record, cellIndex, colName) {}
       	},
       	returnData: function()	{
       		var records = this.getSelectedRecords();

			Ext.each(records, function(record,i) {
		       	UniAppManager.app.onNewDataButtonDown();
		       	masterGrid.setEstiData(record.data);
		    });
			this.getStore().remove(records);
       	}
    });

    function openSearchInfoWindow() {	//검색팝업창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '감마의뢰번호검색',
                width: 1080,
                height: 580,
                layout: {type:'vbox', align:'stretch'},
                items: [orderNoSearch, orderNoMasterGrid],
                tbar:  ['->',
					{itemId : 'saveBtn',
					text: '<t:message code="system.label.inventory.inquiry" default="조회"/>',
					handler: function() {
						orderNoMasterStore.loadStoreRecords();
					},
					disabled: false
					}, {
						itemId : 'OrderNoCloseBtn',
						text: '<t:message code="system.label.inventory.close" default="닫기"/>',
						handler: function() {
							SearchInfoWindow.hide();
						},
						disabled: false
					}
				],
				listeners: {beforehide: function(me, eOpt)
					{
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
                	},
                	beforeclose: function( panel, eOpts ) {
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
       	 			},
                	beforeshow: function( panel, eOpts )	{
                		field = orderNoSearch.getField('INOUT_PRSN');
                		field.fireEvent('changedivcode', field, panelSearch.getValue('DIV_CODE'), null, null, "DIV_CODE");
                		orderNoSearch.setValue('DIV_CODE',panelSearch.getValue('DIV_CODE'));
                		orderNoSearch.setValue('WH_CODE',panelSearch.getValue('WH_CODE'));
                		orderNoSearch.setValue('TO_INOUT_DATE',panelSearch.getValue('INOUT_DATE'));
                		orderNoSearch.setValue('FR_INOUT_DATE', UniDate.get('startOfMonth', orderNoSearch.getValue('TO_INOUT_DATE')));
                		orderNoSearch.setValue('INOUT_PRSN',panelSearch.getValue('INOUT_PRSN'));
                	}
                }
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
    }

    function openMoveReleaseWindow() {    	//이동출고 참조
  		if(!UniAppManager.app.checkForNewDetail()) return false;
  		otherOrderSearch.setValue('FR_INOUT_DATE', UniDate.get('startOfMonth') );
  		otherOrderSearch.setValue('TO_INOUT_DATE', UniDate.get('today', panelSearch.getValue('ORDER_DATE')));
  		otherOrderSearch.setValue('DIV_CODE', panelSearch.getValue('DIV_CODE'));
  		otherOrderStore.loadStoreRecords();

		if(!MoveReleaseWindow) {
			MoveReleaseWindow = Ext.create('widget.uniDetailWindow', {
                title: '감마의뢰참조',
                width: 1080,
                height: 580,
                layout:{type:'vbox', align:'stretch'},

                items: [otherOrderSearch, otherOrderGrid],
                tbar:  ['->',
					{	itemId : 'saveBtn',
						text: '<t:message code="system.label.inventory.inquiry" default="조회"/>',
						handler: function() {
							otherOrderStore.loadStoreRecords();
						},
						disabled: false
					},{	itemId : 'confirmBtn',
						text: '<t:message code="system.label.inventory.receiptapply" default="입고적용"/>',
						handler: function() {
							otherOrderGrid.returnData();
						},
						disabled: false
					},{	itemId : 'confirmCloseBtn',
						text: '<t:message code="system.label.inventory.receiptapplyclose" default="입고적용후 닫기"/>',
						handler: function() {
							otherOrderGrid.returnData();
							MoveReleaseWindow.hide();
							UniAppManager.setToolbarButtons('reset', true);
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.inventory.close" default="닫기"/>',
						handler: function() {
							MoveReleaseWindow.hide();
							UniAppManager.setToolbarButtons('reset', true);
						},
						disabled: false
					}
				],
                listeners : {beforehide: function(me, eOpt)
                	{
                		otherOrderSearch.clearForm();
                		otherOrderGrid.reset();
                	},
                	beforeclose: function(panel, eOpts)
                	{
						otherOrderSearch.clearForm();
                		otherOrderGrid.reset();
                	},
                	beforeshow: function (me, eOpts)
                	{
                		field = otherOrderSearch.getField('INOUT_PRSN');
                		field.fireEvent('changedivcode', field, panelSearch.getValue('DIV_CODE'), null, null, "DIV_CODE");
        			 	otherOrderSearch.setValue('DIV_CODE',panelSearch.getValue('DIV_CODE'));
                		otherOrderSearch.setValue('TO_INOUT_DATE',panelSearch.getValue('INOUT_DATE'));
                		otherOrderSearch.setValue('INOUT_PRSN',panelSearch.getValue('INOUT_PRSN'));
                		otherOrderSearch.setValue('IN_WH_CODE',panelSearch.getValue('WH_CODE'));
        				otherOrderStore.loadStoreRecords();
        			 }
                }
			})
		}
		MoveReleaseWindow.center();
		MoveReleaseWindow.show();
    }

    Unilite.Main ({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		id: 's_opo110ukrv_inApp',
		fnInitBinding: function() {
		    panelResult.getField('INOUT_NUM2').focus();
//			UniAppManager.setToolbarButtons(['reset', 'deleteAll', 'prev', 'next'], true);
			UniAppManager.setToolbarButtons('reset', true);
			//this.setDefault();
//			panelSearch.setValue('DEPT_CODE',UserInfo.deptCode);
//			panelSearch.setValue('DEPT_NAME',UserInfo.deptName);
			panelResult.setValue('INOUT_NUM','');
			panelSearch.setValue('INOUT_NUM','');
			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME',UserInfo.deptName);
			s_opo110ukrv_inService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			})
			cbStore1.loadStoreRecords();
            cbStore2.loadStoreRecords();
		},

		onQueryButtonDown: function()	{
			if(!panelResult.getInvalidMessage()) return;   //필수체크
			
			var inoutNo = panelSearch.getValue('INOUT_NUM');
			var inoutNo2 = panelSearch.getValue('INOUT_NUM2');
			if(Ext.isEmpty(inoutNo) && Ext.isEmpty(inoutNo2)) {
				openSearchInfoWindow()
			} else {
				var param= panelSearch.getValues();
				directMasterStore1.loadStoreRecords();
				if(panelSearch.setAllFieldsReadOnly(true) == false){
					return false;
				}
				if(panelResult.setAllFieldsReadOnly(true) == false){
					return false;
				}
			}
//			UniAppManager.setToolbarButtons('reset', true);
			UniAppManager.setToolbarButtons(['reset', 'deleteAll'], true);
		},

		onNewDataButtonDown: function()	{	// 행추가 버튼
			var inoutNum = panelSearch.getValue('INOUT_NUM')
			var seq = directMasterStore1.max('INOUT_SEQ');
			var whCode = panelSearch.getValue('WH_CODE');
			var whCellCode = panelSearch.getValue('WH_CELL_CODE');
            if(!seq) seq = 1;
            else seq += 1;
            var r = {
				INOUT_NUM: inoutNum,
				INOUT_SEQ: seq,
				WH_CODE: whCode,
				WH_CELL_CODE: whCellCode
		    };
			masterGrid.createRow(r, 'ITEM_CODE', seq-2);
			panelSearch.setAllFieldsReadOnly(false);
		},

		onDeleteDataButtonDown: function() {	// 행삭제 버튼
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.inventory.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					masterGrid.deleteSelectedRow();
			}
		},

		onResetButtonDown: function() {		// 새로고침 버튼
			//this.suspendEvents();
			orderNoSearch.reset();
			otherOrderSearch.reset();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			orderNoMasterGrid.reset();
			otherOrderGrid.reset();
			this.fnInitBinding();
//			panelSearch.getField('WH_CODE').focus();
			directMasterStore1.clearData();
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
			var fp = Ext.getCmp('s_opo110ukrv_inFileUploadPanel');
        	if(masterStore.isDirty() || fp.isDirty()) {
				if(confirm('<t:message code="system.message.inventory.message015" default="변경된 내용을 저장하시겠습니까?"/>'))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},

		fnGetInoutPrsnDivCode: function(subCode){	//사업장의 첫번째 영업담당자 가져오기..
        	var fRecord ='';
        	Ext.each(BsaCodeInfo.inoutPrsn, function(item, i)	{
        		if(item['refCode1'] == subCode) {
        			fRecord = item['codeNo'];
        			return false;
        		}
        	});
        	return fRecord;
        },

		setDefault: function() {	// 화면 초기화
			var field = panelSearch.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = panelResult.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = orderNoSearch.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = otherOrderSearch.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");

			var inoutPrsn = UniAppManager.app.fnGetInoutPrsnDivCode(UserInfo.divCode);		//사업장의 첫번째 영업담당자 set

			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.setValue('INOUT_PRSN',inoutPrsn); ////사업장에 따른 수불담당자 불러와야함
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
        	panelResult.setValue('INOUT_PRSN',inoutPrsn); ////사업장에 따른 수불담당자 불러와야함
        	orderNoSearch.setValue('DIV_CODE', UserInfo.divCode);
        	orderNoSearch.setValue('INOUT_PRSN',inoutPrsn); ////사업장에 따른 수불담당자 불러와야함
        	otherOrderSearch.setValue('DIV_CODE', UserInfo.divCode);
        	otherOrderSearch.setValue('INOUT_PRSN',inoutPrsn); ////사업장에 따른 수불담당자 불러와야함
        	panelSearch.setValue('INOUT_DATE',UniDate.get('today'));
        	panelSearch.getForm().wasDirty = false;
         	panelSearch.resetDirtyStatus();
         	UniAppManager.setToolbarButtons('save', false);
		},

		checkForNewDetail: function() {
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(panelSearch.getValue('INOUT_NUM')))	{
				alert('<t:message code="system.label.inventory.sono" default="수주번호"/>:<t:message code="system.message.inventory.datacheck003" default="필수입력 항목입니다."/>');
				return false;
			}
			return panelSearch.setAllFieldsReadOnly(true);
        },

		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
		,
		onDeleteAllButtonDown: function() {
            var records = directMasterStore1.data.items;
            var isNewData = false;
            Ext.each(records, function(record,i) {
                if(record.phantom){                     //신규 레코드일시 isNewData에 true를 반환
                    isNewData = true;

                } else {                                //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
                    if(confirm('<t:message code="system.message.inventory.confirm002" default="전체삭제 하시겠습니까?"/>')) {
                        var deletable = true;
                        if(deletable){
                            masterGrid.reset();
                            UniAppManager.app.onSaveDataButtonDown();
                        }
                        isNewData = false;
                    }
                    return false;
                }
            });

            if(isNewData){                              //신규 레코드들만 있을시 그리드 리셋
                masterGrid.reset();
                UniAppManager.app.onResetButtonDown();  //삭제후 RESET..
            }

            UniAppManager.setToolbarButtons('deleteAll', false);
        }




	});

	Unilite.createValidator('validator01', {
        store: directMasterStore1,
        grid: masterGrid,
        validate: function( type, fieldName, newValue, oldValue, record, eopt) {
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;
            switch(fieldName) {
                case "WH_CODE" :
                    record.set('WH_CELL_CODE', '');
                    break;

                case "INOUT_CODE" :
                    record.set('INOUT_CODE_DETAIL', '');

                    break;
            }
            return rv;
        }
    });
};

</script>