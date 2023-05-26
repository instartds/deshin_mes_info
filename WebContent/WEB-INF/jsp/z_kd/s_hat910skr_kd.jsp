<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hat910skr_kd"  >
    <t:ExtComboStore comboType="BOR120"    pgmId="s_hat910skr_kd"/>             <!-- 사업장 -->
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
    Unilite.defineModel('s_hat910skr_kdModel', {
        fields: [
            {name: 'COMP_CODE'                ,text:'법인코드'            ,type:'string' },
            {name: 'AFFIL_CODE'               ,text:'부서코드'            ,type:'string' },
            {name: 'AFFIL_NAME'               ,text:'부서'               ,type:'string' },
            {name: 'FOOD_01'                  ,text:'중식'               ,type:'int' },
            {name: 'FOOD_02'                  ,text:'특근'               ,type:'int' },
            {name: 'FOOD_03'                  ,text:'야간'               ,type:'int' },
            {name: 'FOOD_04'                  ,text:'합계'               ,type:'int' },
            {name: 'REMARK'                   ,text:'비고'               ,type:'string' }
            
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                    
    var directMasterStore1 = Unilite.createStore('s_hat910skr_kdMasterStore1',{
            model: 's_hat910skr_kdModel',
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
                       read: 's_hat910skr_kdServiceImpl.selectList'                    
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
                fieldLabel: '조회월',
                xtype: 'uniMonthfield',
                name: 'DUTY_YYYYMM',
                labelWidth:90,               
                value: new Date(),
                tdAttrs: {width: 300},
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
                multiSelect: true, 
                typeAhead: false,
                comboType:'BOR120',
                width: 325,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                    }
                }
            },
            Unilite.popup('DEPT',{
                fieldLabel      : '부서',
                valueFieldName  : 'DEPT_CODE',
                textFieldName   : 'DEPT_NAME',
                validateBlank   : false,                    
                tdAttrs         : {width: 380},  
                listeners       : {
                    onSelected: {
                        fn: function(records, type) {
//                          dataForm.setValue('S_DEPT_CODE', records[0].DEPT_CODE);
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
            })]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('s_hat910skr_kdGrid1', {
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
        columns:  [  { dataIndex: 'COMP_CODE'               , width: 77, hidden:true},                     
                     { dataIndex: 'AFFIL_CODE'              , width: 90},
                     { dataIndex: 'AFFIL_NAME'              , width: 130},
                     { dataIndex: 'FOOD_01'                 , width: 100},
                     { dataIndex: 'FOOD_02'                 , width: 100},
                     { dataIndex: 'FOOD_03'                 , width: 100},
                     { dataIndex: 'FOOD_04'                 , width: 100},
                     { dataIndex: 'REMARK'                  , width: 200}
                    
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
        id  : 's_hat910skr_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE'     ,UserInfo.divCode);
            panelResult.setValue('DUTY_YYYYMM' 	, new Date());
            
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
            var divCode     = panelResult.getValue('DIV_CODE');
            var userId      = UserInfo.userID
            var deptcode    = panelResult.getValue('DEPT_CODE');
            var yearMm      = UniDate.getDbDateStr(panelResult.getValue('DUTY_YYYYMM')).substring(0, 6);
            var spText      = 'omegaplus_kdg.unilite.USP_HUMAN_HAT910SKR_fnQuery ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + deptcode + "'"
                            + ', ' + "'" + yearMm + "'" + ', ' + "''" + ', ' + "'" + userId + "'" + ', ' + "'ko'" + ', ' + "''";
            var spCall      = encodeURIComponent(spText); 
            
            var groupUrl = "http://gw.kdg.co.kr:8070/approval/legacyGateway.hi?viewMode=docuDraft&prg_no=hat910skr&draft_no=0&sp=EXEC " 

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
