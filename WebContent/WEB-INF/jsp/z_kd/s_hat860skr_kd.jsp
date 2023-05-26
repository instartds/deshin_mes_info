<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hat860skr_kd">
    <t:ExtComboStore comboType="AU" comboCode="H024" />                 <!-- 사원구분 -->
    <t:ExtComboStore comboType="AU" comboCode="HX14" />                    <!-- 출력구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
.red-font-color {
	color:red;
}
</style>
<script type="text/javascript" >

function appMain() {

    /**
     *   Model 정의
     * @type
     */
    Unilite.defineModel('S_Hat860skr_kdModel', {
        fields: [
            {name: 'DUTY_YYYYMMDD'         ,text:'일자'            ,type:'string'},
            {name: 'DAY_NAME'              ,text:'요일'            ,type:'string'},
            {name: 'DUTY_FR_TIME'          ,text:'출근'            ,type:'string'},
            {name: 'DUTY_TO_TIME'          ,text:'퇴근'            ,type:'string'},
            {name: 'OUT_TIME'              ,text:'외출'            ,type:'string'},
            {name: 'IN_TIME'               ,text:'귀사'            ,type:'string'},
            {name: 'DUTY_CODE1'            ,text:'근태1'           ,type:'string'},
            {name: 'DUTY_CODE2'            ,text:'근태2'           ,type:'string'},
            {name: 'DUTY_CODE3'            ,text:'근태3'           ,type:'string'},
            {name: 'DUTY_CODE4'            ,text:'근태4'           ,type:'string'},
            {name: 'SCHSHIP_NAME'          ,text:'비고'            ,type:'string'},
            {name: 'COMP_CODE'             ,text:'법인코드'        ,type:'string'},
            {name: 'PERSON_NUMB'           ,text:'사번'            ,type:'string'},
            {name: 'PERSON_NAME'           ,text:'성명'            ,type:'string'},
            {name: 'JOIN_DATE'             ,text:'입사일'          ,type:'string'},
            {name: 'RETR_DATE'             ,text:'퇴사일'          ,type:'string'},
            {name: 'DEPT_CODE'             ,text:'부서코드'        ,type:'string'},
            {name: 'DEPT_NAME'             ,text:'부서명'          ,type:'string'},
            {name: 'EMPLOY_TYPE'           ,text:'사원유형'        ,type:'string'},
            {name: 'EMPLOY_NAME'           ,text:'유형명'          ,type:'string'},
            {name: 'DUTY_CODE_02'          ,text:'추가연장'        ,type:'string'},
            {name: 'DUTY_CODE_04'          ,text:'야간근무'        ,type:'string'},
            {name: 'DUTY_CODE_61'          ,text:'연차'            ,type:'string'},
            {name: 'DUTY_CODE_51'          ,text:'유급휴가'        ,type:'string'},
            {name: 'DUTY_CODE_52'          ,text:'무급휴가'        ,type:'string'},
            {name: 'DUTY_CODE_90'          ,text:'토요무급'        ,type:'string'},
            {name: 'DUTY_CODE_011'         ,text:'연장무급'        ,type:'string'},
            {name: 'DUTY_CODE_21'          ,text:'평일결근'        ,type:'string'},
            {name: 'DUTY_CODE_91'          ,text:'토요결근'        ,type:'string'},
            {name: 'DUTY_CODE_06'          ,text:'지조외합'        ,type:'string'},
            {name: 'DUTY_CODE_23'          ,text:'공상결근'        ,type:'string'},
            {name: 'DUTY_CODE_54'          ,text:'휴직'            ,type:'string'},
            {name: 'DUTY_CODE_TIME'        ,text:'정상시간'        ,type:'string'},
            {name: 'DUTY_CODE_01'          ,text:'연장시간'        ,type:'string'},
            {name: 'DUTY_CODE_HOLIDAY'     ,text:'주휴일수'        ,type:'string'},
            {name: 'WORK_TIME'    		   ,text:'주휴일수'        ,type:'string', defaultValue:'0'}
        ]
    });

    /**
     *   Model 정의
     * @type
     */
    Unilite.defineModel('S_Hat860skr_kdModel2', {
        fields: [
            {name: 'COMP_CODE'             ,text:'회사코드'        ,type:'string'},
            {name: 'DUTY_YYYYMM'           ,text:'일자'            ,type:'string'},
            {name: 'PERSON_NUMB'           ,text:'사번'            ,type:'string'},
            {name: 'DUTY_CODE_02'          ,text:'추가연장'        ,type:'string', defaultValue:'0'},
            {name: 'DUTY_CODE_04'          ,text:'야간근무'        ,type:'string', defaultValue:'0'},
            {name: 'DUTY_CODE_61'          ,text:'연차'            ,type:'string', defaultValue:'0'},
            {name: 'DUTY_CODE_51'          ,text:'유급휴가'        ,type:'string', defaultValue:'0'},
            {name: 'DUTY_CODE_52'          ,text:'무급휴가'        ,type:'string', defaultValue:'0'},
            {name: 'DUTY_CODE_90'          ,text:'토요무급'        ,type:'string', defaultValue:'0'},
            {name: 'DUTY_CODE_011'         ,text:'연장무급'        ,type:'string', defaultValue:'0'},
            {name: 'DUTY_CODE_21'          ,text:'평일결근'        ,type:'string', defaultValue:'0'},
            {name: 'DUTY_CODE_91'          ,text:'토요결근'        ,type:'string', defaultValue:'0'},
            {name: 'DUTY_CODE_06'          ,text:'지조외합'        ,type:'string', defaultValue:'0'},
            {name: 'DUTY_CODE_23'          ,text:'공상결근'        ,type:'string', defaultValue:'0'},
            {name: 'DUTY_CODE_54'          ,text:'휴직'            ,type:'string', defaultValue:'0'},
            {name: 'DUTY_CODE_TIME'        ,text:'점심시간'        ,type:'string', defaultValue:'0'},
            {name: 'DUTY_CODE_01'          ,text:'연장시간'        ,type:'string', defaultValue:'0'},
            {name: 'DUTY_CODE_HOLIDAY'     ,text:'주휴일수'        ,type:'string', defaultValue:'0'}
        ]
    });

    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directMasterStore1 = Unilite.createStore('s_hat860skr_kdMasterStore1',{
        model: 'S_Hat860skr_kdModel',
        uniOpt : {
            isMaster: true,             // 상위 버튼 연결
            editable: false,            // 수정 모드 사용
            deletable:false,            // 삭제 가능 여부
            useNavi : false             // prev | newxt 버튼 사용
        }
        ,autoLoad: false
        ,proxy: {
            type: 'direct',
            api: {
                   read: 's_Hat860skr_kdServiceImpl.selectList'
            }
        }
        ,loadStoreRecords : function()    {
            var param= Ext.getCmp('panelResultForm').getValues();
            console.log( param );
            this.load({
                params : param
            });
        }
        ,listeners: {
            load: function(store, records, successful, eOpts) {
                var count = masterGrid.getStore().getCount();
                if(count > 0){
                    detailForm.setActiveRecord(records[0]);
                    Ext.getCmp('GW').setDisabled(false);
                }else{
                    Ext.getCmp('GW').setDisabled(true);
                }

            }
        },
		groupField:  'PERSON_NAME'
    });

    var directMasterStore2 = Unilite.createStore('s_hat860skr_kdMasterStore2', {
        model: 'S_Hat860skr_kdModel2',
        uniOpt: {
            isMaster: false,            // 상위 버튼 연결
            editable: false,            // 수정 모드 사용
            deletable: false,           // 삭제 가능 여부
            useNavi: false              // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
                read: 's_Hat860skr_kdServiceImpl.selectList'
            }
        },
        loadStoreRecords: function(){
        	var param= Ext.getCmp('panelResultForm').getValues();
            console.log( param );
            this.load({
                params : param
            });
        },
        listeners: {
            load: function(store, records) {
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
        layout : {type : 'uniTable', columns : 4},
        padding:'1 1 1 1',
        border:true,
        items: [
            {
                fieldLabel: '근태년월',
                id: 'frToDate',
                xtype: 'uniMonthfield',
                name: 'DUTY_MONTH',
                value: new Date(),
                allowBlank: false

            }, Unilite.popup('Employee',{
                fieldLabel: '사원',
                valueFieldName:'PERSON_NUMB_FR',
                textFieldName:'NAME',
                colspan:2,
                validateBlank:false,
                autoPopup:true,
                allowBlank: false,
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                        	panelResult2.setValue('S_DEPT_CODE', records[0].DEPT_CODE);
                        	panelResult2.setValue('S_DEPT_NAME', records[0].DEPT_NAME);
                            panelResult2.setValue('S_EMPLOY_TYPE', records[0].EMPLOY_TYPE);
                        	panelResult2.setValue('S_JOIN_DATE', records[0].JOIN_DATE);
                        	panelResult2.setValue('S_RETR_DATE', records[0].RETR_DATE);
                        },
                        scope: this
                    },
                    onClear: function(type)    {
                    	panelResult.setValue('PERSON_NUMB_FR', '');
                        panelResult.setValue('NAME', '');
                    },
                    onValueFieldChange: function(field, newValue){
                    	panelResult.setValue('PERSON_NUMB_TO', newValue);
                    },
                    onTextFieldChange: function(field, newValue){
                    	panelResult.setValue('NAME1', newValue);
                    }
                }
            }),Unilite.popup('Employee',{
                fieldLabel: '~',
                valueFieldName:'PERSON_NUMB_TO',
                textFieldName:'NAME1',
                validateBlank:false,
                autoPopup:true,
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            panelResult2.setValue('S_DEPT_CODE', records[0].DEPT_CODE);
                            panelResult2.setValue('S_DEPT_NAME', records[0].DEPT_NAME);
                            panelResult2.setValue('S_EMPLOY_TYPE', records[0].EMPLOY_TYPE);
                            panelResult2.setValue('S_JOIN_DATE', records[0].JOIN_DATE);
                            panelResult2.setValue('S_RETR_DATE', records[0].RETR_DATE);
                        },
                        scope: this
                    },
                    onClear: function(type)    {
                    	panelResult.setValue('PERSON_NUMB_TO', '');
                        panelResult.setValue('NAME1', '');
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }),
            {
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

    var panelResult2 = Unilite.createSearchForm('panelDetailForm',{
        padding:'0 1 0 1',
        layout : {type : 'uniTable', columns : 4},
        border:true,
        region: 'center',
        items: [
                {
                    xtype: 'container',
                    layout: {type : 'uniTable', columns : 2},
                    width:300,
                    items :[{
                        fieldLabel:'부서',
                        xtype: 'uniTextfield',
                        name: 'S_DEPT_CODE',
                        width: 170,
                        readOnly : true,
                        listeners: {
                            change: function(field, newValue, oldValue, eOpts) {
                                //panelResult.setValue('S_DEPT_CODE', newValue);
                            }
                        }
                    },{
                        fieldLabel:'',
                        xtype: 'uniTextfield',
                        name: 'S_DEPT_NAME',
                        width: 130,
                        readOnly : true,
                        listeners: {
                            change: function(field, newValue, oldValue, eOpts) {
                                //panelResult.setValue('S_DEPT_NAME', newValue);
                            }
                        }
                    }]
                },{
                    fieldLabel: '업무구분',
                    name:'S_EMPLOY_TYPE',
                    xtype: 'uniCombobox',
                    comboType:'AU',
                    comboCode:'H024',
                    readOnly : true,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            //panelSearch.setValue('GRAD_GUBUN', newValue);
                        }
                    }
                },{
                    fieldLabel: '입사일자',
                    id: 'joinDate',
                    xtype: 'uniDatefield',
                    name: 'S_JOIN_DATE',
                    readOnly : true,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            //panelResult.setValue('S_JOIN_DATE', newValue);
                        }
                    }
                },
                {
                    fieldLabel: '퇴사일자',
                    id: 'retrDate',
                    xtype: 'uniDatefield',
                    name: 'S_RETR_DATE',
                    readOnly : true,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            //panelResult.setValue('S_RETR_DATE', newValue);
                        }
                    }
                }
           ]
    });

    var detailForm = Unilite.createSearchForm('detailForm',{
        padding:'1 1 1 1',
        flex: 2,
        border:true,
        region: 'center',
        layout : {type : 'uniTable', columns : 1},
        masterGrid: masterGrid,
        items: [{
            xtype:'container',
            defaultType: 'uniTextfield',
            flex: 1,
            layout: {
                type: 'uniTable',
                columns : 5
            },
            defaults: { labelWidth: 150, readOnly: true, fieldStyle: "text-align:right;"},
            items: [
                {
                    xtype: 'uniTextfield',
                    fieldLabel: '추가연장',
                    name: 'DUTY_CODE_02',
                    value: 0

                },
                {
                    xtype: 'uniTextfield',
                    fieldLabel: '야간근무',
                    name: 'DUTY_CODE_04',
                    value: 0
                },
                {
                	xtype: 'uniTextfield',
                    fieldLabel: '연차',
                    name: 'DUTY_CODE_61',
                    value: 0
                },
                {
                    xtype: 'uniTextfield',
                    fieldLabel: '유급휴가',
                    name: 'DUTY_CODE_51',
                    value: 0
                },
                {
                    xtype: 'uniTextfield',
                    fieldLabel: '무급휴가',
                    name: 'DUTY_CODE_52',
                    value: 0
                },
                {
                	xtype: 'uniTextfield',
                    fieldLabel: '토요무급',
                    name: 'DUTY_CODE_90',
                    value: 0
                },
                {
                    xtype: 'uniTextfield',
                    fieldLabel: '연장무급',
                    name: 'DUTY_CODE_011',
                    value: 0
                },
                {
                    xtype: 'uniTextfield',
                    fieldLabel: '평일결근',
                    name: 'DUTY_CODE_21',
                    value: 0
                },
                {
                	xtype: 'uniTextfield',
                    fieldLabel: '토요결근',
                    name: 'DUTY_CODE_91',
                    value: 0
                },
                {
                    xtype: 'uniTextfield',
                    fieldLabel: '지조외합',
                    name: 'DUTY_CODE_06',
                    value: 0
                },
                {
                    xtype: 'uniTextfield',
                    fieldLabel: '공상결근',
                    name: 'DUTY_CODE_23',
                    value: 0
                },
                {
                    xtype: 'uniTextfield',
                    fieldLabel: '휴직',
                    name: 'DUTY_CODE_54',
                    value: 0
                },
                {
                    xtype: 'uniTextfield',
                    fieldLabel: '정상시간',
                    name: 'WORK_TIME',
                    value: 0
                },
                {
                    xtype: 'uniTextfield',
                    fieldLabel: '연장시간',
                    name: 'DUTY_CODE_01',
                    value: 0
                },
                {
                    xtype: 'uniTextfield',
                    fieldLabel: '주휴일수',
                    name: 'DUTY_CODE_HOLIDAY',
                    value: 0
                }
            ]
        }]
        , api: {
            load: 's_Hat860skr_kdServiceImpl.selectList'
        }

    });


    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
    var masterGrid = Unilite.createGrid('s_hat860skr_kdGrid1', {
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
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	          	if(record.get('DAY_NAME') == '일요일' || record.get('DAY_NAME') == '토요일' ) {	//소계
					cls = 'red-font-color';
				}
				return cls;
	        }
	    },
        features: [
            {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
            {id: 'masterGridTotal',    ftype: 'uniSummary',         showSummaryRow: false}
        ],
        store: directMasterStore1,
        columns:  [  { dataIndex: 'PERSON_NUMB'            , width: 150 },
                     { dataIndex: 'PERSON_NAME'            , width: 150 },
        	         { dataIndex: 'DUTY_YYYYMMDD'         , width: 80     , align:'center'},
                     { dataIndex: 'DAY_NAME'              , width: 100    , align:'center'},
                     { dataIndex: 'DUTY_FR_TIME'          , width: 80     , align:'center'},
                     { dataIndex: 'DUTY_TO_TIME'          , width: 80     , align:'center'},
                     { dataIndex: 'OUT_TIME'              , width: 80     , align:'center'},
                     { dataIndex: 'IN_TIME'               , width: 80     , align:'center'},
                     { dataIndex: 'DUTY_CODE1'            , width: 150    },
                     { dataIndex: 'DUTY_CODE2'            , width: 150    },
                     { dataIndex: 'DUTY_CODE3'            , width: 150    },
                     { dataIndex: 'DUTY_CODE4'            , width: 150    },

                     { dataIndex: 'DUTY_CODE_02'          ,width: 80 , hidden : true},
                     { dataIndex: 'DUTY_CODE_04'          ,width: 80 , hidden : true},
                     { dataIndex: 'DUTY_CODE_61'          ,width: 80 , hidden : true},
                     { dataIndex: 'DUTY_CODE_51'          ,width: 80 , hidden : true},
                     { dataIndex: 'DUTY_CODE_52'          ,width: 80 , hidden : true},
                     { dataIndex: 'DUTY_CODE_90'          ,width: 80 , hidden : true},
                     { dataIndex: 'DUTY_CODE_011'         ,width: 80 , hidden : true},
                     { dataIndex: 'DUTY_CODE_21'          ,width: 80 , hidden : true},
                     { dataIndex: 'DUTY_CODE_91'          ,width: 80 , hidden : true},
                     { dataIndex: 'DUTY_CODE_06'          ,width: 80 , hidden : true},
                     { dataIndex: 'DUTY_CODE_23'          ,width: 80 , hidden : true},
                     { dataIndex: 'DUTY_CODE_54'          ,width: 80 , hidden : true},
                     { dataIndex: 'DUTY_CODE_TIME'        ,width: 80 , hidden : true},
                     { dataIndex: 'DUTY_CODE_01'          ,width: 80 , hidden : true},
                     { dataIndex: 'DUTY_CODE_HOLIDAY'     ,width: 80 , hidden : true},
                     { dataIndex: 'WORK_TIME'     ,width: 80 , hidden : true}
        ] ,
        listeners:{
        	uniOnChange: function(grid, dirty, eOpts) {
            },
            cellclick: function(grid, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
            	if(record){
            		detailForm.setActiveRecord(record);
            	}
            	/* if(Ext.isEmpty(record.get('DUTY_CODE_02'))){
            		detailForm.setValue('DUTY_CODE_02', 0);
            	}else{
            		detailForm.setValue('DUTY_CODE_02', record.get('DUTY_CODE_02')  );
            	}if(Ext.isEmpty(record.get('DUTY_CODE_04'))){
                    detailForm.setValue('DUTY_CODE_04', 0);
                }else{
                    detailForm.setValue('DUTY_CODE_04', record.get('DUTY_CODE_04')  );
                }if(Ext.isEmpty(record.get('DUTY_CODE_61'))){
                    detailForm.setValue('DUTY_CODE_61', 0);
                }else{
                    detailForm.setValue('DUTY_CODE_61', record.get('DUTY_CODE_61')  );
                }if(Ext.isEmpty(record.get('DUTY_CODE_51'))){
                    detailForm.setValue('DUTY_CODE_51', 0);
                }else{
                    detailForm.setValue('DUTY_CODE_51', record.get('DUTY_CODE_51')  );
                }if(Ext.isEmpty(record.get('DUTY_CODE_52'))){
                    detailForm.setValue('DUTY_CODE_52', 0);
                }else{
                    detailForm.setValue('DUTY_CODE_52', record.get('DUTY_CODE_52')  );
                }if(Ext.isEmpty(record.get('DUTY_CODE_90'))){
                    detailForm.setValue('DUTY_CODE_90', 0);
                }else{
                    detailForm.setValue('DUTY_CODE_90', record.get('DUTY_CODE_90')  );
                }if(Ext.isEmpty(record.get('DUTY_CODE_011'))){
                    detailForm.setValue('DUTY_CODE_011', 0);
                }else{
                    detailForm.setValue('DUTY_CODE_011', record.get('DUTY_CODE_011')  );
                }if(Ext.isEmpty(record.get('DUTY_CODE_21'))){
                    detailForm.setValue('DUTY_CODE_21', 0);
                }else{
                    detailForm.setValue('DUTY_CODE_21', record.get('DUTY_CODE_21')  );
                }if(Ext.isEmpty(record.get('DUTY_CODE_91'))){
                    detailForm.setValue('DUTY_CODE_91', 0);
                }else{
                    detailForm.setValue('DUTY_CODE_91', record.get('DUTY_CODE_91')  );
                }if(Ext.isEmpty(record.get('DUTY_CODE_06'))){
                    detailForm.setValue('DUTY_CODE_06', 0);
                }else{
                    detailForm.setValue('DUTY_CODE_06', record.get('DUTY_CODE_06')  );
                }if(Ext.isEmpty(record.get('DUTY_CODE_23'))){
                    detailForm.setValue('DUTY_CODE_23', 0);
                }else{
                    detailForm.setValue('DUTY_CODE_23', record.get('DUTY_CODE_23')  );
                }if(Ext.isEmpty(record.get('DUTY_CODE_54'))){
                    detailForm.setValue('DUTY_CODE_54', 0);
                }else{
                    detailForm.setValue('DUTY_CODE_54', record.get('DUTY_CODE_54')  );
                }if(Ext.isEmpty(record.get('WORK_TIME'))){
                    detailForm.setValue('WORK_TIME', 0);
                }else{
                    detailForm.setValue('DUTY_CODE_TIME', record.get('DUTY_CODE_TIME')  );
                }if(Ext.isEmpty(record.get('DUTY_CODE_01'))){
                    detailForm.setValue('DUTY_CODE_01', 0);
                }else{
                    detailForm.setValue('DUTY_CODE_01', record.get('DUTY_CODE_01')  );
                }if(Ext.isEmpty(record.get('DUTY_CODE_HOLIDAY'))){
                    detailForm.setValue('DUTY_CODE_HOLIDAY', 0);
                }else{
                    detailForm.setValue('DUTY_CODE_HOLIDAY', record.get('DUTY_CODE_HOLIDAY')  );
                } */

            }
        }
    });

    Unilite.Main({
        borderItems:[{
          region:'center',
          layout: {type: 'vbox', align: 'stretch'},
          border: false,
          items:[
                panelResult, panelResult2, masterGrid,
                {   xtype: 'container',
                    region: 'south',
                    layout: {type: 'hbox'},
                    items:[
                        detailForm
                    ]
                }
             ]
          }
        ],
        id  : 's_hat860skr_kdApp',
        fnInitBinding : function() {
            //panelResult.setValue('DIV_CODE', UserInfo.divCode);

            var activeSForm ;
            activeSForm = panelResult;
            activeSForm.onLoadSelectText('DUTY_MONTH');

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

            var param = Ext.getCmp('panelResultForm').getValues();

            detailForm.getForm().load({
                params: param,
                success:function(batch, option)  {
                },
                failure: function(batch, option) {
                }
            })
        },
        onResetButtonDown:function() {
            panelResult.clearForm();
            masterGrid.getStore().loadData({});

            this.fnInitBinding();
        },
        requestApprove: function(){     //결재 요청
            var gsWin = window.open('about:blank','payviewer','width=1100,height=750');

            var frm         = document.f1;
            var compCode    = UserInfo.compCode;
            var divCode     = panelResult.getValue('DIV_CODE');
            var userId      = UserInfo.userID

            //var record = masterGrid1.getSelectedRecord();

            var month      = UniDate.getDbDateStr(panelResult.getValue('DUTY_MONTH')).substring(0, 6);
            var personNumbfr = panelResult.getValue('PERSON_NUMB_FR');
            var personNumbto = panelResult.getValue('PERSON_NUMB_TO');
            var rpttype      = panelResult.getValue('REPORT_TYPE');
            if(Ext.isEmpty(rpttype)){
            	rpttype = '';
            }
            //var stDate      = masterGrid1.getValue("JOIN_DATE")

            var spText      = 'omegaplus_kdg.unilite.USP_HUMAN_hat860skr_fnQuery ' + "'" + compCode + "'" + ', ' + "'" + month + "'"
                            + ', ' + "'" + personNumbfr + "'" +', ' + "'" + personNumbto + "'"
                            + ', ' + "'" + rpttype + "'" + ', ' + "''" + ', ' + "'" + userId + "'" + ', ' + "'ko'" + ', ' + "''";
            console.log('[spText]' + spText)
            var spCall      = encodeURIComponent(spText);

            var groupUrl = "http://gw.kdg.co.kr:8070/approval/legacyGateway.hi?viewMode=docuDraft&prg_no=hat860skr&draft_no=0&sp=EXEC "

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
