<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_axt120skr_kd"  >
    <t:ExtComboStore comboType="BOR120"    pgmId="s_axt120skr_kd"/>             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU"    comboCode="B038"/>             <!-- 결제방법 -->
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
    Unilite.defineModel('s_axt120skr_kdModel', {
        fields: [
//            {name: 'COMP_CODE'              ,text:'법인코드'        ,type:'string'},
//            {name: 'AAA'               ,text:'결재방법'          ,type:'string' },
//            {name: 'BBB'              ,text:'거래처코드'            ,type:'string'},
//            {name: 'CCC'              ,text:'거래처명'            ,type:'string'},
//            {name: 'DDD'                   ,text:'전월이월'            ,type:'string'},
//            {name: 'EEE'            ,text:'미지급(07)'            ,type:'string'},
//            {name: 'FFF'            ,text:'미지급(08)'        ,type:'string'},
//            {name: 'GGG'               ,text:'미지급(09)'            ,type:'string'},
//            {name: 'HHH'        ,text:'미지급(10)'    ,type:'string'},
//            {name: 'III'               ,text:'합계'            ,type:'string'}
            
            {name: 'COMP_CODE'              ,text:'법인코드'                ,type:'string'},
            {name: 'ACCNT'                  ,text:'결재방법코드'              ,type:'string'},
            {name: 'SET_METH'               ,text:'결제방법'                ,type:'string'},
            {name: 'CUSTOM_CODE'            ,text:'거래처코드'               ,type:'string'},
            {name: 'CUSTOM_NAME'            ,text:'거래처명'                ,type:'string'},
            {name: 'AMT_I_M4'               ,text:'미지급'                 ,type:'uniPrice'},
            {name: 'AMT_I_M3'               ,text:'미지급'                 ,type:'uniPrice'},
            {name: 'AMT_I_M2'               ,text:'미지급'                 ,type:'uniPrice'},
            {name: 'AMT_I_M1'               ,text:'미지급'                 ,type:'uniPrice'},
            {name: 'AMT_I_M0'               ,text:'미지급'                 ,type:'uniPrice'},
            {name: 'AMT_I_TOT'              ,text:'미지급(합계)'             ,type:'uniPrice'}
            
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                    
    var directMasterStore1 = Unilite.createStore('s_axt120skr_kdMasterStore1',{
            model: 's_axt120skr_kdModel',
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
                       read: 's_axt120skr_kdService.selectList'                    
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
//            	{
//                    fieldLabel        : '신청기간',
//                    xtype             : 'uniDateRangefield',
//                    startFieldName    : 'FR_DATE',
//                    endFieldName      : 'TO_DATE',
//                    startDate         : UniDate.get('startOfMonth'),
//                    endDate           : UniDate.get('today'),
//                    allowBlank        : false,          
//                    tdAttrs           : {width: 350},
//                    width             : 315,
//                    onStartDateChange: function(field, newValue, oldValue, eOpts) {
//                    },
//                    onEndDateChange: function(field, newValue, oldValue, eOpts) {
//                    }
//               },
               {
                    fieldLabel: '사업장',
                    name:'DIV_CODE', 
                    xtype: 'uniCombobox',
//                    multiSelect: true, 
//                    typeAhead: false,
                    comboType:'BOR120',
//                    width: 325,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
                },
                {
                    fieldLabel  : '기준년월',    
                    name        : 'ST_MONTH', 
                    xtype       : 'uniMonthfield',
                    id          : 'stMonth',              
                    value       : new Date(),               
                    allowBlank  : false,
//                    tdAttrs     : {width: 380},
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                         if(UniDate.getDbDateStr(newValue).substring(4,6) == 5){
                           var month1 = parseInt(UniDate.getDbDateStr(newValue).substring(4,6))-4;
                           var month2 = parseInt(UniDate.getDbDateStr(newValue).substring(4,6))-3;
                           var month3 = parseInt(UniDate.getDbDateStr(newValue).substring(4,6))-2;
                           var month4 = parseInt(UniDate.getDbDateStr(newValue).substring(4,6))-1;
                           var month5 = parseInt(UniDate.getDbDateStr(newValue).substring(4,6));
                           
                           masterGrid.getColumn('AMT_I_M4').setText( '미지급'+'(' + month1  +'월' +')');
                           masterGrid.getColumn('AMT_I_M3').setText( '미지급'+'(' + month2  +'월' +')');
                           masterGrid.getColumn('AMT_I_M2').setText( '미지급'+'(' + month3  +'월' +')');
                           masterGrid.getColumn('AMT_I_M1').setText( '미지급'+'(' + month4  +'월' +')');
                           masterGrid.getColumn('AMT_I_M0').setText( '미지급'+'(' + month5  +'월' +')');
                           
                        }else if(UniDate.getDbDateStr(newValue).substring(4,6) == 4){
                           var month1 = parseInt(UniDate.getDbDateStr(newValue).substring(4,6))+8;
                           var month2 = parseInt(UniDate.getDbDateStr(newValue).substring(4,6))-3;
                           var month3 = parseInt(UniDate.getDbDateStr(newValue).substring(4,6))-2;
                           var month4 = parseInt(UniDate.getDbDateStr(newValue).substring(4,6))-1;
                           var month5 = parseInt(UniDate.getDbDateStr(newValue).substring(4,6));
                           
                           masterGrid.getColumn('AMT_I_M4').setText( '미지급'+'(' + month1  +'월' +')');
                           masterGrid.getColumn('AMT_I_M3').setText( '미지급'+'(' + month2  +'월' +')');
                           masterGrid.getColumn('AMT_I_M2').setText( '미지급'+'(' + month3  +'월' +')');
                           masterGrid.getColumn('AMT_I_M1').setText( '미지급'+'(' + month4  +'월' +')');
                           masterGrid.getColumn('AMT_I_M0').setText( '미지급'+'(' + month5  +'월' +')');
                           
                        }else if(UniDate.getDbDateStr(newValue).substring(4,6) == 3){
                           var month1 = parseInt(UniDate.getDbDateStr(newValue).substring(4,6))+8;
                           var month2 = parseInt(UniDate.getDbDateStr(newValue).substring(4,6))+9;
                           var month3 = parseInt(UniDate.getDbDateStr(newValue).substring(4,6))-2;
                           var month4 = parseInt(UniDate.getDbDateStr(newValue).substring(4,6))-1;
                           var month5 = parseInt(UniDate.getDbDateStr(newValue).substring(4,6));
                           
                           masterGrid.getColumn('AMT_I_M4').setText( '미지급'+'(' + month1  +'월' +')');
                           masterGrid.getColumn('AMT_I_M3').setText( '미지급'+'(' + month2  +'월' +')');
                           masterGrid.getColumn('AMT_I_M2').setText( '미지급'+'(' + month3  +'월' +')');
                           masterGrid.getColumn('AMT_I_M1').setText( '미지급'+'(' + month4  +'월' +')');
                           masterGrid.getColumn('AMT_I_M0').setText( '미지급'+'(' + month5  +'월' +')');
                           
                        }else if(UniDate.getDbDateStr(newValue).substring(4,6) == 2){
                           var month1 = parseInt(UniDate.getDbDateStr(newValue).substring(4,6))+8;
                           var month2 = parseInt(UniDate.getDbDateStr(newValue).substring(4,6))+9;
                           var month3 = parseInt(UniDate.getDbDateStr(newValue).substring(4,6))+10;
                           var month4 = parseInt(UniDate.getDbDateStr(newValue).substring(4,6))-1;
                           var month5 = parseInt(UniDate.getDbDateStr(newValue).substring(4,6));
                           
                           masterGrid.getColumn('AMT_I_M4').setText( '미지급'+'(' + month1  +'월' +')');
                           masterGrid.getColumn('AMT_I_M3').setText( '미지급'+'(' + month2  +'월' +')');
                           masterGrid.getColumn('AMT_I_M2').setText( '미지급'+'(' + month3  +'월' +')');
                           masterGrid.getColumn('AMT_I_M1').setText( '미지급'+'(' + month4  +'월' +')');
                           masterGrid.getColumn('AMT_I_M0').setText( '미지급'+'(' + month5  +'월' +')');
                           
                        }else if(UniDate.getDbDateStr(newValue).substring(4,6) == 1){
                           var month1 = parseInt(UniDate.getDbDateStr(newValue).substring(4,6))+8;
                           var month2 = parseInt(UniDate.getDbDateStr(newValue).substring(4,6))+9;
                           var month3 = parseInt(UniDate.getDbDateStr(newValue).substring(4,6))+10;
                           var month4 = parseInt(UniDate.getDbDateStr(newValue).substring(4,6))+11;
                           var month5 = parseInt(UniDate.getDbDateStr(newValue).substring(4,6));
                           
                           masterGrid.getColumn('AMT_I_M4').setText( '미지급'+'(' + month1  +'월' +')');
                           masterGrid.getColumn('AMT_I_M3').setText( '미지급'+'(' + month2  +'월' +')');
                           masterGrid.getColumn('AMT_I_M2').setText( '미지급'+'(' + month3  +'월' +')');
                           masterGrid.getColumn('AMT_I_M1').setText( '미지급'+'(' + month4  +'월' +')');
                           masterGrid.getColumn('AMT_I_M0').setText( '미지급'+'(' + month5  +'월' +')');
                           
                        }else{
                           var month1 = parseInt(UniDate.getDbDateStr(newValue).substring(4,6))-4;
                           var month2 = parseInt(UniDate.getDbDateStr(newValue).substring(4,6))-3;
                           var month3 = parseInt(UniDate.getDbDateStr(newValue).substring(4,6))-2;
                           var month4 = parseInt(UniDate.getDbDateStr(newValue).substring(4,6))-1;
                           var month5 = parseInt(UniDate.getDbDateStr(newValue).substring(4,6));
                        
                           masterGrid.getColumn('AMT_I_M4').setText( '미지급'+'(' + month1  +'월' +')');
                           masterGrid.getColumn('AMT_I_M3').setText( '미지급'+'(' + month2  +'월' +')');
                           masterGrid.getColumn('AMT_I_M2').setText( '미지급'+'(' + month3  +'월' +')');
                           masterGrid.getColumn('AMT_I_M1').setText( '미지급'+'(' + month4  +'월' +')');
                           masterGrid.getColumn('AMT_I_M0').setText( '미지급'+'(' + month5  +'월' +')');
                        }
                        }
                    }
               },
               {
                fieldLabel  : '결제방법',
                name        : 'SET_METH', 
                xtype       : 'uniCombobox',
                comboType   : 'AU',
                comboCode   : 'B038',
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
            Unilite.popup('CUST',{ 
                fieldLabel: '거래처', 
                popupWidth: 710,
                autoPopup   : true ,
                valueFieldName: 'CUSTOM_CODE_FR',
                textFieldName: 'CUSTOM_NAME',
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                        	panelResult.setValue('CUSTOM_CODE_TO', panelResult.getValue('CUSTOM_CODE_FR'));
                            panelResult.setValue('CUSTOM_NAME1', panelResult.getValue('CUSTOM_NAME'));
                        },
                        scope: this
                    },
                    onClear: function(type) {
                    	panelResult.setValue('CUSTOM_CODE_FR', '');
                    	panelResult.setValue('CUSTOM_NAME', '');
                    },
                    applyextparam: function(popup){                         
                    },
                    onTextSpecialKey: function(elm, e){
                        if (e.getKey() == e.ENTER) {
                            UniAppManager.app.onQueryButtonDown();  
                        }
                    }
                }
            }),
            Unilite.popup('CUST',{ 
                fieldLabel: '~', 
                popupWidth: 710,
                autoPopup   : true ,
                colspan:3,
                valueFieldName: 'CUSTOM_CODE_TO',
                textFieldName: 'CUSTOM_NAME1',
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                        },
                        scope: this
                    },
                    onClear: function(type) {
                    	panelResult.setValue('CUSTOM_CODE_TO', '');
                        panelResult.setValue('CUSTOM_NAME1', '');
                    },
                    applyextparam: function(popup){                         
                    },
                    onTextSpecialKey: function(elm, e){
                        if (e.getKey() == e.ENTER) {
                            UniAppManager.app.onQueryButtonDown();  
                        }
                    }
                }
            })
            ]
    });
    
    
    
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('s_axt120skr_kdGrid1', {
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
                 { dataIndex: 'COMP_CODE'               , width: 133 , hidden: true},
                 { dataIndex: 'ACCNT'                   , width: 133 , hidden: true},
                 { dataIndex: 'SET_METH'              , width: 133},
                 { dataIndex: 'CUSTOM_CODE'             , width: 133},
                 { dataIndex: 'CUSTOM_NAME'             , width: 133},
                 { dataIndex: 'AMT_I_M4'                , width: 133},	
                 { dataIndex: 'AMT_I_M3'                , width: 133},	
                 { dataIndex: 'AMT_I_M2'                , width: 133},	
                 { dataIndex: 'AMT_I_M1'                , width: 133},	
                 { dataIndex: 'AMT_I_M0'                , width: 133},	
                 { dataIndex: 'AMT_I_TOT'               , width: 133}	
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
        id  : 's_axt120skr_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            if(parseInt(UniDate.getDbDateStr(new Date().getMonth()))+1 == 5){
               var month1 = parseInt(UniDate.getDbDateStr(new Date().getMonth()))-3;
               var month2 = parseInt(UniDate.getDbDateStr(new Date().getMonth()))-2;
               var month3 = parseInt(UniDate.getDbDateStr(new Date().getMonth()))-1;
               var month4 = parseInt(UniDate.getDbDateStr(new Date().getMonth()));
               var month5 = parseInt(UniDate.getDbDateStr(new Date().getMonth()))+1;
                           
               masterGrid.getColumn('AMT_I_M4').setText( '미지급'+'(' + month1  +'월' +')');
               masterGrid.getColumn('AMT_I_M3').setText( '미지급'+'(' + month2  +'월' +')');
               masterGrid.getColumn('AMT_I_M2').setText( '미지급'+'(' + month3  +'월' +')');
               masterGrid.getColumn('AMT_I_M1').setText( '미지급'+'(' + month4  +'월' +')');
               masterGrid.getColumn('AMT_I_M0').setText( '미지급'+'(' + month5  +'월' +')');
                           
            }else if(parseInt(UniDate.getDbDateStr(new Date().getMonth()))+1 == 4){
               var month1 = parseInt(UniDate.getDbDateStr(new Date().getMonth()))+8;
               var month2 = parseInt(UniDate.getDbDateStr(new Date().getMonth()))-2;
               var month3 = parseInt(UniDate.getDbDateStr(new Date().getMonth()))-1;
               var month4 = parseInt(UniDate.getDbDateStr(new Date().getMonth()));
               var month5 = parseInt(UniDate.getDbDateStr(new Date().getMonth()))+1;
                           
               masterGrid.getColumn('AMT_I_M4').setText( '미지급'+'(' + month1  +'월' +')');
               masterGrid.getColumn('AMT_I_M3').setText( '미지급'+'(' + month2  +'월' +')');
               masterGrid.getColumn('AMT_I_M2').setText( '미지급'+'(' + month3  +'월' +')');
               masterGrid.getColumn('AMT_I_M1').setText( '미지급'+'(' + month4  +'월' +')');
               masterGrid.getColumn('AMT_I_M0').setText( '미지급'+'(' + month5  +'월' +')');
                          
            }else if(parseInt(UniDate.getDbDateStr(new Date().getMonth()))+1 == 3){
               var month1 = parseInt(UniDate.getDbDateStr(new Date().getMonth()))+9;
               var month2 = parseInt(UniDate.getDbDateStr(new Date().getMonth()))+10;
               var month3 = parseInt(UniDate.getDbDateStr(new Date().getMonth()))-1;
               var month4 = parseInt(UniDate.getDbDateStr(new Date().getMonth()));
               var month5 = parseInt(UniDate.getDbDateStr(new Date().getMonth()))+1;
                           
               masterGrid.getColumn('AMT_I_M4').setText( '미지급'+'(' + month1  +'월' +')');
               masterGrid.getColumn('AMT_I_M3').setText( '미지급'+'(' + month2  +'월' +')');
               masterGrid.getColumn('AMT_I_M2').setText( '미지급'+'(' + month3  +'월' +')');
               masterGrid.getColumn('AMT_I_M1').setText( '미지급'+'(' + month4  +'월' +')');
               masterGrid.getColumn('AMT_I_M0').setText( '미지급'+'(' + month5  +'월' +')');
                           
            }else if(parseInt(UniDate.getDbDateStr(new Date().getMonth()))+1 == 2){
               var month1 = parseInt(UniDate.getDbDateStr(new Date().getMonth()))+9;
               var month2 = parseInt(UniDate.getDbDateStr(new Date().getMonth()))+10;
               var month3 = parseInt(UniDate.getDbDateStr(new Date().getMonth()))+11;
               var month4 = parseInt(UniDate.getDbDateStr(new Date().getMonth()));
               var month5 = parseInt(UniDate.getDbDateStr(new Date().getMonth()))+1;
                           
               masterGrid.getColumn('AMT_I_M4').setText( '미지급'+'(' + month1  +'월' +')');
               masterGrid.getColumn('AMT_I_M3').setText( '미지급'+'(' + month2  +'월' +')');
               masterGrid.getColumn('AMT_I_M2').setText( '미지급'+'(' + month3  +'월' +')');
               masterGrid.getColumn('AMT_I_M1').setText( '미지급'+'(' + month4  +'월' +')');
               masterGrid.getColumn('AMT_I_M0').setText( '미지급'+'(' + month5  +'월' +')');
                          
            }else if(parseInt(UniDate.getDbDateStr(new Date().getMonth()))-11 == 1){
               var month1 = parseInt(UniDate.getDbDateStr(new Date().getMonth()))-3;
               var month2 = parseInt(UniDate.getDbDateStr(new Date().getMonth()))-2;
               var month3 = parseInt(UniDate.getDbDateStr(new Date().getMonth()))-1;
               var month4 = parseInt(UniDate.getDbDateStr(new Date().getMonth()));
               var month5 = parseInt(UniDate.getDbDateStr(new Date().getMonth()))-11;
                           
               masterGrid.getColumn('AMT_I_M4').setText( '미지급'+'(' + month1  +'월' +')');
               masterGrid.getColumn('AMT_I_M3').setText( '미지급'+'(' + month2  +'월' +')');
               masterGrid.getColumn('AMT_I_M2').setText( '미지급'+'(' + month3  +'월' +')');
               masterGrid.getColumn('AMT_I_M1').setText( '미지급'+'(' + month4  +'월' +')');
               masterGrid.getColumn('AMT_I_M0').setText( '미지급'+'(' + month5  +'월' +')');
                           
            }else{
               var month1 = parseInt(UniDate.getDbDateStr(new Date().getMonth()))-3;
               var month2 = parseInt(UniDate.getDbDateStr(new Date().getMonth()))-2;
               var month3 = parseInt(UniDate.getDbDateStr(new Date().getMonth()))-1;
               var month4 = parseInt(UniDate.getDbDateStr(new Date().getMonth()));
               var month5 = parseInt(UniDate.getDbDateStr(new Date().getMonth()))+1;
                        
               masterGrid.getColumn('AMT_I_M4').setText( '미지급'+'(' + month1  +'월' +')');
               masterGrid.getColumn('AMT_I_M3').setText( '미지급'+'(' + month2  +'월' +')');
               masterGrid.getColumn('AMT_I_M2').setText( '미지급'+'(' + month3  +'월' +')');
               masterGrid.getColumn('AMT_I_M1').setText( '미지급'+'(' + month4  +'월' +')');
               masterGrid.getColumn('AMT_I_M0').setText( '미지급'+'(' + month5  +'월' +')');
             }
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
            masterGrid.reset();
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
            var param= panelResult.getValues();
            //param.ACCNT_DIV_NAME = panelSearch.getField('ACCNT_DIV_CODE').getRawValue();
            var win = Ext.create('widget.PDFPrintWindow', {
                url: CPATH+'/accnt/axt120rkrPrint.do',
                prgID: 'axt120rkr',
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
            var stmonth     = UniDate.getDbDateStr(panelResult.getValue('ST_MONTH'));
            var setmeth     = panelResult.getValue('SET_METH');
            if(setmeth == null){
            	setmeth = '';
            }
            var customcodefr  = panelResult.getValue('CUSTOM_CODE_FR');
            var customcodeto  = panelResult.getValue('CUSTOM_CODE_TO');
            
            //var record = masterGrid.getSelectedRecord();
            var groupUrl    = "http://gw.kdg.co.kr:8070/approval/legacyGateway.hi?viewMode=docuDraft&prg_no=axt120skr&draft_no=0&sp=EXEC " 
                                   
            var spText      = 'omegaplus_kdg.unilite.USP_ACCNT_AXT120SKR_fnQuery ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + stmonth + "'" 
                            + ', ' + "'" + setmeth + "'"+ ', ' + "'" + customcodefr + "'"+ ', ' + "'" + customcodeto + "'"+ ', ' + "''"
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
