<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_str902skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_str902skrv_kd"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--매출구분-->
    <t:ExtComboStore comboType="AU" comboCode="B004" /> <!--화폐-->
    <t:ExtComboStore comboType="AU" comboCode="M201" /> <!--담당자-->
    <t:ExtComboStore comboType="AU" comboCode="B042" /> <!--계획금액단위-->
    <t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당-->
    <t:ExtComboStore comboType="AU" comboCode="B055" /> <!--고객분류-->
    <t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목계정-->
    <t:ExtComboStore comboType="AU" comboCode="B109" /> <!--유통-->
    <t:ExtComboStore comboType="AU" comboCode="B013" /> <!--판매단위-->
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--판매유형-->
    <t:ExtComboStore comboType="AU" comboCode="WB06" /> <!--B/OUT관리여부-->
    <t:ExtComboStore comboType="AU" comboCode="WB19" /> <!--부서구분-->
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo = {     //컨트롤러에서 값을 받아옴.
    gsBalanceOut:        '${gsBalanceOut}'
};
//var output ='';   // 입고내역 셋팅 값 확인 alert
//for(var key in BsaCodeInfo){
//    output += key + '  :  ' + BsaCodeInfo[key] + '\n';
//}
//alert(output);

var excelWindow;    // 엑셀참조

function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_str902skrv_kdService.selectList'
        }
    });
    
    Unilite.defineModel('s_str902skrv_kdModel', {
        fields: [
            {name : 'DEPT_CODE'                    ,text : '부서구분'             ,type : 'string', comboType : 'AU', comboCode : 'WB19'},
            {name : 'GROUP_NAME'                    ,text : '부서그룹'             ,type : 'string'},            
            {name : 'YYYY_MM'                      ,text : '기준월'               ,type : 'string'},
            {name : 'OEM_ITEM_CODE'                ,text : '품번'              ,type :  'string'},
            {name : 'ITEM_CODE'                    ,text : '품목코드'             ,type : 'string'},
            {name : 'ITEM_NAME'                    ,text : '품목명'               ,type : 'string'},
            {name : 'SPEC'                         ,text : '규격'                 ,type : 'string'},
            {name : 'SALE_CUSTOM_CODE'             ,text : '거래처'                 ,type : 'string'},
            {name : 'CUSTOM_NAME'                  ,text : '거래처명'                 ,type : 'string'},
            {name : 'MONEY_UNIT'                   ,text : '화폐단위'             ,type : 'string', comboType:'AU', comboCode:'B004', displayField: 'value'},
            {name : 'PLAN_AMT'                     ,text : '계획금액'             ,type : 'uniFC'},
            {name : 'INOUT_I'                      ,text : '출고금액'             ,type : 'uniFC'},
            {name : 'SALE_AMT'                     ,text : '매출금액'             ,type : 'uniFC'}
        ]
    });    
    
    var directMasterStore = Unilite.createStore('s_str902skrv_kdMasterStore',{
        model: 's_str902skrv_kdModel',
        uniOpt : {
            isMaster: true,          // 상위 버튼 연결 
            editable: false,         // 수정 모드 사용 
            deletable:false,         // 삭제 가능 여부 
            useNavi : false          // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {   
            var param= panelResult.getValues();
            var yyyyMM = UniDate.getDbDateStr(panelResult.getValue('YYYY_MM')).substring(0, 6);
            param.YEAR = yyyyMM.substring(0,4);
            param.MONTH = yyyyMM.substring(4,6);
            this.load({
                  params : param
            });         
        }
        ,
        groupField: 'GROUP_NAME'
    });     
    
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
                value: UserInfo.divCode
            },{ 
                fieldLabel: '기준월',
                xtype: 'uniMonthfield',
                name: 'YYYY_MM',
                value: UniDate.get('endOfMonth'),
                allowBlank:false
            },{
                fieldLabel: '부서구분',
                name:'DEPT_CODE',  
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'WB19'
            }
        ],
        setAllFieldsReadOnly: function(b) { 
            var r= true
            if(b) {
                var invalid = this.getForm().getFields().filterBy(function(field) {
                    return !field.validate();
                });                      
                if(invalid.length > 0) {
                    r=false;
                    var labelText = ''
                    if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
                        var labelText = invalid.items[0]['fieldLabel']+'은(는)';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
                    }
                    alert(labelText+Msg.sMB083);
                    invalid.items[0].focus();
                } else {
                    //this.mask();
                    var fields = this.getForm().getFields();
                    Ext.each(fields.items, function(item) {
                        if(Ext.isDefined(item.holdable) ) {
                            if (item.holdable == 'hold') {
                                item.setReadOnly(true); 
                            }
                        } 
                        if(item.isPopupField) {
                            var popupFC = item.up('uniPopupField') ;       
                            if(popupFC.holdable == 'hold') {
                                popupFC.setReadOnly(true);
                            }
                        }
                    })
                }
            } else {
                //this.unmask();
                var fields = this.getForm().getFields();
                Ext.each(fields.items, function(item) {
                    if(Ext.isDefined(item.holdable) ) {
                        if (item.holdable == 'hold') {
                            item.setReadOnly(false);
                        }
                    } 
                    if(item.isPopupField) {
                        var popupFC = item.up('uniPopupField') ; 
                        if(popupFC.holdable == 'hold' ) {
                            item.setReadOnly(false);
                        }
                    }
                })
            }
            return r;
        },
        setLoadRecord: function(record) {
            var me = this;   
            me.uniOpt.inLoading=false;
            me.setAllFieldsReadOnly(true);
        }
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('s_str902skrv_kdmasterGrid', { 
        layout : 'fit',   
        region: 'center',                          
        store: directMasterStore,
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        features: [ 
        	{id: 'masterGridSubTotal',     ftype: 'uniGroupingsummary',    showSummaryRow: false }
        ],
        columns:  [
            { dataIndex: 'DEPT_CODE'                              ,           width: 100,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
                }
            },
            { dataIndex: 'GROUP_NAME'                             ,           width: 80, hidden:true},            
            { dataIndex: 'YYYY_MM'                                ,           width: 80, align : 'center'},
            { dataIndex: 'OEM_ITEM_CODE'                          ,           width: 130, hidden:true},
            { dataIndex: 'ITEM_CODE'                              ,           width: 100},
            { dataIndex: 'ITEM_NAME'                              ,           width: 200},
            { dataIndex: 'SPEC'                                   ,           width: 130},
            { dataIndex: 'SALE_CUSTOM_CODE'                       ,           width: 66},
            { dataIndex: 'CUSTOM_NAME'                            ,           width: 130},
            { dataIndex: 'MONEY_UNIT'                             ,           width: 100},
            { dataIndex: 'PLAN_AMT'                               ,           width: 120, summaryType: 'sum'},
            { dataIndex: 'INOUT_I'                                ,           width: 120, summaryType: 'sum'},
            { dataIndex: 'SALE_AMT'                               ,           width: 120, summaryType: 'sum'}
        ]
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
        id  : 's_str902skrv_kdApp',
        fnInitBinding : function() {
            panelResult.clearForm(); 
            directMasterStore.clearData();
            this.setDefault();
        },
        onQueryButtonDown : function()  {
          masterGrid.reset();
        
        	  directMasterStore.loadStoreRecords();
            var viewLocked = masterGrid.getView();
            var viewNormal = masterGrid.getView();
            viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
            viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
            UniAppManager.setToolbarButtons('reset', true);
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            masterGrid.reset();
            this.fnInitBinding();
        },
        setDefault: function() {
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('YYYY_MM', UniDate.get('today'));
        }
    });
};

</script>