<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_zdd100skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_zdd100skrv_kd"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--매출구분-->
    <t:ExtComboStore comboType="AU" comboCode="WB07" /> <!--설비구분-->
    <t:ExtComboStore comboType="AU" comboCode="WZ01" /> <!--진행(검교정)-->
    <t:ExtComboStore comboType="AU" comboCode="WZ03" /> <!--주기(월)-->
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
    <t:ExtComboStore comboType="AU" comboCode="WB16" /> <!--문서종류-->
</t:appConfig>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' >
</script>
<script type="text/javascript" >

var BsaCodeInfo = {     //컨트롤러에서 값을 받아옴.
    gsAutoType  :   '${gsAutoType}'
};

function appMain() {
    
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_zdd100skrv_kdService.selectList'
        }
    });
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('s_zdd100skrv_kdModel', {
        fields: [
            {name: 'COMP_CODE'              ,text:'법인코드'              ,type: 'string'},
            {name: 'DIV_CODE'               ,text:'사업장'                ,type: 'string'},
            {name: 'EQUIP_CODE'             ,text:'설비코드'              ,type: 'string'},
            {name: 'EQUIP_NAME'             ,text:'설비명'                ,type: 'string'},
            {name: 'EQUIP_SPEC'             ,text:'규격'                  ,type: 'string'},
            {name: 'DEPT_CODE'              ,text:'부서코드'              ,type: 'string'},
            {name: 'DEPT_NAME'              ,text:'부서코드'              ,type: 'string'},
            {name: 'CALI_CYCLE_MM'          ,text:'주기(월)'              ,type: 'string', comboType: 'AU', comboCode: 'WZ03'},
            {name: 'CALI_AVAIL_DATE'        ,text:'유효일(검교정)'        ,type: 'uniDate'},
            {name: 'CALI_STATUS'            ,text:'진행(검교정)'          ,type: 'string', comboType: 'AU', comboCode: 'I801', allowBlank: false},
            {name: 'CALI_CYCLE_MM_TEMP'     ,text:'차기검교정일'        ,type: 'uniDate'},
            {name: 'CALI_REMARK'            ,text:'비고(검교정)'          ,type: 'string'}
        ]
    }); 
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore = Unilite.createStore('s_zdd100skrv_kdMasterStore1',{
        model: 's_zdd100skrv_kdModel',
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
            },{
                fieldLabel: '설비구분',
                name:'EQUIP_TYPE',  
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'I802'
            },
            Unilite.popup('EQUIP_CODE',{ 
                    fieldLabel: '설비',
                    validateBlank: false,
                    valueFieldName:'EQUIP_CODE',
                    textFieldName:'EQUIP_NAME'
            }),{ 
                fieldLabel: '유효기간',
                xtype: 'uniDateRangefield',
                startFieldName: 'CALI_AVAIL_DATE_FR',
                endFieldName: 'CALI_AVAIL_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today')
            },{
                fieldLabel: '진행구분',
                name:'CALI_STATUS',  
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'I801'
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
    
    var masterGrid = Unilite.createGrid('s_zdd100skrv_kdmasterGrid', { 
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
            { dataIndex: 'COMP_CODE'                              ,           width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'                               ,           width: 80, hidden: true},
            { dataIndex: 'EQUIP_CODE'                             ,           width: 100},
            { dataIndex: 'EQUIP_NAME'                             ,           width: 200},
            { dataIndex: 'EQUIP_SPEC'                             ,           width: 200},
            { dataIndex: 'DEPT_CODE'                              ,           width: 100},
            { dataIndex: 'DEPT_NAME'                              ,           width: 200},
            { dataIndex: 'CALI_CYCLE_MM'                          ,           width: 100},
            { dataIndex: 'CALI_AVAIL_DATE'                        ,           width: 100},
            { dataIndex: 'CALI_STATUS'                            ,           width: 100, align : 'center'},
            { dataIndex: 'CALI_CYCLE_MM_TEMP'                     ,           width: 100},
            { dataIndex: 'CALI_REMARK'                            ,           width: 200}
        ]
    });
    
    
    Unilite.Main( {
        borderItems:[{
                region:'center',
                layout: 'border',
                border: false,
                items:[
                    masterGrid, panelResult
                ]
            }
        ],
        id  : 's_zdd100skrv_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll', 'newData'],false);
            this.setDefault();
        },
        onQueryButtonDown : function()  {
        	if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
            directMasterStore.loadStoreRecords();
            UniAppManager.setToolbarButtons(['reset'], true);
            UniAppManager.setToolbarButtons(['newData'], false);
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            panelResult.clearForm();
            masterGrid.reset();
            this.setDefault();
        },
        setDefault: function() {
            directMasterStore.clearData();  
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll', 'newData'],false);
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('CALI_AVAIL_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('CALI_AVAIL_DATE_TO', UniDate.get('today'));
        }                         
    });                         
}
</script>