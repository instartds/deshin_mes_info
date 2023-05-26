<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmd900skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_pmd900skrv_kd"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--매출구분-->
    <t:ExtComboStore comboType="AU" comboCode="WB08" /> <!--금형구분-->
    <t:ExtComboStore comboType="AU" comboCode="WB09" /> <!--위치상태-->
    <t:ExtComboStore comboType="AU" comboCode="WB10" /> <!--제작원인-->
    <t:ExtComboStore comboType="AU" comboCode="WB11" /> <!--수금구분-->
    <t:ExtComboStore comboType="AU" comboCode="B219" /> <!--등록여부-->
    <t:ExtComboStore comboType="AU" comboCode="B010" /> <!-- 사용여부-->
    <t:ExtComboStore comboType="AU" comboCode="WB04" /> <!-- 차종  -->
    <t:ExtComboStore comboType="AU" comboCode="WB12" /> <!--의뢰구분-->
    <t:ExtComboStore comboType="AU" comboCode="WB13" /> <!--보수코드-->
    <t:ExtComboStore comboType="AU" comboCode="WB14" /> <!--진행구분-->
    <t:ExtComboStore comboType="AU" comboCode="A036" /> <!--상각방법-->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	
	/**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('s_pmd900skrv_kdModel', {
        fields: [
            {name: 'COMP_CODE'              ,text:'법인코드'               ,type: 'string'},
            {name: 'DIV_CODE'               ,text:'사업장'                 ,type: 'string', comboType:'BOR120'},
            {name: 'MOLD_CODE'              ,text:'금형코드'               ,type: 'string'},
            {name: 'MOLD_NAME'              ,text:'금형명'                 ,type: 'string'},
            {name: 'MOLD_TYPE'              ,text:'금형구분'               ,type: 'string', comboType: 'AU', comboCode: 'WB08'},
            {name: 'MOLD_MTL'               ,text:'금형소재'               ,type: 'string'},
            {name: 'MOLD_QLT'               ,text:'금형재질'               ,type: 'string'},
            {name: 'MOLD_SPEC'              ,text:'금형규격'               ,type: 'string'},
            {name: 'ITEM_CODE'              ,text:'품목코드'               ,type: 'string'},
            {name: 'ITEM_NAME'              ,text:'품목명'                 ,type: 'string'},
            {name: 'OEM_ITEM_NAME'          ,text:'품번'                   ,type: 'string'},
            {name: 'CAR_TYPE'               ,text:'차종'                   ,type: 'string', comboType: 'AU', comboCode: 'WB04'},
            {name: 'MOLD_PRICE'             ,text:'금형단가'               ,type: 'uniUnitPrice'},
            {name: 'MOLD_NUM'               ,text:'금형도번'               ,type: 'string'},
            {name: 'MOLD_STRC'              ,text:'금형구조'               ,type: 'string'},
            {name: 'TXT_LIFE'               ,text:'수명'                   ,type: 'string'},
            {name: 'MT_DEPR'                ,text:'상각방법'               ,type: 'string', comboType: 'AU', comboCode: 'A036'},
            {name: 'MAX_DEPR'               ,text:'최대상각'               ,type: 'uniQty'},
            {name: 'CHK_DEPR'               ,text:'점검상각'               ,type: 'uniQty'},
            {name: 'NOW_DEPR'               ,text:'현상각'                 ,type: 'uniQty'},
            {name: 'CHK_RATE'               ,text:'점검율 '                ,type: 'uniER'},          // (현타발수/점검상각)*100 
            {name: 'LIMT_DEPR'              ,text:'한도상각'               ,type: 'uniQty'},
            {name: 'CAVITY'                 ,text:'CAVITY'                 ,type: 'uniQty'},
            {name: 'USE_YN'                 ,text:'사용유무'               ,type: 'string', comboType: 'AU', comboCode: 'B010'},
            {name: 'DATE_INST'              ,text:'설치일자'               ,type: 'uniDate'},
            {name: 'DATE_BEHV'              ,text:'가동일자'               ,type: 'uniDate'},
            {name: 'ST_LOCATION'            ,text:'위치상태'               ,type: 'string', comboType: 'AU', comboCode: 'WB09'},
            {name: 'COMP_KEEP'              ,text:'보관방법'               ,type: 'string'},
            {name: 'LOCATION_KEEP'          ,text:'보관위치'               ,type: 'string'},
            {name: 'DATE_PASSOVER'          ,text:'이관일자'               ,type: 'uniDate'},
            {name: 'MAKE_REASON'            ,text:'제작원인'               ,type: 'string', comboType: 'AU', comboCode: 'WB10'},
            {name: 'DATE_MAKE'              ,text:'제작일자'               ,type: 'uniDate'},
            {name: 'MAKER_NAME_CODE'        ,text:'제작업체코드'           ,type: 'string'},
            {name: 'MAKER_NAME_NAME'        ,text:'제작업체명'             ,type: 'string'},
            {name: 'COMP_OWN_CODE'          ,text:'소유업체코드'           ,type: 'string'},
            {name: 'COMP_OWN_NAME'          ,text:'소유업체명'             ,type: 'string'},
            {name: 'COMP_DEV_CODE'          ,text:'개발업체코드'           ,type: 'string'},
            {name: 'COMP_DEV_NAME'          ,text:'개발업체명'             ,type: 'string'},
            {name: 'KEEP_CUSTOM_CODE'       ,text:'보관업체코드'           ,type: 'string'},
            {name: 'KEEP_CUSTOM_NAME'       ,text:'보관업체명'             ,type: 'string'},
            {name: 'TP_COLLECT'             ,text:'수금구분'               ,type: 'string', comboType: 'AU', comboCode: 'WB11'},
            {name: 'DISP_REASON'            ,text:'폐기사유'               ,type: 'string'},
            {name: 'DATE_DISP'              ,text:'폐기일자'               ,type: 'uniDate'}
        ]
    }); 
    
    Unilite.defineModel('s_pmd900skrv_kdModel2', {
        fields: [
            {name: 'COMP_CODE'              ,text:'법인코드'             ,type: 'string'},
            {name: 'DIV_CODE'               ,text:'사업장'               ,type: 'string', comboType:'BOR120'},
            {name: 'WKORD_NUM'              ,text:'작업지시번호'         ,type: 'string'},
            {name: 'PRODT_NUM'              ,text:'실적번호'             ,type: 'string'},
            {name: 'PRODT_DATE'             ,text:'실적일자'             ,type: 'uniDate'},
            {name: 'ITEM_CODE'              ,text:'작지품목'             ,type: 'string'},
            {name: 'ITEM_NAME'              ,text:'작지품목명'           ,type: 'string'},
            {name: 'PROG_WORK_CODE'         ,text:'공정코드'             ,type: 'string'},
            {name: 'PROG_WORK_NAME'         ,text:'공정명'               ,type: 'string'},
            {name: 'MOLD_CODE'              ,text:'금형코드'             ,type: 'string'},
            {name: 'MOLD_NAME'              ,text:'금형명'               ,type: 'string'},
            {name: 'NOW_DEPR'               ,text:'타발수'               ,type: 'uniQty'}
        ]
    }); 
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore = Unilite.createStore('s_pmd900skrv_kdMasterStore1',{
        model: 's_pmd900skrv_kdModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {          
                read: 's_pmd900skrv_kdService.selectList'                 
            }
        },
        loadStoreRecords : function()   {   
            var param= panelResult.getValues();
            this.load({
                  params : param
            });         
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
                var count = masterGrid.getStore().getCount();
                if(count == 0) {
                	masterGrid2.reset();
                }
            }
        }
    }); // End of var directMasterStore1 
    
    var directMasterStore2 = Unilite.createStore('s_pmd900skrv_kdMasterStore2',{
        model: 's_pmd900skrv_kdModel2',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {          
                read: 's_pmd900skrv_kdService.selectList2'                 
            }
        },
        loadStoreRecords : function(param)   {   
            this.load({
                  params : param
            });         
        },
        groupField: 'PRODT_DATE'
    }); // End of var directMasterStore1 
    
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
        id: 'RESULT_SEARCH',
        items: [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
                value: UserInfo.divCode
            },{ 
                fieldLabel: '제작일자',
                xtype: 'uniDateRangefield',
                startFieldName: 'DATE_MAKE_FR',
                endFieldName: 'DATE_MAKE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today')
            },{
                fieldLabel: '위치상태',
                name:'ST_LOCATION',  
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'WB09'
            },{
                fieldLabel: '금형구분',
                name:'MOLD_TYPE',  
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'WB08'
            },
            Unilite.popup('MOLD_CODE',{ 
                    fieldLabel: '금형',
                    valueFieldName:'MOLD_CODE',
                    textFieldName:'MOLD_NAME',
                    valueFieldWidth: 100,
                    textFieldWidth: 200,
                    autoPopup:true,
                    listeners: {
                        applyextparam: function(popup){                         
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                        }
                    }
            }),{
                fieldLabel: '품번',
                name:'OEM_ITEM_CODE',   
                xtype: 'uniTextfield'
//                allowBlank:false
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
    
    var masterGrid = Unilite.createGrid('s_pmd900skrv_kdmasterGrid', { 
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
        selModel: 'rowmodel',
        columns:  [ 
            { dataIndex: 'COMP_CODE'                              ,           width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'                               ,           width: 80, hidden: true},
            { dataIndex: 'MOLD_TYPE'                              ,           width: 80},
            { dataIndex: 'MOLD_CODE'                              ,           width: 110},
            { dataIndex: 'MOLD_NAME'                              ,           width: 200},
            { dataIndex: 'DATE_INST'                              ,           width: 80},
            { dataIndex: 'OEM_ITEM_NAME'                          ,           width: 110},
            { dataIndex: 'CAR_TYPE'                               ,           width: 80},
            { dataIndex: 'MT_DEPR'                                ,           width: 80},
            { dataIndex: 'MAX_DEPR'                               ,           width: 80},
            { dataIndex: 'CHK_DEPR'                               ,           width: 80},
            { dataIndex: 'NOW_DEPR'                               ,           width: 80},
            { dataIndex: 'CHK_RATE'                               ,           width: 80},
            { dataIndex: 'LIMT_DEPR'                              ,           width: 80},
            { dataIndex: 'USE_YN'                                 ,           width: 80},
            { dataIndex: 'ST_LOCATION'                            ,           width: 80},
            { dataIndex: 'DATE_BEHV'                              ,           width: 80, hidden: true},
            { dataIndex: 'MOLD_MTL'                               ,           width: 80, hidden: true},
            { dataIndex: 'MOLD_QLT'                               ,           width: 80, hidden: true},
            { dataIndex: 'MOLD_SPEC'                              ,           width: 100, hidden: true},
            { dataIndex: 'ITEM_CODE'                              ,           width: 110, hidden: true},
            { dataIndex: 'ITEM_NAME'                              ,           width: 200, hidden: true},
            { dataIndex: 'MOLD_PRICE'                             ,           width: 80, hidden: true},
            { dataIndex: 'MOLD_NUM'                               ,           width: 80, hidden: true},
            { dataIndex: 'MOLD_STRC'                              ,           width: 80, hidden: true},
            { dataIndex: 'TXT_LIFE'                               ,           width: 80, hidden: true},
            { dataIndex: 'CAVITY'                                 ,           width: 80, hidden: true},
            { dataIndex: 'COMP_KEEP'                              ,           width: 80, hidden: true},
            { dataIndex: 'LOCATION_KEEP'                          ,           width: 80, hidden: true},
            { dataIndex: 'DATE_PASSOVER'                          ,           width: 80},
            { dataIndex: 'MAKE_REASON'                            ,           width: 80, hidden: true},
            { dataIndex: 'DATE_MAKE'                              ,           width: 80},
            { dataIndex: 'MAKER_NAME_CODE'                        ,           width: 100, hidden: true},
            { dataIndex: 'MAKER_NAME_NAME'                        ,           width: 200},
            { dataIndex: 'COMP_OWN_CODE'                          ,           width: 100, hidden: true},
            { dataIndex: 'COMP_OWN_NAME'                          ,           width: 100},
            { dataIndex: 'COMP_DEV_CODE'                          ,           width: 100, hidden: true},
            { dataIndex: 'COMP_DEV_NAME'                          ,           width: 200},
            { dataIndex: 'KEEP_CUSTOM_CODE'                       ,           width: 100, hidden: true},
            { dataIndex: 'KEEP_CUSTOM_NAME'                       ,           width: 200},
            { dataIndex: 'TP_COLLECT'                             ,           width: 80, hidden: true},
            { dataIndex: 'DISP_REASON'                            ,           width: 80, hidden: true},
            { dataIndex: 'DATE_DISP'                              ,           width: 80, hidden: true}
        ],
        listeners: {
            selectionchange:function( model1, selected, eOpts ){
                if(selected.length > 0) {
                    var record = selected[0];
                    var param = {
                        DIV_CODE       : record.get('DIV_CODE'),
                        MOLD_CODE      : record.get('MOLD_CODE'),
                        DATE_BEHV      : UniDate.getDbDateStr(record.get('DATE_BEHV'))
                    }
                    directMasterStore2.loadStoreRecords(param);
                }
            }
        }
    });
    
    var masterGrid2 = Unilite.createGrid('s_pbs071ukrv_kdGrid2', {
        layout : 'fit',
        region:'south',
        store : directMasterStore2, 
        uniOpt:{    
            expandLastColumn: false,
            useRowNumberer: true,
            useMultipleSorting: true
        },
        features: [ 
            {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
            {id: 'masterGridTotal',    ftype: 'uniSummary',         showSummaryRow: true} 
        ],
        columns: [
            {dataIndex: 'COMP_CODE'               ,       width: 110, hidden: true},
            {dataIndex: 'DIV_CODE'                ,       width: 120,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
                }
            },
            {dataIndex: 'WKORD_NUM'               ,       width: 110},
            {dataIndex: 'PRODT_NUM'               ,       width: 100},
            {dataIndex: 'PRODT_DATE'              ,       width: 80},
            {dataIndex: 'ITEM_CODE'               ,       width: 110},
            {dataIndex: 'ITEM_NAME'               ,       width: 200},
            {dataIndex: 'PROG_WORK_CODE'          ,       width: 100},
            {dataIndex: 'PROG_WORK_NAME'          ,       width: 180},
            {dataIndex: 'MOLD_CODE'               ,       width: 100},
            {dataIndex: 'MOLD_NAME'               ,       width: 180},
            {dataIndex: 'NOW_DEPR'                ,       width: 80, summaryType: 'sum'}
        ]
    });
    
    
    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border : false,
            items:[
                masterGrid, masterGrid2, panelResult
            ]   
        }
        ],
        id  : 's_pmd900skrv_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'],false);
            this.setDefault();
        },
        onQueryButtonDown : function()  {
        	if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
            directMasterStore.loadStoreRecords();
            UniAppManager.setToolbarButtons(['reset'], true);
            UniAppManager.setToolbarButtons(['newData','deleteAll'],false);
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            panelResult.setAllFieldsReadOnly(false);
            panelResult.clearForm();
            panelResult.clearForm(); 
            masterGrid.reset();
            masterGrid2.reset();
            this.setDefault();
        },
        setDefault: function() {
            directMasterStore.clearData();
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
/*
            panelResult.setValue('DATE_INST_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('DATE_INST_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('DATE_INST_TO', UniDate.get('today'));
            panelResult.setValue('DATE_INST_TO', UniDate.get('today'));
*/            
            UniAppManager.setToolbarButtons(['save'], false);
        }                         
    });    
};
</script>