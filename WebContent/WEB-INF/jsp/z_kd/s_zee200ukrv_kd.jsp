<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_zee200ukrv_kd">
    <t:ExtComboStore comboType="BOR120"  pgmId="s_zee200ukrv_kd"  />    <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="WZ10" />                 <!--장비구분-->
    <t:ExtComboStore comboType="AU" comboCode="WZ11" />                 <!--이관부서-->
    <t:ExtComboStore comboType="AU" comboCode="WZ12" />                 <!--사용-->
</t:appConfig>
<script type="text/javascript">

var BsaCodeInfo = { //컨트롤러에서 값을 받아옴.
    gsAutoType  :   '${gsAutoType}'
};

var selectedGrid = 's_zee200ukrv_kdGrid1';

function appMain() {

    var groupUrl = '${groupUrl}'; //그룹웨어 호출 url

    var isAutoOrderNum = false;
    if(BsaCodeInfo.gsAutoType == 'Y') {
        isAutoOrderNum = true;
    }
    
    var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
        api: {
            read    : 's_zee200ukrv_kdService.selectList',
            update  : 's_zee200ukrv_kdService.updateDetail',
            create  : 's_zee200ukrv_kdService.insertDetail',
            destroy : 's_zee200ukrv_kdService.deleteDetail',
            syncAll : 's_zee200ukrv_kdService.saveAll'
        }
    });
    
    var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
        api: {
            read    : 's_zee200ukrv_kdService.selectList2',
            update  : 's_zee200ukrv_kdService.updateDetail2',
            create  : 's_zee200ukrv_kdService.insertDetail2',
            destroy : 's_zee200ukrv_kdService.deleteDetail2',
            syncAll : 's_zee200ukrv_kdService.saveAll2'
        }
    });
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('s_zee200ukrv_kdModel', {
        fields: [
            {name : 'COMP_CODE',            text : '법인코드',          type : 'string'},
            {name : 'DIV_CODE',             text : '사업자코드',         type : 'string'},
 	        {name : 'EQDOC_CODE',           text : '장비대장번호',       type : 'string', allowBlank : isAutoOrderNum},
			{name : 'MGM_DEPT_CODE',        text : '관리부서',          type : 'string', comboType : 'AU', comboCode : 'WZ35', allowBlank : false},
            {name : 'INS_DEPT_CODE',        text : '설치부서',          type : 'string', comboType : 'AU', comboCode : 'WZ36'},
            {name : 'EQDOC_TYPE',           text : '장비구분',          type : 'string', comboType : 'AU', comboCode : 'WZ10', allowBlank : false},
            {name : 'BUY_DATE',             text : '구입일자',          type : 'uniDate', allowBlank : false},
            {name : 'ITEM_NAME',            text : '제품명',            type : 'string', allowBlank : false},
            {name : 'EQDOC_SPEC',           text : '규격',             type : 'string'},
            {name : 'MAKE_COMP',            text : '제조업체',          type : 'string'},
            {name : 'BUY_COMP',            text : '구입업체',          type : 'string'},
            {name : 'BUY_AMT',            text : '구매금액',          type : 'uniPrice'},
            {name : 'MODEL_NO',             text : '모델명',           type : 'string', allowBlank : false},
            {name : 'SERIAL_NO',            text : 'Serial_No',       type : 'string'},
            {name : 'M_REG_NUM',            text : '모니터등록 No',      type : 'string'},
            {name : 'M_BUY_DATE',           text : '모니터구입일',       type : 'uniDate',editable:false},
            {name : 'M_NAME',               text : '모니터명',          type : 'string',editable:false},
            {name : 'M_MODEL_NO',           text : '모니터모델',         type : 'string',editable:false},
            {name : 'M_SPEC',               text : '모니터규격',         type : 'string',editable:false},
            {name : 'M_MAKE_COMP',          text : '모니터제조업체',      type : 'string',editable:false},
            {name : 'BIZ_REMARK',           text : '주요업무처리현황',    type : 'string'},
            {name : 'STATUS',               text : '상태',             type : 'string', comboType : 'AU', comboCode : 'WZ11', allowBlank : false},
            {name : 'USE_YN',               text : '사용',             type : 'string', comboType : 'AU', comboCode : 'WZ12', allowBlank : false},
            {name : 'DISP_DATE',            text : '폐기일자',          type : 'uniDate'},
            {name : 'REMARK',               text : '비고',             type : 'string'}
        ]
    });
    
    Unilite.defineModel('s_zee200ukrv_kdModel2', {
        fields: [
            {name : 'COMP_CODE',            text : '법인코드',          type : 'string'},
            {name : 'DIV_CODE',             text : '사업자코드',         type : 'string'},
            {name : 'EQDOC_CODE',           text : '장비대장번호',       type : 'string'},
            {name : 'SEQ',                  text : '순번',            type : 'int'},
            {name : 'REPAIR_DATE',          text : '수리일자',          type : 'uniDate', allowBlank : false},
            {name : 'REPAIR_REMARK',        text : '수리내역',          type : 'string', allowBlank : false}
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore1 = Unilite.createStore('s_zee200ukrv_kdMasterStore1', {
        model : 's_zee200ukrv_kdModel',
        uniOpt : {
            isMaster    : false,            // 상위 버튼 연결 
            editable    : true,             // 수정 모드 사용 
            deletable   : true,             // 삭제 가능 여부 
            useNavi     : false             // prev | newxt 버튼 사용
        },
        autoLoad : false,
        proxy : directProxy1,
        loadStoreRecords : function() {
            var param = panelResult.getValues();
            this.load({
                  params : param,
               // NEW ADD
  				callback: function(records, operation, success){
  					console.log(records);
  					if(success){
  						if(masterGrid.getStore().getCount() == 0){
  							Ext.getCmp('GW').setDisabled(true);
  						}else if(masterGrid.getStore().getCount() != 0){
  							UniBase.fnGwBtnControl('GW',directMasterStore1.data.items[0].data.GW_FLAG);							
  						}
  					}
  				}
  				//END
            });         
        },
        saveStore : function() {
            var inValidRecs = this.getInvalidRecords();
            console.log("inValidRecords : ", inValidRecs);

            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();                
            var toDelete = this.getRemovedRecords();
            var list = [].concat(toUpdate, toCreate);
            console.log("inValidRecords : ", inValidRecs);
            console.log("list:", list);
            console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
            
            Ext.each(list, function(record, index) {
                if(!Ext.isEmpty(record.data['EQDOC_CODE'])) {
                    record.set('EQDOC_CODE', record.data['EQDOC_CODE']);
                }
            })
            
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
                    }
                };
                this.syncAllDirect(config);
            } else {
                var grid = Ext.getCmp('s_zee200ukrv_kdGrid1');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners:{
            load: function(store, records, successful, eOpts) {
            	if(masterGrid.getStore().getCount() == 0) {
                    Ext.getCmp('GW').setDisabled(true);
                } else {
                    Ext.getCmp('GW').setDisabled(false);
                }
                if(records != null && records.length > 0 ){
//                    selectedGrid = 's_zee200ukrv_kdGrid1';
                    UniAppManager.setToolbarButtons('delete', true);
                }
            },
            update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
                UniAppManager.setToolbarButtons('save', true);      
            },
            datachanged : function(store,  eOpts) {
                if( directMasterStore2.isDirty() || store.isDirty()) {
                    UniAppManager.setToolbarButtons('save', true);  
                }else {
                    UniAppManager.setToolbarButtons('save', false);
                }
            }
        }  
    }); // End of var directMasterStore1

    var directMasterStore2 = Unilite.createStore('s_zee200ukrv_kdMasterStore2',{
        model : 's_zee200ukrv_kdModel2',
        uniOpt : {
            isMaster    : false,            // 상위 버튼 연결 
            editable    : true,             // 수정 모드 사용 
            deletable   : true,             // 삭제 가능 여부 
            useNavi     : false             // prev | newxt 버튼 사용
        },
        autoLoad : false,
        proxy : directProxy2,
        loadStoreRecords : function(param) {
            this.load({
                  params : param
            });         
        },
        saveStore : function() {
            var inValidRecs = this.getInvalidRecords();
            console.log("inValidRecords : ", inValidRecs);

            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();                
            var toDelete = this.getRemovedRecords();
            var list = [].concat(toUpdate, toCreate);
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
                    var grid = Ext.getCmp('s_zee200ukrv_kdGrid2');
                    grid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
        },
        listeners : {
            load: function(store, records, successful, eOpts) {
                if(records != null && records.length > 0){
                    UniAppManager.setToolbarButtons('delete', true);
//                    selectedGrid = 's_zee200ukrv_kdGrid2';
                } else {
                	if(directMasterStore1.isDirty() || store.isDirty()) {
                        UniAppManager.setToolbarButtons('save', true);  
                    }else {
                        UniAppManager.setToolbarButtons('save', false);
                    }
                }
            },
            update : function( store, record, operation, modifiedFieldNames, details, eOpts) {
                UniAppManager.setToolbarButtons('save', true);      
            },
            datachanged : function(store,  eOpts) {
                if(directMasterStore1.isDirty() || store.isDirty()) {
                    UniAppManager.setToolbarButtons('save', true);  
                }else {
                    UniAppManager.setToolbarButtons('save', false);
                }
            }
        }
    }); // End of var directMasterStore1    
    
    var panelResult = Unilite.createSearchForm('resultForm', {
        region : 'north',
        layout : {type : 'uniTable', columns : 4},
        padding:'1 1 1 1',
        border:true,
        items: [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank : false,
                value: UserInfo.divCode
            },{
                fieldLabel: '사용',
                name:'USE_YN',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'WZ12'
            },{ 
                fieldLabel: '구입일자',
                xtype: 'uniDateRangefield',
                startFieldName: 'FR_BUY_DATE',
                endFieldName: 'TO_BUY_DATE',
//                allowBlank : false,
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                colspan:2
            },{
                fieldLabel: '관리부서',
                name:'MGM_DEPT_CODE',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'WZ35'
            },{
                fieldLabel: '설치부서',
                name:'INS_DEPT_CODE',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'WZ36'
            },{
                fieldLabel: '제품명',
                name:'ITEM_NAME',
                xtype: 'uniTextfield'
            },{
                fieldLabel: '모델명',
                name:'MODEL_NO',
                xtype: 'uniTextfield'
            },{
                fieldLabel: '장비구분',
                name:'EQDOC_TYPE',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'WZ10'
            },{
            	fieldLabel: '규격',
                name:'EQDOC_SPEC',
                xtype: 'uniTextfield'
            },{
            	fieldLabel: '모니터제외',
            	name: 'M_DATA_EXCEPT',
				inputValue: 'Y',
				xtype: 'checkbox'
    		},{
                fieldLabel: '장비대장번호',
                name:'EQDOC_CODE',   
                xtype: 'uniTextfield',
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
                        if(Ext.isDefined(item.holdable)) {
                            if(item.holdable == 'hold') {
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
                    if(Ext.isDefined(item.holdable)) {
                        if(item.holdable == 'hold') {
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
    
    var masterGrid = Unilite.createGrid('s_zee200ukrv_kdGrid1', { 
        layout  : 'fit',   
        region  : 'center',
        store   : directMasterStore1,
        uniOpt  : { expandLastColumn    : false,
                    useRowNumberer      : false,
					copiedRow : true,
                    useMultipleSorting  : true
        },
        tbar: [{
            itemId : 'GWBtn',
            id:'GW',
            iconCls : 'icon-referance'  ,
            text:'기안',
            handler: function() {
            	if(confirm('기안 하시겠습니까?')) {
					UniAppManager.app.requestApprove();
            	}
                UniAppManager.app.onQueryButtonDown();
            }
        }],
        columns:  [ 
            {dataIndex : 'COMP_CODE',                   width : 100, hidden : true},
            {dataIndex : 'DIV_CODE',                    width : 130, hidden : true},
            {dataIndex : 'EQDOC_CODE',                  width : 100},
            {dataIndex : 'MGM_DEPT_CODE',               width : 100, align : 'center'},
            {dataIndex : 'INS_DEPT_CODE',               width : 110},
            {dataIndex : 'EQDOC_TYPE',                  width : 120},
            {dataIndex : 'BUY_DATE',                    width : 100},
            {dataIndex : 'ITEM_NAME',                   width : 160},
            {dataIndex : 'EQDOC_SPEC',                  width : 120},
            {dataIndex : 'MAKE_COMP',                   width : 120},
            {dataIndex : 'BUY_COMP',                   width : 120},
            {dataIndex : 'BUY_AMT',                   width : 100},
            {dataIndex : 'MODEL_NO',                    width : 120},
            {dataIndex : 'SERIAL_NO',                   width : 120},
            {dataIndex : 'M_REG_NUM',                   width : 120,
                'editor' : Unilite.popup('M_REG_NUM_KD_G', {
                    autoPopup: true,
                    DBtextFieldName: 'M_REG_NUM',
                    listeners: {'onSelected' : {
                        fn: function(records, type) {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('M_REG_NUM',      records[0]['EQDOC_CODE']);
                            grdRecord.set('M_BUY_DATE',     records[0]['BUY_DATE']);
                            grdRecord.set('M_NAME',         records[0]['ITEM_NAME']);
                            grdRecord.set('M_MODEL_NO',     records[0]['MODEL_NO']);
                            grdRecord.set('M_SPEC',         records[0]['EQDOC_SPEC']);
                            grdRecord.set('M_MAKE_COMP',    records[0]['MAKE_COMP']);
                        },
                        scope: this
                      },
                        'onClear' : function(type) {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('M_REG_NUM',      '');
                            grdRecord.set('M_BUY_DATE',     '');
                            grdRecord.set('M_NAME',         '');
                            grdRecord.set('M_MODEL_NO',     '');
                            grdRecord.set('M_SPEC',         '');
                            grdRecord.set('M_MAKE_COMP',    '');
                        },
                        applyextparam: function(popup) {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            
                            popup.setExtParam({'DIV_CODE'   : panelResult.getValue('DIV_CODE')});
                            popup.setExtParam({'M_REG_NUM'  : grdRecord.get('M_REG_NUM')});
                        }
                    }
                })
            },            
            {dataIndex : 'M_BUY_DATE',                  width : 120, align : 'center'},
            {dataIndex : 'M_NAME',                      width : 120},
            {dataIndex : 'M_MODEL_NO',                  width : 120},
            {dataIndex : 'M_SPEC',                      width : 120},
            {dataIndex : 'M_MAKE_COMP',                 width : 120},
            {dataIndex : 'BIZ_REMARK',                  width : 150},
            {dataIndex : 'STATUS',                      width : 60, align : 'center'},
            {dataIndex : 'USE_YN',                      width : 60, align : 'center'},
            {dataIndex : 'DISP_DATE',                   width : 120, align : 'center'},
            {dataIndex : 'REMARK',                      width : 150}
        ],
        listeners: {
//            select : function() {
//                var count = masterGrid2.getStore().getCount();
//                
//                UniAppManager.setToolbarButtons(['reset', 'newData'], true);
//                selectedGrid = 's_zee200ukrv_kdGrid1';
//                if(count == 0) {
//                    UniAppManager.setToolbarButtons(['delete'], true);  
//                } else {
//                    UniAppManager.setToolbarButtons(['delete'], false);
//                }
//            }, 
//            cellclick : function() {
//                var count = masterGrid2.getStore().getCount();
//                
//                selectedGrid = 's_zee200ukrv_kdGrid1';
//                if(count == 0) {
//                    UniAppManager.setToolbarButtons(['delete'], true);  
//                } else {
//                    UniAppManager.setToolbarButtons(['delete'], false);
//                }
//            },
            render : function(grid, eOpts) {
                var girdNm = grid.getItemId();
                var store = grid.getStore();
                grid.getEl().on('click', function(e, t, eOpt) {
                    selectedGrid = 's_zee200ukrv_kdGrid1';
                    activeGridId = girdNm;
                    //store.onStoreActionEnable();
                    if(directMasterStore1.isDirty() || directMasterStore2.isDirty()) {
                        UniAppManager.setToolbarButtons('save', true);  
                    } else {
                        UniAppManager.setToolbarButtons('save', false);
                    }
                    if(grid.getStore().getCount() > 0)  {
                        UniAppManager.setToolbarButtons('delete', true);        
                    } else {
                        UniAppManager.setToolbarButtons('delete', false);
                    }
                });
             },
            selectionchange : function(model1, selected, eOpts) {
//                var count = masterGrid.getStore().getCount();
//                var count2 = masterGrid2.getStore().getCount();
                if(selected.length > 0) {
                    var record  = selected[0];
                    var param   = panelResult.getValues(); 
                    var param   = {
                        DIV_CODE    : record.get('DIV_CODE'),
                        EQDOC_CODE  : record.get('EQDOC_CODE')
                    }
                    var record = masterGrid.getSelectedRecord();
                    
                    if(!record.phantom == true) {
                        directMasterStore2.loadStoreRecords(param);
                    } else {
                        masterGrid2.reset();
                    }
                }
            },
            beforeedit : function(editor, e, eOpts) {
	            if(UniUtils.indexOf(e.field, ['COMP_CODE','DIV_CODE','EQDOC_CODE'])){ 
                    return false;
                }
            }
        }
    });
    
    var masterGrid2 = Unilite.createGrid('s_zee200ukrv_kdGrid2', {
        layout : 'fit',
        region: 'south',
        split:true,
        store: directMasterStore2,
        uniOpt: {   expandLastColumn    : true,
                    useRowNumberer      : false,
					copiedRow : true,
                    useMultipleSorting  : true
        },
        columns: [
            {dataIndex : 'COMP_CODE',                   width : 100, hidden : true},
            {dataIndex : 'DIV_CODE',                    width : 130, hidden : true},
            {dataIndex : 'EQDOC_CODE',                  width : 100},
            {dataIndex : 'SEQ',                         width : 60},
            {dataIndex : 'REPAIR_DATE',                 width : 110},
            {dataIndex : 'REPAIR_REMARK',               width : 500}
        ],
        listeners: {
//            select : function() {
//                var count = masterGrid2.getStore().getCount();
//                
//                selectedGrid = 's_zee200ukrv_kdGrid2';
//                
//                if(count == 0) {  
//                    UniAppManager.setToolbarButtons(['delete'], true);  
//                } else {
//                    UniAppManager.setToolbarButtons(['delete'], false);
//                }
//                
//                UniAppManager.setToolbarButtons(['reset', 'newData'], true);
//            }, 
//            cellclick : function() {
//                var count = masterGrid2.getStore().getCount();
//                
//                selectedGrid = 's_zee200ukrv_kdGrid2';
//                
//                if(count == 0) {
//                    UniAppManager.setToolbarButtons(['delete'], true);  
//                } else {
//                    UniAppManager.setToolbarButtons(['delete'], false);
//                }
//                
//                UniAppManager.setToolbarButtons(['reset', 'newData'], true);
//            },
            render : function(grid, eOpts) {
                var girdNm = grid.getItemId();
                var store = grid.getStore();
                grid.getEl().on('click', function(e, t, eOpt) {
                	selectedGrid = 's_zee200ukrv_kdGrid2';
                    activeGridId = girdNm;
                    if(directMasterStore1.isDirty() || directMasterStore2.isDirty()) {
                        UniAppManager.setToolbarButtons('save', true);  
                    }else {
                        UniAppManager.setToolbarButtons('save', false);
                    }
                    if(grid.getStore().getCount() > 0)  {
                        UniAppManager.setToolbarButtons('delete', true);
                    }else {
                        UniAppManager.setToolbarButtons('delete', false);
                    }
                });
             },
            beforeedit : function(editor, e, eOpts) {
	            if(UniUtils.indexOf(e.field, ['COMP_CODE','DIV_CODE','EQDOC_CODE','SEQ'])){ 
                    return false;
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
                	panelResult,
            		{
                        region : 'center',
                        xtype : 'container',
                        layout : 'fit',
                        items : [ masterGrid ]
                    }, masterGrid2
                ]
            }
        ],
        id  : 's_zee200ukrv_kdApp',
        fnInitBinding : function() {
            Ext.getCmp('GW').setDisabled(true);
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData', 'deleteAll'], false);
            UniAppManager.setToolbarButtons('newData', true);
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
            Ext.getCmp('GW').setDisabled(true);
            this.fnInitBinding();
        },
        onNewDataButtonDown: function() {       // 행추가
        	if(selectedGrid == 's_zee200ukrv_kdGrid1') {
                var compCode    = UserInfo.compCode; 
                var divCode     = panelResult.getValue('DIV_CODE'); 
                var buyDate     = UniDate.get('today'); 
                var useYN       = '1'
                var status = 'A'
                var mgmDeptCode = panelResult.getValue('MGM_DEPT_CODE'); 
                var insDeptCode = panelResult.getValue('INS_DEPT_CODE'); 
                var eqdocType = panelResult.getValue('EQDOC_TYPE'); 
                
                
                var r = {
                    COMP_CODE   : compCode,
                    DIV_CODE    : divCode,
                    BUY_DATE    : buyDate,
                    USE_YN      : useYN,
                    STATUS : status,
                    
                    MGM_DEPT_CODE : mgmDeptCode, 
					INS_DEPT_CODE : insDeptCode, 
					EQDOC_TYPE : eqdocType    
                    
                };
                
                masterGrid.createRow(r);
                
        	} else if(selectedGrid == 's_zee200ukrv_kdGrid2') {
                var record      = masterGrid.getSelectedRecord();
                
                if(Ext.isEmpty(record.get('EQDOC_CODE'))) {
                	alert('전산장비를 등록한 후 추가하십시오.');
                	return false;
                } else {
                    var compCode    = UserInfo.compCode; 
                    var divCode     = panelResult.getValue('DIV_CODE');
                    var eqdocCode   = record.get('EQDOC_CODE');
                    var seq         = directMasterStore2.max('SEQ');
                        if(!seq) seq = 1;
                        else seq += 1;
                    
                    var r = {
                        COMP_CODE   : compCode,
                        DIV_CODE    : divCode,
                        EQDOC_CODE  : eqdocCode,
                        SEQ         : seq
                    };
                }
                
                masterGrid2.createRow(r);
            }
        },
        onDeleteDataButtonDown: function() {
            var param = panelResult.getValues();
            
            if(selectedGrid == 's_zee200ukrv_kdGrid1') {
                var record = masterGrid.getSelectedRecord();
                var count = masterGrid2.getStore().getCount();
                
                if(record.phantom == true) {
                    masterGrid.deleteSelectedRow();
                } else {
                	if(count != 0) {
                	   alert('수리내역이 존재합니다. 수리내역을 먼저 삭제하시기 바랍니다.');
                        return false;
                	} else {
                        if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                            masterGrid.deleteSelectedRow();
                        }
                	}
                }
            } else if(selectedGrid == 's_zee200ukrv_kdGrid2') {
                var record = masterGrid2.getSelectedRecord();
                
                if(record.phantom == true) {
                    masterGrid2.deleteSelectedRow();
                } else {
                    if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                        masterGrid2.deleteSelectedRow();
                    }
                }
            }
            
            if(directMasterStore1.isDirty() || directMasterStore2.isDirty()) {
                UniAppManager.setToolbarButtons(['save'], true);
            } else if(!directMasterStore1.isDirty() && !directMasterStore2.isDirty()) {
                UniAppManager.setToolbarButtons(['save'], false);
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
            panelResult.getForm().wasDirty = false;
            UniAppManager.setToolbarButtons(['save'], false);
        },
        requestApprove: function(){     //결재 요청
            var gsWin = window.open('about:blank','payviewer','width=500,height=500'); 
            
            var frm         = document.f1;
            var compCode    = UserInfo.compCode;
            var divCode     = panelResult.getValue('DIV_CODE');
            var useYn       = panelResult.getValue('USE_YN');
            if(Ext.isEmpty(useYn)) {
            	useYn = '';
            }
//            var frDate      = UniDate.getDbDateStr(panelResult.getValue('FR_BUY_DATE'));
//            var toDate      = UniDate.getDbDateStr(panelResult.getValue('TO_BUY_DATE'));
            if(Ext.isEmpty(panelResult.getValue('FR_BUY_DATE'))) {
                var frDate = '';
            } else {
                var frDate = UniDate.getDbDateStr(panelResult.getValue('FR_BUY_DATE')); 
            }
            if(Ext.isEmpty(panelResult.getValue('TO_BUY_DATE'))) {
                var toDate = '';
            } else {
                var toDate = UniDate.getDbDateStr(panelResult.getValue('TO_BUY_DATE')); 
            }
            
            
            var mgmDeptCode = panelResult.getValue('MGM_DEPT_CODE');
            if(Ext.isEmpty(mgmDeptCode)) {
            	mgmDeptCode = '';
            }
            var insDeptCode = panelResult.getValue('INS_DEPT_CODE');
            if(Ext.isEmpty(insDeptCode)) {
            	insDeptCode = '';
            }
            var eqdocCode   = panelResult.getValue('EQDOC_CODE');
            if(Ext.isEmpty(eqdocCode)) {
            	eqdocCode = '';
            }
            var eqdocType   = panelResult.getValue('EQDOC_TYPE');
            if(Ext.isEmpty(eqdocType)) {
            	eqdocType = '';
            }
            var eqdocSpec   = panelResult.getValue('EQDOC_SPEC');
            if(Ext.isEmpty(eqdocSpec)) {
            	eqdocSpec = '';
            }
            var itemName    = panelResult.getValue('ITEM_NAME');
            var modelNo    = panelResult.getValue('MODEL_NO');
            var mDataExcept    = panelResult.getValue('M_DATA_EXCEPT');
            if(Ext.isEmpty(mDataExcept)) {
            	mDataExcept = '' ;
            } else {
            		mDataExcept = 'Y' ;
        	}
            var spText      = 'EXEC omegaplus_kdg.unilite.usp_gw_s_zee200ukrv_kd ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + useYn + "'" + ', ' + "'" + frDate + "'"
                                 + ', ' + "'" + toDate + "'" + ', ' + "'" + mgmDeptCode + "'" + ', ' + "'" + eqdocCode + "'" + ', ' + "'" + itemName + "'"+ ', ' + "'" + insDeptCode + "'"+ ', ' + "'" + eqdocType + "'"+ ', ' + "'" + eqdocSpec + "'"+ ', ' + "'" + modelNo + "'"+ ', ' + "'" + mDataExcept + "'";
            var spText2     = 'EXEC omegaplus_kdg.unilite.usp_gw_s_zee210ukrv_kd ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + useYn + "'" + ', ' + "'" + frDate + "'"
                                 + ', ' + "'" + toDate + "'" + ', ' + "'" + mgmDeptCode + "'" + ', ' + "'" + eqdocCode + "'" + ', ' + "'" + itemName + "'"+ ', ' + "'" + insDeptCode + "'"+ ', ' + "'" + eqdocType + "'"+ ', ' + "'" + eqdocSpec + "'"+ ', ' + "'" + modelNo + "'"+ ', ' + "'" + mDataExcept + "'";                     
            var spCall      = encodeURIComponent(spText + "^" + spText2); 
            
/* //            frm.action = '/payment/payreq.php';
            frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_zee200ukrv_kd&draft_no=" + "0" + "&sp=" + spCall;
            frm.target   = "payviewer"; 
            frm.method   = "post";
            frm.submit(); */
            
            var gwurl = groupUrl + "viewMode=docuDraft" + "&prg_no=s_zee200ukrv_kd&draft_no=" + "0" + "&sp=" + spCall;
            UniBase.fnGw_Call(gwurl,frm,'GW'); 
        }                 
    });                         
}
</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>
