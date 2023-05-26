<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_zbb500ukrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_zbb500ukrv_kd"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--매출구분-->
    <t:ExtComboStore comboType="AU" comboCode="WB08" /> <!--금형구분-->
    <t:ExtComboStore comboType="AU" comboCode="WB09" /> <!--금형구분-->
    <t:ExtComboStore comboType="AU" comboCode="WB10" /> <!--위치상태-->
    <t:ExtComboStore comboType="AU" comboCode="WB11" /> <!--수금구분-->
    <t:ExtComboStore comboType="AU" comboCode="B219" /> <!--등록여부-->
    <t:ExtComboStore comboType="AU" comboCode="B010" /> <!-- 사용여부-->
    <t:ExtComboStore comboType="AU" comboCode="WB04" /> <!-- 차종  -->
    <t:ExtComboStore comboType="AU" comboCode="WB12" /> <!--의뢰구분-->
    <t:ExtComboStore comboType="AU" comboCode="WB13" /> <!--보수코드-->
    <t:ExtComboStore comboType="AU" comboCode="WB14" /> <!--진행구분-->
    <t:ExtComboStore comboType="AU" comboCode="WB15" /> <!--단계-->
</t:appConfig>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' >
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
            read: 's_zbb500ukrv_kdService.selectList',
            update: 's_zbb500ukrv_kdService.updateList',
            create: 's_zbb500ukrv_kdService.insertList',
            destroy: 's_zbb500ukrv_kdService.deleteList',
            syncAll: 's_zbb500ukrv_kdService.saveAll'
        }
    });
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('s_zbb500ukrv_kdModel', {
        fields: [
            {name: 'COMP_CODE'              ,text:'법인코드'               ,type: 'string'},
            {name: 'DIV_CODE'               ,text:'사업장'                 ,type: 'string'},
            {name: 'OEM_CODE'               ,text:'품번'                   ,type: 'string', allowBlank: false},
            {name: 'CUSTOM_NAME'            ,text:'고객사'                 ,type: 'string', allowBlank: false},
            {name: 'CAR_TYPE'               ,text:'차종'                   ,type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'WB04'},
            {name: 'ITEM_NAME'              ,text:'품명'                   ,type: 'string', allowBlank: false},
            {name: 'DEV_STATUS'             ,text:'단계'                   ,type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'WB15'},
            {name: 'REV_NO'                 ,text:'리비젼'                 ,type: 'int', allowBlank: false, maxLength: 1},
            {name: 'SPEC_NUM'               ,text:'도면승인번호'           ,type: 'string'},
            {name: 'APPROVAL_DATE'          ,text:'승인일자'               ,type: 'uniDate', allowBlank: false},
            {name: 'CAD_NUM'                ,text:'KDG CAD번호'            ,type: 'string'},
//            {name: 'SPEC_FILE_LINK'         ,text:'도면링크'               ,type: 'string'},
            {name: 'SPEC1'                  ,text:'재질1'                  ,type: 'string'},
            {name: 'SPEC2'                  ,text:'재질2'                  ,type: 'string'},
            {name: 'SPEC3'                  ,text:'재질3'                  ,type: 'string'},
            {name: 'SPEC4'                  ,text:'재질4'                  ,type: 'string'},
            {name: 'SPEC5'                  ,text:'재질5'                  ,type: 'string'},
            {name: 'SPEC_COATING'           ,text:'재질코팅'               ,type: 'string'},
            {name: 'METH_ASSY1'             ,text:'조립방법1'              ,type: 'string'},
            {name: 'METH_ASSY2'             ,text:'조립방법2'              ,type: 'string'},
            {name: 'SPECIAL_CHR1'           ,text:'특별특성1'              ,type: 'string'},
            {name: 'SPECIAL_CHR2'           ,text:'특별특성2'              ,type: 'string'},
            {name: 'SPECIAL_CHR3'           ,text:'특별특성3'              ,type: 'string'},
            {name: 'RELEVANT_SPEC1'         ,text:'관련스펙1'              ,type: 'string'},
            {name: 'RELEVANT_SPEC2'         ,text:'관련스펙2'              ,type: 'string'},
            {name: 'RELEVANT_SPEC3'         ,text:'관련스펙3'              ,type: 'string'},
            {name: 'REMARK'                 ,text:'비고'                   ,type: 'string'},
            {name: 'TEMP'                   ,text: 'TEMP'                  ,type: 'string'}
        ]
    }); 
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore = Unilite.createStore('s_zbb500ukrv_kdMasterStore1',{
        model: 's_zbb500ukrv_kdModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  true,            // 수정 모드 사용 
            deletable: true,            // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {   
            var param= panelSearch.getValues();
            this.load({
                  params : param
            });         
        },
        saveStore: function(index) { 
            var inValidRecs = this.getInvalidRecords();
            var paramMaster= panelSearch.getValues();    //syncAll 수정
            if(inValidRecs.length == 0 )    {                                       
                var config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        if(directMasterStore.getCount() == 0){                              
                            UniAppManager.app.onResetButtonDown();
                            return false;
                        }
                        var master = batch.operations[0].getResultSet();
                        var fp = inputTable.down('xuploadpanel');                  //mask on
                        fp.loadData({});
                        fp.getEl().mask('로딩중...','loading-indicator');                            
                        s_zbb500ukrv_kdService.getFileList({SPEC_NUM : master.SPEC_NUM},              //파일조회 메서드  호출(param - 파일번호) 
                            function(provider, response) {
                                fp.loadData(response.result);                       //업로드 파일 load해서 보여주기
                                fp.getEl().unmask();                                //mask off
                                directMasterStore.loadStoreRecords();
                            }
                         );
                        UniAppManager.setToolbarButtons('save', false);
                        UniAppManager.setToolbarButtons('newData', true);
                        if(index){
                            masterGrid.getSelectionModel().select(index);
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
    var panelSearch = Unilite.createSearchPanel('searchForm', {     
        title: '검색조건',      
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,//true,
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
            itemId: 'search_panel1',
            layout: {type: 'uniTable', columns: 1},
            defaultType: 'uniTextfield',            
            items: [{
                    fieldLabel: '사업장',
                    name:'DIV_CODE',
                    xtype: 'uniCombobox',
                    comboType:'BOR120',
                    allowBlank:false,
                    holdable: 'hold',
                    value: UserInfo.divCode,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('DIV_CODE', newValue);
                        }
                    }
                },{
                    fieldLabel: '단계',
                    name:'DEV_STATUS',  
                    xtype: 'uniCombobox', 
                    comboType:'AU',
                    comboCode:'WB15',
                    holdable: 'hold',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('DEV_STATUS', newValue);
                        }
                    }
                },{
                    fieldLabel: '품번',
                    name:'OEM_CODE',  
                    xtype: 'uniTextfield', 
                    holdable: 'hold',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('OEM_CODE', newValue);
                        }
                    }
                },{
                    fieldLabel: '고객사',
                    name:'CUSTOM_NAME',  
                    xtype: 'uniTextfield', 
                    holdable: 'hold',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('CUSTOM_NAME', newValue);
                        }
                    }
                },{
                    fieldLabel: '차종',
                    name:'CAR_TYPE',  
                    xtype: 'uniCombobox', 
                    comboType:'AU',
                    comboCode:'WB04',
                    holdable: 'hold',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('CAR_TYPE', newValue);
                        }
                    }
                },{
                    fieldLabel: '품명',
                    name:'ITEM_NAME',  
                    xtype: 'uniTextfield', 
                    holdable: 'hold',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('ITEM_NAME', newValue);
                        }
                    }
                },{
                    fieldLabel: '도면번호',
                    name:'SPEC_NUM',  
                    xtype: 'uniTextfield', 
                    holdable: 'hold',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('SPEC_NUM', newValue);
                        }
                    }
                },{ 
                    fieldLabel: '도면승인일자',
                    xtype: 'uniDateRangefield',
                    startFieldName: 'APPROVAL_DATE_FR',
                    endFieldName: 'APPROVAL_DATE_TO',
                    startDate: UniDate.get('startOfMonth'),
                    endDate: UniDate.get('today'),
                    allowBlank:false,
                    onStartDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelSearch) {
                            panelResult.setValue('APPROVAL_DATE_FR', newValue);
                        }
                    },
                    onEndDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelSearch) {
                            panelResult.setValue('APPROVAL_DATE_TO', newValue);                           
                        }
                    }
                },{
                    fieldLabel: '비고',
                    name:'REMARK',  
                    xtype: 'uniTextfield', 
                    holdable: 'hold',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('REMARK', newValue);
                        }
                    }
                },{
                    fieldLabel: '삭제파일FID'   ,       //삭제 파일번호를 set하기 위한 hidden 필드
                    name:'DEL_FID',
                    readOnly:true,
                    hidden:true
                },{
                    fieldLabel: '등록파일FID'   ,       //등록 파일번호를 set하기 위한 hidden 필드
                    name:'ADD_FID',
                    readOnly:true,
                    hidden:true
                }
            ]
        }],
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
    
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
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
                holdable: 'hold',
                value: UserInfo.divCode,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('DIV_CODE', newValue);
                    }
                }
            },{
                fieldLabel: '단계',
                name:'DEV_STATUS',  
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'WB15',
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('DEV_STATUS', newValue);
                    }
                }
            },{
                fieldLabel: '품번',
                name:'OEM_CODE',  
                xtype: 'uniTextfield', 
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('OEM_CODE', newValue);
                    }
                }
            },{
                fieldLabel: '고객사',
                name:'CUSTOM_NAME',  
                xtype: 'uniTextfield', 
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('CUSTOM_NAME', newValue);
                    }
                }
            },{
                fieldLabel: '차종',
                name:'CAR_TYPE',  
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'WB04',
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('CAR_TYPE', newValue);
                    }
                }
            },{
                fieldLabel: '품명',
                name:'ITEM_NAME',  
                xtype: 'uniTextfield', 
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('ITEM_NAME', newValue);
                    }
                }
            },{
                fieldLabel: '도면번호',
                name:'SPEC_NUM',  
                xtype: 'uniTextfield', 
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('SPEC_NUM', newValue);
                    }
                }
            },{ 
                fieldLabel: '도면승인일자',
                xtype: 'uniDateRangefield',
                startFieldName: 'APPROVAL_DATE_FR',
                endFieldName: 'APPROVAL_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank:false,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelSearch.setValue('APPROVAL_DATE_FR', newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelSearch.setValue('APPROVAL_DATE_TO', newValue);                           
                    }
                }
            },{
                fieldLabel: '비고',
                name:'REMARK',  
                xtype: 'uniTextfield', 
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('REMARK', newValue);
                    }
                }
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
    
    var inputTable = Unilite.createSearchForm('detailForm', { //createForm
        layout : {type : 'uniTable', columns : 2},
        disabled: false,
        border:true,
        padding: '1',
//        title: '파일업로드',
        region: 'center',
//        masterGrid: masterGrid,
        items: [{
                xtype: 'xuploadpanel',
                height: 150,
                flex: 0,
                padding: '0 0 8 95',
                labelWidth: 100,
                width: 800,
                colspan: 2,
                listeners : {
                    change: function() {
                        if(directMasterStore.count() > 0){                  
                           UniAppManager.app.setToolbarButtons('save', true);  //파일 추가or삭제시 저장버튼 on
                        }
                        
                    }
                }
            }],
            loadForm: function(record)  {
                // window 오픈시 form에 Data load
                var count = masterGrid.getStore().getCount();
                if(count > 0) {
                    this.reset();
                    this.setActiveRecord(record[0] || null);   
                    this.resetDirtyStatus();            
                }
            }
    });
    
    var masterGrid = Unilite.createGrid('s_zbb500ukrv_kdmasterGrid', { 
        layout : 'fit',   
        region: 'center',                          
        store: directMasterStore,
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useRowNumberer: false,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        columns:  [ 
            { dataIndex: 'COMP_CODE'                             ,           width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'                              ,           width: 80, hidden: true},
            { dataIndex: 'SPEC_NUM'                              ,           width: 100},
            { dataIndex: 'OEM_CODE'                              ,           width: 80},
            { dataIndex: 'CUSTOM_NAME'                           ,           width: 100},
            { dataIndex: 'CAR_TYPE'                              ,           width: 80},
            { dataIndex: 'ITEM_NAME'                             ,           width: 200},
            { dataIndex: 'DEV_STATUS'                            ,           width: 80},
            { dataIndex: 'REV_NO'                                ,           width: 100},
            { dataIndex: 'APPROVAL_DATE'                         ,           width: 80},
            { dataIndex: 'CAD_NUM'                               ,           width: 100},
//            { dataIndex: 'SPEC_FILE_LINK'                        ,           width: 200},
            { dataIndex: 'SPEC1'                                 ,           width: 110},
            { dataIndex: 'SPEC2'                                 ,           width: 110},
            { dataIndex: 'SPEC3'                                 ,           width: 110},
            { dataIndex: 'SPEC4'                                 ,           width: 110},
            { dataIndex: 'SPEC5'                                 ,           width: 110},
            { dataIndex: 'SPEC_COATING'                          ,           width: 110},
            { dataIndex: 'METH_ASSY1'                            ,           width: 110},
            { dataIndex: 'METH_ASSY2'                            ,           width: 110},
            { dataIndex: 'SPECIAL_CHR1'                          ,           width: 110},
            { dataIndex: 'SPECIAL_CHR2'                          ,           width: 110},
            { dataIndex: 'SPECIAL_CHR3'                          ,           width: 110},
            { dataIndex: 'RELEVANT_SPEC1'                        ,           width: 110},
            { dataIndex: 'RELEVANT_SPEC2'                        ,           width: 110},
            { dataIndex: 'RELEVANT_SPEC3'                        ,           width: 110},
            { dataIndex: 'REMARK'                                ,           width: 110}
        ],
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
                if(e.record.phantom) {
                    if(UniUtils.indexOf(e.field, ['SPEC_NUM'])) 
                    { 
                        return false;
                    } else {
                        return true;
                    }
                } else {
                	if(UniUtils.indexOf(e.field, ['SPEC_NUM']))
                    {
                        return false;
                    } else {
                        return true;
                    }
                }
            }, 
            beforeselect : function ( gird, record, index, eOpts ){
                var isNewCardShow = true;      //newCard 보여줄것인지?
                var fp = inputTable.down('xuploadpanel');                  //mask on
                var addFiles = fp.getAddFiles();             
                var removeFiles = fp.getRemoveFiles();
                if(!Ext.isEmpty(addFiles + removeFiles) && !record.phantom){
                    isNewCardShow = false; 
                    Ext.Msg.show({
                       title:'확인',
                       msg: Msg.sMB017 + "\n" + Msg.sMB061,
                       buttons: Ext.Msg.YESNOCANCEL,
                       icon: Ext.Msg.QUESTION,
                       fn: function(res) {
                          if (res === 'yes' ) {
                            UniAppManager.app.onSaveDataButtonDown(index);
                          } else if(res === 'no') {
                              UniAppManager.setToolbarButtons('save', false);
                              fp.loadData({});
                              masterGrid.getSelectionModel().select(index);
                          }
                       }
                  });
                }
                return isNewCardShow;
            },
            selectionchange:function( model1, selected, eOpts ){
                var record = selected[0];
                
                if(selected.length > 0) {
                    inputTable.loadForm(selected);                              
                    var fp = inputTable.down('xuploadpanel');                  //mask on
                    if(directMasterStore.getCount() > 0 && record && !record.phantom){
                        fp.loadData({});
                        fp.getEl().mask('로딩중...','loading-indicator');
                        var specNum = record.data.SPEC_NUM;
                        s_zbb500ukrv_kdService.getFileList({SPEC_NUM : specNum},              //파일조회 메서드  호출(param - 파일번호)  
                            function(provider, response) {                          
                                fp.loadData(response.result);                       //업로드 파일 load해서 보여주기
                                fp.getEl().unmask();                                //mask off
        //                        UniAppManager.setToolbarButtons('save',false);      //저장버튼 비활성화
                            }
                        );
                    } else {
                        inputTable.loadForm(selected);                              
                        var fp = inputTable.down('xuploadpanel');                  //mask on
                        
                        fp.loadData({});
                        fp.getEl().mask('로딩중...','loading-indicator');
                        var specNum = null;
                        s_zbb500ukrv_kdService.getFileList({SPEC_NUM : specNum},              //파일조회 메서드  호출(param - 파일번호) 
                            function(provider, response) {                          
                                fp.loadData(response.result);                       //업로드 파일 load해서 보여주기
                                fp.getEl().unmask();                                //mask off
        //                        UniAppManager.setToolbarButtons('save',false);      //저장버튼 비활성화
                            }
                        );
                    }
                }
                else {
                    inputTable.loadForm(selected);                              
                    var fp = inputTable.down('xuploadpanel');                  //mask on
                    
                    fp.loadData({});
                    fp.getEl().mask('로딩중...','loading-indicator');
                    var specNum = null;
                        s_zbb500ukrv_kdService.getFileList({SPEC_NUM : specNum},              //파일조회 메서드  호출(param - 파일번호) 
                        function(provider, response) {                          
                            fp.loadData(response.result);                       //업로드 파일 load해서 보여주기
                            fp.getEl().unmask();                                //mask off
    //                        UniAppManager.setToolbarButtons('save',false);      //저장버튼 비활성화
                        }
                    );
                }
            }
        }
    });
    
    
    Unilite.Main( {
        borderItems:[{
                region:'center',
                layout: 'border',
                border: false,
                items:[{
                        region : 'center',
                        xtype : 'container',
                        layout : 'fit',
                        items : [ masterGrid ]
                    },
                    panelResult,
                    {
                        region : 'north',
                        xtype : 'container',
                        highth: 20,
                        layout : 'fit',
                        items : [ inputTable ]
                    }
                ]
            },
            panelSearch     
        ],
        id  : 's_zbb500ukrv_kdApp',
        fnInitBinding : function() {
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'],false);
            UniAppManager.setToolbarButtons('newData', true);
            this.setDefault();
        },
        onQueryButtonDown : function()  {
//        	if(panelSearch.setAllFieldsReadOnly(true) == false){
//                return false;
//            }
//            if(panelResult.setAllFieldsReadOnly(true) == false){
//                return false;
//            }
            directMasterStore.loadStoreRecords();
            UniAppManager.setToolbarButtons(['reset'], true);
        },
        onResetButtonDown: function() {
            panelSearch.setAllFieldsReadOnly(false);
            panelResult.setAllFieldsReadOnly(false);
            panelSearch.clearForm();
            panelResult.clearForm(); 
            directMasterStore.clearData();
            masterGrid.reset();
            this.setDefault();
            var fp = inputTable.down('xuploadpanel');
            fp.loadData({}); 
          
        },
        onNewDataButtonDown: function() {       // 행추가
        	var compCode        =   UserInfo.compCode; 
            var divCode         =   panelSearch.getValue('DIV_CODE'); 
            var devStatus       =   panelSearch.getValue('DEV_STATUS'); 
            var revNo           =   '1';
            var oemCode         =   panelSearch.getValue('OEM_CODE'); 
            var customName      =   panelSearch.getValue('CUSTOM_NAME'); 
            var carType         =   panelSearch.getValue('CAR_TYPE'); 
            var itemName        =   panelSearch.getValue('ITEM_NAME'); 
//            var specNum         =   panelSearch.getValue('SPEC_NUM'); 
            var approvalDate    =   UniDate.get('today'); 
            var remark          =   panelSearch.getValue('REMARK'); 
            
            var r = {
                COMP_CODE:          compCode,
                DIV_CODE:           divCode,
                DEV_STATUS:         devStatus,
                REV_NO:             revNo,
                OEM_CODE:           oemCode,
                CUSTOM_NAME:        customName,
                CAR_TYPE:           carType,
                ITEM_NAME:          itemName,
//                SPEC_NUM:           specNum,
                APPROVAL_DATE:      approvalDate,
                REMARK:             remark
            };
            masterGrid.createRow(r);
        },
        onDeleteDataButtonDown: function() {
        	var record = masterGrid.getSelectedRecord();
            if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
            	masterGrid.deleteSelectedRow();
            }
        },
        onSaveDataButtonDown: function () {
        	var fp = inputTable.down('xuploadpanel');
            var addFiles = fp.getAddFiles();             
            var removeFiles = fp.getRemoveFiles();
            panelSearch.setValue('ADD_FID', addFiles);                  //추가 파일 담기
            panelSearch.setValue('DEL_FID', removeFiles);               //삭제 파일 담기         
            if(masterGrid.getSelectedRecord() && !Ext.isEmpty(addFiles) || !Ext.isEmpty(removeFiles) ){   //파일변경이 있을시..
                masterGrid.getSelectedRecord().set('TEMP', addCnt);        //저장을 일으키기 위해 임의로 set...
                addCnt++
            }
            directMasterStore.saveStore();
        },
        setDefault: function() {
            directMasterStore.clearData();  
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelSearch.setValue('APPROVAL_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('APPROVAL_DATE_FR', UniDate.get('startOfMonth'));
            panelSearch.setValue('APPROVAL_DATE_TO', UniDate.get('today'));
            panelResult.setValue('APPROVAL_DATE_TO', UniDate.get('today'));
        }                         
    });                         
}
</script>