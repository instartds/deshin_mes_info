<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mtr903ukrv_kd"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_mtr903ukrv_kd"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M007" /> <!-- 승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B038" /> <!-- 결제조건 --> 
	
	<t:ExtComboStore comboType="AU" comboCode="M002" /> <!-- 진행상태 -->
    <t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="B010" /> <!-- 구매요청여부 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /> <!--창고-->	
	<t:ExtComboStore comboType="AU" comboCode="B014" /> <!-- 조달구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐 -->
	<t:ExtComboStore comboType="AU" comboCode="M301" /> <!-- 단가형태 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" /> <!-- 단위 -->
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo = {
	gsAutoType:     '${gsAutoType}',
	gsDefaultMoney: '${gsDefaultMoney}'
};


var outDivCode = UserInfo.divCode;
var aa = 0;
function appMain() {   
	
	var isAutoOrderNum = false;
	if(BsaCodeInfo.gsAutoType=='Y')	{
		isAutoOrderNum = true;
	}
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_mtr903ukrv_kdService.selectList',
			update: 's_mtr903ukrv_kdService.updateDetail',
			syncAll: 's_mtr903ukrv_kdService.saveAll'
		}
	});	
	/**
	 * Model 정의 
	 * @type 
	 */    			
	Unilite.defineModel('s_mtr903ukrv_kdModel', {
	    fields: [     
            {name: 'COMP_CODE'             , text: '법인코드'           , type: 'string'},
            {name: 'STATUS'                , text: '등록여부'           , type: 'string'},
	        {name: 'DIV_CODE'              , text: '사업장'             , type: 'string'},
	        {name: 'INOUT_DATE'            , text: '입고일'             , type: 'uniDate'},
            {name: 'CUSTOM_CODE'           , text: '거래처'             , type: 'string'},
            {name: 'CUSTOM_NAME'           , text: '거래처명'           , type: 'string'},
            {name: 'INOUT_NUM'             , text: '입고번호'           , type: 'string'},
            {name: 'INOUT_SEQ'             , text: '입고순번'           , type: 'int'},
            {name: 'ITEM_CODE'             , text: '품목코드'           , type: 'string'},
            {name: 'ITEM_NAME'             , text: '품목명'             , type: 'string'},
            {name: 'SPEC'                  , text: '규격'               , type: 'string'},
            {name: 'STOCK_UNIT'            , text: '단위'               , type: 'string'},
            {name: 'INOUT_Q'               , text: '입고수량'           , type: 'uniQty'},
            {name: 'WONSANGI_NUM'          , text: '원산지번호'         , type: 'string'},
            {name: 'WONSANGI_NUM2'         , text: '원산지번호(이전)'   , type: 'string'},
            {name: 'ORDER_NUM'             , text: '발주번호'           , type: 'string'},
            {name: 'ORDER_SEQ'             , text: '발주순번'           , type: 'int'}
        ]  
	});	
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */			
	var directMasterStore1 = Unilite.createStore('s_mtr903ukrv_kdMasterStore1',{
		model: 's_mtr903ukrv_kdModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
           	editable: true,			// 수정 모드 사용 
           	deletable: false,			// 삭제 가능 여부 
           	allDeletable: false,
	        useNavi: false				// prev | newxt 버튼 사용
		},
			autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function() {
			var param= panelSearch.getValues();			
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
       		var toUpdate = this.getUpdatedRecords();  
       		var list = [].concat(toUpdate);
			console.log("list:", list);
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
				var grid = Ext.getCmp('s_mtr903ukrv_kdGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});	
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
    var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '구매요청조건',
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
			items:[{
				fieldLabel: '사업장',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				holdable: 'hold',
				value: UserInfo.divCode,			
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
            Unilite.popup('AGENT_CUST', { 
                fieldLabel: '거래처', 
                holdable: 'hold',
                validateBlank: false,
                listeners: {
                            onSelected: {
                                fn: function(records, type) {
                                    panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
                                    panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));                                                                                                           
                                },
                                scope: this
                            },
                            onClear: function(type) {
                                panelResult.setValue('CUSTOM_CODE', '');
                                panelResult.setValue('CUSTOM_NAME', '');
                            }
                        }
            }),{
                fieldLabel: '입고일',
                xtype: 'uniDateRangefield',
                startFieldName: 'INOUT_DATE_FR',
                endFieldName: 'INOUT_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank:false,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelResult.setValue('INOUT_DATE_FR',newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelResult.setValue('INOUT_DATE_TO',newValue);
                    }
                }
            },{
                fieldLabel: '조달구분', 
                name: 'SUPPLY_TYPE', 
                xtype: 'uniCombobox', 
                comboType: 'AU', 
                comboCode: 'B014',
                listeners: {
                    change: function(combo, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('SUPPLY_TYPE', newValue);
                    }
                }
            },{
                fieldLabel:'입고번호',
                name: 'INOUT_NUM',
                xtype: 'uniTextfield',
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('INOUT_NUM', newValue);
                    }
                }
            },{
                fieldLabel:'원산지번호',
                name: 'WONSANGI_NUM',
                xtype: 'uniTextfield',
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('WONSANGI_NUM', newValue);
                    }
                }
            },{
                xtype: 'radiogroup',                            
                fieldLabel: '등록여부',  
                items : [{
                    boxLabel: '전체',
                    width: 60,
                    name: 'STATUS',
                    checked: true,
                    inputValue: ''
                },{
                    boxLabel: '등록',
                    width: 60,
                    name: 'STATUS',
                    inputValue: '1'
                },{
                    boxLabel: '미등록',
                    width: 60,
                    name: 'STATUS',
                    inputValue: '2'
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.getField('STATUS').setValue(newValue.STATUS);
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
   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
   					}
				   	alert(labelText+Msg.sMB083);
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
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
                holdable: 'hold',
                value: UserInfo.divCode,            
                listeners: {
                    change: function(combo, newValue, oldValue, eOpts) {
                        panelSearch.setValue('DIV_CODE', newValue);
                    }
                }
            },
            Unilite.popup('AGENT_CUST', { 
                fieldLabel: '거래처', 
                holdable: 'hold',
                validateBlank: false,
                listeners: {
                            onSelected: {
                                fn: function(records, type) {
                                    panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
                                    panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));                                                                                                           
                                },
                                scope: this
                            },
                            onClear: function(type) {
                                panelSearch.setValue('CUSTOM_CODE', '');
                                panelSearch.setValue('CUSTOM_NAME', '');
                            }
                        }
            }),{
                fieldLabel: '입고일',
                xtype: 'uniDateRangefield',
                startFieldName: 'INOUT_DATE_FR',
                endFieldName: 'INOUT_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank:false,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelSearch.setValue('INOUT_DATE_FR',newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelSearch.setValue('INOUT_DATE_TO',newValue);
                    }
                }
            },{
                fieldLabel: '조달구분', 
                name: 'SUPPLY_TYPE', 
                xtype: 'uniCombobox', 
                comboType: 'AU', 
                comboCode: 'B014',
                listeners: {
                    change: function(combo, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('SUPPLY_TYPE', newValue);
                    }
                }
            },{
                fieldLabel:'입고번호',
                name: 'INOUT_NUM',
                xtype: 'uniTextfield',
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('INOUT_NUM', newValue);
                    }
                }
            },{
                fieldLabel:'원산지번호',
                name: 'WONSANGI_NUM',
                xtype: 'uniTextfield',
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('WONSANGI_NUM', newValue);
                    }
                }
            },{
                xtype: 'radiogroup',                            
                fieldLabel: '등록여부',  
                items : [{
                    boxLabel: '전체',
                    width: 60,
                    name: 'STATUS',
                    checked: true,
                    inputValue: ''
                },{
                    boxLabel: '등록',
                    width: 60,
                    name: 'STATUS',
                    inputValue: '1'
                },{
                    boxLabel: '미등록',
                    width: 60,
                    name: 'STATUS',
                    inputValue: '2'
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.getField('STATUS').setValue(newValue.STATUS);
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
    
    var inputTable = Unilite.createSearchForm('detailForm', { //createForm
        layout : {type : 'uniTable', columns : 1},
        disabled: false,
        border:true,
        padding:'1 1 1 1',
        region: 'center',
        masterGrid: masterGrid,
        items: [{
                fieldLabel: '원산지번호',
                xtype: 'uniTextfield',
                name: 'WONSANGI_NUM'
            }]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid= Unilite.createGrid('s_mtr903ukrv_kdGrid', {
    	region: 'center' ,
        layout: 'fit',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
            onLoadSelectFirst : false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
        selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
            listeners: {
                select: function(grid, selectRecord, index, rowIndex, eOpts ) {
                	var wonsangiNum = inputTable.getValue('WONSANGI_NUM');
                	if(Ext.isEmpty(wonsangiNum)) {
                		alert("원산지번호를 입력해주세요");
                		var sm = masterGrid.getSelectionModel();
                		var selRecords = masterGrid.getSelectionModel().getSelection();
                		sm.deselect(selRecords);
                        return false;
                	} else {
                        selectRecord.set('WONSANGI_NUM', wonsangiNum);
                	}
                },
                deselect:  function(grid, selectRecord, index, rowIndex, eOpts ) {
                    var wonsangiNum2 = selectRecord.get('WONSANGI_NUM2');
                    selectRecord.set('WONSANGI_NUM', wonsangiNum2);
                }
            }
        }),  
    	store: directMasterStore1,
        columns: [  
            { dataIndex: 'COMP_CODE'                ,  width: 100, hidden: true},
            { dataIndex: 'STATUS'                   ,  width: 100, hidden: true},
            { dataIndex: 'DIV_CODE'                 ,  width: 100, hidden: true},
            { dataIndex: 'INOUT_DATE'               ,  width: 100},
            { dataIndex: 'CUSTOM_CODE'              ,  width: 100},
            { dataIndex: 'CUSTOM_NAME'              ,  width: 200},
            { dataIndex: 'INOUT_NUM'                ,  width: 150},
            { dataIndex: 'INOUT_SEQ'                ,  width: 80},
            { dataIndex: 'ITEM_CODE'                ,  width: 100},
            { dataIndex: 'ITEM_NAME'                ,  width: 200},
            { dataIndex: 'SPEC'                     ,  width: 80},
            { dataIndex: 'STOCK_UNIT'               ,  width: 80},
            { dataIndex: 'INOUT_Q'                  ,  width: 80},
            { dataIndex: 'WONSANGI_NUM'             ,  width: 100},
            { dataIndex: 'WONSANGI_NUM2'            ,  width: 100, hidden: true},
            { dataIndex: 'ORDER_NUM'                ,  width: 100},
            { dataIndex: 'ORDER_SEQ'                ,  width: 80}
        ],
        listeners: {
			beforeedit  : function( editor, e, eOpts ) {
                return false;   
            }
		}
    });		
    
    Unilite.Main({
		borderItems:[{
                region:'center',
                layout: 'border',
                border: false,
                items:[{
                        region : 'center',
                        xtype : 'container',
                        layout : 'fit',
                        items : [ masterGrid ]
                    },
                    panelResult,
                    {
                        region : 'north',
                        xtype : 'container',
                        highth: 20,
                        layout : 'fit',
                        items : [ inputTable ]
                    }
                ]
            },
            panelSearch     
        ],	
		id: 's_mtr903ukrv_kdApp',
		fnInitBinding: function() {
			this.setDefault();		
		},
		onQueryButtonDown: function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
                return false;
            }
			directMasterStore1.loadStoreRecords();  
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			panelResult.clearForm();
			directMasterStore1.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {	
			if(directMasterStore1.isDirty())	{
				var selectedRecords = masterGrid.getSelectedRecords(); 
				if(selectedRecords[0].data.STATUS == 'Y') {
    				if(confirm('기존 원산지번호가 수정됩니다. 수정하시겠습니까?')) {
    				    directMasterStore1.saveStore();
    				}
				} else {
                    directMasterStore1.saveStore();
				}
			}
			var param = panelSearch.getValues();
			directMasterStore1.loadStoreRecords(param); 
//			UniAppManager.app.onQueryButtonDown();
		},
		setDefault: function() {
        	panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
        	panelSearch.setValue('INOUT_DATE_FR',UniDate.get('startOfMonth'));
        	panelResult.setValue('INOUT_DATE_FR',UniDate.get('startOfMonth'));
            panelSearch.setValue('INOUT_DATE_TO',UniDate.get('today'));
            panelResult.setValue('INOUT_DATE_TO',UniDate.get('today'));
        	// panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();											
			UniAppManager.setToolbarButtons('save', false);
			
		}
	});
};
</script>
