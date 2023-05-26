<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="s_zdd300skrv_kd"  >
    <t:ExtComboStore comboType="BOR120" pgmId="s_bco100skrv_kd"/>   <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B004" />             <!-- 화폐단위-->
    <t:ExtComboStore comboType="AU" comboCode="WB14" />             <!-- 진행구분-->
    <t:ExtComboStore comboType="AU" comboCode="B024" />             <!-- 담당자-->
    <t:ExtComboStore comboType="AU" comboCode="B013" />             <!-- 재고단위  -->
    <t:ExtComboStore comboType="AU" comboCode="B015" />             <!-- 거래처구분    -->            
    <t:ExtComboStore comboType="AU" comboCode="B004" />             <!-- 기준화폐-->         
    <t:ExtComboStore comboType="AU" comboCode="B038" />             <!-- 결제방법-->           
    <t:ExtComboStore comboType="AU" comboCode="B034" />             <!-- 결제조건-->             
    <t:ExtComboStore comboType="AU" comboCode="B055" />             <!-- 거래처분류--> 
    <t:ExtComboStore comboType="AU" comboCode="A003" />             <!-- 구분  -->
    <t:ExtComboStore comboType="AU" comboCode="WB26" />             <!-- 단가구분  -->
    <t:ExtComboStore comboType="AU" comboCode="T005" />             <!-- 가격조건  -->
    <t:ExtComboStore comboType="AU" comboCode="WB01" />             <!-- 운송방법  -->
    <t:ExtComboStore comboType="AU" comboCode="WB03" />             <!-- 변동사유  -->
    <t:ExtComboStore comboType="AU" comboCode="WB04" />             <!-- 차종  -->
    <t:ExtComboStore comboType="AU" comboCode="WB18" />             <!-- 내수구분  -->
    <t:ExtComboStore comboType="AU" comboCode="WB22" />             <!-- 의뢰서구분  -->
</t:appConfig>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' >
<script type="text/javascript">
  var protocol =   ("https:" == document.location.protocol)  ? "https" : "http"  ;
  if(protocol == "https")   {
      document.write( unescape( "%3Cscript src='"+ protocol+ "://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E")  );
  }else {
    document.write( unescape( "%3Cscript src='"+ protocol+ "://dmaps.daum.net/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E") );
  }
