<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hbo900skr_kd"  >
    <t:ExtComboStore comboType="BOR120"    pgmId="s_hbo900skr_kd"/>      <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="H032" />             <!-- 상여구분 -->
    <t:ExtComboStore comboType="AU" comboCode="H173" />             <!-- 관리구분 --> 
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
    Unilite.defineModel('s_hbo900skr_kdModel', {
        fields: [
            {name: 'PERSON_NUMB'           	, text:'사번'         	, type : 'string'},
            {name: 'NAME'             		, text:'사원명'          	, type : 'string'},
            {name: 'PAY_YYYYMM'             , text:'지급월'          	, type : 'string'},
            {name: 'DEPT_NAME'				, text: '부서'			, type : 'string'},
			{name: 'POST_NAME'				, text: '직위'			, type : 'string'},
			{name: 'PAY_CODE'				, text: '급여지급방식'		, type : 'string'},
			{name: 'BONUS_KIND'				, text: '상여구분자'		, type : 'string', comboType: "AU", comboCode: "H037"},
			{name: 'BONUS_STD_I'			, text: '상여기준금'		, type : 'uniPrice'},
			{name: 'SUPP_TOTAL_I'			, text: '지급액'			, type : 'uniPrice'},
			{name: 'LONG_MONTH'				, text: '근속개월'			, type : 'int' },
			{name: 'SUPP_RATE'				, text: '지급율'			, type : 'int' },
  
            {name: 'AVG_BASE_WAGE'             	, text:'평균기본급'       	, type : 'int' },
            {name: 'DED_RATE'               , text:'감율(%)'        	, type : 'int' },
            {name: 'DUTY_NUM'               , text:'결근계'         	, type : 'int' },
            {name: 'DUTY_TIME'              , text:'지조외계'     		, type : 'int' },
            
            {name: 'BONUS_RATE'				, text: '상여기준지급율'   	, type : 'int' },
            {name: 'FOREIGN_YN'				, text: '외국인여부'		, type : 'string'},
            {name: 'DUTY_STD_NUM'			, text: '근태기준일'   	, type : 'int' },
            {name: 'DUTY_STD_TIME'			, text: '근태기준시'   	, type : 'int' },
            {name: 'DUTY_FR_MM'				, text: '근태반영시작월'	, type : 'string'},
            {name: 'DUTY_TO_MM'				, text: '근태반영종료월'	, type : 'string'},
            {name: 'JOIN_DATE'				, text: '입사일'			, type : 'uniDate'},
            {name: 'RETR_DATE'				, text: '퇴사일'			, type : 'uniDate'}
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                    
    var directMasterStore1 = Unilite.createStore('s_hbo900skr_kdMasterStore1',{
            model: 's_hbo900skr_kdModel',
            uniOpt : {
                isMaster: false,            // 상위 버튼 연결 
                editable: false,            // 수정 모드 사용 
                deletable:false,            // 삭제 가능 여부 
                useNavi : false            // prev | newxt 버튼 사용
               
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {            
                       read: 's_hbo900skr_kdServiceImpl.selectList'                    
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
    
    Unilite.defineModel('s_hbo900skr_kdMode2', {
        fields: [
            {name: 'PERSON_NUMB'            , text:'사번'    		, type: 'string' },
            {name: 'PAY_YYYYMM'             , text:'지급월'  	    , type: 'string' },
            {name: 'BASE_WAGE'				, text: '기본급'		, type: 'uniPrice'},
			{name: 'DUTY_NUM'				, text: '결근계'		, type: 'int'},
			{name: 'DUTY_TIME'				, text: '지조외계'		, type: 'int'},
			
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                    
    var detailStore = Unilite.createStore('s_hbo900skr_kdDetailStore',{
            model: 's_hbo900skr_kdMode2',
            uniOpt : {
                isMaster: false,            // 상위 버튼 연결 
                editable: false,            // 수정 모드 사용 
                deletable:false,            // 삭제 가능 여부 
                useNavi : false            // prev | newxt 버튼 사용
               
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {            
                       read: 's_hbo900skr_kdServiceImpl.selectDetailList'                    
                }
            }
            ,loadStoreRecords : function(record)    {
                var param= record.getData();    
                console.log( param );
                this.load({
                    params : param
                });
            }
    });
    
    var panelResult = Unilite.createSearchForm('panelResultForm', {
        hidden: !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
            items: [{
                fieldLabel: '기준일자',
                xtype: 'uniMonthfield',
                name: 'PAY_YYYYMM',
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
                typeAhead: false,
                comboType:'BOR120',
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
            }),{
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
        ]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('s_hbo900skr_kdGrid1', {
        region: 'center',
        flex:0.7,
        selModel: 'rowmodel',
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
            {id: 'masterGridTotal',    ftype: 'uniSummary',         showSummaryRow: true} 
        ],
        store: directMasterStore1,
        columns:  [  { dataIndex : 'PERSON_NUMB'  		, width : 80},	
					 { dataIndex : 'NAME' 		, width : 70 },
                     { dataIndex : 'DEPT_NAME' 		, width : 100 },
                     { dataIndex : 'POST_NAME'   		, width : 100},
                     { dataIndex : 'PAY_CODE'   		, width : 90},
         			 { dataIndex : 'AVG_BASE_WAGE'			, width : 100 }, 
                     { dataIndex : 'BONUS_STD_I'		, width : 100 	, summaryType: 'sum'},
                     { dataIndex : 'BONUS_RATE'			, width : 110 }, 
         			 { dataIndex : 'SUPP_RATE'			, width : 60 }, 
                     { dataIndex : 'LONG_MONTH'			, width : 80 }, 
                     
         			 { dataIndex : 'DED_RATE'           , width : 80 },
         			 { dataIndex : 'SUPP_TOTAL_I'		, width : 100	, summaryType: 'sum'},
                     { dataIndex : 'DUTY_NUM'            , width : 80 , hidden:true},
                     { dataIndex : 'DUTY_TIME'            , width : 80 , hidden:true},
        ],
        listeners: {
        	selectionchange : function(grid, record, eOpts) {
        		if(record && record.length == 1)	{
        			detailForm.setActiveRecord(record[0]);
        			detailStore.loadStoreRecords(record[0]);
        		}
        	}
        }
    });   
    
    
    var detailForm = Unilite.createForm('detailForm', {
        region: 'east',
        disabled :false,
        layout : {type : 'uniTable', columns : 2},
        masterGrid : masterGrid,
        height : 150,
        bodyStyle : 'border-width: 0px;',
        
        border:true,
            items: [{
                fieldLabel      : '사번',
                name  : 'PERSON_NUMB',
                fieldStyle:'text-align : center',
                readOnly : true
            },{
                fieldLabel      : '이름',
                name  : 'NAME',
                fieldStyle:'text-align : center',
                readOnly : true
            },{
                fieldLabel: '입사일',
                xtype: 'uniDatefield',
                name: 'JOIN_DATE',
                labelWidth:90,
                readOnly : true
           },{
               fieldLabel: '퇴사일',
               xtype: 'uniDatefield',
               name: 'RETR_DATE',
               labelWidth:90,
               readOnly : true
           },           
            {
                fieldLabel  : '상여구분자',
                xtype       : 'uniCombobox',
                name        : 'FOREIGN_YN',
                comboType   : 'AU',
                comboCode   : 'H037',
                fieldStyle:'text-align : center',
                readOnly : true
            },
           {
                fieldLabel: '상여기준지급율',
                name:'BONUS_RATE', 
                xtype: 'uniNumberfield',
                suffixTpl :'%',
                readOnly : true
            },
            {
                xtype: 'uniMonthfield',
                fieldLabel      : '근태기준 기간',
                name  : 'DUTY_FR_MM',
                readOnly : true
            },{
            	xtype: 'uniMonthfield',
                fieldLabel      : '~',
                name  : 'DUTY_TO_MM',
                readOnly : true
            },
            {
                fieldLabel: '상여기준시',
                name:'DUTY_STD_TIME', 
                xtype: 'uniNumberfield',
                readOnly : true
            }
         ]
    });
    var detailGrid = Unilite.createGrid('s_hbo900skr_kdGrid2', {
        region: 'center',
        layout: 'fit',
        uniOpt:{    
            expandLastColumn: false,    //마지막 컬럼 * 사용 여부
            useRowNumberer: true,        //첫번째 컬럼 순번 사용 여부
            useLiveSearch: false,        //찾기 버튼 사용 여부
            useRowContext: false,            
            onLoadSelectFirst    : true,
            filter: {                    //필터 사용 여부
                useFilter: true,
                autoCreate: true
            }
        },
        store: detailStore,
        columns : [
                     { dataIndex : 'PAY_YYYYMM' 		, width : 100 },
                     { dataIndex : 'BASE_WAGE'   		, width : 100},
                     { dataIndex : 'DUTY_NUM'			, width : 80 }, 
                     { dataIndex : 'DUTY_TIME'			, width : 80 }
        ] 
    });   
    
    var detailContainer = {
    	title : '상여계산 상세정보',
    	xtype : 'panel',
    	region : 'east',
    	flex : 0.3,
    	layout: {type:'uniTable', columns:1, tableAttrs:{'style':'width:100%'}},
    	items :[
    		detailForm,
    		detailGrid
    	]
    };
    Unilite.Main({
        borderItems:[{
         region:'center',
         layout: 'border',
         border: false,
         items:[
                panelResult,
                masterGrid, 
                detailContainer
             ]
         }
        ], 
        id  : 's_hbo900skr_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('SUPP_DATE' , UniDate.get('today'));
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
            
        },
        onResetButtonDown:function() {
            panelResult.clearForm()
            masterGrid.getStore().loadData({});
            detailGrid.getStore().loadData({});
            detailForm.clearForm();
            this.fnInitBinding();
        },
        
        requestApprove: function(){     //결재 요청
            var gsWin = window.open('about:blank','payviewer','width=500,height=500');
            
            var frm           = document.f1;
            var compCode      = UserInfo.compCode;
            var divCode       = panelResult.getValue('DIV_CODE');
            var userId        = UserInfo.userID
            var stdate        = UniDate.getDbDateStr(panelResult.getValue('PAY_YYYYMM'))+'01';
            var deptcodefr    = panelResult.getValue('DEPT_CODE_FR');
            var deptcodeto    = panelResult.getValue('DEPT_CODE_TO');
            var personnumbfr  = panelResult.getValue('PERSON_NUMB_FR');
            var personnumbto  = panelResult.getValue('PERSON_NUMB_TO');
            var rpttype       = panelResult.getValue('REPORT_TYPE');
            var supptype      = panelResult.getValue('SUPP_TYPE');
                        
            var groupUrl    = "http://gw.kdg.co.kr:8070/approval/legacyGateway.hi?viewMode=docuDraft&prg_no=hbo900skr&draft_no=0&sp=EXEC " 

            var spText      = 'omegaplus_kdg.unilite.USP_HUMAN_HBO900SKR_fnQuery ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + stdate + "'" 
                            + ', ' + "'" + deptcodefr + "'" + ', ' + "'" + deptcodeto + "'" + ', ' + "'" + personnumbfr + "'" + ', ' + "'" + personnumbto + "'"  
                            + ', ' + "'" + rpttype + "'" + ', ' + "'" + supptype + "'" + ', ' + "''" + ', ' + "'" + userId + "'" + ', ' + "'ko'" + ', ' + "''";
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