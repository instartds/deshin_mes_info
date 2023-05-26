<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hat930skr"  >
    <t:ExtComboStore comboType="BOR120"    pgmId="hat930skr"/>             <!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {
	
	var groupUrl = '${groupUrl}'; //그룹웨어 호출 url
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('hat930skrModel', {
        fields: [
            {name: 'COMP_CODE'                 ,text:'법인코드'                  ,type:'string' },
            {name: 'PERSON_NUMB'               ,text:'사원번호'                  ,type:'string' },
            {name: 'NAME'                      ,text:'성명'                    ,type:'string' },
            {name: 'DEPT_CODE'                 ,text:'부서코드'                  ,type:'string' },
            {name: 'DEPT_NAME'                 ,text:'부서명'                   ,type:'string' },
            {name: 'ABIL_CODE'                 ,text:'직위코드'                  ,type:'string' },
            {name: 'ABIL_NAME'                 ,text:'직위명'                   ,type:'string' },
            {name: 'WORK_YEAR_CNT'             ,text:'근무연수'                  ,type:'string' },
            {name: 'YEAR_SAVE'                 ,text:'기본연차'                  ,type:'string' },
            {name: 'YEAR_BONUS_I'              ,text:'근속연수추가연차'              ,type:'string' },
            {name: 'YEAR_NUM'                  ,text:'연차합계'                  ,type:'string' },
            {name: 'YEAR_USE'                  ,text:'총사용일수'                 ,type:'string' },
            {name: 'CHOICE_USE'                ,text:'기본사용외일수'               ,type:'string' },
            {name: 'YEAR_CNT'                  ,text:'미사용연차일수'               ,type:'string' },
            {name: 'DAY_AMOUNT_I'              ,text:'일급'                     ,type:'string' },
            {name: 'YEAR_CNT_AMOUNT_I'         ,text:'미사용연차수당'               ,type:'string' },
            {name: 'REMARK'                    ,text:'비고'                     ,type:'string' }
            
            
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                    
    var directMasterStore1 = Unilite.createStore('hat930skrMasterStore1',{
            model: 'hat930skrModel',
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
                       read: 'hat930skrServiceImpl.selectList'                    
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
//					var count = masterGrid.getStore().getCount();  
//					if(count > 0){
//						Ext.getCmp('GW').setDisabled(false);
//						
//						UniAppManager.setToolbarButtons('reset',true);
//					}else{
//						Ext.getCmp('GW').setDisabled(true);
//						
//						UniAppManager.setToolbarButtons('reset',false);
//					}
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
                fieldLabel: '기준년도',
                name:'DUTY_YYYY', 
                xtype: 'uniYearField', 
                allowBlank:false,
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
            })
//            	{
//                fieldLabel: '연차사용일수',
//                xtype: 'uniNumberfield',
//                name: 'STD_USE_CNT'
//            }
            ]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hat930skrGrid1', {
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
        
//        tbar: [
//        	{
//                itemId : 'GWBtn',
//                id:'GW',
//                iconCls : 'icon-referance'  ,
//                text:'기안',
//                handler: function() {
//                    var param = panelResult.getValues();
//                    
//                    if(!UniAppManager.app.isValidSearchForm()){
//                        return false;
//                    }
//                
//                    if(confirm('기안 하시겠습니까?')) {
//                       UniAppManager.app.requestApprove();
//                    }
//                }
//            }
//        ],
        
        features: [ 
            {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
            {id: 'masterGridTotal',    ftype: 'uniSummary',         showSummaryRow: false} 
        ],
        store: directMasterStore1,
        columns:  [  { dataIndex: 'COMP_CODE'                , width: 77, hidden:true},                     
                     { dataIndex: 'PERSON_NUMB'              , width: 90},
                     { dataIndex: 'NAME'                     , width: 130},
                     { dataIndex: 'DEPT_CODE'                , width: 100},
                     { dataIndex: 'DEPT_NAME'                , width: 100},
                     { dataIndex: 'ABIL_CODE'                , width: 100},
                     { dataIndex: 'ABIL_NAME'                , width: 100},
                     { dataIndex: 'WORK_YEAR_CNT'            , width: 100},
                     { dataIndex: 'YEAR_SAVE'                , width: 100},
                     { dataIndex: 'YEAR_BONUS_I'             , width: 100},
                     { dataIndex: 'YEAR_NUM'                 , width: 100},
                     { dataIndex: 'YEAR_USE'                 , width: 100},
                     { dataIndex: 'CHOICE_USE'               , width: 100},
                     { dataIndex: 'YEAR_CNT'                 , width: 100},
                     { dataIndex: 'DAY_AMOUNT_I'             , width: 100},
                     { dataIndex: 'YEAR_CNT_AMOUNT_I'        , width: 100},
                     { dataIndex: 'REMARK'                   , width: 100}
                    
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
        id  : 'hat930skrApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE'     ,UserInfo.divCode);
            panelResult.setValue('DUTY_YYYY' 	, new Date().getFullYear());
            panelResult.setValue('STD_USE_CNT'    ,0);
            
            UniAppManager.setToolbarButtons('detail',false);
            UniAppManager.setToolbarButtons('reset',false);
            UniAppManager.setToolbarButtons('save',false);
            
            //Ext.getCmp('GW').setDisabled(true);
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
            var deptcodefr    = panelResult.getValue('DEPT_CODE_FR');
            var deptcodeto    = panelResult.getValue('DEPT_CODE_TO');
            var personnumbfr    = panelResult.getValue('PERSON_NUMB_FR');
            var personnumbto    = panelResult.getValue('PERSON_NUMB_TO');
            var stdusecnt    = panelResult.getValue('STD_USE_CNT');
            var dutyyyyy      = UniDate.getDbDateStr(panelResult.getValue('DUTY_YYYY'));
            
            
            
            var spText      = 'omegaplus_kdg.unilite.USP_HUMAN_HAT930SKR_fnQuery ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + deptcodefr + "'"
                            + ', ' + "'" + deptcodeto + "'"+ ', ' + "'" + personnumbfr + "'"+ ', ' + "'" + personnumbto + "'"+ ', ' + "'" + dutyyyyy + "'" 
                            + ', ' + "'" + stdusecnt + "'" + ', ' + "''" + ', ' + "'" + userId + "'" + ', ' + "'ko'" + ', ' + "''";
            var spCall      = encodeURIComponent(spText); 
            
            //var groupUrl = "http://58.151.163.201:8070/approval/legacyGateway.hi?viewMode=docuDraft&prg_no=hat930skr&draft_no=0&sp=EXEC "
            var gwurl = groupUrl + "viewMode=docuDraft&prg_no=hat930skr&draft_no=0&sp=EXEC ";

            frm.action   = gwurl + spCall/* + Base64.encode()*/;
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
