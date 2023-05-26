<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="tpl200urk">
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {
    color: #333333;
    font-weight: normal;
    padding: 1px 2px;
}
</style>
<script type="text/javascript">

var excelWindow;
function appMain() {
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('Tpl200ukrModel', {
       fields: [
            /**          
             * type:
             *      uniQty         -      수량
             *      uniUnitPrice   -      단가
             *      uniPrice       -      금액(자사화폐)
             *      uniPercent     -      백분율(00.00)
             *      uniFC          -      금액(외화화폐)
             *      uniER          -      환율
             *      uniDate        -      날짜(2999.12.31)
             * maxLength: 입력가능한 최대 길이
             * editable: true   수정가능 여부
             * allowBlank: 필수 여부
             * defaultValue: 기본값
             * comboType:'AU', comboCode:'B014' : 그리드 콤보 사용시
            */
            {name: 'SEQ'        , text: '순번'         , type: 'int'          , maxLength: 200          , allowBlank: false},
            {name: 'COL01'       , text: '컬럼1'        , type: 'string'       , maxLength: 200},
            {name: 'COL02'       , text: '컬럼2'        , type: 'string'       , maxLength: 200},
            {name: 'COL03'       , text: '컬럼3'        , type: 'string'       , maxLength: 200},
            {name: 'COL04'       , text: '컬럼4'        , type: 'string'       , maxLength: 200},
            {name: 'COL05'       , text: '컬럼5'        , type: 'string'       , maxLength: 200},
            {name: 'COL06'       , text: '컬럼6'        , type: 'string'       , maxLength: 200},
            {name: 'COL07'       , text: '컬럼7'        , type: 'string'       , maxLength: 200},
            {name: 'COL08'       , text: '컬럼8'        , type: 'string'       , maxLength: 200},
            {name: 'COL09'       , text: '컬럼9'        , type: 'string'       , maxLength: 200},
            {name: 'COL10'       , text: '컬럼10'       , type: 'string'       , maxLength: 200}
        ]
    });
    
    /**
     * masterStore Proxy정의
     */     
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'tpl200ukrService.select',           //조회
            update: 'tpl200ukrService.update',         //수정
            create: 'tpl200ukrService.insert',         //입력
            destroy: 'tpl200ukrService.delete',        //삭제
            syncAll: 'tpl200ukrService.saveAll'        //저장
        }
    });
    

    /**
     * masterStore 정의
     */ 
    var masterStore = Unilite.createStore('tpl200MasterStore',{
        model: 'Tpl200ukrModel',
        autoLoad: false,
        uniOpt : {
            isMaster: true,         // 상위 버튼 연결 
            editable: true,         // 수정 모드 사용 
            deletable:true          // 삭제 가능 여부
        },        
        proxy: directProxy,
        loadStoreRecords : function()  {
            var param= panelResult.getValues();     //조회폼 파라미터 수집       
            console.log( param );
            this.load({                             //그리드에 Load..
                params : param,
                callback : function(records, operation, success) {
                    if(success) {   //조회후 처리할 내용
                    
                    }
                }
            });
        },
        // 수정/추가/삭제된 내용 DB에 적용 하기 
        saveStore : function() {               
            var inValidRecs = this.getInvalidRecords();     //필수값 입력여부 체크
            if(inValidRecs.length == 0 )    {
                var config = {
                    params:[panelSearch.getValues()],       //조회조건 param
                    success : function()    {               //저장후 실행될 로직
                        
                    }
                }
                this.syncAllDirect(config);         //저장 로직 실행  
            }else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs); //에러 발생
            }
        }
        
    });


    /**
     * 좌측 검색조건 (panelSearch)
     */
    var panelSearch = Unilite.createSearchPanel('searchForm', {
        title: '검색조건',         
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,   //사용할 조회 폼
        listeners: {    //화면 사용 안하는 조회폼 hide 
            collapse: function () { 
                panelResult.show();
            },
            expand: function() {
                panelResult.hide();
            }
        },
        items: [{     
            title: '기본정보',   
            itemId: 'search_panel',
            layout: {type: 'uniTable', columns: 1},
            items : [{
                xtype:'container',
                layout : {type : 'uniTable', columns : 1},  //1열 종대형 테이블 레이아웃
                items:[{
                    xtype:'uniDatefield',           //필드 타입
                    fieldLabel: '입고일자'  ,
                    name: 'INOUT_DATE',             //Query mapping name
                    value: UniDate.get('today'),    //화면 open시 Default되어 보여질 값
                    allowBlank:false,               //필수(*)여부
                    listeners: {//이벤트 작성
                        change: function(combo, newValue, oldValue, eOpts) {                    
                            panelResult.setValue('INOUT_DATE', newValue);       //비활성화된 검색폼과 동기화 시키기 위해                 
                        }
                    }
                 }]  
            }]
        }]
    });
    
    /**
     * 상단 검색조건 (panelSearch)
     */ 
	var panelResult = Unilite.createSearchForm('resultForm', {
		region: 'north',
        layout : {type : 'uniTable', columns : 3/*, tableAttrs: {width: '100%'}*/},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
            xtype:'uniDatefield',           //필드 타입
            fieldLabel: '입고일자'  ,
            name: 'INOUT_DATE',             //Query mapping name
            value: UniDate.get('today'),    //화면 open시 Default되어 보여질 값
            allowBlank:false,               //필수(*)여부
            listeners: {//이벤트 작성
                change: function(combo, newValue, oldValue, eOpts) {                    
                    panelSearch.setValue('INOUT_DATE', newValue);       //비활성화된 검색폼과 동기화 시키기 위해                 
                }
            }
        },{
            xtype: 'uniTextfield',
            hidden:true,
            name: 'FILE_ID'                  // CSV UPLOAD 시 반드시 존재해야함.
        },{
            xtype: 'uniTextfield',
            hidden:true,
            name: 'CSV_LOAD_YN'              // CSV UPLOAD 시 반드시 존재해야함.
        },{
            xtype: 'uniTextfield',
            hidden:true,
            name: 'PGM_ID'                   // CSV UPLOAD 시 반드시 존재해야함.
        }]
	});
    
    /**
     * CSV 파일 UPLOAD 팝업 오픈
     */
    function openExcelWindow() {
        var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.CSVUpload';

        if (!excelWindow) {
            excelWindow = Ext.create(appName, {
                modal : false,

                excelConfigName : 'tpl200urk',
                listeners : {
                    beforehide: function(me, eOpt) {
                    },
                    beforeclose: function( me, eOpts ) {
                    },
                    hide: function ( me, eOpts ) {
                    	if(me.fileIds != null && me.fileIds.length > 0) {
                    		console.log("me.fileIds.length :: " + me.fileIds.length);
                    		console.log("me.fileIds :: " + me.fileIds[0]);

                    		panelResult.getEl().mask('저장중...','loading-indicator');    // mask on
                    		
                    		panelResult.setValue('FILE_ID', me.fileIds[0]);               // 추가 파일 담기
                    		panelResult.setValue('CSV_LOAD_YN', 'Y');                     // 초기값 세팅
                    		panelResult.setValue('PGM_ID', 'tpl200urk');                  // 초기값 세팅
                    		
                    		masterStore.loadStoreRecords();                               // csv 파일 읽고, 조회하기
                    		
                            panelResult.getEl().unmask();                                 // mask off
                    	} else {
                    		console.log('업로드된 파일 없음.');
                    	}
                    },
                    show: function ( me, eOpts ) {
                    }
                }
            });
        }
        excelWindow.center();
        excelWindow.show();
    }
    
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('tpl103Grid', {
        layout : 'fit',     //화면 꽉차는 layout
        region : 'center',
        store: masterStore,       //스토어 mapping
        uniOpt: {
            expandLastColumn: false,    //마지막컬럼 존재 여부
            useRowNumberer: true,       //순번표시 여부
            copiedRow: true             //행복사 기능 사용 여부
        },
        features: [{        //합계행 표시 처리
            id: 'masterGridSubTotal',
            ftype: 'uniGroupingsummary', 
            showSummaryRow: false 
        },{
            id: 'masterGridTotal',  
            ftype: 'uniSummary',      
            showSummaryRow: false
        }],
        tbar: [{        //그리드 툴바 추가
            text: 'CSV Upload',
            handler: function() {
                openExcelWindow();
            }
        }],
        columns: [
                {dataIndex: 'SEQ'            , width: 60},
                {dataIndex: 'COL01'          , width: 120},
                {dataIndex: 'COL02'          , width: 120},              
                {dataIndex: 'COL03'          , width: 120},
                {dataIndex: 'COL04'          , width: 120},
                {dataIndex: 'COL05'          , width: 120},
                {dataIndex: 'COL06'          , width: 120},
                {dataIndex: 'COL07'          , width: 120},
                {dataIndex: 'COL08'          , width: 120},
                {dataIndex: 'COL09'          , width: 120},
                {dataIndex: 'COL10'          , width: 120}
        ], 
        listeners: {
             
        } 
    });    
    
	Unilite.Main({
		border : false,
		borderItems : [ {
			region : 'center',
			layout : 'border',
			border : false,
			items : [ panelResult, masterGrid ]
		} ],
		id : 'tpl200urkApp',
		fnInitBinding : function() {
			panelSearch.setValue('INOUT_DATE', UniDate.get('today'));              //초기값 세팅
            UniAppManager.setToolbarButtons(['reset','newData','detail'],true);    //main 버튼 활성화 여부
            //UniAppManager.setToolbarButtons('save', false);
            
            //화면 오픈시 입고일자에 focus 및 select 처리
            var activeSForm ;
            if(!UserInfo.appOption.collapseLeftSearch)  {
                activeSForm = panelSearch;
            }else {
                activeSForm = panelResult;
            }
            activeSForm.onLoadSelectText('INOUT_DATE');
		},
        onQueryButtonDown : function()  {           //조회버튼 클릭시
            if(!this.isValidSearchForm()){          //조회전 필수값 입력 여부 체크
                return false;
            }
            panelResult.setValue('FILE_ID', '');              //초기값 세팅
            panelResult.setValue('CSV_LOAD_YN', 'N');         //초기값 세팅
            
            masterStore.loadStoreRecords();   //Store 조회 함수 호출
        },
        onResetButtonDown: function() {             //신규버튼 클릭시
            masterGrid.reset();                     //그리드 reset
            directMasterStore.clearData();          //스토어 Clear
            this.fnInitBinding();                   //초기화 함수 호출
        },
        onNewDataButtonDown : function()    {//추가버튼 클릭시 
             var seq = directMasterStore.max('SEQ');
             if(!seq) seq = 1;
             else  seq += 1;
             var r = { 
                SEQ: seq    
            };          
            masterGrid.createRow(r, 'COL1');    //행 생성시 default값 세팅 및 포커스 지정
        },
         onDeleteDataButtonDown: function() {   //삭제버튼 클릭시  
            var selRow = masterGrid.getSelectedRecord();            
            if(selRow.phantom === true) {
                masterGrid.deleteSelectedRow();
            } else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                masterGrid.deleteSelectedRow();             
            }           
        },
        onSaveDataButtonDown: function () { //저장버튼 클릭시
        	masterStore.saveStore();
        },
        processParams: function(params) {   //링크로 넘어올시 처리 부분 
            
        }
	});

};
</script>
