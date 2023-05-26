<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="log900skr"  >
<style type="text/css">
<t:ExtComboStore comboType="AU" comboCode="B611"/>    <!-- 배치구분    -->
<t:ExtComboStore comboType="AU" comboCode="B612"/>    <!-- 처리상태    -->


#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
</t:appConfig>
<script type="text/javascript" >


function appMain() {

    /**
     * ExtJS Direct Proxy
     * ServiceImpl.java 파일의 Method를 Call 함.
     * log900skrService 객체를 호출함.
     */
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read : 'log900skrService.selectList'                     // log900skrService 객체의 selectList 를 호출
        }
    });

    /**
     * Model 정의
     * @type
     */
    Unilite.defineModel('log900skrModel', {
        fields: [
            {name:'BATCH_NAME'           ,text: '배치명'          ,type: 'string'},
            {name:'START_TIME'           ,text: '시작'            ,type: 'string'},
            {name:'END_TIME'             ,text: '종료'            ,type: 'string'},
            {name:'STATUS_NAME'          ,text: '처리구분'        ,type: 'string'},
            {name:'BATCH_GUBUN'          ,text: '배치여부'        ,type: 'string'},
            {name:'CLIENT_IP'            ,text: '접속IP'          ,type: 'string'},
            {name:'RESULT_MSG'           ,text: '처리결과'        ,type: 'string'}
        ]
    });

    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directMasterStore1 = Unilite.createStore('log900skrMasterStore1',{
        model: 'log900skrModel',
        uniOpt : {
            isMaster: true,            // 상위 버튼 연결
            editable: false,           // 수정 모드 사용
            deletable:false,           // 삭제 가능 여부
            useNavi : false            // prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,            // 위에서 선언한 ExtJS Direct Proxy
        loadStoreRecords : function()    {
            var param= Ext.getCmp('searchForm').getValues();
            console.log( param );
            this.load({
                params : param
            });
        }
    });

    /**
     * 검색조건 (Search Panel)
     * @type
     */
    var panelSearch = Unilite.createSearchPanel('searchForm', {
        title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
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
            title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',
               itemId: 'search_panel1',
               layout: {type: 'uniTable', columns: 1},
               defaultType: 'uniTextfield',
            items : [{
                fieldLabel: '조회기간',
                xtype: 'uniDateRangefield',
                startFieldName: 'START_TIME',
                endFieldName: 'END_TIME',
                allowBlank:false,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelResult.setValue('START_TIME', newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelResult.setValue('END_TIME', newValue);
                    }
                }
            },{
                fieldLabel: '배치명',
                name: 'BATCH_ID',
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'B611',
                width:330,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('BATCH_ID', newValue);
                    }
                }
            },{
                fieldLabel: '처리상태',
                name: 'STATUS',
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'B612',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('STATUS', newValue);
                    }
                }
            }]
        }]
    });

    /**
     * 조회조건
     * @type
     */
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 3                   /*, tdAttrs: {style: 'border : 1px solid #ced9e7;'}*/},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
            fieldLabel: '조회기간',
            xtype: 'uniDateRangefield',
            startFieldName: 'START_TIME',
            endFieldName: 'END_TIME',
            allowBlank:false,
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                    panelSearch.setValue('START_TIME', newValue);
                }
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                    panelSearch.setValue('END_TIME', newValue);
                }
            }
        },{
            fieldLabel: '배치명',
            name: 'BATCH_ID',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'B611',
            width:350,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('BATCH_ID', newValue);
                }
            }
        },{
            fieldLabel: '처리상태',
            name: 'STATUS',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'B612',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('STATUS', newValue);
                }
            }
        }]
    });

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
    var masterGrid = Unilite.createGrid('log900skrGrid', {
        // for tab
        layout : 'fit',
        region:'center',
        store: directMasterStore1,
        uniOpt : {
            useMultipleSorting    : true,
            useLiveSearch        : false,
            onLoadSelectFirst    : false,
            dblClickToEdit        : false,
            useGroupSummary        : true,
            useContextMenu        : false,
            useRowNumberer        : true,
            expandLastColumn    : true,
            useRowContext        : false,    // rink 항목이 있을경우만 true
            filter: {
                useFilter    : false,
                autoCreate    : true
            }
        },
        selModel: 'rowmodel',
        features: [ {id : 'masterGridSubTotal'      , ftype: 'uniGroupingsummary'      , showSummaryRow: false },
                    {id : 'masterGridTotal'         , ftype: 'uniSummary'              , showSummaryRow: false} ],
        columns:  [
            { dataIndex: 'BATCH_NAME'               , width:200},
            {
                text:'조회기간',
                columns: [
                    { dataIndex: 'START_TIME'       , width:140            , align:'center'},
                    { dataIndex: 'END_TIME'         , width:140            , align:'center'}
                ]
            },
            { dataIndex: 'BATCH_GUBUN'              , width:80             , align:'center'},
            { dataIndex: 'STATUS_NAME'              , width:80             , align:'center'},
            { dataIndex: 'CLIENT_IP'                , width:120},
            { dataIndex: 'RESULT_MSG'               , width:350}
        ]
    });

    Unilite.Main( {
        borderItems:[{
                region: 'center',                  // Center
                layout: 'border',                  // border 스타일
                border: false,
                items:[
                    panelResult, masterGrid
                ]
            },
            panelSearch
        ],
        id  : 'log900skrApp',
        fnInitBinding : function() {
            // 검색조건을 Active, non Active 함.
            if(!UserInfo.appOption.collapseLeftSearch) {
                activeSForm = panelSearch;
            } else {
                activeSForm = panelResult;
            }
            activeSForm.onLoadSelectText('START_TIME');                     // 화면이 오픈되면 시작일자에 Focus
            UniAppManager.setToolbarButtons(['detail','save'],false);       // 버튼 활성화
            UniAppManager.setToolbarButtons('reset',true);                  // 버튼 활성화

            panelSearch.setValue('START_TIME' , UniDate.get('today'));      // 시작일 초기값
            panelSearch.setValue('END_TIME'   , UniDate.get('today'));      // 종료일 초기값
            panelResult.setValue('START_TIME' , UniDate.get('today'));      // 시작일 초기값
            panelResult.setValue('END_TIME'   , UniDate.get('today'));      // 종료일 초기값
        },
        onResetButtonDown: function() {                // Reset 버튼 이벤트
            panelSearch.clearForm();
            panelResult.clearForm();
            masterGrid.reset();
            directMasterStore1.clearData();
            this.fnInitBinding();
        },
        onQueryButtonDown : function() {               // 조회 버튼 이벤트
            if(!this.isValidSearchForm()){
                return false;
            }
            directMasterStore1.loadStoreRecords();
        }
    });
};
</script>
