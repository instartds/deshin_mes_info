<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sgp100ukrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_sgp100ukrv_kd"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--매출구분-->
    <t:ExtComboStore comboType="AU" comboCode="B004" /> <!--화폐-->
    <t:ExtComboStore comboType="AU" comboCode="B042" /> <!--계획금액단위-->
    <t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당-->
    <t:ExtComboStore comboType="AU" comboCode="B055" /> <!--고객분류-->
    <t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목계정-->
    <t:ExtComboStore comboType="AU" comboCode="B109" /> <!--유통-->
    <t:ExtComboStore comboType="AU" comboCode="WB06" /> <!--B/OUT관리여부-->
    <t:ExtComboStore comboType="AU" comboCode="WB19" /> <!--출고부서구분-->
</t:appConfig>
<script type="text/javascript" >

var SearchLogWindow;

var BsaCodeInfo = {     //컨트롤러에서 값을 받아옴.
    gsBalanceOut:        '${gsBalanceOut}'
};
//var output ='';   // 입고내역 셋팅 값 확인 alert
//for(var key in BsaCodeInfo){
//    output += key + '  :  ' + BsaCodeInfo[key] + '\n';
//}
//alert(output);

var CustomCodeInfo = {
	gsAgentType		: '',
	gsCustCreditYn	: '',
	gsUnderCalBase	: '',
	gsTaxInout		: '',
	gsbusiPrsn		: ''
};

function appMain() {
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_sgp100ukrv_kdService.selectList',
            update: 's_sgp100ukrv_kdService.updateDetail',
            create: 's_sgp100ukrv_kdService.insertDetail',
            destroy: 's_sgp100ukrv_kdService.deleteDetail',
            syncAll: 's_sgp100ukrv_kdService.saveAll'
        }
    });

    var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{     // 공정&설비 등록
        api: {
            read: 's_sgp100ukrv_kdService.selectList2'
        }
    });

    /**
     *   Model 정의
     * @type
     */
    Unilite.defineModel('s_sgp100ukrv_kdModel', {
        fields: [
            {name: 'DIV_CODE'                       ,text: 'DIV_CODE'        ,type:'string'},
            {name: 'PLAN_YEAR'                      ,text: 'PLAN_YEAR'       ,type:'string'},
            {name: 'PLAN_TYPE1'                     ,text: '판매유형'        ,type:'string'},
            {name: 'PLAN_TYPE2'                     ,text: 'TAB'             ,type:'string', defaultValue: '6'},
            {name: 'PLAN_TYPE2_CODE'                ,text: 'PLAN_TYPE2_CODE' ,type:'string'},
            {name: 'PLAN_TYPE2_CODE2'               ,text: 'PLAN_TYPE2_CODE2' ,type:'string'},
            {name: 'LEVEL_KIND'                     ,text: 'LEVEL_KIND'      ,type:'string', defaultValue: '*'},
            {name: 'MONEY_UNIT'                     ,text: 'MONEY_UNIT'      ,type:'string'},
            {name: 'ENT_MONEY_UNIT'                 ,text: 'ENT_MONEY_UNIT'  ,type:'string'},
            {name: 'AGENT_TYPE'                     ,text: 'AGENT_TYPE'      ,type:'string'},
            {name: 'TRANS_RATE'						, text:'<t:message code="system.label.sales.containedqty" default="입수"/>'				, type: 'uniQty', defaultValue: 1, allowBlank: false},
            {name: 'CONFIRM_YN'                     ,text: 'CONFIRM_YN'      ,type:'string', defaultValue: 'N'},
           // {name: 'SALE_BASIS_P'                   ,text: 'SALE_BASIS_P'    ,type:'string'},
            {name: 'SALE_BASIS_P'					,text:'SALE_BASIS_P'	, type: 'uniUnitPrice', defaultValue: 0, allowBlank: true, editable: true},
            {name: 'CUSTOM_CODE'                    ,text: '거래처코드'      ,type:'string', allowBlank: false},
            {name: 'CUSTOM_NAME'                    ,text: '거래처명'        ,type:'string', allowBlank: false},
            {name: 'DEPT_CODE'                      ,text: '부서코드'        ,type:'string'},
            {name: 'DEPT_NAME'                      ,text: '부서명'          ,type:'string'},
            {name: 'ITEM_CODE'                      ,text: '품목코드'        ,type:'string'},
            {name: 'ITEM_NAME'                      ,text: '품목명'          ,type:'string'},
            {name: 'SPEC'                           ,text: '규격/품번'            ,type:'string'},
            {name: 'OEM_ITEM_CODE'                  ,text: '품번'            ,type:'string'},
            {name: 'PLAN_SUM_Q'                     ,text: '수량'        ,type:'int'},
            {name: 'PLAN_SUM_AMT'                   ,text: '금액'        ,type:'uniPrice'},
            {name: 'MOD_PLAN_SUM_Q'                 ,text: '수정수량'        ,type:'int'},
            {name: 'MOD_PLAN_SUM_AMT'               ,text: '수정금액'        ,type:'uniPrice'},
            {name: 'PLAN_QTY1'                      ,text: '년초수량'        ,type:'int'/*, allowBlank: false*/},
            {name: 'PLAN_AMT1'                      ,text: '년초금액'        ,type:'uniPrice'/*, allowBlank: false*/},
            {name: 'MOD_PLAN_Q1'                    ,text: '수정수량'        ,type:'int'},
            {name: 'MOD_PLAN_AMT1'                  ,text: '수정금액'        ,type:'uniPrice'},
            {name: 'PLAN_QTY2'                      ,text: '년초수량'        ,type:'int'/*, allowBlank: false*/},
            {name: 'PLAN_AMT2'                      ,text: '년초금액'        ,type:'uniPrice'/*, allowBlank: false*/},
            {name: 'MOD_PLAN_Q2'                    ,text: '수정수량'        ,type:'int'},
            {name: 'MOD_PLAN_AMT2'                  ,text: '수정금액'        ,type:'uniPrice'},
            {name: 'PLAN_QTY3'                      ,text: '년초수량'        ,type:'int'/*, allowBlank: false*/},
            {name: 'PLAN_AMT3'                      ,text: '년초금액'        ,type:'uniPrice'/*, allowBlank: false*/},
            {name: 'MOD_PLAN_Q3'                    ,text: '수정수량'        ,type:'int'},
            {name: 'MOD_PLAN_AMT3'                  ,text: '수정금액'        ,type:'uniPrice'},
            {name: 'PLAN_QTY4'                      ,text: '년초수량'        ,type:'int'/*, allowBlank: false*/},
            {name: 'PLAN_AMT4'                      ,text: '년초금액'        ,type:'uniPrice'/*, allowBlank: false*/},
            {name: 'MOD_PLAN_Q4'                    ,text: '수정수량'        ,type:'int'},
            {name: 'MOD_PLAN_AMT4'                  ,text: '수정금액'        ,type:'uniPrice'},
            {name: 'PLAN_QTY5'                      ,text: '년초수량'        ,type:'int'/*, allowBlank: false*/},
            {name: 'PLAN_AMT5'                      ,text: '년초금액'        ,type:'uniPrice'/*, allowBlank: false*/},
            {name: 'MOD_PLAN_Q5'                    ,text: '수정수량'        ,type:'uniQty'},
            {name: 'MOD_PLAN_AMT5'                  ,text: '수정금액'        ,type:'uniPrice'},
            {name: 'PLAN_QTY6'                      ,text: '년초수량'        ,type:'int'/*, allowBlank: false*/},
            {name: 'PLAN_AMT6'                      ,text: '년초금액'        ,type:'uniPrice'/*, allowBlank: false*/},
            {name: 'MOD_PLAN_Q6'                    ,text: '수정수량'        ,type:'int'},
            {name: 'MOD_PLAN_AMT6'                  ,text: '수정금액'        ,type:'uniPrice'},
            {name: 'PLAN_QTY7'                      ,text: '년초수량'        ,type:'int'/*, allowBlank: false*/},
            {name: 'PLAN_AMT7'                      ,text: '년초금액'        ,type:'uniPrice'/*, allowBlank: false*/},
            {name: 'MOD_PLAN_Q7'                    ,text: '수정수량'        ,type:'int'},
            {name: 'MOD_PLAN_AMT7'                  ,text: '수정금액'        ,type:'uniPrice'},
            {name: 'PLAN_QTY8'                      ,text: '년초수량'        ,type:'int'/*, allowBlank: false*/},
            {name: 'PLAN_AMT8'                      ,text: '년초금액'        ,type:'uniPrice'/*, allowBlank: false*/},
            {name: 'MOD_PLAN_Q8'                    ,text: '수정수량'        ,type:'int'},
            {name: 'MOD_PLAN_AMT8'                  ,text: '수정금액'        ,type:'uniPrice'},
            {name: 'PLAN_QTY9'                      ,text: '년초수량'        ,type:'int'/*, allowBlank: false*/},
            {name: 'PLAN_AMT9'                      ,text: '년초금액'        ,type:'uniPrice'/*, allowBlank: false*/},
            {name: 'MOD_PLAN_Q9'                    ,text: '수정수량'        ,type:'int'},
            {name: 'MOD_PLAN_AMT9'                  ,text: '수정금액'        ,type:'uniPrice'},
            {name: 'PLAN_QTY10'                     ,text: '년초수량'        ,type:'int'/*, allowBlank: false*/},
            {name: 'PLAN_AMT10'                     ,text: '년초금액'        ,type:'uniPrice'/*, allowBlank: false*/},
            {name: 'MOD_PLAN_Q10'                   ,text: '수정수량'        ,type:'int'},
            {name: 'MOD_PLAN_AMT10'                 ,text: '수정금액'        ,type:'uniPrice'},
            {name: 'PLAN_QTY11'                     ,text: '년초수량'        ,type:'int'/*, allowBlank: false*/},
            {name: 'PLAN_AMT11'                     ,text: '년초금액'        ,type:'uniPrice'/*, allowBlank: false*/},
            {name: 'MOD_PLAN_Q11'                   ,text: '수정수량'        ,type:'int'},
            {name: 'MOD_PLAN_AMT11'                 ,text: '수정금액'        ,type:'uniPrice'},
            {name: 'PLAN_QTY12'                     ,text: '년초수량'        ,type:'int'/*, allowBlank: false*/},
            {name: 'PLAN_AMT12'                     ,text: '년초금액'        ,type:'uniPrice'/*, allowBlank: false*/},
            {name: 'MOD_PLAN_Q12'                   ,text: '수정수량'        ,type:'int'},
            {name: 'MOD_PLAN_AMT12'                 ,text: '수정금액'        ,type:'uniPrice'},
            {name: 'UPDATE_DB_USER'                 ,text: '수정자'         ,type:'string'},
            {name: 'UPDATE_DB_TIME'                 ,text: '수정시간'        ,type:'string'},
            {name: 'COMP_CODE'                      ,text: 'COMP_CODE'   ,type:'string', defaultValue: UserInfo.compCode},
            {name: 'FLAG'                           ,text: 'FLAG'        ,type:'string'},
            {name: 'INSERT_DB_USER'                 ,text: '입력자'         ,type:'string'},
            {name: 'INSERT_DB_TIME'                 ,text: '입력시간'        ,type:'string'},
            {name: 'SALE_UNIT'						,text:'SALE_UNIT'	  , type: 'string', allowBlank: true, comboType: 'AU', comboCode: 'B013', displayField: 'value'},
            {name: 'STOCK_UNIT'						,text:'STOCK_UNIT'	  ,type: 'string'},
            {name: 'WGT_UNIT'				, text:'<t:message code="system.label.sales.weightunit" default="중량단위"/>'			, type: 'string', defaultValue: BsaCodeInfo.gsWeight},
			{name: 'UNIT_WGT'				, text:'<t:message code="system.label.sales.unitweight" default="단위중량"/>'			, type: 'int', defaultValue: 0},
			{name: 'VOL_UNIT'				, text:'<t:message code="system.label.sales.volumnunit" default="부피단위"/>'			, type: 'string', defaultValue: BsaCodeInfo.gsVolume},
			{name: 'UNIT_VOL'				, text:'<t:message code="system.label.sales.unitvolumn" default="단위부피"/>'			, type: 'string', defaultValue: 0},
			{name: 'PRICE_TYPE'				, text:'<t:message code="system.label.sales.priceclass" default="단가구분"/>'			, type: 'string', defaultValue: BsaCodeInfo.gsPriceGubun},
			{name: 'PRICE_YN'				, text:'<t:message code="system.label.sales.priceclass" default="단가구분"/>'			, type: 'string', comboType: 'AU', comboCode: 'S003', defaultValue: "2", allowBlank: false}
        ]
    });

    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directMasterStore = Unilite.createStore('s_sgp100ukrv_kdMasterStore6',{
        model: 's_sgp100ukrv_kdModel',
        uniOpt : {
            isMaster: true,         // 상위 버튼 연결
            editable: true,         // 수정 모드 사용
            deletable:true,         // 삭제 가능 여부
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {
        /*  var param= Ext.getCmp('searchForm').getValues();
            console.log( param );
            this.load({
                params : param*/
            var param= panelSearch.getValues();
            param.AGENT_TYPE = addResult.getValue('AGENT_TYPE');
            this.load({
                  params : param
            });
        },
        saveStore : function(config)    {
            var inValidRecs = this.getInvalidRecords();
            console.log("inValidRecords : ", inValidRecs);

            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();
            var toDelete = this.getRemovedRecords();
            var list = [].concat(toUpdate, toCreate);

            var isErr = false;
            Ext.each(list, function(record, index) {
            	if(panelResult.getValue('ITEM_CHK') == false) {
                    if(Ext.isEmpty(record.data['ITEM_CODE']) || Ext.isEmpty(record.data['ITEM_NAME'])) {
                        alert((index + 1) + '행의 입력값을 확인해 주세요.\n' + '품목코드: 필수 입력값 입니다.');
                        isErr = true;
                        return false;
                    }
                }
            });
            if(isErr) return false;

            if(inValidRecs.length == 0 )    {
                config = {
                    success: function(batch, option) {
//                        panelSearch.resetDirtyStatus();
                        UniAppManager.setToolbarButtons('save', false);

                        var count = masterGrid.getStore().getCount();
                        if(count > 0) {
                        	UniAppManager.app.onQueryButtonDown();
                        } else {
                            UniAppManager.app.onResetButtonDown();
                        }
                     }
                };
                this.syncAllDirect(config);
            }else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        _onStoreDataChanged: function( store, eOpts )   {
            if(this.uniOpt.isMaster) {
                console.log("_onStoreDataChanged store.count() : ", store.count());
                if(store.count() == 0)  {
                    UniApp.setToolbarButtons(['delete'], false);
                    Ext.apply(this.uniOpt.state, {'btn':{'delete':false}});
                    if(this.uniOpt.useNavi) {
                        UniApp.setToolbarButtons(['prev','next'], false);
                    }
                }else {
                    if(this.uniOpt.deletable)   {
                        record = this.data.items[0];
                        if(record.get('CONFIRM_YN') == "N"){
                            UniApp.setToolbarButtons(['delete'], true);
                        }
                        else {
                        	UniApp.setToolbarButtons(['delete'], false);
                        }

                        Ext.apply(this.uniOpt.state, {'btn':{'delete':true}});
                    }
                    if(this.uniOpt.useNavi) {
                        UniApp.setToolbarButtons(['prev','next'], true);
                    }
                }
                if(store.isDirty()) {
                    UniApp.setToolbarButtons(['save'], true);
                }else {
                    UniApp.setToolbarButtons(['save'], false);
                }
            }
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
                if(store.getCount() != 0) {
                    var record = directMasterStore.data.items;
                    if(record[0].data.CONFIRM_YN == 'Y') {
                        Ext.getCmp('CONFIRM_DATA1').setText('년초계획변경');
                        Ext.getCmp('CREATE_DATA1').setDisabled(true);
                        Ext.getCmp('CONFIRM_DATA1').setDisabled(false);
                        UniApp.setToolbarButtons(['delete', 'deleteAll'], false);
                    } else if(record[0].data.CONFIRM_YN == 'N') {
                        Ext.getCmp('CONFIRM_DATA1').setText('년초계획확정');
                        Ext.getCmp('CREATE_DATA1').setDisabled(true);
                        Ext.getCmp('CONFIRM_DATA1').setDisabled(false);
                        UniApp.setToolbarButtons(['delete', 'deleteAll'], true);
                    }
                    Ext.getCmp('SEARCH_LOG').setDisabled(false);
                } else {
                    Ext.getCmp('CONFIRM_DATA1').setText('년초계획확정');
                    Ext.getCmp('CREATE_DATA1').setDisabled(false);
                    Ext.getCmp('CONFIRM_DATA1').setDisabled(true);
                    Ext.getCmp('SEARCH_LOG').setDisabled(true);
                    UniApp.setToolbarButtons(['delete', 'deleteAll'], false);
//                    masterGrid2.reset();
                }
            }
        },
        groupField : ''
    });


    // LOG 조회 스토어
    var directMasterStore2 = Unilite.createStore('directMasterStore2',{
            model: 's_sgp100ukrv_kdModel',
            autoLoad: false,
            uniOpt : {
                isMaster: true,         // 상위 버튼 연결
                editable: false,         // 수정 모드 사용
                deletable:false,         // 삭제 가능 여부
                allDeletable: false,     // 전체 삭제 가능 여부
                useNavi : false         // prev | next 버튼 사용
            },
            proxy : directProxy2,
            loadStoreRecords : function(param){
                this.load({
                    params: param
                });
            },
            listeners: {
                load: function(store, records, successful, eOpts) {

                }
            }
    });

    /**
     * 검색조건 (Search Panel)
     * @type
     */
    var panelSearch = Unilite.createSearchPanel('searchForm', {
        title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,//true,
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
            items: [{
                fieldLabel: '사업장',
                name: 'DIV_CODE',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                allowBlank:false,
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('DIV_CODE', newValue);
                    }
                }
            },{
                fieldLabel: '계획년도',
                name: 'PLAN_YEAR',
                xtype: 'uniYearField',
                value: new Date().getFullYear(),
                allowBlank: false,
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('PLAN_YEAR', newValue);
                    }
                }
            },{
                fieldLabel: '부서구분',
                name:'DEPT_CODE',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'WB19',
                allowBlank: true,
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('DEPT_CODE', newValue);
                        if(newValue == '3'){
                        	panelResult.setValue('ORDER_TYPE', 40);
                        }else{
                        	panelResult.setValue('ORDER_TYPE', 10);
                        }
                    }
                }
            },{
                fieldLabel: '판매유형',
                name:'ORDER_TYPE',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'S002',
                allowBlank: true,
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('ORDER_TYPE', newValue);
                    }
                }
            },{
                fieldLabel: '화폐',
                name:'MONEY_UNIT',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'B004',
                displayField: 'value',
                allowBlank: false,
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('MONEY_UNIT', newValue);
                    }
                }
            },{
                fieldLabel: '계획금액단위',
                name:'MONEY_UNIT_DIV',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'B042',
                allowBlank: false,
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('MONEY_UNIT_DIV', newValue);
                    }
                }
            }, {
                fieldLabel: ' ',
                name: '',
                xtype: 'uniCheckboxgroup',
                items: [{
                    boxLabel: '거래처별등록',
                    name: 'ITEM_CHK',
                    uncheckedValue: 'N',
                    holdable: 'hold',
                    inputValue: 'Y',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                        	/* if(panelSearch.getValue('ITEM_CHK') != true) {
                        	   directMasterStore.setConfig('groupField', false);
                        	} else {
                        		directMasterStore.setConfig('groupField', 'CUSTOM_CODE');
                        	} */

                            panelSearch.setValue('ITEM_CHK', newValue);
                            UniAppManager.app.onQueryButtonDown();
                        }
                    }
                }]
            }, Unilite.popup('AGENT_CUST', {
                fieldLabel: '거래처',
                valueFieldName: 'CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME',
                holdable: 'hold',
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
                            panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelSearch.setValue('CUSTOM_CODE', '');
                        panelSearch.setValue('CUSTOM_NAME', '');
                    }
                }
        }),
                Unilite.popup('DIV_PUMOK',{
                        fieldLabel: '품목',
                        valueFieldName: 'ITEM_CODE',
                        textFieldName: 'ITEM_NAME',
                        autoPopup:true,
                        listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
                                panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            panelResult.setValue('ITEM_CODE', '');
                            panelResult.setValue('ITEM_NAME', '');
                        }
                    }
               })
