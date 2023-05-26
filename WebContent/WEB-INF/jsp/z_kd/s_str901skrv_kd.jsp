<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_str901skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_str901skrv_kd"  />             <!-- 사업장 -->  
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
            read: 's_str901skrv_kdService.selectList'
        }
    });
    
    Unilite.defineModel('s_str901skrv_kdModel', {
        fields: [
            {name: 'COMP_CODE'                    ,text: '법인코드'             ,type:'string'},
            {name: 'DIV_CODE'                     ,text: '사업장'               ,type:'string',comboType: "BOR120"},
            {name: 'DEPT_CODE'                    ,text: '부서구분'             ,type : 'string', comboType : 'AU', comboCode : 'WB19'},
            {name: 'SALE_DATE'                    ,text: '매출일'               ,type:'uniDate'},
            {name: 'CUSTOM_CODE'                  ,text: '거래처코드'           ,type:'string'},
            {name: 'CUSTOM_NAME'                  ,text: '거래처명'             ,type:'string'},
            {name: 'ORDER_TYPE'                   ,text: '판매유형'             ,type:'string',comboType: "AU", comboCode: "S002"},
            {name: 'OEM_ITEM_CODE'                ,text: '품번'              ,type:'string'},
            {name: 'ITEM_CODE'                    ,text: '품목코드'             ,type:'string'},
            {name: 'ITEM_NAME'                    ,text: '품목명'               ,type:'string'},
            {name: 'SPEC'                         ,text: '규격'                 ,type:'string'},
            {name: 'INOUT_Q'                      ,text: '출고수량'             ,type:'uniQty'},
            {name: 'SALE_Q'                       ,text: '매출수량'             ,type:'uniQty'},
            {name: 'STOCK_UNIT'                   ,text: '단위'                 ,type:'string'},
            {name: 'MONEY_UNIT'                   ,text: '화폐'                 ,type:'string'},
            {name: 'SALE_AMT_O'                   ,text: '금액(화폐)'           ,type:'uniPrice'},
            {name: 'SALE_LOC_AMT_I'               ,text: '금액(자사)'           ,type:'uniPrice'},
            {name: 'TAX_AMT_O'                    ,text: '부가세액'             ,type:'uniPrice'},
            {name: 'SUM_SALE_AMT'                 ,text: '합계'                 ,type:'uniPrice'}
        ]
    });
    
    var directMasterStore = Unilite.createStore('s_str901skrv_kdMasterStore',{
        model: 's_str901skrv_kdModel',
        uniOpt : {
            isMaster: true,          // 상위 버튼 연결 
            editable: false,         // 수정 모드 사용 
            deletable:false,         // 삭제 가능 여부 
            useNavi : false          // prev | newxt 버튼 사용
        },
        expanded : false,
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {   
            var param= panelResult.getValues();
            this.load({
                  params : param
            });         
        },
        listeners: {
            load:function( store, records, successful, operation, eOpts ) {
//            	if(Ext.getCmp('rdoSelect').getChecked()[0].inputValue == '1') {
//                    alert("내역 전체 보여줘야돼!!!!");
//                } else {
//                    alert("소계만 보여줘야돼!!!!");  
//                }
            }
        },
        groupField: 'CUSTOM_NAME'
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
                fieldLabel: '매출일자',
                xtype: 'uniDateRangefield',
                startFieldName: 'SALE_DATE_FR',
                endFieldName: 'SALE_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank:false
            },
            Unilite.popup('CUST',{ 
                    fieldLabel: '거래처',
                    valueFieldName:'CUSTOM_CODE',
                    textFieldName:'CUSTOM_NAME'
            }),{
                fieldLabel: '판매유형',
                name:'ORDER_TYPE',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'S002',
                value: UserInfo.divCode
            }/*,{
                xtype: 'radiogroup',
                fieldLabel: '조회구분',
                items : [{
                    boxLabel: '내역',
                    name: 'TYPE' ,
                    inputValue: '1',                        
                    checked: true,
                    width:60
                }, {
                    boxLabel: '월소계',
                    name: 'TYPE' ,
                    inputValue: '2',
                    width:60
                }]
            }*/ ,{
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
    var masterGrid = Unilite.createGrid('s_str901skrv_kdmasterGrid', { 
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
        	{id: 'masterGridSubTotal',     ftype: 'uniGroupingsummary',    showSummaryRow: true },
            {id: 'masterGridTotal',        ftype: 'uniSummary',            showSummaryRow: true} 
        ],
        columns:  [
            { dataIndex: 'COMP_CODE'                         ,           width: 100, hidden: true},
            { dataIndex: 'DIV_CODE'                          ,           width: 100, hidden: true},
            { dataIndex: 'SALE_DATE'                         ,           width: 100, hidden: true},
            { dataIndex: 'CUSTOM_CODE'                       ,           width: 100,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
                }
            },
            { dataIndex: 'CUSTOM_NAME'                       ,           width: 180},
            { dataIndex: 'DEPT_CODE'                         ,           width: 100},
            { dataIndex: 'ORDER_TYPE'                        ,           width: 90},
            { dataIndex: 'OEM_ITEM_CODE'                     ,           width: 100},
            { dataIndex: 'ITEM_CODE'                         ,           width: 100},
            { dataIndex: 'ITEM_NAME'                         ,           width: 200},
            { dataIndex: 'SPEC'                              ,           width: 80},
            { dataIndex: 'INOUT_Q'                           ,           width: 80, summaryType: 'sum'},
            { dataIndex: 'SALE_Q'                            ,           width: 80, summaryType: 'sum'},
            { dataIndex: 'STOCK_UNIT'                        ,           width: 80},
            { dataIndex: 'MONEY_UNIT'                        ,           width: 80},
            { dataIndex: 'SALE_AMT_O'                        ,           width: 90, summaryType: 'sum'},
            { dataIndex: 'SALE_LOC_AMT_I'                    ,           width: 90, summaryType: 'sum'},
            { dataIndex: 'TAX_AMT_O'                         ,           width: 90, summaryType: 'sum'},
            { dataIndex: 'SUM_SALE_AMT'                      ,           width: 100, summaryType: 'sum'}
        ],               
        listeners: {
//        	afterrender:function() {
//                if(Ext.getCmp('rdoSelect').getChecked()[0].inputValue == '1') {
//                    alert("내역 전체 보여줘야돼!!!!");
//                } else {
//                    alert("소계만 보여줘야돼!!!!");  
//                }
//            }
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
        id  : 's_str901skrv_kdApp',
        fnInitBinding : function() {
            panelResult.clearForm(); 
            directMasterStore.clearData();
            this.setDefault();
        },
        onQueryButtonDown : function()  {
        	directMasterStore.loadStoreRecords();
            /* var viewLocked = masterGrid.getView();
            var viewNormal = masterGrid.getView();
            viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
            viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
            viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
            viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true); */
            UniAppManager.setToolbarButtons('reset', true);
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            masterGrid.reset();
            this.fnInitBinding();
        },
        setDefault: function() {
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('SALE_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('SALE_DATE_TO', UniDate.get('today'));
        }
    });
};

</script>