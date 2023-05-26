<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_ryt300ukrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_ryt300ukrv_kd"  />    <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B131" />                 <!--BOM적용여부 -->
    <t:ExtComboStore comboType="AU" comboCode="B004" />                 <!-- 화폐 -->
    <t:ExtComboStore comboType="AU" comboCode="WR01" />                 <!--비율/단가 -->
    <t:ExtComboStore comboType="AU" comboCode="WR02" />                 <!--프로젝트타입-->
    <t:ExtComboStore comboType="AU" comboCode="WR03" />                 <!--작업반기-->
    <t:ExtComboStore comboType="AU" comboCode="WR04" />                 <!--수량/금액-->
</t:appConfig>
<script type="text/javascript" >

var SearchInfoWindow;   //조회버튼 누르면 나오는 조회창
var bomCopyWindow; //BOM복사 WINDOW
var gsCustomCode	= '';
var gsCustomName	= '';

function appMain() {

    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
        api: {
            read    : 's_ryt300ukrv_kdService.selectList',
            update  : 's_ryt300ukrv_kdService.updateDetail',
            create  : 's_ryt300ukrv_kdService.insertDetail',
            destroy : 's_ryt300ukrv_kdService.deleteDetail',
            syncAll : 's_ryt300ukrv_kdService.saveAll'
        }
    });

    var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
        api: {
            read    : 's_ryt300ukrv_kdService.selectMasterList'
        }
    });

    /**
     *   Model 정의
     * @type
     */
    Unilite.defineModel('s_ryt300ukrv_kdModel', {
        fields: [
            {name : 'COMP_CODE',            text : '법인코드',           type : 'string', allowBlank : false},
            {name : 'DIV_CODE',             text : '사업장',            type : 'string', comboType : "BOR120"},
            {name : 'CHILD_SPEC',           text : '규격',             type : 'string'},
            {name : 'KG_REQ_PRICE',         text : 'KG당 금액',          type: 'float', decimalPrecision: 3, format: '0,000,000.000'}, //2020.02.26 추가
            {name : 'KG_REQ_QTY',           text : 'KG당 소요량',         type: 'float', decimalPrecision: 3, format: '0,000,000.000'},
            {name : 'UNIT_REQ_QTY',         text : '단위 소요량',          type: 'float', decimalPrecision: 5, format: '0,000,000.00000'},
            {name : 'REQ_AMT',         		text : '금액',          	  type: 'float', decimalPrecision: 3, format: '0,000,000.000'}, 	//2020.02.26 추가
            {name : 'PROD_ITEM_CODE',       text : '제품코드',           type : 'string', allowBlank : false},
            {name : 'CUSTOM_CODE',          text : '거래처코드',          type : 'string'},
            {name : 'CHILD_ITEM_CODE',      text : '자재코드',           type : 'string', allowBlank : false},
            {name : 'CHILD_ITEM_NAME',      text : '자재명',            type : 'string'},
            {name : 'SPEC',                 text : '규격',             type : 'string'}
        ]
    });

    Unilite.defineModel('bomPopupModel', {          // 검색팝업창(MASTER)
        fields: [
            {name : 'COMP_CODE',            text : '법인코드',      type : 'string'},
            {name : 'DIV_CODE',             text : '사업자코드',     type : 'string'},
            {name : 'CUSTOM_CODE',          text : '거래처코드',     type : 'string'},
            {name : 'CUSTOM_NAME',          text : '거래처명',      type : 'string'},
            {name : 'ITEM_CODE',            text : '제품코드',      type : 'string'},
            {name : 'ITEM_NAME',            text : '제품명',       type : 'string'},
            {name : 'SPEC',                 text : '규격',        type : 'string'}
        ]
    });

    Unilite.defineModel('s_ryt300ukrv_kd_MasterModel', {
        fields: [
            {name : 'COMP_CODE',          text : '법인코드',         type : 'string'},
            {name : 'DIV_CODE',             text : '사업장',           type : 'string', comboType : "BOR120"},
            {name : 'ITEM_CODE',           text : '품목코드',         type : 'string'},
            {name : 'ITEM_NAME',           text : '품목명',       	 type : 'string'},
            {name : 'SPEC',           			text : '규격',       		 type : 'string'},
            {name : 'BOM_YN',       	    text : 'BOM등록',        type : 'string'}
        ]
    });
    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directMasterStore = Unilite.createStore('s_ryt300ukrv_kdMasterStore1',{
        model: 's_ryt300ukrv_kdModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결
            editable:  true,            // 수정 모드 사용
            deletable: true,            // 삭제 가능 여부
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function(prodItemCode)   {
            var param= panelResult.getValues();
            param.PROD_ITEM_CODE = prodItemCode;
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

            //1. 마스터 정보 파라미터 구성
            var paramMaster= panelResult.getValues();    //syncAll 수정

            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        panelResult.getForm().wasDirty = false;
                        panelResult.resetDirtyStatus();
                        console.log("set was dirty to false");
                        UniAppManager.setToolbarButtons('save', false);
//                        UniAppManager.app.onQueryButtonDown();
                    }
                };
                this.syncAllDirect(config);
            } else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        }
    }); // End of var directMasterStore1

    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directRealMasterStore = Unilite.createStore('s_ryt300ukrv_kdRealMasterStore',{
        model: 's_ryt300ukrv_kd_MasterModel',
        uniOpt : {
        	isMaster: false,			// 상위 버튼 연결
        	editable: true,			// 수정 모드 사용
        	deletable:true,			// 삭제 가능 여부
            useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy1,
        loadStoreRecords : function()   {
            var param= panelResult.getValues();
            this.load({
                  params : param
            });
        }
    }); // End of var directRealMasterStore

    /**
     * 검색조건 (Search Panel)
     * @type
     */
     var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
//        uniOnChange: function(basicForm, dirty, eOpts) {
//            if(directMasterStore.getCount() != 0 && panelResult.isDirty()) {
//                  UniAppManager.setToolbarButtons('save', true);
//            }
//        },
        items: [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
                holdable: 'hold',
                value: UserInfo.divCode
            },{
				fieldLabel: '작업년도',
				name: 'WORK_YEAR',
				xtype: 'uniCombobox',
				holdable: 'hold',
				comboType	: 'AU',
				comboCode	: 'BS90',
				value: new Date().getFullYear(),
				allowBlank: false,
				hidden: false
	    	},{
				fieldLabel	: '반기',
				name		: 'WORK_SEQ',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'Z004',
				holdable: 'hold',
				allowBlank: false,
				hidden: false
			},
            Unilite.popup('AGENT_CUST', {
                    fieldLabel: '거래처',
                    allowBlank:false,
                    holdable: 'hold',
                    listeners: {
                		'onSelected': {
							fn: function(records, type) {
								Ext.each(records, function(record,i) {
									gsCustomCode = record.CUSTOM_CODE;
									gsCustomName = record.CUSTOM_NAME;

								});
							},
							scope: this
						},
                        applyextparam: function(popup){
                            popup.setExtParam({
                                'DIV_CODE':   panelResult.getValue('DIV_CODE'),
                                'ADD_QUERY1': "A.CUSTOM_CODE IN ((SELECT CUSTOM_CODE FROM S_RYT100T_KD WHERE COMP_CODE = ",
                                'ADD_QUERY2': " AND DIV_CODE = ",
                                'ADD_QUERY3': "))"
                            });   //WHERE절 추가 쿼리
                        }
                    }
            }),
            Unilite.popup('DIV_PUMOK',{
                        fieldLabel : '품목코드',
                        allowBlank : true,
                        hidden: true,
                        valueFieldName : 'PROD_ITEM_CODE',
                        textFieldName : 'PROD_ITEM_NAME',
                        holdable: 'hold',
                        listeners : {
                            applyextparam: function(popup){
                                popup.setExtParam({
                                    'DIV_CODE':   panelResult.getValue('DIV_CODE'),
                                    'ADD_QUERY1': "ITEM_CODE IN ((SELECT  A.ITEM_CODE" +
                                                  "               FROM               S_RYT210T_KD AS A WITH (NOLOCK) " +
                                                  "                       INNER JOIN S_RYT200T_KD AS B WITH (NOLOCK) ON B.COMP_CODE   = A.COMP_CODE" +
                                                  "                                                                 AND B.DIV_CODE    = A.DIV_CODE" +
                                                  "                                                                 AND B.CUSTOM_CODE = A.CUSTOM_CODE" +
                                                  "                                                                 AND B.CON_FR_YYMM = A.CON_FR_YYMM" +
                                                  "                                                                 AND B.CON_TO_YYMM = A.CON_TO_YYMM" +
                                                  "                                                                 AND B.GUBUN1      = A.GUBUN1" +
                                                  "               WHERE   A.COMP_CODE = ",
                                    'ADD_QUERY2': "               AND     A.DIV_CODE  = ",
                                    'ADD_QUERY3': "               AND     A.GUBUN1    = 'R'" +
                                                  "               AND     B.GUBUN3    = 'Y'))"
                                });   //WHERE절 추가 쿼리
                            }
                        }
             })
        ],
        api: {
            submit: 's_ryt300ukrv_kdService.syncForm'
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
        },
        setLoadRecord: function(record) {
            var me = this;
            me.uniOpt.inLoading=false;
            me.setAllFieldsReadOnly(true);
        }
    });
 	// create the Grid
	var realMasterGrid = Unilite.createGrid('s_ryt300ukrv_kdmasterGrid1', {
			region:'center',
			enableColumnMove: false,
			store: directRealMasterStore,
			uniOpt:{
				useRowNumberer: true,
				copiedRow : true,
	        	expandLastColumn: false
	        },
	        itemId:'s_ryt300ukrv_kdmasterGrid1',
			columns : [   {dataIndex : 'COMP_CODE',			width : 80, hidden: true}
							, {dataIndex : 'DIV_CODE',			width : 150, hidden: true}
							, {dataIndex : 'ITEM_CODE',		width : 100		}
							, {dataIndex : 'ITEM_NAME',	width : 150		}
							, {dataIndex : 'SPEC',			width : 110		}
							, {dataIndex : 'BOM_YN',			width : 90, align:'center'	}
					],
			listeners : {
				  beforeedit  : function( editor, e, eOpts ) {

		                        return false;

		         }
				,beforedeselect : function ( gird, record, index, eOpts )	{
									var detailStore = Ext.getCmp('s_ryt300ukrv_kdmasterGrid').getStore();
									if(detailStore.isDirty())	{
										if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
											var inValidRecs = detailStore.getInvalidRecords();
											if(inValidRecs.length > 0 )	{
												alert(Msg.sMB083);
												return false;
											}else {
												detailStore.saveStore();
											}
										}
									}
								}
		    	,selectionchange : function(grid, selected, eOpts) {
								this.setDetailGrd( selected, eOpts)	;

							}
			}
			, setDetailGrd : function (selected, eOpts) {
								if(selected.length > 0)	{
									var dgrid = Ext.getCmp('s_ryt300ukrv_kdmasterGrid');
									var record = selected[0];
									dgrid.getStore().loadStoreRecords(record.data['ITEM_CODE']);
								}
							}
			});

    var masterGrid = Unilite.createGrid('s_ryt300ukrv_kdmasterGrid', {
        layout : 'fit',
        region: 'center',
        store: directMasterStore,
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useRowNumberer: false,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        features: [{
            id: 'masterGridSubTotal',
            ftype: 'uniGroupingsummary',
            showSummaryRow: false
        },{
            id: 'masterGridTotal',
            ftype: 'uniSummary',
            showSummaryRow: true
        }],
        tbar: [{
            xtype: 'button',
            text: 'BOM복사',
            disabled: false,
            handler: function() {
                if(panelResult.setAllFieldsReadOnly(true) == false) {
                    return false;
                }

                openBomCopyWindow();


            }
        },{
            xtype: 'button',
            text: '출력',
            handler: function() {
                if(panelResult.setAllFieldsReadOnly(true) == false) {
                    return false;
                }

                var param = panelResult.getValues();
			    var grdData = realMasterGrid.getSelectedRecord();
                param.DIV_CODE          = panelResult.getValue('DIV_CODE');
                param.CUSTOM_CODE       = panelResult.getValue('CUSTOM_CODE');
                param.PROD_ITEM_CODE    = grdData.get('ITEM_CODE');

                var win = Ext.create('widget.CrystalReport', {
                    url: CPATH+'/z_kd/s_ryt300cukrv_kd.do',
                    prgID: 's_ryt300cukrv_kd',
                        extParam: param
                });
                win.center();
                win.show();
            }
        }],
        columns:  [
            {dataIndex : 'COMP_CODE',           width : 100, hidden : true},
            {dataIndex : 'DIV_CODE',            width : 100, hidden : true},
            {dataIndex : 'CUSTOM_CODE',         width : 100, hidden : true},
            {dataIndex : 'PROD_ITEM_CODE',      width : 100, hidden : true},
            {dataIndex : 'CHILD_ITEM_CODE',     width : 120,
                editor: Unilite.popup('DIV_PUMOK_G', {
                    textFieldName: 'ITEM_CODE',
                    DBtextFieldName: 'ITEM_CODE',
                    extParam: {SELMODEL: 'MULTI', POPUP_TYPE: 'GRID_CODE'},
                    autoPopup:true,
                    useBarcodeScanner: false,
                    listeners: {'onSelected': {
                        fn: function(records, type) {
                            console.log('records : ', records);
                            Ext.each(records, function(record, i) {
                                if(i==0) {
                                    masterGrid.setItemData(record, false, masterGrid.uniOpt.currentRecord);
                                } else {
                                    UniAppManager.app.onNewDataButtonDown();
                                    masterGrid.setItemData(record, false, masterGrid.getSelectedRecord());
                                }
                            });
                        },
                        scope: this
                    },
                        'onClear': function(type) {
                            masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
                        },
                        applyextparam: function(popup){
                            var record  = masterGrid.getSelectedRecord();
                            var divCode = record.get('DIV_CODE');
                            popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
                            popup.setExtParam({'DIV_CODE': divCode});
                        }
                    }
                })
            },
            {dataIndex : 'CHILD_ITEM_NAME',     width : 200,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.inventory.subtotal" default="소계"/>', '<t:message code="system.label.inventory.total" default="총계"/>');
				}},
            {dataIndex : 'CHILD_SPEC',          width : 170},
            {dataIndex : 'KG_REQ_PRICE',        width : 120},
            {dataIndex : 'KG_REQ_QTY',          width : 120},
            {dataIndex : 'UNIT_REQ_QTY',        width : 120},
            {dataIndex : 'REQ_AMT',        		width : 120, summaryType: 'sum',
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
            		return Ext.util.Format.number(value, '0,000,000.000')
            	}
            }
        ],
        listeners: {
            beforeedit  : function( editor, e, eOpts ) {
                if(e.record.phantom) {
                    if(UniUtils.indexOf(e.field, ['CHILD_ITEM_NAME', 'CHILD_SPEC'])) {
                        return false;
                    }
                } else {
                    if(UniUtils.indexOf(e.field, ['CHILD_ITEM_CODE', 'CHILD_ITEM_NAME', 'CHILD_SPEC'])) {
                        return false;
                    }
                }
            }
        },
        setItemData : function(record, dataClear, grdRecord) {
            if(dataClear) {
                grdRecord.set('CHILD_ITEM_CODE', "");
                grdRecord.set('CHILD_ITEM_NAME', "");
                grdRecord.set('CHILD_SPEC'     , "");
            } else {
                grdRecord.set('CHILD_ITEM_CODE',    record['ITEM_CODE']);
                grdRecord.set('CHILD_ITEM_NAME',    record['ITEM_NAME']);
                grdRecord.set('CHILD_SPEC',         record['SPEC']);
            }
        }
    });

    var bomPopupStore = Unilite.createStore('bomPopupStore', {    //조회버튼 누르면 나오는 조회창
        model: 'bomPopupModel',
        autoLoad: false,
        uniOpt : {
            isMaster: false,            // 상위 버튼 연결
            editable: false,            // 수정 모드 사용
            deletable:false,            // 삭제 가능 여부
            useNavi : false         // prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
                read: 's_ryt300ukrv_kdService.selectList2'
            }
        }
        ,loadStoreRecords : function()  {
            var param= bomPopupSearch.getValues();
            console.log( param );
            this.load({
                params : param
            });
        }
    });

    var bomPopupSearch = Unilite.createSearchForm('bomPopupSearchForm', {     //조회버튼 누르면 나오는 조회창
        layout: {type: 'uniTable', columns : 3},
        trackResetOnLoad: true,
        items: [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                value: UserInfo.divCode,
                allowBlank: false
            },{
				fieldLabel: '작업년도',
				name: 'WORK_YEAR',
				xtype: 'uniCombobox',
				holdable: 'hold',
				comboType : 'AU',
			    comboCode : 'BS90',
				value: new Date().getFullYear(),
				allowBlank: false,
				hidden: false
	    	},{
				fieldLabel	: '반기',
				name		: 'WORK_SEQ',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'Z004',
				holdable: 'hold',
				allowBlank: false,
				hidden: false
			},
            Unilite.popup('AGENT_CUST', {
                    fieldLabel: '거래처',
                    allowBlank: false,
                    listeners: {
                        applyextparam: function(popup){
                            popup.setExtParam({
                                'DIV_CODE':   panelResult.getValue('DIV_CODE'),
                                'ADD_QUERY1': "A.CUSTOM_CODE IN ((SELECT CUSTOM_CODE FROM S_RYT100T_KD WHERE COMP_CODE = ",
                                'ADD_QUERY2': " AND DIV_CODE = ",
                                'ADD_QUERY3': "))"
                            });   //WHERE절 추가 쿼리
                        }
                    }
            }),
            Unilite.popup('DIV_PUMOK',{
                        fieldLabel : '제품코드',
                        valueFieldName : 'PROD_ITEM_CODE',
                        textFieldName : 'PROD_ITEM_NAME',
                        allowBlank: false,
                        listeners : {
                            applyextparam: function(popup){
                                popup.setExtParam({
                                    'DIV_CODE':   panelResult.getValue('DIV_CODE'),
                                    'ADD_QUERY1': "A.ITEM_CODE IN ((SELECT  A.ITEM_CODE" +
                                                  "               FROM               S_RYT210T_KD AS A WITH (NOLOCK) " +
                                                  "                       INNER JOIN S_RYT200T_KD AS B WITH (NOLOCK) ON B.COMP_CODE   = A.COMP_CODE" +
                                                  "                                                                 AND B.DIV_CODE    = A.DIV_CODE" +
                                                  "                                                                 AND B.CUSTOM_CODE = A.CUSTOM_CODE" +
                                                  "                                                                 AND B.CON_FR_YYMM = A.CON_FR_YYMM" +
                                                  "                                                                 AND B.CON_TO_YYMM = A.CON_TO_YYMM" +
                                                  "                                                                 AND B.GUBUN1      = A.GUBUN1" +
                                                  "               WHERE   A.COMP_CODE = ",
                                    'ADD_QUERY2': "               AND     A.DIV_CODE  = ",
                                    'ADD_QUERY3': "               AND     A.GUBUN1    = 'R'" +
                                                  "               AND     B.GUBUN3    = 'Y'))"
                                });   //WHERE절 추가 쿼리
                            }
                        }
             })
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
    }); // createSearchForm

    var bomCopySearch = Unilite.createSearchForm('bomCopySearchForm', {
		layout	: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items	: [{
				fieldLabel	: '사업장',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				hidden 		: true,
				tdAttrs		: {width: 280}

			},Unilite.popup('AGENT_CUST',{
				fieldLabel		: '거래처',
				validateBlank	: false,
				allowBlank		: false,
				readOnly			: true,
				colspan			: 3,
				width			: 380,
				textFieldName: 'AGENT_CUST_NM',
	            valueFieldName: 'AGENT_CUST_CD',
				tdAttrs			: {width: 280},
				listeners		: {
					'onSelected': {
						fn: function(records, type) {

						},
						scope: this
					},
					applyextparam: function(popup){

					}
				}
		}), {
			fieldLabel: '복사년도',
			name: 'WORK_YEAR_FR',
			xtype: 'uniCombobox',
			comboType : 'AU',
		    comboCode : 'BS90',
			holdable: 'hold',
			value: new Date().getFullYear(),
			allowBlank: false,
			hidden: false
    	},{
			fieldLabel	: '복사반기',
			name		: 'WORK_SEQ_FR',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'Z004',
			holdable: 'hold',
			width:200,
			allowBlank: false,
			hidden: false
		}, {
			fieldLabel: '대상년도',
			name: 'WORK_YEAR_TO',
			xtype: 'uniCombobox',
			comboType : 'AU',
		    comboCode : 'BS90',
			holdable: 'hold',
			value: new Date().getFullYear(),
			allowBlank: false,
			hidden: false
    	},{
			fieldLabel	: '대상반기',
			name		: 'WORK_SEQ_TO',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'Z004',
			holdable: 'hold',
			width:200,
			allowBlank: false,
			hidden: false
		}
		,{
    	xtype:'container',
    	defaultType:'uniTextfield',
    	 flex:1,
    	 layout: {type:'uniTable', columns:1},
    	 margin:'5 0 80 180',
    	items:[
    		{
				xtype	: 'button',
				name	: 'CONFIRM_CHECK1',
				id		: 'procCanc5',
				text	: '복사',
				width	: 100,
				hidden: false,
				handler : function() {//외주처 복사 팝업 호출
				    var workYearFr = 	bomCopySearch.getValue("WORK_YEAR_FR");
				    var workSeqFr = 		bomCopySearch.getValue("WORK_SEQ_FR");
				    var workYearTo = 	bomCopySearch.getValue("WORK_YEAR_TO");
				    var workSeqTo = 	bomCopySearch.getValue("WORK_SEQ_TO");
				    var workSeqTo1 = 	"";
				    if(workSeqTo1 == "1"){
				    	workSeqTo1 = "상반기";
				    }else{
				    	workSeqTo1 = "하반기";
				    }
					if(!bomCopySearch.getInvalidMessage()) {
						return false;
					}
					if(workYearFr == workYearTo && workSeqFr == workSeqTo){
						alert("같은 년도와 반기로 복사할 수는 없습니다.")
						return false;
					}

					Ext.MessageBox.show({
		                title: CommonMsg.errorTitle.ERROR,
		                msg: workYearTo + "년도 " +  workSeqTo1 + "로 BOM을 복사하시겠습니까?",
		                buttons: Ext.Msg.YESNOCANCEL,
					    icon: Ext.Msg.QUESTION,
					    fn: function(res) {
					     	//console.log(res);
					     	if (res === 'yes' ) {
					     		var param = {"DIV_CODE": panelResult.getValue('DIV_CODE'),
					     							"CUSTOM_CODE":	gsCustomCode,
					     							"CUSTOM_NAME": gsCustomName,
					     							"WORK_YEAR_FR": workYearFr,
					     							"WORK_SEQ_FR": workSeqFr,
					     							"WORK_YEAR_TO": workYearTo,
					     							"WORK_SEQ_TO": workSeqTo};

					     		s_ryt300ukrv_kdService.bomCopy(param, function(provider, response) {
					                 if(!Ext.isEmpty(provider)){
											alert("복사가 완료됐습니다.");
											bomCopySearch.clearForm();
											bomCopyWindow.hide();
					                 }
					             })


					     	} else if(res === 'cancel') {
					     		return false;
					     	}
					     }
		            });
				 }
			}
		]
    }]
	}); // createSearchForm

    var bomPopupGrid = Unilite.createGrid('s_ryt300ukrv_kdMasterGrid', {     //조회버튼 누르면 나오는 조회창
        layout : 'fit',
        excelTitle: '기술마스터팝업',
        store: bomPopupStore,
        uniOpt:{
            expandLastColumn: false,
            useRowNumberer: false
        },
        columns:  [
            { dataIndex: 'COMP_CODE',       width:100, hidden: true},
            { dataIndex: 'DIV_CODE',        width:100, hidden: true},
            { dataIndex: 'CUSTOM_CODE',     width:110},
            { dataIndex: 'CUSTOM_NAME',     width:200},
            { dataIndex: 'ITEM_CODE',       width:120},
            { dataIndex: 'ITEM_NAME',       width:200},
            { dataIndex: 'SPEC',            width:150}
        ],
        listeners: {
            onGridDblClick: function(grid, record, cellIndex, colName) {
                bomPopupGrid.returnData(record);
                UniAppManager.app.onQueryButtonDown();
                SearchInfoWindow.hide();
                panelResult.setAllFieldsReadOnly(true);
            }
        },
        returnData: function(record)    {
            if(Ext.isEmpty(record)) {
                record = this.getSelectedRecord();
            }
            panelResult.setValues({
                'DIV_CODE'          : record.get('DIV_CODE'),
                'CUSTOM_CODE'       : record.get('CUSTOM_CODE'),
                'CUSTOM_NAME'       : record.get('CUSTOM_NAME'),
                'PROD_ITEM_CODE'    : record.get('ITEM_CODE'),
                'PROD_ITEM_NAME'    : record.get('ITEM_NAME'),
                'SPEC'              : record.get('SPEC'),
                'WORK_YEAR'              : record.get('WORK_YEAR'),
                'WORK_SEQ'              : record.get('WORK_SEQ')
            });
        }
    });

    function openSearchInfoWindow() {           //조회버튼 누르면 나오는 조회창
        if(!SearchInfoWindow) {
            SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '기술BOM팝업',
                width: 1000,
                height: 500,
                layout: {type:'vbox', align:'stretch'}, //위치 확인 필요
                items: [bomPopupSearch, bomPopupGrid],
                tbar:  ['->',
                    {
                        itemId : 'saveBtn',
                        text: '조회',
                        handler: function() {
                            if(bomPopupSearch.setAllFieldsReadOnly(true) == false){
                                return false;
                            }
                            bomPopupStore.loadStoreRecords();
                        },
                        disabled: false
                    }, {
                        itemId : 'inoutNoCloseBtn',
                        text: '닫기',
                        handler: function() {
                            SearchInfoWindow.hide();
                        },
                        disabled: false
                    }
                ],
                listeners : {
                    beforehide: function(me, eOpt)  {
                        bomPopupSearch.clearForm();
                        bomPopupGrid.reset();
                    },
                     beforeclose: function( panel, eOpts )  {
                        bomPopupSearch.clearForm();
                        bomPopupGrid.reset();
                    },
                    show: function( panel, eOpts )  {
                        bomPopupSearch.setValue('DIV_CODE'       , panelResult.getValue('DIV_CODE'));
                        bomPopupSearch.setValue('WORK_YEAR'    , panelResult.getValue('WORK_YEAR'));
                        bomPopupSearch.setValue('WORK_SEQ'    , panelResult.getValue('WORK_SEQ'));
                     }
                }
            })
        }
        SearchInfoWindow.center();
        SearchInfoWindow.show();
    };

  //BOM복사 팝업	//////////////////////////////////////////////////////////////////////////////////////////////////////
	function openBomCopyWindow() {
		if(!panelResult.getInvalidMessage()) {
			return false;
		}
		if(!Ext.isEmpty(bomCopyWindow)){
//			custCopyWindow.extParam.BILL_TYPE	= panelResult.getValue('BILL_TYPE');
//			custCopyWindow.extParam.ISSUE_GUBUN	= Ext.getCmp('rdoSelect0').getChecked()[0].inputValue;
//			custCopyWindow.extParam.APPLY_YN	= Ext.getCmp('rdoSelect0_0').getChecked()[0].inputValue;
		}
		if(!bomCopyWindow) {
			bomCopyWindow = Ext.create('widget.uniDetailWindow', {
				title	: 'BOM 복사',
				width	: 500,
				height	:200,
				layout	: {type:'vbox', align:'stretch'},
				items	: [bomCopySearch],
				tbar	:  ['->',{
					itemId	: 'closepartListBtn',
					text	: '닫기',
					disabled: false,
					handler	: function() {
						bomCopyWindow.hide();
					}
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						bomCopySearch.clearForm();

					},
					beforeclose: function( panel, eOpts )  {
						bomCopySearch.clearForm();

					},
					show: function( panel, eOpts ) {
						bomCopySearch.setValue('DIV_CODE'				, panelResult.getValue('DIV_CODE'));
					 	bomCopySearch.setValue('AGENT_CUST_CD'		, gsCustomCode);
					 	bomCopySearch.setValue('AGENT_CUST_NM'		, gsCustomName);
					 	bomCopySearch.setValue('WORK_YEAR_FR'	    , panelResult.getValue('WORK_YEAR'));
					 	bomCopySearch.setValue('WORK_SEQ_FR'		, panelResult.getValue('WORK_SEQ'));

					}
				}
			})
		}
		bomCopyWindow.center();
		bomCopyWindow.show();
	}
    Unilite.Main( {
    	items : [ panelResult, {
			xtype : 'container',
			flex : 1,
			layout : 'border',
			defaults : {
				collapsible : false,
				split : true
			},
			items : [ {
				region : 'center',
				xtype : 'container',
				layout : 'fit',
				items : [ realMasterGrid ]
			}, {
				region : 'east',
				xtype : 'container',
				layout : 'fit',
				flex : 3,
				items : [ masterGrid ]
			} ]

		} ],
        id  : 's_ryt300ukrv_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'deleteAll'], false);
            UniAppManager.setToolbarButtons(['newData'], true);
            this.setDefault();
        },
        onQueryButtonDown : function()  {
            var customCode = panelResult.getValue('CUSTOM_CODE');
            if(Ext.isEmpty(customCode)) {
                openSearchInfoWindow()
            } else {
               if(panelResult.setAllFieldsReadOnly(true) == false){
                    return false;
                }
                //directMasterStore.loadStoreRecords();
            	realMasterGrid.getStore().loadStoreRecords();
            }
            UniAppManager.setToolbarButtons(['reset'], true);
            UniAppManager.setToolbarButtons(['newData'], true);
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            panelResult.setAllFieldsReadOnly(false);
            panelResult.clearForm();
            panelResult.clearForm();
            masterGrid.reset();
            realMasterGrid.reset();
            this.setDefault();
        },
        onNewDataButtonDown: function() {       // 행추가
            if(panelResult.setAllFieldsReadOnly(true) == false){
                    return false;
            }
            if(directRealMasterStore.getCount() == 0){
            	alert("조회된 데이터가 없습니다. 조회 후 다시 시도해주세요")
                return false;
       		 }
            var grdData =  realMasterGrid.getSelectedRecord();
            var compCode        =   UserInfo.compCode;
            var divCode         =   panelResult.getValue('DIV_CODE');
            var customCode      =   panelResult.getValue('CUSTOM_CODE');
            var prodItemCode    =   grdData.get('ITEM_CODE');
            var workYear    =   panelResult.getValue('WORK_YEAR');
            var workSeq    =   panelResult.getValue('WORK_SEQ');

            var r = {
                COMP_CODE       : compCode,
                DIV_CODE        : divCode,
                CUSTOM_CODE     : customCode,
                PROD_ITEM_CODE  : prodItemCode,
				WORK_YEAR : workYear,
				WORK_SEQ : workSeq
            };
            masterGrid.createRow(r);
        },
        onDeleteDataButtonDown: function() {
            var selRow1 = masterGrid.getSelectedRecord();
                if(selRow1.phantom === true) {
                    masterGrid.deleteSelectedRow();
                } else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                    masterGrid.deleteSelectedRow();
                }
        },
        onSaveDataButtonDown: function () {
            directMasterStore.saveStore();
        },
        setDefault: function() {
            directMasterStore.clearData();
            directRealMasterStore.clearData();
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('WORK_YEAR',new Date().getFullYear());
            panelResult.setValue('WORK_SEQ','1');
            UniAppManager.setToolbarButtons(['save'], false);
        },
        checkForNewDetail:function() {
            return panelResult.setAllFieldsReadOnly(true);
        }
    });


    var validation = Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, detailGrid, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "KG_REQ_PRICE" :


					var kgReqPrice = newValue;
					var kgReqQty   = 0;
					var unitReqQty = 0;

					kgReqQty   = record.get('KG_REQ_QTY');
					unitReqQty = record.get('UNIT_REQ_QTY');

					if(kgReqQty == 0 && unitReqQty != 0){//kg소요량이 0일때 1로 세팅
						kgReqQty = 1;
					}else if(kgReqQty != 0 && unitReqQty == 0){//단위소요량이 0일때 1로 세팅
						unitReqQty = 1;
					}
					record.set('REQ_AMT', kgReqPrice * kgReqQty * unitReqQty);

					break;

				case "KG_REQ_QTY" :
					var kgReqPrice = 0;
					var kgReqQty   = newValue;
					var unitReqQty = 0;

					kgReqPrice = record.get('KG_REQ_PRICE');
					unitReqQty = record.get('UNIT_REQ_QTY');

					if(kgReqQty == 0 && unitReqQty != 0){//kg소요량이 0일때 1로 세팅
						kgReqQty = 1;
					}else if(kgReqQty != 0 && unitReqQty == 0){//단위소요량이 0일때 1로 세팅
						unitReqQty = 1;
					}
					record.set('REQ_AMT', kgReqPrice * kgReqQty * unitReqQty);

					break;
				case "UNIT_REQ_QTY" :
					var kgReqPrice = 0;
					var kgReqQty   = 0;
					var unitReqQty = newValue;

					kgReqPrice = record.get('KG_REQ_PRICE');
					kgReqQty   = record.get('KG_REQ_QTY');

					if(kgReqQty == 0 && unitReqQty != 0){//kg소요량이 0일때 1로 세팅
						kgReqQty = 1;
					}else if(kgReqQty != 0 && unitReqQty == 0){//단위소요량이 0일때 1로 세팅
						unitReqQty = 1;
					}

					record.set('REQ_AMT', kgReqPrice * kgReqQty * unitReqQty);

					break;

			}
			return rv;
		}
	}); // validator
}

</script>