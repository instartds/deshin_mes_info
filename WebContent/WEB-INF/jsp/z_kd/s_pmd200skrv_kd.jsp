<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmd200skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_pmd200skrv_kd"  />             <!-- 사업장 -->  
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
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo = {     //컨트롤러에서 값을 받아옴.
    gsAutoType  :   '${gsAutoType}'
};

function appMain() {
	
	var isAutoOrderNum = false;
    if(BsaCodeInfo.gsAutoType=='Y') {
        isAutoOrderNum = true;
    }
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('s_pmd200skrv_kdModel', {
        fields: [
            {name: 'COMP_CODE'              ,text:'법인코드'               ,type: 'string'},
            {name: 'DIV_CODE'               ,text:'사업자코드'             ,type: 'string'},
            {name: 'REQ_NO'                 ,text:'의뢰번호'               ,type: 'string', allowBlank: isAutoOrderNum},
            {name: 'REQ_DATE'               ,text:'의뢰일자'               ,type: 'uniDate'},
            {name: 'REQ_TYPE'               ,text:'의뢰구분'               ,type: 'string', comboType: 'AU', comboCode: 'WB12'},
            {name: 'MOLD_CODE'              ,text:'금형코드'               ,type: 'string'},
            {name: 'MOLD_NAME'              ,text:'금형명'                 ,type: 'string'},
            {name: 'OEM_ITEM_CODE'          ,text:'품번'                   ,type: 'string'},
            {name: 'CAR_TYPE'               ,text:'차종'                   ,type: 'string', comboType: 'AU', comboCode: 'WB04'},
            {name: 'PROG_WORK_CODE'         ,text:'공정코드'               ,type: 'string'},
            {name: 'PROG_WORK_NAME'         ,text:'공정명'                 ,type: 'string'},
            {name: 'REPARE_HDATE'           ,text:'완료요청일'              ,type: 'uniDate'},
            {name: 'REQ_DEPT_CODE'          ,text:'의뢰부서'               ,type: 'string'},
            {name: 'REQ_DEPT_NAME'          ,text:'의뢰부서명'             ,type: 'string'},
            {name: 'REQ_WORKMAN'            ,text:'의뢰자'                 ,type: 'string'},
            {name: 'REQ_WORKMAN_NAME'       ,text:'의뢰자명'                 ,type: 'string'},
            {name: 'NOW_DEPR'               ,text:'이전 현상각'            ,type: 'uniQty'},
            {name: 'DATE_BEHV'              ,text:'이전 보수완료일'         ,type: 'uniDate'},
            {name: 'CHK_DEPR'               ,text:'이전 점검상각수'         ,type: 'uniQty'},
            {name: 'REP_DEPT_CODE'          ,text:'처리부서'               ,type: 'string'},
            {name: 'REP_DEPT_NAME'          ,text:'처리부서명'             ,type: 'string'},
            {name: 'REP_WORKMAN'            ,text:'작업자'                 ,type: 'string'},
            {name: 'REP_WORKMAN_NAME'       ,text:'작업자명'                 ,type: 'string'},
            {name: 'REP_FR_DATE'            ,text:'보수시작일'             ,type: 'uniDate'},
            {name: 'REP_FR_HHMMSS'          ,text:'시작시간분'             ,type: 'string'},
            {name: 'REP_TO_DATE'            ,text:'보수완료일'             ,type: 'uniDate'},
            {name: 'REP_TO_HHMMSS'          ,text:'완료시간분'             ,type: 'string'},
            {name: 'SUM_REP_WORKTIME'       ,text:'총작업시간'             ,type: 'string'},
            {name: 'REP_CODE'               ,text:'보수코드'               ,type: 'string', comboType: 'AU', comboCode: 'WB13'},
            {name: 'STATUS'                 ,text:'진행구분'               ,type: 'string', comboType: 'AU', comboCode: 'WB14'},
            {name: 'REQ_REMARK'             ,text:'의뢰내용'               ,type: 'string'},
            {name: 'RST_REMARK'             ,text:'결과내용'               ,type: 'string'}
        ]
    }); 
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore = Unilite.createStore('s_pmd200skrv_kdMasterStore1',{
        model: 's_pmd200skrv_kdModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {          
                read: 's_pmd200skrv_kdService.selectList'                 
            }
        },
        loadStoreRecords : function()   {   
            var param= panelResult.getValues();
            this.load({
                  params : param
            });         
        }
    }); // End of var directMasterStore1 
    
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
                value: UserInfo.divCode
            },      
            Unilite.popup('DEPT', {
                    fieldLabel: '부서', 
                    valueFieldName: 'REQ_DEPT_CODE',
                    textFieldName: 'REQ_DEPT_NAME'
            }),{
                fieldLabel: '품번',
                name:'OEM_ITEM_CODE',  
                xtype: 'uniTextfield',
                colspan:2
            },{
                fieldLabel: '의뢰번호',
                name:'REQ_NO',   
                xtype: 'uniTextfield',
//                readOnly: isAutoOrderNum,
                holdable: isAutoOrderNum ? 'readOnly':'hold'
            },{ 
                fieldLabel: '의뢰일자',
                xtype: 'uniDateRangefield',
                startFieldName: 'REQ_DATE_FR',
                endFieldName: 'REQ_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today')
            },
            Unilite.popup('MOLD_CODE',{ 
                fieldLabel: '금형',
                valueFieldName:'MOLD_CODE',
                textFieldName:'MOLD_NAME',
                valueFieldWidth: 120,
                textFieldWidth: 200,
                autoPopup: true,
                listeners: {
                    applyextparam: function(popup){
                        popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                    }                                   
                }
            }),{
                fieldLabel: '진행구분',
                name:'STATUS',  
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'WB14'
            },{
                fieldLabel: '의뢰구분',
                name:'REQ_TYPE',  
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'WB12'
            },{
                fieldLabel: '의뢰내용',
                xtype: 'textfield',
                name: 'REQ_REMARK'
            },{
                fieldLabel: '결과내용',
                xtype: 'textfield',
                name: 'RST_REMARK'
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
        padding:'1 1 1 1',
        region: 'center',
        masterGrid: masterGrid,
        items: [{
                fieldLabel: '의뢰내용',
                xtype: 'textareafield',
                name: 'REQ_REMARK',
                height : 50,
                width: 500,
                readOnly: true
            },{
                fieldLabel: '결과내용',
                xtype: 'textareafield',
                name: 'RST_REMARK',
                height : 50,
                width: 500,
                readOnly: true
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
    
    var masterGrid = Unilite.createGrid('s_pmd200skrv_kdmasterGrid', { 
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
        selModel: 'rowmodel',
        columns:  [ 
            { dataIndex: 'COMP_CODE'                          ,           width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'                           ,           width: 80, hidden: true},
            { dataIndex: 'REQ_NO'                             ,           width: 120},
            { dataIndex: 'REQ_DATE'                           ,           width: 90},
            { dataIndex: 'REQ_TYPE'                           ,           width: 80},
            { dataIndex: 'MOLD_CODE'                          ,           width: 120},
            { dataIndex: 'MOLD_NAME'                          ,           width: 180},
            { dataIndex: 'OEM_ITEM_CODE'                      ,           width: 120},
            { dataIndex: 'CAR_TYPE'                           ,           width: 90},
            { dataIndex: 'PROG_WORK_CODE'                     ,           width: 100},
            { dataIndex: 'PROG_WORK_NAME'                     ,           width: 200},
            { dataIndex: 'REPARE_HDATE'                       ,           width: 90},
            { dataIndex: 'REQ_DEPT_CODE'                      ,           width: 100},
            { dataIndex: 'REQ_DEPT_NAME'                      ,           width: 200},
            { dataIndex: 'REQ_WORKMAN'                        ,           width: 100},
            { dataIndex: 'REQ_WORKMAN_NAME'                   ,           width: 100},
            { dataIndex: 'NOW_DEPR'                           ,           width: 150},
            { dataIndex: 'DATE_BEHV'                          ,           width: 120},
            { dataIndex: 'CHK_DEPR'                           ,           width: 150},
            { dataIndex: 'REP_DEPT_CODE'                      ,           width: 100},
            { dataIndex: 'REP_DEPT_NAME'                      ,           width: 200},
            { dataIndex: 'REP_WORKMAN'                        ,           width: 100},
            { dataIndex: 'REP_WORKMAN_NAME'                   ,           width: 100},
            { dataIndex: 'REP_FR_DATE'                        ,           width: 90},
            { dataIndex: 'REP_FR_HHMMSS'                      ,           width: 80},
            { dataIndex: 'REP_TO_DATE'                        ,           width: 90},
            { dataIndex: 'REP_TO_HHMMSS'                      ,           width: 80},
            { dataIndex: 'SUM_REP_WORKTIME'                   ,           width: 100},
            { dataIndex: 'REP_CODE'                           ,           width: 100},
            { dataIndex: 'STATUS'                             ,           width: 100},
            { dataIndex: 'REQ_REMARK'                         ,           width: 80, hidden: true},
            { dataIndex: 'RST_REMARK'                         ,           width: 80, hidden: true}
        ],
        listeners: {
            selectionchange:function( model1, selected, eOpts ){
                inputTable.loadForm(selected); 
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
                        region : 'south',
                        xtype : 'container',
                        highth: 20,
                        layout : 'fit',
                        items : [ inputTable ]
                    }
                ]
            }     
        ],
        id  : 's_pmd200skrv_kdApp',
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
            UniAppManager.setToolbarButtons(['newData','deleteAll'],false);
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            panelResult.clearForm(); 
            masterGrid.reset();
            this.setDefault();
        },
        setDefault: function() {
            directMasterStore.clearData();
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('REQ_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('REQ_DATE_TO', UniDate.get('today'));
            
            UniAppManager.setToolbarButtons(['save'], false);
        }
    });    
};
</script>