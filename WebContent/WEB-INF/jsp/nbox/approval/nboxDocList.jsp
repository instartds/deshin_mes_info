<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="${PRGID}" >
</t:appConfig>
<script type="text/javascript" >

function appMain() {
 /**************************************************
 * Require
 **************************************************/
     Ext.require([
                  'Ext.ux.PreviewPlugin' , 
                  'Ext.ux.Printer' ,
                  'Ext.LoadMask'  
              ]);
/**************************************************
 * Common variable
 **************************************************/
    var console = window.console;
/**************************************************
 * Common Code
 **************************************************/
//Combobox
    Ext.define('nbox.myCabinetMenuStore', {
        extend: 'Ext.data.Store',
        fields: ["pgmID", 'pgmName'],
        autoLoad: true,
        proxy: {
            type: 'direct',
            extraParams: {'MENUID': '${PRGID}'},
            api: { read: 'nboxDocCommonService.selectMyCabinetItem' },
            reader: {
                type: 'json',
                root: 'records'
            }
        }
    });  
    
    Ext.define('nbox.cabinetMenuStore', {
    	extend: 'Ext.data.Store',
    	fields: ["pgmID", 'pgmName'],
        autoLoad: true,
        proxy: {
            type: 'direct',
            extraParams: {'MENUID': '${PRGID}'},
            api: { read: 'nboxDocCommonService.selectCabinetItem' },
            reader: {
                type: 'json',
                root: 'records'
            }
        }
    });     
    
    
    Ext.define('nbox.divCodeStore', {
        extend: 'Ext.data.Store',
        fields: ["divCode", 'divName'],
        autoLoad: true,
        proxy: {
            type: 'direct',
            api: { read: 'nboxDocCommonService.selectDivCodeItem' },
            reader: {
                type: 'json',
                root: 'records'
            }
        }
    });
    
/**************************************************
 * Model
 **************************************************/
//Master Grid   
    Ext.define('nbox.masterGridModel', {
        extend: 'Ext.data.Model',
        fields: [
            {name: 'DocumentID'}, 
            {name: 'FileAttachFlag', type: 'int'},
            {name: 'DocumentNo'}, 
            {name: 'Subject'},
            {name: 'Status'},
            {name: 'RcvTypeName'},
            {name: 'ReadDate', type: 'date', dateFormat:'Y-m-d H:i:s'},
            {name: 'InsertDate', type: 'date', dateFormat:'Y-m-d H:i:s'},
            {name: 'EndDate', type: 'date', dateFormat:'Y-m-d H:i:s'},
            {name: 'DraftDate', type: 'date', dateFormat:'Y-m-d H:i:s'},
            {name: 'DraftUserID'},
            {name: 'DraftUserName'},
            {name: 'RcvUserName'},
            {name: 'ClosingFlag'}
        ]
    });
    
/**************************************************
 * Store
 **************************************************/
    Ext.define('nbox.extraUserInfoStroe', {
        extend: 'Ext.data.Store',
        fields: ["posName", 'emailAddr', 'gradeLevel' ],
        
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: { read: 'nboxCommonService.selectUserInfo' },
            reader: {
                type: 'json',
                root: 'records'
            }
        }
    });      
    
    //Master Grid   
    Ext.define('nbox.masterGridStore', {
    	extend: 'Ext.data.Store',
        model: 'nbox.masterGridModel',
        autoLoad: true,
        proxy: {
            type: 'direct',
            api: { read: 'nboxDocListService.selects' },
            reader: {
                type: 'json',
                root: 'records'
            }
        },
        listeners: {
            beforeload: function(store, operation, eOpts) {
                var me = this;
                var proxy = me.getProxy();
                
                proxy.setExtraParam('MENUID', '${PRGID}');
                proxy.setExtraParam('BOX', '${BOX}');
            }
        },
        initPage: function(currentPage, pageSize) {
            var me = this;

            me.currentPage = currentPage;
            me.pageSize = pageSize;
        }
    });
    
/**************************************************
 * Include
 **************************************************/

    
/**************************************************
 * Define
 **************************************************/
