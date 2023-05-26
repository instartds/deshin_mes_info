<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_zbb300ukrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_zbb300ukrv_kd"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="H156" />                          <!--반영구분-->
    <t:ExtComboStore comboType="AU" comboCode="WZ25" />                          <!--문제구분-->
    <t:ExtComboStore comboType="AU" comboCode="WZ26" />                          <!--문제유형-->
    <t:ExtComboStore comboType="AU" comboCode="WZ27" />                          <!--발생단계-->
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
            read: 's_zbb300ukrv_kdService.selectList',
            update: 's_zbb300ukrv_kdService.updateList',
            create: 's_zbb300ukrv_kdService.insertList',
            destroy: 's_zbb300ukrv_kdService.deleteList',
            syncAll: 's_zbb300ukrv_kdService.saveAll'
        }
    });
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('s_zbb300ukrv_kdModel', {
        fields: [
            {name: 'COMP_CODE'            ,text:'법인코드'             ,type: 'string'},
            {name: 'DIV_CODE'             ,text:'사업장'               ,type: 'string'},
            {name: 'DOC_NUM'              ,text:'문서번호'             ,type: 'string'},
            {name: 'WORK_DATE'            ,text:'발생일'               ,type: 'uniDate', allowBlank: false},
            {name: 'CUSTOM_CODE'          ,text:'거래처코드'           ,type: 'string', allowBlank: false},
            {name: 'CUSTOM_NAME'          ,text:'거래처명'             ,type: 'string'},
            {name: 'ITEM_CODE'            ,text:'품목코드'             ,type: 'string', allowBlank: false},
            {name: 'ITEM_NAME'            ,text:'품목코드'             ,type: 'string'},
            {name: 'SPEC'                 ,text:'규격'                 ,type: 'string'},
            {name: 'OEM_ITEM_CODE'        ,text:'품번'                 ,type: 'string'},
            {name: 'ISSUE_GUBUN'          ,text:'문제구분'             ,type: 'string', comboType: 'AU', comboCode: 'WZ25'},
            {name: 'ISSUE_TYPE'           ,text:'문제유형'             ,type: 'string', comboType: 'AU', comboCode: 'WZ26'},
            {name: 'ISSUE_STATUS'         ,text:'발생단계'             ,type: 'string', comboType: 'AU', comboCode: 'WZ27'},
            {name: 'ISSUE_CONTENTS'       ,text:'문제내용'             ,type: 'string'},
            {name: 'ACT_CONTENTS'         ,text:'조치내용'             ,type: 'string'},
            {name: 'REFLECTION_YN'        ,text:'반영여부'             ,type: 'string', comboType: 'AU', comboCode: 'H156'},
            {name: 'REMARK'               ,text:'비고'                 ,type: 'string'},
            {name: 'TEMP'                 ,text: 'TEMP'                ,type: 'string'}
        ]
    }); 
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore = Unilite.createStore('s_zbb300ukrv_kdMasterStore1',{
        model: 's_zbb300ukrv_kdModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  true,            // 수정 모드 사용 
            deletable: true,            // 삭제 가능 여부 
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
                        if(directMasterStore.getCount() == 0){                              
                            UniAppManager.app.onResetButtonDown();
                            return false;
                        }
                        var master = batch.operations[0].getResultSet();
                        var fp = inputTable.down('xuploadpanel');                  //mask on
                        fp.loadData({});
                        fp.getEl().mask('로딩중...','loading-indicator');                            
                        s_zbb300ukrv_kdService.getFileList({DOC_NUM : master.DOC_NUM},              //파일조회 메서드  호출(param - 파일번호) 
                            function(provider, response) {
                                fp.loadData(response.result);                       //업로드 파일 load해서 보여주기
                                fp.getEl().unmask();                                //mask off
                            }
                         );
                        UniAppManager.setToolbarButtons('save', false);
                        UniAppManager.setToolbarButtons('newData', true);
                        directMasterStore.loadStoreRecords();
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
                value: UserInfo.divCode
            },{ 
                fieldLabel: '발생일',
                xtype: 'uniDateRangefield',
                startFieldName: 'WORK_DATE_FR',
                endFieldName: 'WORK_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank:false, 
                holdable: 'hold'
            },{
                fieldLabel: '관리번호',
                name:'DOC_NUM',  
                xtype: 'uniTextfield',
                holdable: 'hold'
            },
            Unilite.popup('AGENT_CUST',{
                    fieldLabel: '거래처',
                    valueFieldName:'CUSTOM_CODE',
                    textFieldName:'CUSTOM_NAME',
                    validateBlank:false,
                    autoPopup:true, 
                    holdable: 'hold'
            }),
            Unilite.popup('DIV_PUMOK',{
                    fieldLabel: '품목코드',
                    valueFieldName:'ITEM_CODE',
                    textFieldName:'ITEM_NAME',
                    validateBlank:false,
                    autoPopup:true, 
                    holdable: 'hold',
                    listeners: {
                        applyextparam: function(popup){                         
                            popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                        }
                    }
            }),{
                fieldLabel: '품번',
                name:'OEM_ITEM_CODE',  
                xtype: 'uniTextfield', 
                holdable: 'hold'
            },{
                fieldLabel: '문제구분',
                name:'ISSUE_GUBUN',  
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'WZ25',
                holdable: 'hold'
            },{
                fieldLabel: '문제유형',
                name:'ISSUE_TYPE',  
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'WZ26',
                holdable: 'hold'
            },{
                fieldLabel: '반영여부',
                name:'REFLECTION_YN',  
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'H156',
                holdable: 'hold'
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
    
    var masterGrid = Unilite.createGrid('s_zbb300ukrv_kdmasterGrid', { 
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
            { dataIndex: 'COMP_CODE'           ,           width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'            ,           width: 80, hidden: true},
            { dataIndex: 'DOC_NUM'             ,           width: 100},
            { dataIndex: 'WORK_DATE'           ,           width: 80},
            { dataIndex: 'CUSTOM_CODE'         ,           width: 110,
              'editor': Unilite.popup('AGENT_CUST_G',{
                    textFieldName : 'CUSTOM_CODE',
                    DBtextFieldName : 'CUSTOM_CODE',
                    autoPopup:true,
                    listeners: { 'onSelected': {
                        fn: function(records, type  ){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
                            grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('CUSTOM_CODE','');
                            grdRecord.set('CUSTOM_NAME','');
                      }
                    }
                })
            },
            { dataIndex: 'CUSTOM_NAME'         ,           width: 200},
            { dataIndex: 'ITEM_CODE'           ,           width: 110,
                editor: Unilite.popup('DIV_PUMOK_G', {      
                        textFieldName: 'ITEM_CODE',
                        DBtextFieldName: 'ITEM_CODE',
                        extParam: {SELMODEL: 'MULTI', DIV_CODE: panelResult.getValue('DIV_CODE'), POPUP_TYPE: 'GRID_CODE'},
                        autoPopup:true,
                        listeners: {'onSelected': {
                            fn: function(records, type) {
                                console.log('records : ', records);
                                Ext.each(records, function(record,i) {                                                                     
                                    if(i==0) {
                                        masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
                                    } else {
                                        UniAppManager.app.onNewDataButtonDown();
                                        masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
                                    }
                                }); 
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
                        },
                        applyextparam: function(popup){                         
                            popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                        }
                    }
                })
            },
            { dataIndex: 'ITEM_NAME'           ,           width: 200},
            { dataIndex: 'SPEC'                ,           width: 200},
            { dataIndex: 'OEM_ITEM_CODE'       ,           width: 100},
            { dataIndex: 'ISSUE_GUBUN'         ,           width: 80},
            { dataIndex: 'ISSUE_TYPE'          ,           width: 80},
            { dataIndex: 'ISSUE_STATUS'        ,           width: 80},
            { dataIndex: 'ISSUE_CONTENTS'      ,           width: 200},
            { dataIndex: 'ACT_CONTENTS'        ,           width: 200},
            { dataIndex: 'REFLECTION_YN'       ,           width: 80},
            { dataIndex: 'REMARK'              ,           width: 200},
            { dataIndex: 'TEMP'                ,           width: 80, hidden: true}
        ],
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
                if(e.record.phantom) {
                    if(UniUtils.indexOf(e.field, ['DOC_NUM', 'DIV_CODE', 'ITEM_NAME', 'SPEC', 'OEM_ITEM_CODE', 'CUSTOM_NAME'])) 
                    { 
                        return false;
                    } else {
                        return true;
                    }
                } else {
                	if(UniUtils.indexOf(e.field, ['DOC_NUM', 'DIV_CODE', 'ITEM_NAME', 'SPEC', 'OEM_ITEM_CODE', 'CUSTOM_NAME']))
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
                        var docNum = record.data.DOC_NUM;
                        s_zbb300ukrv_kdService.getFileList({DOC_NUM : docNum},              //파일조회 메서드  호출(param - 파일번호) 
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
                        var docNum = null;
                        s_zbb300ukrv_kdService.getFileList({DOC_NUM : docNum},              //파일조회 메서드  호출(param - 파일번호) 
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
                    var docNum = null;
                    s_zbb300ukrv_kdService.getFileList({DOC_NUM : docNum},              //파일조회 메서드  호출(param - 파일번호) 
                        function(provider, response) {                          
                            fp.loadData(response.result);                       //업로드 파일 load해서 보여주기
                            fp.getEl().unmask();                                //mask off
    //                        UniAppManager.setToolbarButtons('save',false);      //저장버튼 비활성화
                        }
                    );
                }
            }
        },
        setItemData: function(record, dataClear) {
            var grdRecord = this.getSelectedRecord();
            if(dataClear) {                                     
                grdRecord.set('ITEM_CODE'           , ''); 
                grdRecord.set('ITEM_NAME'           , '');  
                grdRecord.set('SPEC'                , '');  
                grdRecord.set('OEM_ITEM_CODE'       , '');        
            } else {                                    
                grdRecord.set('ITEM_CODE'           , record['ITEM_CODE']);  
                grdRecord.set('ITEM_NAME'           , record['ITEM_NAME']);  
                grdRecord.set('SPEC'                , record['SPEC']);
                grdRecord.set('OEM_ITEM_CODE'       , record['OEM_ITEM_CODE']);
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
            }    
        ],
        id  : 's_zbb300ukrv_kdApp',
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
            var fp = inputTable.down('xuploadpanel');
            fp.loadData({});  
        },
        onNewDataButtonDown: function() {       // 행추가
            if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
        	var compCode        =   UserInfo.compCode; 
            var divCode         =   panelResult.getValue('DIV_CODE');
            var workDate        =   UniDate.get('today')
            var docNum          =   panelResult.getValue('DOC_NUM');
            var reflectionYn    =   'N';
            
            var r = {
                COMP_CODE:          compCode,
                DIV_CODE:           divCode,
                WORK_DATE:          workDate,
                DOC_NUM:            docNum,
                REFLECTION_YN:      reflectionYn
            };
            masterGrid.createRow(r);
        },
        onDeleteDataButtonDown: function() {
        	var selRow = masterGrid.getSelectedRecord();
            if(selRow.phantom === true) {
                masterGrid.deleteSelectedRow();
            } else {
        	    if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                    masterGrid.deleteSelectedRow();
                }
            }
        },
        onSaveDataButtonDown: function () {
        	var fp = inputTable.down('xuploadpanel');
            var addFiles = fp.getAddFiles();             
            var removeFiles = fp.getRemoveFiles();
            panelResult.setValue('ADD_FID', addFiles);                  //추가 파일 담기
            panelResult.setValue('DEL_FID', removeFiles);               //삭제 파일 담기         
            
            if(masterGrid.getSelectedRecord() && !Ext.isEmpty(addFiles) || !Ext.isEmpty(removeFiles) ){   //파일변경이 있을시..
                masterGrid.getSelectedRecord().set('TEMP', addCnt);        //저장을 일으키기 위해 임의로 set...
                addCnt++
            }
            directMasterStore.saveStore();
        },
        setDefault: function() {
            directMasterStore.clearData();  
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('WORK_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('WORK_DATE_TO', UniDate.get('today'));
            UniAppManager.setToolbarButtons(['save'], false);
        }                         
    });                         
}
</script>