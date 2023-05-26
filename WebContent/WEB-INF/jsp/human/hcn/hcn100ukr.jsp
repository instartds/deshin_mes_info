<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hcn100ukr"  >
    <t:ExtComboStore comboType="AU" comboCode="H199" /> <!-- 상담군 -->
    <t:ExtComboStore comboType="AU" comboCode="H005" /> <!-- 직위 -->
    <t:ExtComboStore comboType="AU" comboCode="H006" /> <!-- 직급 -->
    <t:ExtComboStore comboType="AU" comboCode="H200" /> <!-- 상담유형 -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	

<script type="text/javascript" >

var baseCodeH200 = Ext.data.StoreManager.lookup('CBS_AU_H200').data.items;
var baseNameH200_01 = '';
var baseNameH200_02 = '';
var baseNameH200_03 = '';
var baseNameH200_04 = '';
var baseNameH200_05 = '';
Ext.each(baseCodeH200, function(record,i) {
	if(record.get('value') == '01'){
		baseNameH200_01 = record.get('text');
	}else if(record.get('value') == '02'){
        baseNameH200_02 = record.get('text');
	}else if(record.get('value') == '03'){
        baseNameH200_03 = record.get('text');
    }else if(record.get('value') == '04'){
        baseNameH200_04 = record.get('text');
    }else if(record.get('value') == '05'){
        baseNameH200_05 = record.get('text');
    }
});
var consultingWindow; // 이력등록팝업

var checkCnlnGrp = '';