//Master Grid
    Ext.define('nbox.masterGrid', {
        extend: 'Ext.grid.Panel',
        
        config: {
            regItems: {}
        },
        
        viewConfig:{
           loadMask:true,
           loadingText: 'loading...'
        },
            
        flex:1,
        border: false,  
        
        selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly : true, toggleOnClick:false}),
        
        initComponent: function () {
            var me = this;

            me.columns= [
                {
                    text: '<img src="' + NBOX_IMAGE_PATH + 'Attach.gif" width=13 height=13/>',  
                    sortable: false,
                    dataIndex: 'FileAttachFlag',
                    groupable: false,
                    align : 'center',
                    width: 30,
                    renderer: function(value){
                        if(value==1)
                            return imgpath = '<img src="' + NBOX_IMAGE_PATH + 'Attach.gif" width=13 height=13/>';
                    }            
                }, 
                {
                    text: '문서번호',
                    sortable: true,
                    dataIndex: 'DocumentNo',
                    groupable: false,
                    width: 250
                }, 
                {
                    text: '제목',
                    sortable: true,
                    dataIndex: 'Subject',
                    groupable: false,
                    flex:1,
                    renderer : function(value, metadata) {
                    	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
                    	var docBox = null;
                    	if (nboxBaseApp)
                    		   docBox = nboxBaseApp.getDocBox();
                    	
                        var documentID = metadata.record.data.DocumentID;
                        
                        if (value.substring(0,1) == '0') 
                            value = '<b>' + value.substring(1) + '</b>';
                        else
                            value = value.substring(1) ;
                        
                        var pgmId = 'nboxdocdetail';
                        var text = '';                           
                        
                        return "<a onclick=\"return openTab_a(\'" + pgmId + "\',\'" + documentID  + "\',\'" + docBox  + "\',\'" + text  + "\',\'/nbox/nboxdocdetail.do\');\">" + value + "</a>"
                    }
                }, 
                {   
                    text: '상태',
                    sortable: true,
                    dataIndex: 'Status',
                    align: 'center',
                    groupable: false,
                    width: 100
                }, 
                {
                    text: '확인일',
                    sortable: true,
                    dataIndex: 'ReadDate',
                    xtype: 'datecolumn',
                    format: 'Y-m-d',
                    align: 'center',
                    groupable: false
                },
                {
                    text: '작성일',
                    sortable: true,
                    dataIndex: 'InsertDate',
                    xtype: 'datecolumn',
                    format: 'Y-m-d',
                    align: 'center',
                    groupable: false
                },
                {
                    text: '종결일',
                    sortable: true,
                    dataIndex: 'EndDate',
                    xtype: 'datecolumn',
                    format: 'Y-m-d',
                    align: 'center',
                    groupable: false
                },
                {
                    text: '상신일',
                    sortable: true,
                    dataIndex: 'DraftDate',
                    xtype: 'datecolumn',
                    format: 'Y-m-d',
                    align: 'center',
                    groupable: false
                },
                {
                    text: '상신자',
                    sortable: true,
                    dataIndex: 'DraftUserName',
                    align: 'center',
                    groupable: false,
                    width: 100
                },
                {   
                    text: '수신구분',
                    sortable: true,
                    dataIndex: 'RcvTypeName',
                    align: 'center',
                    groupable: false,
                    width: 120
                },              
                {
                    text: '수신자',
                    sortable: true,
                    dataIndex: 'RcvUserName',
                    align: 'center',
                    groupable: false,
                    width: 100
                }];

            var gridPaging = Ext.create('Ext.toolbar.Paging', {
            	id:'nboxMasterGridPaging',
                store: me.getStore(),
                dock: 'bottom',
                displayInfo: true
            });
            
            
            me.callParent(); 
        },
        listeners : {
            render: function(obj, eOpts){
                var nboxBaseApp = Ext.getCmp('nbox.baseApp');
                
                if (nboxBaseApp){
                    switch(nboxBaseApp.getDocBox()){
                        case 'XA001': // 임시문서
                            obj.setColumnsHidden({'RcvTypeName': true, 'ReadDate': true, 'EndDate': true, 'DraftDate': true, 'DraftUserName': true, 'RcvUserName': true});
                            break;
                        case 'XA002': // 기안문서
                            obj.setColumnsHidden({'RcvTypeName': true, 'ReadDate': true, 'InsertDate': true, 'DraftUserName': true, 'RcvUserName': true});
                            break;
                        case 'XA003': // 미결문서
                            obj.setColumnsHidden({'RcvTypeName': true, 'ReadDate': true, 'InsertDate': true, 'EndDate': true, 'RcvUserName': true});
                            break;
                        case 'XA004': case 'XA010': // 기결문서, // 개인문서함 
                            obj.setColumnsHidden({'RcvTypeName': true, 'ReadDate': true, 'InsertDate': true, 'RcvUserName': true});
                            break;
                        case 'XA011': // 반려문서
                            obj.setColumnsHidden({'DocumentNo': true, 'RcvTypeName': true, 'ReadDate': true, 'InsertDate': true, 'RcvUserName': true});
                            break;
                        case 'XA005': // 예결문서
                            obj.setColumnsHidden({'RcvTypeName': true, 'ReadDate': true, 'InsertDate': true, 'EndDate': true, 'DraftDate': true, 'RcvUserName': true});
                            break;
                        case 'XA006': case 'XA007': // 참조함, 수신함
                            obj.setColumnsHidden({'RcvTypeName': true, 'InsertDate': true, 'EndDate': true, 'RcvUserName': true});
                            break;
                        case 'XA008': // 발신함
                            obj.setColumnsHidden({'InsertDate': true, 'EndDate': true, 'DraftDate': true, 'DraftUserName': true});
                            break;
                        case 'XA009': // 회사문서함
                            obj.setColumnsHidden({'RcvTypeName': true, 'ReadDate': true, 'InsertDate': true, 'RcvUserName': true});
                            break;
                        default:
                            break;
    
                    }
                }
            },
            cellclick: function(grid, td, cellIndex, record, tr, rowIndex, e, eOpts ){
                if(cellIndex == 0)
                    return;
                
                grid.getSelectionModel().deselectAll();
                grid.getSelectionModel().select(rowIndex, true);
            },          
            itemdblclick: function(grid, record, item, index, e) {
                var me = this;
                var nboxBaseApp = Ext.getCmp('nboxBaseApp');
                
                if(record) {
                	var params = {
                            'PGM_ID'            : 'nboxdoclist',
                            'documentID'        : record.data.DocumentID,
                            'box'               : nboxBaseApp.getDocBox()
                        }
                        var rec1 = {data : {prgID : 'nboxdocdetail', 'text':''}};      
                	
                        openTab(rec1, '/nbox/nboxdocdetail.do', params);
                        
                    //me.openDetailWin(NBOX_C_READ, record.data.DocumentID);
                }
            },
            cellcontextmenu: function(grid, td, cellIndex, record, tr, rowIndex, e, eOpts ){
                if(cellIndex == 9){
                    var me = this;
                    
                    //contextMenuByUserName = me.getRegItems()['ContextMenuByUserName'];
                    
                    //contextMenuByUserName.getRegItems()['UserID'] = record.data.DraftUserID;
                    //contextMenuByUserName.showAt(e.getXY());
                    //e.preventDefault(); 
                }
            }
        },
        queryData: function(){
            var me = this;
            var store = me.getStore();
            var nboxBaseApp = Ext.getCmp('nboxBaseApp');
            var nboxSearchDivCode = Ext.getCmp('nboxSearchDivCode');
            var nboxSearchForm = Ext.getCmp('nboxSearchForm');
            
            if (nboxBaseApp.getGradeLevel() == "G1")
            	store.proxy.setExtraParam('SEARCHDIVCODE', nboxSearchDivCode.items.get('searchDivCode').getValue());
            else
            	store.proxy.setExtraParam('SEARCHDIVCODE', "");
            
            store.proxy.setExtraParam('SEARCHTEXT', nboxSearchForm.items.get('SEARCHTEXT').getValue());
            //페이지 인닛시키는것임..팝업으로 상세조회 후 닫기시 해당페이지 그대로. 검색시는 무조건 페이지 리셋
            if (NBOX_C_PAGE_INIT == "Y"){
                store.initPage(1, NBOX_C_GRID_LIMIT);   
            }
            else {          
                NBOX_C_PAGE_INIT = "Y";
            }
            
            store.load(); 

        },
        queryDetailData: function(){
            var me = this;
            var record;
            var nboxBaseApp = Ext.getCmp('nboxBaseApp');
            
            record = me.getSelectionModel().getSelection()[0];
            if(record) {
            	nboxBaseApp.setDocumentID(record.data.DocumentID);
            	nboxBaseApp.setActionType(NBOX_C_READ);
            	nboxBaseApp.queryData();
            }
        },
        moveData: function(){
            var me = this;
            
            var selectedDocumentID = new Array();
            var indx = 0;
            var selectedRecord = me.getSelectionModel().getSelection(); 
            var chk = true;
            var nboxBaseApp = Ext.getCmp('nboxBaseApp');
            
            Ext.each(selectedRecord, function(record,i){                                                      
                if(record.data['DocumentID']){
                    
                    if(record.data['ClosingFlag'] != 'Y' ){
                        chk = false;
                        Ext.Msg.alert('확인','선택한 문서 중 종결되지 않은 문서가 존재합니다.');
                        return ;
                    }
                    
                    selectedDocumentID[indx] = record.data['DocumentID'];
                    indx++;
                }
            });
            
            if(chk){
                
                if(selectedDocumentID.length <= 0) {
                    Ext.Msg.alert('확인','이동할문서가 존재하지 않습니다.');
                    return;
                }
            
                var uCabinetID = '';
                var cabinetID = '';
                
                switch(nboxBaseApp.getDocBox()){
                    /* 회사 분류 */
                    case 'XA009':
                        var moveCabinetID = Ext.getCmp('nboxMoveCabinetID');
                        var cabinetID = moveCabinetID.getValues().moveCabinetID;
                        
                        break;
                    /*기안문서, 개인분류 */
                    case 'XA002': case 'XA010':
                        var moveUCabinetID = Ext.getCmp('nboxMoveUCabinetID');
                        var uCabinetID = moveUCabinetID.getValues().moveUCabinetID;
                        
                        break;
                    default:
                        break;
                }
                
                if(cabinetID == '' && uCabinetID == ''){
                    Ext.Msg.alert('확인','이동할메뉴가 존재하지 않습니다.');
                    return;
                }
                
                Ext.Msg.confirm('확인', '선택한 문서를 이동하시겠습니까?',
                    function(btn) {
                        if (btn === 'yes') {
                            var param = {
                                    'CabinetID': cabinetID,
                                    'UCabinetID': uCabinetID,
                                    'DocumentIDs[]' : selectedDocumentID};
                                
                            nboxDocListService.moveMenu(param, function(provider, response) {
                                UniAppManager.updateStatus("이동하였습니다.");
                                me.queryData();
                            });
                        } 
                });
                            
            }   
    
        }, 
        selectPrevious: function(keepExisting, suppressEvent) {
            var me = this;
            var last;
            var pageData;
            var selModel = me.getSelectionModel();
            
            last = selModel.getSelection()[0];
            if (last) {
                pageData = Ext.getCmp('nboxMasterGridPaging').getPageData();
    
                if (last.index >= pageData.fromRecord) {
                    selModel.select((last.index - pageData.fromRecord), keepExisting, suppressEvent);
                    me.queryDetailData();
                    return;
                }
    
                if (pageData.currentPage > 1) {
                    me.view.on('refresh', function(view){
                            selModel.select((me.getStore().getCount() - 1), keepExisting, suppressEvent);
                            me.queryDetailData();
                        },
                        me, {single: true}
                    );
                    Ext.getCmp('nboxMasterGridPaging').movePrevious();
                } else {
                    Ext.Msg.alert('확인', '첫번째 레코드 입니다.');
                }
            }
        },
        selectNext: function(keepExisting, suppressEvent) {
            var me = this;
            var pageData;
            var selModel = me.getSelectionModel();
            
            last = selModel.getSelection()[0];
            if (last) {
                pageData = Ext.getCmp('nboxMasterGridPaging').getPageData();

                if (last.index < pageData.toRecord - 1) {
                    selModel.select((last.index + 2 - pageData.fromRecord), keepExisting, suppressEvent);
                    me.queryDetailData();
                    return;
                }

                if (pageData.currentPage < pageData.pageCount) {
                    me.view.on('refresh', function(view){
                            selModel.select(0, keepExisting, suppressEvent);
                            me.queryDetailData();
                        },
                        me, {single: true}
                    );
                    Ext.getCmp('nboxMasterGridPaging').moveNext();
                } else {
                    Ext.Msg.alert('확인', '마지막 레코드입니다.');
                }
            } 
        },
        setColumnsHidden: function(columns){
            var me = this;
            
            if (!columns) return;
            
            for(var idx=0; idx<me.columns.length; idx++){
                if (columns[me.columns[idx].dataIndex]){
                    me.setColumnHidden(idx, columns[me.columns[idx].dataIndex]);
                }
            }
        },
        setColumnHidden: function(index, flag){
            var me = this;
            if (me.columns[index]){
                me.columns[index].hidden = flag;
            }
        },
        setConfigStore: function(store){
            var me = this;
            me.store = store;
        }/*,
        openDetailWin: function(actionType, documentID){
            var me = this;
            var menuID = '${PRGID}'; 
            var box = '${BOX}';
            
            openDocDetailWin(me, actionType, documentID, menuID, box);
        }*/
    }); 

