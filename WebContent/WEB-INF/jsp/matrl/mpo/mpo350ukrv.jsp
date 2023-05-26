<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mpo350ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="mpo350ukrv" /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주유형 -->
	<t:ExtComboStore comboType="AU" comboCode="M002" /> <!-- 진행상태 -->
 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {   
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mpo350ukrvService.selectList',
			update: 'mpo350ukrvService.deadLineUpdate',
			syncAll: 'mpo350ukrvService.saveAll'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */    			
	Unilite.defineModel('Mpo350ukrvModel', {
	    fields: [  	 
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		,type: 'string'},
			{name: 'STATUS_CODE'		,text: '<t:message code="system.label.purchase.statuscode" default="상태코드"/>'		,type: 'string'},
            {name: 'CLOSE_FLAG'         ,text: 'CLOSE_FLAG' ,type: 'string'},
            {name: 'FLAG_NAME'          ,text: '<t:message code="system.label.purchase.closingyn" default="마감여부"/>'     ,type: 'string'},
            {name: 'STATUS_CODE'        ,text: '<t:message code="system.label.purchase.statuscode" default="상태코드"/>'       ,type: 'string'},
			{name: 'STATUS_CODE_HIDE'	,text: '<t:message code="system.label.purchase.statuscode" default="상태코드"/>hide'	,type: 'string'},
			{name: 'STATUS_NAME'		,text: '<t:message code="system.label.purchase.status" default="상태"/>'			,type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'    	,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'		    ,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.purchase.spec" default="규격"/>'			,type: 'string'},
			{name: 'ORDER_DATE'			,text: '<t:message code="system.label.purchase.podate" default="발주일"/>'      	,type: 'uniDate'},
			{name: 'DVRY_DATE'			,text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'		    ,type: 'uniDate'},
			{name: 'ORDER_Q'			,text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'      	,type: 'uniQty'},
			{name: 'RECEIPT_Q'			,text: '입고대기량'      	,type: 'uniQty'},
			{name: 'INSTOCK_Q'			,text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'      	,type: 'uniQty'},
			{name: 'ACCOUNT_Q'			,text: '<t:message code="system.label.purchase.billqty" default="계산서량"/>'		,type: 'uniQty'},
			{name: 'BAL_Q'				,text: '<t:message code="system.label.purchase.undeliveryqty" default="미납량"/>'		    ,type: 'uniQty'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.purchase.unit" default="단위"/>'        	,type: 'string'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'    	,type: 'string'},
			{name: 'ORDER_SEQ'			,text: '<t:message code="system.label.purchase.seq" default="순번"/>'        	,type: 'int'},
			{name: 'AGREE_STATUS' 		,text: '<t:message code="system.label.purchase.approvalstatus" default="승인상태"/>'		,type: 'string',comboType:'AU', comboCode:'M007'},
			{name: 'ORDER_TYPE'			,text: '<t:message code="system.label.purchase.potypecode" default="발주형태코드"/>'	,type: 'string'},
			{name: 'ORDERTYPE_NAME'		,text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'    	,type: 'string'},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'  	,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'    	,type: 'string'},
			{name: 'REMARK'				,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'        	,type: 'string'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'       ,type: 'string'}
		]  
	});		
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */			
	
	var directMasterStore1 = Unilite.createStore('mpo350ukrvMasterStore1',{
		model: 'Mpo350ukrvModel',
		uniOpt: {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable: false,			// 삭제 가능 여부 
            useNavi: false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
		loadStoreRecords: function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params: param
			});			
		},
		saveStore : function()	{	
			var paramMaster= panelSearch.getValues();
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						directMasterStore1.loadStoreRecords();
					 } 
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});		
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items:[{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
                fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
                name:'ORDER_TYPE',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'M001',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('ORDER_TYPE', newValue);
                    }
                }
            },{
                fieldLabel:'<t:message code="system.label.purchase.pono" default="발주번호"/>',  
                name: 'ORDER_NUM_FR',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('ORDER_NUM_FR', newValue);
                    }
                }
            },{
                fieldLabel:'~',  
                name: 'ORDER_NUM_TO',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('ORDER_NUM_TO', newValue);
                    }
                }
            },
			Unilite.popup('CUST', {
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName:'CUSTOM_CODE',
		    	textFieldName:'CUSTOM_NAME',
				extParam: {'CUSTOM_TYPE': ['1','2']},
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('CUSTOM_CODE', newValue);
								panelResult.setValue('CUSTOM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('CUSTOM_NAME', '');
									panelResult.setValue('CUSTOM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('CUSTOM_NAME', newValue);
								panelResult.setValue('CUSTOM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('CUSTOM_CODE', '');
									panelResult.setValue('CUSTOM_CODE', '');
								}
							},
				            applyextparam: function(popup){
				                    popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
				                    popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
		                	}
					}
			}),
            Unilite.popup('DIV_PUMOK',{ 
                fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
                valueFieldName:'ITEM_CODE',
                textFieldName:'ITEM_NAME',
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('ITEM_CODE', newValue);
								panelResult.setValue('ITEM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('ITEM_NAME', '');
									panelResult.setValue('ITEM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('ITEM_NAME', newValue);
								panelResult.setValue('ITEM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('ITEM_CODE', '');
									panelResult.setValue('ITEM_CODE', '');
								}
							},
						applyextparam: function(popup){	// 2021.08 표준화 작업
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							popup.setExtParam({'ITEM_ACCOUNT_FILTER': BsaCodeInfo.gsItemAccnt.split(',')});
						}
					}
            }),
            Unilite.popup('PJT',{ 
                fieldLabel: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>', 
                textFieldWidth: 170, 
                textFieldName:'PJT_CODE',
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            panelResult.setValue('PJT_CODE', panelSearch.getValue('PJT_CODE'));
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult.setValue('PJT_CODE', '');
                    }
                }
            }),{
	        	fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
	        	xtype: 'uniDateRangefield',
	        	startFieldName: 'ORDER_DATE_FR',
	        	endFieldName: 'ORDER_DATE_TO',
	        	startDate: UniDate.get('startOfMonth'),
	        	endDate: UniDate.get('today'),
	        	onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('ORDER_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('ORDER_DATE_TO',newValue);
			    	}
			    }
			},{
	        	fieldLabel: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>',
	        	xtype: 'uniDateRangefield',
	        	startFieldName: 'DVRY_DATE_FR',
	        	endFieldName: 'DVRY_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('DVRY_DATE_FR',newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('DVRY_DATE_TO',newValue);
                    }
                }
			},{
				fieldLabel: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>',
				name:'CONTROL_STATUS',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'M002',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('CONTROL_STATUS', newValue);
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
   						var labelText = invalid.items[0]['fieldLabel']+':';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
   					}
				   	alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
				   	invalid.items[0].focus();
				} else {
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
					})      
   				}
	  		} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;	
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
    });		    
    
    
    var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
                fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
                value: UserInfo.divCode,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('DIV_CODE', newValue);
                    }
                }
            },
            Unilite.popup('CUST', {
                fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
                valueFieldName:'CUSTOM_CODE',
                textFieldName:'CUSTOM_NAME',
                extParam: {'CUSTOM_TYPE': ['1','2']},
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('CUSTOM_CODE', newValue);
								panelResult.setValue('CUSTOM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('CUSTOM_NAME', '');
									panelResult.setValue('CUSTOM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('CUSTOM_NAME', newValue);
								panelResult.setValue('CUSTOM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('CUSTOM_CODE', '');
									panelResult.setValue('CUSTOM_CODE', '');
								}
							},
				            applyextparam: function(popup){
				                    popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
				                    popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
		                	}
					}
            }),{
                fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
                xtype: 'uniDateRangefield',
                startFieldName: 'ORDER_DATE_FR',
                endFieldName: 'ORDER_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelSearch.setValue('ORDER_DATE_FR',newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelSearch.setValue('ORDER_DATE_TO',newValue);
                    }
                }
            },{
                fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
                name:'ORDER_TYPE',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'M001',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('ORDER_TYPE', newValue);
                    }
                }
            },
            Unilite.popup('DIV_PUMOK',{ 
                fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
                valueFieldName:'ITEM_CODE',
                textFieldName:'ITEM_NAME',
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('ITEM_CODE', newValue);
								panelResult.setValue('ITEM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('ITEM_NAME', '');
									panelResult.setValue('ITEM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('ITEM_NAME', newValue);
								panelResult.setValue('ITEM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('ITEM_CODE', '');
									panelResult.setValue('ITEM_CODE', '');
								}
							},
						applyextparam: function(popup){	// 2021.08 표준화 작업
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
            }),{
                fieldLabel: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>',
                xtype: 'uniDateRangefield',
                startFieldName: 'DVRY_DATE_FR',
                endFieldName: 'DVRY_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelSearch.setValue('DVRY_DATE_FR',newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelSearch.setValue('DVRY_DATE_TO',newValue);
                    }
                }
            },{ 
                xtype: 'container',
                layout: {
                    type: 'hbox', 
                    align:'stretch'
                },
                defaultType: 'uniTextfield',
                width: 400,
                items: [{
                    fieldLabel:'<t:message code="system.label.purchase.pono" default="발주번호"/>', 
                    suffixTpl:'&nbsp;~&nbsp;', 
                    name: 'ORDER_NUM_FR',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelSearch.setValue('ORDER_NUM_FR', newValue);
                        }
                    }
                },{
                    hideLabel: true, 
                    name: 'ORDER_NUM_TO',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelSearch.setValue('ORDER_NUM_TO', newValue);
                        }
                    }
                }]       
            },
            Unilite.popup('PJT',{ 
                fieldLabel: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>', 
                textFieldWidth: 170, 
                textFieldName:'PJT_CODE',
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            panelSearch.setValue('PJT_CODE', panelSearch.getValue('PJT_CODE'));
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelSearch.setValue('PJT_CODE', '');
                    }
                }
            }),{
                fieldLabel: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>',
                name:'CONTROL_STATUS',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'M002',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('CONTROL_STATUS', newValue);
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
                        var labelText = invalid.items[0]['fieldLabel']+':';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
                    }
                    alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
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
	 * Master Grid1 정의(Grid Panel)
	 * 
	 * @type
	 */
	var masterGrid= Unilite.createGrid('mpo350ukrvGrid', {
		region: 'center',
		layout: 'fit',
		excelTitle: '<t:message code="system.label.purchase.poclosingentry" default="발주마감등록"/>',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			onLoadSelectFirst: false,  
    		filter: {
				useFilter: false,
				autoCreate: false
			},
			state: {
				useState: false,   //그리드 설정 (우측)버튼 사용 여부
				useStateList: false  //그리드 설정 (죄측)목록 사용 여부
			}
        },
    	store: directMasterStore1,
    	selModel: Ext.create('Ext.selection.CheckboxModel', {
        	checkOnly: true,
        	toggleOnClick: false,
        	listeners: {        		
        		beforeselect: function(rowSelection, record, index, eOpts) {
        		},
				select: function(grid, record, index, eOpts ){					
					var records = masterGrid.getSelectedRecords();
					if(records.length > '0'){
						UniAppManager.setToolbarButtons('save',true);
					}
					if(record.get('STATUS_CODE')=='1'){
						record.set('STATUS_CODE_HIDE','9');	//신규라고 알려주기 위해 임의로 컬럼 생성
					}else{
						record.set('STATUS_CODE_HIDE','1');
					}
	          	},
				deselect:  function(grid, record, index, eOpts ){
					record.set('STATUS_CODE_HIDE','');
					var records = masterGrid.getSelectedRecords();
					if(records.length < '1'){
						UniAppManager.setToolbarButtons('save',false);
					}
					
        		}
        	}
        }),
    	features: [{
    		id: 'masterGridSubTotal', 
    		ftype: 'uniGroupingsummary',
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: false
    	}],
        columns:  [
        	{dataIndex:'COMP_CODE'			, width: 90 ,hidden: true},
        	{dataIndex:'STATUS_CODE'		, width: 66 ,hidden: true},
        	{dataIndex:'STATUS_CODE_HIDE'	, width: 66 ,hidden: true},
            {dataIndex:'FLAG_NAME'          , width: 70 ,align: 'center'},
        	{dataIndex:'STATUS_NAME'		, width: 70 ,align: 'center'},
        	{dataIndex:'ITEM_CODE'			, width: 100},
        	{dataIndex:'ITEM_NAME'			, width: 200},
        	{dataIndex:'SPEC'				, width: 80},
        	{dataIndex:'ORDER_DATE'			, width: 90},
        	{dataIndex:'DVRY_DATE'			, width: 90},
        	{dataIndex:'ORDER_Q'			, width: 80},
        	{dataIndex:'RECEIPT_Q'			, width: 90},
        	{dataIndex:'INSTOCK_Q'			, width: 80},
        	{dataIndex:'ACCOUNT_Q'			, width: 80},
        	{dataIndex:'BAL_Q'				, width: 80},
        	{dataIndex:'STOCK_UNIT'			, width: 53 ,align:'center'},
        	{dataIndex:'ORDER_NUM'			, width: 120},
        	{dataIndex:'ORDER_SEQ'			, width: 53},
        	{dataIndex:'AGREE_STATUS'		, width: 76 ,hidden:false ,align:'center'},
        	{dataIndex:'ORDER_TYPE'			, width: 66 ,hidden: true},
        	{dataIndex:'ORDERTYPE_NAME'		, width: 80 ,align: 'center'},
        	{dataIndex:'CUSTOM_CODE'		, width: 66 ,hidden: true},
        	{dataIndex:'CUSTOM_NAME'		, width: 150},
        	{dataIndex:'REMARK'				, width: 150},
        	{dataIndex:'PROJECT_NO'			, width: 100}
        ]             
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
		id: 'mpo350ukrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('ORDER_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('ORDER_DATE_TO',UniDate.get('today'));
			panelResult.setValue('ORDER_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('ORDER_DATE_TO',UniDate.get('today'));
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('detail',false);
		},
		onQueryButtonDown: function()	{		
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				directMasterStore1.loadStoreRecords();
			}
		},
		onSaveDataButtonDown: function(config) {				
			directMasterStore1.saveStore();
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
        onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			this.fnInitBinding();
		}
	});		
};
</script>