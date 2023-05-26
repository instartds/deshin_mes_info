<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmd100ukrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_pmd100ukrv_kd"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--매출구분-->
    <t:ExtComboStore comboType="AU" comboCode="WB08" /> <!--금형구분-->
    <t:ExtComboStore comboType="AU" comboCode="WB09" /> <!--금형구분-->
    <t:ExtComboStore comboType="AU" comboCode="WB10" /> <!--위치상태-->
    <t:ExtComboStore comboType="AU" comboCode="WB11" /> <!--수금구분-->
    <t:ExtComboStore comboType="AU" comboCode="B219" /> <!--등록여부-->
    <t:ExtComboStore comboType="AU" comboCode="B010" /> <!--사용여부-->
    <t:ExtComboStore comboType="AU" comboCode="WB04" /> <!--차종-->
    <t:ExtComboStore comboType="AU" comboCode="A036" /> <!--상각방법-->
</t:appConfig>
<script type="text/javascript" >

var SpareWindow; // 스페어정보창

function appMain() {
    
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_pmd100ukrv_kdService.selectList',
            update: 's_pmd100ukrv_kdService.updateDetail',
            create: 's_pmd100ukrv_kdService.insertDetail',
            destroy: 's_pmd100ukrv_kdService.deleteDetail',
            syncAll: 's_pmd100ukrv_kdService.saveAll'
        }
    });
    
    var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_pmd100ukrv_kdService.selectSpareList',
            update: 's_pmd100ukrv_kdService.updateDetail2',
            create: 's_pmd100ukrv_kdService.insertDetail2',
            destroy: 's_pmd100ukrv_kdService.deleteDetail2',
            syncAll: 's_pmd100ukrv_kdService.saveAll2'
        }
    });
    
    /**
	 * Model 정의
	 * 
	 * @type
	 */
    Unilite.defineModel('s_pmd100ukrv_kdModel', {
        fields: [
            {name: 'COMP_CODE'              ,text:'법인코드'               ,type: 'string'},
            {name: 'DIV_CODE'               ,text:'사업장'                 ,type: 'string', comboType:'BOR120'},
            {name: 'MOLD_CODE'              ,text:'금형코드'               ,type: 'string', allowBlank:false},
            {name: 'MOLD_NAME'              ,text:'금형명'                 ,type: 'string', allowBlank:false},
            {name: 'MOLD_TYPE'              ,text:'금형구분'               ,type: 'string', comboType: 'AU', comboCode: 'WB08', allowBlank:false},
            {name: 'MOLD_MTL'               ,text:'금형소재'               ,type: 'string'},
            {name: 'MOLD_QLT'               ,text:'재질'                   ,type: 'string'},
            {name: 'MOLD_SPEC'              ,text:'금형규격'               ,type: 'string'},
            {name: 'ITEM_CODE'              ,text:'품목코드'               ,type: 'string'},
            {name: 'ITEM_NAME'              ,text:'품목명'                 ,type: 'string'},
            {name: 'OEM_ITEM_CODE'          ,text:'품번'                   ,type: 'string'},
            {name: 'CAR_TYPE'               ,text:'차종'                   ,type: 'string', comboType: 'AU', comboCode: 'WB04'},
            {name: 'MOLD_PRICE'             ,text:'단가'                   ,type: 'uniUnitPrice'},
            {name: 'MOLD_NUM'               ,text:'금형도번'               ,type: 'string'},
            {name: 'MOLD_STRC'              ,text:'구조'                   ,type: 'string'},
            {name: 'TXT_LIFE'               ,text:'수명'                   ,type: 'uniQty'},
            {name: 'MT_DEPR'                ,text:'상각방법'               ,type: 'string', comboType: 'AU', comboCode: 'A036'},
            {name: 'MAX_DEPR'               ,text:'최대상각'               ,type: 'uniQty'},
            {name: 'CHK_DEPR'               ,text:'점검주기'               ,type: 'uniQty'},
            {name: 'NOW_DEPR'               ,text:'현상각'                 ,type: 'uniQty'},
            {name: 'LIMT_DEPR'              ,text:'한도상각'               ,type: 'uniQty'},
            {name: 'CAVITY'                 ,text:'CAVITY'                 ,type: 'uniQty'},
            {name: 'USE_CNT'                ,text:'USE'                    ,type: 'uniQty'},
            {name: 'USE_YN'                 ,text:'사용유무'               ,type: 'string', comboType: 'AU', comboCode: 'B010'},
            {name: 'DATE_INST'              ,text:'설치일자'               ,type: 'uniDate'},
            {name: 'DATE_BEHV'              ,text:'가동일자'               ,type: 'uniDate'},
            {name: 'ST_LOCATION'            ,text:'위치상태'               ,type: 'string', comboType: 'AU', comboCode: 'WB09'},
            {name: 'COMP_KEEP'              ,text:'보관방법'               ,type: 'string'},
            {name: 'LOCATION_KEEP'          ,text:'보관위치'               ,type: 'string'},
            {name: 'DATE_PASSOVER'          ,text:'이관일자'               ,type: 'uniDate'},
            {name: 'MAKE_REASON'            ,text:'제작원인'               ,type: 'string', comboType: 'AU', comboCode: 'WB10'},
            {name: 'DATE_MAKE'              ,text:'제작일자'               ,type: 'uniDate'},
            {name: 'MAKER_NAME_CODE'        ,text:'제작업체코드'           ,type: 'string'},
            {name: 'MAKER_NAME_NAME'        ,text:'제작업체명'             ,type: 'string'},
            {name: 'COMP_OWN_CODE'          ,text:'소유업체코드'           ,type: 'string'},
            {name: 'COMP_OWN_NAME'          ,text:'소유업체명'             ,type: 'string'},
            {name: 'COMP_DEV_CODE'          ,text:'개발업체코드'           ,type: 'string'},
            {name: 'COMP_DEV_NAME'          ,text:'개발업체명'             ,type: 'string'},
            {name: 'TP_COLLECT'             ,text:'수금구분'               ,type: 'string', comboType: 'AU', comboCode: 'WB11'},
            {name: 'DISP_REASON'            ,text:'폐기사유'               ,type: 'string'},
            {name: 'DATE_DISP'              ,text:'폐기일자'               ,type: 'uniDate'},
            {name: 'ADD_DEPR'               ,text:'누적상각'               ,type: 'uniQty'},
            {name: 'KEEP_CUSTOM_CODE'       ,text:'보관업체코드'           ,type: 'string'},
            {name: 'KEEP_CUSTOM_NAME'       ,text:'보관업체명'             ,type: 'string'},
            {name: 'LAST_DATE'              ,text:'최근검교정일'           ,type: 'uniDate'},
            {name: 'NEXT_DATE'              ,text:'다음검교정일'           ,type: 'uniDate'},
            {name: 'CAL_CYCLE_MM'           ,text:'검정주기일'             ,type: 'uniDate'},
            {name: 'CAL_CNT'                ,text:'점검차수'               ,type: 'uniQty'},
            {name: 'WORK_SHOP_CODE'         ,text:'작업장코드'             ,type: 'string'},
            {name: 'WORK_SHOP_NAME'         ,text:'작업장명'               ,type: 'string'},
            {name: 'PROG_WORK_CODE'         ,text:'공정코드'               ,type: 'string'},
            {name: 'PROG_WORK_NAME'         ,text:'공정명'                 ,type: 'string'},
            {name: 'CON_NUM'                ,text:'분할수'                 ,type: 'uniQty'},
            {name: 'REMARK'                 ,text:'비고'                   ,type: 'string'},
        	{name: '_fileChange'            ,text:'사진저장체크'           ,type: 'string', editable:false},
            {name: 'IMAGE_FID'              ,text: '사진FID'               ,type: 'string'} 
        ]
    }); 
    
    Unilite.defineModel('s_pmd100ukrv_kdModel2', {
        fields: [
            {name: 'COMP_CODE'              ,text:'법인코드'               ,type: 'string'},
            {name: 'DIV_CODE'               ,text:'사업장'                 ,type: 'string', comboType:'BOR120'},
            {name: 'MOLD_CODE'              ,text:'금형코드'               ,type: 'string'},
            {name: 'ITEM_CODE'              ,text:'품목코드'               ,type: 'string', allowBlank:false},
            {name: 'ITEM_NAME'              ,text:'품목명'                 ,type: 'string', editable:false},
            {name: 'SPEC'                   ,text:'규격'                   ,type: 'string', editable:false},
            {name: 'NEED_QTY'               ,text:'소요량'                 ,type: 'uniQty', allowBlank:false},
            {name: 'SAFE_STOCK_Q'           ,text:'안전재고량'             ,type: 'uniQty', editable:false},
            {name: 'STOCK_QTY'              ,text:'재고량'                 ,type: 'uniQty', editable:false},
            {name: 'PURCH_LDTIME'           ,text:'발주L/T'                ,type: 'uniQty', editable:false}
        ]
    }); 
    
    /**
	 * Store 정의(Service 정의)
	 * 
	 * @type
	 */                 
    var directMasterStore = Unilite.createStore('s_pmd100ukrv_kdMasterStore1',{
        model: 's_pmd100ukrv_kdModel',
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
        listeners:{
            load: function(store, records, successful, eOpts) {
                if(masterGrid.getStore().getCount() == 0) {
                    Ext.getCmp('SPR_BTN').setDisabled(true);
                } else {
                    Ext.getCmp('SPR_BTN').setDisabled(false);
                }
            }   
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
            
            // 1. 마스터 정보 파라미터 구성
            var paramMaster= panelResult.getValues();    // syncAll 수정

            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {                        
                        panelResult.getForm().wasDirty = false;
                        panelResult.resetDirtyStatus();
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
    
    var directMasterStore2 = Unilite.createStore('s_pmd100ukrv_kdMasterStore2',{
        model: 's_pmd100ukrv_kdModel2',
        uniOpt : {
            isMaster:  false,           // 상위 버튼 연결
            editable:  true,            // 수정 모드 사용
            deletable: true,            // 삭제 가능 여부
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy2,
        loadStoreRecords : function()   {  
        	var param= spareSearch.getValues();
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
            
            var isErr = false;
            Ext.each(list, function(record, index) {
                if(Ext.isEmpty(record.get('ITEM_CODE')) || Ext.isEmpty(record.get('NEED_QTY'))){
                    alert((index + 1) + '행의 입력값을 확인해 주세요.\n' + '품목/소요량: 필수 입력값 입니다.');
                    isErr = true;
                    return false;
                }
            });
            if(isErr) return false;
            
            // 1. 마스터 정보 파라미터 구성
            var paramMaster= panelResult.getValues();    // syncAll 수정

            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {                        
                        panelResult.getForm().wasDirty = false;
                        panelResult.resetDirtyStatus();
                        console.log("set was dirty to false");
                        UniAppManager.setToolbarButtons('save', false); 
                        UniAppManager.app.onQueryButtonDown();
                    } 
                };
                this.syncAllDirect(config);
            } else {
                spareGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        }
    }); // End of var directMasterStore1
    
    /**
	 * 검색조건 (Search Panel)
	 * 
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
                fieldLabel: '제작일자',
                xtype: 'uniDateRangefield',
                startFieldName: 'DATE_MAKE_FR',
                endFieldName: 'DATE_MAKE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today')
                //colspan: 2
            },{
                fieldLabel: '폐기포함',
                name:'DATE_DISP',
                xtype: 'checkboxfield',
                checked: false
            },{
                fieldLabel: '금형구분',
                name:'MOLD_TYPE',  
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'WB08'
            },
            Unilite.popup('MOLD_CODE',{ 
                    fieldLabel: '금형',
                    valueFieldName:'MOLD_CODE',
                    textFieldName:'MOLD_NAME',
                    valueFieldWidth: 100,
                    textFieldWidth: 200,
                    autoPopup:true,
                    listeners: {
                        applyextparam: function(popup){                         
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                        }
                    }
            }),{
                fieldLabel: '품번',
                name:'OEM_ITEM_CODE',   
                xtype: 'uniTextfield'
//                allowBlank:false
            },{
                fieldLabel: 'TEMP',
                name:'DATE_MAKE_FR_TEMP',   
                xtype: 'uniDatefield',
                hidden: true
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
                    // this.mask();
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
                // this.unmask();
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
                value:'<div style="color:blue;font-weight:bold;padding-left:5px;">[금형 이미지]</div>',
                colspan:2},
                
                  { xtype: 'filefield',
                    buttonOnly: false,
                    fieldLabel: '사진',
                    hideLabel:true,
                    width:300,
                    name: 'fileUpload',
                    buttonText: '파일선택',
                    listeners: {change : function( filefield, value, eOpts )    {
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
                        var config = {success : function()  {
                                            var selRecord = masterGrid.getSelectedRecord();
                                            detailForm.loadForm(selRecord);             // 입력값 이외의 자동생성 필드가 있다면 반드시 넣어준다.
                                            //detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
                                            //detailWin.setToolbarButtons(['prev','next'],true);
                                      }
                            }
                        UniAppManager.app.onSaveDataButtonDown(config);
                     }                                
                  },{ name: '_fileChange',              fieldLabel: '사진수정여부'  ,hidden:true  }
                  ,
                  { xtype: 'image', id:'pmd100Image', src:CPATH+'/resources/images/nameCard.jpg', width:400,     overflow:'auto', colspan:2}
        ]
       , setImage : function (fid)  {
                    var image = Ext.getCmp('pmd100Image');
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
                inputTable.setImage(record.get('IMAGE_FID'));
                
                /*var win = this.up('uniDetailFormWindow');
                if(win) {       // 처음 윈도열때는 윈독 존재 하지 않음.
                     win.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
                     win.setToolbarButtons(['prev','next'],true);
                }*/
            }
    });
    
    var spareSearch = Unilite.createSearchForm('spareSearchForm', {     // 스페어
        layout: {type: 'uniTable', columns : 2},
//        trackResetOnLoad: true,
        items: [{
                fieldLabel: '사업장',
                name: 'DIV_CODE',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                readOnly: true
            },
            Unilite.popup('MOLD_CODE',{ 
                fieldLabel: '금형',
                valueFieldName:'MOLD_CODE',
                textFieldName:'MOLD_NAME',
                readOnly: true
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
    
    var spareGrid = Unilite.createGrid('reqNumMasterGrid', {     // 스페어
        layout : 'fit',       
        store: directMasterStore2,
        uniOpt:{
            useRowNumberer: false
        },
        columns:  [
            {dataIndex : 'COMP_CODE'                  , width : 80, hidden: true},   
            {dataIndex : 'DIV_CODE'                   , width : 80, hidden: true},   
            {dataIndex : 'MOLD_CODE'                  , width : 80, hidden: true},   
            {dataIndex : 'ITEM_CODE'                  , width : 110,
                editor: Unilite.popup('DIV_PUMOK_G', {      
                        textFieldName: 'ITEM_CODE',
                        DBtextFieldName: 'ITEM_CODE',
                        extParam: {SELMODEL: 'MULTI', DIV_CODE: UserInfo.divCode, POPUP_TYPE: 'GRID_CODE'},
                        autoPopup:true,
                        listeners: {'onSelected': {
                            fn: function(records, type) {
                                console.log('records : ', records);
                                Ext.each(records, function(record,i) {                                                                     
                                    if(i==0) {
                                        spareGrid.setItemData(record,false, spareGrid.uniOpt.currentRecord);
                                    } else {
                                        UniAppManager.app.onNewSpareDataButtonDown();
                                        spareGrid.setItemData(record,false, spareGrid.getSelectedRecord());
                                    }
                                }); 
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            spareGrid.setItemData(null,true, spareGrid.uniOpt.currentRecord);
                        },
                        applyextparam: function(popup){                         
                            popup.setExtParam({'DIV_CODE': spareSearch.getValue('DIV_CODE')});
                        }
                    }
                })
            },   
            {dataIndex : 'ITEM_NAME'                  , width : 200},   
            {dataIndex : 'SPEC'                       , width : 200},   
            {dataIndex : 'NEED_QTY'                   , width : 80},   
            {dataIndex : 'SAFE_STOCK_Q'                 , width : 100},   
            {dataIndex : 'STOCK_QTY'                  , width : 80},   
            {dataIndex : 'PURCH_LDTIME'               , width : 80}
        ],
        setItemData: function(record, dataClear) {
            var grdRecord = this.getSelectedRecord();
            if(dataClear) {                                     
                grdRecord.set('ITEM_CODE'           , ''); 
                grdRecord.set('ITEM_NAME'           , '');  
                grdRecord.set('SPEC'                , '');  
                grdRecord.set('SAFE_STOCK_Q'          , ''); 
                
                grdRecord.set('PURCH_LDTIME'        , '');           
            } else {                                              
                grdRecord.set('ITEM_CODE'           , record['ITEM_CODE']); 
                grdRecord.set('ITEM_NAME'           , record['ITEM_NAME']);  
                grdRecord.set('SPEC'                , record['SPEC']);  
                grdRecord.set('SAFE_STOCK_Q'          , record['SAFE_STOCK_Q']); 
                
                grdRecord.set('PURCH_LDTIME'        , record['PURCH_LDTIME']);  
            }
            
        }
    });
    
    function openSpareWindow() {   // 스페어 팝업
        if(!SpareWindow) {
            SpareWindow = Ext.create('widget.uniDetailWindow', {
                title: '스페어등록',
                width: 1080,                             
                height: 580,
                layout: {type:'vbox', align:'stretch'},                 
                items: [spareSearch, spareGrid], 
                tbar:  ['->',
                    {
                        itemId : 'saveBtn',
                        text: '조회',
                        handler: function() {
                            if(spareSearch.setAllFieldsReadOnly(true) == false){
                                return false;
                            } else {
                                directMasterStore2.loadStoreRecords();
                            }
                        },
                        disabled: false
                    },{
                        text: '행추가',
                        handler: function() {
                            UniAppManager.app.onNewSpareDataButtonDown();
                        },
                        disabled: false
                    },{
                        text: '행삭제',
                        handler: function() {
                        	if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                                spareGrid.deleteSelectedRow();
                        	}
                        },
                        disabled: false
                    },{
                        text: '저장',
                        handler: function() {
                        	directMasterStore2.saveStore();
                        },
                        disabled: false
                    }, {
                        itemId : 'OrderNoCloseBtn',
                        text: '닫기',
                        handler: function() {
                            SpareWindow.hide();
                        },
                        disabled: false
                    }
                ],
                listeners: {
                    beforeshow: function( panel, eOpts )    {
                    	var record = masterGrid.getSelectedRecord();
                        spareSearch.setValue('DIV_CODE', record.get('DIV_CODE'));
                        spareSearch.setValue('MOLD_CODE', record.get('MOLD_CODE'));
                        spareSearch.setValue('MOLD_NAME', record.get('MOLD_NAME'));
                        directMasterStore2.loadStoreRecords();
                    }
                }       
            })
        }
        SpareWindow.show();
        SpareWindow.center();
    }
    
    var masterGrid = Unilite.createGrid('s_pmd100ukrv_kdmasterGrid', { 
        layout : 'fit',   
        region: 'center',                          
        store: directMasterStore,
        uniOpt: {
        	onLoadSelectFirst : true,
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
        tbar: [{
            itemId : 'estimateBtn',
            id:'SPR_BTN',
            iconCls : 'icon-referance'  ,
            text:'스페어등록',
            handler: function() {
                openSpareWindow();
            }
        }],
        columns:  [ 
            { dataIndex: 'COMP_CODE'                              ,           width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'                               ,           width: 80, hidden: true},
            { dataIndex: 'MOLD_CODE'                              ,           width: 110},
            { dataIndex: 'MOLD_NAME'                              ,           width: 200},
            { dataIndex: 'MOLD_TYPE'                              ,           width: 80},
            { dataIndex: 'MOLD_MTL'                               ,           width: 80},
            { dataIndex: 'MOLD_QLT'                               ,           width: 80},
            { dataIndex: 'MOLD_SPEC'                              ,           width: 100},
//            { dataIndex: 'ITEM_CODE'                              ,           width: 110,
//                editor: Unilite.popup('DIV_PUMOK_G', {      
//                        textFieldName: 'ITEM_CODE',
//                        DBtextFieldName: 'ITEM_CODE',
//                        extParam: {SELMODEL: 'MULTI', DIV_CODE: UserInfo.divCode, POPUP_TYPE: 'GRID_CODE'},
//                        autoPopup:true,
//                        listeners: {'onSelected': {
//                            fn: function(records, type) {
//                                console.log('records : ', records);
//                                Ext.each(records, function(record,i) {                                                                     
//                                    if(i==0) {
//                                        masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
//                                    } else {
//                                        UniAppManager.app.onNewDataButtonDown();
//                                        masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
//                                    }
//                                }); 
//                            },
//                            scope: this
//                        },
//                        'onClear': function(type) {
//                            masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
//                        },
//                        applyextparam: function(popup){                         
//                            popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
//                        }
//                    }
//                })
//            },
//            { dataIndex: 'ITEM_NAME'                              ,           width: 200},
            { dataIndex: 'OEM_ITEM_CODE'                          ,           width: 200},
            { dataIndex: 'CAR_TYPE'                               ,           width: 80},
            { dataIndex: 'MOLD_PRICE'                             ,           width: 80},
            { dataIndex: 'MOLD_NUM'                               ,           width: 110},
            { dataIndex: 'MOLD_STRC'                              ,           width: 80},
            { dataIndex: 'TXT_LIFE'                               ,           width: 80},
            { dataIndex: 'MT_DEPR'                                ,           width: 80},
            { dataIndex: 'MAX_DEPR'                               ,           width: 80},
            { dataIndex: 'CHK_DEPR'                               ,           width: 80},
            { dataIndex: 'NOW_DEPR'                               ,           width: 80},
            { dataIndex: 'LIMT_DEPR'                              ,           width: 80},
            { dataIndex: 'CAVITY'                                 ,           width: 80},
            { dataIndex: 'USE_CNT'                                ,           width: 80},
            { dataIndex: 'USE_YN'                                 ,           width: 80},
            { dataIndex: 'DATE_INST'                              ,           width: 80},
            { dataIndex: 'DATE_BEHV'                              ,           width: 80},
            { dataIndex: 'ST_LOCATION'                            ,           width: 80},
            { dataIndex: 'COMP_KEEP'                              ,           width: 80},
            { dataIndex: 'LOCATION_KEEP'                          ,           width: 80},
            { dataIndex: 'DATE_PASSOVER'                          ,           width: 80},
            { dataIndex: 'MAKE_REASON'                            ,           width: 80},
            { dataIndex: 'DATE_MAKE'                              ,           width: 80},
            { dataIndex: 'MAKER_NAME_CODE'                        ,           width: 100,
                editor: 
                    Unilite.popup('AGENT_CUST_G',{
                        autoPopup:true,
                        listeners:{ 
                        	'onSelected': {
                                fn: function(records, type  ){
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('MAKER_NAME_CODE',records[0]['CUSTOM_CODE']);
                                    grdRecord.set('MAKER_NAME_NAME',records[0]['CUSTOM_NAME']);
                                },
                                scope: this
                           },
                           'onClear' : function(type)    {
                                    //var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('MAKER_NAME_CODE','');
                                    grdRecord.set('MAKER_NAME_NAME','');
                            }
                        }
                    })
            },
            { dataIndex: 'MAKER_NAME_NAME'                        ,           width: 200,
                editor: 
                    Unilite.popup('AGENT_CUST_G',{
                        autoPopup:true,
                        listeners:{ 
                            'onSelected': {
                                fn: function(records, type  ){
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('MAKER_NAME_CODE',records[0]['CUSTOM_CODE']);
                                    grdRecord.set('MAKER_NAME_NAME',records[0]['CUSTOM_NAME']);
                                },
                                scope: this
                           },
                           'onClear' : function(type)    {
                                    //var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('MAKER_NAME_CODE','');
                                    grdRecord.set('MAKER_NAME_NAME','');
                            }
                        }
                    })
            },
            { dataIndex: 'COMP_OWN_CODE'                          ,           width: 100,
                editor: 
                    Unilite.popup('AGENT_CUST_G',{
                        autoPopup:true,
                        listeners:{ 
                            'onSelected': {
                                fn: function(records, type  ){
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('COMP_OWN_CODE',records[0]['CUSTOM_CODE']);
                                    grdRecord.set('COMP_OWN_NAME',records[0]['CUSTOM_NAME']);
                                },
                                scope: this
                           },
                           'onClear' : function(type)    {
                                    //var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('COMP_OWN_CODE','');
                                    grdRecord.set('COMP_OWN_NAME','');
                            }
                        }
                    })
            },
            { dataIndex: 'COMP_OWN_NAME'                          ,           width: 100,
                editor: 
                    Unilite.popup('AGENT_CUST_G',{
                        autoPopup:true,
                        listeners:{ 
                            'onSelected': {
                                fn: function(records, type  ){
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('COMP_OWN_CODE',records[0]['CUSTOM_CODE']);
                                    grdRecord.set('COMP_OWN_NAME',records[0]['CUSTOM_NAME']);
                                },
                                scope: this
                           },
                           'onClear' : function(type)    {
                                    //var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('COMP_OWN_CODE','');
                                    grdRecord.set('COMP_OWN_NAME','');
                            }
                        }
                    })
            },
            { dataIndex: 'COMP_DEV_CODE'                          ,           width: 100,
                editor: 
                    Unilite.popup('AGENT_CUST_G',{
                        autoPopup:true,
                        listeners:{ 
                            'onSelected': {
                                fn: function(records, type  ){
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('COMP_DEV_CODE',records[0]['CUSTOM_CODE']);
                                    grdRecord.set('COMP_DEV_NAME',records[0]['CUSTOM_NAME']);
                                },
                                scope: this
                           },
                           'onClear' : function(type)    {
                                    //var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('COMP_DEV_CODE','');
                                    grdRecord.set('COMP_DEV_NAME','');
                            }
                        }
                    })
            },
            { dataIndex: 'COMP_DEV_NAME'                          ,           width: 200,
                editor: 
                    Unilite.popup('AGENT_CUST_G',{
                        autoPopup:true,
                        listeners:{ 
                            'onSelected': {
                                fn: function(records, type  ){
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('COMP_DEV_CODE',records[0]['CUSTOM_CODE']);
                                    grdRecord.set('COMP_DEV_NAME',records[0]['CUSTOM_NAME']);
                                },
                                scope: this
                           },
                           'onClear' : function(type)    {
                                    //var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('COMP_DEV_CODE','');
                                    grdRecord.set('COMP_DEV_NAME','');
                            }
                        }
                    })
            },
            { dataIndex: 'TP_COLLECT'                             ,           width: 80},
            { dataIndex: 'DISP_REASON'                            ,           width: 80},
            { dataIndex: 'DATE_DISP'                              ,           width: 80},
            { dataIndex: 'ADD_DEPR'                               ,           width: 80},
            { dataIndex: 'KEEP_CUSTOM_CODE'                       ,           width: 100,
                editor: 
                    Unilite.popup('AGENT_CUST_G',{
                        autoPopup:true,
                        listeners:{ 
                            'onSelected': {
                                fn: function(records, type  ){
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('KEEP_CUSTOM_CODE',records[0]['CUSTOM_CODE']);
                                    grdRecord.set('KEEP_CUSTOM_NAME',records[0]['CUSTOM_NAME']);
                                },
                                scope: this
                           },
                           'onClear' : function(type)    {
                                    //var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('KEEP_CUSTOM_CODE','');
                                    grdRecord.set('KEEP_CUSTOM_NAME','');
                            }
                        }
                    })
            },
            { dataIndex: 'KEEP_CUSTOM_NAME'                       ,           width: 200,
                editor: 
                    Unilite.popup('AGENT_CUST_G',{
                        autoPopup:true,
                        listeners:{ 
                            'onSelected': {
                                fn: function(records, type  ){
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('KEEP_CUSTOM_CODE',records[0]['CUSTOM_CODE']);
                                    grdRecord.set('KEEP_CUSTOM_NAME',records[0]['CUSTOM_NAME']);
                                },
                                scope: this
                           },
                           'onClear' : function(type)    {
                                    //var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('KEEP_CUSTOM_CODE','');
                                    grdRecord.set('KEEP_CUSTOM_NAME','');
                            }
                        }
                    })
            },
            { dataIndex: 'LAST_DATE'                              ,           width: 95},
            { dataIndex: 'NEXT_DATE'                              ,           width: 95},
            { dataIndex: 'CAL_CYCLE_MM'                           ,           width: 80},
            { dataIndex: 'CAL_CNT'                                ,           width: 80},
            { dataIndex: 'WORK_SHOP_CODE'                         ,           width: 100,
                editor: Unilite.popup('WORK_SHOP_G', {
                        textFieldName: 'TREE_CODE',
                        DBtextFieldName: 'TREE_NAME',
                        //extParam: {SELMODEL: 'MULTI'},
                        autoPopup: true,
                        listeners: {'onSelected': {
                            fn: function(records, type) {
                                Ext.each(records, function(record,i) {
                                    if(i==0) {                                        
                                        masterGrid.setWorkData(record,false, masterGrid.uniOpt.currentRecord);
                                    }else{
                                        UniAppManager.app.onNewDataButtonDown();
                                        masterGrid.setWorkData(record,false, masterGrid.getSelectedRecord());
                                    }                                                           
                                }); 
                            },
                            scope: this
                            },
                            'onClear': function(type) {
                                masterGrid.setWorkData(null,true, masterGrid.uniOpt.currentRecord);
                            },
                            applyextparam: function(popup){              
                                var record = masterGrid.getSelectedRecord();
                                popup.setExtParam({'TYPE_LEVEL'       : record.get('DIV_CODE')});
                                popup.setExtParam({'SELMODEL' : 'MULTI'});
                            }
                    }
                })
            },
            { dataIndex: 'WORK_SHOP_NAME'                         ,           width: 200,
                editor: Unilite.popup('WORK_SHOP_G', {
                            textFieldName: 'TREE_NAME',
                            DBtextFieldName: 'TREE_NAME',
                            //extParam: {SELMODEL: 'MULTI'},
                            autoPopup: true,
                            listeners: {'onSelected': {
                                fn: function(records, type) {
                                    Ext.each(records, function(record,i) {
                                        if(i==0) {
                                            masterGrid.setWorkData(record,false, masterGrid.uniOpt.currentRecord);
                                        }else{
                                            UniAppManager.app.onNewDataButtonDown();
                                            masterGrid.setWorkData(record,false, masterGrid.getSelectedRecord());
                                        }                                                           
                                    }); 
                                },
                                scope: this
                            },
                            'onClear': function(type) {
                                var grdRecord = masterGrid.getSelectedRecord();
                                masterGrid.setWorkData(null,true, masterGrid.uniOpt.currentRecord);
                            },
                            applyextparam: function(popup){              
                                var record = masterGrid.getSelectedRecord();
                                popup.setExtParam({'TYPE_LEVEL'       : record.get('DIV_CODE')});
                                popup.setExtParam({'SELMODEL' : 'MULTI'});
                            }
                        }
                })
            },
            { dataIndex: 'PROG_WORK_CODE'                         ,           width: 100,
                editor: Unilite.popup('PROG_WORK_CODE_G', {
                        textFieldName: 'PROG_WORK_NAME',
                        DBtextFieldName: 'PROG_WORK_NAME',
                        //extParam: {SELMODEL: 'MULTI'},
                        autoPopup: true,
                        listeners: {'onSelected': {
                            fn: function(records, type) {
                                Ext.each(records, function(record,i) {
                                    if(i==0) {                                        
                                        masterGrid.setProgData(record,false, masterGrid.uniOpt.currentRecord);
                                    }else{
                                        UniAppManager.app.onNewDataButtonDown();
                                        masterGrid.setProgData(record,false, masterGrid.getSelectedRecord());
                                    }                                                           
                                }); 
                            },
                            scope: this
                            },
                            'onClear': function(type) {
                                masterGrid.setProgData(null,true, masterGrid.uniOpt.currentRecord);
                            },
                            applyextparam: function(popup){              
                                var record = masterGrid.getSelectedRecord();
                                popup.setExtParam({'DIV_CODE'       : record.get('DIV_CODE')});
                                popup.setExtParam({'WORK_SHOP_CODE' : record.get('WORK_SHOP_CODE')});
                                popup.setExtParam({'SELMODEL' : 'MULTI'});
                            }
                    }
                })
            },
            {dataIndex: 'PROG_WORK_NAME'    , width: 206,
                editor: Unilite.popup('PROG_WORK_CODE_G', {
                            textFieldName: 'PROG_WORK_NAME',
                            DBtextFieldName: 'PROG_WORK_NAME',
                            //extParam: {SELMODEL: 'MULTI'},
                            autoPopup: true,
                            listeners: {'onSelected': {
                                fn: function(records, type) {
                                    Ext.each(records, function(record,i) {
                                        if(i==0) {
                                            masterGrid.setProgData(record,false, masterGrid.uniOpt.currentRecord);
                                        }else{
                                            UniAppManager.app.onNewDataButtonDown();
                                            masterGrid.setProgData(record,false, masterGrid.getSelectedRecord());
                                        }                                                           
                                    }); 
                                },
                                scope: this
                            },
                            'onClear': function(type) {
                                var grdRecord = masterGrid.getSelectedRecord();
                                masterGrid.setProgData(null,true, masterGrid.uniOpt.currentRecord);
                            },
                            applyextparam: function(popup){              
                                var record = masterGrid.getSelectedRecord();
                                popup.setExtParam({'DIV_CODE'       : record.get('DIV_CODE')});
                                popup.setExtParam({'WORK_SHOP_CODE' : record.get('WORK_SHOP_CODE')});
                                popup.setExtParam({'SELMODEL' : 'MULTI'});
                            }
                        }
                })
            },
            { dataIndex: 'CON_NUM'                                ,           width: 80},
            { dataIndex: 'REMARK'                                 ,           width: 200}
            
        ],
        listeners: {
            beforeedit  : function( editor, e, eOpts ) {
                if(e.record.phantom) {
                    if(UniUtils.indexOf(e.field, ['DIV_CODE', 'ITEM_NAME', 'CAR_TYPE', 'MOLD_NAME', 'PROG_WORK_NAME', 'WORK_SHOP_NAME'])) 
                    { 
                        return false;
                    } else {
                        return true;
                    }
                } else {
                    if(UniUtils.indexOf(e.field, ['DIV_CODE', 'MOLD_CODE', 'ITEM_NAME', 'CAR_TYPE', 'MOLD_NAME', 'PROG_WORK_NAME', 'WORK_SHOP_NAME']))
                    {
                        return false;
                    } else {
                        return true;
                    }
                }
            }, 
            edit: function(editor, e) { console.log(e);
                var fieldName = e.field;
                if(e.value == e.originalValue) return false;
                if(fieldName == 'MOLD_CODE'){
                    var newValue = e.value;
                    if(newValue/*.length == 9*/) {
                    	var param = {
                              'COMP_CODE': UserInfo.compCode
                            , 'MOLD_CODE': e.record.get('MOLD_CODE')
                        };  
                        s_pmd100ukrv_kdService.selectOemCodeCarType(param, function(provider, response)   {
                            if(!Ext.isEmpty(provider)) { 
                                e.record.set('OEM_ITEM_CODE'  , provider[0].OEM_ITEM_CODE); 
                                e.record.set('CAR_TYPE'       , provider[0].CAR_TYPE); 
                            }
                            param2 = {
                                  'COMP_CODE': UserInfo.compCode
                                , 'MOLD_CODE': e.record.get('MOLD_CODE')
                            },
                            s_pmd100ukrv_kdService.selectMoldName(param2, function(provider2, response)   {
                            	if(!Ext.isEmpty(provider2)) { 
	                                e.record.set('MOLD_NAME'  , provider[0].OEM_ITEM_CODE + ' ' + provider2[0].PROG_WORK_NAME); 
	                                e.record.set('PROG_WORK_CODE'  , provider2[0].PROG_WORK_CODE); 
	                                e.record.set('PROG_WORK_NAME'  , provider2[0].PROG_WORK_NAME); 
                            	}
                            });
                        });
                    }
                }
            },
            selectionchange:function( model1, selected, eOpts ){
            	if(selected.length > 0) {
                	var record = selected[0];
                    inputTable.loadForm(record);
                }
            }
        },
        setProgData: function(record, dataClear, grdRecord) {
            if(dataClear) {    
                grdRecord.set('PROG_WORK_CODE'          , '');          
                grdRecord.set('PROG_WORK_NAME'          , '');
                grdRecord.set('PROG_UNIT'               ,  panelSearch.getValue('PROG_UNIT'));
            }else{ 
                grdRecord.set('PROG_WORK_CODE'          , record['PROG_WORK_CODE']);            
                grdRecord.set('PROG_WORK_NAME'          , record['PROG_WORK_NAME']);            
                grdRecord.set('PROG_UNIT'               , record['PROG_UNIT']);
            }
        },
        setWorkData: function(record, dataClear, grdRecord) {
            if(dataClear) {    
                grdRecord.set('WORK_SHOP_CODE'          , '');          
                grdRecord.set('WORK_SHOP_NAME'          , '');
            }else{ 
                grdRecord.set('WORK_SHOP_CODE'          , record['TREE_CODE']);            
                grdRecord.set('WORK_SHOP_NAME'          , record['TREE_NAME']); 
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
        }  
        ],
        id  : 's_pmd100ukrv_kdApp',
        fnInitBinding : function() {
            Ext.getCmp('SPR_BTN').setDisabled(true);
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
            
            UniAppManager.setToolbarButtons(['save'], false);
//            masterGrid.reset();            
            this.setDefault();
        },
        onNewDataButtonDown: function() {       // 행추가
            // if(containerclick(masterGrid)) {
                var compCode        =   UserInfo.compCode; 
                var divCode         =   panelResult.getValue('DIV_CODE');   
                var dateInst        =   '';   
                var dateBehv        =   '';  
                var datePassover    =   '';
                var dateMake        =   '';  
                var dateDisp        =   '';   
                var moldType        =   '1';  
                var useYn           =   'Y';  
                var stLocation      =   '1';  
                var makeReason      =   '1';  
                var tpCollect       =   '1';  
                
                var r = {
                    COMP_CODE:          compCode,
                    DIV_CODE:           divCode,
                    DATE_INST:          dateInst,
                    DATE_BEHV:          dateBehv,
                    DATE_PASSOVER:      datePassover,
                    DATE_MAKE:          dateMake,
                    DATE_DISP:          dateDisp,
                    MOLD_TYPE:          moldType,
                    USE_YN:             useYn,
                    ST_LOCATION:        stLocation,
                    MAKE_REASON:        makeReason,
                    TP_COLLECT:         tpCollect
                };
                masterGrid.createRow(r);
        },
        onNewSpareDataButtonDown: function() {       // 스페어 행추가
            var record = masterGrid.getSelectedRecord();
                var compCode        =   UserInfo.compCode; 
                var divCode         =   record.get('DIV_CODE'); 
                var moldCode        =   record.get('MOLD_CODE'); 
                
                var r = {
                    COMP_CODE:          compCode,
                    DIV_CODE:           divCode,
                    MOLD_CODE:          moldCode
                };
                spareGrid.createRow(r);
        },
        onDeleteDataButtonDown: function() {
            var selRow = masterGrid.getSelectedRecord();
            if(selRow.phantom === true) {
                masterGrid.deleteSelectedRow();
            }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                masterGrid.deleteSelectedRow();
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
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            
            panelResult.setValue('DATE_MAKE_FR_TEMP', UniDate.get('startOfMonth'));
            panelResult.setValue('DATE_INST_TO', UniDate.get('today'));
            
            panelResult.setValue('DATE_MAKE_FR', UniDate.add(panelResult.getValue('DATE_MAKE_FR_TEMP'), {years:-10}));
            panelResult.setValue('DATE_MAKE_TO', UniDate.get('today'));
            
            masterGrid.reset();
            UniAppManager.setToolbarButtons(['save', 'delete'], false);
            inputTable.setImage('');
        }                         
    });    
    
//    Unilite.createValidator('validator01', {
//        store: directMasterStore,
//        grid: masterGrid,
//        validate: function( type, fieldName, newValue, oldValue, record, eopt) {
//                console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
//                var rv = true;
//                switch(fieldName) {
//                    case "MOLD_CODE" :  
//                        if(newValue.length == 9) {
//                            var param = {
//                                  'COMP_CODE': UserInfo.compCode
//                                , 'MOLD_CODE': record.get('MOLD_CODE')
//                            };  
//                            s_pmd100ukrv_kdService.selectOemCodeCarType(param, function(provider, response)   {
//                                if(!Ext.isEmpty(provider)) { 
//                                    record.set('OEM_ITEM_CODE'  , provider[0].OEM_ITEM_CODE); 
//                                    record.set('CAR_TYPE'       , provider[0].CAR_TYPE); 
//                                }
//                            });
//                        }
//                    break;
//                    
//                    case "OEM_ITEM_CODE" :   
//                        
//                    break;
//    
//                return rv;
//            }
//        }
//    })
};
</script>