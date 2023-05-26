<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_axt160skr_kd"  >
    <t:ExtComboStore comboType="BOR120"    pgmId="s_axt160skr_kd"/>             <!-- 사업장 -->
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
    Unilite.defineModel('s_axt160skr_kdModel', {
        fields: [
            {name: 'COMP_CODE'              ,text:'법인코드'          ,type:'string'},
            {name: 'REG_DATE'               ,text:'일자'              ,type:'string' },
            {name: 'AMT_01'                 ,text:'현금'              ,type:'int'},
            {name: 'AMT_02'                 ,text:'어음'              ,type:'int'},
            {name: 'AMT_03'                 ,text:'합계'              ,type:'int'},
            {name: 'AMT_04'                 ,text:'누계'              ,type:'int'},
            {name: 'AMT_05'                 ,text:'현금'              ,type:'int'},
            {name: 'AMT_06'                 ,text:'어음'              ,type:'int'},
            {name: 'AMT_07'                 ,text:'합계'              ,type:'int'},
            {name: 'AMT_08'                 ,text:'누계'              ,type:'int'},
            {name: 'REMARK_01'              ,text:'확인담당'          ,type:'string'},
            {name: 'REMARK_02'              ,text:'결재이사/사장'     ,type:'string'}
        ]           
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                    
    var directMasterStore1 = Unilite.createStore('s_axt160skr_kdMasterStore1',{
            model: 's_axt160skr_kdModel',
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
                       read: 's_axt160skr_kdService.selectList'                    
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
                    fieldLabel        : '기준년월일',
                    startFieldName: 'ST_DATE_FR',
                    endFieldName: 'ST_DATE_TO',
                    xtype             : 'uniDateRangefield',
                    id                : 'stMonth',              
                    value             : new Date(),   
                    allowBlank        : false        
              },
              {
                    fieldLabel: '사업장',
                    name:'DIV_CODE', 
                    xtype: 'uniCombobox',
                    comboType:'BOR120'
                }
            ]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('s_axt160skr_kdGrid1', {
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
        columns:  [  
                 { dataIndex: 'REG_DATE'               , width: 80, align:'center'},
                 {text: '입금내역',
                     columns:[
                     {dataIndex: 'AMT_01'               , width: 100 },
                     {dataIndex: 'AMT_02'               , width: 100 },
                     {dataIndex: 'AMT_03'               , width: 100 },
                     {dataIndex: 'AMT_04'               , width: 100 }
                 ]},
                 {text: '출금내역',
                     columns:[
                      {dataIndex: 'AMT_05'              , width: 100 },
                      {dataIndex: 'AMT_06'              , width: 100 },
                      {dataIndex: 'AMT_07'              , width: 100 },
                      {dataIndex: 'AMT_08'              , width: 100 }
                 ]},
                 { dataIndex: 'REMARK_01'               , width: 120,hidden:true},
                 { dataIndex: 'REMARK_02'               , width: 120,hidden:true}
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
        id  : 's_axt160skr_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('ST_DATE_TO', UniDate.get('today'));
            panelResult.setValue('ST_DATE_FR', UniDate.get('today'));
            
            var activeSForm = panelResult;
            //activeSForm.onLoadSelectText('PERSON_NUMB');
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
        onPrintButtonDown: function() {
               
        },
        requestApprove: function(){     //결재 요청
            var gsWin = window.open('about:blank','payviewer','width=500,height=500');
            
            var frm         = document.f1;
            var compCode    = UserInfo.compCode;
            var divCode     = panelResult.getValue('DIV_CODE');
            var userId      = UserInfo.userID
            var stdatefr     = UniDate.getDbDateStr(panelResult.getValue('ST_DATE_FR'));
            var stdateto     = UniDate.getDbDateStr(panelResult.getValue('ST_DATE_TO'));
            
            //var record = masterGrid.getSelectedRecord();
            var groupUrl    = "http://gw.kdg.co.kr:8070/approval/legacyGateway.hi?viewMode=docuDraft&prg_no=axt160skr&draft_no=0&sp=EXEC " 
                                   
            var spText      = 'omegaplus_kdg.unilite.USP_ACCNT_AXT160SKR_fnQuery ' + "'" + compCode + "'" + ', ' + "'" + stdatefr + "'" + ',' + "'" + stdateto + "'"
                            + ', ' + "'" + divCode + "'" + ', ' + "''"
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
