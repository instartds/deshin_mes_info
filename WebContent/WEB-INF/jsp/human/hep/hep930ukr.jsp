<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hep930ukr"  >
    <t:ExtComboStore comboType="AU" comboCode="H173" /> <!-- 직렬 -->
    <t:ExtComboStore comboType="AU" comboCode="H006" /> <!-- 직급 -->
    <t:ExtComboStore comboType="AU" comboCode="H095" /> <!-- 평가구분 -->
    <t:ExtComboStore comboType="AU" comboCode="HE44" /> <!-- 평가등급 -->
    <t:ExtComboStore comboType="AU" comboCode="HE76" /> <!-- 평가별배분율 -->
    <t:ExtComboStore items="${COMBO_ABIL_CODE}" storeId="abilCodeList" /> <!--직급(일반직2급,3급 합침)-->
    
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	

<script type="text/javascript" >

var baseCodeHE44 = Ext.data.StoreManager.lookup('CBS_AU_HE44').data.items;
var baseNameHE44_S_SN = '';
var baseNameHE44_A_SN = '';
var baseNameHE44_B_SN = '';
var baseNameHE44_C_SN = '';
var baseNameHE44_D_SN = '';

var baseNameHE44_S_R4 = '';
var baseNameHE44_A_R4 = '';
var baseNameHE44_B_R4 = '';
var baseNameHE44_C_R4 = '';
var baseNameHE44_D_R4 = '';
Ext.each(baseCodeHE44, function(record,i) {
    if(record.get('value') == 'S'){
        baseNameHE44_S_SN = record.get('text');
        baseNameHE44_S_R4 = record.get('refCode4') + '%';
    }else if(record.get('value') == 'A'){
        baseNameHE44_A_SN = record.get('text');
        baseNameHE44_A_R4 = record.get('refCode4') + '%';
    }else if(record.get('value') == 'B'){
        baseNameHE44_B_SN = record.get('text');
        baseNameHE44_B_R4 = record.get('refCode4') + '%';
    }else if(record.get('value') == 'C'){
        baseNameHE44_C_SN = record.get('text');
        baseNameHE44_C_R4 = record.get('refCode4') + '%';
    }else if(record.get('value') == 'D'){
        baseNameHE44_D_SN = record.get('text');
        baseNameHE44_D_R4 = record.get('refCode4') + '%';
    }
});

/*var baseCodeHE76 = Ext.data.StoreManager.lookup('CBS_AU_HE76').data.items;
var baseCodeHE76_A_R1 = '';                       //다면평가 등급배분율 (종합배분율%)
var baseCodeHE76_A_R4 = '';                       //다면평가 환산점수 (만점기준)
var baseCodeHE76_B_R1 = '';                       //BSC 등급배분율 (종합배분율%)
var baseCodeHE76_B_R4 = '';                       //BSC 환산점수 (만점기준)
var baseCodeHE76_C_R1 = '';                       //근무평정 등급배분율 (종합배분율%)
var baseCodeHE76_C_R4 = '';                       //근무평정 환산점수 (만점기준)
Ext.each(baseCodeHE76, function(record,i) {
    if(record.get('value') == 'A'){                     //다면평가
        baseCodeHE76_A_R1 = record.get('refCode1');
        baseCodeHE76_A_R4 = record.get('refCode4');
    }else if(record.get('value') == 'B'){             //BSC
        baseCodeHE76_B_R1 = record.get('refCode1');
        baseCodeHE76_B_R4 = record.get('refCode4');
    }else if(record.get('value') == 'C'){             //근무평정
        baseCodeHE76_C_R1 = record.get('refCode1');
        baseCodeHE76_C_R4 = record.get('refCode4');
    }
});
*/
var buttonFlag = '';

