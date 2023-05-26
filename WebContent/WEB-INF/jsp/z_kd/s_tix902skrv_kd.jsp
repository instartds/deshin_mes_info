<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_tix902skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  />             <!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
    var searchInfoWindow;  // 검색창

    /**
	 * Model 정의
	 *
	 * @type
	 */
    Unilite.defineModel('S_tix902skrv_kdModel', {  // 모델정의 - 디테일 그리드
        fields: [
            {name: 'DIV_CODE'       , text: '사업장'        , type: 'string', comboType:'BOR120'},
            {name: 'RETURN_NO'      , text: '환급번호'       , type: 'string'},
            {name: 'RETURN_DATE'    , text: '(작성)일자'     , type: 'uniDate'},
            {name: 'SEQ'            , text: '순서(순번)'     , type: 'string'},
            {name: 'ACCEPT_NO'      , text: '접수번호'       , type: 'string'},
            {name: 'BASIS_NO'       , text: '근거번호'       , type: 'string'},
            {name: 'TAKE_DATE'      , text: '양도일자'       , type: 'uniDate'},
            {name: 'TAKER_NAME'     , text: '양도자상호'      , type: 'string'},
            {name: 'COMPANY_NUM'    , text: '사업자번호'      , type: 'string'},
            {name: 'TAKE_QTY'       , text: '양도물량'       , type: 'string'},
            {name: 'STOCK_UNIT'     , text: '단위'          , type: 'string'},
            {name: 'FOB_AMT'        , text: 'FOB금액'       , type: 'uniPrice'},
            {name: 'TAKE_VAT'       , text: '양도세액'       , type: 'uniPrice'},
            {name: 'REMARK'     , text: '비고'          , type: 'string'}
        ]
    });

   /**
	 * Store 정의(Combobox)
	 *
	 * @type
	 */
    var directMasterStore1 = Unilite.createStore('s_tix902skrv_kdMasterStore1', {
        model: 'S_tix902skrv_kdModel',
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결
            editable: false,         // 수정 모드 사용
            deletable: false,        // 삭제 가능 여부
            useNavi: false          // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:{
            type: 'direct',
            api: {
                   read: 's_tix902skrv_kdService.selectList'
            }
        },
        loadStoreRecords: function(){
            var param= Ext.getCmp('searchForm').getValues();
            console.log(param);
            this.load({
                params: param
            });
        },
        groupField: 'RETURN_NO'
    });// End of var directMasterStore1

    /**
	 * 검색조건 (Search Panel)
	 *
	 * @type
	 */
    var panelSearch = Unilite.createSearchPanel('searchForm', {
        title: '검색조건',
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
            id: 'search_panel1',
            itemId: 'search_panel1',
            layout: {type: 'uniTable', columns: 1},
            defaultType: 'uniTextfield',
            items: [
            {
                fieldLabel: '사업장',
                name: 'DIV_CODE',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('DIV_CODE', newValue);
                    }
                }
            },
            Unilite.popup('RETURN_NUM', {
                    fieldLabel: '환급번호',
                    valueFieldName: 'RETURN_NO',
                    textFieldName: 'RETURN_NO',
                    holdable: 'hold',
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                panelResult.setValue('RETURN_NO', panelSearch.getValue('RETURN_NO'));
                                panelResult.setValue('DIV_CODE', panelSearch.getValue('DIV_CODE'));
                                panelResult.setValue('RETURN_DATE_FR', panelSearch.getValue('RETURN_DATE_FR'));
                                panelResult.setValue('RETURN_DATE_TO', panelSearch.getValue('RETURN_DATE_TO'));
                                panelResult.setValue('ENTRY_MAN', panelSearch.getValue('ENTRY_MAN'));
                                panelResult.setValue('REMARK', panelSearch.getValue('REMARK'));
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            panelResult.setValue('RETURN_NO', '');
                        },
                        applyextparam: function(popup){
                            popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                            popup.setExtParam({'RETURN_NO': panelSearch.getValue('RETURN_NO')});
                            popup.setExtParam({'RETURN_DATE_FR': panelSearch.getValue('RETURN_DATE_FR')});
                            popup.setExtParam({'RETURN_DATE_TO': panelSearch.getValue('RETURN_DATE_TO')});
                            popup.setExtParam({'ENTRY_MAN': panelSearch.getValue('ENTRY_MAN')});
                            popup.setExtParam({'REMARK': panelSearch.getValue('REMARK')});
                        }
                    }
            }),{
                fieldLabel: '(작성)일자',
                xtype: 'uniDateRangefield',
                startFieldName: 'RETURN_DATE_FR',
                endFieldName: 'RETURN_DATE_TO',
                allowBlank: false,
                padding: '2 0 1 0',
                startDate: new Date() ,
                endDate: new Date(),
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelResult) {
                            panelResult.setValue('RETURN_DATE_FR',newValue);
                        }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelResult) {
                            panelResult.setValue('RETURN_DATE_TO',newValue);
                        }
                }
            },{
                fieldLabel: '등록자',
                xtype: 'uniTextfield',
                name: 'ENTRY_MAN',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('ENTRY_MAN', newValue);
                    }
                }
            },{
                fieldLabel: '비고',
                xtype: 'textareafield',
                name: 'REMARK',
                textFieldWidth: 170,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('REMARK', newValue);
                    }
                }
            }

            ]
        }]
    });// End of var panelSearch

    /**
	 * 검색조건 (Search Result) - 상단조건
	 *
	 * @type
	 */
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [
        {
            fieldLabel: '사업장',
            name: 'DIV_CODE',
            xtype: 'uniCombobox',
            comboType: 'BOR120',
            allowBlank: false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('DIV_CODE', newValue);
                }
            }
        },
            Unilite.popup('RETURN_NUM', {
                    fieldLabel: '환급번호',
                    valueFieldName: 'RETURN_NO',
                    textFieldName: 'RETURN_NO',
                    holdable: 'hold',
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {

                                panelSearch.setValue('RETURN_NO', panelResult.getValue('RETURN_NO'));
                                panelSearch.setValue('DIV_CODE', panelResult.getValue('DIV_CODE'));
                                panelSearch.setValue('RETURN_DATE_FR', panelResult.getValue('RETURN_DATE_FR'));
                                panelSearch.setValue('RETURN_DATE_TO', panelResult.getValue('RETURN_DATE_TO'));
                                panelSearch.setValue('ENTRY_MAN', panelResult.getValue('ENTRY_MAN'));
                                panelSearch.setValue('REMARK', panelResult.getValue('REMARK'));

                            },
                            scope: this
                        },

                        applyextparam: function(popup){

                            popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                            popup.setExtParam({'RETURN_NO': panelResult.getValue('RETURN_NO')});
                            popup.setExtParam({'RETURN_DATE_FR': panelResult.getValue('RETURN_DATE_FR')});
                            popup.setExtParam({'RETURN_DATE_TO': panelResult.getValue('RETURN_DATE_TO')});
                            popup.setExtParam({'ENTRY_MAN': panelResult.getValue('ENTRY_MAN')});
                            popup.setExtParam({'REMARK': panelResult.getValue('REMARK')});
                        }
                    }
        }),{
            fieldLabel: '(작성)일자',
            xtype: 'uniDateRangefield',
            startFieldName: 'RETURN_DATE_FR',
            endFieldName: 'RETURN_DATE_TO',
            allowBlank: false,
            margin: '0 0 0 -246',
            width: 350,
            startDate: new Date() ,
            endDate: new Date(),
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelSearch) {
                    panelSearch.setValue('RETURN_DATE_FR',newValue);
                }
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelSearch) {
                    panelSearch.setValue('RETURN_DATE_TO',newValue);
                }
            }
        },{
            fieldLabel: '등록자',
            xtype: 'uniTextfield',
            name: 'ENTRY_MAN',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('ENTRY_MAN', newValue);
                }
            }
        },{
            fieldLabel: '비고',
            xtype: 'uniTextfield',
            name: 'REMARK',
            width: 500,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('REMARK', newValue);
                }
            }
        }
        ]
    });// End of var panelSearch

    /**
	 * Master Grid1 정의(Grid Panel)
	 *
	 * @type
	 */
    var masterGrid = Unilite.createGrid('s_tix902skrv_kdGrid1', {      // detail그리드
        layout: 'fit',
        region: 'center',
        uniOpt: {
            expandLastColumn: false,
            useRowNumberer: true,
            copiedRow: true,
			excel: {
				useExcel: true,			//엑셀 다운로드 사용 여부
				exportGroup : true, 		//group 상태로 export 여부
				onlyData:false,
				summaryExport:true
			}
        },
        features: [{
            id: 'masterGridSubTotal',
            ftype: 'uniGroupingsummary',
            showSummaryRow: false
        },{
            id: 'masterGridTotal',
            ftype: 'uniSummary',
            showSummaryRow: false
        }],
        store: directMasterStore1,
        columns: [
            {dataIndex: 'DIV_CODE'       , width: 120   , hidden: true},             // 사업장
            {dataIndex: 'RETURN_NO'      , width: 120},                              // 환급번호
            {dataIndex: 'SEQ'            , width: 80    , locked: false,
                    summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '합계', '총계');
            }},
            {dataIndex: 'RETURN_DATE'    , width: 120},                              // (작성)일자
            {dataIndex: 'ACCEPT_NO'      , width: 120},                              // 접수번호
            {dataIndex: 'BASIS_NO'       , width: 150},                              // 근거번호
            {dataIndex: 'TAKE_DATE'      , width: 100},                              // 양도일자
            {dataIndex: 'TAKER_NAME'     , width: 150},                              // 양수자상호
            {dataIndex: 'COMPANY_NUM'    , width: 100},                              // 사업자번호
            {dataIndex: 'TAKE_QTY'       , width: 100, align:'right',
            	renderer: function(value) {
                	return   Ext.util.Format.number(value, '0.00');
            }},                              // 양도물량
            {dataIndex: 'STOCK_UNIT'     , width: 80},                               // 단위
            {dataIndex: 'FOB_AMT'        , width: 120, summaryType: 'sum' },         // FOB금액
            {dataIndex: 'TAKE_VAT'       , width: 100, summaryType: 'sum' },          // 양도세액
            {dataIndex: 'REMARK'    , width: 100}
        ]
    });// End of var masterGrid

