<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="req999skrTestRequest"  >
    

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>    
<script type="text/javascript" >

var htmlViewWindow;   //



var ReceiveValue = "";
 
var url = unescape(location.href);
var values  = url.split('?');
var params   = values[1].split('&');
    for( var i=0; i<params.length; i++ ){
        var param = params[i].split('=');
    ReceiveValue = param[1];
    }


function appMain() {
	
    var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
             read : req999skrService.getHtml
        }
    });
    
    /**
     *   Model 정의 
     * @type 
     */

    Unilite.defineModel('req999skrSearchModel', {
        fields: [
            {name: 'TEST1'           , text: '증빙'            , type: 'string'},
            {name: 'TEST2'          , text: '회계일자'          , type: 'uniDate'},
            {name: 'TEST3'          , text: '증빙일자'          , type: 'uniDate'},
            {name: 'TEST4'          , text: '전표번호'          , type: 'string'},
            {name: 'TEST5'          , text: '귀속부서'          , type: 'string'},
            {name: 'TEST6'          , text: '작성부서'          , type: 'string'},
            {name: 'TEST7'          , text: '작성자'           , type: 'string'},
            {name: 'TEST8'          , text: '문서유형'          , type: 'string'},
            {name: 'TEST9'          , text: '거래처'           , type: 'string'},
            {name: 'TEST10'         , text: '업종'            , type: 'string'},
            {name: 'TEST11'         , text: '계정과목'          , type: 'string'},
            {name: 'TEST12'         , text: '공급가액'          , type: 'uniPrice'},
            {name: 'TEST13'         , text: '부가세액'          , type: 'uniPrice'},
            {name: 'TEST14'         , text: '총금액'           , type: 'uniPrice'},
            {name: 'TEST15'         , text: '사용내역'          , type: 'string'},
            {name: 'TEST16'         , text: '세무'            , type: 'string'},
            {name: 'TEST17'         , text: '법인카드과세유형'  , type: 'string'},
            {name: 'TEST18'         , text: '처리상태'          , type: 'string'},
            {name: 'TEST19'         , text: '카드승인일'     , type: 'uniDate'},
            {name: 'TEST20'         , text: '카드승인사'     , type: 'string'},
            {name: 'TEST21'         , text: '파일명'           , type: 'string'},
            {name: 'TEST22'         , text: '카드소유자'     , type: 'string'},
            {name: 'TEST23'         , text: '가맹점주소'     , type: 'string'}
        ]
    });
    Unilite.defineModel('tModel2', {
        fields: [
             {name: 'html_document'             ,text:'html'        ,type : 'string'} 
                    
        ]
    });
    Unilite.defineModel('req999skrSubModel1', {
        fields: [
            {name: 't1'                ,text: 'No.'       ,type: 'string'},
            {name: 't2'                ,text: '구분'       ,type: 'string'},
            {name: 't3'                ,text: '결재자'      ,type: 'string'},
            {name: 't4'                ,text: '부서'       ,type: 'string'},
            {name: 't5'                ,text: '결재여부'     ,type: 'string'},
            {name: 't6'                ,text: '결재일시'     ,type: 'string'},
            {name: 't7'                ,text: '의견'        ,type: 'string'}
        ]
    });
    Unilite.defineModel('req999skrSubModel2', {
        fields: [
            {name: 't11'                ,text: 'No.'       ,type: 'string'},
            {name: 't22'                ,text: '구분'       ,type: 'string'},
            {name: 't33'                ,text: '결재자'      ,type: 'string'},
            {name: 't44'                ,text: '부서'       ,type: 'string'},
            {name: 't55'                ,text: '결재여부'     ,type: 'string'},
            {name: 't66'                ,text: '결재일시'     ,type: 'string'},
            {name: 't77'                ,text: '의견'        ,type: 'string'}
        ]
    });
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directSearchStore = Unilite.createStore('req999skrSearchStore', {
        model: 'req999skrSearchModel',
        uniOpt: {
            isMaster: false,         // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            allDeletable:false,
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
                read: 'req999skrService.selectSearchList'                 
            }
        },
        
        listeners: {
            load: function(store, records, successful, eOpts) {
            },
            add: function(store, records, index, eOpts) {
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {
            },
            remove: function(store, record, index, isMove, eOpts) {
            }
        },
        loadStoreRecords: function(){
            var param= {};
//            console.log( param );
            this.load({
//                params: param
            });
        }
    }); 
    var directSubStore1 = Unilite.createStore('req999skrSubStore1', {
        model: 'req999skrSubModel1',
        uniOpt: {
            isMaster: false,         // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            allDeletable:false,
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
                read: 'req999skrService.selectSubList1'                 
            }
        },
        
        listeners: {
            load: function(store, records, successful, eOpts) {
            },
            add: function(store, records, index, eOpts) {
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {
            },
            remove: function(store, record, index, isMove, eOpts) {
            }
        },
        loadStoreRecords: function(){
            var param= [];
            console.log( param );
            this.load({
                params: param
            });
        }
    }); 
    var directSubStore2 = Unilite.createStore('req999skrSubStore2', {
        model: 'req999skrSubModel2',
        uniOpt: {
            isMaster: false,         // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            allDeletable:false,
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
                read: 'req999skrService.selectSubList2'                 
            }
        },
        
        listeners: {
            load: function(store, records, successful, eOpts) {
            },
            add: function(store, records, index, eOpts) {
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {
            },
            remove: function(store, record, index, isMove, eOpts) {
            }
        },
        loadStoreRecords: function(){
            var param= [];
            console.log( param );
            this.load({
                params: param
            });
        }
    }); 
    var htmlStore =  Unilite.createStore('tStore',{
        model: 'tModel2',
         autoLoad: true ,
            uniOpt : {
                isMaster: false,            // 상위 버튼 연결 
                editable: false,            // 수정 모드 사용 
                deletable:false,            // 삭제 가능 여부 
                useNavi : false         // prev | next 버튼 사용
            },
            proxy: directProxy2,
            loadStoreRecords: function()    {
                var param= {};
                this.load({params: param});
            }
        });
    
   
    var searchGrid = Unilite.createGrid('req999skrSearchGrid', {
//      split:true,
        layout: 'fit',
        region: 'center',
        excelTitle: '',
//        height:250,
        uniOpt: {
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: false,
            useMultipleSorting: true,
            onLoadSelectFirst: true,
            useRowNumberer: false,
            expandLastColumn: false,
            useRowContext: false,
            state: {
                useState: true,         
                useStateList: true      
            }
        },
        features: [{
            id: 'detailGridSubTotal', 
            ftype: 'uniGroupingsummary', 
            showSummaryRow: false
        },{
            id: 'detailGridTotal', 
            ftype: 'uniSummary', 
            showSummaryRow: false
        }],
        tbar:[{
           xtype:'uniTextfield',
           fieldLabel:'받은 value',
           id:'receiveField',
           readOnly:true
//           name : 'receiveField'
        }],
        store: directSearchStore,
     /*   selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true,
            listeners: {  
                select: function(grid, selectRecord, index, rowIndex, eOpts ){
//                    if(selectRecord.get('CONFIRM_YN') == 'N'){
//                        selectRecord.set('SEND_J_AMT_I',selectRecord.get('JAN_AMT_I'));
//                    }
//                    
//                    selectRecord.set('CHECK_VALUE','Y');
////                  if(selectRecord.get('CONFIRM_YN') == 'N'){
////                      selectRecord.set('CONFIRM_YN','Y');
////                      
////                  }else if(selectRecord.get('CONFIRM_YN') == 'Y'){
////                      selectRecord.set('CONFIRM_YN','N');
////                  }
                },
                deselect:  function(grid, selectRecord, index, eOpts ){
//                    if(selectRecord.get('CONFIRM_YN') == 'N'){
//                        selectRecord.set('SEND_J_AMT_I',selectRecord.get('SEND_J_AMT_I_DUMMY'));
//                    }
//                    
//                    selectRecord.set('CHECK_VALUE','');
//                    
////                  selectRecord.set('CONFIRM_YN',selectRecord.get('CONFIRM_YN_DUMMY'));
                }
            }
        }),*/
        
        selModel:'rowmodel',
        columns: [
          {dataIndex: 'TEST1',          width: 66},
            {dataIndex: 'TEST2',            width: 88},
            {dataIndex: 'TEST3',            width: 88},
            {dataIndex: 'TEST4',            width: 100},
            {dataIndex: 'TEST5',            width: 130},
            {dataIndex: 'TEST6',            width: 130},
            {dataIndex: 'TEST7',            width: 150},
            {dataIndex: 'TEST8',            width: 100},
            {dataIndex: 'TEST9',            width: 150},
            {dataIndex: 'TEST10',           width: 100},
            {dataIndex: 'TEST11',           width: 150},
            {dataIndex: 'TEST12',           width: 100},
            {dataIndex: 'TEST13',           width: 100},
            {dataIndex: 'TEST14',           width: 100},
            {dataIndex: 'TEST15',           width: 300},
            {dataIndex: 'TEST16',           width: 100},
            {dataIndex: 'TEST17',           width: 150},
            {dataIndex: 'TEST18',           width: 100},
            {dataIndex: 'TEST19',           width: 88},
            {dataIndex: 'TEST20',           width: 100},
            {dataIndex: 'TEST21',           width: 100},
            {dataIndex: 'TEST22',           width: 100},
            {dataIndex: 'TEST23',           width: 250}
        ],
        listeners: { 
            beforeselect: function(rowSelection, record, index, eOpts) {
            },
            
            selectionchangerecord:function(selected)    {
            },
            onGridDblClick: function(grid, record, cellIndex, colName) {
            	directSubStore1.loadStoreRecords();
                directSubStore2.loadStoreRecords();
            	htmlStore.loadStoreRecords();
            	Ext.getCmp('subTitleNo').update('No. AP2016091900000189');
            	openHtmlViewWindow();
            	
                /*var params = {
                    action: 'new',
                    DIV_CODE : masterForm.getValue('DIV_CODE'),
                    FR_DATE : panelResult.getValue('FR_DATE'),
                    TO_DATE : panelResult.getValue('TO_DATE'),
                    CUSTOM_CODE : record.get('CUSTOM_CODE'),
                    CUSTOM_NAME : record.get('CUSTOM_NAME')
                }
                var rec = {data : {prgID : 'aep120ukr'}};                          
                    parent.openTab(rec, '/jbill/aep120ukr.do', params); */ 
            }
        }
    });   
 /*   var htmlView = Ext.create('Ext.view.View', {
        region:'south',
        flex:1,
        tpl: '<tpl for=".">'+
             '<div class="data-source" ><div class="x-view-item-focused x-item-selected">' +                        
              '{html_document}</div></div>'+
              '</tpl>',
        itemSelector: 'div.data-source ',
        
        store: htmlStore
    });
*/
    var searchGrid2 = Unilite.createGrid('req999skrSearchGrid2', {
//      split:true,
        layout: 'fit',
        region: 'center',
        excelTitle: '',
//        height:250,
        uniOpt: {
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: false,
            useMultipleSorting: true,
            onLoadSelectFirst: true,
            useRowNumberer: false,
            expandLastColumn: false,
            useRowContext: false,
            state: {
                useState: true,         
                useStateList: true      
            }
        },
        features: [{
            id: 'detailGridSubTotal', 
            ftype: 'uniGroupingsummary', 
            showSummaryRow: false
        },{
            id: 'detailGridTotal', 
            ftype: 'uniSummary', 
            showSummaryRow: false
        }],
        store: directSearchStore,
     /*   selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true,
            listeners: {  
                select: function(grid, selectRecord, index, rowIndex, eOpts ){
//                    if(selectRecord.get('CONFIRM_YN') == 'N'){
//                        selectRecord.set('SEND_J_AMT_I',selectRecord.get('JAN_AMT_I'));
//                    }
//                    
//                    selectRecord.set('CHECK_VALUE','Y');
////                  if(selectRecord.get('CONFIRM_YN') == 'N'){
////                      selectRecord.set('CONFIRM_YN','Y');
////                      
////                  }else if(selectRecord.get('CONFIRM_YN') == 'Y'){
////                      selectRecord.set('CONFIRM_YN','N');
////                  }
                },
                deselect:  function(grid, selectRecord, index, eOpts ){
//                    if(selectRecord.get('CONFIRM_YN') == 'N'){
//                        selectRecord.set('SEND_J_AMT_I',selectRecord.get('SEND_J_AMT_I_DUMMY'));
//                    }
//                    
//                    selectRecord.set('CHECK_VALUE','');
//                    
////                  selectRecord.set('CONFIRM_YN',selectRecord.get('CONFIRM_YN_DUMMY'));
                }
            }
        }),*/
        
        selModel:'rowmodel',
        columns: [
          {dataIndex: 'TEST1',          width: 66},
            {dataIndex: 'TEST2',            width: 88},
            {dataIndex: 'TEST3',            width: 88},
            {dataIndex: 'TEST4',            width: 100},
            {dataIndex: 'TEST5',            width: 130},
            {dataIndex: 'TEST6',            width: 130},
            {dataIndex: 'TEST7',            width: 150},
            {dataIndex: 'TEST8',            width: 100},
            {dataIndex: 'TEST9',            width: 150},
            {dataIndex: 'TEST10',           width: 100},
            {dataIndex: 'TEST11',           width: 150},
            {dataIndex: 'TEST12',           width: 100},
            {dataIndex: 'TEST13',           width: 100},
            {dataIndex: 'TEST14',           width: 100},
            {dataIndex: 'TEST15',           width: 300},
            {dataIndex: 'TEST16',           width: 100},
            {dataIndex: 'TEST17',           width: 150},
            {dataIndex: 'TEST18',           width: 100},
            {dataIndex: 'TEST19',           width: 88},
            {dataIndex: 'TEST20',           width: 100},
            {dataIndex: 'TEST21',           width: 100},
            {dataIndex: 'TEST22',           width: 100},
            {dataIndex: 'TEST23',           width: 250}
        ],
        listeners: { 
            beforeselect: function(rowSelection, record, index, eOpts) {
            },
            
            selectionchangerecord:function(selected)    {
            },
            onGridDblClick: function(grid, record, cellIndex, colName) {
//                htmlStore.loadStoreRecords();
//                openHtmlViewWindow();
                
                /*var params = {
                    action: 'new',
                    DIV_CODE : masterForm.getValue('DIV_CODE'),
                    FR_DATE : panelResult.getValue('FR_DATE'),
                    TO_DATE : panelResult.getValue('TO_DATE'),
                    CUSTOM_CODE : record.get('CUSTOM_CODE'),
                    CUSTOM_NAME : record.get('CUSTOM_NAME')
                }
                var rec = {data : {prgID : 'aep120ukr'}};                          
                    parent.openTab(rec, '/jbill/aep120ukr.do', params); */ 
            }
        }
    });   
    var subViewForm1 = Unilite.createSimpleForm('subViewForm1',{
        region: 'north',
        
        layout : {type : 'uniTable', columns : 2,
//        tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'},
         tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/width: '100%'/*,align : 'left'*/}
        },
        border:false,
        items: [{
            xtype:'component',
//                padding:'5 5 5 5',
            margin:'0 0 0 10',
            html:'결재문서내역',
            componentCls : 'component-text_title_first',
            tdAttrs: {align : 'left'}
        },{
            xtype:'component',
            id:'subTitleNo',
            padding:'5 5 0 5',
            html:null,
            componentCls : 'component-text_title_second',
            tdAttrs: {align : 'right'},
            width:200
        }]
        
    }); 
    var subViewForm2 = Unilite.createSimpleForm('subViewForm2',{
        region: 'center',
        padding:'0 0 0 0',
        margin: '0 0 0 0',
        layout : {type : 'uniTable', columns : 1
//        tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'},
//         tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/width: '100%'/*,align : 'left'*/}
        },
//        height:300,
        border:false,
        
//      split:true,
        items: [{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            border:true,
            padding:'0 1 1 1',
            items:[{
                title: '',
                xtype: 'fieldset',
                id: 'fieldset1',
                padding: '10 5 5 5',
                margin: '0 0 0 0',
                width: 705,  
                defaults: {readOnly: true, xtype: 'uniTextfield'},
                layout: {type: 'uniTable' , columns: 2},
                items: [{
                    fieldLabel:'시스템구분',
                    value:'전자전표',
                    width:320
    //                readOnly:true
                   /* style: {
                        borderColor: 'red',
                        borderStyle: 'solid'
                    }*/
                },{
                    fieldLabel:'문서유형',
                    value:'법인카드전표',
                    width:320
                },{
                    fieldLabel:'작성자',
                    value:'김종욱',
                    width:320
                },{
                    fieldLabel:'작성일자',
                    value:'2016-09-19 10:14:36',
                    width:320
                },{
                    fieldLabel:'제목',
                    value:'09월_재무팀_여비교통비_시내교통비1111111',
                    width:320
                },{
                    fieldLabel:'SAP 전표',
                    value:'8000117883',
                    width:320
                },{
                    xtype: 'container',
                    layout: {type : 'uniTable', columns : 1},
                    colspan:2,
                    items:[{
                        xtype: 'grid',
                        width:693,
                        id:'subGrid1',
                        store: directSubStore1,
                        columns: [
                            { dataIndex: 't1' ,text: 'No.'       ,type: 'string'         ,width:40,align:'center'},
                            { dataIndex: 't2' ,text: '구분'       ,type: 'string'         ,width:60,align:'center'},
                            { dataIndex: 't3' ,text: '결재자'      ,type: 'string'         ,width:100,align:'center'},
                            { dataIndex: 't4' ,text: '부서'       ,type: 'string'         ,width:120, style: 'text-align:center', align:'left'},
                            { dataIndex: 't5' ,text: '결재여부'     ,type: 'string'         ,width:100,align:'center'},
                            { dataIndex: 't6' ,text: '결재일시'     ,type: 'string'         ,width:110,align:'center'},
                            { dataIndex: 't7' ,text: '의견'       ,type: 'string'         ,width:160,align:'center'}
                        
                        ]
                    }]
                },{
                    xtype: 'container',
                    layout: {type : 'uniTable', columns : 1},
                    colspan:2,
                    items:[{
                        xtype: 'grid',
                        width:693,
                        id:'subGrid2',
                        store: directSubStore2,
                        columns: [
                            { dataIndex: 't11' ,text: 'No.'       ,type: 'string'          ,width:40,align:'center'},    
                            { dataIndex: 't22' ,text: '구분'       ,type: 'string'        ,width:60,align:'center'},     
                            { dataIndex: 't33' ,text: '결재자'      ,type: 'string'       ,width:100,align:'center'},    
                            { dataIndex: 't44' ,text: '부서'       ,type: 'string'        ,width:120,style: 'text-align:center', align:'left'},      
                            { dataIndex: 't55' ,text: '결재여부'     ,type: 'string'      ,width:100,align:'center'},    
                            { dataIndex: 't66' ,text: '결재일시'     ,type: 'string'      ,width:110,align:'center'},    
                            { dataIndex: 't77' ,text: '의견'       ,type: 'string'        ,width:160,align:'center'}     
                        
                        ]     
                    }]
                }]
            }]
        }]
        
    }); 
    var htmlView = Ext.create('Ext.view.View', {
        region:'south',
//        flex:1,
        /*tpl: '<tpl for=".">'+
             '<div class="data-source" ><div class="x-view-item-focused x-item-selected">' +                        
              '{html_document}</div></div>'+
              '</tpl>',
        itemSelector: 'div.data-source ',*/
         tpl: '<tpl for=".">'+
             '<span class="data-source" ><div class="x-view-item-focused x-item-selected">' +                        
              '{html_document}</div></span>'+
              '</tpl>',
        itemSelector: 'div.data-source ',
        store: htmlStore
    });
    
     function openHtmlViewWindow() {          

        if(!htmlViewWindow) {
            htmlViewWindow = Ext.create('widget.uniDetailWindow', {
                title: '전자결재 - 결재 문서 VIEW',
//                width: 735,
                width: 730,  
                minWidth:730,
                maxWidth:730,
//                layout: 'fit',
                height: '100%',
                autoScroll:true,
                padding: '1 1 1 1',
//                layout : {type : 'uniTable', columns : 1
//                    tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'},
//         tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/width: '100%'/*,align : 'left'*/}
                
//                },
                layout:{type:'vbox', align:'stretch'},
//                ,,
                items: [subViewForm1,subViewForm2,htmlView],
                tbar:  [
                    '->',{
                        itemId : 'closeBtn',
                        text: '닫기',
                        handler: function() {
                            htmlViewWindow.hide();
//                          draftNoGrid.reset();
//                          draftNoSearch.clearForm();
                        },
                        disabled: false
                    }
                ],
                listeners : {
                    beforehide: function(me, eOpt)  {
                    },
                    beforeclose: function( panel, eOpts )   {
                    },
                    show: function ( panel, eOpts ) {
                    }
                }
            })
        }
        htmlViewWindow.center();
        htmlViewWindow.show();
    }
    
    

    
    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout : 'border',
            border: false,
            items:[
                searchGrid
            ]
        }], 
        id  : 'req999skrApp',
        fnInitBinding: function(params){
            UniAppManager.setToolbarButtons(['save','reset'], false);
            
            
            Ext.getCmp('receiveField').setValue(ReceiveValue);
            
            this.onQueryButtonDown();
            
        },
        onQueryButtonDown: function() {   
            directSearchStore.loadStoreRecords();   
            
        }
    });
   
};

</script>