//Viewport toolbar
    Ext.define('nbox.viewportToolbar',    {
        extend:'Ext.toolbar.Toolbar',
        config: {
            regItems: {}
        },
        dock : 'top',
        height: 30, 
        
        initComponent: function () {
            var me = this;
            var btnWidth = 60;
            var btnHeight = 26;
            
            var nboxCabinetMenuStore  = Ext.create('nbox.cabinetMenuStore', {
            	id: 'nboxCabinetMenuStore'
            });
            
            var nboxDivCodeStore  = Ext.create('nbox.divCodeStore', {
                id: 'nboxDivCodeStore'
            });
            
            var formCabinetID = {
                xtype: 'form',
                border: false,
                layout: 'fit',
                id:'nboxMoveCabinetID',
                style: { margin: '0px 0px 0px 3px' },
                items: [
                    { 
                        xtype: 'combo', 
                        name: 'moveCabinetID',
                        store: nboxCabinetMenuStore,
                        valueField: 'pgmID',
                        displayField: 'pgmName',
                        emptyText: '이동',
                        
                        listeners: {
                            select: function( obj, records, eOpts ){
                            	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
                            	
                                if(records.length > 0){
                                	if (nboxBaseApp)
                                		   nboxBaseApp.MoveButtonDown();
                                }
                                obj.setValue('');
                            }
                        }
                    }
                  ]
            };
            
            nboxMyCabinetMenuStore = Ext.create('nbox.myCabinetMenuStore', {
            	id: 'nboxMyCabinetMenuStore'
            });
            
            var formDivCode = {
                    xtype: 'form',
                    border: false,
                    layout: 'fit',
                    id:'nboxSearchDivCode',
                    style: { margin: '0px 0px 0px 3px' },
                    items: [
                        { 
                            xtype: 'combo', 
                            id: 'searchDivCode',
                            name: 'searchDivCode',
                            store: nboxDivCodeStore,
                            valueField: 'divCode',
                            displayField: 'divName',
                            emptyText: '선택',
                            
                            listeners: {
                                select: function( obj, records, eOpts ){

                                }
                            }
                        }
                      ]
                };
            
            var formUCabinetID = {
                xtype: 'form',
                border: false,
                layout: 'fit',
                id:'nboxMoveUCabinetID',
                style: { margin: '0px 0px 0px 3px' },
                items: [
                    { 
                        xtype: 'combo', 
                        name: 'moveUCabinetID',
                        store: nboxMyCabinetMenuStore,
                        valueField: 'pgmID',
                        displayField: 'pgmName',
                        emptyText: '이동',
                        disabled: true,
                        
                        listeners: {
                            select: function( obj, records, eOpts ){
                            	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
                            	
                                if(records.length > 0){
                                	if (nboxBaseApp)
                                		nboxBaseApp.MoveButtonDown();
                                }
                                obj.setValue('');
                            }
                        }
                    }
                  ]
            };
            
            var formSearch = { 
                xtype: 'form',
                border: false,
                layout: 'fit',
                id:'nboxSearchForm',
                style: { margin: '0px 0px 0px 3px' },
                items: [
                { 
                    xtype: 'textfield',
                    id: 'SEARCHTEXT',
                    name: 'SEARCHTEXT',
                    width: 250,
                    emptyText: '문서번호, 제목, 상신자 검색어를 입력하세요.'
                }]  
            };
            
            var btnQuery =  {   
                xtype: 'button',
                tooltip: '검색',
                //text: '<img src="' + NBOX_IMAGE_PATH + 'baseButton/search16a.png" width=15 height=15/>&nbsp;<label>검색</label>',
                text: '<label>검색</label>',
                itemId: 'query',
                width: btnWidth,  
                height: btnHeight,
                style: { margin: '0px 0px 0px 3px' },
                
                handler: function() {
                	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
                	
                	if (nboxBaseApp)
                		nboxBaseApp.QueryButtonDown();
                }
            };

            var btnClose = {
                xtype: 'button',
                tooltip : '닫기',
                //text: '<img src="' + NBOX_IMAGE_PATH + 'baseButton/close16a.png" width=15 height=15/>&nbsp;<label>닫기</label>',  
                text: '<label>닫기</label>',
                itemId : 'close',
                width: btnWidth,  
                height: btnHeight,
                style: { margin: '0px 0px 0px 3px' },
                
                handler: function() { 
                	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
                	
                	if (nboxBaseApp)
                		nboxBaseApp.CloseButtonDown();
                }
            };
            
            var toolbarItems = null;
            
            switch('${BOX}'){
                case 'XA002': case 'XA010':
                    toolbarItems = [ formUCabinetID, formSearch, btnQuery, btnClose ];
                    break;
                case 'XA009':
               	    toolbarItems = [ formDivCode, formCabinetID, formSearch, btnQuery, btnClose ];
                    break; 
                default:
                    toolbarItems = [ formSearch, btnQuery, btnClose ];
                    break;
            }
                
            var chk01 = ( typeof IS_DEVELOPE_SERVER == "undefined") ? false : IS_DEVELOPE_SERVER ;
            if( chk01 ) {
                toolbarItems.push( // space
                    '->',
                    {
                        xtype : 'button',
                        text : '',
                        tooltip : '현재탭 Reload(Cache 사용 안함!)', 
                        iconCls: 'icon-reload',
                        handler : function() {
                            location.reload(true );
                        }
                    },
                    {
                        xtype : 'button',
                        text : '',
                        tooltip : '현재 Tab을 새창으로 띄우기', 
                        iconCls: 'icon-newWindow',
                        handler : function() {
                            window.open(window.location.href, '_blank');
                        }
                    }
                );
            }
                        
            me.items = toolbarItems;
            me.callParent(); 
        },
        setToolBars: function(btnItemIDs, flag){
            var me = this;
            
            if(Ext.isArray(btnItemIDs) ) {
                for(i = 0; i < btnItemIDs.length; i ++) {
                    var element = btnItemIDs[i];
                    me.setToolBar(element, flag);
                }
            } else {
                me.setToolBar(btnItemIDs, flag);
            }
        },
        setToolBar: function(btnItemID, flag){
            var me = this;
            
            var obj =  me.getComponent(btnItemID);
            if(obj) {
                (flag) ? obj.enable(): obj.disable();
            }
        }
    });
    
