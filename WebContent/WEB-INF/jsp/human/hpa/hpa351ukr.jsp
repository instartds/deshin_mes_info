<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa351ukr"  >
    <t:ExtComboStore comboType="BOR120"  />                                     <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="H005" />                         <!-- 직위코드 -->
    <t:ExtComboStore comboType="AU" comboCode="H011" />                         <!-- 고용형태 -->
    <t:ExtComboStore comboType="AU" comboCode="H024" />                         <!-- 사원구분 -->
    <t:ExtComboStore comboType="AU" comboCode="H028" />                         <!-- 급여지급방식 -->
    <t:ExtComboStore comboType="AU" comboCode="H031" />                         <!-- 지급일구분 -->
    <t:ExtComboStore comboType="AU" comboCode="H032" opts= '${gsList1}' />      <!-- 지급구분 -->
    <t:ExtComboStore comboType="AU" comboCode="H153" />                         <!-- 마감여부 -->
    <t:ExtComboStore comboType="AU" comboCode="H181" />                         <!-- 사원그룹 -->
    
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
    
    var gsList1 = '${gsList1}';
    var colData = ${colData};
//  console.log(colData);
    var fields = createModelField(colData);
    var columns = createGridColumn(colData);
    

    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read    : 'hpa351ukrService.selectList',
            update  : 'hpa351ukrService.updateList',
            destroy : 'hpa351ukrService.deleteList',
            syncAll : 'hpa351ukrService.saveAll'
        }
    }); 
    
    /*   Model 정의 
     * @type 
     */
    Unilite.defineModel('Hpa351ukrModel', {
        fields : fields
    });
    
    // GroupField string type으로 변환
    function dateToString(v, record){
        return UniDate.safeFormat(v);
      }
      
    /* Store 정의(Service 정의)
     * @type 
     */                 
    var masterStore = Unilite.createStore('hpa351ukrMasterStore',{
        model: 'Hpa351ukrModel',
        uniOpt: {
            isMaster    : true,         // 상위 버튼 연결 
            editable    : true,         // 수정 모드 사용 
            deletable   : true,         // 삭제 가능 여부 
            useNavi     : false         // prev | newxt 버튼 사용
        },
        autoLoad        : false,
        proxy           :directProxy,
        loadStoreRecords: function()    {
            var param= Ext.getCmp('resultForm').getValues();            
                console.log( param );
            this.load({
                params : param
            });
        },
        saveStore: function() {
            var inValidRecs = this.getInvalidRecords();
            var toUpdate = this.getUpdatedRecords();                
            var toDelete = this.getRemovedRecords();
            console.log("toUpdate",toUpdate);
            
            var rv = true;
            
            if(inValidRecs.length == 0 )    {                                       
                config = {
                    params:[panelResult.getValues()],
                    success: function(batch, option) {                              
                        panelResult.resetDirtyStatus();
                        UniAppManager.setToolbarButtons('save', false);         
                        masterStore.loadStoreRecords();
                     } 
                };                  
                this.syncAllDirect(config);
            }else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners : {
            load:function( store, records, successful, operation, eOpts ){
                //조회된 데이터가 있을 때, 합계 보이게 설정 변경
                var viewNormal = masterGrid.getView();
                if (store.getCount() > 0) {
                    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
                    Ext.getCmp('resultForm').getForm().findField('PAY_YYYYMM').setReadOnly(true);
                    UniAppManager.setToolbarButtons('deleteAll', true);
                } else {
                    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);   
                }
            }
        }
    });
    

    /* 검색조건 (Search Panel)
     * @type 
     */   
    
    var panelResult = Unilite.createSearchForm('resultForm',{
        hidden: !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 4
//      ,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//          tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
        },
        padding:'1 1 1 1',
        border:true,
        items: [{
            fieldLabel: '사업장',
            name:'DIV_CODE', 
            xtype: 'uniCombobox', 
            comboType:'BOR120',
            tdAttrs: {width: 380}
        },{
            fieldLabel: '급여지급년월',
            xtype: 'uniMonthfield',
            allowBlank:false,
            name: 'PAY_YYYYMM',
            value: UniDate.get('startOfMonth'),
//          colspan: 2,
            tdAttrs: {width: 380}
        },{
            fieldLabel: '지급구분',
            name:'SUPP_TYPE',   
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode:'H032',
            tdAttrs: {width: 380},  
            allowBlank:false,
            value: 1,
            colspan: 2
        },{
            fieldLabel: '부서',
            name: 'DEPTS2',
            xtype: 'uniCombobox',
            width:300,
            multiSelect: true,
            store:  Ext.data.StoreManager.lookup('authDeptsStore'),
            disabled:true,
            hidden:false,
            allowBlank:false
        },
        Unilite.treePopup('DEPTTREE',{
            itemId: 'deptstree',
            fieldLabel: '부서',
            valueFieldName:'DEPT',
            textFieldName:'DEPT_NAME' ,
            valuesName:'DEPTS' ,
            DBvalueFieldName:'TREE_CODE',
            DBtextFieldName:'TREE_NAME',
            selectChildren:true,
//          textFieldWidth:89,
//          textFieldWidth: 159,
            validateBlank:true,
//          width:300,
            autoPopup:true,
            useLike:true
        }),
            Unilite.popup('Employee',{
            fieldLabel : '사원',
            valueFieldName:'PERSON_NUMB',
            textFieldName:'NAME'
        }),{
            fieldLabel: '고용형태',
            name:'PAY_GUBUN',   
            xtype: 'uniCombobox', 
            comboType:'AU',
            comboCode:'H011'
        },{
            xtype: 'container',
            layout: {type : 'hbox'},
            tdAttrs: {width: 180},  
            items :[{
                xtype: 'radiogroup',
                fieldLabel: '',
                itemId: 'RADIO2',
                labelWidth: 35,
                items: [{
                    boxLabel: '전체', 
                    width: 50,
                    name: 'rdoSelect' , 
                    inputValue: '', 
                    checked: true
                },{
                    boxLabel: '일반',
                    width: 50, 
                    name: 'rdoSelect' ,
                    inputValue: '2'
                },{
                    boxLabel: '일용', 
                    width: 50, 
                    name: 'rdoSelect' ,
                    inputValue: '1'                 
                }]
            }]
        },{
            fieldLabel: '지급차수',
            name:'PAY_PROV_FLAG',   
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'H031'
        }, {
            fieldLabel: '급여지급방식',
            name:'PAY_CODE',    
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'H028',
            colspan: 3
        },{
            xtype: 'radiogroup',                            
            fieldLabel: '세액계산',
            name : 'CALC_TAX_YN',
            items : [{
                boxLabel: '한다',
                width: 50,
                name : 'CALC_TAX_YN',
                checked: true,
                inputValue: 'Y'
            },{
                boxLabel: '안한다',
                width: 60,
                name : 'CALC_TAX_YN',
                inputValue: 'N'
            }]
        },{
            xtype: 'radiogroup',                            
            fieldLabel: '고용보험계산',
            name : 'CALC_HIR_YN',
            items : [{
                boxLabel: '한다',
                width: 50,
                name : 'CALC_HIR_YN',
                checked: true,
                inputValue: 'Y'
            },{
                boxLabel: '안한다',
                width: 60,
                name : 'CALC_HIR_YN',
                inputValue: 'N'}
        ]},{
            xtype: 'radiogroup',                            
            fieldLabel: '산재보험계산',
            name : 'CALC_IND_YN',
            items : [{
                boxLabel: '한다',
                width: 50,
                name : 'CALC_IND_YN',
                checked: true,
                inputValue: 'Y'
            },{
                boxLabel: '안한다',
                width: 60,
                name : 'CALC_IND_YN',
                inputValue: 'N',
                listeners: {
                    specialkey: function(field, event){
                        if(event.getKey() == event.ENTER){
                            UniAppManager.app.onQueryButtonDown();
                        }
                    }
                }
            }]
        }]
    });
    
    /* Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hpa351ukrGrid1', {
        layout  : 'fit',
        region  : 'center',
        store   : masterStore,
        columns : columns,
        uniOpt : {
            useMultipleSorting  : true,     
            useLiveSearch       : false,    
            onLoadSelectFirst   : true,         //체크박스모델은 false로 변경
            dblClickToEdit      : true, 
            useGroupSummary     : false,    
            useContextMenu      : false,    
            useRowNumberer      : true, 
            expandLastColumn    : false,        
            useRowContext       : true,         // rink 항목이 있을경우만 true
            filter: {
                useFilter   : false,    
                autoCreate  : true  
            }           
        },
        features: [{
            id: 'masterGridSubTotal', 
            ftype: 'uniGroupingsummary',
            showSummaryRow: true 
        },{
            id : 'masterGridTotal',     
            ftype: 'uniSummary',
            dock : 'top',
            showSummaryRow: true
        }],
        listeners:{
            beforeedit  : function( editor, e, eOpts ) {
                var record = masterGrid.getSelectedRecord();
                if(record.get('CLOSE_YN') == 'Y'){
                        return false;
                } else  {
                    if(UniUtils.indexOf(e.field, ['GUBUN', 'SUPP_TYPE', 'COMP_CODE', 'DIV_CODE', 'DEPT_CODE', 'DEPT_NAME', 'POST_CODE', 'NAME', 'PERSON_NUMB', 'PAY_YYYYMM', 'JOIN_DATE', 'SUPP_TOTAL_I', 'DED_TOTAL_I', 'REAL_AMOUNT_I'])){
                        return false;
                    } else {
                        return true;
                    }
                }
            }
        },
        onItemcontextmenu:function( menu, grid, record, item, index, event  )   {               
            //menu.showAt(event.getXY());
            return true;
        },
        uniRowContextMenu:{
            items: [
                {   text    : '급여조회및조정 보기',   
                    itemId  : 'linkHpa330ukr',
                    handler : function(menuItem, event) {
                        var record = masterGrid.getSelectedRecord();
                        var param = {
                            'PGM_ID'        : 'hpa351ukr',
                            'PAY_YYYYMM'    : panelResult.getValue('PAY_YYYYMM'),
                            'PERSON_NUMB'   : record.data['PERSON_NUMB'],
                            'NAME'          : record.data['NAME'],
                            'SUPP_TYPE'     : panelResult.getValue('SUPP_TYPE')
                        };
                        masterGrid.gotoHpa330ukr(param);
                    }
                }
            ]
        },
        gotoHpa330ukr:function(record)  {
            if(record)  {
                var params = record
            }
            var rec1 = {data : {prgID : 'hpa330ukr', 'text':''}};                           
            parent.openTab(rec1, '/human/hpa330ukr.do', params);
        }
    });
    
    Unilite.Main( {
        border: false,
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                masterGrid, panelResult
            ]   
        }], 
        id: 'hpa351ukrApp',
        
        fnInitBinding: function() {
            UniHuman.deptAuth(UserInfo.deptAuthYn, panelResult, "deptstree", "DEPTS2");
            
            var radio2 = panelResult.down('#RADIO2');
            radio2.hide();
            radio2.setValue('');

            /*masterGrid.on('edit', function(editor, e) {
                var record = e.grid.getSelectionModel().getSelection()[0];
                var supp_type_value = Ext.getCmp('SUPP_TYPE').getValue();
                record.set('GUBUN', 'U');
                record.set('SUPP_TYPE', supp_type_value);
            });*/
            
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            
            UniAppManager.setToolbarButtons(['newData','save'],false);
        
            panelResult.onLoadSelectText('DIV_CODE');
        },
        onQueryButtonDown : function() {
            if(!panelResult.getInvalidMessage()) return;
                // query 작업
                masterGrid.reset();
                var viewNormal = masterGrid.getView();
                viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
                masterGrid.getStore().loadStoreRecords();
        },
        onResetButtonDown:function () { 
            panelResult.clearForm();            
            masterGrid.getStore().loadData({});             
            this.fnInitBinding();
        
        },
        onDeleteDataButtonDown : function() {
            if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                masterGrid.deleteSelectedRow();
            }
        },
        onSaveDataButtonDown: function() {
            masterStore.saveStore();
        },
        onDeleteAllButtonDown : function() {
            Ext.Msg.confirm('삭제', '전체행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
                if (btn == 'yes') {
                    masterStore.removeAll();
                }
            });
        } 
    });
    // Grid 의 summary row의  표시 /숨김 적용
    function setGridSummary(viewable){
        if (masterStore.getCount() > 0) {
            var viewNormal = masterGrid.getView();
            if (viewable) {
                viewNormal.getFeature('masterGridTotal').enable();
                viewNormal.getFeature('masterGridSubTotal').enable();
           } else {
                viewNormal.getFeature('masterGridTotal').disable();
                viewNormal.getFeature('masterGridSubTotal').disable();
           }
           viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(viewable);
           viewNormal.getFeature('masterGridTotal').toggleSummaryRow(viewable);
            
           masterGrid.getView().refresh();  
        }
    }
    
    // 모델 필드 생성
    function createModelField(colData) {
        var fields = [
            {name: 'GUBUN'              , text: '구분값'           , type:'string', defaultValue: 'D'},
            {name: 'SUPP_TYPE'          , text: '지급구분'          , type:'string'},
            {name: 'DIV_CODE'           , text: '사업장'           , type:'string', comboType:'BOR120'},
            {name: 'CLOSE_YN'           , text: '개인별마감'         , type:'string', comboType:'AU', comboCode:'H153'},
            {name: 'COMP_CODE'          , text: '법인코드'          , type:'string'},
            {name: 'DEPT_CODE'          , text: '부서코드'          , type:'string'},
            {name: 'DEPT_NAME'          , text: '부서명'           , type:'string'},
            {name: 'POST_CODE'          , text: '직위'            , type:'string', comboType:'AU', comboCode:'H005'},
            {name: 'NAME'               , text: '성명'            , type:'string'},
            {name: 'PERSON_NUMB'        , text: '사번'            , type:'string'},
            {name: 'JOIN_DATE'          , text: '입사일'           , type:'string'},
            {name: 'PAY_YYYYMM'         , text: '급여지급년월'        , type:'string'},
            {name: 'SUPP_TOTAL_I'       , text: '지급총액'          , type:'uniPrice'},
            {name: 'DED_TOTAL_I'        , text: '공제총액'          , type:'uniPrice'},
            {name: 'REAL_AMOUNT_I'      , text: '실지급액'          , type:'uniPrice'},
            {name: 'PAY_CODE'           , text: '급여지급방식'        , type:'string'},
            {name: 'PAY_PROV_FLAG'      , text: '지급차수'          , type:'string'},
            {name: 'SUPP_DATE'          , text: '급여지급일'     , type:'string'}
            
        ];
        Ext.each(colData, function(item, index){
        //    if (index == 0) return '';
            fields.push({name: item.WAGES_CODES, text: item.WAGES_NAME, type:'uniPrice' });     
        });
        console.log(fields);
        return fields;
    }
    
    // 그리드 컬럼 생성
    function createGridColumn(colData) {
        var columns = [
/*          {dataIndex: 'GUBUN'                        , locked: false, hidden:true},
            {dataIndex: 'SUPP_TYPE'                    , locked: false, hidden:true},
            {dataIndex: 'COMP_CODE',        width: 100,  locked: false, hidden:true},*/
//          {dataIndex: 'CLOSE_YN',         width: 75,   locked: false, 
            {dataIndex: 'CLOSE_YN',         width: 75,   locked: false,  hidden:true,
            //원하는 컬럼 위치에 소계, 총계 타이틀 넣는다.
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '합계', '합계');
            }},
            {dataIndex: 'DIV_CODE',         width: 120,  locked: false},
            {dataIndex: 'DEPT_CODE',        width: 80,   locked: false},
            {dataIndex: 'DEPT_NAME',        width: 100,  locked: false},
            {dataIndex: 'POST_CODE',        width: 80,   locked: false},
            {dataIndex: 'NAME',             width: 80,   locked: false},
            {dataIndex: 'PERSON_NUMB',      width: 80,   locked: false},
//          {dataIndex: 'PAY_YYYYMM',       width: 80,   locked: false, hidden: true},
            {dataIndex: 'JOIN_DATE',        width: 80,   locked: false},
            {dataIndex: 'SUPP_TOTAL_I',     width: 100,  locked: false, align : 'right',    summaryType: 'sum'},
            {dataIndex: 'DED_TOTAL_I',      width: 100,  locked: false, align : 'right',    summaryType: 'sum'},
            {dataIndex: 'REAL_AMOUNT_I',    width: 100,  locked: false, align : 'right',    summaryType: 'sum'}
        ];
        Ext.each(colData, function(item, index){
            //if (index == 0) return '';
            columns.push({dataIndex: item.WAGES_CODES,  width: 110, align : 'right',  summaryType: 'sum'});
        });
//      console.log(columns);
        return columns;
    }
};


</script>
