<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_zcc100skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_zcc100skrv_kd"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="WB04" /> <!-- 차종  -->
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
            read: 's_zcc100skrv_kdService.selectList'
        }
    });
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('s_zcc100skrv_kdModel', {
        fields: [
            {name: 'COMP_CODE'              ,text:'법인코드'               ,type: 'string'},
            {name: 'ISIR_NUM'               ,text:'ISIR번호'               ,type: 'string'},
            {name: 'DIV_CODE'               ,text:'사업장'                 ,type: 'string', xtype: 'uniCombobox', comboType: 'BOR120'},
            {name: 'ITEM_CODE'              ,text:'품목코드'               ,type: 'string'},
            {name: 'ITEM_NAME'              ,text:'품목명'                 ,type: 'string'},
            {name: 'OEM_ITEM_CODE'          ,text:'품번'                   ,type: 'string'},
            {name: 'SPEC'                   ,text:'규격'                   ,type: 'string'},
            {name: 'CAR_TYPE'               ,text:'차종'                   ,type: 'string', comboType: 'AU', comboCode: 'WB04'},
            {name: 'REMARK'                 ,text:'비고'                   ,type: 'string'}/*,
            {name: 'FLAG'                   ,text:'FLAG'                   ,type: 'string'}*/
        ]
    }); 
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore = Unilite.createStore('s_zcc100skrv_kdMasterStore1',{
        model: 's_zcc100skrv_kdModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  false,            // 수정 모드 사용 
            deletable: false,            // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {   
            var param= panelResult.getValues();
            this.load({
                  params : param
            });         
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
                value: UserInfo.divCode
            },
            Unilite.popup('DIV_PUMOK',{ 
                    fieldLabel: '품목코드',
                    valueFieldName: 'ITEM_CODE', 
                    textFieldName: 'ITEM_NAME', 
                    autoPopup:true,
                    listeners: {
                        applyextparam: function(popup){ 
                            popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                            popup.setExtParam({'ITEM_ACCOUNT_FILTER': ['00','10']});
                        }
                    }
            }),{
                fieldLabel: '품번',
                name:'OEM_ITEM_CODE',  
                xtype: 'uniTextfield'
            },{
                fieldLabel: '비고',
                name:'REMARK',  
                xtype: 'textarea',
                colspan: 3,
                width: 552
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
                           UniAppManager.app.setToolbarButtons('save', false);  //파일 추가or삭제시 저장버튼 on
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
    
    var masterGrid = Unilite.createGrid('s_zcc100skrv_kdmasterGrid', { 
        layout : 'fit',   
        region: 'center',                          
        store: directMasterStore,
        selModel: 'rowmodel', 
        uniOpt: {
            expandLastColumn: true,
            useMultipleSorting: false,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useRowNumberer: true,
            onLoadSelectFirst: true,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        columns:  [ 
            { dataIndex: 'COMP_CODE'                             ,           width: 80, hidden:true},
            { dataIndex: 'ISIR_NUM'                              ,           width: 120, hidden:true},
            { dataIndex: 'DIV_CODE'                              ,           width: 120},
            { dataIndex: 'OEM_ITEM_CODE'                         ,           width: 100},
            { dataIndex: 'ITEM_CODE'                             ,           width: 110},
            { dataIndex: 'ITEM_NAME'                             ,           width: 200},
            { dataIndex: 'SPEC'                                  ,           width: 250},
            { dataIndex: 'CAR_TYPE'                              ,           width: 150},
            { dataIndex: 'REMARK'                                ,           width: 250}/*,
            { dataIndex: 'FLAG'                                  ,           width: 100, hidden: false}*/
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
            },*/
            selectionchange:function( model1, selected, eOpts ){
                var record = selected[0];
                inputTable.loadForm(selected);                              
                var fp = inputTable.down('xuploadpanel');                  //mask on
                if(directMasterStore.getCount() > 0 && record){
//                	if(record.data.FLAG == 'Y') {
                        fp.loadData({});
                        fp.getEl().mask('로딩중...','loading-indicator');
                        var isirNum = record.data.ISIR_NUM;
                        s_zcc100skrv_kdService.getFileList({ISIR_NUM : isirNum},              //파일조회 메서드  호출(param - 파일번호) 
                            function(provider, response) {                          
                                fp.loadData(response.result);                       //업로드 파일 load해서 보여주기
                                fp.getEl().unmask();                                //mask off
                                //UniAppManager.setToolbarButtons('save',false);      //저장버튼 비활성화
                            }
                         );
//                    }
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
        id  : 's_zcc100skrv_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'],false);
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
        setDefault: function() {
            directMasterStore.clearData();  
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
        }                         
    });                         
}
</script>