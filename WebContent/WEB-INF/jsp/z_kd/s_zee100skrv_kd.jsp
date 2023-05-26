<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_zee100skrv_kd">
    <t:ExtComboStore comboType="BOR120"  pgmId="s_zee100skrv_kd"  />    <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="WZ10" />                 <!--장비구분-->
    <t:ExtComboStore comboType="AU" comboCode="WZ11" />                 <!--이관부서-->
    <t:ExtComboStore comboType="AU" comboCode="WZ12" />                 <!--사용-->
    <t:ExtComboStore comboType="AU" comboCode="WZ13" />                 <!--SW_OS-->
    <t:ExtComboStore comboType="AU" comboCode="WZ14" />                 <!--SW_HWP-->
    <t:ExtComboStore comboType="AU" comboCode="WZ15" />                 <!--SW_MS-->
    <t:ExtComboStore comboType="AU" comboCode="WZ16" />                 <!--SW_VC-->
    <t:ExtComboStore comboType="AU" comboCode="WZ17" />                 <!--SW_ETC1-->
    <t:ExtComboStore comboType="AU" comboCode="WZ18" />                 <!--SW_ETC2-->
    <t:ExtComboStore comboType="AU" comboCode="WZ19" />                 <!--SW_ETC3-->
    <t:ExtComboStore comboType="AU" comboCode="WZ20" />                 <!--SW구분-->
</t:appConfig>
<script type="text/javascript">

var BsaCodeInfo = { //컨트롤러에서 값을 받아옴.
    gsAutoType  :   '${gsAutoType}'
};

var selectedGrid = 's_zee100skrv_kdGrid1';