//                {
//                fieldLabel : ' ',
//                name:'SPEC',
//                xtype:'uniTextfield',
//                readOnly:true,
//                hideLabel:true,
//                listeners: {
//                    change: function(field, newValue, oldValue, eOpts) {
//                        panelResult.setValue('SPEC', newValue);
//                    }
//                }
//            },
           ]
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
                    //this.mask();
                    var fields = this.getForm().getFields();
                    Ext.each(fields.items, function(item) {
                        if(Ext.isDefined(item.holdable) ) {
                            if (item.holdable == 'hold') {
                                item.setReadOnly(false);
                            }
                        }
                        if(item.isPopupField) {
                            var popupFC = item.up('uniPopupField') ;
                            if(popupFC.holdable == 'hold') {
                                popupFC.setReadOnly(false);
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
        }
    });
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 4},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
            fieldLabel: '사업장',
            name: 'DIV_CODE',
            xtype: 'uniCombobox',
            comboType: 'BOR120',
            allowBlank:false,
            holdable: 'hold',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('DIV_CODE', newValue);
                }
            }
        },{
            fieldLabel: '계획년도',
            name: 'PLAN_YEAR',
            xtype: 'uniYearField',
            value: new Date().getFullYear(),
            allowBlank: false,
            holdable: 'hold',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('PLAN_YEAR', newValue);
                }
            }
        },{
            fieldLabel: '부서구분',
            name:'DEPT_CODE',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'WB19',
            colspan : 2,
            allowBlank: true,
            holdable: 'hold',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('DEPT_CODE', newValue);
                    if(newValue == '3'){
                    	panelSearch.setValue('ORDER_TYPE', 40);
                    }else{
                    	panelSearch.setValue('ORDER_TYPE', 10);
                    }
                }
            }
        },{
            fieldLabel: '판매유형',
            name:'ORDER_TYPE',
            id: 'ORDER_TYPE',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'S002',
            allowBlank: true,
            holdable: 'hold',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('ORDER_TYPE', newValue);
                }
            }
        },{
            fieldLabel: '화폐',
            name:'MONEY_UNIT',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'B004',
            displayField: 'value',
            allowBlank: false,
            holdable: 'hold',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('MONEY_UNIT', newValue);
                }
            }
        },{
            fieldLabel: '계획금액단위',
            name:'MONEY_UNIT_DIV',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'B042',
            holdable: 'hold',
            allowBlank: false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('MONEY_UNIT_DIV', newValue);
                }
            }
        },{
            fieldLabel: ' ',
            name: '',
            xtype: 'uniCheckboxgroup',
            items: [{
                boxLabel: '거래처별등록',
                name: 'ITEM_CHK',
                uncheckedValue: 'N',
                inputValue: 'Y',
//                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                     /*    if(panelResult.getValue('ITEM_CHK') != true) {
                           directMasterStore.setConfig('groupField', false);
                        } else {
                            directMasterStore.setConfig('groupField', 'CUSTOM_CODE');
                        } */

                        panelSearch.setValue('ITEM_CHK', newValue);
                        UniAppManager.app.onQueryButtonDown();
                    }
                }
            }]
        }, Unilite.popup('AGENT_CUST', {
            fieldLabel: '거래처',
            valueFieldName: 'CUSTOM_CODE',
            textFieldName: 'CUSTOM_NAME',
            holdable: 'hold',
            listeners: {
                onSelected: {
                    fn: function(records, type) {
                        panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
                        panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
                    },
                    scope: this
                },
                onClear: function(type) {
                    panelSearch.setValue('CUSTOM_CODE', '');
                    panelSearch.setValue('CUSTOM_NAME', '');
                }
            }
   		 }), Unilite.popup('DIV_PUMOK',{
                        fieldLabel: '품목',
                        valueFieldName: 'ITEM_CODE',
                        textFieldName: 'ITEM_NAME',
                        autoPopup:true,
                       listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
                                panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            panelSearch.setValue('ITEM_CODE', '');
                            panelSearch.setValue('ITEM_NAME', '');
                        }
                    }
               })
