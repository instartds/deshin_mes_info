<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ppl101ukrv"  >
    <t:ExtComboStore comboType="BOR120" pgmId="ppl101ukrv" /> <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B093" /> <!-- 시작공정 -->
    <t:ExtComboStore comboType="AU" comboCode="S010" /> <!-- 영업담당 -->
    <t:ExtComboStore comboType="AU" comboCode="M007" /> <!-- 승인여부 -->
    
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	

<script type="text/javascript" >

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'ppl101ukrvService.selectList',
            update: 'ppl101ukrvService.updateDetail',
//            create: 'ppl101ukrvService.insertDetail',
//            destroy: 'ppl101ukrvService.deleteDetail',
            syncAll: 'ppl101ukrvService.saveAll'
        }
    });
	

	Unilite.defineModel('ppl101ukrvModel', {
        fields: [
        
        {name: 'SELECT'           	,text: ' '      ,type: 'boolean'},
        {name: 'KEY_VALUE'          ,text: 'KEY_VALUE'      ,type: 'string'},
        {name: 'COMP_CODE'          ,text: '<t:message code="system.label.product.compcode" default="법인코드"/>'      ,type: 'string'},
        {name: 'DIV_CODE'           ,text: '<t:message code="system.label.product.division" default="사업장"/>'      ,type: 'string'},
        {name: 'SORT_ORDER_1'       ,text: 'SORT_ORDER_1'      ,type: 'string'},
        {name: 'SORT_ORDER_2'       ,text: 'SORT_ORDER_2'      ,type: 'string'},
        {name: 'SORT_ORDER_2_NAME'  ,text: '<t:message code="system.label.product.classfication" default="구분"/>'      ,type: 'string'},
        {name: 'ORDER_NUM'          ,text: '<t:message code="system.label.product.sono" default="수주번호"/>'      ,type: 'string'},
        {name: 'SER_NO'             ,text: '<t:message code="system.label.product.seq" default="순번"/>'      ,type: 'string'},
        {name: 'WKORD_NUM'          ,text: '<t:message code="system.label.product.workorderno2" default="작지번호"/>'      ,type: 'string'},
        {name: 'PO_NUM'             ,text: '<t:message code="system.label.product.pono" default="PO번호"/>'      ,type: 'string'},
        {name: 'ORDER_PRSN'         ,text: '<t:message code="system.label.product.saleschargecode" default="영업담당코드"/>'      ,type: 'string'},
        {name: 'ORDERPRSN_NAME'     ,text: '<t:message code="system.label.product.salescharge" default="영업담당"/>'      ,type: 'string'},
        {name: 'CUSTOM_CODE'        ,text: '<t:message code="system.label.product.custom" default="거래처"/>'      ,type: 'string'},
        {name: 'CUSTOM_NAME'        ,text: '<t:message code="system.label.product.customname" default="거래처명"/>'      ,type: 'string'},
        {name: 'ITEM_CODE'          ,text: '<t:message code="system.label.product.item" default="품목"/>'      ,type: 'string'},
        {name: 'ITEM_NAME'          ,text: '<t:message code="system.label.product.itemname" default="품목명"/>'      ,type: 'string'},
        {name: 'SPEC'               ,text: '<t:message code="system.label.product.spec" default="규격"/>'      ,type: 'string'},
        
        {name: 'STOCK_UNIT'         ,text: '<t:message code="system.label.product.inventoryunit" default="재고단위"/>'      ,type: 'string'},
        {name: 'WORK_SHOP_CODE'     ,text: '<t:message code="system.label.product.mainwarehouse" default="주창고"/>'      ,type: 'string'},
        
        {name: 'ORDER_DATE'         ,text: '<t:message code="system.label.product.sodate" default="수주일"/>'      ,type: 'string'},
        {name: 'DVRY_DATE'          ,text: '<t:message code="system.label.product.deliverydate" default="납기일"/>'      ,type: 'string'},
        
        {name: 'ORDER_Q'            ,text: '<t:message code="system.label.product.soqty" default="수주량"/>'      ,type : 'float', decimalPrecision:2, format:'0,000.00'},
        {name: 'NOT_ISSUE_Q'        ,text: '<t:message code="system.label.product.undeliveryqty" default="미납량"/>'       ,type : 'float', decimalPrecision:2, format:'0,000.00'},
        {name: 'GOOD_STOCK_Q'       ,text: '<t:message code="system.label.product.goodstock" default="양품재고"/>'       ,type : 'float', decimalPrecision:2, format:'0,000.00'},
        {name: 'WKORD_Q'            ,text: '작업지시수량(입고예정)'       ,type : 'float', decimalPrecision:2, format:'0,000.00'},
        {name: 'SAFE_STOCK_Q'       ,text: '<t:message code="system.label.product.safetystock" default="안전재고"/>'       ,type : 'float', decimalPrecision:2, format:'0,000.00'},
        {name: 'WK_PLAN_Q'          ,text: '생산계획수량 ①'       ,type : 'float', decimalPrecision:2, format:'0,000.00'},
        {name: 'ADD_Q'              ,text: '추가수량 ②'       ,type : 'float', decimalPrecision:2, format:'0,000.00'},
//        {name: 'EQUIP_TON'          ,text: '설비TON'      ,type: 'string'},
//        {name: 'CYCLE_TIME'         ,text: '재질별Cycle Time'      ,type: 'string'},
//        {name: 'CAVITY'             ,text: 'Cavity'      ,type: 'string'},
        {name: 'WORK_TIME'          ,text: '<t:message code="system.label.product.workhour" default="작업시간"/>'      ,type: 'string'},
////        {name: 'DAY_PRODT_Q'        ,text: '일생산량'       ,type : 'float', decimalPrecision:2, format:'0,000.00'},
        {name: 'TOT_WK_PLAN_Q'      ,text: '총계획량(①+②=③)'       ,type : 'float', decimalPrecision:2, format:'0,000.00'},
        {name: 'TOT_PRODT_Q'        ,text: '<t:message code="system.label.product.totalproductionqty" default="총생산량"/>'       ,type : 'float', decimalPrecision:2, format:'0,000.00'},
////        {name: 'WK_ISSUE_Q'         ,text: '기존작지 발행매수'       ,type : 'float', decimalPrecision:2, format:'0,000.00'},
////        {name: 'ADD_WK_ISSUE_Q'     ,text: '현재작지 발행매수'      ,type : 'float', decimalPrecision:2, format:'0,000.00'},
//        {name: 'MOLD_LOC'           ,text: '금형위치'      ,type: 'string'},
        {name: 'ORDER_P'            ,text: '<t:message code="system.label.product.price" default="단가"/>'      ,type: 'string'},
        {name: 'NOT_ISSUE_O'        ,text: '<t:message code="system.label.product.unissuedamount" default="미납액"/>'       ,type : 'float', decimalPrecision:2, format:'0,000.00'},
        {name: 'LAST_PROG_WORK_CODE' ,text: '<t:message code="system.label.product.lastrouting" default="최종공정"/>'      ,type: 'string'},
        {name: 'LAST_PROG_WORK_NAME' ,text: '<t:message code="system.label.product.lastroutingname" default="최종공정명"/>'      ,type: 'string'},
        {name: 'DETAIL_REMARK'      ,text: '<t:message code="system.label.product.remarks" default="비고"/>'      ,type: 'string'},
        {name: 'REMARK'             ,text: '헤더비고'      ,type: 'string'}
        
        
        
        
        
        
           /* {name: 'COMP_CODE'        ,text: '<t:message code="system.label.product.compcode" default="법인코드"/>'      ,type: 'string',allowBlank:false},
            {name: 'CNLN_DATE'        ,text: '상담일'        ,type: 'uniDate',allowBlank:false},
            {name: 'CNLN_SEQ'         ,text: '상담차수'      ,type: 'int'},
            {name: 'CNLN_GRP'        ,text: '상담군'        ,type: 'string' ,comboType: 'AU' ,comboCode: 'H199',allowBlank:false},
            {name: 'DEPT_CODE'        ,text: '부서코드'      ,type: 'string',allowBlank:false},
            {name: 'DEPT_NAME'        ,text: '부서'         ,type: 'string'},
            {name: 'PERSON_NUMB'     ,text: '상담자사번'         ,type: 'string',allowBlank:false},
            {name: 'PERSON_NUMB1'     ,text: '사번'         ,type: 'string',allowBlank:false},
            {name: 'NAME'             ,text: '성명'         ,type: 'string'},
            {name: 'ABIL_CODE'        ,text: '직급'         ,type: 'string' ,comboType: 'AU' ,comboCode: 'H006'},
            {name: 'ABIL_NAME'        ,text: '직급명'         ,type: 'string'},
            {name: 'CPLT_YN'          ,text: '<t:message code="system.label.product.processstatus" default="진행상태"/>'      ,type: 'string',store: Ext.data.StoreManager.lookup('statusComboStore')},
            {name: 'BTN_COLUMN'       ,text: '상담'         ,type: 'string'},
            
            {name: 'POST_CODE'         ,text: '직위'              ,type: 'string' ,comboType: 'AU' ,comboCode: 'H005'},
            {name: 'POST_NAME'         ,text: '직위명'             ,type: 'string' },
            {name: 'CNLN_TTL'          ,text: '제목'              ,type: 'string'},
            {name: 'CNLN_CNTS01'       ,text: '상담내용01'         ,type: 'string'},
            {name: 'CNLN_RSLT01'       ,text: '상담결과01'         ,type: 'string'},
            {name: 'CNLN_CNTS02'       ,text: '상담내용02'         ,type: 'string'},
            {name: 'CNLN_RSLT02'       ,text: '상담결과02'         ,type: 'string'},
            {name: 'CNLN_CNTS03'       ,text: '상담내용03'         ,type: 'string'},
            {name: 'CNLN_RSLT03'       ,text: '상담결과03'         ,type: 'string'},
            {name: 'CNLN_CNTS04'       ,text: '상담내용04'         ,type: 'string'},
            {name: 'CNLN_RSLT04'       ,text: '상담결과04'         ,type: 'string'},
            {name: 'CNLN_CNTS05'       ,text: '상담내용05'         ,type: 'string'},
            {name: 'CNLN_RSLT05'       ,text: '상담결과05'         ,type: 'string'}*/
        ]
    });
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var detailStore = Unilite.createStore('ppl101ukrvStore', {
        model: 'ppl101ukrvModel',
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결 
            editable: true,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            allDeletable:false,
            useNavi : false         // prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        saveStore : function(config)    {
            var inValidRecs = this.getInvalidRecords();
            var paramMaster= panelSearch.getValues();   //syncAll 수정
            
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
                detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
            	
            	panelResult.down('#pickBtn').setHidden(false);
                panelResult.down('#releaseBtn').setHidden(true);
            },
            add: function(store, records, index, eOpts) {
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {
            },
            remove: function(store, record, index, isMove, eOpts) {
            }
        },
        loadStoreRecords: function() {
            var param = Ext.getCmp('panelSearch').getValues();
            console.log( param );
            this.load({
                params: param
            });
        }
    }); 
	
	var panelSearch = Unilite.createSearchPanel('panelSearch', {       
        title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
            collapse: function () {
                panelResult.show();
            },
            expand: function() {
                panelResult.hide();
            }
        },
        items: [{   
            title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>',  
            itemId: 'search_panel1',
            layout: {type: 'uniTable', columns: 1},
            defaultType: 'uniTextfield',
            items: [{
                fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
                name:'DIV_CODE',
                xtype: 'uniCombobox', 
                comboType:'BOR120',
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('DIV_CODE', newValue);
                    }
                }
            },{
                fieldLabel: '<t:message code="system.label.product.sodate" default="수주일"/>',
                xtype: 'uniDateRangefield',
                startFieldName: 'TARGET_FR_DATE',
                endFieldName: 'TARGET_TO_DATE',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                width: 315,
                allowBlank:false,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('TARGET_FR_DATE',newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('TARGET_TO_DATE',newValue);
                    }
                }
            },
            Unilite.popup('DIV_PUMOK',{
                fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
                validateBlank:false,
                valueFieldName:'ITEM_CODE',
                textFieldName:'ITEM_NAME', 
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('ITEM_CODE', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('ITEM_NAME', newValue);                
                    }
                }
            }),
            {
                xtype: 'uniCheckboxgroup',  
                fieldLabel: '<t:message code="system.label.product.detailshide" default="내역숨기기"/>',
                items: [{
//                    boxLabel: '<t:message code="system.label.product.detailshide" default="내역숨기기"/>',
                    width: 100,
                    name: 'HIDE_OPT',
                    inputValue: 'Y',
                    uncheckedValue: 'N',
//                    checked: true,
                    
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                        	
                            panelResult.setValue('HIDE_OPT', newValue);
                            
                            if(!panelSearch.getInvalidMessage()) return;    //필수체크
                            detailStore.loadStoreRecords();
                        }
                    }
                }]
            }]              
        },{
           
            title: '<t:message code="system.label.product.additionalinfo" default="추가정보"/>',  
            itemId: 'search_panel2',
            layout: {type: 'uniTable', columns: 1},
            defaultType: 'uniTextfield',
            items: [{
                fieldLabel: '<t:message code="system.label.product.salescharge" default="영업담당"/>',
                name:'ORDER_PRSN',
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'S010'
            },{
                fieldLabel: '<t:message code="system.label.product.deliverydate" default="납기일"/>',
                xtype: 'uniDateRangefield',
                startFieldName: 'FR_OT_DATE',
                endFieldName: 'TO_OT_DATE',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                width: 315
            },
            Unilite.popup('CUST',{
                fieldLabel: '<t:message code="system.label.product.custom" default="거래처"/>',
                validateBlank:false,
                valueFieldName:'CUSTOM_CODE',
                textFieldName:'CUSTOM_NAME'
            }),
            {
                fieldLabel: '<t:message code="system.label.product.productionrequestdate" default="생산요청일"/>',
                xtype: 'uniDateRangefield',
                startFieldName: 'FR_HE_DATE',
                endFieldName: 'TO_HE_DATE',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                width: 315
            },{
                fieldLabel: '<t:message code="system.label.product.approveyesno" default="승인여부"/>',
                name:'ORDER_YN',
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'M007'
            },{
            	fieldLabel:'<t:message code="system.label.product.pono" default="PO번호"/>',
            	name:'PO_NO',
                xtype: 'uniTextfield'
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 3},
                width:600,
                items :[{
                    fieldLabel:'<t:message code="system.label.product.sono" default="수주번호"/>', 
                    xtype: 'uniTextfield',
                    name: 'FR_ORDER_NO', 
                    width:195
                },{
                    xtype:'component', 
                    html:'~',
                    style: {
                        marginTop: '3px !important',
                        font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
                    }
                },{
                    fieldLabel:'', 
                    xtype: 'uniTextfield',
                    name: 'TO_ORDER_NO', 
                    width:110
                }]
            },{
                fieldLabel: '대상일',
                xtype: 'uniDateRangefield',
                startFieldName: 'FR_DATE',
                endFieldName: 'TO_DATE',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                width: 315
            },{                
                xtype: 'radiogroup',                            
                fieldLabel: '<t:message code="system.label.product.goodstockqty" default="양품재고량"/>',
                items: [{
                    boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
                    width:80 ,
                    name: 'RDO_SELECT1', 
                    inputValue: '1',
                    checked: true
                },{
                    boxLabel: '0초과', 
                    width:80 ,
                    name: 'RDO_SELECT1' , 
                    inputValue: '2'
                },{
                    boxLabel: '미납량이상', 
                    width:80 ,
                    name: 'RDO_SELECT1' , 
                    inputValue: '3'
                }]            
            }
            ]              
        
        }]
        
 /*       ,
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
                            var labelText = invalid.items[0]['fieldLabel']+' : ';
                        } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                            var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
                        }
    
                        alert(labelText+Msg.sMB083);
                        invalid.items[0].focus();
                    } else {}
                } else {
                    this.unmask();
                }
                return r;
            }*/
    }); //end panelSearch  
    
    var panelResult = Unilite.createSearchForm('panelResult',{
        hidden: !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 2,
            tableAttrs: {width: '100%'},
            tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/width: '100%'}
        },
        padding:'1 1 1 1',
        border:true,
        items: [{
            xtype: 'container',
            layout : {type : 'uniTable'},
            tdAttrs: {width: 1000},    
            items:[{
                fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
                name:'DIV_CODE',
                xtype: 'uniCombobox', 
                comboType:'BOR120',
                allowBlank:false,
                width:250,
                listeners: {
                    change: function(combo, newValue, oldValue, eOpts) {
                        panelSearch.setValue('DIV_CODE', newValue);
                    }
                }
            },{
                fieldLabel: '<t:message code="system.label.product.sodate" default="수주일"/>',
                xtype: 'uniDateRangefield',
                startFieldName: 'TARGET_FR_DATE',
                endFieldName: 'TARGET_TO_DATE',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                width: 315,
                allowBlank:false,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelSearch.setValue('TARGET_FR_DATE',newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelSearch.setValue('TARGET_TO_DATE',newValue);
                    }
                }
            },Unilite.popup('DIV_PUMOK',{
                fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
                validateBlank:false,
                valueFieldName:'ITEM_CODE',
                textFieldName:'ITEM_NAME', 
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelSearch.setValue('ITEM_CODE', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelSearch.setValue('ITEM_NAME', newValue);                
                    }
                }
            })]
            },{
            xtype: 'container',
            layout : {type : 'hbox'},
//            layout : {type : 'uniTable',columns:3},
            tdAttrs: {align : 'right',width: 400},    
            width: 400,
            items:[{
                
                xtype: 'uniCheckboxgroup',  
                fieldLabel: '',
                items: [{
                    boxLabel: '<t:message code="system.label.product.detailshide" default="내역숨기기"/>',
                    width: 100,
                    name: 'HIDE_OPT',
                    inputValue: 'Y',
                    uncheckedValue: 'N',
//                    checked: true,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelSearch.setValue('HIDE_OPT', newValue);
                            
                            if(!panelSearch.getInvalidMessage()) return;    //필수체크
                            detailStore.loadStoreRecords();
                        }
                    }
                }]
            },{
                xtype: 'button',
                itemId : 'pickBtn',
                text:'<t:message code="system.label.product.selectall" default="전체선택"/>',
                tdAttrs: {align : 'left', width: 115},
                width:110,
                handler: function() {
                	var records = detailStore.data.items;
                	
                	var idx = 0;
                	var cnt = detailStore.getCount();
                	
                	if(cnt > 0){
                        Ext.getBody().mask('<t:message code="system.label.product.working" default="작업 중..."/>','loading-indicator');
                        
                    	Ext.each(records, function(record, index){
                    		idx = idx + 1;
                    		if(record.get('SORT_ORDER_2') == '9'){
                    	       record.set('SELECT',true);
                    		}
                    		
                    	});
                    	if(idx == cnt){
                            Ext.getBody().unmask();
                    	}
                    	
                    	
                	
                	
                        panelResult.down('#pickBtn').setHidden(true);
                        panelResult.down('#releaseBtn').setHidden(false);
                	}
                }
             },{
                xtype: 'button',
                itemId : 'releaseBtn',
                text:'전체해제',
                tdAttrs: {align : 'left', width: 115},
                width:110,
                hidden:true,
                handler: function() {
                    var records = detailStore.data.items;
                    
                    var idx = 0;
                    var cnt = detailStore.getCount();
                    if(cnt > 0){
                        Ext.getBody().mask('<t:message code="system.label.product.working" default="작업 중..."/>','loading-indicator');
                        
                        Ext.each(records, function(record, index){
                            idx = idx + 1;
                            if(record.get('SORT_ORDER_2') == '9'){
                               record.set('SELECT',false);
                            }
                            
                        });
                        if(idx == cnt){
                            Ext.getBody().unmask();
                        }
                        
                        
                        
                        panelResult.down('#pickBtn').setHidden(false);
                        panelResult.down('#releaseBtn').setHidden(true);
                    }
                }
             },{
                xtype: 'button',
                itemId : 'refBtn2',
                text:'<t:message code="system.label.product.wholeworkorder" default="일괄작지"/>',
                tdAttrs: {align : 'left', width: 115},
                width:110,
                handler: function() {
                	
                	var records = detailStore.data.items;
                	var cnt = 0;
                	
                	var workShopCode = '';
                	var itemCode = '';
                	var itemName = '';
                	var spec = '';
                	var wkordQ = 0; 
                	var stockUnit = '';
                	
                	Ext.each(records, function(record, index){
                        
                        if(record.get('SELECT') == true){
                           cnt = cnt + 1;
                        }
                        
                        
                        
                    });
                    
                    if(cnt < 1){
                        alert('일괄작지할 품목을 선택하여 주십시오.');	
                    	
                    }else if(cnt > 1){
                    	alert('품목을 하나만 선택하여 주십시오.');
                    }else if(cnt == 1){
                    	
                    	Ext.each(records, function(record, index){
                            if(record.get('SELECT') == true){
                                
                            	workShopCode = record.get('WORK_SHOP_CODE');
                            	itemCode = record.get('ITEM_CODE');
                            	itemName = record.get('ITEM_NAME');
                            	spec = record.get('SPEC');
                            	wkordQ = record.get('WKORD_Q');
                            	stockUnit = record.get('STOCK_UNIT');
                            }
                        });
                    
                    
                        var params = {
                            action:'select', 
                            'PGM_ID' : 'ppl101ukrv',
                            'WORK_SHOP_CODE' : workShopCode,
                            'ITEM_CODE' : itemCode,
                            'ITEM_NAME' : itemName,
                            'SPEC' : spec,
                            'WKORD_Q' : wkordQ,
                            'STOCK_UNIT' : stockUnit
    //                        'CONF_RECE_NO'   : record.data['CONF_RECE_NO'],
    //                        'RECE_COMP_CODE' : record.data['RECE_COMP_CODE'],
    //                        'RECE_COMP_NAME' : record.data['RECE_COMP_NAME'],
    //                        'CONF_RECE_DATE' : record.data['CONF_RECE_DATE'],
    //                        'RECE_AMT'       : record.data['TOT_RECEIVE_AMT'],
    //                        'RECE_GUBUN'     : record.data['RECE_GUBUN'],
    //                        'CUSTOM_CODE'    : record.data['CUSTOM_CODE'],
    //                        'CUSTOM_NAME'    : record.data['CUSTOM_NAME']
                        }
                        var rec1 = {data : {prgID : 'pmp100ukrv', 'text':''}};                           
                        parent.openTab(rec1, '/prodt/pmp100ukrv.do', params);
                    	
                	}
                	/*
                    if(!panelResult.getInvalidMessage()){
                        return false;
                    }
                    if(confirm('평가대상자생성시 기존데이터는 삭제됩니다. \n생성 하시겠습니까?')) {
                        Ext.getBody().mask('<t:message code="system.label.product.working" default="작업 중..."/>','loading-indicator');
                            
                        var param= panelResult.getValues();
                            
                        hep930ukrService.personCreate(param, function(provider, response)  {
                            if(!Ext.isEmpty(provider)){
                                if(provider == 'PN'){
                                    alert('평가대상자 인원수가 맞지 않습니다.');
                                }else if(provider == 'Y'){
                                    alert('평가대상자 생성을 성공 하였습니다.');
                                    
                                    detailStore.loadStoreRecords();
                                }else{
                                    alert('평가대상자 생성을 실패 하였습니다.');
                                }
                                Ext.getBody().unmask();
                            }
                        });
                    }
                */
                
                
                }
             }]
         
            
        }]
  /*      
        ,
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
                            var labelText = invalid.items[0]['fieldLabel']+' : ';
                        } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                            var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
                        }
    
                        alert(labelText+Msg.sMB083);
                        invalid.items[0].focus();
                    } else {}
                } else {
                    this.unmask();
                }
                return r;
            }*/
    }); //end panelSearch 
    
	var detailGrid = Unilite.createGrid('detailGrid', {
        layout: 'fit',
        region: 'center',
        excelTitle: '<t:message code="system.label.product.productionplanentry" default="생산계획등록"/>',
        uniOpt: {
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: false,
            useMultipleSorting: true,
            onLoadSelectFirst: false,
            useRowNumberer: true,
            expandLastColumn: true,
            useRowContext: false,
            state: {
                useState: true,         
                useStateList: true      
            }
        },
        features: [{
            id: 'detailGridSubTotal', 
            ftype: 'uniGroupingsummary', 
            showSummaryRow: false
        },{
            id: 'detailGridTotal', 
            ftype: 'uniSummary', 
            showSummaryRow: false,
            dock:'bottom'
        }],
        store: detailStore,
        selModel:'rowmodel',
        columns: [
        
            
            
            {dataIndex: 'SELECT'                , width: 40, xtype: 'checkcolumn',align:'center',
                listeners: {    
                    checkchange: function( CheckColumn, rowIndex, checked, eOpts ){

                    },
                    beforecheckchange: function( CheckColumn, rowIndex, checked, eOpts ){
                        
                        if(eOpts.get('SORT_ORDER_2') != '9'){
                           return false;    
                        }
                        
                    }
                }
            },
            { dataIndex: 'KEY_VALUE'                        ,width:100,hidden:true},
            { dataIndex: 'COMP_CODE'                        ,width:100,hidden:true},
            { dataIndex: 'DIV_CODE'                         ,width:100,hidden:true},
            { dataIndex: 'SORT_ORDER_1'                     ,width:100,hidden:true},
            { dataIndex: 'SORT_ORDER_2'                     ,width:100,hidden:true},
            { dataIndex: 'SORT_ORDER_2_NAME'                ,width:100},
            { dataIndex: 'ORDER_NUM'                        ,width:140},
            { dataIndex: 'SER_NO'                           ,width:70},
            { dataIndex: 'WKORD_NUM'                        ,width:140},
            { dataIndex: 'PO_NUM'                           ,width:140},
            { dataIndex: 'ORDER_PRSN'                       ,width:100,hidden:true},
            { dataIndex: 'ORDERPRSN_NAME'                   ,width:100,align:'center'},
            { dataIndex: 'CUSTOM_CODE'                      ,width:100},
            { dataIndex: 'CUSTOM_NAME'                      ,width:200},
            { dataIndex: 'ITEM_CODE'                        ,width:160},
            { dataIndex: 'ITEM_NAME'                        ,width:400},
            { dataIndex: 'SPEC'                             ,width:200},
            
            
            { dataIndex: 'STOCK_UNIT'                       ,width:400,hidden:false},
            { dataIndex: 'WORK_SHOP_CODE'                   ,width:200,hidden:false},

            { dataIndex: 'ORDER_DATE'                       ,width:120},
            { dataIndex: 'DVRY_DATE'                        ,width:120},
            { dataIndex: 'ORDER_Q'                          ,width:100},
            { dataIndex: 'NOT_ISSUE_Q'                      ,width:100},
            { dataIndex: 'GOOD_STOCK_Q'                     ,width:100},
            { dataIndex: 'WKORD_Q'                          ,width:180},
            { dataIndex: 'SAFE_STOCK_Q'                     ,width:100},
            { dataIndex: 'WK_PLAN_Q'                        ,width:130},
            { dataIndex: 'ADD_Q'                            ,width:100},
//            { dataIndex: 'EQUIP_TON'                        ,width:100},
//            { dataIndex: 'CYCLE_TIME'                       ,width:100},
//            { dataIndex: 'CAVITY'                           ,width:100},
            { dataIndex: 'WORK_TIME'                        ,width:100},
////            { dataIndex: 'DAY_PRODT_Q'                      ,width:100},
            { dataIndex: 'TOT_WK_PLAN_Q'                    ,width:180},
            { dataIndex: 'TOT_PRODT_Q'                      ,width:180,hidden:true},
////            { dataIndex: 'WK_ISSUE_Q'                       ,width:180},
////            { dataIndex: 'ADD_WK_ISSUE_Q'                   ,width:180},
//            { dataIndex: 'MOLD_LOC'                         ,width:180},
            { dataIndex: 'ORDER_P'                          ,width:100},
            { dataIndex: 'NOT_ISSUE_O'                      ,width:100},
            { dataIndex: 'LAST_PROG_WORK_CODE'              ,width:100},
            { dataIndex: 'LAST_PROG_WORK_NAME'              ,width:150},
            { dataIndex: 'DETAIL_REMARK'                    ,width:250},
            { dataIndex: 'REMARK'                           ,width:450}
        
        ],
        viewConfig: {
            getRowClass: function(record, rowIndex, rowParams, store){
                var cls = '';
                if(record.get('SORT_ORDER_2') == '9'){
                    cls = 'x-change-cell_Background_essRow';  
                }
                return cls;
            }
        },
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
        		if(UniUtils.indexOf(e.field, ['ADD_Q'/*,'ADD_WK_ISSUE_Q'*/])){
        			if(e.record.data.SORT_ORDER_2 == '9'){
                        return true;
        			}else{
        				return false;
        			}
        		}else{
        			return false;
        		}
        	},
            beforeselect: function(rowSelection, record, index, eOpts) {
            	if(record.get('SORT_ORDER_2') != '9'){
                   return false;    
                }
            }
        }
    });   
	
    
    Unilite.Main( {
    	borderItems:[{
            region: 'center',
            layout: {type: 'vbox', align: 'stretch'},
            border: false,
            autoScroll: true,
            id:'pageAll',
            items: [
            	panelResult, detailGrid
            ]
        },panelSearch],
		id  : 'ppl101ukrvApp',
		fnInitBinding: function(){
            UniAppManager.app.fnInitInputFields();
			UniAppManager.setToolbarButtons(['save','print','newData'], false);
            UniAppManager.setToolbarButtons(['reset'], true);
		},
		onQueryButtonDown: function() {
			if(!panelSearch.getInvalidMessage()) return;   //필수체크
            detailStore.loadStoreRecords();
		},
		onSaveDataButtonDown: function() {
            detailStore.saveStore();
        },
		onResetButtonDown: function() {
            panelSearch.clearForm();
			detailGrid.reset();
			detailStore.clearData();
			UniAppManager.app.fnInitInputFields();
			UniAppManager.setToolbarButtons(['save','delete'], false);
			UniAppManager.setToolbarButtons(['reset'], true);
			
			
            panelResult.down('#pickBtn').setHidden(false);
            panelResult.down('#releaseBtn').setHidden(true);
		},
		fnInitInputFields: function(){
//			panelSearch.setValue('CNLN_YEAR',new Date().getFullYear());
			
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
			panelSearch.setValue('INOUT_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('INOUT_DATE_TO',UniDate.get('today'));
			
			panelResult.setValue('INOUT_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('INOUT_DATE_TO',UniDate.get('today'));
			  
            
            
		}
	});
	
	Unilite.createValidator('validator01', {
        store: detailStore,
        grid: detailGrid,
        validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
            var rv = true;
            var records = detailStore.data.items;
            switch(fieldName) {
                
                case "ADD_Q" : //추가수량 2
                    
                    record.set('TOT_WK_PLAN_Q', record.get('WK_PLAN_Q') + newValue);
                    
//                    var dWkPlanQ = record.get('WK_PLAN_Q');
//                    var dAddQ = newValue;
//                    var dDayProdtQ = record.get('DAY_PRODT_Q');
                    
                    
                /*    if(dDayProdtQ == 0 && (dWkPlanQ + dAddQ) > 0) {
                    	record.set('ADD_WK_ISSUE_Q', 1);
                    }else if(dDayProdtQ == 0){
                    	record.set('ADD_WK_ISSUE_Q', 0);
                    }else{
                    	if((dWkPlanQ + dAddQ) / dDayProdtQ <= 0 ){
                            record.set('ADD_WK_ISSUE_Q', 1);
                    	}else{
                    	   	record.set('ADD_WK_ISSUE_Q', ceil((dWkPlanQ + dAddQ), dDayProdtQ));
                    	}
                    }*/
                    
                    
                    
/*                    
                    function ceil(dWkPlanQ + dAddQ, dDayProdtQ)
                        Dim result1
                        Dim result2
                        Dim variant_return
                        
                         result1 = dWkPlanQ + dAddQ/dDayProdtQ
                         result2 = round(dWkPlanQ + dAddQ/dDayProdtQ)
                         if result1 <> result2 then
                          variant_return = fix(result1) + 1
                         else
                          variant_return = result1
                         end if
                        ceil = variant_return
                        end Function
                        */
                        
//                    If grdSheet1.TextMatrix(lRow, grdSheet1.ColIndex("TOT_WK_PLAN_Q")) > 0 Then
//                        grdSheet1.TextMatrix(lRow, grdSheet1.ColIndex("CHK")) = "1"
//                    Else
//                        grdSheet1.TextMatrix(lRow, grdSheet1.ColIndex("CHK")) = "0"
//                    End If

    
    
    
                break;
                /*
                case "ADD_WK_ISSUE_Q" : //현재작지 발행매수
                    
                break;*/
                
            }
            return rv;
        }
    });
    
    /*
    
    function ceil(Pnanum,nanum){
    	
        var result1 =0;
        var result2 =0;
        
        var rv = 0;
        
        result1 = dWkPlanQ + dAddQ/dDayProdtQ;
        result2 = round(Pnanum + nanum);
        if (result1 != result2) {
            rv = fix(result1) + 1;
        }else{
            rv = result1;
        }
    	return rv;
    }
     */
};

</script>
