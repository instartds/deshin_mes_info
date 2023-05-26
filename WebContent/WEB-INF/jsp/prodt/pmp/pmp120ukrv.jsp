<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmp120ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="pmp120ukrv" /> 			<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 -->
	<t:ExtComboStore comboType="WU" /><!-- 작업장  -->
	<t:ExtComboStore comboType="AU" comboCode="B013"/> <!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B014"/> <!-- 조달구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A" />   <!-- 가공창고 -->
	<t:ExtComboStore comboType="AU" comboCode="P120"/> <!-- 대체여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B139"/> <!-- 대체여부 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var searchInfoWindow;	//SearchInfoWindow : 검색창
var referProductionPlanWindow;  //생산계획참조

var BsaCodeInfo = {
	gsUseWorkColumnYn	: '${gsUseWorkColumnYn}',	//작업 관련컬럼(작업자, 작업호기, 작업시간, 주야구분) 사용여부
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


function appMain() {

	var isAutoOrderNum = false;
    if(BsaCodeInfo.gsAutoType=='Y') {
        isAutoOrderNum = true;
    }

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'pmp120ukrvService.selectDetailList',
			update: 'pmp120ukrvService.updateDetail',
			create: 'pmp120ukrvService.insertDetail',
			destroy: 'pmp120ukrvService.deleteDetail',
			syncAll: 'pmp120ukrvService.saveAll'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'pmp120ukrvService.selectWorkNum'
		}
	});

	/**
	 * 긴급작업지시 마스터 정보를 가지고 있는 Grid
	 */
	Unilite.defineModel('pmp120ukrvDetailModel', {
	    fields: [
			{name: 'COMP_CODE'  						, text: '<t:message code="system.label.product.companycode2" default="회사코드"/>'		,type:'string'},
			{name: 'DIV_CODE'  							, text: '<t:message code="system.label.product.division" default="사업장"/>'			    		,type:'string'},
			{name: 'PACK_ITEM_CODE'  			, text: '포장제품'			    		,type:'string'},
			{name: 'PRODT_WKORD_DATE'  		, text: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>'			    		,type:'uniDate'},
			{name: 'PRODT_START_DATE'  		, text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'			    		,type:'uniDate'},
			{name: 'PRODT_END_DATE'  			, text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'			    		,type:'uniDate'},
			{name: 'WKORD_NUM'						, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'	, type: 'string'},
			{name: 'LINE_SEQ' 		   					, text: '<t:message code="system.label.product.routingorder" default="공정순서"/>'			,type:'int', allowBlank: false},
			{name: 'PROG_WORK_CODE'   		, text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'			,type:'string', allowBlank: false},
			{name: 'PROG_WORK_NAME'   		, text: '<t:message code="system.label.product.routingname" default="공정명"/>'			    ,type:'string'},
			{name: 'PROG_UNIT_Q'    					, text: '<t:message code="system.label.product.originunitqty" default="원단위량"/>'			,type:'uniFC', allowBlank: false},
			{name: 'WKORD_Q'  		   					, text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'		,type:'uniQty', allowBlank: false},
			{name: 'PROG_UNIT' 						, text: '<t:message code="system.label.product.unit" default="단위"/>'								,type:'string' ,comboType: 'AU' , comboCode:'B013' , displayField: 'value', allowBlank: false},
			{name: 'WORK_SHOP_CODE'   		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'			    ,type:'string' , comboType: 'WU'},
			{name: 'RAW_CELL_CODE'   		, text: 'RAW_CELL_CODE'			    ,type:'string'}
		]
	});

	/**
	 * Master Store 정의(Service 정의)
	 * @type
	 */
	var detailStore = Unilite.createStore('pmp120ukrvDetailStore', {
		model: 'pmp120ukrvDetailModel',
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
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
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
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('pmp120ukrvGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		if(records[0] != null){
           			panelResult.uniOpt.inLoading = true;
           			panelResult.setValues(records[0].data);
           			panelResult.uniOpt.inLoading = false;
           			detailStore.commitChanges();
           		}
           	}
		}
	});

	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
	            xtype: 'component',
	            colspan: 3,
	            padding: '0 0 0 0',
	            height	: 3
        	},{
        		fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
                holdable: 'hold',
        		allowBlank: false
	    	},{
		    	fieldLabel: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
			 	xtype: 'uniTextfield',
			 	name: 'WKORD_NUM',
			 	colspan: 2,
                holdable: 'hold',
                readOnly: isAutoOrderNum,
                holdable: isAutoOrderNum ? 'readOnly':'hold'
			},{
	            xtype: 'component',
	            colspan: 3,
	            padding: '0 0 0 0',
	            height	: 3
        	},{
	            xtype: 'component',
	            colspan: 3,
	            padding: '0 0 0 0',
	            tdAttrs: {style: 'border-top: 1px solid #cccccc;  padding-top: 2px;' }
        	},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType: 'WU',
                holdable: 'hold',
                value : 'W30',
		 		allowBlank:false
			},{
    			xtype: 'container',
    			layout: { type: 'uniTable', columns: 2},
    			defaultType: 'uniTextfield',
    			defaults : {enforceMaxLength: true},
    			items:[
    				Unilite.popup('DIV_PUMOK',{
			        	fieldLabel: '반제품',
			        	valueFieldName: 'SEMI_ITEM_CODE',
						textFieldName: 'SEMI_ITEM_NAME',
                        holdable: 'hold',
						allowBlank:false,
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									if(!Ext.isEmpty(records[0])){
										panelResult.setValue('PROG_UNIT',records[0]["STOCK_UNIT"]);
									}
									panelResult.setValue('LOT_NO', '');
		                    	},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('ITEM_CODE', '');
								panelResult.setValue('ITEM_NAME', '');
								panelResult.setValue('PROG_UNIT','');
								panelResult.setValue('LOT_NO', '');
							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
								//popup.setExtParam({'ITEM_ACCOUNT': '20'});
							}
						}
			   })]
	    	},
            Unilite.popup('LOTNO',{
	        	fieldLabel: 'LOT NO',
	        	holdable: 'hold',
	        	allowBlank:false,
	        	textFieldName: 'LOT_NO',
				DBtextFieldName: 'LOT_NO',
	        	listeners: {
	        		onSelected: {
	        			fn: function(records, type) {
							console.log('records : ', records);
							panelResult.setValue('LOT_NO',records[0].LOT_NO);
							panelResult.setValue('SEMI_ITEM_CODE', records[0].ITEM_CODE);
							panelResult.setValue('SEMI_ITEM_NAME', records[0].ITEM_NAME);
							panelResult.setValue('RAW_CELL_CODE', records[0].WH_CELL_CODE);
                    	},
						scope: this
					},applyextparam: function(popup){
							popup.setExtParam({'ITEM_CODE': panelResult.getValue('SEMI_ITEM_CODE')});
							popup.setExtParam({'ITEM_NAME': panelResult.getValue('SEMI_ITEM_NAME')});
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
			}),{
				fieldLabel: '포장박스유형',
				name: 'BOX_TYPE',
				xtype: 'uniCombobox',
    			comboType:'AU',
    			comboCode:'B139',
    			holdable: 'hold',
    			allowBlank:false

			},{
    			xtype: 'container',
    			layout: { type: 'uniTable', columns: 2},
    			defaultType: 'uniTextfield',
    			defaults : {enforceMaxLength: true},
    			items:[
    				Unilite.popup('DIV_PUMOK',{
			        	fieldLabel: '포장제품',
			        	valueFieldName: 'PACK_ITEM_CODE',
						textFieldName: 'PACK_ITEM_NAME',
                        holdable: 'hold',
						allowBlank:false,
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									panelResult.setValue('PROG_UNIT',records[0]["STOCK_UNIT"]);
									panelResult.setValue('LOT_NO', '');
									var param = {"ITEM_CODE": records[0]["ITEM_CODE"]};
									pmp120ukrvService.selectSemiItem(param, function(provider, response) {
				                        if(!Ext.isEmpty(provider)&&!Ext.isEmpty(response.result.data[0])){
				                        	panelResult.setValue('SEMI_ITEM_CODE', response.result.data[0].ITEM_CODE);
				                        	panelResult.setValue('SEMI_ITEM_NAME', response.result.data[0].ITEM_NAME);
				                        }else{
				                        	panelResult.setValue('SEMI_ITEM_CODE', '');
				                        	panelResult.setValue('SEMI_ITEM_NAME', '');
				                        }
				                    });
		                    	},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('ITEM_CODE', '');
								panelResult.setValue('ITEM_NAME', '');
								panelResult.setValue('PROG_UNIT','');
								panelResult.setValue('LOT_NO', '');
							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
							}
						}
			   })]
	    	},{
    			xtype: 'container',
    			layout: { type: 'uniTable', columns: 2},
    			defaultType: 'uniTextfield',
    			defaults : {enforceMaxLength: true},
    			items:[{
			    	fieldLabel: '포장지시량',
				 	xtype: 'uniNumberfield',
				 	name: 'BOX_WKORD_Q',
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
				}]
	    	},{
		 		fieldLabel: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>',
		 		xtype: 'uniDatefield',
		 		name: 'PRODT_WKORD_DATE',
		 		allowBlank:false,
		 		holdable: 'hold',
		 		value: new Date()
			},{
                fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
                xtype: 'uniDatefield',
                name: 'PRODT_START_DATE',
                allowBlank:false,
                holdable: 'hold',
                value: new Date()
            },{
                fieldLabel: '<t:message code="system.label.product.completiondate" default="완료예정일"/>',
                xtype: 'uniDatefield',
                name: 'PRODT_END_DATE',
                allowBlank:false,
                holdable: 'hold',
                value: new Date()
            },{
              xtype: 'component'
            },{
	            xtype: 'component',
	            colspan: 3,
	            padding: '0 0 0 0',
	            height	: 3
        	},{
                fieldLabel: '<t:message code="system.label.product.specialremark" default="특기사항"/>',
                xtype:'uniTextfield',
                colspan: 3,
                name: 'REMARK',
                holdable: 'hold',
                width: 825,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('REMARK', newValue);

                        var cgRemark = panelResult.getValue('REMARK');
                        if(Ext.isEmpty(cgRemark)) return false;
                            var records = detailStore.data.items;

                        Ext.each(records, function(record,i){
                            record.set('REMARK',cgRemark);
                        });
                    }
                }
            },{
                fieldLabel: '수주번호',
                xtype:'uniTextfield',
                name: 'ORDER_NUM',
                holdable: 'hold',
                hidden: true
            },{
                fieldLabel: '수주순번',
                xtype:'uniNumberfield',
                name: 'SER_NO',
                holdable: 'hold',
                hidden: true
            },{
	            xtype: 'component',
	            colspan: 3,
	            padding: '0 0 0 0',
	            height	: 3
        	},{
                fieldLabel: 'RAW_CELL_CODE',
                xtype:'uniTextfield',
                name: 'RAW_CELL_CODE',
                holdable: 'hold',
                hidden: true
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
     * Master Grid 정의(Grid Panel)
     * @type
     */
    var detailGrid = Unilite.createGrid('pmp120ukrvGrid', {
    	layout: 'fit',
        region:'center',
        uniOpt: {
			expandLastColumn: true,
			useRowNumberer: false
        },
        tbar: [{
			itemId: 'requestBtn',
			text: '<div style="color: blue">출고예정표참조</div>',
			handler: function() {
				openProductionPlanWindow();
			}
		}],
    	store: detailStore,
        columns: [
			{dataIndex: 'COMP_CODE'  	           	 		, width: 100 , hidden: true},
			{dataIndex: 'DIV_CODE'  		        			, width: 100 , hidden: true},
			{dataIndex: 'WKORD_NUM'  		        	, width: 100 , hidden: true},
			{dataIndex: 'LINE_SEQ' 		 	        			, width: 100 },
			{dataIndex: 'PROG_WORK_CODE'  	        , width: 100 ,
				editor: Unilite.popup('PROG_WORK_CODE_G', {
  					textFieldName: 'PROG_WORK_NAME',
 	 				DBtextFieldName: 'PROG_WORK_NAME',
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
									popup.setExtParam({'DIV_CODE'		: panelResult.getValue('DIV_CODE')});
									popup.setExtParam({'WORK_SHOP_CODE' : panelResult.getValue('WORK_SHOP_CODE')
								});
							}
	 			}
			})},
			{dataIndex: 'PROG_WORK_NAME'          , width: 100 ,
				editor: Unilite.popup('PROG_WORK_CODE_G', {
  					textFieldName: 'PROG_WORK_NAME',
 	 				DBtextFieldName: 'PROG_WORK_NAME',
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
									popup.setExtParam({'DIV_CODE'		: panelResult.getValue('DIV_CODE')});
									popup.setExtParam({'WORK_SHOP_CODE' : panelResult.getValue('WORK_SHOP_CODE')
								});
							}
	 			}
			})},
			{dataIndex: 'PROG_UNIT_Q'    	        		, width: 100 },
			{dataIndex: 'WKORD_Q'  		 	        		, width: 100 },
			{dataIndex: 'PROG_UNIT' 		        			, width: 100 },
			{dataIndex: 'WORK_SHOP_CODE'  	        , width: 100 },
			{dataIndex: 'RAW_CELL_CODE'  	        , width: 100 , hidden: true},
			{dataIndex: 'PACK_ITEM_CODE'           	, width: 100 , hidden: true},
			{dataIndex: 'PRODT_WKORD_DATE'       , width: 100 , hidden: true},
			{dataIndex: 'PRODT_START_DATE'          , width: 100 , hidden: true},
			{dataIndex: 'PRODT_END_DATE'            	, width: 100 , hidden: true}
		],
    	listeners: {
    		beforeedit  : function( editor, e, eOpts ) {

			}
       	},
		setItemData: function(record, dataClear, grdRecord) {
       		//var grdRecord = detailGrid.uniOpt.currentRecord;
       		if(dataClear) {
				grdRecord.set('PROG_WORK_CODE'  	    , '');
				grdRecord.set('PROG_WORK_NAME'  	    , '');
				grdRecord.set('PROG_UNIT'  	    		,  panelResult.getValue('PROG_UNIT'));
       		}else{
				grdRecord.set('PROG_WORK_CODE'  	    , record['PROG_WORK_CODE']);
				grdRecord.set('PROG_WORK_NAME'  	    , record['PROG_WORK_NAME']);
	       		if(grdRecord.get['PROG_UNIT'] != ''){
	       			grdRecord.set('PROG_UNIT'    		, record['PROG_UNIT']);
	       		}
	       		else{
	       			grdRecord.set('PROG_UNIT'    		, panelResult.getValue('PROG_UNIT'));
	       		}
       		}
		},
        setEstiData: function(record, dataClear, grdRecord) {
        	var grdRecord = detailGrid.getSelectedRecord();
            grdRecord.set('DIV_CODE'          ,  record['DIV_CODE']);
            grdRecord.set('LINE_SEQ'          ,  record['LINE_SEQ']);
            grdRecord.set('PROG_WORK_CODE'    ,  record['PROG_WORK_CODE']);
            grdRecord.set('PROG_WORK_NAME'    ,  record['PROG_WORK_NAME']);
            grdRecord.set('PROG_UNIT_Q'       ,  record['PROG_UNIT_Q']);
            grdRecord.set('WKORD_Q'           ,  record['PROG_UNIT_Q'] * panelResult.getValue('BOX_WKORD_Q'));
            grdRecord.set('PROG_UNIT'         ,  record['PROG_UNIT']);
        },
        setBeforeNewData: function(record, dataClear, grdRecord) {
            var grdRecord = detailGrid.getSelectedRecord();
            grdRecord.set('DIV_CODE'          ,  record['DIV_CODE']);
            grdRecord.set('LINE_SEQ'          ,  record['LINE_SEQ']);
            grdRecord.set('PROG_WORK_CODE'    ,  record['PROG_WORK_CODE']);
            grdRecord.set('PROG_WORK_NAME'    ,  record['PROG_WORK_NAME']);
            grdRecord.set('PROG_UNIT'         ,  record['PROG_UNIT']);
        }
    });


    /*************************************************************************************************
	 * 조회창
	 **************************************************************************************************/
	  // 조회창 모델 정의
	    Unilite.defineModel('productionNoMasterModel', {
		    fields: [{name: 'WKORD_NUM'						, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'    	, type: 'string'},
					 {name: 'ITEM_CODE'							, text: '<t:message code="system.label.product.item" default="품목"/>'    			, type: 'string'},
					 {name: 'ITEM_NAME'							, text: '<t:message code="system.label.product.itemname" default="품목명"/>'    			, type: 'string'},
					 {name: 'SPEC'										, text: '<t:message code="system.label.product.spec" default="규격"/>'    			, type: 'string'},
					 {name: 'PRODT_WKORD_DATE'			, text: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>'    	, type: 'uniDate'},
					 {name: 'PRODT_START_DATE'				, text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'    	, type: 'uniDate'},
					 {name: 'PRODT_END_DATE'				, text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'    	, type: 'uniDate'},
					 {name: 'WKORD_Q'								, text: '<t:message code="system.label.product. wkordq" default="작지수량"/>'    		, type: 'uniQty'},
					 {name: 'WK_PLAN_NUM'						, text: '<t:message code="system.label.product.planno" default="계획번호"/>'    		, type: 'string'},
					 {name: 'DIV_CODE'								, text: '<t:message code="system.label.product.division" default="사업장"/>'    		, type: 'string'},
					 {name: 'WORK_SHOP_CODE'				, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'    		, type: 'string' , comboType: 'WU'},
					 {name: 'ORDER_NUM'							, text: '<t:message code="system.label.product.sono" default="수주번호"/>'    		, type: 'string'},
					 {name: 'ORDER_Q'								, text: '<t:message code="system.label.product.soqty" default="수주량"/>'    		, type: 'uniQty'},
					 {name: 'REMARK'									, text: '<t:message code="system.label.product.remarks" default="비고"/>'    			, type: 'string'},
					 {name: 'PRODT_Q'								, text: '<t:message code="system.label.product.productionqty" default="생산량"/>'    		, type: 'uniQty'},
					 {name: 'DVRY_DATE'							, text: '<t:message code="system.label.product.deliverydate" default="납기일"/>'    		, type: 'uniDate'},
					 {name: 'STOCK_UNIT'							, text: '<t:message code="system.label.product.unit" default="단위"/>'    			, type: 'string' ,comboType: 'AU' , comboCode:'B013' , displayField: 'value'},
					 {name: 'PROJECT_NO'							, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'    	, type: 'string'},
					 {name: 'PJT_CODE'								, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'    	, type: 'string'},
					 {name: 'LOT_NO'									, text: 'LOT_NO'    		, type: 'string'},
					 {name: 'WORK_END_YN'						, text: '<t:message code="system.label.product.forceclosingflag" default="강제마감여부"/>'    	, type: 'string'},
					 {name: 'CUSTOM'									, text: '<t:message code="system.label.product.custom" default="거래처"/>'    		, type: 'string'},
					 {name: 'REWORK_YN'							, text: '<t:message code="system.label.product.reworkorderyn" default="재작업지시여부"/>'    	, type: 'string'},
					 {name: 'STOCK_EXCHG_TYPE'				, text: '<t:message code="system.label.product.inventoryexchangetype" default="재고대체유형"/>'    	, type: 'string'}
			]
		});

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
				value: 'W30',
				comboType: 'WU',
		 		allowBlank:true
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
							onClear: function(type)	{

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
    });

	var productionNoMasterStore = Unilite.createStore('productionNoMasterStore', {
			model: 'productionNoMasterModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable:false,			// 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
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

	var productionNoMasterGrid = Unilite.createGrid('pmp120ukrvproductionNoMasterGrid', {
        layout : 'fit',
		store: productionNoMasterStore,
		uniOpt:{
					useRowNumberer: false
		},
        columns:  [{ dataIndex: 'WORK_SHOP_CODE'					,	 width: 120 },
        		   { dataIndex: 'WKORD_NUM'							,	 width: 120 },
          		   { dataIndex: 'ITEM_CODE'							,	 width: 100 },
          		   { dataIndex: 'ITEM_NAME'							,	 width: 166 },
          		   { dataIndex: 'SPEC'								,	 width: 100 },
          		   { dataIndex: 'PRODT_WKORD_DATE'					,	 width: 80 },
          		   { dataIndex: 'PRODT_START_DATE'					,	 width: 80 },
          		   { dataIndex: 'PRODT_END_DATE'					,	 width: 80 },
          		   { dataIndex: 'WKORD_Q'							,	 width: 73 },
          		   { dataIndex: 'WK_PLAN_NUM'						,	 width: 100 ,hidden: true},
          		   { dataIndex: 'DIV_CODE'							,	 width: 0   ,hidden: true},
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
	          	panelResult.uniOpt.inLoading = true;
	          	panelResult.setValues({
	          		'DIV_CODE':record.get('DIV_CODE'),   /*사업장*/
	          		'WKORD_NUM':record.get('WKORD_NUM'),  			 /*작업지시번호*/
	          		'WORK_SHOP_CODE':record.get('WORK_SHOP_CODE'), /* 작업장*/
	          		'SEMI_ITEM_CODE':record.get('SEMI_ITEM_CODE'),				 /*품목코드*/
	          		'SEMI_ITEM_NAME':record.get('SEMI_ITEM_NAME'),	/*품목명*/
	          		'PACK_ITEM_CODE':record.get('ITEM_CODE'),				 /*품목코드*/
	          		'PACK_ITEM_NAME':record.get('ITEM_NAME'),	/*품목명*/
	          		'PRODT_WKORD_DATE':record.get('PRODT_WKORD_DATE'),
	          		'PRODT_START_DATE':record.get('PRODT_START_DATE'),
	          		'PRODT_END_DATE':record.get('PRODT_END_DATE'),
	          		'LOT_NO':record.get('LOT_NO'),
	          		'WKORD_Q':record.get('WKORD_Q'),
	          		'PROG_UNIT':record.get('STOCK_UNIT'),
	          		'PROJECT_NO':record.get('PROJECT_NO'),
	          		'REMARK':record.get('REMARK'),
	          		'PJT_CODE':record.get('PJT_CODE'),
	          		'WORK_END_YN':record.get('WORK_END_YN'),
					//'BOX_WKORD_Q' : '1',
					//'BOX_TYPE' : '050',
	          		'REMARK':record.get('REMARK'),
	          		'ORDER_NUM':record.get('SO_NUM'),
	          		'SER_NO':record.get('SO_SEQ')
	          	});
	          	panelResult.getField('DIV_CODE').setReadOnly( true );
				panelResult.getField('WKORD_NUM').setReadOnly( true );
				panelResult.getField('WORK_SHOP_CODE').setReadOnly( true );
				panelResult.getField('SEMI_ITEM_CODE').setReadOnly( true );
				panelResult.getField('SEMI_ITEM_NAME').setReadOnly( true );
				panelResult.getField('LOT_NO').setReadOnly( true );
			    panelResult.getField('BOX_TYPE').setReadOnly( true );
				panelResult.getField('BOX_WKORD_Q').setReadOnly( true );
				panelResult.getField('PACK_ITEM_CODE').setReadOnly( true );
				panelResult.getField('PACK_ITEM_NAME').setReadOnly( true );
				panelResult.getField('PRODT_WKORD_DATE').setReadOnly( true );
				panelResult.getField('PRODT_START_DATE').setReadOnly( true );
				panelResult.getField('PRODT_END_DATE').setReadOnly( true );
	          	panelResult.uniOpt.inLoading = false;
          }
    });

	function opensearchInfoWindow() {
		if(!searchInfoWindow) {
			searchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '<t:message code="system.label.product.workorderinfo" default="작업지시정보"/>',
                width: 830,
                height: 580,
                layout: {type:'vbox', align:'stretch'},
                items: [productionNoSearch, productionNoMasterGrid],
                tbar:  ['->',
				        {	itemId : 'searchBtn',
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
				listeners : {beforehide: function(me, eOpt)	{
											productionNoSearch.clearForm();
											productionNoMasterGrid.reset();
                						},
                			 beforeclose: function( panel, eOpts )	{
											productionNoSearch.clearForm();
											productionNoMasterGrid.reset();
                			 			},
                			 show: function( panel, eOpts )	{
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
	/*************************************************************************************************
	 * 조회장 END
	 */


    /*************************************************************************************************
	 * 출고예정표정보 참조
	 **************************************************************************************************/
		Unilite.defineModel('pmp120ukrvProductionPlanModel', {
	    	fields: [
					{name: 'DIV_CODE'						,text: '<t:message code="system.label.sales.division" default="사업장"/>' 		,type: 'string'},
					{name: 'ORDER_NUM'					,text: '<t:message code="system.label.sales.sono" default="수주번호"/>' 		,type: 'string'},
					{name: 'SER_NO'							,text: '<t:message code="system.label.sales.seq" default="순번"/>' 		    		,type: 'int'},
					{name: 'CUSTOM_CODE'				,text: '거래처코드' 		,type: 'string'},
					{name: 'CUSTOM_NAME'				,text: '<t:message code="system.label.sales.custom" default="거래처"/>' 		,type: 'string'},
					{name: 'DVRY_DATE'						,text: '<t:message code="system.label.sales.deliverydate" default="납기일"/>' 		,type: 'uniDate'},
					{name: 'ITEM_CODE'						,text: '<t:message code="system.label.sales.item" default="품목"/>' 				,type: 'string'},
					{name: 'ITEM_NAME'					,text: '<t:message code="system.label.sales.itemname" default="품목명"/>' 	,type: 'string'},
					{name: 'READY_STATUS'				,text: '준비상태' 		    	,type: 'string'	, comboType: 'AU'		, comboCode: 'Z012' },
					{name: 'PROD_END_DATE'      		,text:'생산완료일'				,type:'uniDate'},
					{name: 'LOT_NO'      						,text:'LOT NO'				,type:'string'},
					{name: 'PACK_TYPE'      				,text:'포장유형'					,type:'string'	 , comboType: 'AU'	, comboCode: 'B138' },
					{name: 'TRANS_RATE'      				,text:'포장단위'					,type:'string'},
					{name: 'ORDER_Q'      					,text:'수량'						,type:'uniQty'},
					{name: 'DVRY_CUST_CD'      			,text:'납품처'					,type:'string'},
					{name: 'ORDER_DATE'					,text: '<t:message code="system.label.sales.sodate" default="수주일"/>'	,type: 'uniDate'},
					{name: 'REMARK'      						,text:'비고'					,type:'string'}
				]
		});

	function openProductionPlanWindow() {
		if(!referProductionPlanWindow) {
			referProductionPlanWindow = Ext.create('widget.uniDetailWindow', {
                title: '출고예정표정보',
                width: 1020,
                height: 580,
                layout:{type:'vbox', align:'stretch'},

                items: [productionPlanSearch, productionPlanGrid],
                tbar:  ['->',
				        {	itemId : 'saveBtn',
							text: '<t:message code="system.label.product.inquiry" default="조회"/>',
							handler: function() {
								if(!productionPlanSearch.getInvalidMessage()) return;
								productionPlanStore.loadStoreRecords();
							},
							disabled: false
						},
						{	itemId : 'confirmBtn',
							text: '<t:message code="system.label.product.apply" default="적용"/>',
							handler: function() {
								productionPlanGrid.returnData();
								referProductionPlanWindow.hide();
							},
							disabled: false
						},
						{	itemId : 'confirmCloseBtn',
							text: '<t:message code="system.label.product.afterapplyclose" default="적용 후 닫기"/>',
							handler: function() {
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
			    ],
                listeners : {beforehide: function(me, eOpt)	{
                						},
                			 beforeclose: function( panel, eOpts )	{
                			 			},
                			 beforeshow: function ( me, eOpts )	{
                			 	productionPlanSearch.setValue('DIV_CODE',panelResult.getValue('DIV_CODE'));
                			 	productionPlanSearch.setValue('WORK_SHOP_CODE',panelResult.getValue('WORK_SHOP_CODE'));
                			 	productionPlanSearch.setValue('ITEM_CODE',panelResult.getValue('ITEM_CODE'));
                			 	productionPlanSearch.setValue('ITEM_NAME',panelResult.getValue('ITEM_NAME'));
                			 	productionPlanStore.loadStoreRecords();
                			 }
                }
			})
		}
		referProductionPlanWindow.center();
		referProductionPlanWindow.show();
    }

	//생산계획 참조 폼 정의
    var productionPlanSearch = Unilite.createSearchForm('productionPlanForm', {
            layout :  {type : 'uniTable', columns : 3},
			    items: [{
		        	fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
		        	name: 'DIV_CODE',
		        	xtype: 'uniCombobox',
		        	comboType: 'BOR120'
		        },{
					fieldLabel: '납기일',
			        xtype: 'uniDateRangefield',
			        startFieldName: 'ORDER_DATE_FR',
			        endFieldName: 'ORDER_DATE_TO',
			        startDate: UniDate.get('startOfMonth'),
			        endDate: UniDate.get('today')
		        },Unilite.popup('DIV_PUMOK',{
		        	fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
		        	valueFieldName: 'ITEM_CODE',
		    		textFieldName: 'ITEM_NAME',
		    		autoPopup: true
		       })
			]
	});

	var productionPlanStore = Unilite.createStore('pmp120ukrvProductionPlanStore', {
			model: 'pmp120ukrvProductionPlanModel',
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
                	read    : 'pmp120ukrvService.selectEstiList'
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

	var productionPlanGrid = Unilite.createGrid('pmp120ukrvproductionPlanGrid', {
    	layout : 'fit',
    	store: productionPlanStore,
        selModel: 'rowmodel',
        uniOpt:{
            onLoadSelectFirst : true
        },
        columns: [
        	{dataIndex: 'DIV_CODE'		      	, width:100, hidden: true},
			{dataIndex: 'ORDER_NUM'		      	, width:100, hidden: true},
	        {dataIndex: 'SER_NO'				    , width:100, hidden: true},
	        {dataIndex: 'CUSTOM_CODE'	      	, width:100},
	        {dataIndex: 'CUSTOM_NAME'		    , width:135},
	        {dataIndex: 'DVRY_DATE'			    , width:100, hidden: true},
	        {dataIndex: 'ITEM_CODE'		      	, width:70},
	        {dataIndex: 'ITEM_NAME'			    , width:180},
	        {dataIndex: 'REMARK'			    , width:230},
	        {dataIndex: 'READY_STATUS'		    , width:100, hidden: true},
	        {dataIndex: 'PROD_END_DATE'          , width:100, hidden: true},
	        {dataIndex: 'LOT_NO'      	        , width:100, hidden: true},
	        {dataIndex: 'PACK_TYPE'      	    , width:78},
	        {dataIndex: 'TRANS_RATE'         	, width:78},
	        {dataIndex: 'ORDER_Q'      	      	, width:100},
	        {dataIndex: 'DVRY_CUST_CD'         	, width:100, hidden: true},
	        {dataIndex: 'ORDER_DATE'		      	, width:100, hidden: true}
		],
		listeners: {
	          onGridDblClick: function(grid, record, cellIndex, colName) {
		          	productionPlanGrid.returnData(record);
		          	referProductionPlanWindow.hide();
		          	panelResult.getField('PACK_ITEM_CODE').focus();
	          		panelResult.getField('PACK_ITEM_CODE').blur();
	          }
          },
          	returnData: function(record)	{
          		panelResult.uniOpt.inLoading = true;
          		panelResult.uniOpt.inLoading = true;
	          	if(Ext.isEmpty(record))	{
	          		record = this.getSelectedRecord();
	          	}
	          	var packboxType = record.get('TRANS_RATE');;
	          	if(record.get('TRANS_RATE').length < 3){
	          		if(record.get('TRANS_RATE').length == 2){
	          			packboxType = "0" + record.get('TRANS_RATE');
	          		}else if(record.get('TRANS_RATE').length == 1){
	          			packboxType = "00" + record.get('TRANS_RATE');
	          		}
	          	}
	          	panelResult.setValues({
	          		'DIV_CODE':record.get('DIV_CODE'),   /*사업장*/
	          		'PACK_ITEM_CODE':record.get('ITEM_CODE'),				 /*품목코드*/
	          		'PACK_ITEM_NAME':record.get('ITEM_NAME'),	/*품목명*/
	          		'LOT_NO':record.get('LOT_NO'),
					'BOX_WKORD_Q' : record.get('ORDER_Q'),
					'BOX_TYPE' : packboxType,
					'ORDER_NUM'  :  record.get('ORDER_NUM'),
					'SER_NO'  :  record.get('SER_NO'),
					'REMARK' : record.get('REMARK')
	          	});
          		panelResult.uniOpt.inLoading = false;
          }
    });
	/*************************************************************************************************
	 * 생산계획을 참조 END
	 */


   /**************************************************************************************************
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
      	}
      	],
		id: 'pmp100ukrvApp',
		fnInitBinding: function(params) {
			UniAppManager.setToolbarButtons(['reset','newData', 'prev', 'next'], true);
			this.setDefault();
			if(!Ext.isEmpty(params && params.PGM_ID)){
                this.processParams(params);
            }
		},
		onQueryButtonDown: function() {
			var orderNo = panelResult.getValue('WKORD_NUM');
			if(Ext.isEmpty(orderNo)) {
				opensearchInfoWindow();

			} else {
				detailStore.loadStoreRecords();
               // panelResult.setAllFieldsReadOnly(true);

			}
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;

			var param = panelResult.getValues();
            pmp120ukrvService.selectProgInfo(param, function(provider, response) {
                var records = response.result;
                if(!Ext.isEmpty(provider)) {
                	var count = detailGrid.getStore().getCount();
                    if(count <= 0) {
                        Ext.each(records, function(record,i) {
                        	var compCode       		= UserInfo.compCode;
                            var divCode        			= panelResult.getValue('DIV_CODE');
                            var wkordNum       = panelResult.getValue('WKORD_NUM');
                        	var linSeq 						= detailStore.max('LINE_SEQ');
	                            if(!linSeq) linSeq = 1;
	                            else  linSeq += 1;
                            var progUnitQ      			= parseInt(panelResult.getValue('BOX_TYPE'));
                            //var progUnitQ      			= 1;
                            var wkordQ         			= progUnitQ * panelResult.getValue('BOX_WKORD_Q');
                            var progUnit       			= panelResult.getValue('PROG_UNIT');
                            var workShopCode   		= panelResult.getValue('WORK_SHOP_CODE');
                            var lotNo          				= panelResult.getValue('LOT_NO');
                            var prodtWkordDate 	= UniDate.getDateStr(panelResult.getValue('PRODT_WKORD_DATE'));
                            var prodtStartDate 		= UniDate.getDateStr(panelResult.getValue('PRODT_START_DATE'));
                            var prodtEndDate   		= UniDate.getDateStr(panelResult.getValue('PRODT_END_DATE'));
                            var remark         				= panelResult.getValue('REMARK');
                            var itemCode         		= panelResult.getValue('PACK_ITEM_CODE');
                            var semiItemCode			= panelResult.getValue('SEMI_ITEM_CODE');
                            var orderNum				= panelResult.getValue('ORDER_NUM');
                            var serNo						= panelResult.getValue('SER_NO');
                            var rawCellCode       = panelResult.getValue('RAW_CELL_CODE');
                            var r = {
	                    		 COMP_CODE      				: compCode,
	                             DIV_CODE         	 			: divCode,
	                             WKORD_NUM					: wkordNum,
	                             LINE_SEQ          					: linSeq,
	                             PROG_UNIT_Q      			: 1,
	                             WKORD_Q           				: wkordQ,
	                             PROG_UNIT         				: progUnit,
	                             WORK_SHOP_CODE    		: workShopCode,
	                             LOT_NO            					: lotNo,
	                             PRODT_WKORD_DATE  	: prodtWkordDate,
	                             PRODT_START_DATE  		: prodtStartDate,
	                             PRODT_END_DATE    		: prodtEndDate,
	                             REMARK            				: remark,
	                             PACK_ITEM_CODE			: itemCode,
	                             SEMI_ITEM_CODE				: semiItemCode,
	                             ORDER_NUM					: orderNum,
	                             SER_NO								: serNo,
	                             RAW_CELL_CODE			: rawCellCode
                            };
							detailGrid.createRow(r);
							detailGrid.setBeforeNewData(record);
                        });
                    } else {
                    	var compCode       		= UserInfo.compCode;
                        var divCode        			= panelResult.getValue('DIV_CODE');
                        var wkordNum       		= panelResult.getValue('WKORD_NUM');
                    	var linSeq 						= detailStore.max('LINE_SEQ');
                            if(!linSeq) linSeq = 1;
                            else  linSeq += 1;
                        var progUnitQ      			= parseInt(panelResult.getValue('BOX_TYPE'));
                        //var progUnitQ      			= 1;
                        var wkordQ         			= progUnitQ * panelResult.getValue('BOX_WKORD_Q');
                        var progUnit       			= panelResult.getValue('PROG_UNIT');
                        var workShopCode   		= panelResult.getValue('WORK_SHOP_CODE');
                        var lotNo          				= panelResult.getValue('LOT_NO');
                        var prodtWkordDate 	= UniDate.getDateStr(panelResult.getValue('PRODT_WKORD_DATE'));
                        var prodtStartDate 		= UniDate.getDateStr(panelResult.getValue('PRODT_START_DATE'));
                        var prodtEndDate   		= UniDate.getDateStr(panelResult.getValue('PRODT_END_DATE'));
                        var remark         				= panelResult.getValue('REMARK');
                        var itemCode         		= panelResult.getValue('PACK_ITEM_CODE');
                        var semiItemCode			= panelResult.getValue('SEMI_ITEM_CODE');
                        var orderNum				= panelResult.getValue('ORDER_NUM');
                        var serNo						= panelResult.getValue('SER_NO');
                        var rawCellCode       = panelResult.getValue('RAW_CELL_CODE');
                        var r = {
                    		 COMP_CODE      				: compCode,
                             DIV_CODE         	 			: divCode,
                             WKORD_NUM					: wkordNum,
                             LINE_SEQ          					: linSeq,
                             PROG_UNIT_Q      			: 1,
                             WKORD_Q           				: wkordQ,
                             PROG_UNIT         				: progUnit,
                             WORK_SHOP_CODE    		: workShopCode,
                             LOT_NO            					: lotNo,
                             PRODT_WKORD_DATE  	: prodtWkordDate,
                             PRODT_START_DATE  		: prodtStartDate,
                             PRODT_END_DATE    		: prodtEndDate,
                             REMARK            				: remark,
                             PACK_ITEM_CODE			: itemCode,
                             SEMI_ITEM_CODE				: semiItemCode,
                             ORDER_NUM					: orderNum,
                             SER_NO								: serNo,
                             RAW_CELL_CODE			: rawCellCode
                        };
                        detailGrid.createRow(r);
                    }
                } else {
                	var compCode       		= UserInfo.compCode;
                    var divCode        			= panelResult.getValue('DIV_CODE');
                    var wkordNum       = panelResult.getValue('WKORD_NUM');
                	var linSeq 						= detailStore.max('LINE_SEQ');
                        if(!linSeq) linSeq = 1;
                        else  linSeq += 1;
                     var progUnitQ      			= parseInt(panelResult.getValue('BOX_TYPE'));
                     //var progUnitQ      			= 1;
                    var wkordQ         			= progUnitQ * panelResult.getValue('BOX_WKORD_Q');
                    var progUnit       			= panelResult.getValue('PROG_UNIT');
                    var workShopCode   		= panelResult.getValue('WORK_SHOP_CODE');
                    var lotNo          				= panelResult.getValue('LOT_NO');
                    var prodtWkordDate 	= UniDate.getDateStr(panelResult.getValue('PRODT_WKORD_DATE'));
                    var prodtStartDate 		= UniDate.getDateStr(panelResult.getValue('PRODT_START_DATE'));
                    var prodtEndDate   		= UniDate.getDateStr(panelResult.getValue('PRODT_END_DATE'));
                    var remark         				= panelResult.getValue('REMARK');
                    var itemCode         		= panelResult.getValue('PACK_ITEM_CODE');
                    var semiItemCode			= panelResult.getValue('SEMI_ITEM_CODE');
                    var orderNum				= panelResult.getValue('ORDER_NUM');
                    var serNo						= panelResult.getValue('SER_NO');
                    var rawCellCode       = panelResult.getValue('RAW_CELL_CODE');
                    var r = {
                		 COMP_CODE      				: compCode,
                         DIV_CODE         	 			: divCode,
                         WKORD_NUM					: wkordNum,
                         LINE_SEQ          					: linSeq,
                         PROG_UNIT_Q      			: 1,
                         WKORD_Q           				: wkordQ,
                         PROG_UNIT         				: progUnit,
                         WORK_SHOP_CODE    		: workShopCode,
                         LOT_NO            					: lotNo,
                         PRODT_WKORD_DATE  	: prodtWkordDate,
                         PRODT_START_DATE  		: prodtStartDate,
                         PRODT_END_DATE    		: prodtEndDate,
                         REMARK            				: remark,
                         PACK_ITEM_CODE			: itemCode,
                         SEMI_ITEM_CODE				: semiItemCode,
                         ORDER_NUM					: orderNum,
                         SER_NO								: serNo,
                         RAW_CELL_CODE			: rawCellCode
                    };
                    detailGrid.createRow(r);
                }
            });

		},
		onResetButtonDown: function() {
			panelResult.uniOpt.inLoading = true;
			panelResult.clearForm();
            panelResult.setAllFieldsReadOnly(false);
			detailGrid.reset();
			detailStore.clearData();
			this.fnInitBinding();
			panelResult.getField('WKORD_NUM').focus();
			this.setDefault();
			panelResult.uniOpt.inLoading = false;
          	panelResult.uniOpt.inLoading = false;
		},
		onSaveDataButtonDown: function(config) {
			detailStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
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
                        if(deletable){
                            detailGrid.reset();
                            UniAppManager.app.onSaveDataButtonDown();
                        }
                        isNewData = false;
                    }
                    return false;
                }
            });
            if(isNewData){                              //신규 레코드들만 있을시 그리드 리셋
                detailGrid.reset();
                UniAppManager.app.onResetButtonDown();  //삭제후 RESET..
            }
        },
		setDefault: function() {
			if(Ext.isEmpty(BsaCodeInfo.gsUseWorkColumnYn) || BsaCodeInfo.gsUseWorkColumnYn != 'Y') {

			}
        	panelResult.setValue('DIV_CODE',UserInfo.divCode);
        	panelResult.setValue('PRODT_WKORD_DATE',new Date());
        	panelResult.setValue('PRODT_START_DATE',new Date());
        	panelResult.setValue('PRODT_END_DATE',new Date());
        	panelResult.setValue('WKORD_Q',0.00);
        	panelResult.setValue('ORDER_Q',0.00);
        	panelResult.setValue('WORK_SHOP_CODE','W30');
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
		},
		setReadOnly: function(flag) {
        	panelResult.getField('DIV_CODE').setReadOnly(true);
        	panelResult.getField('WKORD_NUM').setReadOnly(true);
        	panelResult.getField('WORK_END_YN').setReadOnly(flag);
        	panelResult.getField('EXCHG_TYPE').setReadOnly(flag);
        	panelResult.getField('DIV_CODE').setReadOnly(true);
        	panelResult.getField('WKORD_NUM').setReadOnly(true);
        	panelResult.getField('WORK_END_YN').setReadOnly(flag);
        	panelResult.getField('EXCHG_TYPE').setReadOnly(flag);
        	Ext.getCmp('rework').setReadOnly(flag);
        	Ext.getCmp('reworkRe').setReadOnly(flag);
		},
		checkForNewDetail:function() {
            if(panelResult.setAllFieldsReadOnly(true)){
                return panelResult.setAllFieldsReadOnly(true);
            }
        },
        //S_SOF120UKRV_IN PROCESS
        processParams: function(params) {
        	UniAppManager.app.onResetButtonDown();
        	if(params.PGM_ID == 's_sof120ukrv_in') {
                panelResult.setValue('DIV_CODE',params.formPram.DIV_CODE);
                panelResult.setValue('PACK_ITEM_CODE',params.ITEM_CODE);
                panelResult.setValue('PACK_ITEM_NAME',params.ITEM_NAME);
                panelResult.setValue('BOX_WKORD_Q',params.ORDER_Q);
                panelResult.setValue('LOT_NO',params.LOT_NO);
                panelResult.setValue('REMARK',params.REMARK);
                panelResult.setValue('PRODT_WKORD_DATE',params.DVRY_DATE);
                panelResult.setValue('PRODT_START_DATE',params.DVRY_DATE);
                panelResult.setValue('PRODT_END_DATE',params.DVRY_DATE);
                var packboxType = params.TRANS_RATE;
	          	if(params.TRANS_RATE.length < 3){
	          		if(params.TRANS_RATE.length == 2){
	          			packboxType = "0" + params.TRANS_RATE
	          			 panelResult.setValue('BOX_TYPE',packboxType);
	          		}else if(params.TRANS_RATE.length == 1){
	          			packboxType = "00" + params.TRANS_RATE;
	          			panelResult.setValue('BOX_TYPE',packboxType);
	          		}
	          	}else{
	          		panelResult.setValue('BOX_TYPE',packboxType);
	          	}
            }
            var param = {"ITEM_CODE": params.ITEM_CODE};
			pmp120ukrvService.selectSemiItem(param, function(provider, response) {
                if(!Ext.isEmpty(provider)&&!Ext.isEmpty(response.result.data[0])){
                	panelResult.setValue('SEMI_ITEM_CODE', response.result.data[0].ITEM_CODE);
                	panelResult.setValue('SEMI_ITEM_NAME', response.result.data[0].ITEM_NAME);
                }else{

                }
            });
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

				case "WKORD_Q", "LINE_SEQ"	: // 작업지시량 , 공정순번

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