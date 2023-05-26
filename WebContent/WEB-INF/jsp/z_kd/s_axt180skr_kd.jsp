<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_axt180skr_kd"  >
    <t:ExtComboStore comboType="BOR120"    pgmId="s_axt180skr_kd"/>             <!-- 사업장 -->
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
    Unilite.defineModel('s_axt180skr_kdModel', {
        fields: [
            {name: 'COMP_CODE'                  ,text:'법인코드'        ,type:'string'},
            {name: 'DEPT_CODE'                  ,text:'부서코드'          ,type:'string' },
            {name: 'DEPT_NAME'                  ,text:'부서명'            ,type:'string'},
            {name: 'PERSON_NUMB'                ,text:'사원번호'            ,type:'string'},
            {name: 'PERSON_NAME'                ,text:'성명'            ,type:'string'},
            {name: 'JOIN_DATE'                  ,text:'입사일자'            ,type:'string'},
            {name: 'LONG_TOT_DAY'               ,text:'근속일'            ,type:'int'},
            {name: 'PAY_TOTAL_I'                ,text:'급여'            ,type:'uniPrice'},
            {name: 'BONUS_SUM'                  ,text:'상여'            ,type:'uniPrice'},
            {name: 'PAY_AMT_SUM'                ,text:'계'                       ,type:'uniPrice'},
            {name: 'AVG_PAY_3'                  ,text:'최근3개월급여'            ,type:'uniPrice'},
            {name: 'BONUS_SUM_3'                ,text:'최근3개월상여'         ,type:'uniPrice'},
            {name: 'DAY_3'                      ,text:'일수'                  ,type:'int'},
            {name: 'AVG_DAY'                    ,text:'일평균급여'               ,type:'uniPrice'},
            {name: 'AVG_WAGES_I'                ,text:'충당금'                 ,type:'uniPrice'},
            {name: 'REMARK'                     ,text:'비고'                  ,type:'string'}
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                    
    var directMasterStore1 = Unilite.createStore('s_axt180skr_kdMasterStore1',{
            model: 's_axt180skr_kdModel',
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
                       read: 's_axt180skr_kdService.selectList'                    
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
            items: [/*{
                    fieldLabel        : '기준일자',
                    xtype             : 'uniDateRangefield',
                    startFieldName    : 'FR_DATE',
                    endFieldName      : 'TO_DATE',
                    startDate         : UniDate.get('startOfMonth'),
                    endDate           : UniDate.get('today'),
                    allowBlank        : false,          
                    tdAttrs           : {width: 350},
                    width             : 315,
                    onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    },
                    onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    }
              }*/
              {
				fieldLabel: '기준일자',
				xtype: 'uniDatefield',
				name: 'ST_DATE',                
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DUTY_YYYYMMDD', newValue);
					}
				}
			  },
	          {
	                fieldLabel: '사업장',
	                name:'DIV_CODE', 
	                xtype: 'uniCombobox',
					colspan: 2,
	                //multiSelect: true, 
	                typeAhead: false,
	                comboType:'BOR120',
	                width: 325,
	                listeners: {
	                    change: function(field, newValue, oldValue, eOpts) {                        
	                    }
	                }
	           },			
		     	Unilite.popup('Employee',{ 
					
					validateBlank: false,
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('PERSON_NUMB', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('NAME', newValue);				
						}
					}
				}),
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
            })
            ]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('s_axt180skr_kdGrid1', {
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
            {id: 'masterGridTotal',    ftype: 'uniSummary',         showSummaryRow: true} 
        ],
        store: directMasterStore1,
        columns:  [  
                 { dataIndex: 'DEPT_CODE'               , width: 80,
                 	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
						return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
					}
                 },
                 { dataIndex: 'DEPT_NAME'               , width: 80},
                 { dataIndex: 'PERSON_NUMB'               , width: 80},
                 { dataIndex: 'PERSON_NAME'               , width: 80},
                 { dataIndex: 'JOIN_DATE'               , width: 80},
                 { dataIndex: 'LONG_TOT_DAY'               , width: 80},
                 { dataIndex: 'PAY_TOTAL_I'               , width: 110},
                 { dataIndex: 'BONUS_SUM'               , width: 110},
                 { dataIndex: 'PAY_AMT_SUM'               , width: 110},
                 { dataIndex: 'AVG_PAY_3'               , width: 110},
                 { dataIndex: 'BONUS_SUM_3'               , width: 110},
                 { dataIndex: 'DAY_3'               , width: 80},
                 { dataIndex: 'AVG_DAY'               , width: 110},
                 { dataIndex: 'AVG_WAGES_I'               , width: 110	, summaryType: 'sum'
                 },
                 { dataIndex: 'REMARK'               , width: 300}
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
        id  : 's_axt180skr_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('ST_DATE', new Date(new Date().getFullYear(), new Date().getMonth() + 1, 0));
            
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
        onPrintButtonDown: function(printType) {
            var param= panelResult.getValues();
            //param.ACCNT_DIV_NAME = panelSearch.getField('ACCNT_DIV_CODE').getRawValue();
            var win = Ext.create('widget.PDFPrintWindow', {
                url: CPATH+'/accnt/axt180rkrPrint.do',
                prgID: 'axt180rkr',
                extParam: param
                });
            win.center();
            win.show();  
        },
        requestApprove: function(){     //결재 요청
            var gsWin = window.open('about:blank','payviewer','width=500,height=500');
            
            var frm         = document.f1;
            var compCode    = UserInfo.compCode;
            var divCode     = panelResult.getValue('DIV_CODE');
            var userId      = UserInfo.userID
            var stdate      = UniDate.getDbDateStr(panelResult.getValue('ST_DATE'));
            var deptcode    = panelResult.getValue('DEPT_CODE');
            var personnumb  = panelResult.getValue('PERSON_NUMB');
            
            var groupUrl    = "http://gw.kdg.co.kr:8070/approval/legacyGateway.hi?viewMode=docuDraft&prg_no=axt180skr&draft_no=0&sp=EXEC " 
                        
            var spText      = 'omegaplus_kdg.unilite.USP_ACCNT_AXT180SKR_fnQuery ' + "'" + compCode + "'" + ', ' + "'" + stdate + "'" 
                            + ', ' + "'" + divCode + "'" + ', ' + "'" + deptcode + "'" + ', ' + "'" + personnumb + "'" 
                            + ', ' + "''" + ', ' + "'" + userId + "'" + ', ' + "'ko'" + ', ' + "''";
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
