<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_zee100ukrv_kd">
    <t:ExtComboStore comboType="BOR120"  pgmId="s_zee100ukrv_kd"  />    <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="WZ10" opts='1;2;3;4'/>                 <!--장비구분-->
    <t:ExtComboStore comboType="AU" comboCode="WZ11" />                 <!--이관부서-->
    <t:ExtComboStore comboType="AU" comboCode="WZ12" />                 <!--사용-->
    <t:ExtComboStore comboType="AU" comboCode="WZ13" />                 <!--SW_OS-->
    <t:ExtComboStore comboType="AU" comboCode="WZ14" />                 <!--SW_HWP-->
    <t:ExtComboStore comboType="AU" comboCode="WZ15" />                 <!--SW_MS-->
    <t:ExtComboStore comboType="AU" comboCode="WZ16" />                 <!--SW_VC-->
    <t:ExtComboStore comboType="AU" comboCode="WZ17" />                 <!--SW_ETC1 2 3 -->
    <t:ExtComboStore comboType="AU" comboCode="WZ18" />                 <!--SW_LAB1 2 3 -->
    <t:ExtComboStore comboType="AU" comboCode="WZ20" />                 <!--SW구분-->
</t:appConfig>
<script type="text/javascript">

var BsaCodeInfo = { //컨트롤러에서 값을 받아옴.
    gsAutoType  :   '${gsAutoType}'
};

var selectedGrid = 's_zee100ukrv_kdGrid1';

