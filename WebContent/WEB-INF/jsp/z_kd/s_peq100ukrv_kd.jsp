<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_peq100ukrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_peq100ukrv_kd"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--매출구분-->
    <t:ExtComboStore comboType="AU" comboCode="WB07" /> <!--설비구분-->
    <t:ExtComboStore comboType="AU" comboCode="B219" /> <!--등록여부-->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
    
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_peq100ukrv_kdService.selectList',
            update: 's_peq100ukrv_kdService.updateDetail',
            create: 's_peq100ukrv_kdService.insertDetail',
            destroy: 's_peq100ukrv_kdService.deleteDetail',
            syncAll: 's_peq100ukrv_kdService.saveAll'
        }
    });
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('s_peq100ukrv_kdModel', {
        fields: [
            {name: 'COMP_CODE'              ,text:'법인코드'               ,type: 'string'},
            {name: 'DIV_CODE'               ,text:'사업장'                 ,type: 'string', comboType:'BOR120'},
            {name: 'EQUIP_CODE'             ,text:'설비코드'               ,type: 'string'},
            {name: 'EQUIP_NAME'             ,text:'설비명'                 ,type: 'string'},
            {name: 'EQUIP_SPEC'             ,text:'규격'                   ,type: 'string'},
            {name: 'EQUIP_TYPE'             ,text:'구분'                   ,type: 'string', comboType: 'AU', comboCode: 'WB07'},
            {name: 'DATE_PURCHASE'          ,text:'구입일자'               ,type: 'uniDate'},
            {name: 'PURCHASE_NAME'          ,text:'구입처'                 ,type: 'string'},
            {name: 'PURCHASE_AMT'           ,text:'구입금액'               ,type: 'uniPrice'},
            {name: 'MAKER_NAME'             ,text:'제작처'                 ,type: 'string'},
            {name: 'DATE_MAKER'             ,text:'제작일자'               ,type: 'uniDate'},
            {name: 'USE_TYPE'               ,text:'용도'                   ,type: 'string'},
            {name: 'MAKE_SERIAL'            ,text:'제조번호'               ,type: 'string'},
            {name: 'INS_DATE'               ,text:'설치일자'               ,type: 'uniDate'},
            {name: 'OPR_DATE'               ,text:'가동일자'               ,type: 'uniDate'},
            {name: 'DISP_DATE'              ,text:'폐기일자'               ,type: 'uniDate'},
            {name: 'INS_PLACE'              ,text:'설치장소'               ,type: 'string'},
            {name: 'WORK_SHOP_CODE'         ,text:'작업장'                 ,type: 'string'},
            {name: 'WORK_SHOP_NAME'         ,text:'작업장명'               ,type: 'string'},
            {name: 'DEPT_CODE'              ,text:'관리부서'               ,type: 'string'},
            {name: 'DEPT_NAME'              ,text:'관리부서명'             ,type: 'string'},
            {name: 'DEPT_PRSN_CODE'         ,text:'관리담당자'             ,type: 'string'},
            {name: 'DEPT_PRSN_NAME'         ,text:'관리담당자명'           ,type: 'string'},
            {name: 'USE_DEPT_CODE'          ,text:'사용부서'               ,type: 'string'},
            {name: 'USE_DEPT_NAME'          ,text:'사용부서명'             ,type: 'string'},
            {name: 'USE_DEPT_PRSN_CODE'     ,text:'사용담당자'             ,type: 'string'},
            {name: 'USE_DEPT_PRSN_NAME'     ,text:'사용담당자명'           ,type: 'string'},
            {name: 'STATUS'                 ,text:'상태'                   ,type: 'string'},
            {name: 'REMARK'                 ,text:'비고'                   ,type: 'string'},
            {name: 'INSERT_DB_USER'         ,text:'입력자'                 ,type: 'string'},
            {name: 'INSERT_DB_TIME'         ,text:'입력일'                 ,type: 'uniDate'},
            {name: 'UPDATE_DB_USER'         ,text:'수정자'                 ,type: 'string'},
            {name: 'UPDATE_DB_TIME'         ,text:'수정일'                 ,type: 'uniDate'},
            {name: 'IMAGE_FID'              ,text: '사진FID'               ,type: 'string'} 
        ]
    }); 
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore = Unilite.createStore('s_peq100ukrv_kdMasterStore1',{
        model: 's_peq100ukrv_kdModel',
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
            var paramMaster= panelSearch.getValues();    //syncAll 수정

            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {                        
                        panelSearch.getForm().wasDirty = false;
                        panelSearch.resetDirtyStatus();
                        console.log("set was dirty to false");
                        UniAppManager.setToolbarButtons('save', false); 
                        UniAppManager.app.onQueryButtonDown();
                    } 
                };
                this.syncAllDirect(config);
            } else {
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
                    value: UserInfo.divCode,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('DIV_CODE', newValue);
                        }
                    }
                },{ 
                    fieldLabel: '구입일자',
                    xtype: 'uniDateRangefield',
                    startFieldName: 'DATE_PURCHASE_FR',
                    endFieldName: 'DATE_PURCHASE_TO',
                    startDate: UniDate.get('startOfMonth'),
                    endDate: UniDate.get('today'),
                    allowBlank:false,
                    onStartDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelSearch) {
                            panelResult.setValue('DATE_PURCHASE_FR', newValue);
                        }
                    },
                    onEndDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelSearch) {
                            panelResult.setValue('DATE_PURCHASE_TO', newValue);                           
                        }
                    }
                },{
                    fieldLabel: '설비구분',
                    name:'EQUIP_TYPE',  
                    xtype: 'uniCombobox', 
                    comboType:'AU',
                    comboCode:'WB07',
                    holdable: 'hold',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('EQUIP_TYPE', newValue);
                        }
                    }
                },
                Unilite.popup('EQUIP_CODE',{ 
                        fieldLabel: '설비',
                        valueFieldName:'EQUIP_CODE',
                        textFieldName:'EQUIP_NAME',
                        listeners: {
                            onSelected: {
                                fn: function(records, type) {
                                    panelResult.setValue('EQUIP_CODE', panelSearch.getValue('EQUIP_CODE'));
                                    panelResult.setValue('EQUIP_NAME', panelSearch.getValue('EQUIP_NAME'));                                                                                                           
                                },
                                scope: this
                            },
                            onClear: function(type) {
                                panelResult.setValue('EQUIP_CODE', '');
                                panelResult.setValue('EQUIP_NAME', '');
                            }
                        }
                })
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
        layout : {type : 'uniTable', columns : 2},
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
                value: UserInfo.divCode,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('DIV_CODE', newValue);
                    }
                }
            },{ 
                fieldLabel: '구입일자',
                xtype: 'uniDateRangefield',
                startFieldName: 'DATE_PURCHASE_FR',
                endFieldName: 'DATE_PURCHASE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank:false,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelSearch.setValue('DATE_PURCHASE_FR', newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelSearch.setValue('DATE_PURCHASE_TO', newValue);                           
                    }
                }
            },{
                fieldLabel: '설비구분',
                name:'EQUIP_TYPE',  
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'WB07',
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('EQUIP_TYPE', newValue);
                    }
                }
            },
            Unilite.popup('EQUIP_CODE',{ 
                    fieldLabel: '설비',
                    valueFieldName:'EQUIP_CODE',
                    textFieldName:'EQUIP_NAME',
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                panelSearch.setValue('EQUIP_CODE', panelResult.getValue('EQUIP_CODE'));
                                panelSearch.setValue('EQUIP_NAME', panelResult.getValue('EQUIP_NAME'));                                                                                                           
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            panelSearch.setValue('EQUIP_CODE', '');
                            panelSearch.setValue('EQUIP_NAME', '');
                        }
                    }
            })
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
        fileUpload: true,
        url:  CPATH+'/fileman/upload.do',
        padding:'1 1 1 1',
        region: 'east',
        items: [ 
        { xtype:'displayfield',
                hideLabel:true,
                value:'<div style="color:blue;font-weight:bold;padding-left:5px;">[설비 이미지]</div>',
                colspan:2},
                
                  { xtype: 'filefield',
                    buttonOnly: false,
                    fieldLabel: '사진',
                    hideLabel:true,
                    width:300,
                    name: 'fileUpload',
                    buttonText: '파일선택',
                    listeners: {
                        change : function( filefield, value, eOpts )    {
                            var fileExtention = value.lastIndexOf(".");
                            //FIXME : 업로드 확장자 체크, 이미지파일만 upload
                            if(value !='' ) {
                                var record = masterGrid.getSelectedRecord();
                                inputTable.setValue('_fileChange', 'true');
                                //detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],true);
                                //detailWin.setToolbarButtons(['prev','next'],false);
                            }
                        }
                    }
                  }
                  ,{ xtype: 'button', text:'올리기', margin:'0 0 0 2',
                     handler:function() {
                        var config = {
                            success : function()  {
                                var selRecord = masterGrid.getSelectedRecord();
                                inputTable.loadForm(selRecord);             // 입력값 이외의 자동생성 필드가 있다면 반드시 넣어준다.
                                //detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
                                //detailWin.setToolbarButtons(['prev','next'],true);
                            }
                        }
                        UniAppManager.app.onSaveDataButtonDown(config);
                     }                                
                  },{ name: '_fileChange',              fieldLabel: '사진수정여부'  ,hidden:true  }
                  ,
                  { xtype: 'image', id:'peq100Image', src:CPATH+'/resources/images/nameCard.jpg', width:400,     overflow:'auto', colspan:2}
        ],
        setImage : function (fid)  {
            var image = Ext.getCmp('peq100Image');
            var src = CPATH+'/resources/images/nameCard.jpg'
            if(!Ext.isEmpty(fid))   {
                //src = CPATH+'/fileman/download.do?fid='+fid+'&inline=Y';
                src= CPATH+'/fileman/view/'+fid;
            }
            image.setSrc(src);
         },
         loadForm: function(record) {
            // window 오픈시 form에 Data load
            this.reset();
            this.setActiveRecord(record || null);   
            this.resetDirtyStatus();
            inputTable.setImage(record.get('IMAGE_FID'));
            
            /*var win = this.up('uniDetailFormWindow');
            if(win) {       // 처음 윈도열때는 윈독 존재 하지 않음.
                 win.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
                 win.setToolbarButtons(['prev','next'],true);
            }*/
        }
    });
    
    var masterGrid = Unilite.createGrid('s_peq100ukrv_kdmasterGrid', { 
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
            { dataIndex: 'COMP_CODE'                          ,           width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'                           ,           width: 100, hidden: true},
            { dataIndex: 'EQUIP_CODE'                         ,           width: 100},
            { dataIndex: 'EQUIP_NAME'                         ,           width: 200},
            { dataIndex: 'EQUIP_SPEC'                         ,           width: 200},
            { dataIndex: 'EQUIP_TYPE'                         ,           width: 100},
            { dataIndex: 'DATE_PURCHASE'                      ,           width: 80},
            { dataIndex: 'PURCHASE_NAME'                      ,           width: 80},
            { dataIndex: 'PURCHASE_AMT'                       ,           width: 80},
            { dataIndex: 'MAKER_NAME'                         ,           width: 80},
            { dataIndex: 'DATE_MAKER'                         ,           width: 80},
            { dataIndex: 'USE_TYPE'                           ,           width: 200},
            { dataIndex: 'MAKE_SERIAL'                        ,           width: 100},
            { dataIndex: 'INS_DATE'                           ,           width: 80},
            { dataIndex: 'OPR_DATE'                           ,           width: 80},
            { dataIndex: 'DISP_DATE'                          ,           width: 80},
            { dataIndex: 'INS_PLACE'                          ,           width: 200},
            { dataIndex: 'WORK_SHOP_CODE'        ,       width: 80
                ,'editor' : Unilite.popup('WORK_SHOP_G',{textFieldName:'TREE_CODE', textFieldWidth:100, DBtextFieldName: 'TREE_CODE',
                    autoPopup: true,
                    listeners: {'onSelected': {
                            fn: function(records, type) {
                                UniAppManager.app.fnWorkShopChange(records); 
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            grdRecord = Ext.getCmp('tab_pbs070ukrvs5Tab').down('#pbs070ukrvs_5Grid').getSelectedRecord();
                            record = records[0];
                            grdRecord.set('WORK_SHOP_CODE', '');
                            grdRecord.set('WORK_SHOP_NAME', '');
                        },
                        applyextparam: function(popup){ 
                            var param =  panelSearch.getValues();
                            popup.setExtParam({'TYPE_LEVEL': param.DIV_CODE});
                        }
                    }
                })
            },
            { dataIndex: 'WORK_SHOP_NAME'        ,       width: 200
                ,'editor' : Unilite.popup('WORK_SHOP_G',{textFieldName:'TREE_NAME', textFieldWidth:100, DBtextFieldName: 'TREE_NAME',
                    autoPopup: true,
                    listeners: {'onSelected': {
                            fn: function(records, type) {
                                UniAppManager.app.fnWorkShopChange(records);     
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            grdRecord = Ext.getCmp('tab_pbs070ukrvs5Tab').down('#pbs070ukrvs_5Grid').getSelectedRecord();
                            record = records[0];
                            grdRecord.set('WORK_SHOP_CODE', '');
                            grdRecord.set('WORK_SHOP_NAME', '');
                        },
                        applyextparam: function(popup){ 
                            var param =  panelSearch.getValues();
                            popup.setExtParam({'TYPE_LEVEL': param.DIV_CODE});
                        }
                    }
                })
            },
            { dataIndex: 'DEPT_CODE'                          ,           width: 100,
                'editor': Unilite.popup('DEPT_G',{
                    autoPopup: true,
                    DBtextFieldName: 'DEPT_CODE',
                    listeners: { 'onSelected': {
                        fn: function(records, type  ){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('DEPT_CODE',records[0]['TREE_CODE']);
                            grdRecord.set('DEPT_NAME',records[0]['TREE_NAME']);
                            
                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('DEPT_CODE','');
                            grdRecord.set('DEPT_NAME','');
                      }
                    }
                })
            },
            { dataIndex: 'DEPT_NAME'                ,               width:150,
              'editor': Unilite.popup('DEPT_G',{
                    autoPopup: true,
                    listeners: { 'onSelected': {
                        fn: function(records, type  ){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('DEPT_CODE',records[0]['TREE_CODE']);
                            grdRecord.set('DEPT_NAME',records[0]['TREE_NAME']);
                            
                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('DEPT_CODE','');
                            grdRecord.set('DEPT_NAME','');
                      }
                    }
                })
            },
            { dataIndex: 'DEPT_PRSN_CODE'                     ,           width: 100,
               'editor': Unilite.popup('Employee_G',{
                        textFieldName : 'PERSON_NUMB',
                        autoPopup: true,
                        listeners: { 'onSelected': {
                            fn: function(records, type  ){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                                grdRecord.set('DEPT_PRSN_CODE',records[0]['PERSON_NUMB']);
                                grdRecord.set('DEPT_PRSN_NAME',records[0]['NAME']);
                            },
                            scope: this
                          },
                          'onClear' : function(type)    {
                                var grdRecord = masterGrid.uniOpt.currentRecord;
                                grdRecord.set('DEPT_PRSN_CODE','');
                                grdRecord.set('DEPT_PRSN_NAME','');
                          }
                        }
                    })
            },
            { dataIndex: 'DEPT_PRSN_NAME'                     ,           width: 200,
               'editor': Unilite.popup('Employee_G',{
                        textFieldName : 'PERSON_NAME',
                        autoPopup: true,
                        listeners: { 'onSelected': {
                            fn: function(records, type  ){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                                grdRecord.set('DEPT_PRSN_CODE',records[0]['PERSON_NUMB']);
                                grdRecord.set('DEPT_PRSN_NAME',records[0]['NAME']);
                            },
                            scope: this
                          },
                          'onClear' : function(type)    {
                                var grdRecord = masterGrid.uniOpt.currentRecord;
                                grdRecord.set('DEPT_PRSN_CODE','');
                                grdRecord.set('DEPT_PRSN_NAME','');
                          }
                        }
                    })
            },
            { dataIndex: 'USE_DEPT_CODE'                      ,           width: 100,
                'editor': Unilite.popup('DEPT_G',{
                    autoPopup: true,
                    DBtextFieldName: 'DEPT_CODE',
                    listeners: { 'onSelected': {
                        fn: function(records, type  ){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('USE_DEPT_CODE',records[0]['TREE_CODE']);
                            grdRecord.set('USE_DEPT_NAME',records[0]['TREE_NAME']);
                            
                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('USE_DEPT_CODE','');
                            grdRecord.set('USE_DEPT_NAME','');
                      }
                    }
                })
            },
            { dataIndex: 'USE_DEPT_NAME'                      ,           width: 200,
              'editor': Unilite.popup('DEPT_G',{
                    autoPopup: true,
                    listeners: { 'onSelected': {
                        fn: function(records, type  ){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('USE_DEPT_CODE',records[0]['TREE_CODE']);
                            grdRecord.set('USE_DEPT_NAME',records[0]['TREE_NAME']);
                            
                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('USE_DEPT_CODE','');
                            grdRecord.set('USE_DEPT_NAME','');
                      }
                    }
                })
            },
            { dataIndex: 'USE_DEPT_PRSN_CODE'                 ,           width: 100,
               'editor': Unilite.popup('Employee_G',{
                        textFieldName : 'PERSON_NUMB',
                        autoPopup: true,
                        listeners: { 'onSelected': {
                            fn: function(records, type  ){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                                grdRecord.set('USE_DEPT_PRSN_CODE',records[0]['PERSON_NUMB']);
                                grdRecord.set('USE_DEPT_PRSN_NAME',records[0]['NAME']);
                            },
                            scope: this
                          },
                          'onClear' : function(type)    {
                                var grdRecord = masterGrid.uniOpt.currentRecord;
                                grdRecord.set('USE_DEPT_PRSN_CODE','');
                                grdRecord.set('USE_DEPT_PRSN_NAME','');
                          }
                        }
                    })
            },
            { dataIndex: 'USE_DEPT_PRSN_NAME'                 ,           width: 200,
               'editor': Unilite.popup('Employee_G',{
                        textFieldName : 'PERSON_NAME',
                        autoPopup: true,
                        listeners: { 'onSelected': {
                            fn: function(records, type  ){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                                grdRecord.set('USE_DEPT_PRSN_CODE',records[0]['PERSON_NUMB']);
                                grdRecord.set('USE_DEPT_PRSN_NAME',records[0]['NAME']);
                            },
                            scope: this
                          },
                          'onClear' : function(type)    {
                                var grdRecord = masterGrid.uniOpt.currentRecord;
                                grdRecord.set('USE_DEPT_PRSN_CODE','');
                                grdRecord.set('USE_DEPT_PRSN_NAME','');
                          }
                        }
                    })
            },
            { dataIndex: 'STATUS'                             ,           width: 100},
            { dataIndex: 'REMARK'                             ,           width: 100},
            { dataIndex: 'INSERT_DB_USER'                     ,           width: 80, hidden: true},
            { dataIndex: 'INSERT_DB_TIME'                     ,           width: 80, hidden: true},
            { dataIndex: 'UPDATE_DB_USER'                     ,           width: 80, hidden: true},
            { dataIndex: 'UPDATE_DB_TIME'                     ,           width: 80, hidden: true}
        ],
        listeners: {
            beforeedit  : function( editor, e, eOpts ) {
                if(e.record.phantom) {
                    if(UniUtils.indexOf(e.field, ['DIV_CODE'])) 
                    { 
                        return false;
                    } else {
                        return true;
                    }
                } else {
                    if(UniUtils.indexOf(e.field, ['DIV_CODE', 'EQUIP_CODE']))
                    {
                        return false;
                    } else {
                        return true;
                    }
                }
            },
            selectionchange:function( model1, selected, eOpts ){
                if(selected.length > 0) {
                    var record = selected[0];
                    inputTable.loadForm(record);
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
                    region : 'east',
                    xtype : 'container',
                    width: 410,
                    layout : 'fit',
                    items : [ inputTable ]
                }
            ]
        },
            panelSearch      
        ],
        id  : 's_peq100ukrv_kdApp',
        fnInitBinding : function() {
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'],false);
            UniAppManager.setToolbarButtons('newData', true);
            this.setDefault();
        },
        onQueryButtonDown : function()  {
        	if(panelSearch.setAllFieldsReadOnly(true) == false){
                return false;
            }
            directMasterStore.loadStoreRecords();
            UniAppManager.setToolbarButtons(['reset'], true);
        },
        onResetButtonDown: function() {
            panelSearch.setAllFieldsReadOnly(false);
            panelResult.setAllFieldsReadOnly(false);
            panelSearch.clearForm();
            panelResult.clearForm(); 
            masterGrid.reset();
            this.setDefault();
        },
        onNewDataButtonDown: function() {       // 행추가
            //if(containerclick(masterGrid)) {
                var compCode        =   UserInfo.compCode; 
                var divCode         =   panelSearch.getValue('DIV_CODE');   
                var datePurchase    =   UniDate.get('today');  
                var purchaseAmt     =   '0';  
                var dateMaker       =   UniDate.get('today');  
                
                var r = {
                    COMP_CODE:          compCode,
                    DIV_CODE:           divCode,
                    DATE_PURCHASE:      datePurchase,
                    PURCHASE_AMT:       purchaseAmt,
                    DATE_MAKER:         dateMaker
                };
                masterGrid.createRow(r);
        },
        onDeleteDataButtonDown: function() {
            var record = masterGrid.getSelectedRecord();
            
            if(record.phantom === true) {
                masterGrid.deleteSelectedRow();
            } else {
                if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                    masterGrid.deleteSelectedRow();
                }
            }
        },
        onSaveDataButtonDown: function (config) {
            if(inputTable.isDirty()) {
                inputTable.submit({
                            waitMsg: 'Uploading...',
                            success: function(form, action) {
                                if( action.result.success === true) {
                                    masterGrid.getSelectedRecord().set('IMAGE_FID', action.result.fid);                                  
                                    directMasterStore.saveStore(config);
                                    inputTable.setImage(action.result.fid);
                                    inputTable.clearForm();
                                }
                            }
                    });
            }else {
                directMasterStore.saveStore(config);
            }
        },
        setDefault: function() {
            directMasterStore.clearData();
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelSearch.setValue('DATE_PURCHASE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('DATE_PURCHASE_FR', UniDate.get('startOfMonth'));
            panelSearch.setValue('DATE_PURCHASE_TO', UniDate.get('today'));
            panelResult.setValue('DATE_PURCHASE_TO', UniDate.get('today'));
            UniAppManager.setToolbarButtons(['save'], false);
            
            inputTable.setImage('');
            
        },
        fnWorkShopChange: function(records) {
            grdRecord = masterGrid.getSelectedRecord();
            record = records[0];
            grdRecord.set('WORK_SHOP_CODE', record.TREE_CODE);
            grdRecord.set('WORK_SHOP_NAME', record.TREE_NAME);
            if(Ext.isEmpty(grdRecord.get('DIV_CODE'))){
                grdRecord.set('DIV_CODE', record.TYPE_LEVEL);
            }
        }
    });                         
}
</script>