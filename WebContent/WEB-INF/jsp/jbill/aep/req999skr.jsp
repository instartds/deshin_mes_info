<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="req999skr"  >
    

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>    
<script type="text/javascript" >

var htmlViewWindow;   //


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
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directSearchStore = Unilite.createStore('req999skrSearchStore', {
        model: 'req999skrSearchModel',
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결 
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
            	htmlStore.loadStoreRecords();
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
    var htmlView = Ext.create('Ext.view.View', {
        region:'south',
//        flex:1,
        tpl: '<tpl for=".">'+
             '<div class="data-source" ><div class="x-view-item-focused x-item-selected">' +                        
              '{html_document}</div></div>'+
              '</tpl>',
        itemSelector: 'div.data-source ',
        
        store: htmlStore
    });
    
    function openHtmlViewWindow() {          

        if(!htmlViewWindow) {
            htmlViewWindow = Ext.create('widget.uniDetailWindow', {
                title: 'HTML뷰',
                width: 1000,                                
                height: '100%',
                layout:{type:'vbox', align:'stretch'},
                items: [searchGrid2,htmlView],
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
            
        },
        onQueryButtonDown: function() {   
            directSearchStore.loadStoreRecords();   
            
        }
    });
   
};

</script>