//Viewport
    Ext.define('nbox.baseApp', {
        extend: 'Ext.Viewport',
        config: {
        	documentID: null,
        	actionType: null,
        	docBox: null,
        	gradeLevel: null,
            regItems: {}
        },
        defaults: { padding: 0 },
        layout : {  
            type: 'vbox', 
            pack: 'start', 
            align: 'stretch' 
        },
        initComponent: function () {
            var me = this;

            me.setDocumentID('${DOCUMENTID}');
            me.setDocBox('${BOX}');

            var title = {
                xtype: 'container',
                cls: 'uni-pageTitle',
                id: 'UNILITE_PG_TITLE',
                html: "${PGM_TITLE}",
                padding: '0 0 5px 0',
                height: 32,
                region:'north'
            };
            
            var nboxViewportToolbar = Ext.create('nbox.viewportToolbar',{
            	id: 'nboxViewportToolbar'
            });
            
            var nboxMasterGridStore = Ext.create('nbox.masterGridStore', {
            	id: 'nboxMasterGridStore'
            });
            
            var nboxMasterGrid = Ext.create('nbox.masterGrid',{
            	id:'nboxMasterGrid',
                store: nboxMasterGridStore
            });
            
            me.items = [title, nboxViewportToolbar, nboxMasterGrid];
            
            me.callParent(); 
        },
        MoveButtonDown: function(){
            var me = this;
            me.moveData();
        },
        QueryButtonDown: function(){
            var me = this;
            NBOX_C_PAGE_INIT == "Y"
            me.queryData();
        },
        NewButtonDown: function(){
            var me = this;
            me.newData();
        },
        CloseButtonDown: function(){
            var me = this;
            me.closeWindow();
        },   
        moveData: function(){
            var me = this;
            var nboxMasterGrid = Ext.getCmp('nboxMasterGrid');
            
            if (nboxMasterGrid)
            	nboxMasterGrid.moveData();
        },
        queryData: function(){
            var me = this;
            var nboxMasterGrid = Ext.getCmp('nboxMasterGrid');
            
            if (nboxMasterGrid)
            	nboxMasterGrid.queryData();
        },      
        newData: function(){
        },
        closeWindow: function(){
            var tabPanel = parent.Ext.getCmp('contentTabPanel');
            if(tabPanel) {
                var activeTab = tabPanel.getActiveTab();
                var canClose = activeTab.onClose(activeTab);
                if(canClose)  {
                    tabPanel.remove(activeTab);
                }
            } else {
                me.hide();
            }
        } 
    });
    