function appMain() {

    var isAutoOrderNum = false;
    if(BsaCodeInfo.gsAutoType == 'Y') {
        isAutoOrderNum = true;
    }

    var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
        api: {
            read    : 's_zee100ukrv_kdService.selectList',
            update  : 's_zee100ukrv_kdService.updateDetail',
            syncAll : 's_zee100ukrv_kdService.saveAll'
        }
    });

    var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
        api: {
            read    : 's_zee100ukrv_kdService.selectList2',
            update  : 's_zee100ukrv_kdService.updateDetail2',
            create  : 's_zee100ukrv_kdService.insertDetail2',
            destroy : 's_zee100ukrv_kdService.deleteDetail2',
            syncAll : 's_zee100ukrv_kdService.saveAll2'
        }
    });

    /**
     *   Model 정의
     * @type
     */
    Unilite.defineModel('s_zee100ukrv_kdModel', {
        fields: [
            {name : 'COMP_CODE',            text : '법인코드',             type : 'string'},
            {name : 'DIV_CODE',             text : '사업장',               type : 'string'},
            {name : 'EQDOC_CODE',           text : '장비대장번호',         type : 'string'},
			{name : 'MGM_DEPT_CODE',        text : '관리부서',          	type : 'string', comboType : 'AU', comboCode : 'WZ35', allowBlank : false},
            {name : 'INS_DEPT_CODE',        text : '설치부서',          	type : 'string', comboType : 'AU', comboCode : 'WZ36'},
            {name : 'EQDOC_TYPE',           text : '장비구분',             type : 'string', comboType : 'AU', comboCode : 'WZ10'},
            {name : 'MODEL_NO',             text : '모델번호',             type : 'string'},
            {name : 'BUY_DATE',             text : '구입일자',               type : 'uniDate'},
            
            {name : 'SW_OS',                text : 'OS',                   type : 'string', comboType : 'AU', comboCode : 'WZ13'},
            {name : 'SW_HWP',               text : '한글',                 type : 'string', comboType : 'AU', comboCode : 'WZ14'},
            {name : 'SW_MSOFFICE',          text : '오피스',               type : 'string', comboType : 'AU', comboCode : 'WZ15'},
            {name : 'SW_VACCIN',            text : '백신',                 type : 'string', comboType : 'AU', comboCode : 'WZ16'},
            {name : 'SW_ETC1',              text : '기타1',                 type : 'string', comboType : 'AU', comboCode : 'WZ17'},
            {name : 'SW_ETC2',              text : '기타2',               type : 'string', comboType : 'AU', comboCode : 'WZ17'},
            {name : 'SW_ETC3',              text : '기타3',                 type : 'string', comboType : 'AU', comboCode : 'WZ17'},
            {name : 'SW_LAB1',              text : '연구소1',                 type : 'string', comboType : 'AU', comboCode : 'WZ18'},
            {name : 'SW_LAB2',              text : '연구소2',                 type : 'string', comboType : 'AU', comboCode : 'WZ18'},
            {name : 'SW_LAB3',              text : '연구소3',                 type : 'string', comboType : 'AU', comboCode : 'WZ18'},
            {name : 'BIZ_REMARK',           text : '사용자',     	type : 'string'},
            {name : 'SW_REMARK',           text : '비고',     	type : 'string'},
            
            {name : 'IP',               	text : 'IP',                 type : 'string'},
            {name : 'WINDOW_PASS',          text : '윈도우암호',                 type : 'string'}
        ]
    });

    Unilite.defineModel('s_zee100ukrv_kdModel2', {
        fields: [
            {name : 'COMP_CODE',            text : '법인코드',             type : 'string'},
            {name : 'DIV_CODE',             text : '사업장',               type : 'string'},
            {name : 'SW_TYPE',              text : 'SW구분',               type : 'string', comboType : 'AU', comboCode : 'WZ20', allowBlank: false},
            {name : 'SW_CODE',              text : 'SW코드',               type : 'string', allowBlank: false},
            {name : 'SW_NAME',              text : 'SW명',                 type : 'string', allowBlank: false},
            {name : 'BUY_QTY',              text : '보유수량',                 type : 'uniQty', allowBlank: false},
            {name : 'INSTALL_QTY',          text : '설치수량',             type : 'uniQty'},
            {name : 'WANT_QTY',             text : '과부족수량',           type : 'uniQty'},
            {name : 'REMARK',               text : '비고',                 type : 'string'}
        ]
    });
    
    
    Unilite.defineModel('subModel', {
        fields: [
            {name : 'COMP_CODE',            text : '법인코드',             type : 'string'},
            {name : 'DIV_CODE',             text : '사업장',               type : 'string'},
            {name : 'MGM_DEPT_CODE',        text : '관리부서',         type : 'string', comboType : 'AU', comboCode : 'WZ35'},
            {name : 'INS_DEPT_CODE',        text : '설치부서',         type : 'string', comboType : 'AU', comboCode : 'WZ36'},
            {name : 'EQDOC_CODE',           text : '장비대장번호',         type : 'string'},
            {name : 'EQDOC_TYPE',           text : '장비구분',             type : 'string', comboType : 'AU', comboCode : 'WZ10'},
            {name : 'ITEM_NAME',            text : '제품명',               type : 'string'},
            {name : 'MODEL_NO',             text : '모델번호',             type : 'string'},
            {name : 'BIZ_REMARK',           text : '사용자',     type : 'string'},
            {name : 'SW_REMARK',           text : '비고',     type : 'string'}
            
            
        ]
    });
    
    
    
    

    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directMasterStore1 = Unilite.createStore('s_zee100ukrv_kdMasterStore1',{
        model: 's_zee100ukrv_kdModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결
            editable:  true,            // 수정 모드 사용
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
        },
        saveStore: function() {
            var inValidRecs = this.getInvalidRecords();
            console.log("inValidRecords : ", inValidRecs);

            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();
            var toDelete = this.getRemovedRecords();
            var list = [].concat(toUpdate, toCreate);
            console.log("inValidRecords : ", inValidRecs);
            console.log("list:", list);
            console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

            //1. 마스터 정보 파라미터 구성
            var paramMaster = panelResult.getValues();    //syncAll 수정

            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        panelResult.getForm().wasDirty = false;
                        panelResult.resetDirtyStatus();
                        console.log("set was dirty to false");
                        UniAppManager.setToolbarButtons('save', false);
//                        UniAppManager.app.onQueryButtonDown();
                    }
                };
                this.syncAllDirect(config);
            } else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        }
    }); // End of var directMasterStore1

    var directMasterStore2 = Unilite.createStore('s_zee100ukrv_kdMasterStore2',{
        model: 's_zee100ukrv_kdModel2',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결
            editable:  true,            // 수정 모드 사용
            deletable: true,            // 삭제 가능 여부
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy2,
        loadStoreRecords : function() {
            var param = panelResult2.getValues();
            this.load({
                  params : param
            });
        },
        saveStore: function() {
            var inValidRecs = this.getInvalidRecords();
            console.log("inValidRecords : ", inValidRecs);

            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();
            var toDelete = this.getRemovedRecords();
            var list = [].concat(toUpdate, toCreate);
            console.log("inValidRecords : ", inValidRecs);
            console.log("list:", list);
            console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

            //1. 마스터 정보 파라미터 구성
            var paramMaster = panelResult2.getValues();    //syncAll 수정

            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        panelResult2.getForm().wasDirty = false;
                        panelResult2.resetDirtyStatus();
                        console.log("set was dirty to false");
                        UniAppManager.setToolbarButtons('save', false);
                        directMasterStore2.loadStoreRecords();
//                        UniAppManager.app.onQueryButtonDown();
                    }
                };
                this.syncAllDirect(config);
            } else {
                masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners : {
            load: function(store, records, successful, eOpts) {
            	if(Ext.isEmpty(records)){
	            	subStore.clearData(); 
		            subGrid.reset();
            	}
            }
        }
        
        
        
        
			            
    }); // End of var directMasterStore1

    var subStore = Unilite.createStore('subStore',{
        model: 'subModel',
        uniOpt : {
            isMaster:  false,            // 상위 버튼 연결 
            editable:  false,            // 수정 모드 사용 
            deletable: false,            // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
			type: 'direct',
        	api: {
            	read    : 's_zee100ukrv_kdService.selectSub'
        	}
        },
        loadStoreRecords : function(param) {   
            this.load({
                  params : param
            });         
        }
    });
    
    
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 4},
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
                fieldLabel: '장비대장번호',
                name:'EQDOC_CODE',   
                xtype: 'uniTextfield'
            },{ 
                fieldLabel: '구입일자',
                xtype: 'uniDateRangefield',
                startFieldName: 'FR_BUY_DATE',
                endFieldName: 'TO_BUY_DATE',
//                allowBlank : false,
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today')
            },{
                fieldLabel: '라이센스명',
                name:'SW_NM',   
                xtype: 'uniTextfield'
            },{
                fieldLabel: '관리부서',
                name:'MGM_DEPT_CODE',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'WZ35'
            },{
                fieldLabel: '사용부서',
                name:'INS_DEPT_CODE',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'WZ36'
            },{
                fieldLabel: '장비구분',
                name:'EQDOC_TYPE',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'WZ10'
            },{
                fieldLabel: '사용자',
                name:'BIZ_REMARK',
                xtype: 'uniTextfield'
            },{
                xtype: 'container',
                layout:{type:'uniTable', columns: 6},
                colspan: 4,
                items:[{
                    fieldLabel: '소프트웨어',
                    name:'SW_OS',
                    xtype: 'uniCombobox',
                    comboType:'AU',
                    comboCode:'WZ13',
                    emptyText	: "OS"
                },{
                    name:'SW_HWP',
                    xtype: 'uniCombobox',
                    comboType:'AU',
                    comboCode:'WZ14',
                    emptyText	: "한글"
                },{
                    name:'SW_MS',
                    xtype: 'uniCombobox',
                    comboType:'AU',
                    comboCode:'WZ15',
                    emptyText	: "오피스"
                },{
                    name:'SW_VC',
                    xtype: 'uniCombobox',
                    comboType:'AU',
                    comboCode:'WZ16',
                    emptyText	: "백신"
                },{
                    name:'SW_ETC',
                    xtype: 'uniCombobox',
                    comboType:'AU',
                    comboCode:'WZ17',
                    emptyText	: "기타"
                },{
                    name:'SW_LAB',
                    xtype: 'uniCombobox',
                    comboType:'AU',
                    comboCode:'WZ18',
                    emptyText	: "연구소"
                }
            ]}
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

    var masterGrid = Unilite.createGrid('s_zee100ukrv_kdGrid1', {
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
        columns:  [
            {dataIndex : 'COMP_CODE',                   width : 100, hidden : true},
            {dataIndex : 'DIV_CODE',                    width : 100, hidden : true},
            {dataIndex : 'EQDOC_CODE',                  width : 100},
            {dataIndex : 'MGM_DEPT_CODE',               width : 100},
            {dataIndex : 'INS_DEPT_CODE',               width : 100},
            {dataIndex : 'EQDOC_TYPE',                  width : 100},
            {dataIndex : 'MODEL_NO',                    width : 100},
            {dataIndex : 'BUY_DATE',                    width : 100},
            
            {dataIndex : 'SW_OS',                       width : 100},
            {dataIndex : 'SW_HWP',                      width : 100},
            {dataIndex : 'SW_MSOFFICE',                 width : 100},
            {dataIndex : 'SW_VACCIN',                   width : 100},
            {dataIndex : 'SW_ETC1',                     width : 100},
            {dataIndex : 'SW_ETC2',                     width : 100},
            {dataIndex : 'SW_ETC3',                     width : 100},
            {dataIndex : 'SW_LAB1',                     width : 100},
            {dataIndex : 'SW_LAB2',                     width : 100},
            {dataIndex : 'SW_LAB3',                     width : 100},
            {dataIndex : 'BIZ_REMARK',                  width : 250},
            {dataIndex : 'SW_REMARK',                      width : 250},
            {dataIndex : 'IP',                          width : 100},
            {dataIndex : 'WINDOW_PASS',                 width : 100}
        ],
        listeners: {
            beforeedit : function( editor, e, eOpts ) {
                if(UniUtils.indexOf(e.field, ['SW_OS', 'SW_HWP', 'SW_MSOFFICE', 'SW_VACCIN', 'SW_ETC1', 'SW_ETC2', 'SW_ETC3',
                								'SW_LAB1','SW_LAB2','SW_LAB3','BIZ_REMARK','SW_REMARK','IP','WINDOW_PASS']))
                {
                    return true;
                } else {
                    return false;
                }
            }
        }
    });

    var panelResult2 = Unilite.createSearchForm('resultForm2',{
        region: 'north',
        layout : {type : 'uniTable', columns : 2},
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
            },/*{
            	fieldLabel: '소프트웨어',
            	name:'SW_TYPE',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'WZ20',
                width: 325,
                multiSelect: true,
                typeAhead: false
            }*/{
                xtype: 'uniCheckboxgroup',
                fieldLabel: '소프트웨어',
                items: [{
                    boxLabel: 'OS',
                    width: 80,
                    name: 'WZ13',
                    inputValue: 'WZ13',
                    uncheckedValue: 'N',
                    checked: true
                },{
                    boxLabel: 'HWP',
                    width: 80,
                    name: 'WZ14',
                    inputValue: 'WZ14',
                    uncheckedValue: 'N',
                    checked: true
                },{
                    boxLabel: 'MS',
                    width: 80,
                    name: 'WZ15',
                    inputValue: 'WZ15',
                    uncheckedValue: 'N',
                    checked: true
                },{
                    boxLabel: '백신',
                    width: 80,
                    name: 'WZ16',
                    inputValue: 'WZ16',
                    uncheckedValue: 'N',
                    checked: true
                },{
                    boxLabel: '기타',
                    width: 80,
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
                },{
                    boxLabel: '전체',
                    width: 80,
                    name: 'ALL',
                    listeners: {
						change: function(box, newValue, oldValue, eOpts) {
                    		if(newValue == true){
                    			panelResult2.setValue('WZ13',true);
                    			panelResult2.setValue('WZ14',true);
                    			panelResult2.setValue('WZ15',true);
                    			panelResult2.setValue('WZ16',true);
                    			panelResult2.setValue('WZ17',true);
                    			panelResult2.setValue('WZ18',true);
                    		}else{
                    			panelResult2.setValue('WZ13',false);
                    			panelResult2.setValue('WZ14',false);
                    			panelResult2.setValue('WZ15',false);
                    			panelResult2.setValue('WZ16',false);
                    			panelResult2.setValue('WZ17',false);
                    			panelResult2.setValue('WZ18',false);
                    		}
						}
                    }
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

    var masterGrid2 = Unilite.createGrid('s_zee100ukrv_kdGrid2', {
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
            {dataIndex : 'COMP_CODE',                   width : 100, hidden: true},
            {dataIndex : 'DIV_CODE',                    width : 100, hidden: true},
            {dataIndex : 'SW_TYPE',                     width : 100},
            {dataIndex : 'SW_CODE',                     width : 100,
                editor: Unilite.popup('SW_CODE_G', {
                        textFieldName: 'SW_CODE',
                        DBtextFieldName: 'SW_NAME',
                        autoPopup: true,
                        listeners: {
                        	'onSelected': {
                                fn: function(records, type) {
                                    var grdRecord = masterGrid2.uniOpt.currentRecord;
                                    grdRecord.set('SW_CODE', records[0]['SW_CODE']);
                                    grdRecord.set('SW_NAME', records[0]['SW_NAME']);
                                },
                                scope: this
                            },
                            'onClear': function(type) {
                                var grdRecord = masterGrid2.uniOpt.currentRecord;
                                grdRecord.set('SW_CODE', '');
                                grdRecord.set('SW_NAME', '');
                            },
                            applyextparam: function(popup) {
                            	var grdRecord = masterGrid2.uniOpt.currentRecord;
                                popup.setExtParam({'MAIN_CODE': grdRecord.get('SW_TYPE')});
                            }
                        }
                })
            },
            {dataIndex : 'SW_NAME',                     width : 200,
              'editor': Unilite.popup('SW_CODE_G',{
                    autoPopup : true,
                    listeners : {
                    	'onSelected' : {
                            fn: function(records, type) {
                                var grdRecord = masterGrid2.uniOpt.currentRecord;
                                grdRecord.set('SW_CODE', records[0]['SW_CODE']);
                                grdRecord.set('SW_NAME', records[0]['SW_NAME']);

                            },
                            scope : this
                        },
                        'onClear' : function(type) {
                            var grdRecord = masterGrid2.uniOpt.currentRecord;
                            grdRecord.set('SW_CODE', '');
                            grdRecord.set('SW_NAME', '');
                        },
                        applyextparam: function(popup) {
                            var grdRecord = masterGrid2.uniOpt.currentRecord;
                            popup.setExtParam({'MAIN_CODE': grdRecord.get('SW_TYPE')});
                        }
                    }
                })
            },
            {dataIndex : 'BUY_QTY',                     width : 100},
            {dataIndex : 'INSTALL_QTY',                 width : 100},
            {dataIndex : 'WANT_QTY',                    width : 100},
            {dataIndex : 'REMARK',                      width : 300}
        ],
        listeners: {
            beforeedit : function( editor, e, eOpts ) {
                if(e.record.phantom) {
                    if(UniUtils.indexOf(e.field, ['SW_TYPE', 'SW_CODE', 'SW_NAME', 'BUY_QTY', 'REMARK'])) {
                        return true;
                    } else {
                        return false;
                    } 
                } else {
                    if(UniUtils.indexOf(e.field, ['BUY_QTY', 'REMARK'])) {
                        return true;
                    } else {
                        return false;
                    }
                }
            },
            selectionchange:function( model1, selected, eOpts ) {
            	if(selected.length > 0) {
            		if(selected[0].phantom == false) {
	                	var record = selected[0];
	                	var param = {
	                		'DIV_CODE': record.get('DIV_CODE'),
	                		'SW_TYPE':  record.get('SW_TYPE'),
	                		'SW_CODE':  record.get('SW_CODE')
	                	}
	                	subStore.loadStoreRecords(param); 
            		}else{
			            subStore.clearData(); 
			            subGrid.reset();
            		}
            	}else{
		            subStore.clearData(); 
		            subGrid.reset();
            	}
            }
        }
    });
    var subGrid = Unilite.createGrid('subGrid', { 
        layout : 'fit',
        region: 'south',
        store: subStore,
        split:true,
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
        columns: [
            {dataIndex : 'COMP_CODE',                   width : 100, hidden : true},
            {dataIndex : 'DIV_CODE',                    width : 130, hidden : true},
            {dataIndex : 'MGM_DEPT_CODE',               width : 110},
            {dataIndex : 'INS_DEPT_CODE',               width : 120},
            {dataIndex : 'EQDOC_CODE',                  width : 130},
            {dataIndex : 'EQDOC_TYPE',                  width : 100},
            {dataIndex : 'ITEM_NAME',                   width : 160},
            {dataIndex : 'MODEL_NO',                    width : 120},
            {dataIndex : 'BIZ_REMARK',                  width : 150}
        ]
    });    
    
    var tab = Unilite.createTabPanel('tabPanel',{
        split: true,
        border : false,
        region:'center',
        items: [
            {
                 title: '전산장비SW'
                 ,xtype:'container'
                 ,layout:{type:'vbox', align:'stretch'}
                 ,items:[panelResult, masterGrid]
                 ,id: 'tab1'
            },{
                 title: 'SW보유대수'
                 ,xtype:'container'
                 ,layout:{type:'vbox', align:'stretch'}
                 ,items:[panelResult2, masterGrid2,subGrid]
                 ,id: 'tab2'
            }
        ],
        listeners:  {
            tabChange:  function ( tabPanel, newCard, oldCard, eOpts )  {
                var activeTabId = tab.getActiveTab().getId();
                if(activeTabId == 'tab1') {
                    if(directMasterStore2.getCount() > 0) {
                        var param= panelResult.getValues();
                        directMasterStore1.loadStoreRecords(param);
                        UniAppManager.setToolbarButtons(['newData', 'delete'], false);
                    } else {
                    	UniAppManager.setToolbarButtons(['newData', 'delete'], false);
                    }
                } else if(activeTabId == 'tab2') {
                    if(directMasterStore2.getCount() > 0) {
                        panelResult2.setValue('DIV_CODE',UserInfo.divCode);
                        var param= panelResult.getValues();
                        directMasterStore2.loadStoreRecords(param);
                        UniAppManager.setToolbarButtons(['newData', 'delete'], true);
                    } else {
                        panelResult2.setValue('DIV_CODE',UserInfo.divCode);
                        var param= panelResult.getValues();
                        directMasterStore2.loadStoreRecords(param);
                        UniAppManager.setToolbarButtons(['newData'], true);
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
                	tab
                ]
            }
        ],
        id  : 's_zee100ukrv_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData', 'deleteAll', 'delete'], false);
            this.setDefault();
        },
        onQueryButtonDown : function() {
        	var activeTabId = tab.getActiveTab().getId();
            if(activeTabId == 'tab1') {
                if(panelResult.setAllFieldsReadOnly(true) == false) {
                    return false;
                }
                directMasterStore1.loadStoreRecords();
                UniAppManager.setToolbarButtons(['reset'], true);
            } else {
            	if(panelResult2.setAllFieldsReadOnly(true) == false) {
                    return false;
                }
                directMasterStore2.loadStoreRecords();
                UniAppManager.setToolbarButtons(['reset'], true);
            }
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            panelResult.clearForm();
            directMasterStore1.clearData(); 
            masterGrid.reset();
            directMasterStore2.clearData(); 
            masterGrid2.reset();
            subStore.clearData(); 
            subGrid.reset();
            this.setDefault();
        },
        onNewDataButtonDown: function() {       // 행추가
            var compCode = UserInfo.compCode;
            var divCode  = panelResult.getValue('DIV_CODE');

            var r = {
                COMP_CODE:          compCode,
                DIV_CODE:           divCode
            };
            masterGrid2.createRow(r);
        },
        onDeleteDataButtonDown: function() {
        	var selRow = masterGrid2.getSelectedRecord();
            if(selRow.phantom === true) {
                masterGrid2.deleteSelectedRow();
            }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                masterGrid2.deleteSelectedRow();
            }
        },
        onSaveDataButtonDown: function () {
            if(directMasterStore1.isDirty()) {
                directMasterStore1.saveStore();
            }
            if(directMasterStore2.isDirty()) {
                directMasterStore2.saveStore();
            }
        },
        setDefault: function() {
            directMasterStore1.clearData();
            directMasterStore2.clearData();
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('FR_BUY_DATE', UniDate.get('startOfMonth'));
            panelResult.setValue('TO_BUY_DATE', UniDate.get('today'));
            panelResult2.setValue('WZ13', true);
            panelResult2.setValue('WZ14', true);
            panelResult2.setValue('WZ15', true);
            panelResult2.setValue('WZ16', true);
            panelResult2.setValue('WZ17', true);
            panelResult2.setValue('WZ18', true);
            UniAppManager.setToolbarButtons(['save', 'newData', 'deleteAll', 'delete'], false);
        }
    });
}
</script>