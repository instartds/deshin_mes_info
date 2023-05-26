<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hat870skr_kd">
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
    //1. 기간별 , 2. 월별
    Unilite.defineModel('s_hat870skr_kdModel', {
        fields: [
			{name: 'COMP_CODE'		 	,text: '사업장'			,type: 'string'},
			{name: 'DEPT_CODE'			,text: '부서코드'			,type: 'string'},
			{name: 'DEPT_NAME'			,text: '부서명'			,type: 'string'},
			{name: 'SORT_SEQ'		    ,text: '순번'			,type: 'string'},			
			{name: 'POST_CODE'           ,text: '직위코드'           ,type: 'string'},
			{name: 'POST_NAME'		    ,text: '직위'			,type: 'string'},	
			{name: 'PERSON_NUMB'        ,text: '사원번호'           ,type: 'string'}, //        , comboType: "AU"   , comboCode: "H005"},
			{name: 'PERSON_NAME'		,text: '성명'			,type: 'string'},
			{name: 'DUTY_FR_TIME'		,text: '출근'			,type: 'string'},
			{name: 'DUTY_TO_TIME'		,text: '퇴근'			,type: 'string'},
			{name: 'OUT_TIME'			,text: '외출'			,type: 'string'},
			{name: 'IN_TIME'			,text: '귀사'			,type: 'string'},
			{name: 'DUTY_CODE1'			,text: '근태1'			,type: 'string'},
			{name: 'DUTY_CODE2'			,text: '근태2'			,type: 'string'},
			{name: 'DUTY_CODE3'			,text: '근태3'			,type: 'string'},
			{name: 'DUTY_CODE4'			,text: '근태4'			,type: 'string'}
        ]
    });

    /** Store 정의(Service 정의)
     * @type 
     */        
    //1. 기간별
    var masterStore1 = Unilite.createStore('s_hat870skr_kdmasterStore11',{
        model    : 's_hat870skr_kdModel',
        uniOpt    : {
            isMaster    : true,                // 상위 버튼 연결 
            editable    : false,            // 수정 모드 사용 
            deletable    : false,            // 삭제 가능 여부 
            useNavi        : false                // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy    : {
            type: 'direct',
            api: {            
                    read: 's_hat870skr_kdService.selectList'
            }
        },
        loadStoreRecords : function()    {
            var param= Ext.getCmp('panelResultForm').getValues();
            //1: 기간별 flag
            param.WORK_GUBUN = '1'
            console.log( param );
            this.load({
                params : param
            });
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
                var count = masterGrid1.getStore().getCount();  
                if(count > 0){
                    Ext.getCmp('GW1').setDisabled(false);
                }else{
                    Ext.getCmp('GW1').setDisabled(true);
                }

            }
        },
        group: 'DEPT_CODE'
    });
    
    //2. 월별
    var masterStore2 = Unilite.createStore('s_hat870skr_kdmasterStore12',{
        model    : 's_hat870skr_kdModel',
        uniOpt    : {
//            isMaster    : true,                // 상위 버튼 연결 
            isMaster    : false,                // 상위 버튼 연결 
            editable    : false,            // 수정 모드 사용 
            deletable    : false,            // 삭제 가능 여부 
            useNavi        : false                // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy    : {
            type: 'direct',
            api: {            
                    read: 's_hat870skr_kdService.selectList'
            }
        },
        loadStoreRecords : function()    {
            var param= Ext.getCmp('panelResultForm').getValues();
            //1: 월별 flag
            param.WORK_GUBUN = '2'
            console.log( param );
            this.load({
                params : param
            });
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
                var count = masterGrid2.getStore().getCount();  
                if(count > 0){
                    Ext.getCmp('GW2').setDisabled(false);
                }else{
                    Ext.getCmp('GW2').setDisabled(true);
                }

            }
        },
        group: 'DEPT_CODE'
    });

    
    
    
    var panelResult = Unilite.createSearchForm('panelResultForm', {
        region    : 'north',
        layout    : {type : 'uniTable', columns : 3
//        , tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
//        , tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
        },
        padding    : '1 1 1 1',
        border    : true,
        items    : [
            {
                    fieldLabel: '근태일자',
                    xtype: 'uniDatefield',
                    name: 'DUTY_DATE',
                    labelWidth:90,
                    value: new Date(),
                    allowBlank: false,
                    listeners: {
                          change: function(field, newValue, oldValue, eOpts) {                                  
                          }
                    }
            }, {
                 fieldLabel    : '사업장',
                 name        : 'DIV_CODE', 
                 xtype        : 'uniCombobox',
                 comboType    : 'BOR120',
                 value        : UserInfo.divCode,
                 colspan        : 2,
//                 multiSelect    : true, 
//                 typeAhead    : false,
                 listeners: {
                     change: function(field, newValue, oldValue, eOpts) {
                     }
                  }
            },  
            Unilite.popup('DEPT',{
                fieldLabel        : '부서',
                valueFieldName    : 'DEPT_CODE',
                textFieldName    : 'DEPT_NAME',
                validateBlank    : false,                    
                tdAttrs            : {width: 380},  
                listeners        : {
                    onSelected: {
                        fn: function(records, type) {
//                            dataForm.setValue('S_DEPT_CODE', records[0].DEPT_CODE);
                        },
                        scope: this
                    },
                    onClear: function(type)    {
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
    //1. 서울
    var masterGrid1 = Unilite.createGrid('s_hat870skr_kdGrid1', {
        store    : masterStore1,
        region    : 'center',
        layout    : 'fit',
        uniOpt    : {    
            expandLastColumn    : true,            //마지막 컬럼 * 사용 여부
            useRowNumberer        : true,            //첫번째 컬럼 순번 사용 여부
            useLiveSearch        : true,            //찾기 버튼 사용 여부
            useRowContext        : false,            
            onLoadSelectFirst    : true,
            filter: {                            //필터 사용 여부
                useFilter    : true,
                autoCreate    : true
            }
        },
        
        tbar: [{
                itemId : 'GWBtn',
                id:'GW1',
                iconCls : 'icon-referance'  ,
                text:'기안',
                handler: function() {
                    var param = panelResult.getValues();
                    
                    if(!UniAppManager.app.isValidSearchForm()){
                        return false;
                    }
                
                    //param.DRAFT_NO = "0";
                    if(confirm('기안 하시겠습니까?')) {
                       UniAppManager.app.requestApprove();
                    }
                    //UniAppManager.app.onQueryButtonDown();
                }
            }
        ],
        
        features: [ 
            {id: 'masterGrid1SubTotal1' , ftype: 'uniGroupingsummary'    , showSummaryRow: false},
            {id: 'masterGrid1Total2'    , ftype: 'uniSummary'            , showSummaryRow: false} 
        ],
        columns:  [
            { dataIndex: 'COMP_CODE'        , width: 110    , hidden: true},
            { dataIndex: 'DEPT_CODE'        , width: 110    },
            { dataIndex: 'DEPT_NAME'        , width: 110    },
            { dataIndex: 'SORT_SEQ'         , width: 110    , hidden: true},            
            { dataIndex: 'POST_CODE'        , width: 90     , hidden: true},
            { dataIndex: 'POST_NAME'        , width: 90     },
            { dataIndex: 'PERSON_NUMB'      , width: 110    },
            { dataIndex: 'PERSON_NAME'      , width: 90     },
            { dataIndex: 'DUTY_FR_TIME'     , width: 90     },
            { dataIndex: 'DUTY_TO_TIME'     , width: 90     },
            { dataIndex: 'OUT_TIME'         , width: 90     },
            { dataIndex: 'IN_TIME'          , width: 90     },
            { dataIndex: 'DUTY_CODE1'       , width: 90     },
            { dataIndex: 'DUTY_CODE2'       , width: 90     },
            { dataIndex: 'DUTY_CODE3'       , width: 90     },
            { dataIndex: 'DUTY_CODE4'       , width: 90     }

        ] ,
        listeners:{
            uniOnChange: function(grid, dirty, eOpts) {
            }
        }
    });    

    //2. 인천
    var masterGrid2 = Unilite.createGrid('s_hat870skr_kdGrid2', {
        store    : masterStore2,
        region    : 'center',
        layout    : 'fit',
        uniOpt    : {    
            expandLastColumn    : true,            //마지막 컬럼 * 사용 여부
            useRowNumberer        : true,          //첫번째 컬럼 순번 사용 여부
            useLiveSearch        : true,           //찾기 버튼 사용 여부
            useRowContext        : false,            
            onLoadSelectFirst    : true,
            filter: {                           //필터 사용 여부
                useFilter    : true,
                autoCreate    : true
            }
        },
        
        tbar: [{
                itemId : 'GWBtn',
                id:'GW2',
                iconCls : 'icon-referance'  ,
                text:'기안',
                handler: function() {
                    var param = panelResult.getValues();
                    
                    if(!UniAppManager.app.isValidSearchForm()){
                        return false;
                    }
                
                    //param.DRAFT_NO = "0";
                    if(confirm('기안 하시겠습니까?')) {
                       UniAppManager.app.requestApprove();
                    }
                    //UniAppManager.app.onQueryButtonDown();
                }
            }
        ],
        
        features: [ 
            {id: 'masterGrid1SubTotal2'    , ftype: 'uniGroupingsummary'    , showSummaryRow: false},
            {id: 'masterGrid1Total2'    , ftype: 'uniSummary'            , showSummaryRow: false} 
        ],
        columns:  [
            { dataIndex: 'COMP_CODE'        , width: 110    , hidden: true},
            { dataIndex: 'DEPT_CODE'        , width: 110    },
            { dataIndex: 'DEPT_NAME'        , width: 110    },
            { dataIndex: 'SORT_SEQ'         , width: 110    , hidden: true},
            { dataIndex: 'POST_CODE'        , width: 90     , hidden: true},
            { dataIndex: 'POST_NAME'        , width: 90     },            
            { dataIndex: 'PERSON_NUMB'      , width: 110    },
            { dataIndex: 'PERSON_NAME'      , width: 90     },
            { dataIndex: 'DUTY_FR_TIME'     , width: 90     },
            { dataIndex: 'DUTY_TO_TIME'     , width: 90     },
            { dataIndex: 'OUT_TIME'         , width: 90     },
            { dataIndex: 'IN_TIME'          , width: 90     },
            { dataIndex: 'DUTY_CODE1'       , width: 90     },
            { dataIndex: 'DUTY_CODE2'       , width: 90     },
            { dataIndex: 'DUTY_CODE3'       , width: 90     },
            { dataIndex: 'DUTY_CODE4'       , width: 90     }
        ] ,
        listeners:{
            uniOnChange: function(grid, dirty, eOpts) {
            }
        }
    });    

    
    
    
    var tab = Unilite.createTabPanel('s_hat870skr_kdTab',{        
        region        : 'center',
        activeTab    : 1,				//초기화 시 인천 탭 오픈
        border        : false,
        items        : [{
                title    : '서울',
                xtype    : 'container',
                itemId    : 's_hat870skr_kdTab1',
                layout    : {type:'vbox', align:'stretch'},
                items    : [
                    masterGrid1
                ]
            },{
                title    : '인천',
                xtype    : 'container',
                itemId    : 's_hat870skr_kdTab2',
                layout    : {type:'vbox', align:'stretch'},
                items:[
                    masterGrid2
                ]
            }
        ],
        listeners:{
            tabchange: function( tabPanel, newCard, oldCard, eOpts )    {
                if(newCard.getItemId() == 's_hat870skr_kdTab1')    {
                    
                }else {
                    
                }
            }
        }
    })
 
    
    
    
     Unilite.Main({
        id  : 's_hat870skr_kdApp',
        borderItems:[{
          region:'center',
          layout: {type: 'vbox', align: 'stretch'},
          border: false,
          items:[
                panelResult, tab 
          ]}
        ], 
        fnInitBinding : function() {
            //초기값 설정
            panelResult.setValue('DIV_CODE'        , UserInfo.divCode);
            panelResult.setValue('DUTY_DATE'        , UniDate.get('today'));
            
            //초기화 시, 포커스 설정
            panelResult.onLoadSelectText('DUTY_DATE');
            
            //초기화 시 인천 탭 오픈
            tab.setActiveTab(1);
            
            //버튼 설정
            UniAppManager.setToolbarButtons('detail',false);
            UniAppManager.setToolbarButtons('reset',false);
            UniAppManager.setToolbarButtons('save',false);
            
            Ext.getCmp('GW1').setDisabled(true);
            Ext.getCmp('GW2').setDisabled(true);
        },
        
        onQueryButtonDown : function()    {
        	
            masterStore1.claerData;
            masterStore2.claerData; 
        	
            //필수입력값 체크
            if(!this.isValidSearchForm()){
                return false;
            }
            //활성화 된 탭에 따른 조회로직
            var activeTab = tab.getActiveTab().getItemId();
            //1: 서울
            if (activeTab == 's_hat870skr_kdTab1'){
                masterStore1.loadStoreRecords();
            //2: 인천
            } else {
                masterStore2.loadStoreRecords();
            }
            
            //초기화 버튼 활성화
            UniAppManager.setToolbarButtons('reset', true);
            
        },                
                
        onResetButtonDown: function() {        
            panelResult.clearForm();
            masterStore1.claerData;
            masterStore2.claerData; 
            masterGrid1.getStore().loadData({});    
            masterGrid2.getStore().loadData({});
            this.fnInitBinding();    
        }, 
        requestApprove: function(){     //결재 요청
            var gsWin = window.open('about:blank','payviewer','width=500,height=500');
            
            var frm         = document.f1;
            var compCode    = UserInfo.compCode;
            var divCode     = panelResult.getValue('DIV_CODE');
            var userId      = UserInfo.userID
            var stdate      = UniDate.getDbDateStr(panelResult.getValue('DUTY_DATE'));
            var deptcode    = panelResult.getValue('DEPT_CODE');
            
          
            
            var gubun = '';
            
            //var record = masterGrid1.getSelectedRecord();
            var activeTab = tab.getActiveTab().getItemId();
            //1: 서울
            if (activeTab == 's_hat870skr_kdTab1'){
            	var groupUrl = "http://gw.kdg.co.kr:8070/approval/legacyGateway.hi?viewMode=docuDraft&prg_no=hat870skr_1&draft_no=0&sp=EXEC " 
            	gubun = '1';

            //2: 인천
            } else {
            	var groupUrl = "http://gw.kdg.co.kr:8070/approval/legacyGateway.hi?viewMode=docuDraft&prg_no=hat870skr_2&draft_no=0&sp=EXEC " 
            	gubun = '2';
            }
            
            var spText      = 'omegaplus_kdg.unilite.USP_HUMAN_HAT870SKR_fnQuery ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" 
                            + ', ' + "'" + deptcode + "'" +', ' + "'" + stdate + "'" + ', ' + "'" + gubun + "'"  
                            + ', ' + "'" + userId + "'" + ', ' + "'ko'" + ', ' + "''";
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