/**************************************************
 * Create
 **************************************************/
//Load Mask
//var myMask = new Ext.LoadMask(Ext.getBody(), {msg:"Please wait..."});
    
    
    var extraUserInfoStroe = Ext.create('nbox.extraUserInfoStroe',{});
    extraUserInfoStroe.load({
        callback: function(records, operation, success) {
            if (success){
                UserInfo.posName = records[0].data.posName;
                UserInfo.emailAddr = records[0].data.emailAddr;
                
                //Viewport Create
                Ext.create('nbox.baseApp',  {
                	id:'nboxBaseApp'
                });
                
                var nboxBaseApp = Ext.getCmp('nboxBaseApp');
                var searchDivCode = Ext.getCmp('searchDivCode');
                var box ="${BOX}";
                
                if (nboxBaseApp){
                	nboxBaseApp.setGradeLevel(records[0].data.gradeLevel);
                	
                	if (box == "XA009"){
                	    if (nboxBaseApp.getGradeLevel() == 'G1')
                	    	  searchDivCode.setHidden(false);
                	    else
                	    	  searchDivCode.setHidden(true);
                	}
                }
            }
        }
    });
    
    //openDocDetailTab_GW("6","6330020170008",null);
    
}; // appMain

/**************************************************
 * User Define Function
 **************************************************/
function openTab_a(pgmId, documentID, docBox, text, doPath){
    var params = {
         'PGM_ID'            : pgmId,
         'documentID'        : documentID,
         'box'               : docBox
    }
    var rec1 = {data : {prgID : pgmId, 'text':text}}; 
    
    openTab(rec1, doPath, params);
};

function openTab(rec1, doPath, params){
	
	nboxDocListService.checkDoc(
        {'DOCUMENTID' : params.documentID, 'MENUID' : '${PRGID}','BOX' : '${BOX}' },
        function(provider, response) {
        	if (response.result <= 0){
        		Ext.Msg.alert('확인','해당 문서함에 존재하지 않는 문서 입니다.</br>문서함을 다시 조회 하십시요!');
        	}
        	else{
        		parent.openTab(rec1, doPath, params);    		
        	}
        });
};
</script>	