</script>
<script type="text/javascript" >
function appMain() {
	
	Unilite.defineModel('s_zdd300skrv_kdModel', {                            
        fields: [
            {name: 'COMP_CODE'            ,text:'법인코드'             ,type: 'string'},
            {name: 'DIV_CODE'             ,text:'사업장'               ,type: 'string'},
            {name: 'REQ_NUM'              ,text:'의뢰번호'             ,type: 'string'},
            {name: 'REQ_DATE'             ,text:'의뢰일자'             ,type: 'uniDate'},
            {name: 'REQ_END_DATE'         ,text:'완료요청일'           ,type: 'uniDate'},
            {name: 'REQ_DEPT_CODE'        ,text:'의뢰부서코드'         ,type: 'string'},
            {name: 'REQ_DEPT_NAME'        ,text:'의뢰부서명'           ,type: 'string'},
            {name: 'REQ_PERSON'           ,text:'의뢰사원코드'         ,type: 'string'},
            {name: 'REQ_PERSON_NAME'      ,text:'의뢰사원명'           ,type: 'string'},
            {name: 'GASGET_REMARK'        ,text:'가스켓이력'           ,type: 'string'},
            {name: 'TEST_REMARK'          ,text:'시험목적'             ,type: 'string'},
            {name: 'CUSTOM_CODE'          ,text:'고객사코드'           ,type: 'string'},
            {name: 'CUSTOM_NAME'          ,text:'고객사명'             ,type: 'string'},
            {name: 'PJT_NAME'             ,text:'프로젝트명'           ,type: 'string'},
            {name: 'EXHAUST_Q'            ,text:'배기량'               ,type: 'string'},
            {name: 'PART_GUBUN'           ,text:'기관구분'             ,type: 'string'},
            {name: 'ORIGIN_SPEC'          ,text:'고유사양'             ,type: 'string'},
            {name: 'ETC_TXT'              ,text:'기타'                 ,type: 'string'},
            {name: 'DOC_NUM'              ,text:'도면번호'             ,type: 'string'},
            {name: 'CHG_TXT'              ,text:'설변사항'             ,type: 'string'},
            {name: 'HIS_TXT'              ,text:'상대물이력'           ,type: 'string'},
            {name: 'TEST_SPEC1'           ,text:'시험스펙(고객)'       ,type: 'string'},
            {name: 'TEST_SPEC2'           ,text:'시험스펙(KDG)'        ,type: 'string'},
            {name: 'ITEM_CODE'            ,text:'품목코드'             ,type: 'string'},
            {name: 'ITEM_NAME'            ,text:'품목명'               ,type: 'string'},
            {name: 'OEM_ITEM_CODE'        ,text:'품번'                 ,type: 'string'},
            {name: 'TEST_TXT1'            ,text:'시험내용1'            ,type: 'string'},
            {name: 'TEST_TXT2'            ,text:'시험내용2'            ,type: 'string'},
            {name: 'TEST_TXT3'            ,text:'시험내용3'            ,type: 'string'},
            {name: 'STATUS'               ,text:'진행상태'             ,type: 'string', comboType: 'AU', comboCode: 'WB14'}
        ]
    });
	
	var directMasterStore = Unilite.createStore('directMasterStore', {   // 검색 팝업창
            model: 's_zdd300skrv_kdModel',
            autoLoad: false,
            uniOpt : {
                isMaster: true,            // 상위 버튼 연결
                editable: false,            // 수정 모드 사용
                deletable:false,            // 삭제 가능 여부
                useNavi : false         // prev | newxt 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                    read: 's_zdd300skrv_kdService.selectList'
                }
            },
            loadStoreRecords: function() {
            var param = panelResult.getValues();
            this.load({
                params : param
            });
        }
    });
    
    var masterGrid = Unilite.createGrid('s_bco200ukrv_kdGrid1', {
        sortableColumns : false,  
        border:true,
        layout: 'fit',
        padding:'1 1 1 1',
        region: 'center',
        uniOpt : {              
            useMultipleSorting  : true,     
            useLiveSearch       : false,    
            onLoadSelectFirst   : true,        
            dblClickToEdit      : false,    
            useGroupSummary     : false, 
            useContextMenu      : false,    
            useRowNumberer      : false, 
            expandLastColumn    : false,     
            useRowContext       : false,    
            filter: {           
                useFilter       : false,    
                autoCreate      : true  
            }           
        },
        selModel:'rowmodel',
        store: directMasterStore,
        columns: [ 
            { dataIndex: 'COMP_CODE'                    ,  width: 100, hidden: true}, 
            { dataIndex: 'DIV_CODE'                     ,  width: 100, hidden: true}, 
            { dataIndex: 'REQ_NUM'                      ,  width: 100,isLink:true}, 
            { dataIndex: 'REQ_DATE'                     ,  width: 100}, 
            { dataIndex: 'REQ_END_DATE'                 ,  width: 100}, 
            { dataIndex: 'REQ_DEPT_CODE'                ,  width: 100}, 
            { dataIndex: 'REQ_DEPT_NAME'                ,  width: 200}, 
            { dataIndex: 'REQ_PERSON'                   ,  width: 100}, 
            { dataIndex: 'REQ_PERSON_NAME'              ,  width: 200}, 
            { dataIndex: 'GASGET_REMARK'                ,  width: 100, hidden: true}, 
            { dataIndex: 'TEST_REMARK'                  ,  width: 100, hidden: true}, 
            { dataIndex: 'CUSTOM_CODE'                  ,  width: 100}, 
            { dataIndex: 'CUSTOM_NAME'                  ,  width: 200}, 
            { dataIndex: 'ITEM_CODE'                    ,  width: 110},
            { dataIndex: 'ITEM_NAME'                    ,  width: 200},  
            { dataIndex: 'OEM_ITEM_CODE'                ,  width: 200},  
            { dataIndex: 'PJT_NAME'                     ,  width: 100}, 
            { dataIndex: 'EXHAUST_Q'                    ,  width: 100, hidden: true}, 
            { dataIndex: 'PART_GUBUN'                   ,  width: 100, hidden: true}, 
            { dataIndex: 'ORIGIN_SPEC'                  ,  width: 100, hidden: true}, 
            { dataIndex: 'ETC_TXT'                      ,  width: 100, hidden: true}, 
            { dataIndex: 'DOC_NUM'                      ,  width: 100, hidden: true}, 
            { dataIndex: 'CHG_TXT'                      ,  width: 100, hidden: true}, 
            { dataIndex: 'HIS_TXT'                      ,  width: 100, hidden: true}, 
            { dataIndex: 'TEST_SPEC1'                   ,  width: 100, hidden: true}, 
            { dataIndex: 'TEST_SPEC2'                   ,  width: 100, hidden: true},
            { dataIndex: 'TEST_TXT1'                    ,  width: 100, hidden: true}, 
            { dataIndex: 'TEST_TXT2'                    ,  width: 100, hidden: true}, 
            { dataIndex: 'TEST_TXT3'                    ,  width: 100, hidden: true}, 
            { dataIndex: 'STATUS'                       ,  width: 100, hidden: true}
        ],
        listeners: {
        	selectionchange:function( model1, selected, eOpts ) {
        		var record = selected[0];
                inputTable.loadForm(selected);                              
                var fp = inputTable.down('xuploadpanel');                  //mask on
                if(directMasterStore.getCount() > 0 && record && !record.phantom){
                    fp.loadData({});
                    fp.getEl().mask('로딩중...','loading-indicator');
                    var reqNum = record.data.REQ_NUM;
                    s_zdd300skrv_kdService.getFileList({REQ_NUM : reqNum},              //파일조회 메서드  호출(param - 파일번호) 
                        function(provider, response) {                          
                            fp.loadData(response.result);                       //업로드 파일 load해서 보여주기
                            fp.getEl().unmask();                                //mask off
                        }
                     );
                }
        		
//                var record = masterGrid.getSelectedRecord();
                var count = masterGrid.getStore().getCount();
                detailForm.loadForm(selected);
            },
            onGridDblClick:function(grid, record, cellIndex, colName) {
                if(!record.phantom) {
                    switch(colName) {
                    case 'REQ_NUM' :
                            masterGrid.hide();
                            break;      
                    default:
                            break;
                    }
                }
            },
            hide:function() {
                detailForm.show();
                inputTable.show();
            },
            show:function() { 
            	detailForm.hide();
                inputTable.hide();
            }
        }
    });
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {        
        layout: {type: 'uniTable', columns : 3},
        border:true,
        region: 'north',
        padding:'1 1 1 1',
        trackResetOnLoad: true,
        items: [
            {
                fieldLabel: '사업장',
                name: 'DIV_CODE',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                allowBlank:false
            },{
                fieldLabel: '의뢰일자',
                startFieldName: 'REQ_DATE_FR',
                endFieldName: 'REQ_DATE_TO',
                xtype: 'uniDateRangefield',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank:false
            },{
                fieldLabel: '의뢰번호',
                name: 'REQ_NUM',  
                xtype: 'uniTextfield'
            },
            Unilite.popup('DEPT', { 
                fieldLabel: '부서', 
                valueFieldName: 'REQ_DEPT_CODE',
                textFieldName: 'REQ_DEPT_NAME',
                autoPopup:true,
                listeners: {
                    applyextparam: function(popup){                         
                        var authoInfo = pgmInfo.authoUser;              //권한정보(N-전체,A-자기사업장>5-자기부서)
                        var deptCode = UserInfo.deptCode;   //부서정보
                        var divCode = '';                   //사업장
                        if(authoInfo == "A"){   //자기사업장 
                            popup.setExtParam({'TREE_CODE': ""});
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                        }else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){   //전체권한
                            popup.setExtParam({'TREE_CODE': ""});
                            popup.setExtParam({'DIV_CODE': detailForm.getValue('DIV_CODE')});
                        }else if(authoInfo == "5"){     //부서권한
                            popup.setExtParam({'TREE_CODE': UserInfo.deptCode});
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                        }
                    }
                }
            }), 
            Unilite.popup('Employee',{
                    fieldLabel: '담당자',
                    holdable: 'hold',
                    valueFieldName:'REQ_PERSON',
                    textFieldName:'REQ_PERSON_NAME',
                    validateBlank:false,
                    autoPopup:true,
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                var param= Ext.getCmp('panelResultForm').getValues();
                                s_zdd300skrv_kdService.selectPersonDept(param, function(provider, response)  {     
                                    if(!Ext.isEmpty(provider)){                                                
                                        detailForm.setValue('REQ_DEPT_CODE', provider[0].DEPT_CODE);  
                                        detailForm.setValue('REQ_DEPT_NAME', provider[0].DEPT_NAME);             
                                    }                                                                          
                                });    
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            detailForm.setValue('REQ_PERSON', '');
                            detailForm.setValue('REQ_PERSON_NAME', '');
                        },
                        applyextparam: function(popup){                         
                            popup.setExtParam({'DEPT_SEARCH': panelResult.getValue('REQ_DEPT_NAME')});
                        }
                    }
            }), 
            Unilite.popup('AGENT_CUST',{
                    fieldLabel: '고객사',
                    valueFieldName:'CUSTOM_CODE',
                    textFieldName:'CUSTOM_NAME',
                    validateBlank:false,
                    autoPopup:true
            }),
            Unilite.popup('DIV_PUMOK',{ 
                    fieldLabel: '품목코드',
                    valueFieldName: 'ITEM_CODE', 
                    textFieldName: 'ITEM_NAME', 
                    listeners: {
                        applyextparam: function(popup){                         
                            popup.setExtParam({'DIV_CODE': detailForm.getValue('DIV_CODE')});
                        }
                    }
            }),{
                fieldLabel: '품번',
                name:'OEM_ITEM_CODE',  
                xtype: 'uniTextfield'
            },{
                fieldLabel: '프로젝트명',
                name:'PJT_NAME',  
                xtype: 'uniTextfield'
            },{
                fieldLabel: '진행사항',
                name:'STATUS',  
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'WB14'
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
        padding: '1',
        region: 'center',
        items: [{
                xtype: 'xuploadpanel',
                height: 150,
                flex: 0,
                padding: '0 0 8 95',
                labelWidth: 100,
                width: 800,
                colspan: 2
            }],
            loadForm: function(record)  {
                var count = masterGrid.getStore().getCount();
                if(count > 0) {
                    this.reset();
                    this.setActiveRecord(record[0] || null);   
                    this.resetDirtyStatus();            
                }
            }
    });
	
	/**
     * Master Form
     * 
     * @type
     */     
    var detailForm = Unilite.createForm('s_zdd300skrv_kdDetail', {
        disabled :false,
        border:true,
        padding:'1 1 1 1',
        flex:1,
        layout: {type: 'uniTable', columns: 3, tdAttrs: {valign:'top'}},
        items :[
            {
                fieldLabel: '사업장',
                name: 'DIV_CODE',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                colspan: 3, 
                readOnly: true
            },{
                fieldLabel: '의뢰번호',
                name: 'REQ_NUM',  
                xtype: 'uniTextfield',
                colspan: 3, 
                readOnly: true,
                readOnly: true
            },
            Unilite.popup('DEPT', { 
                fieldLabel: '부서', 
                valueFieldName: 'REQ_DEPT_CODE',
                textFieldName: 'REQ_DEPT_NAME',
                autoPopup:true,
                readOnly: true,
                listeners: {
                    applyextparam: function(popup){                         
                        var authoInfo = pgmInfo.authoUser;              //권한정보(N-전체,A-자기사업장>5-자기부서)
                        var deptCode = UserInfo.deptCode;   //부서정보
                        var divCode = '';                   //사업장
                        if(authoInfo == "A"){   //자기사업장 
                            popup.setExtParam({'TREE_CODE': ""});
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                        }else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){   //전체권한
                            popup.setExtParam({'TREE_CODE': ""});
                            popup.setExtParam({'DIV_CODE': detailForm.getValue('DIV_CODE')});
                        }else if(authoInfo == "5"){     //부서권한
                            popup.setExtParam({'TREE_CODE': UserInfo.deptCode});
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                        }
                    }
                }
            }),{
                fieldLabel: '가스켓이력',
                xtype: 'textareafield',
                name: 'GASGET_REMARK',
                rowspan:4,
                height : 103,
                width: 500,
                readOnly: true
            },{
                fieldLabel: '시험목적',
                xtype: 'textareafield',
                labelWidth: 100,
                name: 'TEST_REMARK',
                rowspan:4,
                height : 103,
                width: 500,
                readOnly: true
            }, 
            Unilite.popup('Employee',{
                    fieldLabel: '담당자',
                    holdable: 'hold',
                    valueFieldName:'REQ_PERSON',
                    textFieldName:'REQ_PERSON_NAME',
                    colspan: 3,
                    validateBlank:false,
                    autoPopup:true,
                    readOnly: true,
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                var param= Ext.getCmp('s_zdd300skrv_kdDetail').getValues();
                                s_zdd300skrv_kdService.selectPersonDept(param, function(provider, response)  {     
                                    if(!Ext.isEmpty(provider)){                                                
                                        detailForm.setValue('REQ_DEPT_CODE', provider[0].DEPT_CODE);  
                                        detailForm.setValue('REQ_DEPT_NAME', provider[0].DEPT_NAME);             
                                    }                                                                          
                                });    
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            detailForm.setValue('REQ_PERSON', '');
                            detailForm.setValue('REQ_PERSON_NAME', '');
                        },
                        applyextparam: function(popup){                         
                            popup.setExtParam({'DEPT_SEARCH': detailForm.getValue('REQ_DEPT_NAME')});
                        }
                    }
            }),{
                fieldLabel: '의뢰일',
                name: 'REQ_DATE',
                xtype: 'uniDatefield',
                value: UniDate.get('today'),
                holdable: 'hold',
                colspan: 3, 
                readOnly: true
            },{
                fieldLabel: '완료요청일',
                name: 'REQ_END_DATE',
                xtype: 'uniDatefield',
                value: UniDate.get('today'),
                holdable: 'hold',
                colspan: 3, 
                readOnly: true
            },{
               xtype: 'component',
               colspan: 3
            },{
                xtype: 'component',
                colspan: 3,
                tdAttrs: {style: 'border-top: 1px solid #cccccc;  padding-top: 5px;' }
            }, 
            Unilite.popup('AGENT_CUST',{
                    fieldLabel: '고객사',
                    valueFieldName:'CUSTOM_CODE',
                    textFieldName:'CUSTOM_NAME',
                    colspan: 3,
                    validateBlank:false,
                    autoPopup:true,
                    readOnly: true
            }),{
                fieldLabel: '프로젝트명',
                name:'PJT_NAME',  
                xtype: 'uniTextfield',
                readOnly: true
            },{
                fieldLabel: '도면번호',
                xtype: 'textareafield',
                name: 'DOC_NUM',
                rowspan:6,
                height : 103,
                width: 500,
                readOnly: true,
                readOnly: true
            },{
                fieldLabel: '설변사항',
                labelWidth: 100,
                width: 500,
                name:'CHG_TXT',  
                xtype: 'uniTextfield',
                readOnly: true
            },{
                fieldLabel: '배기량',
                colspan: 2,
                xtype: 'uniNumberfield',
                name: 'EXHAUST_Q',
                readOnly: true
            },{
                fieldLabel: '상대물이력',
                labelWidth: 100,
                width: 500,
                name:'HIS_TXT',  
                xtype: 'uniTextfield',
                readOnly: true
            },{
                fieldLabel: '기관구분',
                name:'PART_GUBUN',  
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'',
                colspan: 2,
                readOnly: true
            },{
                fieldLabel: '시험스펙(고객사)',
                labelWidth: 100,
                width: 500,
                name:'TEST_SPEC1',  
                xtype: 'uniTextfield',
                readOnly: true
            },{
                fieldLabel: '고유사항',
                name:'ORIGIN_SPEC',  
                xtype: 'uniTextfield',
                colspan: 2,
                readOnly: true
            },{
                fieldLabel: '시험스펙(KDG)',
                labelWidth: 100,
                width: 500,
                name:'TEST_SPEC2',  
                xtype: 'uniTextfield',
                readOnly: true
            },{
                fieldLabel: '기타',
                width: 825,
                colspan: 3,
                name:'ETC_TXT',  
                xtype: 'uniTextfield',
                readOnly: true
            },{
                xtype: 'component',
                colspan: 3,
                tdAttrs: {style: 'border-top: 1px solid #cccccc;  padding-top: 5px;' }
            }, {
                xtype: 'container',
                layout : {type : 'uniTable'},
                colspan: 3,
                readOnly: true,
                items: [ 
                    Unilite.popup('DIV_PUMOK',{ 
                            fieldLabel: '품목코드',
                            valueFieldName: 'ITEM_CODE', 
                            textFieldName: 'ITEM_NAME',
                            readOnly: true, 
                            listeners: {
                            	onSelected: {
                                    fn: function(records, type) {
                                        detailForm.setValue('ITEM_CODE', records[0]['ITEM_CODE']); 
                                        detailForm.setValue('ITEM_NAME', records[0]['ITEM_NAME']);  
                                        detailForm.setValue('OEM_ITEM_CODE', records[0]['OEM_ITEM_CODE']);          
                                    },
                                    scope: this
                                },
                                onClear: function(type) {
                                    detailForm.setValue('ITEM_CODE', '');
                                    detailForm.setValue('ITEM_NAME', '');
                                    detailForm.setValue('OEM_ITEM_CODE', '');
                                },
                                applyextparam: function(popup){                         
                                    popup.setExtParam({'DIV_CODE': detailForm.getValue('DIV_CODE')});
                                }
                            }
                   }),{
                        fieldLabel: '시험내용1',
                        labelWidth: 70,
                        width: 347,
                        colspan: 2,
                        name:'TEST_TXT1',  
                        xtype: 'uniTextfield',
                        readOnly: true
                    }
                ]
            },{
                fieldLabel: '품번',
                name:'OEM_ITEM_CODE',  
                readOnly: true,
                readOnly: true,
                xtype: 'uniTextfield'
            },{
                fieldLabel: '시험내용2',
                width: 500,
                labelWidth: 223,
                colspan: 2,
                name:'TEST_TXT2',  
                xtype: 'uniTextfield',
                readOnly: true
            },{
                fieldLabel: '진행사항',
                name:'STATUS',  
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'WB14',
                readOnly: true
            },{
                fieldLabel: '시험내용3',
                width: 500,
                labelWidth: 223,
                name:'TEST_TXT3',  
                xtype: 'uniTextfield',
                readOnly: true
            }
        ],
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

    /**
     * main app
     */
    Unilite.Main( {
         borderItems:[
            {
                region:'center',
                layout: 'border',
                border: false,
                items:[{   region:'center',
                        title:'시험의뢰서',
                        layout : {type:'vbox', align:'stretch'},
                        flex:1,
                        autoScroll:true,
                        tools: [
                            {
                                type: 'hum-grid',                               
                                handler: function () {
                                    detailForm.hide();
                                    masterGrid.show();
                                }
                            },{
                    
                                type: 'hum-photo',                              
                                handler: function () {
                                    masterGrid.hide();
                                    detailForm.show();
                                }
                            }
                        ],
                        items:[  
                            {
                                region : 'north',
                                xtype : 'container',
                                highth: 20,
                                layout : 'fit',
                                items : [ inputTable ]
                            },                
                            masterGrid,
                            detailForm       
                        ]
                    },
                    panelResult
                ]
            }  
        ],  
         fnInitBinding : function() {
         	masterGrid.show();
            detailForm.hide();
            inputTable.hide();
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('REQ_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('REQ_DATE_TO', UniDate.get('today'));
            this.setToolbarButtons(['newData', 'delete', 'deleteAll', 'reset', 'save'],false);
        },
        onQueryButtonDown:function () {
        	if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
            directMasterStore.loadStoreRecords();
            this.setToolbarButtons(['reset'],true);
        },
        onResetButtonDown: function() {     // 초기화
            var fp = inputTable.down('xuploadpanel');
            fp.loadData({});  
            panelResult.clearForm();
            directMasterStore.clearData();
            masterGrid.reset();
            this.fnInitBinding();
        }         
    });
}
</script>