if('${checkCnlnGrp}' == '03'){//관리자
	checkCnlnGrp = '02';    
}else if('${checkCnlnGrp}' == '07'){//부서장
    checkCnlnGrp = '01';    
}

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'hcn100ukrService.selectList',
            update: 'hcn100ukrService.updateDetail',
            create: 'hcn100ukrService.insertDetail',
            destroy: 'hcn100ukrService.deleteDetail',
            syncAll: 'hcn100ukrService.saveAll'
        }
    });
	
    var statusStore = Unilite.createStore('statusComboStore', {  
        fields: ['text', 'value'],
        data :  [
            {'text':'미완료'  , 'value':'N'},
            {'text':'등록중'  , 'value':'I'},
            {'text':'완료'   , 'value':'Y'}
        ]
    });

	Unilite.defineModel('hcn100ukrModel', {
        fields: [
            {name: 'COMP_CODE'        ,text: '법인코드'      ,type: 'string',allowBlank:false},
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
            {name: 'CPLT_YN'          ,text: '진행상태'      ,type: 'string',store: Ext.data.StoreManager.lookup('statusComboStore')},
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
            {name: 'CNLN_RSLT05'       ,text: '상담결과05'         ,type: 'string'}
        ]
    });
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var detailStore = Unilite.createStore('hcn100ukrStore', {
        model: 'hcn100ukrModel',
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결 
            editable: true,            // 수정 모드 사용 
            deletable: true,           // 삭제 가능 여부 
            allDeletable:false,
            useNavi : false         // prev | newxt 버튼 사용
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
	
	var panelSearch = Unilite.createSearchForm('panelSearch',{
        region: 'north',
        layout : {type : 'uniTable', columns : 2},
        padding:'1 1 1 1',
        border:true,
        items: [{
            xtype: 'uniYearField',
            fieldLabel: '기준년도',
            name: 'CNLN_YEAR',
            readOnly:true,
            allowBlank:false
        },{
            xtype: 'uniCombobox',
            fieldLabel: '상담군',
            name: 'CNLN_GRP',
            comboType: 'AU',
            comboCode: 'H199',
            allowBlank: false,
            readOnly:true
        },
        Unilite.popup('DEPT', {
            fieldLabel: '부서',
            valueFieldName: 'DEPT_CODE',
            textFieldName: 'DEPT_NAME',
            listeners: {
                applyextparam: function(popup) {
                	if(checkCnlnGrp == '01'){
                        popup.setExtParam({'DEPT_CODE' : UserInfo.deptCode})
                	}
                }
            }
        }),
        Unilite.popup('Employee', {
            fieldLabel: '상담자', 
            valueFieldName: 'PERSON_NUMB',
            textFieldName: 'NAME',
            listeners: {
                applyextparam: function(popup) {
                    if(checkCnlnGrp == '01'){
                        popup.setExtParam({'DEPT_CODE_01' : Ext.isEmpty(panelSearch.getValue('DEPT_CODE')) ? UserInfo.deptCode : panelSearch.getValue('DEPT_CODE')})
                    }else if(checkCnlnGrp == '02'){
                        popup.setExtParam({'DEPT_CODE_01' : panelSearch.getValue('DEPT_CODE')})
                    }
                }
            }
        })
        ]
    });
	var detailGrid = Unilite.createGrid('hcn100ukrGrid', {
        layout: 'fit',
        region: 'center',
        excelTitle: '상담이력등록',
        height:300,
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
            { dataIndex: 'COMP_CODE'              ,width:100,hidden:true},
            { dataIndex: 'CNLN_DATE'              ,width:100},
            { dataIndex: 'CNLN_SEQ'               ,width:80,align:'center'},
            { dataIndex: 'CNLN_GRP'               ,width:80,hidden:true},
            { dataIndex: 'DEPT_CODE'                      ,width:100,
                editor: Unilite.popup('DEPT_G',{
                    autoPopup: true,
                    listeners:{
                        scope:this,
                        onSelected:function(records, type ) {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('DEPT_CODE',records[0]['TREE_CODE']);
                            grdRecord.set('DEPT_NAME',records[0]['TREE_NAME']);
                            
                            grdRecord.set('PERSON_NUMB1','');
                            grdRecord.set('NAME','');
                            
                            grdRecord.set('POST_CODE','');
                            grdRecord.set('POST_NAME','');
                            grdRecord.set('ABIL_CODE','');
                            grdRecord.set('ABIL_NAME','');
                            
                        },
                        onClear:function(type) {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('DEPT_CODE','');
                            grdRecord.set('DEPT_NAME','');
                            
                            grdRecord.set('PERSON_NUMB1','');
                            grdRecord.set('NAME','');
                            
                            grdRecord.set('POST_CODE','');
                            grdRecord.set('POST_NAME','');
                            grdRecord.set('ABIL_CODE','');
                            grdRecord.set('ABIL_NAME','');
                          
                        },
                        applyExtParam:{
                            scope:this,
                            fn:function(popup){
                                var param = {
                                    'DEPT_CODE' :checkCnlnGrp == '01' ? UserInfo.deptCode : ''
                                   
                                }
                                popup.setExtParam(param);
                            }
                        }
                    }
                })
            },
            { dataIndex: 'DEPT_NAME'                      ,width:200,
                editor: Unilite.popup('DEPT_G',{
                    autoPopup: true,
                    listeners:{
                        scope:this,
                        onSelected:function(records, type ) {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('DEPT_CODE',records[0]['TREE_CODE']);
                            grdRecord.set('DEPT_NAME',records[0]['TREE_NAME']);
                            
                            grdRecord.set('PERSON_NUMB1','');
                            grdRecord.set('NAME','');
                            
                            grdRecord.set('POST_CODE','');
                            grdRecord.set('POST_NAME','');
                            grdRecord.set('ABIL_CODE','');
                            grdRecord.set('ABIL_NAME','');
                            
                        },
                        onClear:function(type)  {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('DEPT_CODE','');
                            grdRecord.set('DEPT_NAME','');
                            
                            grdRecord.set('PERSON_NUMB1','');
                            grdRecord.set('NAME','');
                            
                            grdRecord.set('POST_CODE','');
                            grdRecord.set('POST_NAME','');
                            grdRecord.set('ABIL_CODE','');
                            grdRecord.set('ABIL_NAME','');
                          
                        },
                        applyExtParam:{
                            scope:this,
                            fn:function(popup){
                                var param = {
                                    'DEPT_CODE' :checkCnlnGrp == '01' ? UserInfo.deptCode : ''
                                   
                                }
                                popup.setExtParam(param);
                            }
                        }
                    }
                })
            },
            { dataIndex: 'PERSON_NUMB'           ,width:100,hidden:true},
            { dataIndex: 'PERSON_NUMB1'           ,width:100,
                editor: Unilite.popup('Employee_G',{
                    autoPopup: true,
                    listeners:{
                        scope:this,
                        onSelected:function(records, type ) {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('PERSON_NUMB1',records[0]['PERSON_NUMB']);
                            grdRecord.set('NAME',records[0]['NAME']);
                            
                            grdRecord.set('POST_CODE',records[0]['POST_CODE']);
                            grdRecord.set('POST_NAME',records[0]['POST_CODE_NAME']);
                            grdRecord.set('ABIL_CODE',records[0]['ABIL_CODE']);
                            grdRecord.set('ABIL_NAME',records[0]['ABIL_NAME']);
                            
                        },
                        onClear:function(type)  {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('PERSON_NUMB1','');
                            grdRecord.set('NAME','');
                          
                            grdRecord.set('POST_CODE','');
                            grdRecord.set('POST_NAME','');
                            grdRecord.set('ABIL_CODE','');
                            grdRecord.set('ABIL_NAME','');
                        },
                        applyExtParam:{
                            scope:this,
                            fn:function(popup){
                            	var grdRecord = detailGrid.uniOpt.currentRecord;
                                var param = {
                                    'DEPT_CODE' : '',
                                	'DEPT_CODE_01' : grdRecord.get('DEPT_CODE')
                                   
                                }
                                popup.setExtParam(param);
                            }
                        }
                    }
                })
            },
            { dataIndex: 'NAME'                      ,width:100,align:'center',
                editor: Unilite.popup('Employee_G',{
                    autoPopup: true,
                    listeners:{
                        scope:this,
                        onSelected:function(records, type ) {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('PERSON_NUMB1',records[0]['PERSON_NUMB']);
                            grdRecord.set('NAME',records[0]['NAME']);
                            
                            grdRecord.set('POST_CODE',records[0]['POST_CODE']);
                            grdRecord.set('POST_NAME',records[0]['POST_CODE_NAME']);
                            grdRecord.set('ABIL_CODE',records[0]['ABIL_CODE']);
                            grdRecord.set('ABIL_NAME',records[0]['ABIL_NAME']);
                            
                        },
                        onClear:function(type)  {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('PERSON_NUMB1','');
                            grdRecord.set('NAME','');
                          
                            grdRecord.set('POST_CODE','');
                            grdRecord.set('POST_NAME','');
                            grdRecord.set('ABIL_CODE','');
                            grdRecord.set('ABIL_NAME','');
                        },
                        applyExtParam:{
                            scope:this,
                            fn:function(popup){
                                var grdRecord = detailGrid.uniOpt.currentRecord;
                                var param = {
                                    'DEPT_CODE' : '',
                                	'DEPT_CODE_01' : grdRecord.get('DEPT_CODE')

                                }
                                popup.setExtParam(param);
                            }
                        }
                    }
                })
            },
            { dataIndex: 'ABIL_CODE'                      ,width:200,align:'center'},
            { dataIndex: 'ABIL_NAME'                      ,width:100,hidden:true},
            
            { dataIndex: 'CPLT_YN'                ,width:100, align:'center'},
            {
                text: '상담',
                width: 150,
                xtype: 'widgetcolumn',
                id:'wgcol',
                widget: {
                    xtype: 'button',
                    text: '등록하기',
                    handler: function(widgetColumn) {
                        var record = widgetColumn.getWidgetRecord();
                        var sm = detailGrid.getSelectionModel();
                        sm.select(record);
                        
                        var selectRecord = detailGrid.getSelectedRecord();
                           
                        if(Ext.isEmpty(selectRecord.get('CNLN_DATE'))){
                        	alert('상담일을 먼저 입력해주십시오.');
                            return false;
                        }else if(Ext.isEmpty(selectRecord.get('CNLN_GRP'))){
                        	alert('상담군을 먼저 입력해주십시오.');
                        	return false;
                        }else if(Ext.isEmpty(selectRecord.get('DEPT_CODE'))){
                        	alert('부서코드를 먼저 입력해주십시오.');
                        	return false;
                        }else if(Ext.isEmpty(selectRecord.get('PERSON_NUMB1'))){
                        	alert('사번을 먼저 입력해주십시오.');
                        	return false;
                        }
                        openconsultingWindow(record);
                    }
                }
            },
            { dataIndex: 'POST_CODE'                      ,width:100,hidden:true},
            { dataIndex: 'POST_NAME'                      ,width:100,hidden:true},
            
            { dataIndex: 'CNLN_TTL'                   ,width:100,hidden:true},
            { dataIndex: 'CNLN_CNTS01'                ,width:100,hidden:true},
            { dataIndex: 'CNLN_RSLT01'                ,width:100,hidden:true},
            { dataIndex: 'CNLN_CNTS02'                ,width:100,hidden:true},
            { dataIndex: 'CNLN_RSLT02'                ,width:100,hidden:true},
            { dataIndex: 'CNLN_CNTS03'                ,width:100,hidden:true},
            { dataIndex: 'CNLN_RSLT03'                ,width:100,hidden:true},
            { dataIndex: 'CNLN_CNTS04'                ,width:100,hidden:true},
            { dataIndex: 'CNLN_RSLT04'                ,width:100,hidden:true},
            { dataIndex: 'CNLN_CNTS05'                ,width:100,hidden:true},
            { dataIndex: 'CNLN_RSLT05'                ,width:100,hidden:true}
        ],
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
        		if(UniUtils.indexOf(e.field, ['DEPT_CODE','DEPT_NAME','PERSON_NUMB1','NAME'])){
                    if(e.record.phantom == true){
                    	if(UniUtils.indexOf(e.field, ['PERSON_NUMB1','NAME'])){
                    		if(Ext.isEmpty(e.record.data.DEPT_CODE)){
                    			alert('부서코드를 먼저 입력 해주십시오');
                    			return false;
                    		}else{
                                return true;
                    		}
                    	}else{
                    	   return true;
                    	}
                    }else{
                        return false;
                    }
        		}else{
        			return false;
        		}
        	}
        }
    });   
	
    var consultingForm = Unilite.createForm('consultingForm',{    
        padding:'0 0 0 0',
        disabled: false,
        bodyPadding: 10,
        region: 'center',
        flex:1,
        items: [{
            title:'',
            xtype: 'fieldset',
            padding: '5 5 5 5',
            layout: {type : 'uniTable', columns : 3,
                tableAttrs: { width: '100%'}
            },
            items: [{
                xtype: 'component',
                margin: '0 0 0 10',
                html: '이력등록',
                componentCls: 'component-text_title_first',
                tdAttrs: {align : 'left'}
            },{
                xtype: 'container',
                layout: {type: 'uniTable', columns: 2},
                tdAttrs: {align : 'right'},
                items: [{
                    xtype:'button',
                    itemId:'saveButton',
                    text:'저장',
                    width: 100,
                    tdAttrs: {align : 'right'},
                    handler: function() {
                    	
                    	if(Ext.isEmpty(consultingForm.getValue('CNLN_TTL'))){
                    		alert("제목을 입력해주십시오.");
                    		
                    	}else{
                    	
                            var selectRecord = detailGrid.getSelectedRecord();
                            selectRecord.set('CNLN_TTL'   ,consultingForm.getValue('CNLN_TTL'));
                            selectRecord.set('CNLN_CNTS01',consultingForm.getValue('CNLN_CNTS01'));
                            selectRecord.set('CNLN_RSLT01',consultingForm.getValue('CNLN_RSLT01'));
                            selectRecord.set('CNLN_CNTS02',consultingForm.getValue('CNLN_CNTS02'));
                            selectRecord.set('CNLN_RSLT02',consultingForm.getValue('CNLN_RSLT02'));
                            selectRecord.set('CNLN_CNTS03',consultingForm.getValue('CNLN_CNTS03'));
                            selectRecord.set('CNLN_RSLT03',consultingForm.getValue('CNLN_RSLT03'));
                            selectRecord.set('CNLN_CNTS04',consultingForm.getValue('CNLN_CNTS04'));
                            selectRecord.set('CNLN_RSLT04',consultingForm.getValue('CNLN_RSLT04'));
                            selectRecord.set('CNLN_CNTS05',consultingForm.getValue('CNLN_CNTS05'));
                            selectRecord.set('CNLN_RSLT05',consultingForm.getValue('CNLN_RSLT05'));
                            
                            selectRecord.set('CPLT_YN','I');
                            
                            consultingWindow.close();
                    	}
                    }
                },{
                    xtype: 'button', 
                    text: '닫기',
                    width: 100,
                    tdAttrs: {align : 'right'},
                    handler: function() {
                        consultingWindow.close();
                    }
                }]
            }]
        },{
            title:'',
            xtype: 'fieldset',
            padding: '5 5 10 5',
            layout: {type : 'uniTable', columns : 1,
                tableAttrs: { width: '100%'}
            },
            items: [{
                xtype: 'container',
                layout: {type: 'uniTable', columns: 2,
                    tableAttrs: { width: '100%'},
                    tdAttrs: {align : 'center'}
                },
                items: [{ 
                    xtype:'component',
                    itemId:'EmpImg',
                    width:140,                                  
                    autoEl: {
                        tag: 'img',
                        src: CPATH+'/resources/images/human/noPhoto.png',
                        cls:'photo-wrap'
                    }
                },{
                    xtype: 'container',
                    layout: {type: 'uniTable', columns: 6,
                    tableAttrs: {style: 'border : 0.1px solid #bdcfe6;'/*, width: '100%'*/},
                    tdAttrs: {style: 'border : 0.1px solid #bdcfe6; background-color: #e8edf5;',  align : 'center'}
                },
                items: [
                    { xtype: 'component',  html:'부서', width: 100},
                    { xtype: 'displayfield', name: 'DEPT_NAME', width: 150, tdAttrs: {style: 'background-color: #f4f4f5;'}},
                    
                    { xtype: 'component',  html:'직위', width: 100},
                    
                    { xtype: 'displayfield',name: 'POST_NAME', width: 150, tdAttrs: {style: 'background-color: #f4f4f5;'}},
                    { xtype: 'component',  html:'직급', width: 100},
                    { xtype: 'displayfield', name: 'ABIL_NAME', width: 150, tdAttrs: {style: 'background-color: #f4f4f5;'}},
                    { xtype: 'component',  html:'성명', width: 100},
                    { xtype: 'displayfield', name: 'NAME', width: 150, tdAttrs: {style: 'background-color: #f4f4f5;'}},
                    { xtype: 'component',  html:'상담일', width: 100},
                    { xtype: 'displayfield', name: 'CNLN_DATE', width: 150, tdAttrs: {style: 'background-color: #f4f4f5;'}},
                    { xtype: 'component',  html:'상담차수', width: 100},
                    { xtype: 'displayfield', name: 'CNLN_SEQ', width: 150, tdAttrs: {style: 'background-color: #f4f4f5;'}}
                ]
            }]
            },{
                xtype: 'container',
                layout: {type: 'uniTable', columns: 2,
                    tableAttrs: {style: 'border : 0.1px solid #bdcfe6;'/*, width: '100%'*/},
                    tdAttrs: {style: 'border : 0.1px solid #bdcfe6; background-color: #e8edf5;',  align : 'center'}
                },
                tdAttrs: {align : 'center'},
                colspan:2,
                padding:'0 0 10 0',
                items: [
                    { xtype: 'component',  html:'제목', width:200},
                    { xtype: 'uniTextfield', name: 'CNLN_TTL', width:702}
                ]
            },{
                xtype: 'container',
                layout: {type: 'uniTable', columns: 3,
                    tableAttrs: {style: 'border : 0.1px solid #bdcfe6;'/*, width: '100%'*/},
                    tdAttrs: {style: 'border : 0.1px solid #bdcfe6; background-color: #e8edf5;',  align : 'center'}
                },
                tdAttrs: {align : 'center'},
                colspan:2,
                items: [
                    { xtype: 'component',  html:'구분', width:200},
                    { xtype: 'component',  html:'내역', width:350},
                    { xtype: 'component',  html:'결과', width:350},
                    
                    {xtype: 'displayfield',name: '', width: 200, value:baseNameH200_01},
                    { xtype: 'textareafield', name: 'CNLN_CNTS01', width:350},
                    { xtype: 'textareafield', name: 'CNLN_RSLT01', width:350},
                    
                    {xtype: 'displayfield',name: '', width: 200, value:baseNameH200_02},
                    { xtype: 'textareafield', name: 'CNLN_CNTS02', width:350},
                    { xtype: 'textareafield', name: 'CNLN_RSLT02', width:350},
                    
                    {xtype: 'displayfield',name: '', width: 200, value:baseNameH200_03},
                    { xtype: 'textareafield', name: 'CNLN_CNTS03', width:350},
                    { xtype: 'textareafield', name: 'CNLN_RSLT03', width:350},
                    
                    {xtype: 'displayfield',name: '', width: 200, value:baseNameH200_04},
                    { xtype: 'textareafield', name: 'CNLN_CNTS04', width:350},
                    { xtype: 'textareafield', name: 'CNLN_RSLT04', width:350},
                    
                    {xtype: 'displayfield',name: '', width: 200, value:baseNameH200_05},
                    { xtype: 'textareafield', name: 'CNLN_CNTS05', width:350},
                    { xtype: 'textareafield', name: 'CNLN_RSLT05', width:350}
                ]
            }]
        }]
    });
    function openconsultingWindow(record) {            //설정
        if(!consultingWindow) {
            consultingWindow = Ext.create('widget.uniDetailWindow', {
                title: '이력등록',
                header: {
                    titleAlign: 'center'
                },
                width: 970,
                height: 800,
                minWidth:970,
                maxWidth:970,
                layout: {type:'vbox', align:'stretch'},                     
                items: [consultingForm],
                listeners : {
                    show: function( panel, eOpts )  {
                    	var selectRecord = detailGrid.getSelectedRecord();
                    	consultingForm.setValue('DEPT_NAME',selectRecord.get('DEPT_NAME'));
                        consultingForm.setValue('POST_NAME',selectRecord.get('POST_NAME'));
                        consultingForm.setValue('ABIL_NAME',selectRecord.get('ABIL_NAME'));
                        consultingForm.setValue('NAME',selectRecord.get('NAME'));
                        
                        consultingForm.setValue('CNLN_DATE',
                            UniDate.getDbDateStr(selectRecord.get('CNLN_DATE')).substring(0,4) + '.' +
                            UniDate.getDbDateStr(selectRecord.get('CNLN_DATE')).substring(4,6) + '.' +
                            UniDate.getDbDateStr(selectRecord.get('CNLN_DATE')).substring(6,8) 
                        );
                        
                        consultingForm.setValue('CNLN_SEQ',selectRecord.get('CNLN_SEQ'));
                        
                        consultingForm.setValue('CNLN_TTL'   ,selectRecord.get('CNLN_TTL'));
                        consultingForm.setValue('CNLN_CNTS01',selectRecord.get('CNLN_CNTS01'));
                        consultingForm.setValue('CNLN_RSLT01',selectRecord.get('CNLN_RSLT01'));
                        consultingForm.setValue('CNLN_CNTS02',selectRecord.get('CNLN_CNTS02'));
                        consultingForm.setValue('CNLN_RSLT02',selectRecord.get('CNLN_RSLT02'));
                        consultingForm.setValue('CNLN_CNTS03',selectRecord.get('CNLN_CNTS03'));
                        consultingForm.setValue('CNLN_RSLT03',selectRecord.get('CNLN_RSLT03'));
                        consultingForm.setValue('CNLN_CNTS04',selectRecord.get('CNLN_CNTS04'));
                        consultingForm.setValue('CNLN_RSLT04',selectRecord.get('CNLN_RSLT04'));
                        consultingForm.setValue('CNLN_CNTS05',selectRecord.get('CNLN_CNTS05'));
                        consultingForm.setValue('CNLN_RSLT05',selectRecord.get('CNLN_RSLT05'));
                        
                    	consultingForm.down('#EmpImg').getEl().dom.src=CPATH+'/uploads/employeePhoto/'+selectRecord.get('PERSON_NUMB1');/*data['PERSON_NUMB1']*///'S199705004';  /*+ '?_dc=' + data['dc'];*/  

                    },
                    beforehide: function(me, eOpt)  {
                    	consultingForm.down('#EmpImg').getEl().dom.src= '';
                    },
                    beforeclose: function( panel, eOpts )   {
                    }
                }       
            })
        }
        consultingWindow.center();
        consultingWindow.show();
    }
    
    Unilite.Main( {
    	borderItems:[{
            region: 'center',
            layout: {type: 'vbox', align: 'stretch'},
            border: false,
            autoScroll: true,
            id:'pageAll',
            items: [
            	panelSearch, detailGrid
            ]
        }],
		id  : 'hcn100ukrApp',
		fnInitBinding: function(){
            UniAppManager.app.fnInitInputFields();
			UniAppManager.setToolbarButtons(['save','print'], false);
            UniAppManager.setToolbarButtons(['reset','newData'], true);
		},
		onQueryButtonDown: function() {
			if(!panelSearch.getInvalidMessage()) return;   //필수체크
            detailStore.loadStoreRecords();
		},
		onNewDataButtonDown: function()	{
			if(!panelSearch.getInvalidMessage()) return;	//필수체크
		
			 var compCode = UserInfo.compCode;
             var personNumb = UserInfo.personNumb;
			 var cnlnDate = UniDate.get('today');
		     var cnlnGrp = panelSearch.getValue('CNLN_GRP');
		     var cpltYn = 'N'
		     
        	 var r = {
				COMP_CODE: compCode,
				PERSON_NUMB: personNumb,
				CNLN_DATE: cnlnDate,
				CNLN_GRP: cnlnGrp,
				CPLT_YN: cpltYn
	        };
			detailGrid.createRow(r);
		},
		onSaveDataButtonDown: function() {
            detailStore.saveStore();
        },
        onDeleteDataButtonDown: function() {
            var selRow = detailGrid.getSelectedRecord();
            if(!Ext.isEmpty(selRow)){
                if(selRow.phantom === true) {
                    detailGrid.deleteSelectedRow();
                }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')){
                    detailGrid.deleteSelectedRow();   
                }
            }
        },
		onResetButtonDown: function() {
            panelSearch.clearForm();
			detailGrid.reset();
			detailStore.clearData();
			UniAppManager.app.fnInitInputFields();
			UniAppManager.setToolbarButtons(['save','delete'], false);
			UniAppManager.setToolbarButtons(['reset'], true);
		},
		fnInitInputFields: function(){
			panelSearch.setValue('CNLN_YEAR',new Date().getFullYear());
            panelSearch.setValue('CNLN_GRP',checkCnlnGrp);
		}
	});
};

</script>
