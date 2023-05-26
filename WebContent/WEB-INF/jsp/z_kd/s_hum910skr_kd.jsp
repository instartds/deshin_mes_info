<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hum910skr_kd"  >
    <t:ExtComboStore comboType="BOR120"    pgmId="s_hum910skr_kd"/>             <!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('s_hum910skr_kdModel', {
        fields: [
            {name: 'COMP_CODE'                ,text:'법인코드'             ,type:'string' },
            {name: 'DEPT_CODE'                ,text:'부서코드'             ,type:'string' },
            {name: 'DEPT_NAME'                ,text:'부서'                ,type:'string' },
            {name: 'PERSON_NUMB'              ,text:'사원번호'             ,type:'string' },
            {name: 'PERSON_NAME'              ,text:'성명'                ,type:'string' },
            {name: 'OUT_FROM_DATE'            ,text:'출발일자'             ,type:'string' },
            {name: 'OUT_TO_DATE'              ,text:'귀국일자'             ,type:'string' },
            {name: 'TERM'                     ,text:'기간'                ,type:'string'},
            {name: 'NATION'                   ,text:'출장지'              ,type:'string' },
            {name: 'PURPOSE'                  ,text:'목적'                ,type:'string' },
            {name: 'REMARK'                   ,text:'비고'                ,type:'string' }
            
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                    
    var directMasterStore1 = Unilite.createStore('s_hum910skr_kdMasterStore1',{
            model: 's_hum910skr_kdModel',
            uniOpt : {
                isMaster: true,            // 상위 버튼 연결 
                editable: false,            // 수정 모드 사용 
                deletable:false,            // 삭제 가능 여부 
                useNavi : false            // prev | newxt 버튼 사용
               
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {            
                       read: 's_hum910skr_kdService.selectList'                    
                }
            }
            ,loadStoreRecords : function()    {
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
						
						UniAppManager.setToolbarButtons('reset',true);
					}else{
						Ext.getCmp('GW').setDisabled(true);
						
						UniAppManager.setToolbarButtons('reset',false);
					}
				}
			}
    });
    
    var panelResult = Unilite.createSearchForm('panelResultForm', {
        hidden: !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
            items: [{ 
                fieldLabel      : '출장일',
                xtype           : 'uniDateRangefield',
                startFieldName  : 'OUT_FR_DATE',
                endFieldName    : 'OUT_TO_DATE',
                startDate       : UniDate.get('startOfMonth'),
                endDate         : UniDate.get('today'),
                allowBlank      : false,        
                tdAttrs         : {width: 350}, 
                width           : 315,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                }
            },
            {
                fieldLabel: '사업장',
                name:'DIV_CODE', 
                xtype: 'uniCombobox',
                typeAhead: false,
                comboType:'BOR120',
                colspan:2,
                width: 300,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                    }
                }
            },
           Unilite.popup('Employee',{
                fieldLabel      : '사원',
                valueFieldName  : 'PERSON_NUMB_FR',
                textFieldName   : 'NAME',
                validateBlank   : false,
                autoPopup       : true,
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
                validateBlank   : false,
                autoPopup       : true,
                colspan         : 2,
                listeners       : {
                    onSelected: {
                        fn: function(records, type) {
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
            }),
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
                validateBlank   : false,                    
                tdAttrs         : {width: 380},  
                colspan         : 2,
                listeners       : {
                    onSelected: {
                        fn: function(records, type) {
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
            }),{        
                fieldLabel  : '재직구분',
                name        : 'WORK_GUBUN',
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
            }]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('s_hum910skr_kdGrid1', {
        region: 'center',
        layout: 'fit',
        uniOpt:{    
            expandLastColumn: false,    //마지막 컬럼 * 사용 여부
            useRowNumberer: true,        //첫번째 컬럼 순번 사용 여부
            useLiveSearch: true,        //찾기 버튼 사용 여부
            useRowContext: false,            
            onLoadSelectFirst    : true,
            filter: {                    //필터 사용 여부
                useFilter: true,
                autoCreate: true
            }
        },
        
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
            {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
            {id: 'masterGridTotal',    ftype: 'uniSummary',         showSummaryRow: false} 
        ],
        store: directMasterStore1,
        columns:  [  { dataIndex: 'COMP_CODE'                 , width: 77, hidden:true},                     
                     { dataIndex: 'DEPT_CODE'                 , width: 90},
                     { dataIndex: 'DEPT_NAME'                 , width: 130},
                     { dataIndex: 'PERSON_NUMB'               , width: 90},
                     { dataIndex: 'PERSON_NAME'               , width: 90},
                     { dataIndex: 'OUT_FROM_DATE'             , width: 130},
                     { dataIndex: 'OUT_TO_DATE'               , width: 130},
                     { dataIndex: 'TERM'                      , width: 100, align:'center'},
                     { dataIndex: 'NATION'                    , width: 130},
                     { dataIndex: 'PURPOSE'                   , width: 250},
                     { dataIndex: 'REMARK'                    , width: 250}
                     
                     
        ] 
    });   
    
    Unilite.Main({
        borderItems:[{
         region:'center',
         layout: 'border',
         border: false,
         items:[
                masterGrid, panelResult
             ]
         }
        ], 
        id  : 's_hum910skr_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            
            panelResult.setValue('OUT_FR_DATE'	, UniDate.get('startOfMonth'));
			panelResult.setValue('OUT_TO_DATE'	, UniDate.get('today'));
            
            UniAppManager.setToolbarButtons('detail',false);
            UniAppManager.setToolbarButtons('reset',false);
            UniAppManager.setToolbarButtons('save',false);
            
            Ext.getCmp('GW').setDisabled(true);
        },
        onQueryButtonDown : function()    {
            if(!this.isValidSearchForm()){
                return false;
            }
            masterGrid.reset();
            masterGrid.getStore().loadStoreRecords();
            
            var viewLocked = masterGrid.getView();
            var viewNormal = masterGrid.getView();
            console.log("viewLocked : ",viewLocked);
            console.log("viewNormal : ",viewNormal);
            viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(false);
            viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);
            viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(false);
            viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
        },
        onResetButtonDown:function() {
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
            var frdate      = UniDate.getDbDateStr(panelResult.getValue('OUT_FR_DATE'));
            var todate      = UniDate.getDbDateStr(panelResult.getValue('OUT_TO_DATE'));
            var deptcodefr    = panelResult.getValue('DEPT_CODE_FR');
            var deptcodeto    = panelResult.getValue('DEPT_CODE_TO');
            var personnumbfr  = panelResult.getValue('PERSON_NUMB_FR');
            var personnumbto  = panelResult.getValue('PERSON_NUMB_TO');
            var gubun       = Ext.getCmp('workGb').getChecked()[0].inputValue
            
            //var record = masterGrid.getSelectedRecord();
            var groupUrl    = "http://gw.kdg.co.kr:8070/approval/legacyGateway.hi?viewMode=docuDraft&prg_no=hum910skr&draft_no=0&sp=EXEC " 
            
                        
            var spText      = 'omegaplus_kdg.unilite.USP_HUMAN_HUM910SKR_fnQuery ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" 
                            + ', ' + "'" + frdate + "'" + ', ' + "'" + todate + "'"+ ', ' + "'" + deptcodefr + "'"+ ', ' + "'" + deptcodeto + "'" 
                            + ', ' + "'" + personnumbfr + "'" + ', ' + "'" + personnumbto + "'" 
                            + ', ' + "'" + gubun + "'" + ', ' + "''" + ', ' + "'" + userId + "'" + ', ' + "'ko'" + ', ' + "''";
            var spCall      = encodeURIComponent(spText); 
            
            
            
            //var groupUrl = "http://58.151.163.201:8070/ClipReport4/sample2.jsp?prg_no=hat890skr&sp=EXEC "

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
