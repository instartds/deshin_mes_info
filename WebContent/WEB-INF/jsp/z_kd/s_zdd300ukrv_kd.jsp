<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="s_zdd300ukrv_kd"  >
    <t:ExtComboStore comboType="BOR120" pgmId="s_bco100ukrv_kd"/>   <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B004" />             <!-- 화폐단위-->
    <t:ExtComboStore comboType="AU" comboCode="WB14" />             <!-- 진행구분-->
    <t:ExtComboStore comboType="AU" comboCode="WZ09" />             <!-- 기관구분-->
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
    var groupUrl = '${groupUrl}'; //그룹웨어 호출 url
	var SearchInfoWindow; // 검색창
	
	Unilite.defineModel('orderNoMasterModel', {                            // 검색조회창
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
            {name: 'TEST_TXT1'            ,text:'시험내용1'            ,type: 'string'},
            {name: 'TEST_TXT2'            ,text:'시험내용2'            ,type: 'string'},
            {name: 'TEST_TXT3'            ,text:'시험내용3'            ,type: 'string'},
            {name: 'STATUS'               ,text:'진행상태'             ,type: 'string'}
        ]
    });
	
	var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {   // 검색 팝업창
            model: 'orderNoMasterModel',
            autoLoad: false,
            uniOpt : {
                isMaster: false,            // 상위 버튼 연결
                editable: false,            // 수정 모드 사용
                deletable:false,            // 삭제 가능 여부
                useNavi : false         // prev | newxt 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                    read: 's_zdd300ukrv_kdService.selectReqNum'
                }
            },
            loadStoreRecords: function() {
            var param= orderNoSearch.getValues();
            this.load({
                params : param
            });
        }
    });
	
	var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {        // 검색 팝업창
        layout: {type: 'uniTable', columns : 3},
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
                                var param= Ext.getCmp('orderNoSearchForm').getValues();
                                s_zdd300ukrv_kdService.selectPersonDept(param, function(provider, response)  {     
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
                            popup.setExtParam({'DEPT_SEARCH': orderNoSearch.getValue('REQ_DEPT_NAME')});
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
        ]
    });
    
    var orderNoMasterGrid = Unilite.createGrid('btr120ukrvOrderNoMasterGrid', { // 검색팝업창
        // title: '기본',
        layout : 'fit',       
        store: orderNoMasterStore,
        uniOpt:{
            useRowNumberer: false
        },
        columns:  [ 
            { dataIndex: 'COMP_CODE'                    ,  width: 100, hidden: true}, 
            { dataIndex: 'DIV_CODE'                     ,  width: 100, hidden: true}, 
            { dataIndex: 'REQ_NUM'                      ,  width: 100}, 
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
            onGridDblClick:function(grid, record, cellIndex, colName) {
                orderNoMasterGrid.returnData(record);
                UniAppManager.app.onQueryButtonDown();
                SearchInfoWindow.hide();
            }
        },
        returnData: function(record)   {
            if(Ext.isEmpty(record)) {
                record = this.getSelectedRecord();
            }
            detailForm.setValues({'DIV_CODE'    :record.get('DIV_CODE')});
            detailForm.setValues({'REQ_NUM'     :record.get('REQ_NUM')});
        }   
    });
	
	function openSearchInfoWindow() {  //검색팝업창
        orderNoSearch.setValue('DIV_CODE', UserInfo.divCode);
        orderNoSearch.setValue('REQ_DATE_FR', UniDate.get('startOfMonth'));
        orderNoSearch.setValue('REQ_DATE_TO', UniDate.get('today'));
        orderNoMasterStore.loadStoreRecords();
        if(!SearchInfoWindow) {
            SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '의뢰번호검색',
                width: 1080,                             
                height: 580,
                layout: {type:'vbox', align:'stretch'},                 
                items: [orderNoSearch, orderNoMasterGrid], 
                tbar:  ['->',
                    {itemId : 'saveBtn',
                    text: '조회',
                    handler: function() {
                        orderNoMasterStore.loadStoreRecords();
                    },
                    disabled: false
                    }, {
                        itemId : 'OrderNoCloseBtn',
                        text: '닫기',
                        handler: function() {
                            SearchInfoWindow.hide();
                        },
                        disabled: false
                    }
                ],
                listeners: {beforehide: function(me, eOpt)
                    {
                        orderNoSearch.clearForm();
                        orderNoMasterGrid.reset();                                              
                    },
                    beforeclose: function( panel, eOpts ) {
                        orderNoSearch.clearForm();
                        orderNoMasterGrid.reset();
                    },
                    beforeshow: function( panel, eOpts )    {
                        orderNoSearch.setValue('DIV_CODE', UserInfo.divCode);
                        orderNoSearch.setValue('REQ_DATE_FR', UniDate.get('startOfMonth'));
                        orderNoSearch.setValue('REQ_DATE_TO', UniDate.get('today'));
                        orderNoMasterStore.loadStoreRecords();
                    }
                }       
            })
        }
        SearchInfoWindow.show();
        SearchInfoWindow.center();
    }
	
    /**
     * Master Form
     * 
     * @type
     */     
    var detailForm = Unilite.createForm('s_zdd300ukrv_kdDetail', {
        disabled :false,
        flex:1,
        layout: {type: 'uniTable', columns: 3, tdAttrs: {valign:'top'}},
        items :[
            {
                fieldLabel: '사업장',
                name: 'DIV_CODE',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                allowBlank:false
            },{
                fieldLabel: 'FLAG',
                name:'FLAG',  
                xtype: 'uniTextfield',
                hidden: true
            },{
                fieldLabel: 'COMP_CODE',
                name:'COMP_CODE',  
                xtype: 'uniTextfield',
                hidden: true
            },{
                fieldLabel: '의뢰번호',
                name: 'REQ_NUM',  
                xtype: 'uniTextfield',
                readOnly: true
            },{
                xtype : 'button',
                id:'GW',
                text:'기안',
                colspan: 2, 
                handler: function() {
                    var param = detailForm.getValues();
                    param.DRAFT_NO = UserInfo.compCode + detailForm.getValue('REQ_NUM');
                    if(confirm('기안 하시겠습니까?')) {
                        s_zdd300ukrv_kdService.selectGwData(param, function(provider, response) {
                            if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
                                s_zdd300ukrv_kdService.makeDraftNum(param, function(provider2, response)   {
                                    UniAppManager.app.requestApprove();
                                }); 
                            } else {
                                alert('이미 기안된 자료입니다.');
                                return false;
                            }    
                        });
                    }
                    UniAppManager.app.onQueryButtonDown();
                }
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
            }),{
                fieldLabel: '가스켓이력',
                xtype: 'textareafield',
                name: 'GASGET_REMARK',
                rowspan:4,
                height : 103,
                width: 500
            },{
                fieldLabel: '시험목적',
                xtype: 'textareafield',
                labelWidth: 100,
                name: 'TEST_REMARK',
                rowspan:4,
                height : 103,
                width: 500
            }, 
            Unilite.popup('Employee',{
                    fieldLabel: '담당자',
                    holdable: 'hold',
                    valueFieldName:'REQ_PERSON',
                    textFieldName:'REQ_PERSON_NAME',
                    colspan: 3,
                    validateBlank:false,
                    autoPopup:true,
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                var param= Ext.getCmp('s_zdd300ukrv_kdDetail').getValues();
                                s_zdd300ukrv_kdService.selectPersonDept(param, function(provider, response)  {     
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
                allowBlank: false
            },{
                fieldLabel: '완료요청일',
                name: 'REQ_END_DATE',
                xtype: 'uniDatefield',
                value: UniDate.get('today'),
                holdable: 'hold',
                colspan: 3, 
                allowBlank: false
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
                    allowBlank:false
            }),{
                fieldLabel: '프로젝트명',
                name:'PJT_NAME',  
                xtype: 'uniTextfield'
            },{
                fieldLabel: '도면번호',
                xtype: 'textareafield',
                name: 'DOC_NUM',
                rowspan:6,
                height : 103,
                width: 500
            },{
                fieldLabel: '설변사항',
                labelWidth: 100,
                width: 500,
                name:'CHG_TXT',  
                xtype: 'uniTextfield'
            },{
                fieldLabel: '배기량',
                colspan: 2,
                xtype: 'uniNumberfield',
                name: 'EXHAUST_Q'
            },{
                fieldLabel: '상대물이력',
                labelWidth: 100,
                width: 500,
                name:'HIS_TXT',  
                xtype: 'uniTextfield'
            },{
                fieldLabel: '기관구분',
                name:'PART_GUBUN',  
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'WZ09',
                colspan: 2
            },{
                fieldLabel: '시험스펙(고객사)',
                labelWidth: 100,
                width: 500,
                name:'TEST_SPEC1',  
                xtype: 'uniTextfield'
            },{
                fieldLabel: '고유사항',
                name:'ORIGIN_SPEC',  
                xtype: 'uniTextfield',
                colspan: 2
            },{
                fieldLabel: '시험스펙(KDG)',
                labelWidth: 100,
                width: 500,
                name:'TEST_SPEC2',  
                xtype: 'uniTextfield'
            },{
                fieldLabel: '기타',
                width: 825,
                colspan: 3,
                name:'ETC_TXT',  
                xtype: 'uniTextfield'
            },{
                xtype: 'component',
                colspan: 3,
                tdAttrs: {style: 'border-top: 1px solid #cccccc;  padding-top: 5px;' }
            }, {
                xtype: 'container',
                layout : {type : 'uniTable'},
                colspan: 3,
                items: [ 
                    Unilite.popup('DIV_PUMOK',{ 
                            fieldLabel: '품목코드',
                            valueFieldName: 'ITEM_CODE', 
                            textFieldName: 'ITEM_NAME', 
                            allowBlank: false, 
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
                        xtype: 'uniTextfield'
                    }
                ]
            },{
                fieldLabel: '품번',
                name:'OEM_ITEM_CODE',  
                readOnly: true,
                xtype: 'uniTextfield'
            },{
                fieldLabel: '시험내용2',
                width: 500,
                labelWidth: 223,
                colspan: 2,
                name:'TEST_TXT2',  
                xtype: 'uniTextfield'
            },{
                fieldLabel: '진행사항',
                name:'STATUS',  
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'WB14'
            },{
                fieldLabel: '시험내용3',
                width: 500,
                labelWidth: 223,
                name:'TEST_TXT3',  
                xtype: 'uniTextfield'
            },{
                fieldLabel: 'GW_FLAG',
                name:'GW_FLAG',  
                hidden: true,
                xtype: 'uniTextfield'
            },{
                fieldLabel: 'GW_DOC',
                name:'GW_DOC',  
                hidden: true,
                xtype: 'uniTextfield'
            },{
                fieldLabel: 'DRAFT_NO',
                name:'DRAFT_NO',  
                hidden: true,
                xtype: 'uniTextfield'
            }
        ], 
        api: {
            load: 's_zdd300ukrv_kdService.selectMaster',
            submit: 's_zdd300ukrv_kdService.syncMaster'             
        }, 
        listeners : {
                uniOnChange:function( basicForm, dirty, eOpts ) {
                    console.log("onDirtyChange");
                    if(basicForm.isDirty()) {
                    	if(detailForm.getValue('FLAG') == 'D') {
                            UniAppManager.setToolbarButtons('save', false);
                        } else if(!Ext.isEmpty(detailForm.getValue('REQ_NUM')) && detailForm.getValue('FLAG') != 'D') {
                            detailForm.setValue('FLAG', 'U');
                    	}
                        UniAppManager.setToolbarButtons(['save', 'reset'], true);
                    } else {
                        detailForm.setValue('FLAG', '');
                        UniAppManager.setToolbarButtons(['save', 'reset'], false);
                    }
                },
                beforeaction:function(basicForm, action, eOpts) {
                    console.log("action : ",action);
                    console.log("action.type : ",action.type);
                    if(action.type =='directsubmit')    {
                        var invalid = this.getForm().getFields().filterBy(function(field) {
                            return !field.validate();
                        });
                        if(invalid.length > 0)  {
                            r=false;
                            var labelText = ''
                            
                            if(Ext.isDefined(invalid.items[0]['fieldLabel']))   {
                                var labelText = invalid.items[0]['fieldLabel']+'은(는)';
                            }else if(Ext.isDefined(invalid.items[0].ownerCt))   {
                                var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
                            }
                            alert(labelText+Msg.sMB083);
                            invalid.items[0].focus();
                        }                                                                                                   
                    }
                }
        }        
    });

    /**
     * main app
     */
    Unilite.Main( {
             id  : 's_zdd300ukrv_kdApp',
             items  : [ detailForm],
             fnInitBinding : function() {
                Ext.getCmp('GW').setDisabled(true);
                detailForm.setValue('FLAG', 'N');
                detailForm.setValue('COMP_CODE',UserInfo.compCode);
                detailForm.setValue('DIV_CODE',UserInfo.divCode);
                detailForm.setValue('REQ_DATE', UniDate.get('today'));
                detailForm.setValue('REQ_END_DATE', UniDate.get('today'));
                detailForm.setValue('EXHAUST_Q', '1');
//                this.setToolbarButtons(['newData'],true);
                this.setToolbarButtons(['newData', 'delete', 'deleteAll', 'reset', 'save'],false);
            },
            onQueryButtonDown:function () {
            	var reqNum = detailForm.getValue('REQ_NUM');
                if(Ext.isEmpty(reqNum)) {
                    openSearchInfoWindow() 
                } else {
                    var param= detailForm.getValues();
                    detailForm.uniOpt.inLoading = true;
                    Ext.getBody().mask('로딩중...','loading-indicator');
                    detailForm.getForm().load({
                        params: param,
                        success:function()  {
                            Ext.getBody().unmask();
                            detailForm.uniOpt.inLoading = false;
                            if(!Ext.isEmpty(detailForm.getValue('REQ_NUM'))) {
                                Ext.getCmp('GW').setDisabled(false);
                            } else {
                                Ext.getCmp('GW').setDisabled(true);
                            }
                        },
                         failure: function(batch, option) {                     
                            Ext.getBody().unmask();                  
                         }
                    })
                    this.setToolbarButtons(['save'], false);
                    this.setToolbarButtons(['deleteAll', 'reset'], true);
                }
            },
            onResetButtonDown: function() {     // 초기화
                detailForm.clearForm();
                detailForm.setValue('FLAG', 'N');
                detailForm.setValue('COMP_CODE',UserInfo.compCode);
                detailForm.setValue('DIV_CODE',UserInfo.divCode);
                detailForm.setValue('REQ_DATE', UniDate.get('today'));
                detailForm.setValue('REQ_END_DATE', UniDate.get('today'));
                detailForm.setValue('EXHAUST_Q', '1');
                Ext.getCmp('GW').setDisabled(true);
                this.setToolbarButtons(['newData', 'delete', 'deleteAll', 'reset', 'save'],false);
            },
            onDeleteAllButtonDown : function() {
                detailForm.setValue('FLAG', 'D');         
                var param= detailForm.getValues();
                Ext.getBody().mask('로딩중...','loading-indicator');
                detailForm.getForm().submit({
                     params : param,
                     success : function(form, action) {
                        Ext.getBody().unmask();
                        detailForm.getForm().wasDirty = false;
                        detailForm.resetDirtyStatus();                                          
                        UniAppManager.setToolbarButtons('save', false); 
                        UniAppManager.app.onResetButtonDown();
                        UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.
                     }  
                });  
//                UniAppManager.app.onResetButtonDown();    
            },
            onSaveDataButtonDown: function (config, action) { 
            	if(Ext.isEmpty(detailForm.getValue('CUSTOM_CODE')) || Ext.isEmpty(detailForm.getValue('ITEM_CODE'))) {
                    alert("필수입력값을 확인해주세요.");
                    return false;
                } else {
                    var param= detailForm.getValues();
                    Ext.getBody().mask('로딩중...','loading-indicator');
                    detailForm.getForm().submit({
                         params : param,
                         success : function(form, action) {
                            Ext.getBody().unmask();
                            detailForm.getForm().wasDirty = false;
                            detailForm.resetDirtyStatus();     
                            if(detailForm.getValue('FLAG') == 'N') {
                                s_zdd300ukrv_kdService.selectReqNumFormSet(param, function(provider, response)   {
                                	detailForm.setValue('REQ_NUM', provider[0].REQ_NUM);
                                    UniAppManager.setToolbarButtons('save', false); 
                                    UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.
                                });
                            } else {
                                UniAppManager.setToolbarButtons('save', false); 
                                UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.
                            }
                         }  
                    });
                }
            },
            requestApprove: function(){     //결재 요청
                var gsWin = window.open('about:blank','payviewer','width=500,height=500'); 
                
                var frm         = document.f1;
                var compCode    = UserInfo.compCode;
                var divCode     = detailForm.getValue('DIV_CODE');
                var reqNum      = detailForm.getValue('REQ_NUM');
                var spText      = 'EXEC omegaplus_kdg.unilite.USP_GW_S_ZDD300UKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + reqNum + "'";
                var spCall      = encodeURIComponent(spText); 
                
                /* frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_zdd300ukrv_kd&draft_no=" + 0 + "&sp=" + spCall/* + Base64.encode();
                frm.target   = "payviewer"; 
                frm.method   = "post";
                frm.submit(); */
                
                var gwurl = groupUrl + "viewMode=docuDraft" + "&prg_no=s_zdd300ukrv_kd&draft_no=" + 0 + "&sp=" + spCall/* + Base64.encode()*/;
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
