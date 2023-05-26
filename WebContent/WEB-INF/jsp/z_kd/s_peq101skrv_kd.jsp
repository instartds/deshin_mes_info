<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_peq101skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_peq101skrv_kd"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--매출구분-->
    <t:ExtComboStore comboType="AU" comboCode="WB07" /> <!--설비구분-->
    <t:ExtComboStore comboType="AU" comboCode="B219" /> <!--등록여부-->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('s_peq101skrv_kdModel', {
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
    
    Unilite.defineModel('s_peq101skrv_kdModel2', {
        fields: [
            {name: 'COMP_CODE'              ,text:'법인코드'               ,type: 'string'},
            {name: 'DIV_CODE'               ,text:'사업장'                 ,type: 'string', comboType:'BOR120'},
            {name: 'EQUIP_CODE'             ,text:'설비코드'               ,type: 'string'},
            {name: 'EQUIP_NAME'             ,text:'설비명'                 ,type: 'string'},
            {name: 'ITEM_CODE'              ,text:'품목코드'               ,type: 'string'},
            {name: 'ITEM_NAME'              ,text:'품목명'                 ,type: 'string'},
            {name: 'SPEC'                   ,text:'설비규격'               ,type: 'string'},
            {name: 'NEED_Q'                 ,text:'필요수량'               ,type: 'uniQty'},
            {name: 'STOCK_Q'                ,text:'현재고량'               ,type: 'uniQty'},
            {name: 'REMARK'                 ,text:'비고'                   ,type: 'string'},
            {name: 'INSERT_DB_USER'         ,text:'입력자'                 ,type: 'string'},
            {name: 'INSERT_DB_TIME'         ,text:'입력일'                 ,type: 'uniDate'},
            {name: 'UPDATE_DB_USER'         ,text:'수정자'                 ,type: 'string'},
            {name: 'UPDATE_DB_TIME'         ,text:'수정일'                 ,type: 'uniDate'}
        ]
    }); 
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore = Unilite.createStore('s_peq101skrv_kdMasterStore1',{
        model: 's_peq101skrv_kdModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  false,            // 수정 모드 사용 
            deletable: false,            // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {read: 's_peq101skrv_kdService.selectList'}
        },
        loadStoreRecords : function()   {   
            var param= panelResult.getValues();
            this.load({
                  params : param
            });         
        }
    }); // End of var directMasterStore1 
    
    var directMasterStore2 = Unilite.createStore('s_peq101skrv_kdMasterStore2',{
        model: 's_peq101skrv_kdModel2',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  false,            // 수정 모드 사용 
            deletable: false,            // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {read: 's_peq101skrv_kdService.selectList2'}
        },
        loadStoreRecords : function(param)   {   
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
                value: UserInfo.divCode
            },{ 
                fieldLabel: '구입일자',
                xtype: 'uniDateRangefield',
                startFieldName: 'DATE_PURCHASE_FR',
                endFieldName: 'DATE_PURCHASE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank:false
            },{
                fieldLabel: '설비구분',
                name:'EQUIP_TYPE',  
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'WB07'
            },
            Unilite.popup('EQUIP_CODE',{ 
                    fieldLabel: '설비',
                    valueFieldName:'EQUIP_CODE',
                    textFieldName:'EQUIP_NAME'
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
    
    var masterGrid = Unilite.createGrid('s_peq101skrv_kdmasterGrid', { 
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
            { dataIndex: 'WORK_SHOP_CODE'                     ,           width: 80},
            { dataIndex: 'WORK_SHOP_NAME'                     ,           width: 200},
            { dataIndex: 'DEPT_CODE'                          ,           width: 100},
            { dataIndex: 'DEPT_NAME'                          ,           width: 150},
            { dataIndex: 'DEPT_PRSN_CODE'                     ,           width: 100},
            { dataIndex: 'DEPT_PRSN_NAME'                     ,           width: 200},
            { dataIndex: 'USE_DEPT_CODE'                      ,           width: 100},
            { dataIndex: 'USE_DEPT_NAME'                      ,           width: 200},
            { dataIndex: 'USE_DEPT_PRSN_CODE'                 ,           width: 100},
            { dataIndex: 'USE_DEPT_PRSN_NAME'                 ,           width: 200},
            { dataIndex: 'STATUS'                             ,           width: 100},
            { dataIndex: 'REMARK'                             ,           width: 100},
            { dataIndex: 'INSERT_DB_USER'                     ,           width: 80, hidden: true},
            { dataIndex: 'INSERT_DB_TIME'                     ,           width: 80, hidden: true},
            { dataIndex: 'UPDATE_DB_USER'                     ,           width: 80, hidden: true},
            { dataIndex: 'UPDATE_DB_TIME'                     ,           width: 80, hidden: true}
        ],
        listeners: {
        	selectionchange:function( model1, selected, eOpts ) {
        		var count = masterGrid.getStore().getCount();
        		if(count > 0) {
                    var record = selected[0];
                    var param = Ext.getCmp('resultForm').getValues(); 
                    var param = {
                        DIV_CODE       : record.get('DIV_CODE'),
                        EQUIP_CODE     : record.get('EQUIP_CODE')
                    }
                    directMasterStore2.loadStoreRecords(param);
                    imagePanel.loadForm(record);
                } else {
                    UniAppManager.app.onResetButtonDown();                        
                }
            }
        }
    });
    
    var masterGrid2 = Unilite.createGrid('s_peq101skrv_kdmasterGrid2', { 
        layout : 'fit',     
        region:'south',                     
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
        columns:  [ 
            { dataIndex: 'COMP_CODE'                          ,           width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'                           ,           width: 80, hidden: true},
            { dataIndex: 'EQUIP_CODE'                         ,           width: 80, hidden: true},
            { dataIndex: 'EQUIP_NAME'                         ,           width: 80, hidden: true},
            { dataIndex: 'ITEM_CODE'                          ,           width: 110,
                editor: Unilite.popup('DIV_PUMOK_G', {      
                        textFieldName: 'ITEM_CODE',
                        DBtextFieldName: 'ITEM_CODE',
			    		autoPopup: true,
                        listeners: {'onSelected': {
                            fn: function(records, type) {
                                console.log('records : ', records);
                                Ext.each(records, function(record,i) {                                                                     
                                    if(i==0) {
                                        masterGrid2.setItemData(record,false, masterGrid2.uniOpt.currentRecord);
                                    } else {
                                        UniAppManager.app.onNewDataButtonDown();
                                        masterGrid2.setItemData(record,false, masterGrid2.getSelectedRecord());
                                    }
                                }); 
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            masterGrid2.setItemData(null,true, masterGrid2.uniOpt.currentRecord);
                        },
                        applyextparam: function(popup){                         
                            popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                        }
                    }
                })
            },
            { dataIndex: 'ITEM_NAME'                          ,           width: 200,
                editor: Unilite.popup('DIV_PUMOK_G', {      
                        textFieldName: 'ITEM_CODE',
                        DBtextFieldName: 'ITEM_CODE',
			    		autoPopup: true,
                        listeners: {'onSelected': {
                            fn: function(records, type) {
                                console.log('records : ', records);
                                Ext.each(records, function(record,i) {                                                                     
                                    if(i==0) {
                                        masterGrid2.setItemData(record,false, masterGrid2.uniOpt.currentRecord);
                                    } else {
                                        UniAppManager.app.onNewDataButtonDown();
                                        masterGrid2.setItemData(record,false, masterGrid2.getSelectedRecord());
                                    }
                                }); 
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            masterGrid2.setItemData(null,true, masterGrid2.uniOpt.currentRecord);
                        },
                        applyextparam: function(popup){                         
                            popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                        }
                    }
                })
            },
            { dataIndex: 'SPEC'                               ,           width: 100},
            { dataIndex: 'NEED_Q'                             ,           width: 80},
            { dataIndex: 'STOCK_Q'                             ,          width: 80},
            { dataIndex: 'REMARK'                             ,           width: 100},
            { dataIndex: 'INSERT_DB_USER'                     ,           width: 80, hidden: true},
            { dataIndex: 'INSERT_DB_TIME'                     ,           width: 80, hidden: true},
            { dataIndex: 'UPDATE_DB_USER'                     ,           width: 80, hidden: true},
            { dataIndex: 'UPDATE_DB_TIME'                     ,           width: 80, hidden: true}
        ],
        listeners: {
            beforeedit  : function( editor, e, eOpts ) {
                if(e.record.phantom) {
                    if(UniUtils.indexOf(e.field, ['SPEC'])) 
                    { 
                        return false;
                    } else {
                        return true;
                    }
                } else {
                    if(UniUtils.indexOf(e.field, ['SPEC']))
                    {
                        return false;
                    } else {
                        return true;
                    }
                }
            }
        },
        setItemData: function(record, dataClear) {
            var grdRecord = this.getSelectedRecord();
            if(dataClear) {                                     
                grdRecord.set('ITEM_CODE'           , ''); 
                grdRecord.set('ITEM_NAME'           , ''); 
                grdRecord.set('SPEC'                , '');           
            } else {                                    
                grdRecord.set('ITEM_CODE'           , record['ITEM_CODE']);  
                grdRecord.set('ITEM_NAME'           , record['ITEM_NAME']);
                grdRecord.set('SPEC'                , record['SPEC']);  
            }
            
        }
    });
    
    var imagePanel = Unilite.createSearchForm('detailForm', { //createForm
        layout : {type : 'uniTable', columns : 2},
        disabled: false,
        border:true,
        autoScroll: true,  
        fileUpload: true,
        url:  CPATH+'/fileman/upload.do',
        padding:'1 1 1 1',
        region: 'east',
        items: [ 
        { xtype:'displayfield',
                hideLabel:true,
                value:'<div style="color:blue;font-weight:bold;padding-left:5px;">[설비 이미지]</div>',
                colspan:2},
                
                  { name: '_fileChange',              fieldLabel: '사진수정여부'  ,hidden:true  },
                  { xtype: 'image', id:'peq101Image', src:CPATH+'/resources/images/nameCard.jpg', width:400,     overflow:'auto', colspan:2}
        ]
       , setImage : function (fid)  {
                    var image = Ext.getCmp('peq101Image');
                    var src = CPATH+'/resources/images/nameCard.jpg'
                    if(!Ext.isEmpty(fid))   {
                        //src = CPATH+'/fileman/download.do?fid='+fid+'&inline=Y';
                        src= CPATH+'/fileman/view/'+fid;
                    }
                    image.setSrc(src);
                 }
            ,loadForm: function(record) {
                // window 오픈시 form에 Data load
                this.reset();
                this.setActiveRecord(record || null);   
                this.resetDirtyStatus();
                imagePanel.setImage(record.get('IMAGE_FID'));
                
                /*var win = this.up('uniDetailFormWindow');
                if(win) {       // 처음 윈도열때는 윈독 존재 하지 않음.
                     win.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
                     win.setToolbarButtons(['prev','next'],true);
                }*/
            }
    });

    
    
    Unilite.Main( {
        borderItems:[{
                region:'center',
                layout: 'border',
                defaults:{
                    split:true
                },
                items:[
                    panelResult,
                    {
                        region : 'center',
                        xtype : 'container',
                        layout : 'fit',
                        items : [ masterGrid ]
                    },
                    masterGrid2,
                    {
                        region : 'east',
                        xtype : 'container',
                        width: 410,
                        layout : 'fit',
                        items : [ imagePanel ]
                    }        
                ]
            }     
        ],
        id  : 's_peq101skrv_kdApp',
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
            masterGrid2.reset();
            this.setDefault();
        },
        setDefault: function() {
            directMasterStore.clearData();
            directMasterStore2.clearData();
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('DATE_PURCHASE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('DATE_PURCHASE_TO', UniDate.get('today'));
            UniAppManager.setToolbarButtons(['save'], false);
            
            imagePanel.setImage('');
        }
    });                         
}
</script>