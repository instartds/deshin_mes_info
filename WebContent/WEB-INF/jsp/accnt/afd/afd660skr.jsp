<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afd660skr"  >
    <t:ExtComboStore comboType="BOR120"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="A089" /> <!--차입구분-->
    <t:ExtComboStore comboType="AU" comboCode="B004" /> <!--화폐단위-->
    <t:ExtComboStore comboType="AU" comboCode="B013" /> <!--화폐단위-->
    <t:ExtComboStore comboType="AU" comboCode="A036" /> <!--상각방법-->
    <t:ExtComboStore comboType="AU" comboCode="A020" /> <!--분할여부(예/아니오)-->
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>    
</t:appConfig>
<script type="text/javascript" >
var getChargeCode = '${getChargeCode}';
function appMain() {
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('Afd660skrModel', {
        fields: [
            {name: 'COMP_CODE'             ,text:'법잉코드'            ,type: 'string'},
            {name: 'LOANNO'                ,text:'차입번호'            ,type: 'string'},
            {name: 'LOAN_NAME'             ,text:'차입금명'            ,type: 'string'},
            {name: 'ACCNT'                 ,text:'계정과목'            ,type: 'string'},
            {name: 'ACCNT_NAME'            ,text:'계정명'              ,type: 'string'},
            {name: 'CUSTOM'                ,text:'차입처'              ,type: 'string'},
            {name: 'DIV_CODE'              ,text:'사업장'              ,type: 'string', comboType: 'BOR120', child: 'WH_CODE'},
            {name: 'DEPT_CODE'             ,text:'차입부서'            ,type: 'string'},
            {name: 'LOAN_GUBUN'            ,text:'차입구분'            ,type: 'string', comboType: 'AU', comboCode: 'A089'},
            {name: 'PUB_DATE'              ,text:'차입일'              ,type: 'uniDate'},
            {name: 'EXP_DATE'              ,text:'만기일'              ,type: 'uniDate'},
            {name: 'MONEY_UNIT'            ,text:'화폐단위'            ,type: 'string', comboType: 'AU', comboCode: 'B004'},
            {name: 'AMT_I'                 ,text:'차입원화금액'        ,type: 'uniPrice'},
            {name: 'EXCHG_RATE_O'          ,text:'차입환율'            ,type: 'uniER'},
            {name: 'FOR_AMT_I'             ,text:'차입외화금액'        ,type: 'uniFC'},
            {name: 'INT_RATE'              ,text:'이율'                ,type: 'uniER'},
            {name: 'P_PRINCIPAL_AMT'       ,text:'계획상환금액'        ,type: 'uniPrice'},
            {name: 'P_FOR_PRINCIPAL_AMT'   ,text:'계획상환금액_외화'   ,type: 'uniFC'},
            {name: 'P_INTEREST_AMT'        ,text:'계획이자지금액'      ,type: 'uniPrice'},
            {name: 'P_FOR_INT_AMT'         ,text:'계획이자지금액_외화' ,type: 'uniFC'},
            {name: 'INT_FR_DATE'           ,text:'이자대상기간_FROM'   ,type: 'uniDate'},
            {name: 'INT_TO_DATE'           ,text:'이자대상기간_TO'     ,type: 'uniDate'},
            {name: 'PAYMENT_DATE'          ,text:'지급일자 = 상환일자' ,type: 'uniDate'},
            {name: 'PRI_AMT'               ,text:'상환금액'            ,type: 'uniPrice'},
            {name: 'FOR_PRI_AMT'           ,text:'상환금액_외화'       ,type: 'uniFC'},
            {name: 'INT_AMT'               ,text:'이자급액'            ,type: 'uniPrice'},
            {name: 'FOR_INT_AMT'           ,text:'이자지급액_외화'     ,type: 'uniFC'}
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore = Unilite.createStore('afd660skrMasterStore1',{
        model: 'Afd660skrModel',
        uniOpt : {
            isMaster: true,         // 상위 버튼 연결 
            editable: false,        // 수정 모드 사용 
            deletable:false,        // 삭제 가능 여부 
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {          
                read: 'afd660skrService.selectList'                   
            }
        },
        loadStoreRecords : function()   {
            var param= Ext.getCmp('resultForm').getValues();            
            console.log( param );
            this.load({
                params : param
            });
        }
    });

    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        hidden: !UserInfo.appOption.collapseLeftSearch,
        layout : {type : 'uniTable', columns : 2},
        padding:'1 1 1 1',
        border:true,
        items: [{ 
            fieldLabel     : '차입일자',
            xtype          : 'uniDateRangefield',
            startFieldName : 'FR_DATE',
            endFieldName   : 'TO_DATE',
            startDate      : UniDate.get('startOfMonth'),
            endDate        : UniDate.get('today'),
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
            }
        },{ 
            fieldLabel: '사업장',
            name: 'DIV_CODE',
            xtype: 'uniCombobox',
            comboType: 'BOR120'
        },
        Unilite.popup('CUST',{ 
            fieldLabel: '차입처',
            valueFieldName: 'CON_CUSTOM_CODE',
            textFieldName: 'CON_CUSTOM_NAME',
            listeners: {
                onSelected: {
                    fn: function(records, type) {
                    },
                    scope: this
                },
                onClear: function(type) {
                },
                applyextparam: function(popup){                         
                    //popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                }
            }
        }),
        Unilite.popup('DEBT_NO',{ 
            fieldLabel: '차입금',
            valueFieldName: 'DEBT_NO_CODE',
            textFieldName: 'DEBT_NO_NAME'
        })]
    }); 
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('afd660skrGrid1', {
        // for tab      
        region:'center',
        store : directMasterStore, 
        excelTitle: '자산변동내역조회',
        uniOpt: {
            useMultipleSorting  : true,
            useLiveSearch       : true,
            onLoadSelectFirst   : true,
            dblClickToEdit      : false,
            useGroupSummary     : true,
            useContextMenu      : false,
            useRowNumberer      : true,
            expandLastColumn    : true,
            useRowContext       : false,
            filter: {
                useFilter       : true,
                autoCreate      : true
            }
        },
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
                    {id : 'masterGridTotal',    ftype: 'uniSummary',      showSummaryRow: false} ],
        columns:  [        
            { dataIndex: 'COMP_CODE'                     ,                   width: 100, hidden: true},
            { dataIndex: 'LOANNO'                        ,                   width: 100},
            { dataIndex: 'LOAN_NAME'                     ,                   width: 200},
            { dataIndex: 'ACCNT'                         ,                   width: 100},
            { dataIndex: 'ACCNT_NAME'                    ,                   width: 200},
            { dataIndex: 'CUSTOM'                        ,                   width: 100},
            { dataIndex: 'DIV_CODE'                      ,                   width: 100},
            { dataIndex: 'DEPT_CODE'                     ,                   width: 100},
            { dataIndex: 'LOAN_GUBUN'                    ,                   width: 100},
            { dataIndex: 'PUB_DATE'                      ,                   width: 100},
            { dataIndex: 'EXP_DATE'                      ,                   width: 100},
            { dataIndex: 'MONEY_UNIT'                    ,                   width: 100},
            { dataIndex: 'AMT_I'                         ,                   width: 100},
            { dataIndex: 'EXCHG_RATE_O'                  ,                   width: 100},
            { dataIndex: 'FOR_AMT_I'                     ,                   width: 100},
            { dataIndex: 'INT_RATE'                      ,                   width: 100},
            { dataIndex: 'P_PRINCIPAL_AMT'               ,                   width: 100},
            { dataIndex: 'P_FOR_PRINCIPAL_AMT'           ,                   width: 100},
            { dataIndex: 'P_INTEREST_AMT'                ,                   width: 100},
            { dataIndex: 'P_FOR_INT_AMT'                 ,                   width: 100},
            { dataIndex: 'INT_FR_DATE'                   ,                   width: 100},
            { dataIndex: 'INT_TO_DATE'                   ,                   width: 100},
            { dataIndex: 'PAYMENT_DATE'                  ,                   width: 100},
            { dataIndex: 'PRI_AMT'                       ,                   width: 100},
            { dataIndex: 'FOR_PRI_AMT'                   ,                   width: 100},
            { dataIndex: 'INT_AMT'                       ,                   width: 100},
            { dataIndex: 'FOR_INT_AMT'                   ,                   width: 100}
        ],
        listeners: {
            itemmouseenter:function(view, record, item, index, e, eOpts )   {               
            }
        }
    });   
    
    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                masterGrid, panelResult
            ]
        }   
        ],  
        id  : 'afd660skrApp',
        fnInitBinding : function() {
            UniAppManager.setToolbarButtons('save',false);
            panelResult.setValue('FR_DATE', UniDate.get('startOfMonth'));
            panelResult.setValue('TO_DATE', UniDate.get('today'));
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            var activeSForm  = panelResult;
            activeSForm.onLoadSelectText('FR_DATE');
        },
        onQueryButtonDown : function()  {
            if(!this.isValidSearchForm()){
                return false;
            }else{
                
                masterGrid.getStore().loadStoreRecords();
            }
        },
        onResetButtonDown: function() {
            panelResult.clearForm();
            masterGrid.reset();
            this.fnInitBinding();
        }
    });
};


</script>
