<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hpa730skr_kd"  >
    <t:ExtComboStore comboType="BOR120"    pgmId="s_hpa730skr_kd"/>      <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="H032" />             <!-- 상여구분 -->
    <t:ExtComboStore comboType="AU" comboCode="H173" />             <!-- 관리구분 --> 
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
    Unilite.defineModel('s_hpa730skr_kdModel', {
        fields: [
            {name: 'COMP_CODE'                ,text:'법인코드'          ,type:'string' },
            {name: 'PERSON_NUMB'              ,text:'사번'             ,type:'string' },
            {name: 'PERSON_NAME'              ,text:'사원명'            ,type:'string' },
            {name: 'DEPT_CODE'                ,text:'부서코드'          ,type:'string' },
            {name: 'DEPT_NAME'                ,text:'부서명'            ,type:'string' },
            {name: 'POST_CODE'                ,text:'직위코드'          ,type:'string' },
            {name: 'POST_NAME'                ,text:'직위명'            ,type:'string' },
            {name: 'YEAR_NUM'                 ,text:'년차일수'          ,type:'int' },
            {name: 'YEAR_USE'                 ,text:'휴가일(년차사용일)'  ,type:'int' },
            {name: 'YEAR_TOT'                 ,text:'남은일수'          ,type:'int' },
            {name: 'WORK_DAY'                 ,text:'무급휴일수'         ,type:'int' },
            {name: 'FIELD_01'                 ,text:'담당'             ,type:'string' },
            {name: 'FIELD_02'                 ,text:'팀장'             ,type:'string' },
            {name: 'FIELD_03'                 ,text:'부서장'            ,type:'string' },
            {name: 'FIELD_04'                 ,text:'사장'             ,type:'string' }
           
            
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                    
    var directMasterStore1 = Unilite.createStore('s_hpa730skr_kdMasterStore1',{
            model: 's_hpa730skr_kdModel',
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
                       read: 's_hpa730skr_kdService.selectList'                    
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
					}else{
						Ext.getCmp('GW').setDisabled(true);
					}
				}
			}
    });
    
    var panelResult = Unilite.createSearchForm('panelResultForm', {
        hidden: !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 2},
        padding:'1 1 1 1',
        border:true,
            items: [{
                fieldLabel: '년도',
                xtype: 'uniYearField',
                name: 'ST_YYYY',
                labelWidth:90,
                value: new Date().getFullYear(),
                allowBlank: false,
                listeners: {
                      change: function(field, newValue, oldValue, eOpts) {   
                      }
                }
           },
           {
                fieldLabel: '사업장',
                name:'DIV_CODE', 
                xtype: 'uniCombobox',
                comboType:'BOR120',
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
                        },
                        scope: this
                    },
                    onClear: function(type) {
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }),Unilite.popup('Employee',{
                fieldLabel      : '~',
                valueFieldName  : 'PERSON_NUMB_TO',
                textFieldName   : 'NAME',
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
                        },
                        scope: this
                    },
                    onClear: function(type) {
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }),Unilite.popup('DEPT',{
                fieldLabel      : '~',
                valueFieldName  : 'DEPT_CODE_TO',
                textFieldName   : 'DEPT_NAME',
                validateBlank   : false,                    
                tdAttrs         : {width: 380},  
                listeners       : {
                    onSelected: {
                        fn: function(records, type) {
                        },
                        scope: this
                    },
                    onClear: function(type) {
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            })
            ]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('s_hpa730skr_kdGrid1', {
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
        columns:  [  { dataIndex: 'COMP_CODE'               , width: 100, hidden:true},                     
                     { dataIndex: 'PERSON_NUMB'             , width: 100},
                     { dataIndex: 'PERSON_NAME'             , width: 140},
                     { dataIndex: 'DEPT_CODE'               , width: 100},
                     { dataIndex: 'DEPT_NAME'               , width: 150},
                     { dataIndex: 'POST_CODE'               , width: 120},
                     { dataIndex: 'POST_NAME'               , width: 150},
                     { dataIndex: 'YEAR_NUM'                , width: 120},
                     { dataIndex: 'YEAR_USE'                , width: 130},
                     { dataIndex: 'YEAR_TOT'                , width: 120},
                     { dataIndex: 'WORK_DAY'                , width: 120},
                     { dataIndex: 'FIELD_01'                , width: 140},
                     { dataIndex: 'FIELD_02'                , width: 140},
                     { dataIndex: 'FIELD_03'                , width: 140},
                     { dataIndex: 'FIELD_04'                , width: 140}
                     
                     
                     
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
        id  : 's_hpa730skr_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            
            UniAppManager.setToolbarButtons('detail',false);
            UniAppManager.setToolbarButtons('reset',false);
            UniAppManager.setToolbarButtons('save',false);
            
            Ext.getCmp('GW').setDisabled(true);
        },
        onQueryButtonDown : function()    {
            if(!this.isValidSearchForm()){
                return false;
            }
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
            
            var stdate        = UniDate.getDbDateStr(panelResult.getValue('ST_YYYY'));
            var deptcodefr    = panelResult.getValue('DEPT_CODE_FR');
            var deptcodeto    = panelResult.getValue('DEPT_CODE_TO');
            var personnumbfr  = panelResult.getValue('PERSON_NUMB_FR');
            var personnumbto  = panelResult.getValue('PERSON_NUMB_TO');
            
            //var record = masterGrid.getSelectedRecord();
            var groupUrl = "http://gw.kdg.co.kr:8070/approval/legacyGateway.hi?viewMode=docuDraft&prg_no=hpa730skr&draft_no=0&sp=EXEC " 
            
                        
            var spText      = 'omegaplus_kdg.unilite.USP_HUMAN_HPA730SKR_fnQuery ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" 
                            + ', ' + "'" + deptcodefr + "'" + ', ' + "'" + deptcodeto + "'"+', ' + "'" + personnumbfr + "'" + ', ' + "'" + personnumbto + "'" 
                            +', ' + "'" + stdate + "'" + ', ' + "''" + ', ' + "'" + userId + "'" + ', ' + "'ko'" + ', ' + "''";
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
