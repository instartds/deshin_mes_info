<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_zdd410ukrv_kd"  >
    <t:ExtComboStore comboType="BOR120" pgmId="s_bco100skrv_kd"/>   <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B004" />             <!-- 화폐단위-->
    <t:ExtComboStore comboType="AU" comboCode="WB14" />             <!-- 진행구분-->
    <t:ExtComboStore comboType="AU" comboCode="B024" />             <!-- 담당자-->
    <t:ExtComboStore comboType="AU" comboCode="B013" />             <!-- 재고단위  -->
    <t:ExtComboStore comboType="AU" comboCode="B015" />             <!-- 거래처구분    -->            
    <t:ExtComboStore comboType="AU" comboCode="B004" />             <!-- 기준화폐-->         
    <t:ExtComboStore comboType="AU" comboCode="B038" />             <!-- 결제방법-->           
    <t:ExtComboStore comboType="AU" comboCode="B034" />             <!-- 결제조건-->             
    <t:ExtComboStore comboType="AU" comboCode="B055" />             <!-- 거래처분류--> 
    <t:ExtComboStore comboType="AU" comboCode="A003" />             <!-- 구분  -->
    <t:ExtComboStore comboType="AU" comboCode="WB26" />             <!-- 단가구분  -->
    <t:ExtComboStore comboType="AU" comboCode="T005" />             <!-- 가격조건  -->
    <t:ExtComboStore comboType="AU" comboCode="WB01" />             <!-- 운송방법  -->
    <t:ExtComboStore comboType="AU" comboCode="WB03" />             <!-- 변동사유  -->
    <t:ExtComboStore comboType="AU" comboCode="WB04" />             <!-- 차종  -->
    <t:ExtComboStore comboType="AU" comboCode="WB18" />             <!-- 내수구분  -->
    <t:ExtComboStore comboType="AU" comboCode="WB22" />             <!-- 의뢰서구분  -->
</t:appConfig>
</script>
<script type="text/javascript" >

var BsaCodeInfo = {     //컨트롤러에서 값을 받아옴.
    gsAutoType  :   '${gsAutoType}'
};

