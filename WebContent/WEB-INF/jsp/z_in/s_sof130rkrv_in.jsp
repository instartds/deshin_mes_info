<%--
'   프로그램명 : 수주현황조회 (영업)
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
<t:appConfig pgmId="s_sof130rkrv_in"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_sof130rkrv_in"/> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B139"/>  					<!-- 박스형태 -->
	<t:ExtComboStore comboType="AU" comboCode="S106"/>  					<!-- 라벨종류 -->
	<t:ExtComboStore comboType="AU" comboCode="B138"/>  					<!-- 포장형태 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333; font-weight: normal; padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	
	//Ext.create('Ext.data.Store', {
	//	storeId:"printType",
	//    fields: ['text', 'value'],
	//    data : [
	//        {text:"의료기기",   value:"A"},
	//        {text:"산업체"	 ,   value:"B"}
	//    ]
	//});
	
	Unilite.defineModel('S_sof130rkrv_inModel', {
	    fields: [
			{name: 'ORDER_NUM'		 		, text:'<t:message code="system.label.sales.sono" default="수주번호"/>' 						, type:'string'},
			{name: 'SER_NO'		 				, text:'SER_NO' 						, type:'string'},
			{name: 'CUSTOM_CODE'		 	, text:'<t:message code="system.label.sales.custom" default="거래처코드"/>'   			, type:'string'},  
			{name: 'CUSTOM_NAME'			, text:'<t:message code="system.label.sales.customname" default="거래처"/>'			, type:'string'},
			{name: 'ITEM_CODE'             	, text:'<t:message code="system.label.sales.itemcode" default="품목코드"/>'             , type: 'string'},
			{name: 'ITEM_NAME'		 		, text:'<t:message code="system.label.sales.itemname" default="품목명"/>' 				, type:'string'},
			{name: 'LOT_NO'						, text:'LOT NO'				,type:'string'},
			{name: 'ORDER_Q'                		, text:'생산량'          			, type: 'uniQty'},
			{name: 'ORDER_UNIT'             	, text:'<t:message code="system.label.sales.salesunit" default="판매단위"/>'             	, type: 'string'},
			
			{name: 'PACK_TYPE'             		, text:'포장형태'             	, type: 'string'   , comboType:"AU", comboCode:"B138"},
			{name: 'BOX_TYPE'             		, text:'박스형태'             	, type: 'string'   , comboType:"AU", comboCode:"B139"},
			{name: 'ADD_VALUE'						, text:'추가내용'				,type:'string'},
			{name: 'D_CNT'             			, text:'출력배수'             	, type: 'int'},
			{name: 'PRINT_Q'             			, text:'출력수량'             	, type: 'int'},
			{name: 'LABEL_TYPE'					, text: '출력양식'				, type: 'string' , xtype:'uniCombobox', comboType: 'AU', comboCode:'S106'}	//store: Ext.data.StoreManager.lookup('printType')},
			
		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('s_sof130rkrv_inMasterStore1', {
		model: 'S_sof130rkrv_inModel',
		uniOpt: {
           	isMaster: false,			// 상위 버튼,상태바 연결
           	editable: true,		// 수정 모드 사용
           	deletable:false,		// 삭제 가능 여부
            useNavi: false			// prev | next 버튼 사용
		},
        autoLoad: false,
        proxy: {
        	type: 'direct',
            api: {
            	read: 's_sof130rkrv_inService.selectList1'
		    }
		},
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			this.load({
				params: param
			});
		},
        listeners: {
            load: function(store, records, successful, eOpts) {
            	Ext.each(records, function(record,i) {	
                	if(Ext.isEmpty(record.get('LABEL_TYPE'))){
                		record.set('LABEL_TYPE','A');
                	}
                	if(record.get('BOX_TYPE')  <= 50){
                		record.set('BOX_TYPE','050');
                	}
                	record.set('PRINT_Q', Math.ceil(record.get('ORDER_Q')/record.get('BOX_TYPE') * record.get('D_CNT')));
				}); 
            	store.commitChanges(); 
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {
            	store.commitChanges(); 
            }
        }
	});

	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,//true,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
	    	items: [{
				fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '생산일',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'PRODT_START_DATE',
		        endFieldName: 'PRODT_END_DATE',
		        width: 470,
		        allowBlank: false, 
		        startDate: UniDate.get('startOfMonth'),
		        endDate: UniDate.get('today'),
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
		        	if(panelResult) {
						panelResult.setValue('PRODT_START_DATE',newValue);
		        	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('PRODT_END_DATE',newValue);
			    	}
				}
	        },Unilite.popup('DIV_PUMOK',{
				fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName: 'ITEM_CODE',
				textFieldName: 'ITEM_NAME',
				autoPopup: true,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_NAME', newValue);
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
			})/* ,{   
	        	   fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
			       name: 'ORDER_TYPE',
			       comboType: 'AU',
			       comboCode: 'S002',
			       xtype: 'uniCombobox',
			       allowBlank:true,
			       holdable: 'hold',
			       value: '10',
			       listeners: {
			           change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ORDER_TYPE',newValue);
			        	   if(newValue == '10'){
								panelSearch.setValue('LABEL_TYPE', 'A');
							}else{
								panelSearch.setValue('LABEL_TYPE', 'B');
							}
			           }
			       }
			   },{
				xtype: 'radiogroup',
				fieldLabel: '라벨유형',
				id: 'LABEL_TYPE1',
				items: [{
					boxLabel: '의료기기',
					width: 80,
					name: 'LABEL_TYPE',
					inputValue: 'A',
					checked: true
				}, {
					boxLabel: '산업체',
					width: 80, 
					name: 'LABEL_TYPE',
					inputValue: 'B'
				}],
				listeners: {
			           change: function(field, newValue, oldValue, eOpts) {
			        	   panelResult.getField('LABEL_TYPE').setValue(newValue.LABEL_TYPE);
			        	   if(newValue == 'A'){
			        		   panelSearch.setValue('ORDER_TYPE', '10');
							}
			           }
			       }
			},Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
				valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME',
				extParam: {'CUSTOM_TYPE':['1','3']},
                autoPopup: true,
                listeners: {
                            onValueFieldChange: function(field, newValue){
                            	panelResult.setValue('CUSTOM_CODE', newValue);
                            },
                            onTextFieldChange: function(field, newValue){
                            	panelResult.setValue('CUSTOM_NAME', newValue);
                            },
                            applyextparam: function(popup) {
        						popup.setExtParam({'CUSTOM_TYPE':['1','3']});
        					}
                        }
            }) */,{
		         	xtype:'button',
		         	text:'라벨출력',
		         	id: 'btnPrint1',
		         	width: 150,
 		         	margin : '0 0 0 95',
 		         	handler:function()	{
		    			  var param = panelResult.getValues();
		  				  var selectedDetails = masterGrid.getSelectedRecords();
		                    param["PGM_ID"]= PGM_ID;
		                	var itemLot= "";
		                	var itemPrint = "";
		                	var cntLabelTypeA = 0;
		                	var cntLabelTypeB = 0;
		                	var cntLabelTypeC = 0;
		                	Ext.each(selectedDetails, function(record, idx) {
		                		if(idx ==0) {
		                			itemLot = record.get("ITEM_CODE")+record.get('LOT_NO');
		                			itemPrint = record.get("ITEM_CODE")+record.get('LOT_NO')+"^"+ record.get('LABEL_TYPE') + "^" + record.get('PRINT_Q') + "^" + record.get('BOX_TYPE');
		                    	}else{
		                    		itemLot = itemLot + ',' + record.get("ITEM_CODE")+record.get('LOT_NO');
		                    		itemPrint = itemPrint + ',' + record.get("ITEM_CODE")+record.get('LOT_NO')+"^"+ record.get('LABEL_TYPE') + "^" + record.get('PRINT_Q') + "^" + record.get('BOX_TYPE');
		                    	}
		                    	if(record.get('LABEL_TYPE') == "A")
		                    		cntLabelTypeA++;
		                    	else if(record.get('LABEL_TYPE') == "B")
		                    		cntLabelTypeB++;
		                    	else if(record.get('LABEL_TYPE') == "C")
		                    		cntLabelTypeC++;
		    				});
		                	panelResult.setValue('ITEM_PRINT', itemPrint);
		                	panelResult.setValue('ITEM_LOT', itemLot);
		                	param = panelResult.getValues();
		                    if(Ext.isEmpty(panelResult.getValue('ITEM_PRINT'))){
		                    	Ext.getCmp('btnPrint1').disable();  
		            			Ext.getCmp('btnPrint2').disable(); 
		                    }else{
		                    	Ext.getCmp('btnPrint1').enable();  
		            			Ext.getCmp('btnPrint2').enable(); 
		                    }
		                    
		                    if(cntLabelTypeA + cntLabelTypeB > 0 && cntLabelTypeC > 0) {
		                    	alert("STEMP 양식은 다른 양식과 함께 출력하실 수 없습니다.");
		                    	return;
		                    }
		                    
		                    if(cntLabelTypeC > 0) {
								var win = Ext.create('widget.ClipReport', {
									url: CPATH+'/z_in/s_sof130clrkrv_in2.do',
									prgID: 's_sof130rkrv_in',
									extParam: param
								});
								win.center();
								win.show();
		                    }
		                    else {
								var win = Ext.create('widget.ClipReport', {
									url: CPATH+'/z_in/s_sof130clrkrv_in.do',
									prgID: 's_sof130rkrv_in',
									extParam: param
								});
								win.center();
								win.show();
		                    }
	         			}
	         },{
		 		    xtype: 'radiogroup',
				    fieldLabel: '옵션',
				    id: 'optRadio',
				    colspan: 2,
				    items : [{
				    	boxLabel: '생산',
				    	name: 'OPT' ,
				    	inputValue: 'P',
				    	checked: true,
				    	width:95
				    }, {boxLabel: '출고예정',
				    	name: 'OPT',
				    	inputValue: '11',
				    	width:95
				    }],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.getField('OPT').setValue(newValue.OPT);
						}
					}
				},{
		            fieldLabel: 'LOT NO',
		            name:'LOT_NO',
		            xtype: 'uniTextfield',
					listeners: {
						change: function(combo, newValue, oldValue, eOpts) {
							panelResult.setValue('LOT_NO', newValue);
						}
					}
		        }
			]
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
				   	alert(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
				   	invalid.items[0].focus();
				}
	  		}
			return r;
  		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
				fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'PRODT_START_DATE',
		        endFieldName: 'PRODT_END_DATE',
		        allowBlank: false, 
		        startDate: UniDate.get('startOfMonth'),
		        endDate: UniDate.get('today'),
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
		        	if(panelResult) {
						panelResult.setValue('PRODT_START_DATE',newValue);
		        	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('PRODT_END_DATE',newValue);
			    	}
				}
	        },Unilite.popup('DIV_PUMOK',{
				fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName: 'ITEM_CODE',
				textFieldName: 'ITEM_NAME',
				autoPopup: true,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('ITEM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('ITEM_NAME', newValue);
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
			})/* ,{   
	        	   fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
			       name: 'ORDER_TYPE',
			       comboType: 'AU',
			       comboCode: 'S002',
			       xtype: 'uniCombobox',
			       allowBlank:true,
			       value: '10',
			       listeners: {
			           change: function(field, newValue, oldValue, eOpts) {
			        	   panelSearch.setValue('ORDER_TYPE',newValue);
			        	   if(newValue == '10'){
								panelResult.setValue('LABEL_TYPE', 'A');
							}else{
								panelResult.setValue('LABEL_TYPE', 'B');
							}
			           }
			       }
			   },{
				xtype: 'radiogroup',
				fieldLabel: '라벨유형',
				id: 'LABEL_TYPE2',
				items: [{
					boxLabel: '의료기기',
					width: 80,
					name: 'LABEL_TYPE',
					inputValue: 'A',
					checked: true
				}, {
					boxLabel: '산업체',
					width: 80, 
					name: 'LABEL_TYPE',
					inputValue: 'B'
				}],
				listeners: {
			           change: function(field, newValue, oldValue, eOpts) {
			        	   panelSearch.getField('LABEL_TYPE').setValue(newValue.LABEL_TYPE);
			        	   if(newValue == 'A'){
								panelResult.setValue('ORDER_TYPE', '10');
							}
			           }
			       }
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
				extParam: {'CUSTOM_TYPE':['1','3']},
				valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME',
				autoPopup: true,
                listeners: {
                            onValueFieldChange: function(field, newValue){
                            	panelSearch.setValue('CUSTOM_CODE', newValue);
                            },
                            onTextFieldChange: function(field, newValue){
                            	panelSearch.setValue('CUSTOM_NAME', newValue);
                            },
                            applyextparam: function(popup) {
        						popup.setExtParam({'CUSTOM_TYPE':['1','3']});
        					}
                        }
            }) */,{
 		         	xtype:'button',
 		         	text:'라벨출력',
 		         	id: 'btnPrint2',
 		         	margin : '0 4 1 10',
 		         	handler:function()	{
		    			  var param = panelResult.getValues();
		  				  var selectedDetails = masterGrid.getSelectedRecords();
		                    param["PGM_ID"]= PGM_ID;
		                	var itemLot= "";
		                	var itemPrint = "";
		                	var cntLabelTypeA = 0;
		                	var cntLabelTypeB = 0;
		                	var cntLabelTypeC = 0;
		                	Ext.each(selectedDetails, function(record, idx) {
		                		if(idx ==0) {
		                			itemLot = record.get("ITEM_CODE")+record.get('LOT_NO');
		                			itemPrint = record.get("ITEM_CODE")+record.get('LOT_NO')+"^"+ record.get('LABEL_TYPE') + "^" + record.get('PRINT_Q') + "^" + record.get('BOX_TYPE')+ "^" + record.get('PACK_TYPE')+ "^" + record.get('ADD_VALUE');
		                    	}else{
		                    		itemLot = itemLot + ',' + record.get("ITEM_CODE")+record.get('LOT_NO');
		                    		itemPrint = itemPrint + ',' + record.get("ITEM_CODE")+record.get('LOT_NO')+"^"+ record.get('LABEL_TYPE') + "^" + record.get('PRINT_Q') + "^" + record.get('BOX_TYPE')+ "^" + record.get('PACK_TYPE')+ "^" + record.get('ADD_VALUE');
		                    	}
		                    	if(record.get('LABEL_TYPE') == "A")
		                    		cntLabelTypeA++;
		                    	else if(record.get('LABEL_TYPE') == "B")
		                    		cntLabelTypeB++;
		                    	else if(record.get('LABEL_TYPE') == "C")
		                    		cntLabelTypeC++;
		    				});
		                	panelResult.setValue('ITEM_PRINT', itemPrint);
		                	panelResult.setValue('ITEM_LOT', itemLot);
		                	param = panelResult.getValues();
		                    if(Ext.isEmpty(panelResult.getValue('ITEM_PRINT'))){
		                    	Ext.getCmp('btnPrint1').disable();  
		            			Ext.getCmp('btnPrint2').disable(); 
		                    }else{
		                    	Ext.getCmp('btnPrint1').enable();  
		            			Ext.getCmp('btnPrint2').enable(); 
		                    }
		                    
		                    if(cntLabelTypeA + cntLabelTypeB > 0 && cntLabelTypeC > 0) {
		                    	alert("STEMP 양식은 다른 양식과 함께 출력하실 수 없습니다.");
		                    	return;
		                    }
		                    
		                    if(cntLabelTypeC > 0) {
								var win = Ext.create('widget.ClipReport', {
									url: CPATH+'/z_in/s_sof130clrkrv_in2.do',
									prgID: 's_sof130rkrv_in',
									extParam: param
								});
								win.center();
								win.show();
		                    }
		                    else {
								var win = Ext.create('widget.ClipReport', {
									url: CPATH+'/z_in/s_sof130clrkrv_in.do',
									prgID: 's_sof130rkrv_in',
									extParam: param
								});
								win.center();
								win.show();
		                    }
	         			}
	         },{
	 		    xtype: 'radiogroup',
			    fieldLabel: '옵션',
			    colspan: 2,
			    items : [{
			    	boxLabel: '생산',
			    	name: 'OPT' ,
			    	inputValue: 'P',
			    	checked: true,
			    	width:95
			    }, {boxLabel: '출고예정',
			    	name: 'OPT',
			    	inputValue: '11',
			    	width:95
			    }],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.getField('OPT').setValue(newValue.OPT);
					}
				}
			},{
	            fieldLabel: 'LOT NO',
	            name:'LOT_NO',
	            xtype: 'uniTextfield',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelSearch.setValue('LOT_NO', newValue);
					}
				}
	        },{
	             fieldLabel: 'ITEM_PRINT',
	             xtype: 'uniTextfield',
	             name: 'ITEM_PRINT',
	             hidden: true
	         },{
	             fieldLabel: 'ITEM_LOT',
	             xtype: 'uniTextfield',
	             name: 'ITEM_LOT',
	             hidden: true
	         }
		]
    });
	
	/**
     * Master Grid1 정의(Grid Panel),
     * @type
     */
    var masterGrid = Unilite.createGrid('s_sof130rkrv_inGrid1', {
    	layout: 'fit',
    	region:'center',
    	selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
            listeners: {
                select: function(grid, selectRecord, index, rowIndex, eOpts ){
                    /* if(Ext.isEmpty(panelResult.getValue('ORDER_NUM'))) {
                        panelResult.setValue('ORDER_NUM', selectRecord.get('ORDER_NUM'));
                    } else {
                        var orderNums = panelResult.getValue('ORDER_NUM');
                        orderNums = orderNums + ',' + selectRecord.get('ORDER_NUM');
                        panelResult.setValue('ORDER_NUM', orderNums);
                    } */
                    if(Ext.isEmpty(selectRecord)){
                    	Ext.getCmp('btnPrint1').disable();  
            			Ext.getCmp('btnPrint2').disable(); 
                    }else{
                    	Ext.getCmp('btnPrint1').enable();  
            			Ext.getCmp('btnPrint2').enable(); 
                    }
                },
                deselect:  function(grid, selectRecord, index, eOpts ){
                	/* var selectedDetails = masterGrid.getSelectedRecords();
                	var orderNums = "";
                	Ext.each(selectedDetails, function(record, idx) {
                		if(idx ==0) {
                			orderNums = record.get("ORDER_NUM");
                    	}else{
                    		orderNums = orderNums + ',' + record.get("ORDER_NUM");
                    	}
    				});
                	panelResult.setValue('ORDER_NUM', orderNums); */
                	var selectedDetails = masterGrid.getSelectedRecords();
                    if(Ext.isEmpty(selectedDetails)){
                    	Ext.getCmp('btnPrint1').disable();  
            			Ext.getCmp('btnPrint2').disable(); 
                    }else{
                    	Ext.getCmp('btnPrint1').enable();  
            			Ext.getCmp('btnPrint2').enable(); 
                    }
                } 
            }
        }),
        uniOpt: {
        	expandLastColumn: true,
    		useGroupSummary: false,
    		useLiveSearch: false,
			useContextMenu: false,
			useRowContext 		: true,
			onLoadSelectFirst: false,
            filter: {
                useFilter: false,
                autoCreate: false
            }

        },
    	store: directMasterStore,
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],

        columns: [
			{dataIndex: 'ITEM_CODE'     		, width: 100,
					summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
	              	return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
	            }	
			},
			{dataIndex: 'ITEM_NAME'		 		, width: 200},
			{dataIndex: 'LOT_NO'			 	, width: 130},
			{dataIndex: 'ORDER_Q'      			, width: 100, summaryType: 'sum'},
			{dataIndex: 'ORDER_UNIT'             , width: 100}, 
			{dataIndex: 'PACK_TYPE'               , width: 100}, 
			{dataIndex: 'BOX_TYPE'               , width: 100}, 
			{dataIndex: 'ADD_VALUE'               , width: 100,hidden:true}, 
			{dataIndex: 'D_CNT'               , width: 100}, 
			{dataIndex: 'PRINT_Q'                , width: 100},
			{dataIndex: 'LABEL_TYPE'                , width: 120}
			/* { text:'프로세스' , dataIndex:'service', width: 128,
 			   renderer:function(value,cellmeta){   
 				   return "<input type='button'  style= 'background-color: #ececec; border-style: groove; border-color: #f1f1f1; width: 116px;' value='거래명세서 출력' >"
 				},
                	listeners:{  
                   	click:function(val,metaDate,record,rowIndex,colIndex,store,view){
                 		var params = store;
							masterGrid.printBtn(params);
                    	}
 				}
            },
            {dataIndex: 'DEAL_REPORT_TYPE'    		, width: 120}, */

		],
		 listeners: {
	        	beforeedit: function( editor, e, eOpts ) {
					 if(!e.record.phantom) {
						if(UniUtils.indexOf(e.field, ['PRINT_Q','BOX_TYPE','LABEL_TYPE','PACK_TYPE','ADD_VALUE','D_CNT'])) 
						{ 
							return true;
		  				} else {
		  					return false;
		  				}
					} else {
						if(UniUtils.indexOf(e.field, ['PRINT_Q','BOX_TYPE','LABEL_TYPE','PACK_TYPE','ADD_VALUE','D_CNT']))
					   	{
							return true;
		  				} else {
		  					return false;
		  				}
					}
				},cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
					//beforeRowIndex = rowIndex;
				}
			 }/* ,
        printBtn:function(record){
				var param= record.data;
				if(record.data.DEAL_REPORT_TYPE == '15'){
					var win = Ext.create('widget.ClipReport', {
						url: CPATH+'/sales/sof120clskrv_5.do',
						prgID: 's_sof130rkrv_in_5',
						extParam: param
						});
						win.center();
						win.show(); 
				}else{
					var win = Ext.create('widget.ClipReport', {
						url: CPATH+'/sales/sof120clskrv.do',
						prgID: 's_sof130rkrv_in',
						extParam: param
						});
						win.center();
						win.show(); 
				}
        }  */
    });

    Unilite.Main({
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
		id: 's_sof130rkrv_inApp',
		fnInitBinding: function() {
			panelResult.getField('OPT').setValue('P');
			panelSearch.getField('OPT').setValue('P');
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
        	panelSearch.setValue('PRODT_END_DATE', UniDate.get('today'));
			panelSearch.setValue('PRODT_START_DATE', UniDate.get('startOfMonth', panelSearch.getValue('ORDER_DATE_TO')));
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
        	panelResult.setValue('PRODT_END_DATE', UniDate.get('today'));
			panelResult.setValue('PRODT_START_DATE', UniDate.get('startOfMonth', panelSearch.getValue('ORDER_DATE_TO')));
			Ext.getCmp('btnPrint1').disable();  
			Ext.getCmp('btnPrint2').disable(); 
		},
		onQueryButtonDown: function()	{
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
			masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			this.fnInitBinding();
		}
	});
    
    Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			var rv = true;
			switch(fieldName) {
				case "BOX_TYPE" :	// 발생시간
					if(parseInt(newValue) > record.get('ORDER_Q')) {
						rv= '생산량 보다 큰 박스형태수량을 입력할 수 없습니다.';
						break;
					}else{
						record.set('PRINT_Q', Math.ceil(record.get('ORDER_Q')/parseInt(newValue)*record.get('D_CNT')));
					}
				case "D_CNT" :	// 출력배수
						record.set('PRINT_Q', Math.ceil(record.get('ORDER_Q')/parseInt(record.get('BOX_TYPE'))*parseInt(newValue)));
				break;
			}
			return rv;
		}
	});
};
</script>