function appMain() {

    var isAutoOrderNum = false;
    if(BsaCodeInfo.gsAutoType == 'Y') {
        isAutoOrderNum = true;
    }
    
    var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
        api: {
            read    : 's_zee100skrv_kdService.selectList'
        }
    });
    
    var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
        api: {
            read    : 's_zee100skrv_kdService.selectList2'
        }
    });
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('s_zee100skrv_kdModel', {
        fields: [
            {name : 'COMP_CODE',            text : '법인코드',             type : 'string'},
            {name : 'DIV_CODE',             text : '사업장',               type : 'string'},
            {name : 'SW_TYPE',              text : 'SW구분',               type : 'string', comboType : 'AU', comboCode : 'WZ20'},
            {name : 'SW_CODE',              text : 'SW코드',               type : 'string'},
            {name : 'SW_NAME',              text : 'SW명',                 type : 'string'},
            {name : 'BUY_QTY',              text : '보유수량',             type : 'uniQty'},
            {name : 'INSTALL_QTY',          text : '설치수량',             type : 'uniQty'},
            {name : 'WANT_QTY',             text : '과부족수량',           type : 'uniQty'},
            {name : 'REMARK',               text : '비고',                 type : 'string'}
        ]
    });
    
    Unilite.defineModel('s_zee100skrv_kdModel2', {
        fields: [
            {name : 'COMP_CODE',            text : '법인코드',             type : 'string'},
            {name : 'DIV_CODE',             text : '사업장',               type : 'string'},
            {name : 'EQDOC_CODE',           text : '장비대장번호',         type : 'string'},
            {name : 'BUY_DATE',             text : '구입일자',             type : 'uniDate'},
            {name : 'MGM_DEPT_CODE',        text : '관리부서코드',         type : 'string'},
            {name : 'MGM_DEPT_NAME',        text : '관리부서명',           type : 'string'},
            {name : 'EQDOC_TYPE',           text : '장비구분',             type : 'string', comboType : 'AU', comboCode : 'WZ10'},
            {name : 'ITEM_NAME',            text : '제품명',               type : 'string'},
            {name : 'MODEL_NO',             text : '모델번호',             type : 'string'},
            {name : 'SERIAL_NO',            text : '시리얼',               type : 'string'},
            {name : 'EQDOC_SPEC',           text : '규격',                 type : 'string'},
            {name : 'MAKE_COMP',            text : '제조업체',             type : 'string'},
            {name : 'M_BUY_DATE',           text : '모니터구입일',         type : 'uniDate'},
            {name : 'M_NAME',               text : '모니터명',             type : 'string'},
            {name : 'M_MODEL_NO',           text : '모니터모델',           type : 'string'},
            {name : 'M_SPEC',               text : '모니터규격',           type : 'string'},
            {name : 'M_MAKE_COMP',          text : '모니터제조',           type : 'string'},
            {name : 'BIZ_REMARK',           text : '주요업무처리현황',     type : 'string'},
            {name : 'INS_DEPT_CODE',        text : '설치부서코드',         type : 'string'},
            {name : 'INS_DEPT_NAME',        text : '설치부서명',           type : 'string'},
            {name : 'DISP_DATE',            text : '폐기일자',             type : 'uniDate'},
            {name : 'STATUS',               text : '이관부서',             type : 'string', comboType : 'AU', comboCode : 'WZ11'},
            {name : 'USE_YN',               text : '사용',                 type : 'string', comboType : 'AU', comboCode : 'WZ12'},
            {name : 'REMARK',               text : '비고',                 type : 'string'},
            {name : 'SW_OS',                text : 'OS',                   type : 'string', comboType : 'AU', comboCode : 'WZ13'},
            {name : 'SW_HWP',               text : '한글',                 type : 'string', comboType : 'AU', comboCode : 'WZ14'},
            {name : 'SW_MSOFFICE',          text : '오피스',               type : 'string', comboType : 'AU', comboCode : 'WZ15'},
            {name : 'SW_VACCIN',            text : '백신',                 type : 'string', comboType : 'AU', comboCode : 'WZ16'},
            {name : 'SW_ETC1',              text : '기타',                 type : 'string', comboType : 'AU', comboCode : 'WZ17'},
            {name : 'SW_ETC2',              text : '연구소',               type : 'string', comboType : 'AU', comboCode : 'WZ18'},
            {name : 'SW_ETC3',              text : '기타3',                type : 'string', comboType : 'AU', comboCode : 'WZ19'}
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore1 = Unilite.createStore('s_zee100skrv_kdMasterStore1',{
        model: 's_zee100skrv_kdModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  false,            // 수정 모드 사용 
            deletable: false,            // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy1,
        loadStoreRecords : function()   {   
            var param = panelResult.getValues();
            this.load({
                  params : param
            });         
        }
    }); // End of var directMasterStore1

    var directMasterStore2 = Unilite.createStore('s_zee100skrv_kdMasterStore2',{
        model: 's_zee100skrv_kdModel2',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  false,            // 수정 모드 사용 
            deletable: false,            // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy2,
        loadStoreRecords : function(param) {   
            this.load({
                  params : param
            });         
        }
    }); // End of var directMasterStore1    
    
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank : false,
                value: UserInfo.divCode
            },{
                xtype: 'uniCheckboxgroup',  
                fieldLabel: '소프트웨어',
                items: [{
                    boxLabel: 'OS',
                    width: 50,
                    name: 'WZ13',
                    inputValue: 'WZ13',
                    uncheckedValue: 'N',
                    checked: true
                },{
                    boxLabel: 'HWP',
                    width: 50,
                    name: 'WZ14',
                    inputValue: 'WZ14',
                    uncheckedValue: 'N',
                    checked: true
                },{
                    boxLabel: 'MS',
                    width: 50,
                    name: 'WZ15',
                    inputValue: 'WZ15',
                    uncheckedValue: 'N',
                    checked: true
                },{
                    boxLabel: '백신',
                    width: 50,
                    name: 'WZ16',
                    inputValue: 'WZ16',
                    uncheckedValue: 'N',
                    checked: true
                },{
                    boxLabel: '기타',
                    width: 50,
                    name: 'WZ17',
                    inputValue: 'WZ17',
                    uncheckedValue: 'N',
                    checked: true
                },{
                    boxLabel: '연구소',
                    width: 80,
                    name: 'WZ18',
                    inputValue: 'WZ18',
                    uncheckedValue: 'N',
                    checked: true
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
                        var popupFC = item.up('uniPopupField'); 
                        if(popupFC.holdable == 'hold') {
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
    
    var masterGrid = Unilite.createGrid('s_zee100skrv_kdGrid1', { 
        layout : 'fit',   
        region: 'center',                          
        store: directMasterStore1,
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
        selModel:'rowmodel',
        columns:  [
            {dataIndex : 'COMP_CODE',                   width : 100, hidden: true},
            {dataIndex : 'DIV_CODE',                    width : 100, hidden: true},
            {dataIndex : 'SW_TYPE',                     width : 100},
            {dataIndex : 'SW_CODE',                     width : 100, hidden: true},
            {dataIndex : 'SW_NAME',                     width : 200},
            {dataIndex : 'BUY_QTY',                     width : 100},
            {dataIndex : 'INSTALL_QTY',                 width : 100},
            {dataIndex : 'WANT_QTY',                    width : 100},
            {dataIndex : 'REMARK',                      width : 300, hidden: true}
        ],
        listeners: {
            selectionchange:function( model1, selected, eOpts ) {
            	if(selected.length > 0) {
                	var record = selected[0];
                	var param = {
                		'DIV_CODE': record.get('DIV_CODE'),
                		'SW_TYPE':  record.get('SW_TYPE'),
                		'SW_CODE':  record.get('SW_CODE')
                	}
                	directMasterStore2.loadStoreRecords(param); 
            	}
            }
        }
    });
    
    var masterGrid2 = Unilite.createGrid('s_zee100skrv_kdGrid2', { 
        layout : 'fit',
        region: 'south',
        store: directMasterStore2,
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
        columns: [
            {dataIndex : 'COMP_CODE',                   width : 100, hidden : true},
            {dataIndex : 'DIV_CODE',                    width : 130, hidden : true},
            {dataIndex : 'BUY_DATE',                    width : 100, hidden : true},
            {dataIndex : 'MGM_DEPT_CODE',               width : 110, hidden : true},
            {dataIndex : 'MGM_DEPT_NAME',               width : 200},
            {dataIndex : 'INS_DEPT_CODE',               width : 120, hidden : true},
            {dataIndex : 'INS_DEPT_NAME',               width : 200},
            {dataIndex : 'EQDOC_CODE',                  width : 130},
            {dataIndex : 'ITEM_NAME',                   width : 160},
            {dataIndex : 'MODEL_NO',                    width : 120},
            {dataIndex : 'SW_OS',                       width : 80, hidden : true},
            {dataIndex : 'SW_HWP',                      width : 80, hidden : true},
            {dataIndex : 'SW_MSOFFICE',                 width : 80, hidden : true},
            {dataIndex : 'SW_VACCIN',                   width : 80, hidden : true},
            {dataIndex : 'SW_ETC1',                     width : 80, hidden : true},
            {dataIndex : 'SW_ETC2',                     width : 80, hidden : true},
            {dataIndex : 'EQDOC_TYPE',                  width : 120, hidden : true},
            {dataIndex : 'SERIAL_NO',                   width : 120, hidden : true},
            {dataIndex : 'EQDOC_SPEC',                  width : 120, hidden : true},
            {dataIndex : 'MAKE_COMP',                   width : 120, hidden : true},
            {dataIndex : 'M_BUY_DATE',                  width : 120, hidden : true},
            {dataIndex : 'M_NAME',                      width : 120, hidden : true},
            {dataIndex : 'M_MODEL_NO',                  width : 120, hidden : true},
            {dataIndex : 'M_SPEC',                      width : 120, hidden : true},
            {dataIndex : 'M_MAKE_COMP',                 width : 120, hidden : true},
            {dataIndex : 'BIZ_REMARK',                  width : 150},
            {dataIndex : 'USE_YN',                      width : 80, hidden : true},
            {dataIndex : 'STATUS',                      width : 110, hidden : true},
            {dataIndex : 'DISP_DATE',                   width : 120, hidden : true},
            {dataIndex : 'REMARK',                      width : 150, hidden : true}
        ]
    });    
    
    Unilite.Main( {
        borderItems:[{
                region:'center',
                layout: 'border',
                border: false,
                items:[
                	panelResult, masterGrid, masterGrid2
                ]
            }
        ],
        id  : 's_zee100skrv_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData', 'deleteAll', 'delete'], false);
            this.setDefault();
        },
        onQueryButtonDown : function() {
        	if(panelResult.setAllFieldsReadOnly(true) == false) {
                return false;
            }
            directMasterStore1.loadStoreRecords();
            UniAppManager.setToolbarButtons(['reset'], true);
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            panelResult.clearForm();
            masterGrid.reset();
            masterGrid2.reset();
            this.setDefault();
        },
        setDefault: function() {
            directMasterStore1.clearData();
            directMasterStore2.clearData();
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('WZ13', true);
            panelResult.setValue('WZ14', true);
            panelResult.setValue('WZ15', true);
            panelResult.setValue('WZ16', true);
            panelResult.setValue('WZ17', true);
            panelResult.setValue('WZ18', true);
            UniAppManager.setToolbarButtons(['save', 'newData', 'deleteAll', 'delete'], false);
        }                         
    });                         
}
</script>