//
// // 검색창 폼 정의 - 메인조회 (큰돋보기)
// var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {
// layout: {type: 'uniTable', columns : 2},
// trackResetOnLoad: true,
// items: [{
// fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>' ,
// name: 'DIV_CODE',
// xtype:'uniCombobox',
// comboType:'BOR120',
// value:UserInfo.divCode,
// listeners: {
// change: function(combo, newValue, oldValue, eOpts) {
// }
// }
// },{
// fieldLabel: '(작성)일자',
// xtype: 'uniDateRangefield',
// startFieldName: 'RETURN_DATE_FR',
// endFieldName: 'RETURN_DATE_TO',
// margin: '0 0 0 -246',
// width: 350,
// startDate: new Date() ,
// endDate: new Date()
// },{
// xtype: 'uniTextfield',
// name: 'RETURN_NO',
// fieldLabel: '환급번호'
// },{
// xtype: 'uniTextfield',
// name: 'ENTRY_MAN',
// margin: '0 0 0 -246',
// fieldLabel: '등록자'
// },{
// xtype: 'uniTextfield',
// name: 'REMARK',
// width: 500,
// fieldLabel: '비고'
//
// }]
// });
//
// // 검색창 모델 정의
// Unilite.defineModel('orderNoMasterModel', { // 모델정의 - 메인 조회버튼 팝업 그리드
// fields: [
// {name: 'DIV_CODE' , text: '사업장' , type: 'string'},
// {name: 'RETURN_NO' , text: '환급번호' , type: 'string'},
// {name: 'RETURN_DATE' , text: '(작성)일자' , type: 'uniDate'},
// {name: 'ENTRY_MAN' , text: '등록자' , type: 'string'},
// {name: 'REMARK' , text: '비고' , type: 'string'}
// ]
// });
// // 검색창 스토어 정의
// var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {
// model: 'orderNoMasterModel',
// autoLoad: false,
// uniOpt : {
// isMaster: false, // 상위 버튼 연결여부
// editable: false, // 수정 모드 사용여부
// deletable:false, // 삭제 가능 여부
// useNavi : false // prev | newxt 버튼 사용여부
// },
// proxy: {
// type: 'direct',
// api: {
// read : 's_tix902skrv_kdService.selectOrderNumMasterList'
// }
// }
// ,loadStoreRecords : function() {
// var param= orderNoSearch.getValues();
// console.log( param );
// this.load({
// params : param
// });
// }
// });
// // 검색창 그리드 정의
// var orderNoMasterGrid = Unilite.createGrid('s_tix902skrvOrderNoMasterGrid', {
// // title: '기본',
// layout : 'fit',
// store: orderNoMasterStore,
// uniOpt:{
// useRowNumberer: false
// },
// columns: [{ dataIndex: 'DIV_CODE' , width: 100 },
// { dataIndex: 'RETURN_NO' , width: 120 },
// { dataIndex: 'RETURN_DATE' , width: 100 },
// { dataIndex: 'ENTRY_MAN' , width: 150 },
// { dataIndex: 'REMARK' , width: 110 },
// { dataIndex: 'MONEY_UNIT' , width: 110 , hidden: true},
// { dataIndex: 'EXCHG_RATE_O' , width: 110 , hidden: true}
// ] ,
// listeners: {
// onGridDblClick: function(grid, record, cellIndex, colName) {
// orderNoMasterGrid.returnData(record);
// UniAppManager.app.onQueryButtonDown();
// searchInfoWindow.hide();
// }
// }
// ,returnData: function(record) {
// if(Ext.isEmpty(record)) {
// record = this.getSelectedRecord();
// }
//
// panelResult.setValue('DIV_CODE', record.get('DIV_CODE'));
// panelResult.setValue('RETURN_NO', record.get('RETURN_NO'));
// panelResult.setValue('RETURN_DATE', record.get('RETURN_DATE'));
// panelResult.setValue('ENTRY_MAN', record.get('ENTRY_MAN'));
// panelResult.setValue('REMARK', record.get('REMARK'));
//
// panelSearch.setValue('DIV_CODE', record.get('DIV_CODE'));
// panelSearch.setValue('RETURN_NO', record.get('RETURN_NO'));
// panelSearch.setValue('RETURN_DATE', record.get('RETURN_DATE'));
// panelSearch.setValue('ENTRY_MAN', record.get('ENTRY_MAN'));
// panelSearch.setValue('REMARK', record.get('REMARK'));
//
// }
//
// });
//
// // openSearchInfoWindow
// // 검색창 메인
// function openSearchInfoWindow() { // 환급번호 더블클릭시 창을 띄우는 함수
// if(!searchInfoWindow) {
// searchInfoWindow = Ext.create('widget.uniDetailWindow', {
// title: '환급번호검색',
// width: 830,
// height: 580,
// layout: {type:'vbox', align:'stretch'},
// items: [orderNoSearch, orderNoMasterGrid],
// tbar: [
// { itemId : 'searchBtn',
// text: '조회',
// handler: function() {
// orderNoMasterStore.loadStoreRecords();
// },
// disabled: false
// }, '->',{
// itemId : 'closeBtn',
// text: '닫기',
// handler: function() {
// searchInfoWindow.hide();
// },
// disabled: false
// }
// ],
// listeners : {beforehide: function(me, eOpt) {
// orderNoSearch.clearForm();
// orderNoMasterGrid.reset();
// },
// beforeclose: function( panel, eOpts ) {
// orderNoSearch.clearForm();
// orderNoMasterGrid.reset();
// },
// show: function( panel, eOpts ) {
// orderNoSearch.setValue('DIV_CODE',panelSearch.getValue('DIV_CODE'));
// orderNoSearch.setValue('ENTRY_MAN',panelSearch.getValue('ENTRY_MAN'));
// orderNoSearch.setValue('REMARK',panelSearch.getValue('REMARK'));
// orderNoSearch.setValue('RETURN_DATE_TO',
// panelSearch.getValue('RETURN_DATE_TO'));
// orderNoSearch.setValue('RETURN_DATE_FR',
// panelSearch.getValue('RETURN_DATE_FR'));
// }
// }
// })
// }
// searchInfoWindow.center();
// searchInfoWindow.show();
// }
//
    Unilite.Main( {
        border: false,
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
        id: 's_tix902skrv_kdApp',
        fnInitBinding: function() {
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelSearch.setValue('RETURN_NO', '');
            panelSearch.setValue('ENTRY_MAN', '');
            panelSearch.setValue('REMARK', '');
            panelSearch.setValue('RETURN_DATE_TO', UniDate.get('today'));
            panelSearch.setValue('RETURN_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('RETURN_DATE_TO')));

            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('RETURN_NO', '');
            panelResult.setValue('ENTRY_MAN', '');
            panelResult.setValue('REMARK', '');
            panelResult.setValue('RETURN_DATE_TO', UniDate.get('today'));
            panelResult.setValue('RETURN_DATE_FR', UniDate.get('startOfMonth', panelResult.getValue('RETURN_DATE_TO')));

            UniAppManager.setToolbarButtons(['reset'], false);

            var activeSForm ;
            if(!UserInfo.appOption.collapseLeftSearch)  {
                activeSForm = panelSearch;
            }else {
                activeSForm = panelResult;
            }
            activeSForm.onLoadSelectText('DIV_CODE');
        },
        onQueryButtonDown: function() { // 조회
            var reportNo = panelSearch.getValue('RETURN_NO');
            var detailform = panelSearch.getForm();
            if (detailform.isValid()) {
                masterGrid.getStore().loadStoreRecords(); // 메인조회
                UniAppManager.setToolbarButtons('reset', true);
            }

            var viewLocked = masterGrid.getView();
            var viewNormal = masterGrid.getView();
            viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
            viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
            viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
            viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
        },
        onResetButtonDown : function() { // 초기화
            panelSearch.clearForm();
            panelResult.clearForm();
            masterGrid.getStore().loadData({});
            this.fnInitBinding();
        }
    });

};

</script>