//                {
//                fieldLabel : ' ',
//                name:'SPEC',
//                xtype:'uniTextfield',
//                readOnly:true,
//                hideLabel:true,
//                listeners: {
//                    change: function(field, newValue, oldValue, eOpts) {
//                        panelSearch.setValue('SPEC', newValue);
//                    }
//                }
//            },
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
                                item.setReadOnly(false);
                            }
                        }
                        if(item.isPopupField) {
                            var popupFC = item.up('uniPopupField') ;
                            if(popupFC.holdable == 'hold') {
                                popupFC.setReadOnly(false);
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
        }
    });

    var addResult = Unilite.createSearchForm('detailForm', { //createForm
        layout : {type:'uniTable', columns: '1'},
        disabled: false,
        border:true,
        hidden : true,
        height: 32,
        padding:'1 1 1 1',
        region: 'center',
        items: [{
            fieldLabel: '고객분류',
            name:'AGENT_TYPE',
            allowBlank: false,
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'B055',
            value: '1'
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
        }
    });

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
    var masterGrid = Unilite.createGrid('s_sgp100ukrv_kdmasterGrid', {
        layout : 'fit',
        region: 'center',
        store: directMasterStore,
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: false,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        tbar: [
            {
                xtype: 'button',
                text: '저장이력 조회',
                name: '',
                id: 'SEARCH_LOG',
                itemId: 'btnSearchLog',
                width: 110,
                handler : function(records, grid, record) {
                	openSearchLogWindow()
                }
            },
            {
                xtype: 'button',
                text: '년초계획확정',
                name: '',
                id: 'CONFIRM_DATA1',
                itemId: 'btnViewAutoSlip',
                width: 110,
                handler : function(records, grid, record) {
                    var me = this;
                    panelSearch.getEl().mask('로딩중...','loading-indicator');
                    panelResult.getEl().mask('로딩중...','loading-indicator');
                    var record = masterGrid.getSelectedRecord();
                    var param= panelSearch.getValues();
                    param.PLAN_TYPE1 = record.data['PLAN_TYPE1']
                    param.PLAN_TYPE2 = record.data['PLAN_TYPE2']
                    param.PLAN_TYPE2_CODE = record.data['PLAN_TYPE2_CODE']
                    param.PLAN_TYPE2_CODE2 = record.data['PLAN_TYPE2_CODE2']
                    param.LEVEL_KIND = record.data['LEVEL_KIND']
                    if(panelResult.getValue('ITEM_CHK') == true) {
                        param.TAB = "CUSTOM";
                    } else {
                        param.TAB = "CUSTOMMODEL";
                    }
                    if(record.get('CONFIRM_YN') == 'Y') {
                        s_sgp100ukrv_kdService.cancleDataList(param,
                            function(provider, response) {
                                UniAppManager.updateStatus("완료 되었습니다.");
                                UniAppManager.app.onQueryButtonDown();
                                me.setDisabled(true);
                                panelSearch.getEl().unmask();
                                panelResult.getEl().unmask();
                            }
                        )
                    } else if(record.get('CONFIRM_YN') == 'N') {
                    	if(confirm('확정하시겠습니까?')) {
                            s_sgp100ukrv_kdService.confirmDataList(param,
                                function(provider, response) {
                                    UniAppManager.updateStatus("완료 되었습니다.");
                                    UniAppManager.app.onQueryButtonDown();
                                    me.setDisabled(true);
                                    UniAppManager.setToolbarButtons(['deleteAll'],false);
//                                    panelSearch.getEl().unmask();
//                                    panelResult.getEl().unmask();
                                }
                            )
                    	}
                        panelSearch.getEl().unmask();
                        panelResult.getEl().unmask();
                    }
                }
            },{
                xtype: 'button',
                text: '기초데이터생성',
                id: 'CREATE_DATA1',
                hidden : true,
                name: '',
                //inputValue: '2',
                width: 110,
                handler : function(records, grid, record) {
                    var me = this;
                    panelSearch.getEl().mask('로딩중...','loading-indicator');
                    panelResult.getEl().mask('로딩중...','loading-indicator');
                    var param= panelSearch.getValues();
                    var grid = this.down('#s_sgp100ukrv_kdmasterGrid');
//                    var records = grid.getStore().getAt(0);
                    if(panelResult.getValue('ITEM_CHK') == true) {
                        param.TAB = "CUSTOM";
                    } else {
                    	param.TAB = "CUSTOMMODEL";
                    }

                    s_sgp100ukrv_kdService.creatCustomerItemDataList(param,
                        function(provider, response) {
                        	var store = masterGrid.getStore();
                            var records = response.result;
                            if(!Ext.isEmpty(provider)){
                            	store.insert(0, records);
//                                Ext.each(provider, function(record,i){
//                                    UniAppManager.app.onNewDataButtonDown();
//                                    masterGrid.setCustomItemData(record);
//                                    me.setDisabled(true);
//                                });
                                UniAppManager.updateStatus("완료 되었습니다.");
                                Ext.getCmp('CREATE_DATA1').setDisabled(true);
                                Ext.getCmp('CONFIRM_DATA1').setDisabled(true);
                                panelSearch.getEl().unmask();
                                panelResult.getEl().unmask();
                            } else {
                                Ext.getCmp('CREATE_DATA1').setDisabled(true);
                                Ext.getCmp('CONFIRM_DATA1').setDisabled(true);
                                panelSearch.getEl().unmask();
                                panelResult.getEl().unmask();
                            }
                        }
                    )



                }
            }
        ],
        features: [
            {id: 'masterGridSubTotal',     ftype: 'uniGroupingsummary',    showSummaryRow: true},
            {id: 'masterGridTotal',        ftype: 'uniSummary',            showSummaryRow: true}
        ],
        columns:  [ { dataIndex: 'DIV_CODE'                  ,           width:86, hidden: true }
                   ,{ dataIndex: 'PLAN_YEAR'                 ,           width:86, hidden: true }
                   ,{ dataIndex: 'PLAN_TYPE1'                ,           width:86, hidden: true }
                   ,{ dataIndex: 'PLAN_TYPE2'                ,           width:86, hidden: true }
                   ,{ dataIndex: 'PLAN_TYPE2_CODE'           ,           width:86, hidden: true }
                   ,{ dataIndex: 'PLAN_TYPE2_CODE2'          ,           width:86, hidden: true }
                   ,{ dataIndex: 'DEPT_CODE'                 ,           width:86, hidden: true }
                   ,{ dataIndex: 'LEVEL_KIND'                ,           width:86, hidden: true }
                   ,{ dataIndex: 'MONEY_UNIT'                ,           width:86, hidden: true }
                   ,{ dataIndex: 'AGENT_TYPE'                ,           width:86, hidden: true }
                   ,{ dataIndex: 'TRANS_RATE'				 , 			 width:60, hidden: true }
                   ,{ dataIndex: 'ENT_MONEY_UNIT'            ,           width:86, hidden: true }
                   ,{ dataIndex: 'CONFIRM_YN'                ,           width:86, hidden: true }
                   ,{ dataIndex: 'SALE_BASIS_P'              ,           width:86, hidden: true }
                   ,{ dataIndex: 'CUSTOM_CODE'           ,           width:86,
                        'editor' : Unilite.popup('AGENT_CUST_G',{
                            textFieldName: 'CUSTOM_NAME',
                            DBtextFieldName: 'CUSTOM_NAME',
//                            extParam: {'CUSTOM_TYPE': ['1','3']},
//                            extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
			    			autoPopup: true,
                            listeners: {'onSelected': {
                                    fn: function(records, type) {
                                        console.log('records : ', records);
                                        Ext.each(records, function(record,i) {
                                            console.log('record',record);
                                            if(i==0) {
                                                masterGrid.setCustData(record,false, masterGrid.uniOpt.currentRecord);
                                            } else {
                                                UniAppManager.app.onNewDataButtonDown();
                                                masterGrid.setCustData(record,false, masterGrid.uniOpt.currentRecord);
                                            }
                                        });
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    masterGrid.setCustData(null,true, masterGrid.uniOpt.currentRecord);
                                },
                                applyextparam: function(popup) {
                                    popup.setExtParam({'CUSTOM_TYPE': ['1','3']});
                                }
                            }
                        })
                      }
                  ,{ dataIndex: 'CUSTOM_NAME'               ,           width:86 ,
                        'editor' : Unilite.popup('AGENT_CUST_G',{
//                            extParam: {'CUSTOM_TYPE': ['1','3']},
//                            extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
			    			autoPopup: true,
                            listeners: {'onSelected': {
                                    fn: function(records, type) {
                                        console.log('records : ', records);
                                        Ext.each(records, function(record,i) {
                                            if(i==0) {
                                                masterGrid.setCustData(record,false, masterGrid.uniOpt.currentRecord);
                                            } else {
                                                UniAppManager.app.onNewDataButtonDown();
                                                masterGrid.setCustData(record,false, masterGrid.uniOpt.currentRecord);
                                            }
                                        });
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    masterGrid.setCustData(null,true, masterGrid.uniOpt.currentRecord);
                                },
                                applyextparam: function(popup) {
                                    popup.setExtParam({'CUSTOM_TYPE': ['1','3']});
                                }
                            }
                        })
                     },
//                  ,{dataIndex:'DEPT_CODE'      ,width:100,
//                    editor: Unilite.popup('DEPT_G',{
//    //                  textFieldName: 'TREE_CODE',
//                        DBtextFieldName: 'DEPT_CODE',
//                            listeners: {'onSelected': {
//                                fn: function(records, type) {
//                                        var rtnRecord = masterGrid.uniOpt.currentRecord;
//                                        rtnRecord.set('DEPT_CODE', records[0]['TREE_CODE']);
//                                        rtnRecord.set('DEPT_NAME', records[0]['TREE_NAME']);
//                                    },
//                                scope: this
//                                },
//                                'onClear': function(type) {
//                                    var rtnRecord = masterGrid.uniOpt.currentRecord;
//                                        rtnRecord.set('DEPT_CODE', '');
//                                        rtnRecord.set('DEPT_NAME', '');
//                                },
//                                applyextparam: function(popup){
//
//                                }
//                            }
//                    })
//                }
//                ,{dataIndex:'DEPT_NAME'        ,width:150,
//                    editor: Unilite.popup('DEPT_G',{
//    //                  textFieldName: 'TREE_NAME',
//                        DBtextFieldName: 'DEPT_NAME',
//                            listeners: {'onSelected': {
//                                fn: function(records, type) {
//                                        var rtnRecord = masterGrid.uniOpt.currentRecord;
//                                        rtnRecord.set('DEPT_CODE', records[0]['TREE_CODE']);
//                                        rtnRecord.set('DEPT_NAME', records[0]['TREE_NAME']);
//                                    },
//                                scope: this
//                                },
//                                'onClear': function(type) {
//                                    var rtnRecord = masterGrid.uniOpt.currentRecord;
//                                        rtnRecord.set('DEPT_CODE', '');
//                                        rtnRecord.set('DEPT_NAME', '');
//                                },
//                                applyextparam: function(popup){
//
//                                }
//                            }
//                    })
//                },
                  {
                    text: '품목정보',
                    columns:[
                       { dataIndex:  'ITEM_CODE'                ,           width:100,
                            summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                                return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
                            },
                            'editor' : Unilite.popup('DIV_PUMOK_G', {
                                        textFieldName: 'ITEM_CODE',
                                        DBtextFieldName: 'ITEM_CODE',
			    						autoPopup: true,
                                        listeners: {
                                                    applyextparam: function(popup){
                                                        popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE'),
                                                                           'ADD_OEM': ", OEM_ITEM_CODE"});           //OEM_ITEM_CODE조회
                                                        if(BsaCodeInfo.gsBalanceOut == 'Y') {
                                                            popup.setExtParam({'ADD_QUERY': "ISNULL(B_OUT_YN, 'N') != N'Y'"});           //WHERE절 추가 쿼리
                                                        }
                                                    },
                                                    'onSelected': {
                                                            fn: function(records, type) {
                                                                    console.log('records : ', records);
                                                                    Ext.each(records, function(record,i) {
                                                                                        if(i==0) {
                                                                                                    masterGrid.setItemCodeData(record,false, masterGrid.uniOpt.currentRecord);
                                                                                                } else {
                                                                                                    UniAppManager.app.onNewDataButtonDown();
                                                                                                    masterGrid.setItemCodeData(record,false, masterGrid.getSelectedRecord());
                                                                                                }
                                                                    });
                                                            },
                                                            scope: this
                                                    },
                                                    'onClear': function(type) {
                                                        masterGrid.setItemCodeData(null,true, masterGrid.uniOpt.currentRecord);
                                                    }
                                            }
                         })
                          }
                      ,{ dataIndex: 'ITEM_NAME'                ,           width:100 ,
                            'editor' : Unilite.popup('DIV_PUMOK_G', {
    //                                    extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
			    						autoPopup: true,
                                        listeners: {
                                                    applyextparam: function(popup){
                                                        popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE'),
                                                                           'ADD_OEM': ", OEM_ITEM_CODE"});
                                                        if(BsaCodeInfo.gsBalanceOut == 'Y') {
                                                            popup.setExtParam({'ADD_QUERY': "ISNULL(B_OUT_YN, 'N') != N'Y'"});           //WHERE절 추가 쿼리
                                                        }
                                                    },
                                                    'onSelected': {
                                                            fn: function(records, type) {
                                                                    console.log('records : ', records);
                                                                    Ext.each(records, function(record,i) {
                                                                                        if(i==0) {
                                                                                                    masterGrid.setItemCodeData(record,false, masterGrid.uniOpt.currentRecord);
                                                                                                } else {
                                                                                                    UniAppManager.app.onNewDataButtonDown();
                                                                                                    masterGrid.setItemCodeData(record,false, masterGrid.getSelectedRecord());
                                                                                                }
                                                                    });
                                                            },
                                                            scope: this
                                                    },
                                                    'onClear': function(type) {
                                                        masterGrid.setItemCodeData(null,true, masterGrid.uniOpt.currentRecord);
                                                    }
                                            }
                        })
                         }
                       ,{ dataIndex: 'SPEC'                          ,           width:150 }
                       ,{ dataIndex: 'OEM_ITEM_CODE'                 ,           width:105, hidden:true }
                     ]
                  }
                   ,{
                    text: '합계',
                    columns:[
                        { dataIndex: 'PLAN_SUM_Q'                ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'PLAN_SUM_AMT'              ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'MOD_PLAN_SUM_Q'            ,           width:86, summaryType: 'sum', hidden:true}
                       ,{ dataIndex: 'MOD_PLAN_SUM_AMT'          ,           width:86, summaryType: 'sum', hidden:true}
                    ]
                  },{
                    text: '1월',
                    columns:[
                        { dataIndex: 'PLAN_QTY1'                 ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'PLAN_AMT1'                 ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'MOD_PLAN_Q1'               ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'MOD_PLAN_AMT1'             ,           width:86, summaryType: 'sum'}
                    ]
                  },{
                    text: '2월',
                    columns:[
                        { dataIndex: 'PLAN_QTY2'                 ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'PLAN_AMT2'                 ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'MOD_PLAN_Q2'               ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'MOD_PLAN_AMT2'             ,           width:86, summaryType: 'sum'}
                    ]
                  },{
                    text: '3월',
                    columns:[
                        { dataIndex: 'PLAN_QTY3'                 ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'PLAN_AMT3'                 ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'MOD_PLAN_Q3'               ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'MOD_PLAN_AMT3'             ,           width:86, summaryType: 'sum'}
                    ]
                  },{
                    text: '4월',
                    columns:[
                        { dataIndex: 'PLAN_QTY4'                 ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'PLAN_AMT4'                 ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'MOD_PLAN_Q4'               ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'MOD_PLAN_AMT4'             ,           width:86, summaryType: 'sum'}
                    ]
                  },{
                    text: '5월',
                    columns:[
                        { dataIndex: 'PLAN_QTY5'                 ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'PLAN_AMT5'                 ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'MOD_PLAN_Q5'               ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'MOD_PLAN_AMT5'             ,           width:86, summaryType: 'sum'}
                    ]
                  },{
                    text: '6월',
                    columns:[
                        { dataIndex: 'PLAN_QTY6'                 ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'PLAN_AMT6'                 ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'MOD_PLAN_Q6'               ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'MOD_PLAN_AMT6'             ,           width:86, summaryType: 'sum'}
                    ]
                  },{
                    text: '7월',
                    columns:[
                        { dataIndex: 'PLAN_QTY7'                 ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'PLAN_AMT7'                 ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'MOD_PLAN_Q7'               ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'MOD_PLAN_AMT7'             ,           width:86, summaryType: 'sum'}
                    ]
                  },{
                    text: '8월',
                    columns:[
                        { dataIndex: 'PLAN_QTY8'                 ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'PLAN_AMT8'                 ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'MOD_PLAN_Q8'               ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'MOD_PLAN_AMT8'             ,           width:86, summaryType: 'sum'}
                    ]
                  },{
                    text: '9월',
                    columns:[
                        { dataIndex: 'PLAN_QTY9'                 ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'PLAN_AMT9'                 ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'MOD_PLAN_Q9'               ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'MOD_PLAN_AMT9'             ,           width:86, summaryType: 'sum'}
                    ]
                  },{
                    text: '10월',
                    columns:[
                        { dataIndex: 'PLAN_QTY10'                ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'PLAN_AMT10'                ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'MOD_PLAN_Q10'              ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'MOD_PLAN_AMT10'            ,           width:86, summaryType: 'sum'}
                    ]
                  },{
                    text: '11월',
                    columns:[
                        { dataIndex: 'PLAN_QTY11'                ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'PLAN_AMT11'                ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'MOD_PLAN_Q11'              ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'MOD_PLAN_AMT11'            ,           width:86, summaryType: 'sum'}
                    ]
                  },{
                    text: '12월',
                    columns:[
                        { dataIndex: 'PLAN_QTY12'                ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'PLAN_AMT12'                ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'MOD_PLAN_Q12'              ,           width:86, summaryType: 'sum'}
                       ,{ dataIndex: 'MOD_PLAN_AMT12'            ,           width:86, summaryType: 'sum'}
                    ]
                  }
                   ,{ dataIndex: 'UPDATE_DB_USER'            , width:86, hidden: true }
                   ,{ dataIndex: 'UPDATE_DB_TIME'            , width:86, hidden: true }
                   ,{ dataIndex: 'COMP_CODE'                 , width:86, hidden: true }
                   ,{ dataIndex: 'SALE_UNIT'			     , width:66, hidden: true }
                   ,{ dataIndex: 'STOCK_UNIT'			     , width:80, align: 'center',hidden: true }
                   ,{ dataIndex: 'WGT_UNIT'			     , width:66, hidden: true }
                   ,{ dataIndex: 'UNIT_WGT'			     , width:66, hidden: true }
                   ,{ dataIndex: 'VOL_UNIT'			     , width:66, hidden: true }
                   ,{ dataIndex: 'UNIT_VOL'			     , width:66, hidden: true }
                   ,{ dataIndex: 'PRICE_TYPE'			 , width:66, hidden: true }
                   ,{ dataIndex: 'PRICE_YN'			     , width:66, hidden: true }


          ],
          listeners: {
                beforeedit  : function( editor, e, eOpts ) {
                    if(e.record.phantom == false) {
                        var record = masterGrid.getSelectedRecord();
                        if(record.get('CONFIRM_YN') == 'N') {
                            if(UniUtils.indexOf(e.field, ['PLAN_QTY1', 'PLAN_AMT1', 'PLAN_QTY2', 'PLAN_AMT2', 'PLAN_QTY3', 'PLAN_AMT3', 'PLAN_QTY4', 'PLAN_AMT4', 'PLAN_QTY5', 'PLAN_AMT5'
                                                            , 'PLAN_QTY6', 'PLAN_AMT6', 'PLAN_QTY7', 'PLAN_AMT7', 'PLAN_QTY8', 'PLAN_AMT8', 'PLAN_QTY9', 'PLAN_AMT9', 'PLAN_QTY10', 'PLAN_AMT10', 'PLAN_QTY11', 'PLAN_AMT11', 'PLAN_QTY12', 'PLAN_AMT12'])) {
                                return true;
                            } else {
                                return false;
                            }
                        } else {
                            if(UniUtils.indexOf(e.field, ['MOD_PLAN_Q1', 'MOD_PLAN_AMT1', 'MOD_PLAN_Q2', 'MOD_PLAN_AMT2', 'MOD_PLAN_Q3', 'MOD_PLAN_AMT3', 'MOD_PLAN_Q4', 'MOD_PLAN_AMT4', 'MOD_PLAN_Q5', 'MOD_PLAN_AMT5'
                                                            , 'MOD_PLAN_Q6', 'MOD_PLAN_AMT6', 'MOD_PLAN_Q7', 'MOD_PLAN_AMT7', 'MOD_PLAN_Q8', 'MOD_PLAN_AMT8', 'MOD_PLAN_Q9', 'MOD_PLAN_AMT9', 'MOD_PLAN_Q10', 'MOD_PLAN_AMT10', 'MOD_PLAN_Q11', 'MOD_PLAN_AMT11', 'MOD_PLAN_Q12', 'MOD_PLAN_AMT12'])) {
                                return true;
                            } else {
                                return false;
                            }
                        }
                    } else {
                        var record = masterGrid.getSelectedRecord();
                        if(record.get('CONFIRM_YN') == 'N') {
                            if(UniUtils.indexOf(e.field, ['CUSTOM_CODE', 'CUSTOM_NAME', 'ITEM_CODE', 'ITEM_NAME', 'PLAN_QTY1', 'PLAN_AMT1', 'PLAN_QTY2', 'PLAN_AMT2', 'PLAN_QTY3', 'PLAN_AMT3', 'PLAN_QTY4', 'PLAN_AMT4', 'PLAN_QTY5', 'PLAN_AMT5'
                                                            , 'PLAN_QTY6', 'PLAN_AMT6', 'PLAN_QTY7', 'PLAN_AMT7', 'PLAN_QTY8', 'PLAN_AMT8', 'PLAN_QTY9', 'PLAN_AMT9', 'PLAN_QTY10', 'PLAN_AMT10', 'PLAN_QTY11', 'PLAN_AMT11', 'PLAN_QTY12', 'PLAN_AMT12'])) {
                                return true;
                            } else {
                                return false;
                            }
                        } else {
                            if(UniUtils.indexOf(e.field, ['CUSTOM_CODE', 'CUSTOM_NAME', 'ITEM_CODE', 'ITEM_NAME','MOD_PLAN_Q1', 'MOD_PLAN_AMT1', 'MOD_PLAN_Q2', 'MOD_PLAN_AMT2', 'MOD_PLAN_Q3', 'MOD_PLAN_AMT3', 'MOD_PLAN_Q4', 'MOD_PLAN_AMT4', 'MOD_PLAN_Q5', 'MOD_PLAN_AMT5'
                                                            , 'MOD_PLAN_Q6', 'MOD_PLAN_AMT6', 'MOD_PLAN_Q7', 'MOD_PLAN_AMT7', 'MOD_PLAN_Q8', 'MOD_PLAN_AMT8', 'MOD_PLAN_Q9', 'MOD_PLAN_AMT9', 'MOD_PLAN_Q10', 'MOD_PLAN_AMT10', 'MOD_PLAN_Q11', 'MOD_PLAN_AMT11', 'MOD_PLAN_Q12', 'MOD_PLAN_AMT12'])) {
                                return true;
                            } else {
                                return false;
                            }
                        }
                    }
                }//,
//                select: function() {
//                    selectedGrid = 's_sgp100ukrv_kdmasterGrid';
//                    UniAppManager.setToolbarButtons(['newData', 'delete'], true);
//                },
//                cellclick: function() {
//                    selectedGrid = 's_sgp100ukrv_kdmasterGrid';
//                    UniAppManager.setToolbarButtons(['newData', 'delete'], true);
//                }//,
//                render: function(grid, eOpts) {
//                    var girdNm = grid.getItemId();
//                    grid.getEl().on('click', function(e, t, eOpt) {
//                        selectedMasterGrid = 's_sgp100ukrv_kdmasterGrid';
//                    });
//                },
//                selectionchange:function( model1, selected, eOpts ){
//                    if(selected.length > 0) {
//                        var record = selected[0];
//                        var param= panelSearch.getValues();
//                        param.COMP_CODE        = UserInfo.compCode;
//                        param.DIV_CODE         = UserInfo.divCode;
//                        param.PLAN_YEAR        = panelSearch.getValue('PLAN_YEAR');
//                        param.ORDER_TYPE       = panelSearch.getValue('ORDER_TYPE');
//                        param.MONEY_UNIT       = panelSearch.getValue('MONEY_UNIT');
//                        param.DEPT_CODE        = panelSearch.getValue('DEPT_CODE');
//                        param.AGENT_TYPE       = addResult.getValue('AGENT_TYPE');
//                        param.PLAN_TYPE2_CODE  = record.get('PLAN_TYPE2_CODE');
//                        param.PLAN_TYPE2_CODE2 = record.get('PLAN_TYPE2_CODE2');
//
//                        if(panelResult.getValue('ITEM_CHK') == true) {
//                            param.PLAN_TYPE2   = '2';
//                        }
//                        else {
//                            param.PLAN_TYPE2   = '6';
//                        }
//
//                        directMasterStore2.loadStoreRecords(param);
//                    }
//                }
            },
            setCustData: function(record, dataClear, grdRecord) {
                var grdRecord = this.uniOpt.currentRecord;
                if(dataClear) {
                    grdRecord.set('CUSTOM_CODE'          , '');
                    grdRecord.set('CUSTOM_NAME'          , '');
                    grdRecord.set('PLAN_TYPE2_CODE2'     , '');
                    grdRecord.set('AGENT_TYPE'           , '');
                    grdRecord.set('MONEY_UNIT'           , '');

                } else {

                	grdRecord.set('CUSTOM_CODE'          , record['CUSTOM_CODE']);
                    grdRecord.set('CUSTOM_NAME'          , record['CUSTOM_NAME']);
                    grdRecord.set('PLAN_TYPE2_CODE2'     , record['CUSTOM_CODE']);
                    grdRecord.set('AGENT_TYPE'           , record['AGENT_TYPE']);
                    grdRecord.set('MONEY_UNIT'           , record['MONEY_UNIT']);
                    UniSales.fnGetDivPriceInfo2(grdRecord, UniAppManager.app.cbGetPriceInfo
						,'I'
						,UserInfo.compCode
						,grdRecord.get('CUSTOM_CODE')
						,grdRecord.get('AGENT_TYPE')
						,grdRecord.get('ITEM_CODE')
						,grdRecord.get('MONEY_UNIT')
						,grdRecord.get('SALE_UNIT')
						,grdRecord.get('STOCK_UNIT')
						,grdRecord.get('TRANS_RATE')
						,UniDate.getDbDateStr(UniDate.get('today'))
						,0
						,grdRecord.get('WGT_UNIT')
						,grdRecord.get('VOL_UNIT')
						,grdRecord.get('UNIT_WGT')
						,grdRecord.get('UNIT_VOL')
						,grdRecord.get('PRICE_TYPE')
						,grdRecord.get('PRICE_YN')
					)
                }
            },
            setItemCodeData: function(record, dataClear, grdRecord) {
                var grdRecord = this.uniOpt.currentRecord;
                if(dataClear) {
                    grdRecord.set('ITEM_CODE'          , '');
                    grdRecord.set('ITEM_NAME'          , '');
                    grdRecord.set('PLAN_TYPE2_CODE'    , '');
                    grdRecord.set('SPEC'               , '');
                    grdRecord.set('OEM_ITEM_CODE'      , '');
                    grdRecord.set('TRANS_RATE'         , '');
                    grdRecord.set('SALE_UNIT'        , '');
                    grdRecord.set('STOCK_UNIT'       , '');
                    grdRecord.set('WGT_UNIT'         , '');
                    grdRecord.set('VOL_UNIT'         , '');
                    grdRecord.set('UNIT_WGT'         , '');
                    grdRecord.set('UNIT_VOL'         , '');
                    grdRecord.set('PRICE_TYPE'       , '');
                    grdRecord.set('PRICE_YN'         , '');


                } else {
                    grdRecord.set('ITEM_CODE'          , record['ITEM_CODE']);
                    grdRecord.set('ITEM_NAME'          , record['ITEM_NAME']);
                    grdRecord.set('PLAN_TYPE2_CODE'    , record['ITEM_CODE']);
                    grdRecord.set('SPEC'               , record['SPEC']);
                    grdRecord.set('OEM_ITEM_CODE'      , record['OEM_ITEM_CODE']);
                    grdRecord.set('TRANS_RATE'         , record['TRNS_RATE']);
                    grdRecord.set('SALE_UNIT'        , record['SALE_UNIT']);
                    grdRecord.set('STOCK_UNIT'       , record['STOCK_UNIT']);
                    grdRecord.set('WGT_UNIT'         , record['WGT_UNIT']);
                    grdRecord.set('VOL_UNIT'         , record['VOL_UNIT']);
                    grdRecord.set('UNIT_WGT'         , record['UNIT_WGT']);
                    grdRecord.set('UNIT_VOL'         , record['UNIT_VOL']);
                    grdRecord.set('PRICE_TYPE'       , record['PRICE_TYPE']);
                    grdRecord.set('PRICE_YN'         , record['PRICE_YN']);
                	UniSales.fnGetDivPriceInfo2(grdRecord, UniAppManager.app.cbGetPriceInfo
							,'I'
							,UserInfo.compCode
							,grdRecord.get('CUSTOM_CODE')
							,grdRecord.get('AGENT_TYPE')
							,grdRecord.get('ITEM_CODE')
							,grdRecord.get('MONEY_UNIT')
							,grdRecord.get('SALE_UNIT')
							,grdRecord.get('STOCK_UNIT')
							,grdRecord.get('TRANS_RATE')
							,UniDate.getDbDateStr(UniDate.get('today'))
							,0
							,grdRecord.get('WGT_UNIT')
							,grdRecord.get('VOL_UNIT')
							,grdRecord.get('UNIT_WGT')
							,grdRecord.get('UNIT_VOL')
							,grdRecord.get('PRICE_TYPE')
							,grdRecord.get('PRICE_YN')
							)
                }
            },
            setCustomItemData:function(record){
                var grdRecord = this.getSelectedRecord();
                grdRecord.set('DIV_CODE'             ,panelSearch.getValue('DIV_CODE'));
                grdRecord.set('PLAN_YEAR'            ,panelSearch.getValue('PLAN_YEAR'));
                grdRecord.set('DEPT_CODE'            ,panelSearch.getValue('DEPT_CODE'));
                grdRecord.set('PLAN_TYPE1'           ,panelSearch.getValue('ORDER_TYPE'));
                grdRecord.set('PLAN_TYPE2'           ,'6');
                grdRecord.set('PLAN_TYPE2_CODE'      ,record['ITEM_CODE']);
                grdRecord.set('PLAN_TYPE2_CODE2'     ,record['CUSTOM_CODE']);
                grdRecord.set('LEVEL_KIND'           ,'*');
                grdRecord.set('MONEY_UNIT'           ,panelSearch.getValue('MONEY_UNIT'));
                grdRecord.set('ENT_MONEY_UNIT'       ,panelSearch.getValue('MONEY_UNIT_DIV'));
                grdRecord.set('CONFIRM_YN'           ,record['CONFIRM_YN']);
                grdRecord.set('CUSTOM_CODE'          ,record['CUSTOM_CODE']);
                grdRecord.set('CUSTOM_NAME'          ,record['CUSTOM_NAME']);
                grdRecord.set('ITEM_CODE'            ,record['ITEM_CODE']);
                grdRecord.set('ITEM_NAME'            ,record['ITEM_NAME']);
                grdRecord.set('SPEC'                 ,record['SPEC']);
                grdRecord.set('PLAN_SUM'             ,record['PLAN_SUM']);
                grdRecord.set('MOD_PLAN_SUM'         ,record['MOD_PLAN_SUM']);
                grdRecord.set('A_D_RATE_SUM'         ,record['A_D_RATE_SUM']);
                grdRecord.set('PLAN1'                ,record['PLAN1']);
                grdRecord.set('MOD_PLAN1'            ,record['MOD_PLAN1']);
                grdRecord.set('A_D_RATE1'            ,record['A_D_RATE1']);
                grdRecord.set('PLAN2'                ,record['PLAN2']);
                grdRecord.set('MOD_PLAN2'            ,record['MOD_PLAN2']);
                grdRecord.set('A_D_RATE2'            ,record['A_D_RATE2']);
                grdRecord.set('PLAN3'                ,record['PLAN3']);
                grdRecord.set('MOD_PLAN3'            ,record['MOD_PLAN3']);
                grdRecord.set('A_D_RATE3'            ,record['A_D_RATE3']);
                grdRecord.set('PLAN4'                ,record['PLAN4']);
                grdRecord.set('MOD_PLAN4'            ,record['MOD_PLAN4']);
                grdRecord.set('A_D_RATE4'            ,record['A_D_RATE4']);
                grdRecord.set('PLAN5'                ,record['PLAN5']);
                grdRecord.set('MOD_PLAN5'            ,record['MOD_PLAN5']);
                grdRecord.set('A_D_RATE5'            ,record['A_D_RATE5']);
                grdRecord.set('PLAN6'                ,record['PLAN6']);
                grdRecord.set('MOD_PLAN6'            ,record['MOD_PLAN6']);
                grdRecord.set('A_D_RATE6'            ,record['A_D_RATE6']);
                grdRecord.set('PLAN7'                ,record['PLAN7']);
                grdRecord.set('MOD_PLAN7'            ,record['MOD_PLAN7']);
                grdRecord.set('A_D_RATE7'            ,record['A_D_RATE7']);
                grdRecord.set('PLAN8'                ,record['PLAN8']);
                grdRecord.set('MOD_PLAN8'            ,record['MOD_PLAN8']);
                grdRecord.set('A_D_RATE8'            ,record['A_D_RATE8']);
                grdRecord.set('PLAN9'                ,record['PLAN9']);
                grdRecord.set('MOD_PLAN9'            ,record['MOD_PLAN9']);
                grdRecord.set('A_D_RATE9'            ,record['A_D_RATE9']);
                grdRecord.set('PLAN10'               ,record['PLAN10']);
                grdRecord.set('MOD_PLAN10'           ,record['MOD_PLAN10']);
                grdRecord.set('A_D_RATE10'           ,record['A_D_RATE10']);
                grdRecord.set('PLAN11'               ,record['PLAN11']);
                grdRecord.set('MOD_PLAN11'           ,record['MOD_PLAN11']);
                grdRecord.set('A_D_RATE11'           ,record['A_D_RATE11']);
                grdRecord.set('PLAN12'               ,record['PLAN12']);
                grdRecord.set('MOD_PLAN12'           ,record['MOD_PLAN12']);
                grdRecord.set('A_D_RATE12'           ,record['A_D_RATE12']);
                grdRecord.set('UPDATE_DB_USER'       ,record['UPDATE_DB_USER']);
                grdRecord.set('UPDATE_DB_TIME'       ,record['UPDATE_DB_TIME']);
                grdRecord.set('COMP_CODE'            ,record['COMP_CODE']);
            }
    });

    //LOG 보기
    var masterGrid2 = Unilite.createGrid('s_sgp100ukrv_kdGrid2', {
        layout : 'fit',
        region:'south',
        title : '저장이력 조회',
        store : directMasterStore2,
        uniOpt:{    expandLastColumn: false,
                    useRowNumberer: true,
                    useMultipleSorting: true,
                    onLoadSelectFirst   : false //조회시 첫번째 레코드 select 사용여부
        },
        columns: [  { dataIndex: 'FLAG'                     ,           width:60}
        	       ,{ dataIndex: 'DIV_CODE'                 ,           width:86, hidden: true }
                   ,{ dataIndex: 'PLAN_YEAR'                ,           width:86, hidden: true }
                   ,{ dataIndex: 'PLAN_TYPE1'               ,           width:86, hidden: true }
                   ,{ dataIndex: 'PLAN_TYPE2'               ,           width:86, hidden: true }
                   ,{ dataIndex: 'PLAN_TYPE2_CODE'          ,           width:86, hidden: true }
                   ,{ dataIndex: 'PLAN_TYPE2_CODE2'         ,           width:86, hidden: true }
                   ,{ dataIndex: 'DEPT_CODE'                ,           width:86, hidden: true }
                   ,{ dataIndex: 'LEVEL_KIND'               ,           width:86, hidden: true }
                   ,{ dataIndex: 'MONEY_UNIT'               ,           width:86, hidden: true }
                   ,{ dataIndex: 'ENT_MONEY_UNIT'           ,           width:86, hidden: true }
                   ,{ dataIndex: 'CONFIRM_YN'               ,           width:86, hidden: true }
                   ,{ dataIndex: 'SALE_BASIS_P'             ,           width:86, hidden: true }
                   ,{ dataIndex: 'CUSTOM_CODE'              ,           width:86}
                   ,{ dataIndex: 'CUSTOM_NAME'              ,           width:86 }
                   ,{
                    text: '품목정보',
                    columns:[
                        { dataIndex:  'ITEM_CODE'           ,           width:100}
                       ,{ dataIndex: 'ITEM_NAME'            ,           width:100}
                       ,{ dataIndex: 'SPEC'                 ,           width:150}
                       ,{ dataIndex: 'OEM_ITEM_CODE'        ,           width:105, hidden:true }
                     ]
                  }
                   ,{
                    text: '합계',
                    columns:[
                        { dataIndex: 'PLAN_SUM_Q'                ,           width:86 }
                       ,{ dataIndex: 'PLAN_SUM_AMT'              ,           width:86 }
                       ,{ dataIndex: 'MOD_PLAN_SUM_Q'            ,           width:86, hidden:true }
                       ,{ dataIndex: 'MOD_PLAN_SUM_AMT'          ,           width:86, hidden:true }
                    ]
                  },{
                    text: '1월',
                    columns:[
                        { dataIndex: 'PLAN_QTY1'                 ,           width:86 }
                       ,{ dataIndex: 'PLAN_AMT1'                 ,           width:86 }
                       ,{ dataIndex: 'MOD_PLAN_Q1'               ,           width:86 }
                       ,{ dataIndex: 'MOD_PLAN_AMT1'             ,           width:86 }
                    ]
                  },{
                    text: '2월',
                    columns:[
                        { dataIndex: 'PLAN_QTY2'                 ,           width:86 }
                       ,{ dataIndex: 'PLAN_AMT2'                 ,           width:86 }
                       ,{ dataIndex: 'MOD_PLAN_Q2'               ,           width:86 }
                       ,{ dataIndex: 'MOD_PLAN_AMT2'             ,           width:86 }
                    ]
                  },{
                    text: '3월',
                    columns:[
                        { dataIndex: 'PLAN_QTY3'                 ,           width:86 }
                       ,{ dataIndex: 'PLAN_AMT3'                 ,           width:86 }
                       ,{ dataIndex: 'MOD_PLAN_Q3'               ,           width:86 }
                       ,{ dataIndex: 'MOD_PLAN_AMT3'             ,           width:86 }
                    ]
                  },{
                    text: '4월',
                    columns:[
                        { dataIndex: 'PLAN_QTY4'                 ,           width:86 }
                       ,{ dataIndex: 'PLAN_AMT4'                 ,           width:86 }
                       ,{ dataIndex: 'MOD_PLAN_Q4'               ,           width:86 }
                       ,{ dataIndex: 'MOD_PLAN_AMT4'             ,           width:86 }
                    ]
                  },{
                    text: '5월',
                    columns:[
                        { dataIndex: 'PLAN_QTY5'                 ,           width:86 }
                       ,{ dataIndex: 'PLAN_AMT5'                 ,           width:86 }
                       ,{ dataIndex: 'MOD_PLAN_Q5'               ,           width:86 }
                       ,{ dataIndex: 'MOD_PLAN_AMT5'             ,           width:86 }
                    ]
                  },{
                    text: '6월',
                    columns:[
                        { dataIndex: 'PLAN_QTY6'                 ,           width:86 }
                       ,{ dataIndex: 'PLAN_AMT6'                 ,           width:86 }
                       ,{ dataIndex: 'MOD_PLAN_Q6'               ,           width:86 }
                       ,{ dataIndex: 'MOD_PLAN_AMT6'             ,           width:86 }
                    ]
                  },{
                    text: '7월',
                    columns:[
                        { dataIndex: 'PLAN_QTY7'                 ,           width:86 }
                       ,{ dataIndex: 'PLAN_AMT7'                 ,           width:86 }
                       ,{ dataIndex: 'MOD_PLAN_Q7'               ,           width:86 }
                       ,{ dataIndex: 'MOD_PLAN_AMT7'             ,           width:86 }
                    ]
                  },{
                    text: '8월',
                    columns:[
                        { dataIndex: 'PLAN_QTY8'                 ,           width:86 }
                       ,{ dataIndex: 'PLAN_AMT8'                 ,           width:86 }
                       ,{ dataIndex: 'MOD_PLAN_Q8'               ,           width:86 }
                       ,{ dataIndex: 'MOD_PLAN_AMT8'             ,           width:86 }
                    ]
                  },{
                    text: '9월',
                    columns:[
                        { dataIndex: 'PLAN_QTY9'                 ,           width:86 }
                       ,{ dataIndex: 'PLAN_AMT9'                 ,           width:86 }
                       ,{ dataIndex: 'MOD_PLAN_Q9'               ,           width:86 }
                       ,{ dataIndex: 'MOD_PLAN_AMT9'             ,           width:86 }
                    ]
                  },{
                    text: '10월',
                    columns:[
                        { dataIndex: 'PLAN_QTY10'                ,           width:86 }
                       ,{ dataIndex: 'PLAN_AMT10'                ,           width:86 }
                       ,{ dataIndex: 'MOD_PLAN_Q10'              ,           width:86 }
                       ,{ dataIndex: 'MOD_PLAN_AMT10'            ,           width:86 }
                    ]
                  },{
                    text: '11월',
                    columns:[
                        { dataIndex: 'PLAN_QTY11'                ,           width:86 }
                       ,{ dataIndex: 'PLAN_AMT11'                ,           width:86 }
                       ,{ dataIndex: 'MOD_PLAN_Q11'              ,           width:86 }
                       ,{ dataIndex: 'MOD_PLAN_AMT11'            ,           width:86 }
                    ]
                  },{
                    text: '12월',
                    columns:[
                        { dataIndex: 'PLAN_QTY12'                ,           width:86 }
                       ,{ dataIndex: 'PLAN_AMT12'                ,           width:86 }
                       ,{ dataIndex: 'MOD_PLAN_Q12'              ,           width:86 }
                       ,{ dataIndex: 'MOD_PLAN_AMT12'            ,           width:86 }
                    ]
                  }
                   ,{ dataIndex: 'INSERT_DB_USER'              ,           width:90}
                   ,{ dataIndex: 'INSERT_DB_TIME'              ,           width:170}
                   ,{ dataIndex: 'UPDATE_DB_USER'            ,           width:90}
                   ,{ dataIndex: 'UPDATE_DB_TIME'            ,           width:170}
                   ,{ dataIndex: 'COMP_CODE'                 ,           width:86, hidden: true }

          ],
        listeners :{/*
            select: function() {
                selectedGrid = 's_sgp100ukrv_kdGrid2';
                UniAppManager.setToolbarButtons(['newData', 'delete'], false);
            },
            cellclick: function() {
                selectedGrid = 's_sgp100ukrv_kdGrid2';
                var count = masterGrid.getStore().getCount();
                var record = masterGrid.getSelectedRecord();
                UniAppManager.setToolbarButtons(['newData', 'delete'], false);
            },
            render: function(grid, eOpts) {
                var girdNm = grid.getItemId();
                grid.getEl().on('click', function(e, t, eOpt) {
                    selectedMasterGrid = 's_sgp100ukrv_kdGrid2';
                });
            }
        */}
    });

    function openSearchLogWindow() {           //조회버튼 누르면 나오는 조회창
        if(!SearchLogWindow) {
            SearchLogWindow = Ext.create('widget.uniDetailWindow', {
                title: '저장이력 조회',
                width: 1000,
                height: 500,
                layout: {type:'vbox', align:'stretch'}, //위치 확인 필요
                items: [masterGrid2],
                tbar:  ['->',
                    {
                        itemId : 'queryBtn',
                        text: '조회',
                        handler: function() {
                            directMasterStore2.loadStoreRecords();
                        },
                        disabled: false,
                        hidden: true
                    }, {
                        itemId : 'inoutNoCloseBtn',
                        text: '닫기',
                        handler: function() {
                            SearchLogWindow.hide();
                        },
                        disabled: false
                    }
                ],
                listeners : {
                    beforeshow: function (me, eOpts)
                    {
                    	var record = masterGrid.getSelectedRecord();
                    	var param = {
                    	   COMP_CODE        : UserInfo.compCode,
                           DIV_CODE         : UserInfo.divCode,
                           PLAN_YEAR        : panelSearch.getValue('PLAN_YEAR'),
                           ORDER_TYPE       : panelSearch.getValue('ORDER_TYPE'),
                           MONEY_UNIT       : panelSearch.getValue('MONEY_UNIT'),
                           DEPT_CODE        : panelSearch.getValue('DEPT_CODE'),
                           AGENT_TYPE       : addResult.getValue('AGENT_TYPE'),
                           PLAN_TYPE2_CODE  : record.get('PLAN_TYPE2_CODE'),
                           PLAN_TYPE2_CODE2 : record.get('PLAN_TYPE2_CODE2')
                        }
                        if(panelResult.getValue('ITEM_CHK') == true) {
                           param.PLAN_TYPE2 = '2'
                        } else {
                           param.PLAN_TYPE2 = '6'
                        }
                        directMasterStore2.loadStoreRecords(param);
                        UniAppManager.app.setHiddenColumn();
                     }
                }
            })
        }
        SearchLogWindow.center();
        SearchLogWindow.show();
    };

    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                masterGrid, panelResult,
                {
                    region : 'north',
                    xtype : 'container',
                    highth: 20,
                    layout : 'fit',
                    items : [ addResult ]
                }
            ]
        },
            panelSearch
        ],
        id  : 's_sgp100ukrv_kdApp',
        fnInitBinding : function() {
            UniAppManager.setToolbarButtons(['save', 'deleteAll'], false);
            panelSearch.setValue('DIV_CODE', UserInfo.divCode);
            UniAppManager.setToolbarButtons(['reset', 'newData'], true);
            Ext.getCmp('CREATE_DATA1').setDisabled(true);
            Ext.getCmp('CONFIRM_DATA1').setDisabled(true);
            Ext.getCmp('SEARCH_LOG').setDisabled(true);

            this.setDefault();
        },
        onQueryButtonDown : function()  {
            if(panelSearch.setAllFieldsReadOnly(true) == false){
            return false;
            }
            if(panelResult.setAllFieldsReadOnly(true) == false){
               return false;
            }

        /*     if(panelResult.getValue('ITEM_CHK') != true) {
         	   directMasterStore.setConfig('groupField', false);
         	} else {
         		directMasterStore.setConfig('groupField', 'CUSTOM_CODE');
         	} */


            if(panelResult.getValue('DEPT_CODE') == '3'){
           	 var colName = "";
          	 for(var i=0; i<masterGrid.getColumns().length; i++){
           		 colName = masterGrid.getColumns()[i].dataIndex;
           		 if(masterGrid.getColumns()[i].xtype == 'numbercolumn'){
           			masterGrid.getColumn(colName).setConfig('format','0,000');
           			masterGrid.getColumn(colName).setConfig('decimalPrecision',2);

           		}else if(masterGrid.getColumns()[i].xtype == 'uniNnumberColumn'){
           			masterGrid.getColumn(colName).setConfig('format','0,000.00');
           			masterGrid.getColumn(colName).setConfig('decimalPrecision',0);
           		}
           	}

           	masterGrid.getView().refresh(true);
           }else{
            	var colName = "";
              	 for(var i=0; i<masterGrid.getColumns().length; i++){
              		 colName = masterGrid.getColumns()[i].dataIndex;
              		 if(masterGrid.getColumns()[i].xtype == 'numbercolumn'){
              			masterGrid.getColumn(colName).setConfig('format','0,000');
              		}else if(masterGrid.getColumns()[i].xtype == 'uniNnumberColumn'){
              			masterGrid.getColumn(colName).setConfig('format','0,000');
              		}
              	}
           	/* 	var length = Ext.isEmpty(UniFormat.Price.split('.')[1]) ? 0 : UniFormat.Price.split('.')[1].length;
           	masterGrid.getColumn("PLAN_SUM_AMT").setConfig('format',UniFormat.Price);
           	masterGrid.getColumn("PLAN_SUM_AMT").setConfig('decimalPrecision',length); */
           	masterGrid.getView().refresh(true);
           }
            directMasterStore.loadStoreRecords();
            UniAppManager.app.setHiddenColumn();

            UniAppManager.setToolbarButtons('newData', true);

        },
        onResetButtonDown: function() {
            panelSearch.setAllFieldsReadOnly(false);
            panelResult.setAllFieldsReadOnly(false);
            masterGrid.reset();
//            this.fnInitBinding();

            UniAppManager.setToolbarButtons(['save', 'newData', 'deleteAll'], false);
            panelSearch.setValue('DIV_CODE', UserInfo.divCode);
            UniAppManager.setToolbarButtons('reset', true);
            Ext.getCmp('CREATE_DATA1').setDisabled(true);
            Ext.getCmp('CONFIRM_DATA1').setDisabled(true);
            Ext.getCmp('SEARCH_LOG').setDisabled(true);

            panelSearch.setValue('DIV_CODE', UserInfo.divCode);
            panelSearch.setValue('PLAN_YEAR', new Date().getFullYear());
            panelSearch.setValue('MONEY_UNIT', UserInfo.currency);
            panelSearch.setValue('MONEY_UNIT_DIV', '1');

            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('PLAN_YEAR', new Date().getFullYear());
            panelResult.setValue('MONEY_UNIT', UserInfo.currency);
            panelResult.setValue('MONEY_UNIT_DIV', '1');

            addResult.setValue('AGENT_TYPE', '1');
            panelSearch.setValue('ORDER_TYPE', '');
            panelResult.setValue('ORDER_TYPE', '');
            panelSearch.setValue('DEPT_CODE', '');
            panelResult.setValue('DEPT_CODE', '');

            masterGrid.getColumn('ITEM_CODE').setVisible(true);
            masterGrid.getColumn('ITEM_NAME').setVisible(true);
            masterGrid.getColumn('SPEC').setVisible(true);
   //         masterGrid.getColumn('OEM_ITEM_CODE').setVisible(true);
            Ext.getCmp('CONFIRM_DATA1').setText('년초계획확정');

            panelResult.setValue('ITEM_CHK',false);
            panelSearch.setValue('ITEM_CHK',false);
            UniAppManager.setToolbarButtons(['reset', 'newData'], true);
        },
        onNewDataButtonDown: function() {
        	if(panelSearch.setAllFieldsReadOnly(true) == false){
                return false;
            }
            if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
            if(addResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
            if(Ext.isEmpty(panelSearch.getValue('DEPT_CODE')))    {
            	alert('부서 구분을 선택해주세요.')
            	panelResult.getField('DEPT_CODE').focus();
            	return false;
            }
            var divCode = '';
            if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE')))  {
                divCode = panelSearch.getValue('DIV_CODE');
            }

            var planYear = '';
            if(!Ext.isEmpty(panelSearch.getValue('PLAN_YEAR'))) {
                planYear = panelSearch.getValue('PLAN_YEAR');
            }

            var orderType = '';
            if(!Ext.isEmpty(panelSearch.getValue('ORDER_TYPE')))    {
                orderType = panelSearch.getValue('ORDER_TYPE');
            }

            var moneyUnit = '';
            if(!Ext.isEmpty(panelSearch.getValue('MONEY_UNIT')))    {
                moneyUnit = panelSearch.getValue('MONEY_UNIT');
            }

            var moneyUnitDiv = '';
            if(!Ext.isEmpty(panelSearch.getValue('MONEY_UNIT_DIV')))    {
                moneyUnitDiv = panelSearch.getValue('MONEY_UNIT_DIV');
            }

            var levelKind = '';
            if(!Ext.isEmpty(addResult.getValue('AGENT_TYPE')))    {
                levelKind = addResult.getValue('AGENT_TYPE');
            }

            var deptCode = '';
            if(!Ext.isEmpty(panelSearch.getValue('DEPT_CODE')))    {
                deptCode = panelSearch.getValue('DEPT_CODE');
            }

            var planType2 = '';
            if(panelResult.getValue('ITEM_CHK') == true) {
                planType2 = '2';
            }
            else {
            	planType2 = '6';
            }

            var confirmYN = '';
            if(Ext.getCmp('CONFIRM_DATA1').getText() == '년초계획변경') {
                confirmYN = 'Y';
            }
            else {
                confirmYN = 'N';
            }

            var r = {
                DIV_CODE: divCode,
                PLAN_YEAR: planYear,
                PLAN_TYPE1: orderType,
                MONEY_UNIT: moneyUnit,
                ENT_MONEY_UNIT: moneyUnitDiv,
                LEVEL_KIND : levelKind,
                DEPT_CODE : deptCode,
                PLAN_TYPE2 : planType2,
                CONFIRM_YN : confirmYN
            };
            masterGrid.createRow(r, null);
        },
        onSaveDataButtonDown: function () {
            directMasterStore.saveStore();
//            directMasterStore.loadStoreRecords();
        },
        onDeleteDataButtonDown: function() {
        	var record = masterGrid.getSelectedRecord();

        	if(record.phantom === true) {
                masterGrid.deleteSelectedRow();
            } else {
                if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                    if(record.get('CONFIRM_YN') == 'Y') {
                       alert("확정된 데이터는 삭제할수 없습니다.");
                       return false;
                    } else {
                        masterGrid.deleteSelectedRow();
                    }
                }
            }
        },
        onDeleteAllButtonDown: function() {
            var records1 = directMasterStore.data.items;
            var isNewData = false;
            Ext.each(records1, function(record,i) {
                if(record.phantom) {                     //신규 레코드일시 isNewData에 true를 반환
                    isNewData = true;
                }else{                                  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
                    if(confirm('전체삭제 하시겠습니까?')) {
                        var deletable = true;
                        if(deletable){
                            masterGrid.reset();
                            UniAppManager.app.onSaveDataButtonDown();
                        }
                        isNewData = false;
                    }
                    return false;
                }
            });
            if(isNewData){                              //신규 레코드들만 있을시 그리드 리셋
                masterGrid.reset();
                UniAppManager.app.onResetButtonDown();  //삭제후 RESET..
            }
        },
        setDefault: function() {
            panelSearch.setValue('DIV_CODE', UserInfo.divCode);
            panelSearch.setValue('PLAN_YEAR', new Date().getFullYear());
            panelSearch.setValue('MONEY_UNIT', UserInfo.currency);
            panelSearch.setValue('MONEY_UNIT_DIV', '1');

            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('PLAN_YEAR', new Date().getFullYear());
            panelResult.setValue('MONEY_UNIT', UserInfo.currency);
            panelResult.setValue('MONEY_UNIT_DIV', '1');

            addResult.setValue('AGENT_TYPE', '1');
            panelSearch.setValue('ORDER_TYPE', '');
            panelResult.setValue('ORDER_TYPE', '');
            panelSearch.setValue('DEPT_CODE', '');
            panelResult.setValue('DEPT_CODE', '');

//            UniAppManager.app.setHiddenColumn();

            Ext.getCmp('CONFIRM_DATA1').setText('년초계획확정');
        },
        setHiddenColumn: function() {
        	if(panelResult.getValue('ITEM_CHK') == true) {
                masterGrid.getColumn('ITEM_CODE').setVisible(false);
                masterGrid.getColumn('ITEM_NAME').setVisible(false);
                masterGrid.getColumn('SPEC').setVisible(false);
//                masterGrid.getColumn('OEM_ITEM_CODE').setVisible(false);
//                masterGrid2.getColumn('ITEM_CODE').setVisible(false);
//                masterGrid2.getColumn('ITEM_NAME').setVisible(false);
//                masterGrid2.getColumn('SPEC').setVisible(false);
//                masterGrid2.getColumn('OEM_ITEM_CODE').setVisible(false);
        	}
        	else {
                masterGrid.getColumn('ITEM_CODE').setVisible(true);
                masterGrid.getColumn('ITEM_NAME').setVisible(true);
                masterGrid.getColumn('SPEC').setVisible(true);
//                masterGrid.getColumn('OEM_ITEM_CODE').setVisible(true);
//                masterGrid2.getColumn('ITEM_CODE').setVisible(true);
//                masterGrid2.getColumn('ITEM_NAME').setVisible(true);
//                masterGrid2.getColumn('SPEC').setVisible(true);
//                masterGrid2.getColumn('OEM_ITEM_CODE').setVisible(true);
        	}
        },
		// UniSales.fnGetDivPriceInfo2 callback 함수
		cbGetPriceInfo: function(provider, params) {
			var dSalePrice	= Unilite.nvl(provider['SALE_PRICE'],0);//판매단가(판매단위)
			var dWgtPrice	= Unilite.nvl(provider['WGT_PRICE'],0);//판매단가(중량단위)
			var dVolPrice	= Unilite.nvl(provider['VOL_PRICE'],0);//판매단가(부피단위)

			var dUnitWgt = 0;
			var dUnitVol = 0;

			if(params.sType=='I') {
				dUnitWgt = params.unitWgt;
				dUnitVol = params.unitVol;
				if(params.priceType == 'A') {
					dWgtPrice = (dUnitWgt = 0) ?	0 : dSalePrice / dUnitWgt;
					dVolPrice = (dUnitVol = 0) ?	0 : dSalePrice / dUnitVol;
				} else if(params.priceType == 'B'){
					dSalePrice = dWgtPrice  * dUnitWgt;
					dVolPrice = (dUnitVol = 0) ? 0 : dSalePrice / dUnitVol;
				} else if(params.priceType == 'C'){
					dSalePrice = dVolPrice  * dUnitVol;
					dWgtPrice = (dUnitWgt = 0) ? 0 : dSalePrice / dUnitWgt;
				} else {
					dWgtPrice = (dUnitWgt = 0) ? 0 : dSalePrice / dUnitWgt;
					dVolPrice = (dUnitVol = 0) ? 0 : dSalePrice / dUnitVol;
				}
				if(Ext.isEmpty(provider['SALE_PRICE'])){
					params.rtnRecord.set('SALE_BASIS_P'	, 0);
				} else {
					params.rtnRecord.set('SALE_BASIS_P'	, provider['SALE_PRICE']);
				}
				/* params.rtnRecord.set('INOUT_WGT_P', dWgtPrice );
				params.rtnRecord.set('INOUT_VOL_P', dVolPrice );
 */
				if(Ext.isEmpty(provider['SALE_TRANS_RATE'])){
					params.rtnRecord.set('TRANS_RATE', 1);
				} else {
					params.rtnRecord.set('TRANS_RATE', provider['SALE_TRANS_RATE']);
				}

				/* if(Ext.isEmpty(provider['DC_RATE'])){
					params.rtnRecord.set('DISCOUNT_RATE', 0);
				} else {
					params.rtnRecord.set('DISCOUNT_RATE', provider['DC_RATE']);
				}
				var exchangRate = panelResult.getValue('EXCHG_RATE_O');
				params.rtnRecord.set('INOUT_FOR_WGT_P', dWgtPrice / exchangRate);
				params.rtnRecord.set('INOUT_FOR_VOL_P', dVolPrice / exchangRate); */

				params.rtnRecord.set('PRICE_YN',provider['PRICE_TYPE']);
				UniAppManager.app.fnOrderAmtCal(params.rtnRecord);
			}
		},
		fnOrderAmtCal: function(rtnRecord) {

			var saleBasisP	= Unilite.nvl(rtnRecord.get('SALE_BASIS_P'),0);
			rtnRecord.set('PLAN_AMT1', rtnRecord.get('PLAN_QTY1')   * saleBasisP);
			rtnRecord.set('PLAN_AMT2', rtnRecord.get('PLAN_QTY2')   * saleBasisP);
			rtnRecord.set('PLAN_AMT3', rtnRecord.get('PLAN_QTY3')   * saleBasisP);
			rtnRecord.set('PLAN_AMT4', rtnRecord.get('PLAN_QTY4')   * saleBasisP);
			rtnRecord.set('PLAN_AMT5', rtnRecord.get('PLAN_QTY5')   * saleBasisP);
			rtnRecord.set('PLAN_AMT6', rtnRecord.get('PLAN_QTY6')   * saleBasisP);
			rtnRecord.set('PLAN_AMT7', rtnRecord.get('PLAN_QTY7')   * saleBasisP);
			rtnRecord.set('PLAN_AMT8', rtnRecord.get('PLAN_QTY8')   * saleBasisP);
			rtnRecord.set('PLAN_AMT9', rtnRecord.get('PLAN_QTY9')   * saleBasisP);
			rtnRecord.set('PLAN_AMT10',rtnRecord.get('PLAN_QTY10')  * saleBasisP);
			rtnRecord.set('PLAN_AMT11',rtnRecord.get('PLAN_QTY11')  * saleBasisP);
			rtnRecord.set('PLAN_AMT12',rtnRecord.get('PLAN_QTY12')  * saleBasisP);
			rtnRecord.set('PLAN_SUM_Q',   rtnRecord.get('PLAN_QTY1') + rtnRecord.get('PLAN_QTY2') + rtnRecord.get('PLAN_QTY3') + rtnRecord.get('PLAN_QTY4') + rtnRecord.get('PLAN_QTY5') + rtnRecord.get('PLAN_QTY6') + rtnRecord.get('PLAN_QTY7')
                    + rtnRecord.get('PLAN_QTY8') + rtnRecord.get('PLAN_QTY9') + rtnRecord.get('PLAN_QTY10') + rtnRecord.get('PLAN_QTY11') + rtnRecord.get('PLAN_QTY12'));
			rtnRecord.set('PLAN_SUM_AMT', rtnRecord.get('PLAN_AMT1') + rtnRecord.get('PLAN_AMT2') + rtnRecord.get('PLAN_AMT3') + rtnRecord.get('PLAN_AMT4') + rtnRecord.get('PLAN_AMT5') + rtnRecord.get('PLAN_AMT6') + rtnRecord.get('PLAN_AMT7')
                    + rtnRecord.get('PLAN_AMT8') + rtnRecord.get('PLAN_AMT9') + rtnRecord.get('PLAN_AMT10') + rtnRecord.get('PLAN_AMT11') + rtnRecord.get('PLAN_AMT12'));

		},
		fnPlanSumAmt: function(rtnRecord){
			rtnRecord.set('PLAN_SUM_AMT', rtnRecord.get('PLAN_AMT1') + rtnRecord.get('PLAN_AMT2') + rtnRecord.get('PLAN_AMT3') + rtnRecord.get('PLAN_AMT4') + rtnRecord.get('PLAN_AMT5') + rtnRecord.get('PLAN_AMT6') + rtnRecord.get('PLAN_AMT7')
                     + rtnRecord.get('PLAN_AMT8') + rtnRecord.get('PLAN_AMT9') + rtnRecord.get('PLAN_AMT10') + rtnRecord.get('PLAN_AMT11') + rtnRecord.get('PLAN_AMT12'));
		}
    });

    Unilite.createValidator('validator01', {
        store: directMasterStore,
        grid: masterGrid,
        validate: function( type, fieldName, newValue, oldValue, record, eopt) {
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;
            switch(fieldName) {
                case "PLAN_QTY1" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('PLAN_AMT1', newValue * record.get('SALE_BASIS_P'));
                    record.set('PLAN_SUM_Q', newValue + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12'));
                    UniAppManager.app.fnPlanSumAmt(record);
                    break;
                case "PLAN_QTY2" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('PLAN_AMT2', newValue * record.get('SALE_BASIS_P'));
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + newValue + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12'));
                    UniAppManager.app.fnPlanSumAmt(record);
                    break;
                case "PLAN_QTY3" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('PLAN_AMT3', newValue * record.get('SALE_BASIS_P'));
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + newValue + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12'));
                    UniAppManager.app.fnPlanSumAmt(record);
                    break;
                case "PLAN_QTY4" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('PLAN_AMT4', newValue * record.get('SALE_BASIS_P'));
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + newValue + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12'));
                    UniAppManager.app.fnPlanSumAmt(record);
                    break;
                case "PLAN_QTY5" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('PLAN_AMT5', newValue * record.get('SALE_BASIS_P'));
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + newValue + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12'));
                    UniAppManager.app.fnPlanSumAmt(record);
                    break;
                case "PLAN_QTY6" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('PLAN_AMT6', newValue * record.get('SALE_BASIS_P'));
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + newValue + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12'));
                    UniAppManager.app.fnPlanSumAmt(record);
                    break;
                case "PLAN_QTY7" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('PLAN_AMT7', newValue * record.get('SALE_BASIS_P'));
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + newValue
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12'));
                    UniAppManager.app.fnPlanSumAmt(record);
                    break;
                case "PLAN_QTY8" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('PLAN_AMT8', newValue * record.get('SALE_BASIS_P'));
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + newValue + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12'));
                    UniAppManager.app.fnPlanSumAmt(record);
                    break;
                case "PLAN_QTY9" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('PLAN_AMT9', newValue * record.get('SALE_BASIS_P'));
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + newValue + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12'));
                    UniAppManager.app.fnPlanSumAmt(record);
                    break;
                case "PLAN_QTY10" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('PLAN_AMT10', newValue * record.get('SALE_BASIS_P'));
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + newValue + record.get('PLAN_QTY11') + record.get('PLAN_QTY12'));
                    UniAppManager.app.fnPlanSumAmt(record);
                    break;
                case "PLAN_QTY11" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('PLAN_AMT11', newValue * record.get('SALE_BASIS_P'));
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + newValue + record.get('PLAN_QTY12'));
                    UniAppManager.app.fnPlanSumAmt(record);
                    break;
                case "PLAN_QTY12" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('PLAN_AMT12', newValue * record.get('SALE_BASIS_P'));
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + newValue);
                    UniAppManager.app.fnPlanSumAmt(record);
                    break;

                case "PLAN_AMT1" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('PLAN_SUM_AMT', newValue + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12'));
                    break;
                case "PLAN_AMT2" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + newValue + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12'));
                    break;
                case "PLAN_AMT3" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + newValue + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12'));
                    break;
                case "PLAN_AMT4" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + newValue + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12'));
                    break;
                case "PLAN_AMT5" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + newValue + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12'));
                    break;
                case "PLAN_AMT6" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + newValue + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12'));
                    break;
                case "PLAN_AMT7" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + newValue
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12'));
                    break;
                case "PLAN_AMT8" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + newValue + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12'));
                    break;
                case "PLAN_AMT9" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + newValue + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12'));
                    break;
                case "PLAN_AMT10" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + newValue + record.get('PLAN_AMT11') + record.get('PLAN_AMT12'));
                    break;
                case "PLAN_AMT11" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + newValue + record.get('PLAN_AMT12'));
                    break;
                case "PLAN_AMT12" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + newValue);
                    break;

                case "MOD_PLAN_Q1" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('MOD_PLAN_AMT1', newValue * record.get('SALE_BASIS_P'))
                    record.set('MOD_PLAN_SUM_Q', newValue + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12'));
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                            + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12'));
                    break;
                case "MOD_PLAN_Q2" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('MOD_PLAN_AMT2', newValue * record.get('SALE_BASIS_P'))
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + newValue + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12'));
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                            + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12'));
                    break;
                case "MOD_PLAN_Q3" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('MOD_PLAN_AMT3', newValue * record.get('SALE_BASIS_P'))
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + newValue + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12'));
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                            + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12'));
                    break;
                case "MOD_PLAN_Q4" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('MOD_PLAN_AMT4', newValue * record.get('SALE_BASIS_P'))
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + newValue + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12'));
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                            + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12'));
                    break;
                case "MOD_PLAN_Q5" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('MOD_PLAN_AMT5', newValue * record.get('SALE_BASIS_P'))
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + newValue + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12'));
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                            + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12'));
                    break;
                case "MOD_PLAN_Q6" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('MOD_PLAN_AMT6', newValue * record.get('SALE_BASIS_P'))
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + newValue + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12'));
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                            + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12'));
                    break;
                case "MOD_PLAN_Q7" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('MOD_PLAN_AMT7', newValue * record.get('SALE_BASIS_P'))
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + newValue
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12'));
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                            + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12'));
                    break;
                case "MOD_PLAN_Q8" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('MOD_PLAN_AMT8', newValue * record.get('SALE_BASIS_P'))
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + newValue + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12'));
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                            + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12'));
                    break;
                case "MOD_PLAN_Q9" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('MOD_PLAN_AMT9', newValue * record.get('SALE_BASIS_P'))
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + newValue + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12'));
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                            + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12'));
                    break;
                case "MOD_PLAN_Q10" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('MOD_PLAN_AMT10', newValue * record.get('SALE_BASIS_P'))
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + newValue + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12'));
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                            + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12'));
                    break;
                case "MOD_PLAN_Q11" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('MOD_PLAN_AMT11', newValue * record.get('SALE_BASIS_P'))
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + newValue + record.get('MOD_PLAN_Q12'));
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                            + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12'));
                    break;
                case "MOD_PLAN_Q12" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('MOD_PLAN_AMT12', newValue * record.get('SALE_BASIS_P'))
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + newValue);
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                            + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12'));
                    break;

                case "MOD_PLAN_AMT1" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('MOD_PLAN_SUM_AMT', newValue + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12'));
                    break;
                case "MOD_PLAN_AMT2" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + newValue + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12'));
                    break;
                case "MOD_PLAN_AMT3" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + newValue + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12'));
                    break;
                case "MOD_PLAN_AMT4" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + newValue + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12'));
                    break;
                case "MOD_PLAN_AMT5" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + newValue + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12'));
                    break;
                case "MOD_PLAN_AMT6" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + newValue + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12'));
                    break;
                case "MOD_PLAN_AMT7" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + newValue
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12'));
                    break;
                case "MOD_PLAN_AMT8" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + newValue + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12'));
                    break;
                case "MOD_PLAN_AMT9" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + newValue + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12'));
                    break;
                case "MOD_PLAN_AMT10" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + newValue + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12'));
                    break;
                case "MOD_PLAN_AMT11" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + newValue + record.get('MOD_PLAN_AMT12'));
                    break;
                case "MOD_PLAN_AMT12" :
                    if(newValue < '0') {
                        alert("양수를 입력해주세요.");
                        break;
                    }
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + newValue);
                    break;
            }
            return rv;
        }
    })

};


</script>