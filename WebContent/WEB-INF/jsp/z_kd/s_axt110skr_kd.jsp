<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_axt110skr_kd"  >
    <t:ExtComboStore comboType="BOR120"    pgmId="s_axt110skr_kd"/>             <!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {

    /**
	 * Model 정의
	 * 
	 * @type
	 */
    Unilite.defineModel('s_axt110skr_kdModel', {
        fields: [
            {name: 'COMP_CODE'           ,text:'법인코드'             ,type:'string'},
            {name: 'AC_DATE'             ,text:'월'                   ,type:'string' },
            {name: 'OUT_AMT_I1'          ,text:'원자재출고금액'       ,type:'int'},
            {name: 'AMT_01'              ,text:'월계'                 ,type:'int'},
            {name: 'AMT_02'              ,text:'누계'                 ,type:'int'},
            {name: 'AMT_03'              ,text:'월계'                 ,type:'int'},
            {name: 'AMT_04'              ,text:'누계'                 ,type:'int'},
            {name: 'AMT_05'              ,text:'월계'                 ,type:'int'},
            {name: 'AMT_06'              ,text:'누계'                 ,type:'int'},
            {name: 'OUT_AMT_I2'          ,text:'원자재출고금액'       ,type:'int'},
            {name: 'AMT_07'              ,text:'누계'                 ,type:'int'},
            {name: 'AMT_08'              ,text:'월계'                 ,type:'int'},
            {name: 'AMT_09'              ,text:'누계'                 ,type:'int'},
            {name: 'AMT_10'              ,text:'월계'                 ,type:'int'},
            {name: 'AMT_11'              ,text:'누계'                 ,type:'int'},
            {name: 'AMT_12'              ,text:'월계'                 ,type:'int'}
        ]
    });
    
    /**
	 * Store 정의(Service 정의)
	 * 
	 * @type
	 */                    
    var directMasterStore1 = Unilite.createStore('s_axt110skr_kdMasterStore1',{
            model: 's_axt110skr_kdModel',
            uniOpt : {
                isMaster: true,             // 상위 버튼 연결
                editable: false,            // 수정 모드 사용
                deletable:false,            // 삭제 가능 여부
                useNavi : false             // prev | newxt 버튼 사용
               
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {            
                       read: 's_axt110skr_kdService.selectList'                    
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
            items: [
               {
                fieldLabel  : '사업장',
                name        : 'DIV_CODE', 
                xtype       : 'uniCombobox',
                comboType   : 'BOR120'
            },{
                fieldLabel: '기준년도',
                xtype: 'uniYearField',
                name: 'ST_YYYY',     
                allowBlank: false,
                listeners:{
                    change:function(field, newValue, oldValue) {
                    	Ext.getCmp('date').setText(newValue-1+ '년도') ;
                    	Ext.getCmp('date2').setText(newValue+ '년도') ;
                    }
                }
            }
        ]
        
    });
    
    /**
	 * Master Grid1 정의(Grid Panel)
	 * 
	 * @type
	 */
    var masterGrid = Unilite.createGrid('s_axt110skr_kdGrid1', {
        region: 'center',
        layout: 'fit',
        uniOpt:{    
            expandLastColumn: false,     // 마지막 컬럼 * 사용 여부
            useRowNumberer: true,        // 첫번째 컬럼 순번 사용 여부
            useLiveSearch: true,         // 찾기 버튼 사용 여부
            useRowContext: false,            
            onLoadSelectFirst: true,
            filter: {                    // 필터 사용 여부
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
                 { dataIndex: 'COMP_CODE'               , width: 80, hidden : true },
                 { dataIndex: 'AC_DATE'               , width: 80,align:'center',
                    renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
                        return  val.substring(0,4) + '.' + val.substring(4,6);
                    }
                 },
                 
                 {id:'date',
                  text: new Date().getFullYear().toString()-1+'년도',
                	 columns:[
                         { dataIndex: 'OUT_AMT_I1'         , width: 133},
                         {text: '(동)비철매출',
                             columns:[
                             {dataIndex: 'AMT_01'          , width: 100 },
                             {dataIndex: 'AMT_02'          , width: 100 }
                         ]},
                         {text: 'SUS외 고철매출',
                             columns:[
                             {dataIndex: 'AMT_03'          , width: 100 },
                             {dataIndex: 'AMT_04'          , width: 100 }
                         ]},
                         {text: '매출총합계',
                             columns:[
                             {dataIndex: 'AMT_05'          , width: 100 },
                             {dataIndex: 'AMT_06'          , width: 100 }
                         ]}
                     ]
                 },
                 {id:'date2',
                  text: new Date().getFullYear().toString()+'년도',
                     columns:[
                         { dataIndex: 'OUT_AMT_I2'           , width: 133},
                         {text: '(동)비철매출',
                             columns:[
                             {dataIndex: 'AMT_08'            , width: 100 },
                             {dataIndex: 'AMT_07'            , width: 100 }
                         ]},
                         {text: 'SUS외 고철매출',
                             columns:[
                             {dataIndex: 'AMT_10'            , width: 100 },
                             {dataIndex: 'AMT_09'            , width: 100 }
                         ]},
                         {text: '매출총합계',
                             columns:[
                             {dataIndex: 'AMT_12'            , width: 100 },
                             {dataIndex: 'AMT_11'            , width: 100 }
                         ]}
                     ]
                 }
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
        id  : 's_axt110skr_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            
            var activeSForm = panelResult;
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('ST_YYYY', new Date().getFullYear());
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
            var styyyy  = UniDate.getDbDateStr(panelResult.getValue('ST_YYYY'));
            
            //var record = masterGrid.getSelectedRecord();
            var groupUrl = "http://gw.kdg.co.kr:8070/approval/legacyGateway.hi?viewMode=docuDraft&prg_no=axt110skr&draft_no=0&sp=EXEC " 
                                   
            var spText      = 'omegaplus_kdg.unilite.USP_ACCNT_AXT110SKR_fnQuery ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" 
                            + ', ' + "'" + styyyy + "'" + ', ' + "''"
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
