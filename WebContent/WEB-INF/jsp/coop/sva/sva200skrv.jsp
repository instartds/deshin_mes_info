<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sva200skrv"  >
    <t:ExtComboStore comboType="BOR120" pgmId="sva200skrv"  />          <!-- 사업장 -->
    <t:ExtComboStore items="${COMBO_VENDING_MACHINE_NO}" storeId="MachineNo" /><!--자판기명-->

</t:appConfig>
<script type="text/javascript" >
/*var output ='';
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);
*/

var outDivCode = UserInfo.divCode;

function appMain() {
    /**
     *   Model 정의
     * @type
     */
    Unilite.defineModel('Sva200skrvModel', {
        fields: [
            {name: 'COMP_CODE'       ,text: '법인코드'      ,type: 'string'},
            {name: 'DIV_CODE'        ,text: '사업장'           ,type: 'string'},
            {name: 'INOUT_DATE'      ,text: '판매일자'      ,type: 'uniDate'},
            {name: 'POS_NO'          ,text: '자판기번호'         ,type: 'string'},
            {name: 'POS_NAME'        ,text: '자판기명'      ,type: 'string'},
            {name: 'LOCATION'        ,text: '위치'            ,type: 'string'},
            {name: 'SALE_O'          ,text: '판매금액'      ,type: 'uniPrice'},
            {name: 'SALE_AMT_O'      ,text: '입금액(현금)'           ,type: 'uniPrice'},
            {name: 'CARD_SALE_AMT_O'      ,text: '입금액(카드)'           ,type: 'uniPrice'},
            {name: 'OVER_SHORTAGE'   ,text: '과부족'           ,type: 'uniPrice'},
            {name: 'CONFIRM'         ,text: '확정횟수'      ,type: 'int'},
            {name: 'CONFIRM_USER_ID' ,text: '확정자'           ,type: 'string'}
        ]
    });     //End of Unilite.defineModel('Sva200skrvModel', {

    Unilite.defineModel('Sva200skrvModel2', {
        fields: [
            {name: 'COMP_CODE'              ,text: '법인코드'               ,type: 'string'},
            {name: 'DIV_CODE'               ,text: '사업장'                ,type: 'string'},
            {name: 'POS_NO'                 ,text: '자판기번호'          ,type: 'string'},

            {name: 'COLUMN_NO'              ,text: '컬럼번호'               ,type: 'int',allowBlank:false},
            {name: 'ITEM_CODE'              ,text: '품목코드'               ,type: 'string',allowBlank:false},
            {name: 'ITEM_NAME'              ,text: '품명'                 ,type: 'string'},

            {name: 'CASH_INOUT_NUM'              ,text: '수불번호(현금)'               ,type: 'string'},
            {name: 'CARD_INOUT_NUM'              ,text: '수불번호(카드)'               ,type: 'string'},
            {name: 'BEFORE_CNT'             ,text: '이전도수'               ,type: 'uniQty'},
            {name: 'AFTER_CNT'              ,text: '현재도수'               ,type: 'uniQty'},
            {name: 'SALE_Q'                 ,text: '판매수량(현금)'               ,type: 'uniQty'},
            {name: 'CARD_SALE_Q'            ,text: '판매수량(카드)'               ,type: 'uniQty'},
            {name: 'SALE_P'                 ,text: '판매단가'               ,type: 'uniPrice'},
            {name: 'SALE_O'                 ,text: '판매금액(현금)'               ,type: 'uniPrice'},
            {name: 'CARD_SALE_O'                 ,text: '판매금액(카드)'               ,type: 'uniPrice'}]
    });     //End of Unilite.defineModel('Sva200skrvModel', {
    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directMasterStore1 = Unilite.createStore('sva200skrvMasterStore1',{
        model: 'Sva200skrvModel',
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결
            editable: false,            // 수정 모드 사용
            deletable: false,           // 삭제 가능 여부
            useNavi: false              // prev | newxt 버튼 사용
        },
            autoLoad: false,
        proxy: {
                type: 'direct',
                api: {
                    read: 'sva200skrvService.gridUp'
                }
            },
        loadStoreRecords: function() {
            var param= masterForm.getValues();
            console.log(param);
            this.load({
                params : param
            });
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
                if(records[0] != null){
                    masterForm.setValue('GRID_CUSTOM_CODE',records[0].get('POS_NO'));


                if((masterForm.getValue('GRID_CUSTOM_CODE') != '')) {
                    directMasterStore2.loadStoreRecords(records);
                }
                }else{
                    masterForm.setValue('GRID_CUSTOM_CODE','');

                        masterGrid2.getStore().removeAll();
                }
            },
            add: function(store, records, index, eOpts) {

            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {

            },
            remove: function(store, record, index, isMove, eOpts) {
            }
        }


    });     // End of var directMasterStore1 = Unilite.createStore('sva200skrvMasterStore1',{

    var directMasterStore2 = Unilite.createStore('sva200skrvMasterStore2', {
        model: 'Sva200skrvModel2',
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결
            editable: false,            // 수정 모드 사용
            deletable: false,           // 삭제 가능 여부
            useNavi : false         // prev | newxt 버튼 사용
        },
            autoLoad: false,
            /*proxy: {
                type: 'direct',
                api: {
                    read: 'sva200skrvService.gridDown'
                }
            },*/
            proxy: {
                type: 'direct',
                api: {
                    read: 'sva200skrvService.gridDown'
                }
            },
        loadStoreRecords: function(){
            var param= Ext.getCmp('searchForm').getValues();
    //      param.DATE = UniDate.get('today'),
            console.log(param);
            this.load({
                params : param
            });
        }
    });//End of var directMasterStore2 = Unilite.createStore('mms200ukrvMasterStore2', {

    /**
     * 검색조건 (Search Panel)
     * @type
     */
    var masterForm = Unilite.createSearchPanel('searchForm', {
        title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
            collapse: function () {
                panelResult.show();
            },
            expand: function() {
                panelResult.hide();
            }
        },
        items: [{
            title: '기본정보',
            itemId: 'search_panel1',
            layout: {type: 'uniTable', columns: 1},
            defaultType: 'uniTextfield',
            items:[{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
                value: UserInfo.divCode,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('DIV_CODE', newValue);
                    }
                }
            },{
                fieldLabel: '판매일'  ,
                name: 'SALE_DATE',
                xtype:'uniDatefield',
                allowBlank:false,
                listeners: {
                    change: function(combo, newValue, oldValue, eOpts) {
                        panelResult.setValue('SALE_DATE', newValue);
                    }
                }
             },{
                fieldLabel: '자판기',
                name:'POS_CODE',
                xtype: 'uniCombobox',
                store:Ext.data.StoreManager.lookup('MachineNo'),
                multiSelect: true,
                typeAhead: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('POS_CODE', newValue);
                    }
                }
            },{
                xtype: 'button',
                text: '확정',
                width: 100,
                margin: '10 0 0 120',
                handler:function()  {
                    var me = this;
                    var param = {"SALE_DATE": UniDate.getDbDateStr(masterForm.getValue('SALE_DATE')).substring(0, 8)};
                    sva200skrvService.billDateCheck(param, function(provider, response) {
                        if(!Ext.isEmpty(provider)){
                            alert("매출집계가 완료된 일자 입니다. 수정 및 저장할 수 없습니다.");
                        }else{
                            var records = masterGrid.getSelectedRecords();
                            masterGrid.getEl().mask('로딩중...','loading-indicator');
                            masterGrid2.getEl().mask();
                            me.setDisabled(true);
                            Ext.each(records, function(record,i){
                                param = {
                                    COMP_CODE: UserInfo.compCode,
                                    DIV_CODE: record.get('DIV_CODE'),
                                    INOUT_DATE: UniDate.getDbDateStr(record.get('INOUT_DATE')),
                                    POS_NO: record.get('POS_NO'),
                                    USER_ID: UserInfo.userID
                                }
                                sva200skrvService.setConfirm(param, function(provider, response){
                                    if(provider){
                                        if(records.length == i+1){
                                            UniAppManager.updateStatus(Msg.sMB011);
                                            directMasterStore1.loadStoreRecords();
                                        }
                                    }
                                    if(records.length == i+1){
                                        masterGrid.getEl().unmask();
                                        masterGrid2.getEl().unmask();
                                        me.setDisabled(false);
                                    }
                                });
                            });
                        }
                    });
                }
            },
            {
                fieldLabel: '그리드의 자판기번호값',
                name: 'GRID_CUSTOM_CODE',
                xtype: 'uniTextfield',
                hidden: true
            }]
        }],

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
                          var fields = this.getForm().getFields();
                        Ext.each(fields.items, function(item) {
                            if(Ext.isDefined(item.holdable) )   {
                                if (item.holdable == 'hold') {
                                    item.setReadOnly(true);
                                }
                            }
                            if(item.isPopupField)   {
                                var popupFC = item.up('uniPopupField')  ;
                                if(popupFC.holdable == 'hold') {
                                    popupFC.setReadOnly(true);
                                }
                            }
                        })
                    }
                } else {
                    var fields = this.getForm().getFields();
                    Ext.each(fields.items, function(item) {
                        if(Ext.isDefined(item.holdable) )   {
                            if (item.holdable == 'hold') {
                                item.setReadOnly(false);
                            }
                        }
                        if(item.isPopupField)   {
                            var popupFC = item.up('uniPopupField')  ;
                            if(popupFC.holdable == 'hold' ) {
                                item.setReadOnly(false);
                            }
                        }
                    })
                }
                return r;
            }
    });     // End of var masterForm = Unilite.createSearchForm('searchForm',{
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        hidden: !UserInfo.appOption.collapseLeftSearch,
        layout : {type : 'uniTable', columns : 4},
        padding:'1 1 1 1',
        border:true,
        items: [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
                value: UserInfo.divCode,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        masterForm.setValue('DIV_CODE', newValue);
                    }
                }
            },{
                fieldLabel: '판매일'  ,
                name: 'SALE_DATE',
                xtype:'uniDatefield',
                allowBlank:false,
                listeners: {
                    change: function(combo, newValue, oldValue, eOpts) {
                        masterForm.setValue('SALE_DATE', newValue);
                    }
                }
             },{
                fieldLabel: '자판기',
                name:'POS_CODE',
                xtype: 'uniCombobox',
                store:Ext.data.StoreManager.lookup('MachineNo'),
                multiSelect: true,
                typeAhead: false,
                width: 400,
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            masterForm.setValue('POS_CODE', newValue);
                        }
                    }
            },{
                xtype: 'button',
                text: '확정',
                width: 100,
                margin: '0 0 0 40',
                handler:function()  {
                    var me = this;
                    var param = {"SALE_DATE": UniDate.getDbDateStr(masterForm.getValue('SALE_DATE')).substring(0, 8)};
                    sva200skrvService.billDateCheck(param, function(provider, response) {
                        if(!Ext.isEmpty(provider)){
                            alert("매출집계가 완료된 일자 입니다. 수정 및 저장할 수 없습니다.");
                        }else{

                            var records = masterGrid.getSelectedRecords();
                            masterGrid.getEl().mask();
                            masterGrid2.getEl().mask();
                            me.setDisabled(true);
                            Ext.each(records, function(record,i){
                                param = {
                                    COMP_CODE: UserInfo.compCode,
                                    DIV_CODE: record.get('DIV_CODE'),
                                    INOUT_DATE: UniDate.getDbDateStr(record.get('INOUT_DATE')),
                                    POS_NO: record.get('POS_NO'),
                                    USER_ID: UserInfo.userID
                                }
                                sva200skrvService.setConfirm(param, function(provider, response){
                                    if(provider){
                                        if(records.length == i+1){
                                            UniAppManager.updateStatus(Msg.sMB011);
                                            directMasterStore1.loadStoreRecords();
                                        }
                                    }
                                    if(records.length == i+1){
                                        masterGrid.getEl().unmask();
                                        masterGrid2.getEl().unmask();
                                        me.setDisabled(false);
                                    }
                                });
                            });
                        }
                    });
                }
            }],
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
                          var fields = this.getForm().getFields();
                        Ext.each(fields.items, function(item) {
                            if(Ext.isDefined(item.holdable) )   {
                                if (item.holdable == 'hold') {
                                    item.setReadOnly(true);
                                }
                            }
                            if(item.isPopupField)   {
                                var popupFC = item.up('uniPopupField')  ;
                                if(popupFC.holdable == 'hold') {
                                    popupFC.setReadOnly(true);
                                }
                            }
                        })
                    }
                } else {
                    var fields = this.getForm().getFields();
                    Ext.each(fields.items, function(item) {
                        if(Ext.isDefined(item.holdable) )   {
                            if (item.holdable == 'hold') {
                                item.setReadOnly(false);
                            }
                        }
                        if(item.isPopupField)   {
                            var popupFC = item.up('uniPopupField')  ;
                            if(popupFC.holdable == 'hold' ) {
                                item.setReadOnly(false);
                            }
                        }
                    })
                }
                return r;
            }
    });     // end of var panelResult = Unilite.createSearchForm('resultForm',{


    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
    var masterGrid= Unilite.createGrid('sva200skrvGrid', {
        region: 'center',
        layout: 'fit',
        uniOpt: {
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useMultipleSorting: true,
            useRowNumberer: false,
            expandLastColumn: false,
            filter: {
                useFilter: false,
                autoCreate: false
            },
            state: {
                useState: false,   //그리드 설정 (우측)버튼 사용 여부
                useStateList: false  //그리드 설정 (죄측)목록 사용 여부
            }
        },
        store: directMasterStore1,
        features: [{
            id: 'masterGridSubTotal',
            ftype: 'uniGroupingsummary',
            showSummaryRow: false
        },{
            id: 'masterGridTotal',
            ftype: 'uniSummary',
            showSummaryRow: true
        }],
        selModel: Ext.create('Ext.selection.CheckboxModel', {
            checkOnly: true,
            toggleOnClick: false,
            listeners: {
                beforeselect: function(rowSelection, record, index, eOpts) {

                },
                select: function(grid, record, index, eOpts ){

                },
                deselect:  function(grid, record, index, eOpts ){

                }
            }
        }),
        columns: [
                {dataIndex: 'CONFIRM'       ,width:60, align: 'center'},
                {dataIndex: 'COMP_CODE'     ,width:80,hidden:true},
                {dataIndex: 'DIV_CODE'      ,width:80,hidden:true},
                {dataIndex: 'INOUT_DATE'    ,width:100},
                {dataIndex: 'POS_NO'        ,width:100,align:'center',
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                   return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
                }},

                {dataIndex: 'POS_NAME'      ,width:200},
                {dataIndex: 'LOCATION'      ,width:300},
                {dataIndex: 'SALE_O'        ,width:120,summaryType: 'sum'},
                {dataIndex: 'SALE_AMT_O'    ,width:120,summaryType: 'sum'},
                {dataIndex: 'CARD_SALE_AMT_O'    ,width:120,summaryType: 'sum'},
                {dataIndex: 'OVER_SHORTAGE' ,width:120,summaryType: 'sum'},
                {dataIndex: 'CONFIRM_USER_ID',width:80}

        ],
        listeners: {
            cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
                if(rowIndex != beforeRowIndex){
                    masterForm.setValue('GRID_CUSTOM_CODE',record.get('POS_NO'));

//                  masterForm.setValue('SALE_COMMON_P',record.get('SALE_COMMON_P'));
                    directMasterStore2.loadStoreRecords(record);
                }
                beforeRowIndex = rowIndex;
            }
        }
    });     // End of masterGrid= Unilite.createGrid('sva200skrvGrid', {

    var masterGrid2 = Unilite.createGrid('sva200skrvGrid2', {
        layout: 'fit',
        region: 'south',
        uniOpt: {
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useMultipleSorting: true,
            useRowNumberer: false,
            expandLastColumn: false,
            filter: {
                useFilter: false,
                autoCreate: false
            }
        },
        features: [{
            id: 'masterGridSubTotal',
            ftype: 'uniGroupingsummary',
            showSummaryRow: false
        },{
            id: 'masterGridTotal',
            ftype: 'uniSummary',
            showSummaryRow: true
        }],
        store: directMasterStore2,
        columns: [
                {dataIndex: 'COMP_CODE'     ,width:80,hidden:true},
                {dataIndex: 'DIV_CODE'      ,width:80,hidden:true},
                {dataIndex: 'POS_NO'        ,width:80,hidden:true},
                {dataIndex: 'COLUMN_NO'     ,width:80,align:'center'},
            	{text: '품목코드',
                	columns: [{dataIndex: 'ITEM_CODE'     ,width:120,
						                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
						                   return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
						                }},
		               				 {dataIndex: 'ITEM_NAME'     ,width:300}]
                },
                {text: '수불번호',
                	columns: [{dataIndex: 'CASH_INOUT_NUM'     ,width:110},
	                			  {dataIndex: 'CARD_INOUT_NUM'     ,width:110}]
                },
                {text: '도수',
                	columns: [ {dataIndex: 'BEFORE_CNT'    ,width:120,summaryType: 'sum'},
                	               {dataIndex: 'AFTER_CNT'     ,width:120,summaryType: 'sum'}]
                },
                {text: '판매수량',
                	columns: [{dataIndex: 'SALE_Q'        ,width:120,summaryType: 'sum'},
                					{dataIndex: 'CARD_SALE_Q'        ,width:120,summaryType: 'sum'}]
                },
                {dataIndex: 'SALE_P'        ,width:120},
                {text: '판매금액',
                	columns: [{dataIndex: 'SALE_O'        ,width:120,summaryType: 'sum'},
               					 {dataIndex: 'CARD_SALE_O'        ,width:120,summaryType: 'sum'}]
                }
        ]
    });//End of var masterGrid = Unilite.createGrid('sva200skrvGrid1', {
    Unilite.Main({
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                masterGrid, masterGrid2, panelResult
            ]
        },
            masterForm
        ],
        id: 'sva200skrvApp',
        fnInitBinding: function() {
            //masterForm.getField('CUSTOM_CODE').focus();
            //panelResult.getField('CUSTOM_CODE').focus();
            UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
            this.setDefault();
        },
        onQueryButtonDown: function()   {
            /*masterForm.setAllFieldsReadOnly(false);
            var orderNo = masterForm.getValue('ORDER_NUM');
            if(Ext.isEmpty(orderNo)) {
                openSearchInfoWindow()
            } else {*/

            if(!UniAppManager.app.checkForNewDetail()){
                return false;
            }else{
                /*var param= masterForm.getValues();
                masterForm.uniOpt.inLoading=true;
                masterForm.getForm().load({
                    params: param,
                    success: function() {
                        masterForm.setAllFieldsReadOnly(true)

                        masterForm.uniOpt.inLoading=false;
                    },
                    failure: function(form, action) {
                        masterForm.uniOpt.inLoading=false;
                    }
                })*/
                directMasterStore1.loadStoreRecords();
                beforeRowIndex = -1;
            }
        },
        onResetButtonDown: function() {
            masterForm.clearForm();
//          masterForm.setAllFieldsReadOnly(false);
//          panelResult.setAllFieldsReadOnly(false);
            masterGrid.reset();
            masterGrid2.reset();
            panelResult.clearForm();
            this.fnInitBinding();
        },
        setDefault: function() {
            masterForm.setValue('DIV_CODE',UserInfo.divCode);
            masterForm.setValue('SALE_DATE',UniDate.get('today'));
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('SALE_DATE',UniDate.get('today'));

            masterForm.getForm().wasDirty = false;
            masterForm.resetDirtyStatus();
            UniAppManager.setToolbarButtons('save', false);
        },
        checkForNewDetail:function() {
            return masterForm.setAllFieldsReadOnly(true);
        }


    });     // End of Unilite.Main({
};
</script>
