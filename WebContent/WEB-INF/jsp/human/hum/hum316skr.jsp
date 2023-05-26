<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum316skr"  >
    <t:ExtComboStore comboType="BOR120"    pgmId="hum316skr"/>             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="H177" />                 <!-- 자/타사구분 -->
    <t:ExtComboStore comboType="AU" comboCode="H011" />                 <!-- 고용형태 -->
    <t:ExtComboStore comboType="AU" comboCode="H024" />                 <!-- 사원구분 -->
    <t:ExtComboStore comboType="AU" comboCode="H028" />                 <!-- 급여지급방식 -->
    <t:ExtComboStore comboType="AU" comboCode="H031" />                 <!-- 급여지급차수 -->
    <t:ExtComboStore comboType="AU" comboCode="H181" />                 <!-- 사원그룹 -->
    <t:ExtComboStore comboType="AU" comboCode="H005" />                 <!-- 직위 -->
    <t:ExtComboStore comboType="AU" comboCode="H163" />                 <!-- 인정경력구분 -->
    <t:ExtComboStore items="${COMBO_HUMAN_COST_POOL}" storeId="getHumanCostPool" />    <!--사업명-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {
    var gsCostPool = '${CostPool}';  // H175 subCode 10의 Y/N 에 따라 값이 바뀜
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('Hum316skrModel', {
        fields: [
            {name: 'COMP_CODE'              ,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'            ,type:'string'},
            {name: 'DIV_CODE'              		,text:'<t:message code="system.label.human.division" default="사업장"/>'          ,type:'string' , comboType:'BOR120'},
            {name: 'DEPT_NAME'               	,text:'<t:message code="system.label.human.department" default="부서"/>'                ,type:'string'},
            {name: 'POST_CODE'              	,text:'<t:message code="system.label.human.postcode" default="직위"/>'                ,type:'string'},
            {name: 'NAME'                    		,text:'<t:message code="system.label.human.name" default="성명"/>'                ,type:'string'},
            {name: 'PERSON_NUMB'          ,text:'<t:message code="system.label.human.personnumb" default="사번"/>'                ,type:'string'},
            {name: 'CARR_STRT_DATE'       ,text:'<t:message code="system.label.human.carrstrtdate1" default="근무시작일"/>'            ,type:'uniDate'},
            {name: 'CARR_END_DATE'        ,text:'<t:message code="system.label.human.carrenddate1" default="근무종료일"/>'            ,type:'uniDate'},
            {name: 'COMP_GUBUN'            ,text:'<t:message code="system.label.human.compgubun1" default="자타사구분"/>'            ,type:'string' },
            {name: 'COMP_NAME'              ,text:'<t:message code="system.label.human.compname" default="회사명"/>'            ,type:'string'},
            {name: 'POST_NAME'                ,text:'<t:message code="system.label.human.postname" default="직위명"/>'            ,type:'string' },
            {name: 'OCPT_NAME'                ,text:'<t:message code="system.label.human.ocpt" default="직종"/>'                ,type:'string'},
            {name: 'DEPT_NAME2'              ,text:'<t:message code="system.label.human.department" default="부서"/>'                ,type:'string'},
            {name: 'JOB_NAME'                	,text:'<t:message code="system.label.human.jobname" default="담당업무명"/>'            ,type:'string'},
            {name: 'CARR_GUBUN'             ,text:'<t:message code="system.label.human.carrgubun" default="인정경력구분"/>'        ,type:'string' }
            
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                    
    var directMasterStore1 = Unilite.createStore('hum316skrMasterStore1',{
            model: 'Hum316skrModel',
            uniOpt : {
                isMaster: true,            // 상위 버튼 연결 
                editable: false,            // 수정 모드 사용 
                deletable:false,            // 삭제 가능 여부 
                useNavi : false            // prev | newxt 버튼 사용
               
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {            
                       read: 'hum316skrService.selectList'                    
                }
            }
            ,loadStoreRecords : function()    {
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
        title: '<t:message code="system.label.human.searchconditon" default="검색조건"/>',         
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
            title: '<t:message code="system.label.human.basisinfo" default="기본정보"/>',   
            itemId: 'search_panel1',
            layout : {type : 'uniTable', columns : 1},
            items:[{
                fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
                name:'DIV_CODE', 
                xtype: 'uniCombobox',
                multiSelect: true, 
                typeAhead: false,
                comboType:'BOR120',
                width: 325,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('DIV_CODE', newValue);
                    }
                }
            },
            Unilite.treePopup('DEPTTREE',{
                fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
                valueFieldName:'DEPT',
                textFieldName:'DEPT_NAME' ,
                valuesName:'DEPTS' ,
                DBvalueFieldName:'TREE_CODE',
                DBtextFieldName:'TREE_NAME',
                selectChildren:true,
                textFieldWidth:89,
                validateBlank:true,
                width:300,
                autoPopup:true,
                useLike:true,
                listeners: {
                    'onValueFieldChange': function(field, newValue, oldValue  ){
                            panelResult.setValue('DEPT',newValue);
                    },
                    'onTextFieldChange':  function( field, newValue, oldValue  ){
                            panelResult.setValue('DEPT_NAME',newValue);
                    },
                    'onValuesChange':  function( field, records){
                            var tagfield = panelResult.getField('DEPTS') ;
                            tagfield.setStoreData(records)
                    }
                }
            }),  
                Unilite.popup('Employee',{
                fieldLabel: '<t:message code="system.label.human.employee" default="사원"/>',
                  valueFieldName:'PERSON_NUMB',
                textFieldName:'NAME',
                validateBlank:false,
                autoPopup:true,
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            panelSearch.setValue('DIV_CODE', records[0].DIV_CODE);
                            panelResult.setValue('DIV_CODE', records[0].DIV_CODE);
                            panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
                            panelResult.setValue('NAME', panelSearch.getValue('NAME'));                                                                                                             
                        },
                        scope: this
                    },
                    onClear: function(type)    {
                        panelSearch.setValue('PERSON_NUMB', '');
                        panelSearch.setValue('NAME', '');
                        panelResult.setValue('PERSON_NUMB', '');
                        panelResult.setValue('NAME', '');
                    },
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('PERSON_NUMB', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('NAME', newValue);                
                    }
                }
            }),{
                xtype: 'radiogroup',                            
                fieldLabel: '<t:message code="system.label.human.incumbenttype" default="재직구분"/>',
                items: [{
                    boxLabel: '<t:message code="system.label.human.whole" default="전체"/>', 
                    width: 70, 
                    name: 'RDO_TYPE',
                    inputValue: '' 
                },{
                    boxLabel : '<t:message code="system.label.human.incumbent" default="재직"/>', 
                    width: 70,
                    name: 'RDO_TYPE',
                    inputValue: 'A',
                    checked: true
                    
                },{
                    boxLabel: '<t:message code="system.label.human.retrsp" default="퇴직"/>', 
                    width: 70, 
                    name: 'RDO_TYPE',
                    inputValue: 'B'    
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.getField('RDO_TYPE').setValue(newValue.RDO_TYPE);
                    }
                }
            },{
                fieldLabel: '<t:message code="system.label.human.compname" default="회사명"/>',
                name:'COMP_NAME',
                xtype: 'uniTextfield',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {      
                        panelResult.setValue('COMP_NAME', newValue);
                    }
                }
            },{
                fieldLabel: '<t:message code="system.label.human.compgubun1" default="자타사구분"/>',
                name:'COMP_GUBUN',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H177',
                hidden : true,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {      
                        panelResult.setValue('COMP_GUBUN', newValue);
                    }
                }
            },{
                fieldLabel: '<t:message code="system.label.human.carrgubun" default="인정경력구분"/>',
                name:'CARR_GUBUN',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H163',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {      
                        panelResult.setValue('CARR_GUBUN', newValue);
                    }
                }
            }]
        },{
                title:'<t:message code="system.label.human.addinfo" default="추가정보"/>',
                   id: 'search_panel2',
                itemId:'search_panel2',
                defaultType: 'uniTextfield',
                layout : {type : 'uniTable', columns : 1},
                defaultType: 'uniTextfield',
                
                items:[{
                    fieldLabel: '<t:message code="system.label.human.paygubun" default="고용형태"/>',
                    name:'PAY_GUBUN',
                    xtype: 'uniCombobox',
                    comboType:'AU',
                    comboCode:'H011'
                },{
                    fieldLabel: '<t:message code="system.label.human.employtype" default="사원구분"/>',
                    name:'EMPLOY_GUBUN',
                    xtype: 'uniCombobox',
                    comboType:'AU',
                    comboCode:'H024'
                },{
                    fieldLabel: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',
                    name:'PAY_CODE',
                    xtype: 'uniCombobox',
                    comboType:'AU',
                    comboCode:'H028'
                },{
                    fieldLabel: '<t:message code="system.label.human.pjtname" default="사업명"/>',
                    name:'COST_POOL',
                    xtype: 'uniCombobox',
                    store: Ext.data.StoreManager.lookup('getHumanCostPool')
                },{
                    fieldLabel: '<t:message code="system.label.human.payprovflag3" default="급여차수"/>',
                    name:'PAY_PROV_FLAG',
                    xtype: 'uniCombobox',
                    comboType:'AU',
                    comboCode:'H031'
                },{
                    fieldLabel: '<t:message code="system.label.human.employeegroup" default="사원그룹"/>',
                    name:'PERSON_GROUP',
                    xtype: 'uniCombobox',
                    comboType:'AU',
                    comboCode:'H181'
                }]                
        }]
    }); 
    
    var panelResult = Unilite.createSearchForm('panelResultForm', {
        hidden: !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
            items: [{
                fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
                name:'DIV_CODE', 
                xtype: 'uniCombobox',
                multiSelect: true, 
                typeAhead: false,
                comboType:'BOR120',
                width: 325,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('DIV_CODE', newValue);
                    }
                }
            },
            Unilite.treePopup('DEPTTREE',{
                fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
                valueFieldName:'DEPT',
                textFieldName:'DEPT_NAME' ,
                valuesName:'DEPTS' ,
                DBvalueFieldName:'TREE_CODE',
                DBtextFieldName:'TREE_NAME',
                selectChildren:true,
                textFieldWidth:89,
                validateBlank:true,
                width:300,
                autoPopup:true,
                useLike:true,
                colspan:2,
                listeners: {
                    'onValueFieldChange': function(field, newValue, oldValue  ){
                            panelSearch.setValue('DEPT',newValue);
                    },
                    'onTextFieldChange':  function( field, newValue, oldValue  ){
                            panelSearch.setValue('DEPT_NAME',newValue);
                    },
                    'onValuesChange':  function( field, records){
                            var tagfield = panelSearch.getField('DEPTS') ;
                            tagfield.setStoreData(records)
                    }
                }
            }),
            Unilite.popup('Employee',{
                fieldLabel: '<t:message code="system.label.human.employee" default="사원"/>',
                  valueFieldName:'PERSON_NUMB',
                textFieldName:'NAME',
                colspan:2,
                validateBlank:false,
                autoPopup:true,
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            panelSearch.setValue('DIV_CODE', records[0].DIV_CODE);
                            panelResult.setValue('DIV_CODE', records[0].DIV_CODE);
                            panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
                            panelSearch.setValue('NAME', panelResult.getValue('NAME'));                                                                                                             
                        },
                        scope: this
                    },
                    onClear: function(type)    {
                        panelSearch.setValue('PERSON_NUMB', '');
                        panelSearch.setValue('NAME', '');
                        panelResult.setValue('PERSON_NUMB', '');
                        panelResult.setValue('NAME', '');
                    },
                    onValueFieldChange: function(field, newValue){
                        panelSearch.setValue('PERSON_NUMB', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelSearch.setValue('NAME', newValue);                
                    }
                }
            }),{
                xtype: 'radiogroup',                            
                fieldLabel: '<t:message code="system.label.human.incumbenttype" default="재직구분"/>',    
                items: [{
                    boxLabel: '<t:message code="system.label.human.whole" default="전체"/>', 
                    width: 70, 
                    name: 'RDO_TYPE',
                    inputValue: '' 
                },{
                    boxLabel : '<t:message code="system.label.human.incumbent" default="재직"/>', 
                    width: 70,
                    name: 'RDO_TYPE',
                    inputValue: 'A',
                    checked: true
                    
                },{
                    boxLabel: '<t:message code="system.label.human.retrsp" default="퇴직"/>', 
                    width: 70, 
                    name: 'RDO_TYPE',
                    inputValue: 'B'    
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.getField('RDO_TYPE').setValue(newValue.RDO_TYPE);
                    }
                }
            },{
                fieldLabel: '<t:message code="system.label.human.compname" default="회사명"/>',
                name:'COMP_NAME',
                xtype: 'uniTextfield',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {      
                        panelSearch.setValue('COMP_NAME', newValue);
                    }
                }
            },{
                fieldLabel: '<t:message code="system.label.human.compgubun1" default="자타사구분"/>',
                name:'COMP_GUBUN',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H177',
                hidden : true,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {      
                        panelSearch.setValue('COMP_GUBUN', newValue);
                    }
                }
            },{
                fieldLabel: '<t:message code="system.label.human.carrgubun" default="인정경력구분"/>',
                name:'CARR_GUBUN',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H163',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {      
                        panelSearch.setValue('CARR_GUBUN', newValue);
                    }
                }
            }]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hum316skrGrid1', {
        region: 'center',
        layout: 'fit',
        uniOpt:{    
            expandLastColumn: true,    //마지막 컬럼 * 사용 여부
            useRowNumberer: true,        //첫번째 컬럼 순번 사용 여부
            useLiveSearch: true,        //찾기 버튼 사용 여부
            useRowContext: false,            
            onLoadSelectFirst    : true,
            filter: {                    //필터 사용 여부
                useFilter: true,
                autoCreate: true
            }
        },
        features: [ 
            {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
            {id: 'masterGridTotal',    ftype: 'uniSummary',         showSummaryRow: false} 
        ],
        store: directMasterStore1,
        columns:  [  //{ dataIndex: 'COMP_CODE'                , width: 120},
                     { dataIndex: 'DIV_CODE'                   , width: 133},
                     { dataIndex: 'DEPT_NAME'               , width: 160},
                     { dataIndex: 'POST_CODE'                 , width: 77},
                     { dataIndex: 'NAME'                    , width: 88},
                     { dataIndex: 'PERSON_NUMB'                , width: 77},
                     { dataIndex: 'CARR_STRT_DATE'            , width: 88},
                     { dataIndex: 'CARR_END_DATE'            , width: 88},
                     //{ dataIndex: 'COMP_GUBUN'                , width: 150},
                     { dataIndex: 'COMP_NAME'                , width: 150},
                     { dataIndex: 'POST_NAME'                , width: 133},
                     { dataIndex: 'OCPT_NAME'                , width: 100},
                     { dataIndex: 'DEPT_NAME2'                , width: 110},
                     { dataIndex: 'JOB_NAME'                , width: 110},
                     { dataIndex: 'CARR_GUBUN'                , width: 88}
                     
                     
        ] 
    });   
    
    Unilite.Main({
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
        id  : 'hum316skrApp',
        fnInitBinding : function() {
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            if(!Ext.isEmpty(gsCostPool)){
                panelSearch.getField('COST_POOL').setFieldLabel(gsCostPool);  
            }
            
            
            var activeSForm ;
            if(!UserInfo.appOption.collapseLeftSearch)    {
                activeSForm = panelSearch;
            }else {
                activeSForm = panelResult;
            }
            activeSForm.onLoadSelectText('PERSON_NUMB');
            
            UniAppManager.setToolbarButtons('detail',false);
            UniAppManager.setToolbarButtons('reset',false);
            UniAppManager.setToolbarButtons('save',false);
        },
        onQueryButtonDown : function()    {
            if(!this.isValidSearchForm()){
                return false;
            }
            masterGrid.getStore().loadStoreRecords();
            
        },
        onResetButtonDown:function() {
            panelSearch.clearForm();
            panelResult.clearForm();
            masterGrid.getStore().loadData({});
            
            this.fnInitBinding();
        }
    });
};


</script>
