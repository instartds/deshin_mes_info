<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_afb500skr_KOCIS"  >
    
    <t:ExtComboStore comboType="AU" comboCode="A132" />         <!-- 수지구분 -->
    <t:ExtComboStore comboType="AU" comboCode="B042" />         <!-- 금액단위 -->
    <t:ExtComboStore comboType="AU" comboCode="A390" /> <!-- 회계구분 -->
    <t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> <!--기관-->
    
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>    
</t:appConfig>
<script type="text/javascript" >

function appMain() {
    
    Unilite.defineModel('Afb500Model1', {
        fields: [
            {name: 'AC_GUBUN'           , text: '회계구분'          , type: 'string',comboType:'AU', comboCode:'A390'},
//            {name: 'ACCT_NAME'          , text: '계좌명'           , type: 'string'},
//            {name: 'DEPT_NAME'          , text: '기관'             , type: 'string'},
//            {name: 'BUDG_CODE'          , text: '예산과목'          , type: 'string'},
            
            {name: 'NAME2'        , text: '프로그램'            , type: 'string'},
            {name: 'NAME3'        , text: '단위사업'            , type: 'string'},
            {name: 'NAME4'        , text: '세부사업'            , type: 'string'},
            {name: 'NAME5'        , text: '목'            , type: 'string'},
            {name: 'NAME6'        , text: '세목'         , type: 'string'},
            
            
            
            
            
            {name: 'YEAR_BUDGE'                  , text: '연간예산</br>(A)'          , type: 'uniUnitPrice'},
            {name: 'BUDG_CONF_I'        , text: '세출예산'          , type: 'uniUnitPrice'},
            {name: 'BUDG_ASGN_I'        , text: '세목조정'         , type: 'uniUnitPrice'},
            {name: 'BUDG_TRANSFER_I'    , text: '이체금액'         , type: 'uniUnitPrice'},
            {name: 'BUDG_IWALL_I'       , text: '이월/불용승인액'         , type: 'uniUnitPrice'},
            
//            {name: 'IWALL_AMT_I'        , text: '이월예산'         , type: 'uniUnitPrice'},
//            {name: 'CONF_AMT_I'         , text: '불용승인이월'      , type: 'uniUnitPrice'},
//            {name: 'REQ_AMT'            , text: '지출요청금액 ()'       , type: 'uniUnitPrice'},
            {name: 'EX_AMT_I'           , text: '지출액합계</br>(B)'      , type: 'uniUnitPrice'},
            {name: 'ORDER_AMT'           , text: '정정/반납액</br>(C)'      , type: 'uniUnitPrice'},
            
            
            {name: 'WON_BAL'              , text: '잔액</br>(A-B+C)'            , type: 'uniUnitPrice'},
            {name: 'BUDG_TYPE'          , text: '수지구분'          , type: 'string',comboType:'AU', comboCode:'A132'}
        ]
    });     // End of Ext.define('s_afb500skr_KOCISModel', {
    
    var masterStore = Unilite.createStore('Afb500masterStore',{
        model: 'Afb500Model1',
        uniOpt: {
            isMaster: true,             // 상위 버튼 연결
            editable: false,            // 수정 모드 사용
            deletable:false,            // 삭제 가능 여부
            useNavi : false             // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {
                read: 's_afb500skrService_KOCIS.selectList'                 
            }
        },
        loadStoreRecords: function() {
            var param = Ext.getCmp('searchForm').getValues();
            this.load({
                params : param
            });
        }
    });
    
    var panelSearch = Unilite.createSearchPanel('searchForm', {
        title: '검색조건',
        width: 360,
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
            items: [{
                xtype: 'uniYearField',
                fieldLabel: '예산년도',
                name: 'AC_YEAR',
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('AC_YEAR', newValue);
                    }
                }
            },{
                xtype: 'uniCombobox',
                fieldLabel: '회계구분',
                name: 'AC_GUBUN',
                comboType: 'AU',
                comboCode: 'A390',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('AC_GUBUN', newValue);
                    }
                }
            },{
                xtype: 'uniCombobox',
                name: 'BUDG_TYPE',
                comboType:'AU',
                comboCode:'A132',
                value: '2',
                fieldLabel: '수지구분',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('BUDG_TYPE', newValue);
                    }
                }
             },{
                xtype: 'uniCombobox',
                fieldLabel: '기관',
                name: 'DEPT_CODE',
                store: Ext.data.StoreManager.lookup('deptKocis'),
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('DEPT_CODE', newValue);
                    }
                }
            },
            Unilite.popup('BUDG_KOCIS_NORMAL',{
                fieldLabel: '예산과목',
                valueFieldName:'BUDG_CODE_FR',
                textFieldName:'BUDG_NAME_FR',
                //validateBlank:false,
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_CODE_FR', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_NAME_FR', newValue);                
                    },
                    applyextparam: function(popup) {
                        popup.setExtParam({'AC_YYYY': panelResult.getValue("AC_YEAR")}),
                        popup.setExtParam({'DEPT_CODE' : panelResult.getValue('DEPT_CODE')}),
                        popup.setExtParam({'ADD_QUERY' : "B.BUDG_TYPE = "+ "'" + panelResult.getValue('BUDG_TYPE')+ "'" + " AND B.GROUP_YN = 'N' AND A.USE_YN = 'Y'"})
                    }
                }
            }),
            Unilite.popup('BUDG_KOCIS_NORMAL',{
                fieldLabel: '~',
                valueFieldName:'BUDG_CODE_TO',
                textFieldName:'BUDG_NAME_TO',
                //validateBlank:false,
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_CODE_TO', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_NAME_TO', newValue);                
                    },
                    applyextparam: function(popup) {
                        popup.setExtParam({'AC_YYYY': panelResult.getValue("AC_YEAR")}),
                        popup.setExtParam({'DEPT_CODE' : panelResult.getValue('DEPT_CODE')}),
                       popup.setExtParam({'ADD_QUERY' : "B.BUDG_TYPE = "+ "'" + panelResult.getValue('BUDG_TYPE')+ "'" + " AND B.GROUP_YN = 'N' AND A.USE_YN = 'Y'"})
                    }
                }
            })]  
        }]
    });
    
    var panelResult = Unilite.createSearchForm('resultForm',{
        hidden: !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        items: [{
            xtype: 'uniYearField',
            fieldLabel: '예산년도',
            name: 'AC_YEAR',
            allowBlank:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('AC_YEAR', newValue);
                }
            }
        },{
            xtype: 'uniCombobox',
            fieldLabel: '회계구분',
            name: 'AC_GUBUN',
            comboType: 'AU',
            comboCode: 'A390',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('AC_GUBUN', newValue);
                }
            }
        },{
            xtype: 'uniCombobox',
            name: 'BUDG_TYPE',
            comboType:'AU',
            comboCode:'A132',
            value: '2',
            fieldLabel: '수지구분',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('BUDG_TYPE', newValue);
                }
            }
         },{
            xtype: 'uniCombobox',
            fieldLabel: '기관',
            name: 'DEPT_CODE',
            store: Ext.data.StoreManager.lookup('deptKocis'),
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('DEPT_CODE', newValue);
                }
            }
        },
        Unilite.popup('BUDG_KOCIS_NORMAL',{
            fieldLabel: '예산과목',
            valueFieldName:'BUDG_CODE_FR',
            textFieldName:'BUDG_NAME_FR',
            //validateBlank:false,
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('BUDG_CODE_FR', newValue);                                
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('BUDG_NAME_FR', newValue);                
                },
                applyextparam: function(popup) {
                    popup.setExtParam({'AC_YYYY': panelResult.getValue("AC_YEAR")}),
                    popup.setExtParam({'DEPT_CODE' : panelResult.getValue('DEPT_CODE')}),
                    popup.setExtParam({'ADD_QUERY' : "B.BUDG_TYPE = "+ "'" + panelResult.getValue('BUDG_TYPE')+ "'" + " AND B.GROUP_YN = 'N' AND A.USE_YN = 'Y'"})
                }
            }
        }),
        Unilite.popup('BUDG_KOCIS_NORMAL',{
            fieldLabel: '~',
            valueFieldName:'BUDG_CODE_TO',
            textFieldName:'BUDG_NAME_TO',
            labelWidth:15,
            //validateBlank:false,
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('BUDG_CODE_TO', newValue);                                
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('BUDG_NAME_TO', newValue);                
                },
                applyextparam: function(popup) {
                    popup.setExtParam({'AC_YYYY': panelResult.getValue("AC_YEAR")}),
                    popup.setExtParam({'DEPT_CODE' : panelResult.getValue('DEPT_CODE')}),
                    popup.setExtParam({'ADD_QUERY' : "B.BUDG_TYPE = "+ "'" + panelResult.getValue('BUDG_TYPE')+ "'" + " AND B.GROUP_YN = 'N' AND A.USE_YN = 'Y'"})
                }
            }
        })]
    });
    
    var masterGrid = Unilite.createGrid('Afb500Grid1', {
        features: [{
                id: 'masterGridSubTotal',   
                ftype: 'uniGroupingsummary',    
                showSummaryRow: false
            },{
                id: 'masterGridTotal',      
                ftype: 'uniSummary',            
                showSummaryRow: true
            }
        ],
        layout : 'fit',
        region : 'center',
        store: masterStore,
        uniOpt: {
            useMultipleSorting  : true,
            useLiveSearch       : true,
            useRowContext       : false,
            expandLastColumn    : true,
            onLoadSelectFirst   : true,
            dblClickToEdit      : false,
            useGroupSummary     : false,
            useContextMenu      : false,
            useRowNumberer      : true
        },
        selModel:'rowmodel',
        columns: [
            {dataIndex: 'AC_GUBUN'              , width: 100},
//            {dataIndex: 'ACCT_NAME'             , width: 100},
//            {dataIndex: 'DEPT_NAME'             , width: 100},
//            {dataIndex: 'BUDG_CODE'             , width: 170,
//                renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
//                    return (val.substring(0, 3) + '-' + val.substring(3, 7) + '-' + 
//                            val.substring(7, 11) + '-' + val.substring(11, 14) + '-' + 
//                            val.substring(14, 17) + '-' + val.substring(17, 19));
//                }
//            },
            {dataIndex: 'NAME2'           , width: 150},
            {dataIndex: 'NAME3'           , width: 150},
            {dataIndex: 'NAME4'           , width: 150},
            {dataIndex: 'NAME5'           , width: 150},
            {dataIndex: 'NAME6'           , width: 150}, 
            
            {dataIndex: 'YEAR_BUDGE'                     , width: 120},
            
            {dataIndex: 'BUDG_CONF_I'           , width: 120},
            {dataIndex: 'BUDG_ASGN_I'           , width: 120},
            {dataIndex: 'BUDG_TRANSFER_I'       , width: 120},
            
            {dataIndex: 'BUDG_IWALL_I'           , width: 120},
//            {dataIndex: 'IWALL_AMT_I'           , width: 120},
//            {dataIndex: 'CONF_AMT_I'            , width: 120},
//            {dataIndex: 'REQ_AMT'               , width: 120},
            {dataIndex: 'EX_AMT_I'              , width: 120},
            
            {dataIndex: 'ORDER_AMT'              , width: 120},
            
            {dataIndex: 'WON_BAL'                 , width: 120},
            {dataIndex: 'BUDG_TYPE'             , width: 100}
        ]
       /* listeners: {
            itemmouseenter:function(view, record, item, index, e, eOpts )   {               
                view.ownerGrid.setCellPointer(view, item);
            }
        },
        onItemcontextmenu:function( menu, grid, record, item, index, event  )   {               
            //menu.showAt(event.getXY());
            return true;
        },
        uniRowContextMenu:{
            items: [
                {   text: '예산집행상세내역조회 보기',   
                    handler: function(menuItem, event) {
                        var param = menuItem.up('menu');
                        masterGrid.gotoAfb555(param.record);
                    }
                }
            ]
        },
        gotoAfb555:function(record) {
            if(record)  {
                var params = {
                    action:'select',
                    'PGM_ID'            : 's_afb500skr_KOCIS',
                    'FR_YYYYMM'         : panelSearch.getValue('FR_YYYYMM'),
                    'TO_YYYYMM'         : panelSearch.getValue('TO_YYYYMM'),
                    'BUDG_CODE'         : record.data['BUDG_CODE'],
                    'BUDG_NAME'         : record.data['BUDG_NAME'],
                    'DEPT_CODE'         : record.data['DEPT_CODE'],
                    'DEPT_NAME'         : record.data['DEPT_NAME'],
                    'BUDG_TYPE'         : record.data['BUDG_TYPE'], 
                    'RDO'               : Ext.getCmp('RDO_SELECT').getChecked()[0].inputValue,
                    'MONEY_UNIT'        : panelSearch.getValue('MONEY_UNIT'),
                    'AC_PROJECT_CODE'   : panelSearch.getValue('AC_PROJECT_CODE'),
                    'AC_PROJECT_NAME'   : panelSearch.getValue('AC_PROJECT_NAME')
                }
                var rec1 = {data : {prgID : 'afb555skr', 'text':''}};                           
                parent.openTab(rec1, '/accnt/afb555skr.do', params);
            }
        }*/
    });
    
    Unilite.Main( {
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
        id : 'Afb500App',
        fnInitBinding : function() {
  
            UniAppManager.app.fnInitInputFields(); 
        },
        onQueryButtonDown : function()  {
            if(!panelResult.getInvalidMessage()) return;   //필수체크
            masterStore.loadStoreRecords();
        },
        processParams: function(params) {
            this.uniOpt.appParams = params;
            if(params.PGM_ID == 'afb510skr') {
                panelSearch.setValue('FR_YYYYMM',params.FR_YYYYMM);
                panelSearch.setValue('TO_YYYYMM',params.TO_YYYYMM);
                panelSearch.setValue('BUDG_CODE',params.BUDG_CODE);
                panelSearch.setValue('BUDG_NAME',params.BUDG_NAME);
                panelSearch.setValue('DEPT_CODE',params.DEPT_CODE);
                panelSearch.setValue('DEPT_NAME',params.DEPT_NAME);
                panelSearch.setValue('BUDG_TYPE',params.BUDG_TYPE);
                panelSearch.setValue('RDO',params.RDO);
                panelSearch.setValue('MONEY_UNIT',params.MONEY_UNIT);
                panelSearch.setValue('AC_PROJECT_CODE',params.AC_PROJECT_CODE);
                panelSearch.setValue('AC_PROJECT_NAME',params.AC_PROJECT_NAME);
                panelResult.setValue('FR_YYYYMM',params.FR_YYYYMM);
                panelResult.setValue('TO_YYYYMM',params.TO_YYYYMM);
                panelResult.setValue('BUDG_CODE',params.BUDG_CODE);
                panelResult.setValue('BUDG_NAME',params.BUDG_NAME);
                panelResult.setValue('DEPT_CODE',params.DEPT_CODE);
                panelResult.setValue('DEPT_NAME',params.DEPT_NAME);
                panelResult.setValue('BUDG_TYPE',params.BUDG_TYPE);
                panelResult.setValue('RDO',params.RDO);
                panelResult.setValue('MONEY_UNIT',params.MONEY_UNIT);
                panelResult.setValue('AC_PROJECT_CODE',params.AC_PROJECT_CODE);
                panelResult.setValue('AC_PROJECT_NAME',params.AC_PROJECT_NAME);
                
            }
            masterStore.loadStoreRecords();
        },
        fnInitInputFields: function(){
            var activeSForm ;
            if(!UserInfo.appOption.collapseLeftSearch)  {
                activeSForm = panelSearch;
            }else {
                activeSForm = panelResult;
            }
//            activeSForm.onLoadSelectText('FR_AC_DATE');
            
            panelSearch.setValue('AC_YEAR', UniDate.getDbDateStr(UniDate.today()).substring(0, 4));
            panelResult.setValue('AC_YEAR', UniDate.getDbDateStr(UniDate.today()).substring(0, 4));
            
            
            
//            panelSearch.setValue('FR_AC_DATE', UniDate.get('startOfMonth'));
//            panelSearch.setValue('TO_AC_DATE', UniDate.get('today'));
//            panelResult.setValue('FR_AC_DATE', UniDate.get('startOfMonth'));
//            panelResult.setValue('TO_AC_DATE', UniDate.get('today'));
            UniAppManager.setToolbarButtons('save',false);
            UniAppManager.setToolbarButtons('reset',true);
            
            panelSearch.setValue('DEPT_CODE',UserInfo.deptCode);
            panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
            
            if(!Ext.isEmpty(UserInfo.deptCode)){
                if(UserInfo.deptCode == '01'){
                    panelSearch.getField('DEPT_CODE').setReadOnly(false);
                    panelResult.getField('DEPT_CODE').setReadOnly(false);
                }else{
                    panelSearch.getField('DEPT_CODE').setReadOnly(true);
                    panelResult.getField('DEPT_CODE').setReadOnly(true);
                }
            }else{
                panelSearch.getField('DEPT_CODE').setReadOnly(true);
                panelResult.getField('DEPT_CODE').setReadOnly(true);
            }
        }
    });
};
</script>