function appMain() {
	var addCnt = 0; //폼만 수정시 강제 저장 일으키기 위한 cnt
	var isAutoOrderNum = false;
    if(BsaCodeInfo.gsAutoType=='Y') {
        isAutoOrderNum = true;
    }
    
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_zdd410ukrv_kdService.selectList',
            update: 's_zdd410ukrv_kdService.updateList',
            syncAll: 's_zdd410ukrv_kdService.saveAll'
        }
    });
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('s_zdd410ukrv_kdModel', {
        fields: [
//            {name: 'CONFIRM_YN_CHECK'     , text: '확정'                , type: 'boolean'},
            {name: 'COMP_CODE'            , text:'법인코드'             , type: 'string'},
            {name: 'DIV_CODE'             , text:'사업장'               , type: 'string'},
            {name: 'REQ_NUM'              , text:'의뢰번호'             , type: 'string'},
            {name: 'REQ_DATE'             , text:'의뢰일자'             , type: 'uniDate'},
            {name: 'REQ_END_DATE'         , text:'완료요청일'           , type: 'uniDate'},
            {name: 'REQ_DEPT_CODE'        , text:'의뢰부서코드'         , type: 'string'},
            {name: 'REQ_DEPT_NAME'        , text:'의뢰부서명'           , type: 'string'},
            {name: 'REQ_PERSON'           , text:'의뢰사원코드'         , type: 'string'},
            {name: 'REQ_PERSON_NAME'      , text:'의뢰사원명'           , type: 'string'},
            {name: 'GASGET_REMARK'        , text:'가스켓이력'           , type: 'string'},
            {name: 'TEST_REMARK'          , text:'시험목적'             , type: 'string'},
            {name: 'CUSTOM_CODE'          , text:'고객사코드'           , type: 'string'},
            {name: 'CUSTOM_NAME'          , text:'고객사명'             , type: 'string'},
            {name: 'PJT_NAME'             , text:'프로젝트명'           , type: 'string'},
            {name: 'EXHAUST_Q'            , text:'배기량'               , type: 'string'},
            {name: 'PART_GUBUN'           , text:'기관구분'             , type: 'string'},
            {name: 'ORIGIN_SPEC'          , text:'고유사양'             , type: 'string'},
            {name: 'ETC_TXT'              , text:'기타'                 , type: 'string'},
            {name: 'DOC_NUM'              , text:'도면번호'             , type: 'string'},
            {name: 'CHG_TXT'              , text:'설변사항'             , type: 'string'},
            {name: 'HIS_TXT'              , text:'상대물이력'           , type: 'string'},
            {name: 'TEST_SPEC1'           , text:'시험스펙(고객)'       , type: 'string'},
            {name: 'TEST_SPEC2'           , text:'시험스펙(KDG)'        , type: 'string'},
            {name: 'ITEM_CODE'            , text:'품목코드'             , type: 'string'},
            {name: 'ITEM_NAME'            , text:'품목명'               , type: 'string'},
            {name: 'OEM_ITEM_CODE'        , text:'품번'                 , type: 'string'},
            {name: 'TEST_TXT1'            , text:'시험내용1'            , type: 'string'},
            {name: 'TEST_TXT2'            , text:'시험내용2'            , type: 'string'},
            {name: 'TEST_TXT3'            , text:'시험내용3'            , type: 'string'},
            {name: 'STATUS'               , text:'진행상태'             , type: 'string', comboType: 'AU', comboCode: 'WB14'}
        ]
    }); 
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore = Unilite.createStore('s_zdd410ukrv_kdMasterStore1',{
        model: 's_zdd410ukrv_kdModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  true,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {   
            var param= panelResult.getValues();
            this.load({
                  params : param
            });         
        },
        saveStore: function(index) { 
            var inValidRecs = this.getInvalidRecords();
            var paramMaster= panelResult.getValues();    //syncAll 수정
            if(inValidRecs.length == 0 )    {                                       
                var config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        panelResult.getForm().wasDirty = false;
                        panelResult.resetDirtyStatus();
                        console.log("set was dirty to false");
                        UniAppManager.setToolbarButtons('save', false);     
                        if(directMasterStore.getCount() == 0){
                            UniAppManager.app.onResetButtonDown();
                        }
                    } 
                };                  
                this.syncAllDirect(config);
            }else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        }
    }); // End of var directMasterStore1 
    
    /**
     * 검색조건 (Search Panel)
     * @type 
     */ 
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 4},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        id: 'RESULT_SEARCH',
        items: [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
//                holdable: 'hold',
                value: UserInfo.divCode
            },{ 
                fieldLabel: '의뢰일',
                xtype: 'uniDateRangefield',
                startFieldName: 'REQ_DATE_FR',
                endFieldName: 'REQ_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank:false/*, 
                holdable: 'hold'*/
            },{
                fieldLabel: '의뢰번호',
                name:'REQ_NUM',  
                xtype: 'uniTextfield', 
//                holdable: 'hold',
                colspan: 2
            },
            Unilite.popup('DEPT', { 
                fieldLabel: '부서', 
                valueFieldName: 'REQ_DEPT_CODE',
                textFieldName: 'REQ_DEPT_NAME',
                autoPopup:true, 
//                holdable: 'hold',
                listeners: {
                    applyextparam: function(popup){                         
                        var authoInfo = pgmInfo.authoUser;              //권한정보(N-전체,A-자기사업장>5-자기부서)
                        var deptCode = UserInfo.deptCode;   //부서정보
                        var divCode = '';                   //사업장
                        if(authoInfo == "A"){   //자기사업장 
                            popup.setExtParam({'TREE_CODE': ""});
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                        }else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){   //전체권한
                            popup.setExtParam({'TREE_CODE': ""});
                            popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                        }else if(authoInfo == "5"){     //부서권한
                            popup.setExtParam({'TREE_CODE': UserInfo.deptCode});
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                        }
                    }
                }
            }), 
            Unilite.popup('Employee',{
                    fieldLabel: '담당자',
                    holdable: 'hold',
                    valueFieldName:'REQ_PERSON',
                    textFieldName:'REQ_PERSON_NAME', 
//                    holdable: 'hold',
                    validateBlank:false,
                    autoPopup:true,
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                var param= Ext.getCmp('s_zdd300skrv_kdDetail').getValues();
                                s_zdd300skrv_kdService.selectPersonDept(param, function(provider, response)  {     
                                    if(!Ext.isEmpty(provider)){                                                
                                        panelResult.setValue('REQ_DEPT_CODE', provider[0].DEPT_CODE);  
                                        panelResult.setValue('REQ_DEPT_NAME', provider[0].DEPT_NAME);             
                                    }                                                                          
                                });    
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            panelResult.setValue('REQ_PERSON', '');
                            panelResult.setValue('REQ_PERSON_NAME', '');
                        },
                        applyextparam: function(popup){                         
                            popup.setExtParam({'DEPT_SEARCH': panelResult.getValue('REQ_DEPT_NAME')});
                        }
                    }
            }),
            Unilite.popup('DIV_PUMOK',{ 
                    fieldLabel: '품목코드',
                    valueFieldName: 'ITEM_CODE', 
                    textFieldName: 'ITEM_NAME', 
//                    holdable: 'hold',
                    colspan: 2,
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                panelResult.setValue('ITEM_CODE', records[0]['ITEM_CODE']); 
                                panelResult.setValue('ITEM_NAME', records[0]['ITEM_NAME']);  
                                panelResult.setValue('OEM_ITEM_CODE', records[0]['OEM_ITEM_CODE']);          
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            panelResult.setValue('ITEM_CODE', '');
                            panelResult.setValue('ITEM_NAME', '');
                            panelResult.setValue('OEM_ITEM_CODE', '');
                        },
                        applyextparam: function(popup){                         
                            popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                        }
                    }
            }), 
            Unilite.popup('AGENT_CUST',{
                    fieldLabel: '고객사',
                    valueFieldName:'CUSTOM_CODE',
                    textFieldName:'CUSTOM_NAME', 
//                    holdable: 'hold',
                    validateBlank:false,
                    autoPopup:true
            }),{
                fieldLabel: '품번',
                name:'OEM_ITEM_CODE',  
                xtype: 'uniTextfield', 
//                holdable: 'hold'
            },{
                fieldLabel: '프로젝트명',
                name:'PJT_NAME',  
                xtype: 'uniTextfield', 
//                holdable: 'hold'
            },{
                xtype: 'radiogroup',                            
                fieldLabel: '진행상태',                                       
                id: 'rdoSelect',
//                holdable: 'hold',
                items: [{
                    boxLabel: '의뢰', 
                    width: 50, 
                    name: 'STATUS',
                    inputValue: '1',
                    checked: true  
                },{
                    boxLabel : '마감', 
                    width: 50,
                    inputValue: '3',
                    name: 'STATUS'
                }]
            }
        ],
        setAllFieldsReadOnly: function(b) { 
            var r= true
            if(b) {
                var invalid = this.getForm().getFields().filterBy(function(field) {
                    return !field.validate();
                });                      
                if(invalid.length > 0) {
                    r=false;
                    var labelText = ''
                    if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
                        var labelText = invalid.items[0]['fieldLabel']+'은(는)';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
                    }
                    alert(labelText+Msg.sMB083);
                    invalid.items[0].focus();
                } else {
                    //this.mask();
                    var fields = this.getForm().getFields();
                    Ext.each(fields.items, function(item) {
                        if(Ext.isDefined(item.holdable) ) {
                            if (item.holdable == 'hold') {
                                item.setReadOnly(true); 
                            }
                        } 
                        if(item.isPopupField) {
                            var popupFC = item.up('uniPopupField') ;       
                            if(popupFC.holdable == 'hold') {
                                popupFC.setReadOnly(true);
                            }
                        }
                    })
                }
            } else {
                //this.unmask();
                var fields = this.getForm().getFields();
                Ext.each(fields.items, function(item) {
                    if(Ext.isDefined(item.holdable) ) {
                        if (item.holdable == 'hold') {
                            item.setReadOnly(false);
                        }
                    } 
                    if(item.isPopupField) {
                        var popupFC = item.up('uniPopupField') ; 
                        if(popupFC.holdable == 'hold' ) {
                            item.setReadOnly(false);
                        }
                    }
                })
            }
            return r;
        },
        setLoadRecord: function(record) {
            var me = this;   
            me.uniOpt.inLoading=false;
            me.setAllFieldsReadOnly(true);
        }
    });
    
    var masterGrid = Unilite.createGrid('s_zdd410ukrv_kdmasterGrid', { 
        layout : 'fit',   
        region: 'center',                          
        store: directMasterStore,
        uniOpt: {              
            useMultipleSorting  : true,     
            useLiveSearch       : false,    
            onLoadSelectFirst   : false,        
            dblClickToEdit      : false,    
            useGroupSummary     : false, 
            useContextMenu      : false,    
            useRowNumberer      : false, 
            expandLastColumn    : false,     
            useRowContext       : false,    
            filter: {           
                useFilter       : false,    
                autoCreate      : true  
            }           
        },
        selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
            listeners: {  
                select: function(grid, selectRecord, index, rowIndex, eOpts, oldValue ) {
                    if(Ext.getCmp('rdoSelect').getChecked()[0].inputValue == '1') {
                        selectRecord.set('STATUS', '3');
                    } else if(Ext.getCmp('rdoSelect').getChecked()[0].inputValue == '3') {
                        selectRecord.set('STATUS', '1');
                    }
                }, 
                deselect: function(grid, selectRecord, index, rowIndex, eOpts, oldValue ){
                    if(Ext.getCmp('rdoSelect').getChecked()[0].inputValue == '1') {
                        selectRecord.set('STATUS', '1');
                    } else if(Ext.getCmp('rdoSelect').getChecked()[0].inputValue == '3') {
                       selectRecord.set('STATUS', '3');
                    }
                }
            }
        }),
        columns:  [ 
            { dataIndex: 'COMP_CODE'                    ,  width: 100, hidden: true}, 
            { dataIndex: 'DIV_CODE'                     ,  width: 100, hidden: true}, 
            { dataIndex: 'REQ_NUM'                      ,  width: 100}, 
            { dataIndex: 'REQ_DATE'                     ,  width: 100}, 
            { dataIndex: 'REQ_DEPT_CODE'                ,  width: 100}, 
            { dataIndex: 'REQ_DEPT_NAME'                ,  width: 200}, 
            { dataIndex: 'REQ_PERSON'                   ,  width: 100}, 
            { dataIndex: 'REQ_PERSON_NAME'              ,  width: 200}, 
            { dataIndex: 'CUSTOM_CODE'                  ,  width: 100}, 
            { dataIndex: 'CUSTOM_NAME'                  ,  width: 200}, 
            { dataIndex: 'ITEM_CODE'                    ,  width: 110},
            { dataIndex: 'ITEM_NAME'                    ,  width: 200},  
            { dataIndex: 'OEM_ITEM_CODE'                ,  width: 200},  
            { dataIndex: 'PJT_NAME'                     ,  width: 100}, 
            { dataIndex: 'REQ_END_DATE'                 ,  width: 100, hidden: true}, 
            { dataIndex: 'GASGET_REMARK'                ,  width: 100, hidden: true}, 
            { dataIndex: 'TEST_REMARK'                  ,  width: 100, hidden: true}, 
            { dataIndex: 'EXHAUST_Q'                    ,  width: 100, hidden: true}, 
            { dataIndex: 'PART_GUBUN'                   ,  width: 100, hidden: true}, 
            { dataIndex: 'ORIGIN_SPEC'                  ,  width: 100, hidden: true}, 
            { dataIndex: 'ETC_TXT'                      ,  width: 100, hidden: true}, 
            { dataIndex: 'DOC_NUM'                      ,  width: 100, hidden: true}, 
            { dataIndex: 'CHG_TXT'                      ,  width: 100, hidden: true}, 
            { dataIndex: 'HIS_TXT'                      ,  width: 100, hidden: true}, 
            { dataIndex: 'TEST_SPEC1'                   ,  width: 100, hidden: true}, 
            { dataIndex: 'TEST_SPEC2'                   ,  width: 100, hidden: true},
            { dataIndex: 'TEST_TXT1'                    ,  width: 100, hidden: true}, 
            { dataIndex: 'TEST_TXT2'                    ,  width: 100, hidden: true}, 
            { dataIndex: 'TEST_TXT3'                    ,  width: 100, hidden: true}, 
            { dataIndex: 'STATUS'                       ,  width: 100, hidden: true}
        ],
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
                if(e.record.phantom) {
                    if(UniUtils.indexOf(e.field, ['CHECK'])) 
                    { 
                        return true;
                    } else {
                        return false;
                    }
                } else {
                	if(UniUtils.indexOf(e.field, ['CHECK']))
                    {
                        return true;
                    } else {
                        return false;
                    }
                }
            }
        }
    });
    
    
    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                masterGrid, panelResult
            ]
        }],
        id  : 's_zdd410ukrv_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'],false);
            UniAppManager.setToolbarButtons('newData', true);
            this.setDefault();
        },
        onQueryButtonDown : function()  {
        	if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
            directMasterStore.loadStoreRecords();
            UniAppManager.setToolbarButtons(['reset'], true);
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            panelResult.clearForm();
            masterGrid.reset();
            this.setDefault(); 
        },
        onSaveDataButtonDown: function () {
            directMasterStore.saveStore();
        },
        setDefault: function() {
            directMasterStore.clearData();  
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('REQ_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('REQ_DATE_TO', UniDate.get('today'));
        }                         
    });                         
}
</script>