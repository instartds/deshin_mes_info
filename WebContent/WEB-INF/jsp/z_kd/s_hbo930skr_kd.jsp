<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hbo930skr_kd"  >
    <t:ExtComboStore comboType="BOR120"    pgmId="s_hbo930skr_kd"/>      <!-- 사업장 -->
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
    Unilite.defineModel('s_hbo930skr_kdModel', {
        fields: [
            {name: 'COMP_CODE'                ,text:'법인코드'        ,type:'string' },
            {name: 'DEPT_CODE'                ,text:'부서코드'        ,type:'string' },
            {name: 'DEPT_NAME'                ,text:'부서명'          ,type:'string' },
            {name: 'DEPT_PERSON_CNT'          ,text:'인원'           ,type:'int' },
            {name: 'BONUS_RATE'               ,text:'지급비율(%)'     ,type:'string' },
            {name: 'WAGES_100'                ,text:'평균기본급'       ,type:'int' },
            {name: 'BONUS_I'                  ,text:'상여금액'        ,type:'int' },
            {name: 'REMARK'                   ,text:'비고'           ,type:'string' }
           
            
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                    
    var directMasterStore1 = Unilite.createStore('s_hbo930skr_kdMasterStore1',{
            model: 's_hbo930skr_kdModel',
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
                       read: 's_hbo930skr_kdServiceImpl.selectList'                    
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
						
						UniAppManager.setToolbarButtons('reset'	, true);
					}else{
						Ext.getCmp('GW').setDisabled(true);
						
						UniAppManager.setToolbarButtons('reset'	, false);
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
                fieldLabel: '지급년월',
                xtype: 'uniMonthRangefield',
                startFieldName  : 'PAY_YYYYMM_FR',
                endFieldName    : 'PAY_YYYYMM_TO',
                labelWidth:90,
                value: new Date(),
                allowBlank: false,
                listeners: {
                      change: function(field, newValue, oldValue, eOpts) {                                  
                            panelResult.setValue('PAY_YYYYMM_FR', newValue);
                      }
                }
           },
           {
                fieldLabel: '사업장',
                name:'DIV_CODE', 
                xtype: 'uniCombobox',
                comboType:'BOR120',
                colspan : 2,
                width: 300,
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
                        panelResult.setValue('SUPP_TYPE', newValue);
                    }
                }           
            }]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('s_hbo930skr_kdGrid1', {
        region: 'center',
        layout: 'fit',
        uniOpt:{    
            expandLastColumn  : false,    //마지막 컬럼 * 사용 여부
            useRowNumberer    : true,     //첫번째 컬럼 순번 사용 여부
            useLiveSearch     : true,     //찾기 버튼 사용 여부
            useRowContext     : false,            
            onLoadSelectFirst : true,
            filter: {                     //필터 사용 여부
                useFilter: true,
                autoCreate: true
            }
        },
        
        tbar: [{
                itemId : 'GWBtn',
                id:'GW',
                iconCls : 'icon-referance'  ,
                text:'기안',
                //disabled : true,
                //hidden: true,
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
                     { dataIndex: 'DEPT_CODE'               , width: 100},
                     { dataIndex: 'DEPT_NAME'               , width: 150},
                     { dataIndex: 'DEPT_PERSON_CNT'         , width: 100},
                     { dataIndex: 'BONUS_RATE'              , width: 120, align: 'center'},
                     { dataIndex: 'WAGES_100'               , width: 120},
                     { dataIndex: 'BONUS_I'                 , width: 120},
                     { dataIndex: 'REMARK'                  , width: 240}
                     
                     
                     
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
        id  : 's_hbo930skr_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('PAY_YYYYMM_FR',new Date());
            panelResult.setValue('PAY_YYYYMM_TO',new Date());
            
            panelResult.setValue('SUPP_TYPE', '2');
            
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
            
            var frm          = document.f1;
            var compCode     = UserInfo.compCode;
            var divCode      = panelResult.getValue('DIV_CODE');
            var userId       = UserInfo.userID
            var paydatefr    = UniDate.getDbDateStr(panelResult.getValue('PAY_YYYYMM_FR'));
            var paydateto    = UniDate.getDbDateStr(panelResult.getValue('PAY_YYYYMM_TO'));
			var supptype     = panelResult.getValue('SUPP_TYPE');
                        
            
            var groupUrl    = "http://gw.kdg.co.kr:8070/approval/legacyGateway.hi?viewMode=docuDraft&prg_no=hbo930skr&draft_no=0&sp=EXEC " 
                        
            var spText      = 'omegaplus_kdg.unilite.USP_HUMAN_HBO930SKR_fnQuery ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" 
                            + ', ' + "'" + paydatefr + "'" + ', ' + "'" + paydateto + "'"
                            + ', ' + "'" + supptype + "'" + ', ' + "''"
                            + ', ' + "''" + ', ' + "'" + userId + "'" + ', ' + "'ko'" + ', ' + "''";
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