var calcRatingWindow; // 등급별인원수계산 팝업
var calcRatingWin; // 등급별인원수계산 팝업
var excelWindow;    // 엑셀참조
function appMain() {
	// 엑셀참조
    Unilite.Excel.defineModel('excel.hep930.sheet01', {
        fields:[
            {name: 'PERSON_NUMB'    ,text: '사번'     ,type: 'string'},
            {name: 'NAME'           ,text: '성명'     ,type: 'string'},
            {name: 'WORK_POINT'     ,text: '근무평정점수'     ,type : 'float', decimalPrecision:3, format:'0,000.000'},
            {name: 'MULTI_POINT'    ,text: '다면평가점수'     ,type : 'float', decimalPrecision:3, format:'0,000.000'}
        ]
    });
    
    function openExcelWindow() {
        var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.ExcelUpload';
        if(!excelWindow) {
            excelWindow =  Ext.WindowMgr.get(appName);
            excelWindow = Ext.create( appName, {
                modal: false,
                excelConfigName: 'hep930ukr',
                extParam: {
                    'PGM_ID' : 'hep930ukr'
                },
                grids: [{
                    itemId: 'grid01',
                    title: '평가관리 평정 다면 점수 등록양식',                                
                    useCheckbox: false,
                    model : 'excel.hep930.sheet01',
                    readApi: 'hep930ukrService.selectExcelUploadSheet1',
                    columns:[
                        {dataIndex: 'PERSON_NUMB'                , width: 100},
                        {dataIndex: 'NAME'                       , width: 100},
                        {dataIndex: 'WORK_POINT'                , width: 100},
                        {dataIndex: 'MULTI_POINT'                , width: 100}
                    ]
                }],
                listeners: {
                    show: function( panel, eOpts )  {
                        Ext.getBody().mask('엑셀업로드작업중...','loading-indicator');
                    },
                    close: function() {
                        this.hide();
                    },
                    hide: function() {
                        Ext.getBody().unmask();
                    }
                },
                onApply:function()  {
                    excelWindow.getEl().mask('로딩중...','loading-indicator');     ///////// 엑셀업로드 최신로직
                    var me = this;
                    var grid = this.down('#grid01');
                    var records = grid.getStore().getAt(0); 
                    if(Ext.isEmpty(records)) {
                        excelWindow.getEl().unmask();
                        return false;
                    }
                    var param = {"_EXCEL_JOBID": records.get('_EXCEL_JOBID')};
                    hep930ukrService.selectExcelUploadApply(param, function(provider, response){
                        var store = detailStore;
                        var records = response.result;
                        
                        var detailRecords = detailStore.data.items;
                        if(detailRecords.length > 0)  {
                            Ext.each(records, function(record, i){
                                Ext.each(detailRecords, function(item, j){
                                    if(item.data['PERSON_NUMB'] == record.PERSON_NUMB){
                                        item.set('WORK_POINT',record.WORK_POINT);
                                        item.set('MULTI_POINT',record.MULTI_POINT);
                                    }
                                })
                            })
                        }
                        
                        excelWindow.getEl().unmask();
                        grid.getStore().removeAll();
                        me.hide();
                    });
                }
            });
        }
        excelWindow.center();
        excelWindow.show();
    }
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'hep930ukrService.selectList',
            update: 'hep930ukrService.updateDetail',
            syncAll: 'hep930ukrService.saveAll'
        }
    });
	

	Unilite.defineModel('hep930ukrModel', {
        fields: [
            {name: 'COMP_CODE'         ,text: '법인코드'        ,type: 'string',allowBlank:false},
            {name: 'MERITS_YEARS'         ,text: '기준년도'        ,type: 'string',allowBlank:false},
            {name: 'MERITS_GUBUN'         ,text: '구분'        ,type: 'string',allowBlank:false},
            {name: 'RANK'                   ,text: '순위'        ,type: 'string'},
            {name: 'AFFIL_CODE'         ,text: '직렬코드'        ,type: 'string'},
            {name: 'AFFIL_NAME'         ,text: '직렬'        ,type: 'string'},
            {name: 'DEPT_CODE'         ,text: '부서코드'        ,type: 'string'},
            {name: 'DEPT_NAME'         ,text: '부서명'        ,type: 'string'},
            {name: 'ABIL_CODE'         ,text: '직급코드'        ,type: 'string'},
            {name: 'ABIL_NAME'         ,text: '직급'        ,type: 'string'},
            {name: 'PERSON_NUMB'         ,text: '사번'        ,type: 'string'},
            {name: 'NAME'                   ,text: '성명'        ,type: 'string'},
            {name: 'JOIN_DATE'          ,text: '입사일'        ,type: 'uniDate'},
            {name: 'WORK_POINT'               ,text: '점수'        ,type : 'float', decimalPrecision:3, format:'0,000.000'},
            {name: 'WORK_WEGH_POINT'          ,text: '가중치점수'        ,type : 'float', decimalPrecision:3, format:'0,000.000'},
            {name: 'BSC_POINT'                ,text: '점수'        ,type : 'float', decimalPrecision:3, format:'0,000.000'},
            {name: 'BSC_WEGH_POINT'           ,text: '가중치점수'        ,type : 'float', decimalPrecision:3, format:'0,000.000'},
            {name: 'MULTI_POINT'              ,text: '점수'        ,type : 'float', decimalPrecision:3, format:'0,000.000'},
            {name: 'MULTI_WEGH_POINT'         ,text: '가중치점수'        ,type : 'float', decimalPrecision:3, format:'0,000.000'},
            {name: 'LAST_EVAL_POINT'          ,text: '최종점수'        ,type : 'float', decimalPrecision:3, format:'0,000.000'},
            {name: 'MERITS_CLASS'         ,text: '최종등급'        ,type: 'string',comboType:'AU', comboCode:'HE44'},
            {name: 'ADJU_MERITS_CLASS'         ,text: '조정등급'        ,type: 'string',comboType:'AU', comboCode:'HE44'},
            {name: 'ADJU_RESN'          ,text: '조정사유'        ,type: 'string'},
            
            {name: 'UPDATE_DUMMY_FLAG'          ,text: '평가점수계산버튼 누를시 사용'        ,type: 'string'}
            
            
            
        ]
    });
    
