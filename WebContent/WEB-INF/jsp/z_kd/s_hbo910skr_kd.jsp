<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hbo910skr_kd"  >
    <t:ExtComboStore comboType="BOR120"    pgmId="s_hbo910skr_kd"/>             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="HX14" />                    <!-- 출력구분 -->
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
    Unilite.defineModel('s_hbo910skr_kdModel', {
        fields: [
            {name: 'COMP_CODE'                ,text:'법인코드'            ,type:'string' },
            {name: 'DEPT_CODE'                ,text:'부서코드'            ,type:'string' },
            {name: 'DEPT_NAME'                ,text:'부서'               ,type:'string' },
            {name: 'PERSON_CNT'               ,text:'인원'               ,type:'int' },
            {name: 'BONUS_I'                  ,text:'상여금액'            ,type:'int' },
            {name: 'BONUS_WAGES_I'            ,text:'상여수당'            ,type:'int' },
            {name: 'BONUS_TOT_I'              ,text:'상여총액'            ,type:'int' },
            {name: 'BONUS_DED_I'              ,text:'상여공제'            ,type:'int' },
            {name: 'INC_AMT'                  ,text:'소득세'              ,type:'int' },
            {name: 'LOC_AMT'                  ,text:'주민세'              ,type:'int' },
            {name: 'HIR_AMT'                  ,text:'고용보험'             ,type:'int' },
            {name: 'BONUS_DED_TOT'            ,text:'공제합계'             ,type:'int' },
            {name: 'BONUS_REAL_TOT'           ,text:'실지급액'             ,type:'int' }
            
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                    
    var directMasterStore1 = Unilite.createStore('s_hbo910skr_kdMasterStore1',{
            model: 's_hbo910skr_kdModel',
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
                       read: 's_hbo910skr_kdServiceImpl.selectList'                    
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
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
            items: [{
                fieldLabel: '기준년월',
                xtype: 'uniMonthfield',
                name: 'ST_DATE',
                labelWidth:90,
                value: new Date(),
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
                width: 325,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                    }
                }
            },
            {
                fieldLabel  : '상여구분',
                xtype       : 'uniCombobox',
                name        : 'SUPP_TYPE',
                id          : 'SUPP_TYPE',
                comboType   : 'AU',
                comboCode   : 'H032',
                allowBlank  : false ,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {      
                    }
                }           
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
            ,{
                fieldLabel  : '출력구분',
                name        : 'REPORT_TYPE', 
                xtype       : 'uniCombobox',
                comboType   : 'AU',
                comboCode   : 'HX14',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                    },
                    afterrender: {
                        fn: function (combo) {
                           var store = combo.getStore()
                           var rec = { value: '', text: '' };
                           store.insert(0,rec);
                        }
                     }
                }
            }
            ]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('s_hbo910skr_kdGrid1', {
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
                
                    //param.DRAFT_NO = "0";
                    if(confirm('기안 하시겠습니까?')) {
                       UniAppManager.app.requestApprove();
                    }
                    //UniAppManager.app.onQueryButtonDown();
                }
            }
        ],
        
        features: [ 
            {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
            {id: 'masterGridTotal',    ftype: 'uniSummary',         showSummaryRow: false} 
        ],
        store: directMasterStore1,
        columns:  [  { dataIndex: 'DEPT_CODE'                 , width: 90},                     
                     { dataIndex: 'DEPT_NAME'                 , width: 160},
                     { dataIndex: 'PERSON_CNT'                , width: 90},
                     { dataIndex: 'BONUS_I'                   , width: 110},
                     { dataIndex: 'BONUS_WAGES_I'             , width: 110},
                     { dataIndex: 'BONUS_TOT_I'               , width: 110},
                     { dataIndex: 'BONUS_DED_I'               , width: 110},
                     { dataIndex: 'INC_AMT'                   , width: 110},
                     { dataIndex: 'LOC_AMT'                   , width: 110},
                     { dataIndex: 'HIR_AMT'                   , width: 110},
                     { dataIndex: 'BONUS_DED_TOT'             , width: 110},
                     { dataIndex: 'BONUS_REAL_TOT'            , width: 110}

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
        id  : 's_hbo910skr_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            
            panelResult.setValue('ST_DATE',UniDate.get('today'));
            
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
            
            UniAppManager.setToolbarButtons('reset', true);
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
            var divCode     = panelResult.getValue('DIV_CODE');
            var userId      = UserInfo.userID
            var stdate      = UniDate.getDbDateStr(panelResult.getValue('ST_DATE')).substring(0, 6);
            var deptcodefr  = panelResult.getValue('DEPT_CODE_FR');
            var deptcodeto  = panelResult.getValue('DEPT_CODE_TO');
            
            var supptype    = panelResult.getValue('SUPP_TYPE');
            var rpttype     = panelResult.getValue('REPORT_TYPE');
            
            var spText      = 'omegaplus_kdg.unilite.USP_HUMAN_HBO910SKR_fnQuery ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + stdate + "'" 
                            + ', ' + "'" + deptcodefr + "'" + ', ' + "'" + deptcodeto + "'" 
                            + ', ' + "'" + rpttype + "'" + ', ' + "'" + supptype + "'"
                            + ', ' + "''" + ', ' + "'" + userId + "'" + ', ' + "'ko'" + ', ' + "''";
            var spCall      = encodeURIComponent(spText); 
            
            var groupUrl = "http://gw.kdg.co.kr:8070/approval/legacyGateway.hi?viewMode=docuDraft&prg_no=hbo910skr&draft_no=0&sp=EXEC " 

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
