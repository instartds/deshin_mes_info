<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="eia100ukrv">
    <t:ExtComboStore comboType="BOR120"  pgmId="eia100ukrv"  />    <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B302" storeId="eisGubun"/>                 <!--관계사구분-->
</t:appConfig>
<script type="text/javascript">

var BsaCodeInfo = { //컨트롤러에서 값을 받아옴.
    gsAutoType  : '${gsAutoType}',
	gsMoneyUnit	: '${gsMoneyUnit}'
};

var selectedGrid = 'eia100ukrvGrid1';
var activeGridId = '${PKGNAME}Grid';
function appMain() {

    var groupUrl = '${groupUrl}'; //그룹웨어 호출 url

    var isAutoOrderNum = false;
    if(BsaCodeInfo.gsAutoType == 'Y') {
        isAutoOrderNum = true;
    }

    var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
        api: {
            read    : 'eia100ukrvService.selectList',
            update  : 'eia100ukrvService.updateDetail',
            create  : 'eia100ukrvService.insertDetail',
            destroy : 'eia100ukrvService.deleteDetail',
            syncAll : 'eia100ukrvService.saveAll'
        }
    });

    var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
        api: {
            read    : 'eia100ukrvService.selectList2',
            update  : 'eia100ukrvService.updateDetail2',
            create  : 'eia100ukrvService.insertDetail2',
            destroy : 'eia100ukrvService.deleteDetail2',
            syncAll : 'eia100ukrvService.saveAll2'
        }
    });

    /**
     *   Model 정의
     * @type
     */
    Unilite.defineModel('eia100ukrvModel', {
        fields: [
            {name : 'COMP_CODE'     ,       text : '법인코드',          type : 'string'},
            {name : 'COMP_NUM'      ,       text : '관계사명',         type : 'string', comboType : 'AU', comboCode : 'B302', allowBlank : false},
 	        {name : 'COMP_NAME'     ,       text : '관계사명',       	type : 'string'},
			{name : 'CAPITAL_STOCK' ,       text : '발행할 총 주식 수',      type : 'float'		, decimalPrecision: 0 , format:'0,000'},
            {name : 'ISSUED_STOCK'  ,       text : '발행한 총 주식 수',      type : 'float'		, decimalPrecision: 0 , format:'0,000'},
            {name : 'CAPITAL'       ,       text : '자본금',            type : 'float'		, decimalPrecision: 0 , format:'0,000'},
            {name : 'STOCK_VALUE'   ,       text : '1주당 가격',         type : 'float'		, decimalPrecision: 0 , format:'0,000'},
            {name : 'MONEY_UNIT'    ,       text : '화폐단위',           type : 'string', comboType : 'AU', comboCode : 'B004', allowBlank : true, displayField: 'value'},
            {name : 'SORT_SEQ'      ,       text : '정렬순번',           type : 'int'},
            {name : 'USE_YN'		,       text : '사용여부',           type : 'string', comboType : 'AU', comboCode : 'B010'}

        ]
    });

    Unilite.defineModel('eia100ukrvModel2', {
        fields: [
            {name : 'COMP_CODE'    ,   text : '법인코드',          type : 'string'},
            {name : 'COMP_NUM'     ,   text : '관계사명',          type : 'string', comboType : 'AU', comboCode : 'B302', allowBlank : false},
            {name : 'COMP_NAME'    ,   text : '관계사명',          type : 'string'},
            {name : 'CLOSING_DATE' ,   text : '결산 기준일',        type : 'uniDate', allowBlank : false},
            {name : 'TOTAL_ASSETS' ,   text : '총자산',           type : 'float'		, decimalPrecision: 0 , format:'0,000'},
            {name : 'TOTAL_DEBT'   ,   text : '부채총계',          type : 'float'		, decimalPrecision: 0 , format:'0,000'},
            {name : 'TOTAL_CAPITAL',   text : '자본총계',          type : 'float'		, decimalPrecision: 0 , format:'0,000'},
            {name : 'SALE_AMT'     ,   text : '매출액',           type : 'float'		, decimalPrecision: 0 , format:'0,000'},
            {name : 'BIZ_PROFIT'   ,   text : '영업이익',          type : 'float'		, decimalPrecision: 0 , format:'0,000'},
            {name : 'NET_PROFIT'   ,   text : '당기순이익',         type : 'float'		, decimalPrecision: 0 , format:'0,000'},
            {name : 'MONEY_UNIT'   ,   text : '화폐단위',          type : 'string'		, comboType : 'AU', comboCode : 'B004', displayField: 'value'},
            {name : 'SORT_SEQ'     ,   text : '정렬순번',          type : 'int'},
            {name : 'USE_YN'       ,   text : '사용여부',          type : 'string', comboType : 'AU', comboCode : 'B010'},
            {name : 'REMARK'       ,   text : '비고',            type : 'string'}
        ]
    });

    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directMasterStore1 = Unilite.createStore('eia100ukrvMasterStore1', {
        model : 'eia100ukrvModel',
        uniOpt : {
            isMaster    : false,            // 상위 버튼 연결
            editable    : true,             // 수정 모드 사용
            deletable   : true,             // 삭제 가능 여부
            useNavi     : false             // prev | newxt 버튼 사용
        },
        autoLoad : false,
        proxy : directProxy1,
        loadStoreRecords : function() {
            var param = panelResult.getValues();
            this.load({
                  params : param,
               // NEW ADD
  				callback: function(records, operation, success){
  					console.log(records);
  					if(success){

  					}
  				}
  				//END
            });
        },
        saveStore : function() {
            var inValidRecs = this.getInvalidRecords();
            console.log("inValidRecords : ", inValidRecs);

            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();
            var toDelete = this.getRemovedRecords();
            var list = [].concat(toUpdate, toCreate);
            console.log("inValidRecords : ", inValidRecs);
            console.log("list:", list);
            console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));



            //1. 마스터 정보 파라미터 구성
            var paramMaster = panelResult.getValues();    //syncAll 수정

            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        panelResult.getForm().wasDirty = false;
                        panelResult.resetDirtyStatus();
                        console.log("set was dirty to false");
                        UniAppManager.setToolbarButtons('save', false);
                        if(directMasterStore2.isDirty()){
                        	directMasterStore2.saveStore();
                        }
                    }
                };
                this.syncAllDirect(config);
            } else {
                var grid = Ext.getCmp('eia100ukrvGrid1');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners:{
            load: function(store, records, successful, eOpts) {

                if(records != null && records.length > 0 ){
//                    selectedGrid = 'eia100ukrvGrid1';
                    UniAppManager.setToolbarButtons('delete', true);
                }
            },
            update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
                UniAppManager.setToolbarButtons('save', true);
            },
            datachanged : function(store,  eOpts) {
                if( directMasterStore2.isDirty() || store.isDirty()) {
                    UniAppManager.setToolbarButtons('save', true);
                }else {
                    UniAppManager.setToolbarButtons('save', false);
                }
            }
        }
    }); // End of var directMasterStore1

    var directMasterStore2 = Unilite.createStore('eia100ukrvMasterStore2',{
        model : 'eia100ukrvModel2',
        uniOpt : {
            isMaster    : false,            // 상위 버튼 연결
            editable    : true,             // 수정 모드 사용
            deletable   : true,             // 삭제 가능 여부
            useNavi     : false             // prev | newxt 버튼 사용
        },
        autoLoad : false,
        proxy : directProxy2,
        loadStoreRecords : function(param) {
        	 var param = panelResult.getValues();
        	this.load({
                  params : param
            });
        },
        saveStore : function() {
            var inValidRecs = this.getInvalidRecords();
            console.log("inValidRecords : ", inValidRecs);

            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();
            var toDelete = this.getRemovedRecords();
            var list = [].concat(toUpdate, toCreate);
            console.log("list:", list);
            console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

            //1. 마스터 정보 파라미터 구성
            var paramMaster = panelResult.getValues();    //syncAll 수정

            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        panelResult.getForm().wasDirty = false;
                        panelResult.resetDirtyStatus();
                        console.log("set was dirty to false");
                        UniAppManager.setToolbarButtons('save', false);
                        if(directMasterStore1.isDirty()){
                        	directMasterStore1.saveStore();
                        }
//                        UniAppManager.app.onQueryButtonDown();
                    }
                };
                this.syncAllDirect(config);
            } else {
                    var grid = Ext.getCmp('eia100ukrvGrid2');
                    grid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
        },
        listeners : {
            load: function(store, records, successful, eOpts) {
                if(records != null && records.length > 0){
                    UniAppManager.setToolbarButtons('delete', true);
//                    selectedGrid = 'eia100ukrvGrid2';
                } else {
                	if(directMasterStore1.isDirty() || store.isDirty()) {
                        UniAppManager.setToolbarButtons('save', true);
                    }else {
                        UniAppManager.setToolbarButtons('save', false);
                    }
                }
            },
            update : function( store, record, operation, modifiedFieldNames, details, eOpts) {
                UniAppManager.setToolbarButtons('save', true);
            },
            datachanged : function(store,  eOpts) {
                if(directMasterStore1.isDirty() || store.isDirty()) {
                    UniAppManager.setToolbarButtons('save', true);
                }else {
                    UniAppManager.setToolbarButtons('save', false);
                }
            }
        }
    }); // End of var directMasterStore1

    var panelResult = Unilite.createSearchForm('resultForm', {
        region : 'north',
        layout : {type : 'uniTable', columns : 4},
        padding:'1 1 1 1',
        border:true,
        items: [{
                fieldLabel: '관계사(EIS)',
                name:'COMP_NUM',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'B302'
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
                        if(Ext.isDefined(item.holdable)) {
                            if(item.holdable == 'hold') {
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
                    if(Ext.isDefined(item.holdable)) {
                        if(item.holdable == 'hold') {
                            item.setReadOnly(false);
                        }
                    }
                    if(item.isPopupField) {
                        var popupFC = item.up('uniPopupField');
                        if(popupFC.holdable == 'hold') {
                            item.setReadOnly(false);
                        }
                    }
                })
            }
            return r;
        },
        setLoadRecord: function(record) {
            var me = this;
            me.uniOpt.inLoading = false;
            me.setAllFieldsReadOnly(true);
        }
    });

    var masterGrid = Unilite.createGrid('eia100ukrvGrid1', {
        layout  : 'fit',
        region  : 'center',
        title 	: '자금현황',
        store   : directMasterStore1,
        uniOpt  : { expandLastColumn    : false,
                    useRowNumberer      : true,
					copiedRow : true,
                    useMultipleSorting  : true
        },
        tbar:     [
					{
						xtype:'label',
						html:'<div style="color:#0033CC;font-weight: bold">( '+'단위: 주 /원'+' )</div>'

					}
			  ],
        columns:  [
            {dataIndex : 'COMP_CODE'      ,              width : 100, hidden : true},
            {dataIndex : 'COMP_NUM'       ,              width : 150, hidden : false},
            {dataIndex : 'COMP_NAME'      ,              width : 150, hidden : true},
            {dataIndex : 'CAPITAL_STOCK'  ,              width : 120, align : 'right'},
            {dataIndex : 'ISSUED_STOCK'   ,              width : 120, align : 'right'},
            {dataIndex : 'CAPITAL'        ,              width : 120, align : 'right'},
            {dataIndex : 'STOCK_VALUE'    ,              width : 120, align : 'right'},
            {dataIndex : 'MONEY_UNIT'     ,              width : 80, align : 'center'},
            {dataIndex : 'SORT_SEQ'       ,              width : 80},
            {dataIndex : 'USE_YN'		  ,              width : 80}
        ],
        listeners: {
//            select : function() {
//                var count = masterGrid2.getStore().getCount();
//
//                UniAppManager.setToolbarButtons(['reset', 'newData'], true);
//                selectedGrid = 'eia100ukrvGrid1';
//                if(count == 0) {
//                    UniAppManager.setToolbarButtons(['delete'], true);
//                } else {
//                    UniAppManager.setToolbarButtons(['delete'], false);
//                }
//            },
//            cellclick : function() {
//                var count = masterGrid2.getStore().getCount();
//
//                selectedGrid = 'eia100ukrvGrid1';
//                if(count == 0) {
//                    UniAppManager.setToolbarButtons(['delete'], true);
//                } else {
//                    UniAppManager.setToolbarButtons(['delete'], false);
//                }
//            },
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.phantom ) {
					if (UniUtils.indexOf(e.field,['COMP_NAME','COMP_CODE'])){
							return false;
					}
				}else{
					if (UniUtils.indexOf(e.field,['COMP_NUM','COMP_CODE','COMP_NAME'])){
						return false;
					}

				}
			},
            render : function(grid, eOpts) {
                var girdNm = grid.getItemId();
                var store = grid.getStore();
                grid.getEl().on('click', function(e, t, eOpt) {
                    selectedGrid = 'eia100ukrvGrid1';
                    var oldGrid = Ext.getCmp(activeGridId);
			    	grid.changeFocusCls(oldGrid);
                    activeGridId = girdNm;

                    //store.onStoreActionEnable();
                    if(directMasterStore1.isDirty() || directMasterStore2.isDirty()) {
                        UniAppManager.setToolbarButtons('save', true);
                    } else {
                        UniAppManager.setToolbarButtons('save', false);
                    }
                    if(grid.getStore().getCount() > 0)  {
                        UniAppManager.setToolbarButtons('delete', true);
                    } else {
                        UniAppManager.setToolbarButtons('delete', false);
                    }
                });
             },
            selectionchange : function(model1, selected, eOpts) {
//                var count = masterGrid.getStore().getCount();
//                var count2 = masterGrid2.getStore().getCount();
               /*  if(selected.length > 0) {
                    var record  = selected[0];
                    var param   = panelResult.getValues();
                    var param   = {
                        DIV_CODE    : record.get('DIV_CODE'),
                        EQDOC_CODE  : record.get('EQDOC_CODE')
                    }
                    var record = masterGrid.getSelectedRecord();

                    if(!record.phantom == true) {
                        directMasterStore2.loadStoreRecords(param);
                    } else {
                        masterGrid2.reset();
                    }
                } */
            }
        }
    });

    var masterGrid2 = Unilite.createGrid('eia100ukrvGrid2', {
        layout : 'fit',
        region: 'south',
        title : '재무현황',
        split:true,
        store: directMasterStore2,
        uniOpt: {   expandLastColumn    : true,
                    useRowNumberer      : true,
					copiedRow : true,
                    useMultipleSorting  : true
        },
        tbar:     [
					{
						xtype:'label',
						html:'<div style="color:#0033CC;font-weight: bold">( '+'단위: 백만원'+' )</div>'

					}
			  ],
        columns: [
            {dataIndex : 'COMP_CODE'    ,              width : 100, hidden : true},
            {dataIndex : 'COMP_NUM'     ,              width : 150},
            {dataIndex : 'COMP_NAME'    ,              width : 150, hidden : true},
            {dataIndex : 'CLOSING_DATE' ,              width : 100},
            {dataIndex : 'TOTAL_ASSETS' ,              width : 120},
            {dataIndex : 'TOTAL_DEBT'   ,              width : 120},
            {dataIndex : 'TOTAL_CAPITAL',              width : 120},
            {dataIndex : 'SALE_AMT'     ,              width : 120},
            {dataIndex : 'BIZ_PROFIT'   ,              width : 120},
            {dataIndex : 'NET_PROFIT'   ,              width : 120},
            {dataIndex : 'MONEY_UNIT'   ,              width : 80, align : 'center'},
            {dataIndex : 'SORT_SEQ'     ,              width : 80},
            {dataIndex : 'USE_YN'       ,              width : 80},
            {dataIndex : 'REMARK'       ,              width : 300}

        ],
        listeners: {
//            select : function() {
//                var count = masterGrid2.getStore().getCount();
//
//                selectedGrid = 'eia100ukrvGrid2';
//
//                if(count == 0) {
//                    UniAppManager.setToolbarButtons(['delete'], true);
//                } else {
//                    UniAppManager.setToolbarButtons(['delete'], false);
//                }
//
//                UniAppManager.setToolbarButtons(['reset', 'newData'], true);
//            },
//            cellclick : function() {
//                var count = masterGrid2.getStore().getCount();
//
//                selectedGrid = 'eia100ukrvGrid2';
//
//                if(count == 0) {
//                    UniAppManager.setToolbarButtons(['delete'], true);
//                } else {
//                    UniAppManager.setToolbarButtons(['delete'], false);
//                }
//
//                UniAppManager.setToolbarButtons(['reset', 'newData'], true);
//            },
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.phantom ) {
					if (UniUtils.indexOf(e.field,['COMP_NAME','COMP_CODE','TOTAL_CAPITAL'])){
							return false;
					}
				}else{
					if (UniUtils.indexOf(e.field,['COMP_NUM','COMP_CODE','COMP_NAME','TOTAL_CAPITAL'])){
						return false;
					}
				}
			},
            render : function(grid, eOpts) {
                var girdNm = grid.getItemId();
                var store = grid.getStore();
                grid.getEl().on('click', function(e, t, eOpt) {
                	selectedGrid = 'eia100ukrvGrid2';
                	var oldGrid = Ext.getCmp(activeGridId);
  			    	grid.changeFocusCls(oldGrid);
                    activeGridId = girdNm;
                    if(directMasterStore1.isDirty() || directMasterStore2.isDirty()) {
                        UniAppManager.setToolbarButtons('save', true);
                    }else {
                        UniAppManager.setToolbarButtons('save', false);
                    }
                    if(grid.getStore().getCount() > 0)  {
                        UniAppManager.setToolbarButtons('delete', true);
                    }else {
                        UniAppManager.setToolbarButtons('delete', false);
                    }
                });
             }
        }
    });

    Unilite.Main( {
        borderItems:[{
                region:'center',
                layout: 'border',
                border: false,
                items:[
                	panelResult,
            		{
                        region : 'center',
                        xtype : 'container',
                        layout : 'fit',
                        items : [ masterGrid ]
                    }, masterGrid2
                ]
            }
        ],
        id  : 'eia100ukrvApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData', 'deleteAll'], false);
            UniAppManager.setToolbarButtons('newData', true);
            this.setDefault();
        },
        onQueryButtonDown : function() {
            if(panelResult.setAllFieldsReadOnly(true) == false) {
                return false;
            }
            directMasterStore1.loadStoreRecords();
            directMasterStore2.loadStoreRecords();
            UniAppManager.setToolbarButtons(['reset'], true);
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            panelResult.clearForm();
            masterGrid.reset();
            masterGrid2.reset();
            this.fnInitBinding();
        },
        onNewDataButtonDown: function() {       // 행추가
        	if(selectedGrid == 'eia100ukrvGrid1') {
                var compCode    = UserInfo.compCode;
                var useYN       = 'Y'
                var seq         = directMasterStore1.max('SORT_SEQ');
                if(!seq) seq = 1;
                else seq += 1;

                var r = {
                		COMP_CODE    	 :  compCode,
                        CAPITAL_STOCK    :  0,
                        ISSUED_STOCK     :  0,
                        CAPITAL          :  0,
                        STOCK_VALUE      :  0,
                        MONEY_UNIT       :	BsaCodeInfo.gsMoneyUnit,
                        SORT_SEQ         :  seq,
                        USE_YN		     :  useYN
                };

                masterGrid.createRow(r);

        	} else if(selectedGrid == 'eia100ukrvGrid2') {
                var record      = masterGrid.getSelectedRecord();
                    var compCode    = UserInfo.compCode;
                    var seq         = directMasterStore2.max('SORT_SEQ');
                        if(!seq) seq = 1;
                        else seq += 1;

                    var r = {
                        COMP_CODE     : compCode,
                        CLOSING_DATE  : UniDate.get('today'),
                        TOTAL_ASSETS  : 0,
                        TOTAL_DEBT    : 0,
                        TOTAL_CAPITAL : 0,
                        SALE_AMT      : 0,
                        BIZ_PROFIT    : 0,
                        NET_PROFIT    : 0,
                        MONEY_UNIT    : BsaCodeInfo.gsMoneyUnit,
                        SORT_SEQ      : seq,
                        USE_YN        : 'Y'
                    };

                masterGrid2.createRow(r);
            }
        },
        onDeleteDataButtonDown: function() {
            var param = panelResult.getValues();

            if(selectedGrid == 'eia100ukrvGrid1') {
                var record = masterGrid.getSelectedRecord();
                var count = masterGrid2.getStore().getCount();

                if(record.phantom == true) {
                    masterGrid.deleteSelectedRow();
                } else {
                	masterGrid.deleteSelectedRow();
                	/* if(count != 0) {
                	   alert('수리내역이 존재합니다. 수리내역을 먼저 삭제하시기 바랍니다.');
                        return false;
                	} else {
                        if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                            masterGrid.deleteSelectedRow();
                        }
                	} */
                }
            } else if(selectedGrid == 'eia100ukrvGrid2') {
                var record = masterGrid2.getSelectedRecord();

                if(record.phantom == true) {
                    masterGrid2.deleteSelectedRow();
                } else {
                    if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                        masterGrid2.deleteSelectedRow();
                    }
                }
            }

            if(directMasterStore1.isDirty() || directMasterStore2.isDirty()) {
                UniAppManager.setToolbarButtons(['save'], true);
            } else if(!directMasterStore1.isDirty() && !directMasterStore2.isDirty()) {
                UniAppManager.setToolbarButtons(['save'], false);
            }
        },
        onSaveDataButtonDown: function () {
         /*    if(directMasterStore1.isDirty() && ! directMasterStore2.isDirty()) {
                directMasterStore1.saveStore();
            }else if(directMasterStore2.isDirty() && ! directMasterStore1.isDirty() ) {
                directMasterStore2.saveStore();
            }else if(directMasterStore1.isDirty() && directMasterStore2.isDirty()) {
            	directMasterStore1.saveStore();
            	directMasterStore2.saveStore();
            } */
        	  if(directMasterStore1.isDirty()) {
                  directMasterStore1.saveStore();
              }else if(directMasterStore2.isDirty()) {
                  directMasterStore2.saveStore();
              }

        },
        setDefault: function() {
            directMasterStore1.clearData();
            directMasterStore2.clearData();

            panelResult.getForm().wasDirty = false;
            UniAppManager.setToolbarButtons(['save'], false);
        }
    });


    /** Validation
	 */
	var validation = Unilite.createValidator('validator01', {
		store	: directMasterStore1,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, detailGrid, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "COMP_NUM" :
					var eisGubunStore =  Ext.data.StoreManager.lookup('eisGubun');
					Ext.each(eisGubunStore.data.items, function(comboData, idx) {
						if(comboData.get('value') == newValue){
							record.set('COMP_NAME', comboData.get('text'));
						}
					});
					break;

			}
			return rv;
		}
	}); // validator

	var validation2 = Unilite.createValidator('validator02', {
		store	: directMasterStore2,
		grid	: masterGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, detailGrid, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "COMP_NUM" :
					var eisGubunStore =  Ext.data.StoreManager.lookup('eisGubun');
					Ext.each(eisGubunStore.data.items, function(comboData, idx) {
						if(comboData.get('value') == newValue){
							record.set('COMP_NAME', comboData.get('text'));
						}
					});
					break;
				case "TOTAL_ASSETS" :
						var totalDebt = record.get('TOTAL_DEBT');
						var total     = 	newValue - totalDebt;
						record.set('TOTAL_CAPITAL', total);
					break;
				case "TOTAL_DEBT" :
						var totalAssets = record.get('TOTAL_ASSETS');
						var total     = 	totalAssets - newValue;
						record.set('TOTAL_CAPITAL', total);
					break;

			}
			return rv;
		}
	}); // validator
}
</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>