//    function setConvert (value) {
//     return Math.floor(value*100) / 100;
//    }
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var detailStore = Unilite.createStore('hep930ukrStore', {
        model: 'hep930ukrModel',
        uniOpt: {
            isMaster: false,         // 상위 버튼 연결           ( 삭제, 저장, 이전, 이후   , 몇건 조회되었습니다. 컨트롤)
            editable: true,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            allDeletable:false,
            useNavi : false         // prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        saveStore : function(config)    {
            var inValidRecs = this.getInvalidRecords();
            var paramMaster= panelResult.getValues();   //syncAll 수정
            
            paramMaster.buttonFlag = buttonFlag;
         /*   if(buttonFlag == 'refBtn3'){
                paramMaster.baseCodeHE76_A_R1 = baseCodeHE76_A_R1;
                paramMaster.baseCodeHE76_A_R4 = baseCodeHE76_A_R4;
                paramMaster.baseCodeHE76_B_R1 = baseCodeHE76_B_R1;
                paramMaster.baseCodeHE76_B_R4 = baseCodeHE76_B_R4;
                paramMaster.baseCodeHE76_C_R1 = baseCodeHE76_C_R1;
                paramMaster.baseCodeHE76_C_R4 = baseCodeHE76_C_R4;
            	
            }*/
            
            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    
                    success: function(batch, option) {
                        panelResult.getForm().wasDirty = false;
                        panelResult.resetDirtyStatus();
                        console.log("set was dirty to false");
                        UniAppManager.setToolbarButtons('save', false); 
                        
                        UniAppManager.app.onQueryButtonDown();
                        

                        buttonFlag = '';
                    },
                    failure: function(batch, option) {
                        buttonFlag = '';
                 	
                    }
                    
                };
                this.syncAllDirect(config);
            } else {
                detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
            	var count = store.getCount();
                    if(count > 0) {
                        panelResult.down('#refBtn3').setDisabled(false);
                        panelResult.down('#refBtn4').setDisabled(false);
                        
                        detailGrid.down('#excelBtn').setDisabled(false);
                    }
                    
            	var msg = records.length + Msg.sMB001; //'건이 조회되었습니다.';
                UniAppManager.updateStatus(msg, true);  
                
            },
            add: function(store, records, index, eOpts) {
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {
            	
                UniAppManager.setToolbarButtons('save', false);
            },
            remove: function(store, record, index, isMove, eOpts) {
            }
        },
        loadStoreRecords: function() {
            var param = Ext.getCmp('panelResult').getValues();
            console.log( param );
            this.load({
                params: param
            });
        }
    }); 
	
	var panelResult = Unilite.createSearchForm('panelResult',{
        region: 'north',
        layout : {type : 'uniTable', columns : 2,
            tableAttrs: {width: '100%'},
            tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/width: '100%'}
        },
        padding:'1 1 1 1',
        border:true,
        items: [{
            xtype: 'container',
            layout : {type : 'uniTable'},
            tdAttrs: {width: 1000},    
            items:[{
                xtype: 'uniYearField',
                fieldLabel: '기준년도',
                name: 'MERITS_YEARS',
                allowBlank:false,
                width:250
            },{
                xtype: 'uniCombobox',
                fieldLabel: '구분',
                name: 'MERITS_GUBUN',
                comboType: 'AU',
                comboCode: 'H095',
                allowBlank: false,
                labelWidth: 180
            },{
                fieldLabel: '직렬',
                name:'AFFIL_CODE',
                xtype: 'uniCombobox',
                comboType: 'AU', 
                comboCode: 'H173',
                labelWidth: 180
            }]
        },{
            xtype: 'container',
            layout : {type : 'uniTable',columns:4},
            tdAttrs: {align : 'right',width: 1300},    
            items:[{
                xtype: 'button',
                itemId : 'refBtn1',
                text:'등급별인원수계산',
                tdAttrs: {align : 'left', width: 115},
                width:110,
                handler: function() {
                    if(Ext.isEmpty(panelResult.getValue('MERITS_YEARS'))){
                        return false;
                    }
                    UniAppManager.app.fnCalcRatingWin();
                }
             },{
                xtype: 'button',
                itemId : 'refBtn2',
                text:'평가대상자생성',
                tdAttrs: {align : 'left', width: 115},
                width:110,
                handler: function() {
                    if(!panelResult.getInvalidMessage()){
                        return false;
                    }
                    if(confirm('평가대상자생성시 기존데이터는 삭제됩니다. \n생성 하시겠습니까?')) {
                        Ext.getBody().mask('작업 중...','loading-indicator');
                            
                        var param= panelResult.getValues();
                            
                        hep930ukrService.personCreate(param, function(provider, response)  {
                            if(!Ext.isEmpty(provider)){
                            	if(provider == 'PN'){
                                    alert('평가대상자 인원수가 맞지 않습니다.');
                                }else if(provider == 'Y'){
                                    alert('평가대상자 생성을 성공 하였습니다.');
                                    
                                    detailStore.loadStoreRecords();
                                }else{
                                    alert('평가대상자 생성을 실패 하였습니다.');
                                }
                                Ext.getBody().unmask();
                            }
                        });
                    }
                }
             },{
                xtype: 'button',
                itemId : 'refBtn3',
                text:'평가점수계산',  //최종등급까지 생성됨
                tdAttrs: {align : 'left', width: 115},
                width:110,
                handler: function() {
                    if(!panelResult.getInvalidMessage()){
                        return false;
                    }
                    
                    var records = detailStore.data.items;
                    Ext.each(records, function(record, index) {
                    	record.set('UPDATE_DUMMY_FLAG','Y');
                    });
                    
                    if(confirm('평가점수계산시 기존데이터는 변경됩니다. \n계산 하시겠습니까?')) {
                        buttonFlag = 'refBtn3';
                        detailStore.saveStore();
                        
          /*              
                    var records = detailStore.data.items;
                    Ext.each(records, function(record, index) {
                    	if(baseCodeHE76_C_R1=='' || baseCodeHE76_C_R1==0 ||
                    	   baseCodeHE76_C_R4=='' || baseCodeHE76_C_R4==0){
                    	   	record.set('WORK_WEGH_POINT', 0);
                	   }else{
                    	
                            record.set('WORK_WEGH_POINT', record.get('WORK_POINT') * ((100/baseCodeHE76_C_R4) * (baseCodeHE76_C_R1/100)));
                            //점수*(환산점수*등급배분율)
                	   }
                    	   
                    	record.set('BSC_WEGH_POINT', record.get('BSC_POINT') * 0.3);
                    	
                    	if(baseCodeHE76_A_R1=='' || baseCodeHE76_A_R1==0 ||
                           baseCodeHE76_A_R4=='' || baseCodeHE76_A_R4==0){
                            record.set('MULTI_WEGH_POINT', 0);
                       }else{
                        
                            record.set('MULTI_WEGH_POINT', record.get('MULTI_POINT') * ((100/baseCodeHE76_A_R4) * (baseCodeHE76_A_R1/100)));
                            //점수*(환산점수*등급배분율)
                       }
                           record.set('LAST_EVAL_POINT', record.get('WORK_WEGH_POINT')+record.get('BSC_WEGH_POINT')+record.get('MULTI_WEGH_POINT'));
                    })
                    
//                    record.set('LAST_EVAL_POINT', record.get('WORK_WEGH_POINT')+record.get('BSC_WEGH_POINT')+record.get('MULTI_WEGH_POINT'));
//                    Ext.getBody().unmask();
                    }
//                    Ext.getBody().unmask();
*/                  
                    }else{
	                    var records = detailStore.data.items;
                        Ext.each(records, function(record, index) {
                            record.set('UPDATE_DUMMY_FLAG','');
                        });
                    }
                    buttonFlag = '';
                }
             },{
                xtype: 'button',
                itemId : 'refBtn4',
                text:'등급조정',//조정등급, 등급사유 업데이트                //text:'평가확정',
                tdAttrs: {align : 'left', width: 115},
                width:110,
                handler: function() {
                    if(!panelResult.getInvalidMessage()){
                        return false;
                    }
                    if(confirm('등급조정시 최종등급도 변경됩니다. \n등급조정 하시겠습니까?')) {
                        detailStore.saveStore();
                    }
                }
             }]
         },{
            xtype: 'container',
            layout : {type : 'uniTable'},
            tdAttrs: {width: 1100},    
            items:[
            Unilite.treePopup('DEPTTREE',{
                fieldLabel: '부서',
                valueFieldName:'DEPT',
                textFieldName:'DEPT_NAME' ,
                valuesName:'DEPTS' ,
                DBvalueFieldName:'TREE_CODE',
                DBtextFieldName:'TREE_NAME',
                selectChildren:true,
//                validateBlank:true,
                autoPopup:true,
                useLike:true,
                width:400,
                listeners: {
                    'onValuesChange':  function( field, records){
    //                            var tagfield = panelResult.getField('DEPTS') ;
    //                            tagfield.setStoreData(records)
                    }
                }
            }),
            Unilite.popup('Employee', {
                fieldLabel: '사번', 
                valueFieldName: 'PERSON_NUMB',
                textFieldName: 'NAME',
                labelWidth: 30
            }),{
                xtype: 'uniCombobox',
                fieldLabel: '직급',
                name: 'ABIL_CODE',
                store: Ext.data.StoreManager.lookup('abilCodeList'),
                labelWidth: 100
                
            }]
        }]
    });
	var detailGrid = Unilite.createGrid('hep930ukrGrid', {
        layout: 'fit',
        region: 'center',
        uniOpt: {
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: false,
            useMultipleSorting: false,
            onLoadSelectFirst: false,
            useRowNumberer: true,
            expandLastColumn: true,
            useRowContext: false,
            state: {
                useState: true,         
                useStateList: true      
            }
        },
        tbar: [{
            itemId: 'excelBtn',
            text: '엑셀참조',
            handler: function() {
                if(!panelResult.getInvalidMessage()){
                    return false;
                }
                openExcelWindow();
            }
        }],
        features: [{
            id: 'detailGridSubTotal', 
            ftype: 'uniGroupingsummary', 
            showSummaryRow: false
        },{
            id: 'detailGridTotal', 
            ftype: 'uniSummary', 
            showSummaryRow: false,
            dock:'bottom'
        }],
        store: detailStore,
        selModel:'rowmodel',
        columns: [
            { dataIndex: 'COMP_CODE'                ,width:100,hidden:true},
            { dataIndex: 'MERITS_YEARS'             ,width:100,hidden:true},
            { dataIndex: 'MERITS_GUBUN'             ,width:100,hidden:true},
            
            { dataIndex: 'RANK'                          ,width:60,align:'center'},
            { dataIndex: 'AFFIL_CODE'                    ,width:100,hidden:true},
            { dataIndex: 'AFFIL_NAME'                    ,width:80},
            { dataIndex: 'DEPT_CODE'                     ,width:100,hidden:true},
            { dataIndex: 'DEPT_NAME'                     ,width:200},
            { dataIndex: 'ABIL_CODE'                     ,width:100,hidden:true},
            { dataIndex: 'ABIL_NAME'                     ,width:100},
            { dataIndex: 'PERSON_NUMB'                   ,width:100},
            { dataIndex: 'NAME'                          ,width:80},
            { dataIndex: 'JOIN_DATE'                     ,width:100},
            
            {text:'근무평정', 
                columns:[
                    { dataIndex: 'WORK_POINT'                    ,width:100},
                    { dataIndex: 'WORK_WEGH_POINT'               ,width:100}
                
                ]
            },
            {text:'BSC', 
                columns:[
                    { dataIndex: 'BSC_POINT'                     ,width:100},
                    { dataIndex: 'BSC_WEGH_POINT'                ,width:100}
                ]
            },
            {text:'다면평가', 
                columns:[
                    { dataIndex: 'MULTI_POINT'                   ,width:100},
                    { dataIndex: 'MULTI_WEGH_POINT'              ,width:100}
                ]
            },
            
            { dataIndex: 'LAST_EVAL_POINT'               ,width:100},
            { dataIndex: 'MERITS_CLASS'                  ,width:100},
            { dataIndex: 'ADJU_MERITS_CLASS'             ,width:100},
            { dataIndex: 'ADJU_RESN'                     ,width:250},
            
            { dataIndex: 'UPDATE_DUMMY_FLAG'             ,width:100,hidden:true}
            
        ],
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
        		if( UniUtils.indexOf(e.field, ['WORK_POINT','BSC_POINT','MULTI_POINT','ADJU_MERITS_CLASS','ADJU_RESN'])){
        			return true;
        		}else{
        			return false;
        		}
        	}
        }
    });   

    
    Unilite.defineModel('calcRatingModel', {
        fields: [
        
            {name: 'COMP_CODE'          , text: '법인코드'  , type: 'string'},
            {name: 'MERITS_YEARS'       , text: '기준년도'  , type: 'string'},
            
            {name: 'ABIL_CODE'          , text: '직급코드'  , type: 'string'},
            {name: 'ABIL_NAME'          , text: '직급'     , type: 'string'},
            {name: 'GRADE_GUBUN'        , text: '등급코드'  , type: 'string'},
            {name: 'GRADE'              , text: '등급'     , type: 'string'},
            {name: 'TOTAL_PERSONNEL'    , text: '계'      , type: 'int'},
            
            {name: 'S_GRADE'            , text: baseNameHE44_S_SN                , type: 'uniNumber'},
            {name: 'A_GRADE'            , text: baseNameHE44_A_SN                , type: 'uniNumber'},
            {name: 'B_GRADE'            , text: baseNameHE44_B_SN                , type: 'uniNumber'},
            {name: 'C_GRADE'            , text: baseNameHE44_C_SN                , type: 'uniNumber'},
            {name: 'D_GRADE'            , text: baseNameHE44_D_SN                , type: 'uniNumber'}
     
        ]
    });
                
    var calcRatingStore = Unilite.createStore('calcRatingStore',{
    
        model: 'calcRatingModel',
        uniOpt : {
            isMaster: false,            // 상위 버튼 연결 
            editable: true,        // 수정 모드 사용 
            deletable: false,        // 삭제 가능 여부 
            useNavi: false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'uniDirect',
            api: {
                read: 'hep930ukrService.calcRatingSelectList'
               ,update: 'hep930ukrService.calcRatingUpdate'
               ,syncAll: 'hep930ukrService.calcRatingSaveAll'
            }
        },
        loadStoreRecords: function(){
        var param= calcRatingWindow.down('#search').getValues();
            console.log( param );
            this.load({
                params: param
            });
        },
        saveStore:function()    {
            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();                
            var toDelete = this.getRemovedRecords();
            var list = [].concat(toUpdate, toCreate);
            
            var inValidRecs = this.getInvalidRecords();
            console.log("inValidRecords : ", inValidRecs);
            if(inValidRecs.length == 0) {
                config = {
                            //params: [paramMaster],
                            success: function(batch, option) {
                                calcRatingWin.changes = true;
                                calcRatingWin.unmask();
                                calcRatingStore.loadStoreRecords();
                            }
                    };
                this.syncAllDirect(config);
            } else {
                calcRatingGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        }
    });

    var calcRatingGrid = Unilite.createGrid('calcRatingGrid', {
        layout : 'fit',
        store : calcRatingStore, 
        sortableColumns: false,
        itemId:'calcRatingGrid',
        uniOpt:{    
            expandLastColumn: false,    //마지막 컬럼 * 사용 여부
            useRowNumberer: false,        //첫번째 컬럼 순번 사용 여부
            useLiveSearch: false,        //찾기 버튼 사용 여부
            filter: {                    //필터 사용 여부
                useFilter: false,
                autoCreate: false
            },
            state: {
                useState: false,            //그리드 설정 버튼 사용 여부
                useStateList: false        //그리드 설정 목록 사용 여부
            }
        },
        tbar:[
            '->',
            {
                xtype:'button',
                itemId:'calcRatingWin-query',
                text:'배분기준조회',
                handler:function()    {
                    calcRatingStore.loadStoreRecords();
                }
            },{
                xtype:'button',
                text:'배분기준생성',
                itemId:'calcRatingWin-create',
                handler:function()    {
                    if(!calcRatingWindow.down('#search').getInvalidMessage()){
                        return false;
                    }
                     if(confirm('배분기준 생성시 기존데이터는 삭제됩니다. \n생성 하시겠습니까?')) {
                        Ext.getBody().mask('작업 중...','loading-indicator');
                           
                        
                        var param= calcRatingWindow.down('#search').getValues();
                            
                        hep930ukrService.calcRatingCreate(param, function(provider, response)  {
                            if(!Ext.isEmpty(provider)){
                                if(provider == 'Y'){
                                    alert('배분기준 생성을 성공 하였습니다.');
                                    
                                    calcRatingStore.loadStoreRecords();
                                }else{
                                    alert('배분기준 생성을 실패 하였습니다.');
                                }
                                Ext.getBody().unmask();
                            }
                        });
                    }
                }
            }
        ],
        columns: [
            {dataIndex: 'COMP_CODE'               , width: 100,hidden:true},
            {dataIndex: 'MERITS_YEARS'            , width: 100,hidden:true},
            {dataIndex: 'ABIL_CODE'               , width: 100,hidden:true},
            {dataIndex: 'ABIL_NAME'               , width: 100},
            {dataIndex: 'GRADE_GUBUN'             , width: 100,hidden:true},
            {dataIndex: 'GRADE'                   , width: 100},
            {dataIndex: 'TOTAL_PERSONNEL'         , width: 100},
            {dataIndex: 'S_GRADE'                 , width: 100},
            {dataIndex: 'A_GRADE'                 , width: 100},
            {dataIndex: 'B_GRADE'                 , width: 100},
            {dataIndex: 'C_GRADE'                 , width: 100},
            {dataIndex: 'D_GRADE'                 , width: 100}
        ],
        listeners:{
            beforeedit:function(editor, context, eOpts) {
                if(context.record.data.GRADE_GUBUN == '2'){
                    if( UniUtils.indexOf(context.field, ['COMP_CODE','MERITS_YEARS','ABIL_CODE','ABIL_NAME','GRADE_GUBUN','GRADE','TOTAL_PERSONNEL'])){
                        return false;
                    }else{
                        return true;
                    }
                }else{
                    return false;
                }
            },
            edit:function(editor, context, eOpts){
            
            }
        }
    });
                
    Unilite.Main( {
    	borderItems:[{
            region: 'center',
            layout: {type: 'vbox', align: 'stretch'},
            border: false,
            autoScroll: true,
            id:'pageAll',
            items: [
            	panelResult, detailGrid
            ]
        }],
		id  : 'hep930ukrApp',
		fnInitBinding: function(){
            UniAppManager.app.fnInitInputFields();
			UniAppManager.setToolbarButtons(['save','print','newData'], false);
            UniAppManager.setToolbarButtons(['reset'], true);
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return;   //필수체크
			panelResult.getField('MERITS_YEARS').setReadOnly(true);//조회 버튼 클릭 시 기준년도 콤보 readOnly true
			panelResult.getField('MERITS_GUBUN').setReadOnly(true);//조회 버튼 클릭 시 구분 콤보 readOnly true
            detailStore.loadStoreRecords();
		},
//		onSaveDataButtonDown: function() {
////            detailStore.saveStore();
//        },
		onResetButtonDown: function() {
            panelResult.clearForm();
			detailGrid.reset();
			detailStore.clearData();
			UniAppManager.app.fnInitBinding();
		},
		fnInitInputFields: function(){
			panelResult.setValue('MERITS_YEARS',new Date().getFullYear());
            panelResult.getField('MERITS_YEARS').setReadOnly(false);
            panelResult.getField('MERITS_GUBUN').setReadOnly(false);
            
            panelResult.down('#refBtn3').setDisabled(true);
            panelResult.down('#refBtn4').setDisabled(true);
            
            detailGrid.down('#excelBtn').setDisabled(true);
		},
		
		
		fnCalcRatingWin: function(){
            if(!calcRatingWindow) {
                calcRatingWindow = Ext.create('widget.uniDetailWindow', {
                    title: '등급별인원수계산',
                    width: 1100,                                
                    height:500,
                    
                    layout: {type:'vbox', align:'stretch'},                    
                    items: [{
                        itemId:'search',
                        xtype:'uniSearchForm',
                         style:{
                            'background':'#fff'
                        },
                        height:100,
                        layout:{
                            type:'uniTable', columns:2,
                            tableAttrs: {width: '100%'},
                            tdAttrs: {width: '100%'}
                        },
                        margine:'3 3 3 3',
                        items:[{
                            xtype: 'container',
                            layout: {type: 'uniTable', columns: 2
//                                tableAttrs: {style: 'border : 0.1px solid #bdcfe6;', width: '100%'},
//                                tdAttrs: {style: 'border : 0.1px solid #bdcfe6; background-color: #e8edf5;',  align : 'right'}
//                                tdAttrs:{align : 'right'}
                            },
                            items: [{
                                xtype: 'uniYearField',
                                fieldLabel: '기준년도',
                                name: 'MERITS_YEARS',
                                allowBlank:false,
                                width:250
                            },{
                                xtype: 'uniCombobox',
                                fieldLabel: '직급',
                                name: 'ABIL_CODE',
                                store: Ext.data.StoreManager.lookup('abilCodeList')
                            }]
                        },{
                            xtype: 'container',
                            layout: {type: 'uniTable', columns: 1
//                                tableAttrs: {style: 'border : 0.1px solid #bdcfe6;', width: '100%'},
//                                tdAttrs: {style: 'border : 0.1px solid #bdcfe6; background-color: #e8edf5;',  align : 'right'}
//                                tdAttrs:{align : 'right'}
                            },
                            items: [{
                                title:'배분율',
                                xtype: 'fieldset',
                                layout: {type : 'uniTable', columns : 6,
                                    tableAttrs: { width: '100%'},
                                  tdAttrs: {align : 'center', width: '100%'}
                                },
                                items: [
                                    { xtype: 'displayfield',width: 80,/*minWidth:80,maxWidth:150,*/ value:'등급&nbsp;&nbsp;&nbsp;: '},
                                    
                                    {xtype: 'displayfield',name: '', width: 80, value:baseNameHE44_S_SN},
                                    {xtype: 'displayfield',name: '', width: 80, value:baseNameHE44_A_SN},
                                    {xtype: 'displayfield',name: '', width: 80, value:baseNameHE44_B_SN},
                                    {xtype: 'displayfield',name: '', width: 80, value:baseNameHE44_C_SN},
                                    {xtype: 'displayfield',name: '', width: 80, value:baseNameHE44_D_SN},
                                    
                                    
                                    
                                    
                                    { xtype: 'displayfield',width: 80,/*minWidth:80,maxWidth:150,*/ value:'비율&nbsp;&nbsp;&nbsp;: '},
                                    
                                    {xtype: 'displayfield',name: '', width: 80, value:baseNameHE44_S_R4},
                                    {xtype: 'displayfield',name: '', width: 80, value:baseNameHE44_A_R4},
                                    {xtype: 'displayfield',name: '', width: 80, value:baseNameHE44_B_R4},
                                    {xtype: 'displayfield',name: '', width: 80, value:baseNameHE44_C_R4},
                                    {xtype: 'displayfield',name: '', width: 80, value:baseNameHE44_D_R4}
                                ]
                            }]
                        }]
                    },{
                        xtype:'container',
                        flex:1,
                        layout: {type:'vbox', align:'stretch'},
                        items:[
                            calcRatingGrid
                        ]}
                    ],
                    bbar:{
                        layout: {
                            pack: 'center',
                            type: 'hbox'
                        },
                        dock:'bottom',
                        items : [{
                            itemId : 'submitBtn',
                            text: '저장',
                            width:100,
                            handler: function() {
                                var store = Ext.data.StoreManager.lookup('calcRatingStore') ;
                                if(store.isDirty())    {
                                    store.saveStore();
                                }
                            },
                            disabled: false
                        },{
                            itemId : 'closeBtn',
                            text: '닫기',
                            width:100,
                            handler: function() {
                                calcRatingWindow.hide();
                                
                            },
                            disabled: false
                        }]
                    },
                    listeners : {
                        beforehide: function(me, eOpt) {
                        	calcRatingWindow.down('#search').setValue('ABIL_CODE','');
                            calcRatingGrid.reset();
                            calcRatingStore.clearData();
                        },
                        beforeclose: function( panel, eOpts ) {
                        },
                        beforeshow: function( panel, eOpts ) {
                            calcRatingWindow.down('#search').setValue('MERITS_YEARS',panelResult.getValue('MERITS_YEARS'));
                        }
                    }        
                });
            }
            calcRatingWindow.center();
            calcRatingWindow.show();
        }
	});
	Unilite.createValidator('validatorSub', {
        store: calcRatingStore,
        grid: calcRatingGrid,
        validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
            var rv = true;
            switch(fieldName) {
                case "S_GRADE":
                    if(newValue + record.get('A_GRADE') + record.get('B_GRADE') + record.get('C_GRADE') + record.get('D_GRADE') > record.get('TOTAL_PERSONNEL')){
                        alert("적용인원이 맞지 않습니다.");
                        rv= false;
                        break;
                    }
                break; 
                case "A_GRADE":
                    if(newValue + record.get('S_GRADE') + record.get('B_GRADE') + record.get('C_GRADE') + record.get('D_GRADE') > record.get('TOTAL_PERSONNEL')){
                        alert("적용인원이 맞지 않습니다.");
                        rv= false;
                        break;
                    }
                break; 
                case "B_GRADE":
                    if(newValue + record.get('S_GRADE') + record.get('A_GRADE') + record.get('C_GRADE') + record.get('D_GRADE') > record.get('TOTAL_PERSONNEL')){
                        alert("적용인원이 맞지 않습니다.");
                        rv= false;
                        break;
                    }
                break; 
                case "C_GRADE":
                    if(newValue + record.get('S_GRADE') + record.get('A_GRADE') + record.get('B_GRADE') + record.get('D_GRADE') > record.get('TOTAL_PERSONNEL')){
                        alert("적용인원이 맞지 않습니다.");
                        rv= false;
                        break;
                    }
                break; 
                case "D_GRADE":
                    if(newValue + record.get('S_GRADE') + record.get('A_GRADE') + record.get('B_GRADE') + record.get('C_GRADE') > record.get('TOTAL_PERSONNEL')){
                        alert("적용인원이 맞지 않습니다.");
                        rv= false;
                        break;
                    }
                break;
            }
            return rv;
        }
    });
	
	Unilite.createValidator('validator01', {
        store: detailStore,
        grid: detailGrid,
        validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
            var rv = true;
            var records = detailStore.data.items;
            switch(fieldName) {
            	
                case "WORK_MMCNT1" : //근무일수1
                    var param= {
                        "U_DEPT_CODE" : record.get('DEPT_CODE1')
                        ,"U_DAY" : newValue
                        ,"EVAL_YEARS" : record.get('EVAL_YEARS')
                    }
                    
                    hep930ukrService.operSelect(param, function(provider, response){
                        if(!Ext.isEmpty(provider)){
                            record.set('DEPT_POINT1',provider);
                        }else{
                            record.set('DEPT_POINT1',0.00);	
                        }
                        
                        record.set('LAST_POINT',record.get('DEPT_POINT1')+ record.get('DEPT_POINT2') + record.get('DEPT_POINT3') + record.get('DEPT_POINT4') + record.get('DEPT_POINT5'));
                        
                    });
                break;
                
                case "WORK_MMCNT2" : //근무일수2
                    var param= {
                        "U_DEPT_CODE" : record.get('DEPT_CODE2')
                        ,"U_DAY" : newValue
                        ,"EVAL_YEARS" : record.get('EVAL_YEARS')
                    }
                    
                    hep930ukrService.operSelect(param, function(provider, response){
                        if(!Ext.isEmpty(provider)){
                            record.set('DEPT_POINT2',provider);
                        }else{
                            record.set('DEPT_POINT2',0.00); 
                        }
                        record.set('LAST_POINT',record.get('DEPT_POINT1')+ record.get('DEPT_POINT2') + record.get('DEPT_POINT3') + record.get('DEPT_POINT4') + record.get('DEPT_POINT5'));
                    });
                break;
                
                case "WORK_MMCNT3" : //근무일수3
                    var param= {
                        "U_DEPT_CODE" : record.get('DEPT_CODE3')
                        ,"U_DAY" : newValue
                        ,"EVAL_YEARS" : record.get('EVAL_YEARS')
                    }
                    
                    hep930ukrService.operSelect(param, function(provider, response){
                        if(!Ext.isEmpty(provider)){
                            record.set('DEPT_POINT3',provider);
                        }else{
                            record.set('DEPT_POINT3',0.00); 
                        }
                        record.set('LAST_POINT',record.get('DEPT_POINT1')+ record.get('DEPT_POINT2') + record.get('DEPT_POINT3') + record.get('DEPT_POINT4') + record.get('DEPT_POINT5'));
                    });
                break;
                
                case "WORK_MMCNT4" : //근무일수4
                    var param= {
                        "U_DEPT_CODE" : record.get('DEPT_CODE4')
                        ,"U_DAY" : newValue
                        ,"EVAL_YEARS" : record.get('EVAL_YEARS')
                    }
                    
                    hep930ukrService.operSelect(param, function(provider, response){
                        if(!Ext.isEmpty(provider)){
                            record.set('DEPT_POINT4',provider);
                        }else{
                            record.set('DEPT_POINT4',0.00); 
                        }
                        record.set('LAST_POINT',record.get('DEPT_POINT1')+ record.get('DEPT_POINT2') + record.get('DEPT_POINT3') + record.get('DEPT_POINT4') + record.get('DEPT_POINT5'));
                    });
                break;
                
                case "WORK_MMCNT5" : //근무일수5
                    var param= {
                        "U_DEPT_CODE" : record.get('DEPT_CODE5')
                        ,"U_DAY" : newValue
                        ,"EVAL_YEARS" : record.get('EVAL_YEARS')
                    }
                    
                    hep930ukrService.operSelect(param, function(provider, response){
                        if(!Ext.isEmpty(provider)){
                            record.set('DEPT_POINT5',provider);
                        }else{
                            record.set('DEPT_POINT5',0.00); 
                        }
                        record.set('LAST_POINT',record.get('DEPT_POINT1')+ record.get('DEPT_POINT2') + record.get('DEPT_POINT3') + record.get('DEPT_POINT4') + record.get('DEPT_POINT5'));
                    });
                break;
            }
            return rv;
        }
    });
};
</script>
