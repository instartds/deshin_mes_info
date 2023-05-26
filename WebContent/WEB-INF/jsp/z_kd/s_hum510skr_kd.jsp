<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hum510skr_kd">
    <t:ExtComboStore comboType="BOR120"  />                             <!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {
    
    /** Model 정의 
     * @type 
     */
    Unilite.defineModel('s_hum510skr_kdModel', {
        fields: [
            {name: 'PERSON_NUMB'        ,text: '사원번호'                       ,type: 'string'},
            {name: 'PERSON_NAME'        ,text: '성명'                         ,type: 'string'},
            {name: 'DEPT_CODE'          ,text: '부서코드'                       ,type: 'string'},
            {name: 'DEPT_NAME'          ,text: '부서명'                        ,type: 'string'},
            {name: 'BIRTH_DATE'         ,text: '생년월일'                       ,type: 'string'},
            {name: 'KOR_ADDR'           ,text: '주소'                         ,type: 'string'},
            {name: 'JOB_REMARK'         ,text: '기능 및 자격'                    ,type: 'string'},
            {name: 'RETR_DATE'          ,text: '퇴사일자'                       ,type: 'string'},
            {name: 'ARMY_REMARK'        ,text: '병역'                         ,type: 'string'},
            {name: 'RETR_RESN_REMARK'   ,text: '퇴직사유'                       ,type: 'string'},
            {name: 'JOIN_DATE'          ,text: '입사일'                        ,type: 'string'},
            {name: 'CONRRACT_DATE'      ,text: '계약갱신일'                  ,type: 'string'},
            {name: 'ANNOUNCE_LIST1'     ,text: '발령정보'                       ,type: 'string'},
            {name: 'ANNOUNCE_LIST2'     ,text: '발령정보(교육, 건강, 휴직 등)'     ,type: 'string'}
        ]
    });
    
    
    
    
    /** Store 정의(Service 정의)
     * @type 
     */                 
    var masterStore = Unilite.createStore('s_hum510skr_kdMasterStore1',{
        model   : 's_hum510skr_kdModel',
        uniOpt  : {
            isMaster    : true,             // 상위 버튼 연결 
            editable    : false,            // 수정 모드 사용 
            deletable   : false,            // 삭제 가능 여부 
            useNavi     : false             // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy   : {
            type: 'direct',
            api: {          
                    read: 's_hum510skr_kdService.selectList'
            }
        },
        loadStoreRecords : function()   {
            var param= Ext.getCmp('panelResultForm').getValues();
            console.log( param );
            this.load({
                params : param
            });
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
                var count = masterGrid.getStore().getCount();  
                if(count > 0){
                    Ext.getCmp('GW').setDisabled(false);
                }else{
                    Ext.getCmp('GW').setDisabled(true);
                }

            }
        },
        group: 'DEPT_CODE'
    });
    
    
    
    
    var panelResult = Unilite.createSearchForm('panelResultForm', {
//      hidden  : !UserInfo.appOption.collapseLeftSearch,
        region  : 'north',
        layout  : {type : 'uniTable', columns : 3
//, tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
//, tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
        },
        padding : '1 1 1 1',
        border  : true,
        items   : [
           {
                fieldLabel  : '사업장',
                name        : 'DIV_CODE', 
                xtype       : 'uniCombobox',
                comboType   : 'BOR120',
                value       : UserInfo.divCode,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                    }
                }
            }, Unilite.popup('Employee',{
                fieldLabel      : '사원',
                valueFieldName  : 'PERSON_NUMB_FR',
                textFieldName   : 'NAME',
                validateBlank   : false,
                autoPopup       : true,
                tdAttrs         : {width: 380},
                listeners       : {
                    onSelected: {
                        fn: function(records, type) {
                            panelResult.setValue('PERSON_NUMB_TO', panelResult.getValue('PERSON_NUMB_FR'));
                            panelResult.setValue('NAME1', panelResult.getValue('NAME'));
                        },
                        scope: this
                    },
                    onClear: function(type) {
                    	panelResult.setValue('PERSON_NUMB_FR', '');
                        panelResult.setValue('NAME', '');
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }),Unilite.popup('Employee',{
                fieldLabel      : '~',
                valueFieldName  : 'PERSON_NUMB_TO',
                textFieldName   : 'NAME1',
                autoPopup       : true,
                tdAttrs         : {width: 380},
                listeners       : {
                    onSelected: {
                        fn: function(records, type) {
//                          dataForm.setValue('S_DEPT_CODE', records[0].DEPT_CODE);
                        },
                        scope: this
                    },
                    onClear: function(type) {
                    	panelResult.setValue('PERSON_NUMB_TO', '');
                        panelResult.setValue('NAME1', '');
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }),{     
                fieldLabel  : '재직구분',
                name        : 'WORK_GB',
                id          : 'workGb',
                xtype       : 'uniRadiogroup',
                width       : 300,
                items       : [{
                    boxLabel    : '전체',
                    name        : 'WORK_GB',
                    inputValue  : ''                            
                },{
                    boxLabel    : '재직',
                    name        : 'WORK_GB',
                    inputValue  : '1'                               
                },{
                    boxLabel    : '퇴직',
                    name        : 'WORK_GB',
                    inputValue  : '2'
                }], 
                value       : '1'
            },  
            Unilite.popup('DEPT',{
                fieldLabel      : '부서',
                valueFieldName  : 'DEPT_CODE_FR',
                textFieldName   : 'DEPT_NAME',
                validateBlank   : false,                    
                tdAttrs         : {width: 380},  
                listeners       : {
                    onSelected: {
                        fn: function(records, type) { 
                            panelResult.setValue('DEPT_CODE_TO', panelResult.getValue('DEPT_CODE_FR'));
                            panelResult.setValue('DEPT_NAME1', panelResult.getValue('DEPT_NAME'));
                        },
                        scope: this
                    },
                    onClear: function(type) {
                    	panelResult.setValue('DEPT_CODE_FR', '');
                        panelResult.setValue('DEPT_NAME', '');
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }),Unilite.popup('DEPT',{
                fieldLabel      : '~',
                valueFieldName  : 'DEPT_CODE_TO',
                textFieldName   : 'DEPT_NAME1',                    
                tdAttrs         : {width: 380},  
                listeners       : {
                    onSelected: {
                        fn: function(records, type) {
//                          dataForm.setValue('S_DEPT_CODE', records[0].DEPT_CODE);
                        },
                        scope: this
                    },
                    onClear: function(type) {
                    	panelResult.setValue('DEPT_CODE_TO', '');
                        panelResult.setValue('DEPT_NAME1', '');
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            })
        ]
    });

    
    
    
    /** Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('s_hum510skr_kdGrid1', {
        store   : masterStore,
        region  : 'west',
        flex    : 2,
        uniOpt  : { 
            expandLastColumn    : false,        //마지막 컬럼 * 사용 여부
            useRowNumberer      : true,         //첫번째 컬럼 순번 사용 여부
            useLiveSearch       : true,         //찾기 버튼 사용 여부
            useRowContext       : false,            
            onLoadSelectFirst   : true,
            filter: {                           //필터 사용 여부
                useFilter   : true,
                autoCreate  : true
            }
        },
        selModel: 'rowmodel',
        
        tbar: [{
                itemId : 'GWBtn',
                id:'GW',
                iconCls : 'icon-referance'  ,
                text:'기안',
                handler: function() {
                    var param = panelResult.getValues();
                    
                    if(!UniAppManager.app.isValidSearchForm()){
                        return false;
                    }

                    if(confirm('기안 하시겠습니까?')) {
                       UniAppManager.app.requestApprove();
                    }
                }
            }
        ],
        
        features: [ 
            {id: 'masterGridSubTotal'   , ftype: 'uniGroupingsummary'   , showSummaryRow: false},
            {id: 'masterGridTotal'      , ftype: 'uniSummary'           , showSummaryRow: false} 
        ],
        columns:  [
            { dataIndex: 'PERSON_NUMB'          , width: 110    },
            { dataIndex: 'PERSON_NAME'          , width: 110    },
            { dataIndex: 'DEPT_CODE'            , width: 110    },
            { dataIndex: 'DEPT_NAME'            , flex: 1       , minWidth: 110 },
            { dataIndex: 'BIRTH_DATE'           , width: 100    , hidden: true},
            { dataIndex: 'KOR_ADDR'             , width: 80     , hidden: true},
            { dataIndex: 'JOB_REMARK'           , width: 110    , hidden: true},
            { dataIndex: 'RETR_DATE'            , width: 110    , hidden: true},
            { dataIndex: 'ARMY_REMARK'          , width: 110    , hidden: true},
            { dataIndex: 'RETR_RESN_REMARK'     , width: 100    , hidden: true},
            { dataIndex: 'JOIN_DATE'            , width: 100    , hidden: true},
            { dataIndex: 'CONRRACT_DATE'        , width: 100    , hidden: true},
            { dataIndex: 'ANNOUNCE_LIST1'       , width: 100    , hidden: true},
            { dataIndex: 'ANNOUNCE_LIST2'       , width: 100    , hidden: true}
        ],
        listeners:{
            uniOnChange: function(grid, dirty, eOpts) {
            },
            selectionchangerecord:function(selected)    {
                detailForm.loadForm(selected);
            }
        }
    }); 
    
    
    
    var detailForm = Unilite.createForm('detailForm', {
        masterGrid  : masterGrid,
        region      : 'center',
        flex        : 5,
        autoScroll  : true,
        border      : false,
        disabled    : false,
        padding     : '1 1 1 1',
        layout      : {
            type        : 'uniTable',
            columns     : 8,
            tableAttrs  : {style: 'border : 1px solid #ced9e7;', width: '100%'},
            tdAttrs     : {style: 'border : 1px solid #ced9e7;', align : 'center'}
        },
        xtype       : 'container',
        items       : [{ 
            xtype   : 'component',
            html    : "<font size='5'>근로자 명부<br>",
            padding : '10 0 10 0',
            colspan : 8
        },{
            xtype   : 'component',
            html    : '사&nbsp;&nbsp;&nbsp;&nbsp;번',
            width   : 100,
            colspan : 2
        },
        {
            xtype   : 'uniTextfield',
            name    : 'PERSON_NUMB_FR',
            readOnly: true,
//          width   : '100%',
            width   : 250,
            colspan : 2
        },{
            xtype   : 'component',
            html    : '부&nbsp;&nbsp;&nbsp;서&nbsp;&nbsp;&nbsp;명',
            width   : 100,
            colspan : 2
        },{
            xtype   : 'uniTextfield',
            name    : 'DEPT_NAME',
            readOnly: true,
            width   : '100%',
            colspan : 2
        },{
            xtype   : 'component',
            html    : '성&nbsp;&nbsp;&nbsp;&nbsp;명',
            colspan : 2
        },{
            xtype   : 'uniTextfield',
            name    : 'PERSON_NAME',
            readOnly: true,
//          width   : '100%',
            width   : 250,
            colspan : 2
        },{
            xtype   : 'component',
            html    : '생&nbsp;&nbsp;년&nbsp;&nbsp;월&nbsp;&nbsp;일',
            colspan : 2
        },{ 
            xtype   : 'uniTextfield',
            name    : 'BIRTH_DATE',
            readOnly: true,
            width   : '100%',
            colspan : 2
        },{
            xtype   : 'component',
            html    : '주&nbsp;&nbsp;&nbsp;&nbsp;소',
            colspan : 2
        },{
            xtype   : 'uniTextfield',
            name    : 'KOR_ADDR',
            readOnly: true, 
            width   : '100%',
            colspan : 6
        },{
            xtype   : 'component',
            html    : '이</br></br>력',
            width   : 30,
            rowspan : 2 
        },{
            xtype   : 'component',
            html    : '기능 및 자격',
            colspan : 1
        },{
            xtype   : 'uniTextfield',
            name    : 'JOB_REMARK',
            readOnly: true,
//          width   : '100%',
            width   : 250,
            colspan : 2
        },{
            xtype   : 'component',
            html    : '사</br></br>유',
            width   : 30,
            rowspan : 2
        },{
            xtype   : 'component',
            html    : '퇴&nbsp;&nbsp;&nbsp;직&nbsp;&nbsp;&nbsp;일',
            colspan : 1
        },{
            xtype   : 'uniTextfield',
            name    : 'RETR_DATE',
            readOnly: true, 
            width   : '100%', 
            colspan : 2
        },{
            xtype   : 'component', 
            html    : '병&nbsp;&nbsp;&nbsp;&nbsp;역', 
            colspan : 1
        },{
            xtype   : 'uniTextfield',
            name    : 'ARMY_REMARK',
            readOnly: true,
//          width   : '100%',
            width   : 250,
            colspan : 2
        },{
            xtype   : 'component',
            html    : '사&nbsp;&nbsp;&nbsp;&nbsp;유',
            colspan : 1
        },{
            xtype   : 'uniTextfield',
            name    : 'RETR_RESN_REMARK',
            readOnly: true,
            width   : '100%',
            colspan : 2
        },{
            xtype   : 'component',
            html    : '고&nbsp;&nbsp;&nbsp;용&nbsp;&nbsp;&nbsp;일',
            colspan : 2
        },{
            xtype   : 'uniTextfield',
            name    : 'JOIN_DATE',
            readOnly: true,
//          width   : '100%',
            width   : 250,
            colspan : 2
        },{
            xtype   : 'component',
            html    : '계&nbsp;약&nbsp;갱&nbsp;신&nbsp;일',
            colspan : 2
        },{
            xtype   : 'uniTextfield',
            name    : 'CONRRACT_DATE',
            readOnly: true,
            width   : '100%',
            colspan : 2
        },{
            xtype   : 'component',
            html    : '근</br>로</br>계</br>약</br>조</br>건',
            rowspan : 1,
            colspan     : 2
        },{
            fieldLabel  : '',
            xtype       : 'textareafield',
            name        : 'ANNOUNCE_LIST1',
            readOnly    : true,
            width       : '100%',
            height      : 95,
            colspan     : 7
        },{
            xtype   : 'component',
            html    : "<div style='text-align:left', 'border-bottom:0'>특기사항 (교육, 건강, 휴직 등)</div>",
            colspan : 8
        },{
            fieldLabel  : '',
            xtype       : 'textareafield',
            name        : 'ANNOUNCE_LIST2',
            readOnly    : true,
            width       : '100%',
            height      : '100%',
            minHeight   : 60,
            colspan     : 8
        }],
        loadForm: function(record)  {
            // window 오픈시 form에 Data load
            this.reset();
            this.setActiveRecord(record || null); 
            this.resetDirtyStatus();
        },
        listeners:{
//          hide:function() {
//              masterGrid.show();
//              panelResult.show();
//          }
        }
    });

    
    
    
    Unilite.Main({
        id          : 's_hum510skr_kdApp',
        borderItems : [{
            region  : 'center',
            layout  : 'border',
            border  : false,
            items   : [
                panelResult,
                {
                    region  : 'center',
                    xtype   : 'container',
                    border  : true,
                    layout  : {type:'hbox', align:'stretch'},
                    items   : [
                        masterGrid, detailForm
                    ]
                }
            ]
        }], 
        fnInitBinding : function() {
            //초기값 설정
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            Ext.getCmp('workGb').setValue('1');

            //초기화 시, 포커스 설정
            panelResult.onLoadSelectText('PERSON_NUMB_FR');
            //버튼 설정
            UniAppManager.setToolbarButtons('detail', false);
            UniAppManager.setToolbarButtons('reset' , false);
            UniAppManager.setToolbarButtons('save'  , false);
            
            Ext.getCmp('GW').setDisabled(true);
        },
        
        onQueryButtonDown : function()  {
            //필수입력값 체크
            if(!this.isValidSearchForm()){
                return false;
            }
            
            masterStore.loadStoreRecords();
            //초기화 버튼 활성화
            UniAppManager.setToolbarButtons('reset', true);
        },              
                
        onResetButtonDown: function() {     
            panelResult.clearForm();
            masterGrid.getStore().loadData({}); 
            this.fnInitBinding();   
        },
        
        requestApprove: function(){     //결재 요청
            var gsWin = window.open('about:blank','payviewer','width=500,height=500');
            
            var frm         = document.f1;
            var compCode    = UserInfo.compCode;
            var userId      = UserInfo.userID
            var divCode     = panelResult.getValue('DIV_CODE');
            var gubun       = Ext.getCmp('workGb').getChecked()[0].inputValue
            
            var record = masterGrid.getSelectedRecord();
            
            var deptcodefr    = record.data['DEPT_CODE'];
            var deptcodeto    = record.data['DEPT_CODE'];
            var personnumbfr  = record.data['PERSON_NUMB'];
            var personnumbto  = record.data['PERSON_NUMB'];
            
            
            var groupUrl = "http://gw.kdg.co.kr:8070/approval/legacyGateway.hi?viewMode=docuDraft&prg_no=hum510skr&draft_no=0&sp=EXEC " 
     
            var spText      = 'omegaplus_kdg.unilite.USP_HUMAN_HUM510SKR_fnQuery ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" 
                            + ', ' + "'" + deptcodefr + "'" +', ' + "'" + deptcodeto + "'" 
                            + ', ' + "'" + personnumbfr + "'" + ', ' + "'" + personnumbto + "'" 
                            + ', ' + "'" + gubun + "'" + ', ' + "''" + ', ' + "'" + userId + "'" + ', ' + "'ko'" + ', ' + "''";
            var spCall      = encodeURIComponent(spText); 
            


            frm.action   = groupUrl + spCall/* + Base64.encode()*/;
            frm.target   = "payviewer"; 
            frm.method   = "post";
            frm.submit();
        }
    });
};
</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>
