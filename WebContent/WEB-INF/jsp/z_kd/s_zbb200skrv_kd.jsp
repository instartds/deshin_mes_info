<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_zbb200skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_zbb200skrv_kd"  />    <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="WB04" />                 <!--차종-->
    <t:ExtComboStore comboType="AU" comboCode="WZ30" />                 <!--FMEA구분-->
    <t:ExtComboStore comboType="AU" comboCode="WZ29" />                 <!--부품구분-->
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
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('s_zbb200skrv_kdModel', {
        fields: [
            {name : 'COMP_CODE',        text : '법인코드',              type : 'string'},
            {name : 'DIV_CODE',         text : '사업장',               type : 'string'},
            {name : 'DOC_NUM',          text : 'FMEA번호',            type : 'string', allowBlank: isAutoOrderNum},
            {name : 'WORK_GUBUN',       text : '구분',                type : 'string', comboType: 'AU', comboCode: 'WZ30', allowBlank : false},
            {name : 'PART_GUBUN',       text : '부품구분',             type : 'string', comboType: 'AU', comboCode: 'WZ29', allowBlank : false},
            {name : 'WORK_DATE',        text : '등록일자',              type : 'uniDate', allowBlank : false},
            {name : 'REVISION_NO',      text : '리비젼',               type : 'int', allowBlank : false, maxLength : 2},
            {name : 'CUSTOM_CODE',      text : '거래처코드',             type : 'string'},
            {name : 'CUSTOM_NAME',      text : '거래처명',              type : 'string'},
            {name : 'ITEM_CODE',        text : '품목코드',              type : 'string'},
            {name : 'ITEM_NAME',        text : '품목명',               type : 'string'},
            {name : 'OEM_ITEM_CODE',    text : '품번',                type : 'string'},
            {name : 'CAR_TYPE',         text : '차종',                type : 'string', comboType: 'AU', comboCode: 'WB04'},
            {name : 'WORK_MAN',         text : '작성자',               type : 'string'},
            {name : 'DOC_FILE_LINK',    text : '링크 첨부',             type : 'string'},
            {name : 'REMARK',           text : '비고',                type : 'string'}
        ]
    }); 
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore = Unilite.createStore('s_zbb200skrv_kdMasterStore1', {
        model: 's_zbb200skrv_kdModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  false,           // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {          
                read: 's_zbb200skrv_kdService.selectList'                 
            }
        },
        loadStoreRecords : function() {
            var param = panelResult.getValues();
            this.load({
                  params : param
            });         
        }
    }); // End of var directMasterStore1 
    
    var panelResult = Unilite.createSearchForm('resultForm', {
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        items: [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank : false,
                value: UserInfo.divCode
            }, {
                fieldLabel: '구분',
                name:'WORK_GUBUN',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'WZ28'
            }, {
                fieldLabel: '부품구분',
                name:'PART_GUBUN',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'WZ29'
            },
            Unilite.popup('AGENT_CUST', {
                fieldLabel: '거래처',
                valueFieldName: 'CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME'
            }),
            Unilite.popup('DIV_PUMOK',{
                    fieldLabel: '품목코드',
                    valueFieldName:'ITEM_CODE',
                    textFieldName:'ITEM_NAME',
                    validateBlank:false,
                    autoPopup:true, 
                    listeners: {
                        applyextparam: function(popup){                         
                            popup.setExtParam({'DIV_CODE' : panelResult.getValue('DIV_CODE')});
                        }
                    }
            }), {
                fieldLabel: '품번',
                name:'OEM_ITEM_CODE',
                xtype: 'uniTextfield'
            }, {
                fieldLabel: 'FMEA번호',
                name:'DOC_NUM',
                xtype: 'uniTextfield'//,
//                readOnly: isAutoOrderNum,
//                holdable: isAutoOrderNum ? 'readOnly':'hold'
            }, {
                fieldLabel: '등록일자',
                xtype: 'uniDateRangefield',
                startFieldName: 'FR_WORK_DATE',
                endFieldName: 'TO_WORK_DATE',
                allowBlank : false,
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today')
            }, {
                fieldLabel: '비고',
                name:'REMARK',
                width: 500,
                xtype: 'uniTextfield'
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
            me.uniOpt.inLoading = false;
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
                uniOpt: {editable:false}
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
    
    var masterGrid = Unilite.createGrid('s_zbb200skrv_kdmasterGrid', { 
        layout : 'fit',   
        region: 'center',
        store: directMasterStore,
        selModel: 'rowmodel',
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
            {dataIndex : 'COMP_CODE',           width : 130, hidden : true},
            {dataIndex : 'DIV_CODE',            width : 130, hidden : true},
            {dataIndex : 'DOC_NUM',             width : 120},
            {dataIndex : 'WORK_GUBUN',          width : 100},
            {dataIndex : 'PART_GUBUN',          width : 100},
            {dataIndex : 'WORK_DATE',           width : 110, align : 'center'},
            {dataIndex : 'REVISION_NO',         width : 100},
            {dataIndex : 'CUSTOM_CODE',         width : 100},
            {dataIndex : 'CUSTOM_NAME',         width : 170},
            {dataIndex : 'ITEM_CODE',           width : 120},
            {dataIndex : 'ITEM_NAME',           width : 170},
            {dataIndex : 'OEM_ITEM_CODE',       width : 120},
            {dataIndex : 'CAR_TYPE',            width : 110},
            {dataIndex : 'WORK_MAN',            width : 120},
            {dataIndex : 'DOC_FILE_LINK',       width : 120, hidden : true},
            {dataIndex : 'REMARK',              width : 150}
                    
        ],
        listeners: {/*
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
                          UniAppManager.setToolbarButtons('save', false);
                          fp.loadData({});
                          masterGrid.getSelectionModel().select(index);
                       }
                  });
                }
                return isNewCardShow;
            },*/
            selectionchange:function( model1, selected, eOpts ){
                var record = selected[0];
                inputTable.loadForm(selected);                              
                var fp = inputTable.down('xuploadpanel');                  //mask on
                if(directMasterStore.getCount() > 0 && record && !record.phantom){
                    fp.loadData({});
                    fp.getEl().mask('로딩중...','loading-indicator');
                    var docNum = record.data.DOC_NUM;
                    s_zbb200skrv_kdService.getFileList({DOC_NUM : docNum},              //파일조회 메서드  호출(param - 파일번호) 
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
            }
        ],
        id : 's_zbb200skrv_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'], false);
            this.setDefault();
        },
        onQueryButtonDown : function()  {
            if(panelResult.setAllFieldsReadOnly(true) == false) {
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
            var compCode    = UserInfo.compCode; 
            var divCode     = panelResult.getValue('DIV_CODE');
            var workDate    = UniDate.get('today');
            
            var r = {
                COMP_CODE    : compCode,
                DIV_CODE     : divCode,
                WORK_DATE    : workDate
            };
            masterGrid.createRow(r);
        },
        setDefault: function() {
            directMasterStore.clearData();
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('FR_WORK_DATE', UniDate.get('startOfMonth'));
            panelResult.setValue('TO_WORK_DATE', UniDate.get('today'));
            panelResult.getForm().wasDirty = false;
            UniAppManager.setToolbarButtons(['save'], false);
        }
    });                         
}
</script>