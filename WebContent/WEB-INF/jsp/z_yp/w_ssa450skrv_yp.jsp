<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="w_ssa450skrv_yp"  >
    <t:ExtComboStore comboType="BOR120" pgmId="w_ssa450skrv_yp"  />          <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당 -->
    <t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 -->    
    <t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->
    <t:ExtComboStore comboType="AU" comboCode="S007" /> <!--출고유형-->
    <t:ExtComboStore comboType="AU" comboCode="S024" /> <!--국내:부가세유형-->
    <t:ExtComboStore comboType="AU" comboCode="S118" /> <!--해외:부가세유형-->
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--판매유형-->
    <t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목유형-->
    <t:ExtComboStore comboType="AU" comboCode="S003" /> <!--단가구분-->
    <t:ExtComboStore comboType="AU" comboCode="B031"  opts= '1;5'/> <!--생성경로-->
    <t:ExtComboStore comboType="AU" comboCode="B059" /> <!--과세여부-->
    <t:ExtComboStore comboType="AU" comboCode="S024" /> <!--부가세유형-->
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>

<script type="text/javascript" >

function appMain() {
    /**
     *   Model 정의 
     * @type 
     */                 
    Unilite.defineModel('Ssa450skrvModel1', {
        fields: [{name: 'SALE_CUSTOM_CODE'      ,text: '거래처코드'         ,type: 'string'},
                 {name: 'SALE_CUSTOM_NAME'      ,text: '거래처명'           ,type: 'string'},
                 {name: 'BILL_TYPE'             ,text: '부가세유형'         ,type: 'string',comboType: "AU", comboCode: "S024"},
                 {name: 'SALE_DATE'             ,text: '매출일'             ,type: 'uniDate'},
                 {name: 'INOUT_TYPE_DETAIL'     ,text: '출고유형'           ,type: 'string',comboType: "AU", comboCode: "S007"},                    
                 {name: 'ITEM_CODE'             ,text: '품목코드'           ,type: 'string'},
                 {name: 'ITEM_NAME'             ,text: '품명'               ,type: 'string'},
                 {name: 'CREATE_LOC'            ,text: '생성경로'           ,type: 'string',comboType: "AU", comboCode: "B031"},
                 {name: 'SPEC'                  ,text: '규격'               ,type: 'string'},
                 {name: 'SALE_UNIT'             ,text: '단위'               ,type: 'string'},
                 {name: 'PRICE_TYPE'            ,text: '단가구분'           ,type: 'string'},
                 {name: 'TRANS_RATE'            ,text: '입수'               ,type: 'string'},
                 {name: 'SALE_Q'                ,text: '매출량'             ,type: 'uniQty'},
                 {name: 'SALE_WGT_Q'            ,text: '매출량(중량)'       ,type: 'number'},
                 {name: 'SALE_VOL_Q'            ,text: '매출량(부피)'       ,type: 'string'},                   
                 {name: 'CUSTOM_CODE'           ,text: '수주거래처'         ,type: 'string'},
                 {name: 'CUSTOM_NAME'           ,text: '수주거래처명'       ,type: 'string'},                           
                 {name: 'SALE_P'                ,text: '단가'               ,type: 'uniUnitPrice'},
                 {name: 'SALE_FOR_WGT_P'        ,text: '단가(중량)'         ,type: 'number'},                   
                 {name: 'SALE_FOR_VOL_P'        ,text: '단가(부피)'         ,type: 'string'},               
                 {name: 'MONEY_UNIT'            ,text: '화폐'               ,type: 'string'},
                 {name: 'EXCHG_RATE_O'          ,text: '환율'               ,type: 'uniER'},
                 {name: 'SALE_LOC_AMT_F'        ,text: '매출액(외화)'       ,type: 'uniFC'},
                 {name: 'SALE_LOC_AMT_I'        ,text: '매출액'             ,type: 'uniPrice'},
                 {name: 'TAX_TYPE'              ,text: '과세여부'           ,type: 'string', comboType: "AU", comboCode: "B059"},
                 {name: 'TAX_AMT_O'             ,text: '세액'               ,type: 'uniPrice'},
                 {name: 'SUM_SALE_AMT'          ,text: '매출계'             ,type: 'uniPrice'},
//               {name: 'CONSIGNMENT_FEE'       ,text: '수수료(위탁)'    ,type: 'uniPrice'},
                 {name: 'ORDER_TYPE'            ,text: '판매유형'           ,type: 'string',comboType: "AU", comboCode: "S002"},
                 {name: 'DIV_CODE'              ,text: '사업장'             ,type: 'string',comboType: "BOR120"},
                 {name: 'SALE_PRSN'             ,text: '영업담당'           ,type: 'string',comboType: "AU", comboCode: "S010"},
                 {name: 'MANAGE_CUSTOM'         ,text: '집계거래처'         ,type: 'string'},
                 {name: 'MANAGE_CUSTOM_NM'      ,text: '집계거래처명'       ,type: 'string'},
                 {name: 'AREA_TYPE'             ,text: '지역'               ,type: 'string',comboType: "AU", comboCode: "B056"},
                 {name: 'AGENT_TYPE'            ,text: '거래처분류'         ,type: 'string',comboType: "AU", comboCode: "B055"},                    
                 {name: 'PROJECT_NO'            ,text: '프로젝트번호'       ,type: 'string'},
                 {name: 'PUB_NUM'               ,text: '계산서번호'         ,type: 'string'},
                 {name: 'EX_NUM'                ,text: '전표번호'           ,type: 'string'},
                 {name: 'BILL_NUM'              ,text: '매출번호'           ,type: 'string'},
                 {name: 'ORDER_NUM'             ,text: '수주번호'           ,type: 'string'},
                 {name: 'DISCOUNT_RATE'         ,text: '할인율(%)'          ,type: 'number'},                   
                 {name: 'PRICE_YN'              ,text: '단가구분'           ,type: 'string', comboType: "AU", comboCode: "S003"},
                 {name: 'WGT_UNIT'              ,text: '중량단위'           ,type: 'string'},
                 {name: 'UNIT_WGT'              ,text: '단위중량'           ,type: 'string'},
                 {name: 'VOL_UNIT'              ,text: '부피단위'           ,type: 'string'},
                 {name: 'UNIT_VOL'              ,text: '단위부피'           ,type: 'string'},
                 {name: 'COMP_CODE'             ,text: '법인코드'           ,type: 'string'},
                 {name: 'BILL_SEQ'              ,text: '계산서 순번'        ,type: 'string'},
                 
                 {name: 'SALE_AMT_WON'          ,text: '매출액(자사)'       ,type: 'uniPrice'},
                 {name: 'TAX_AMT_WON'           ,text: '세액(자사)'         ,type: 'uniPrice'},
                 {name: 'SUM_SALE_AMT_WON'      ,text: '매출계(자사)'       ,type: 'uniPrice'}
            ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore1 = Unilite.createStore('w_ssa450skrv_ypMasterStore1',{
        model: 'Ssa450skrvModel1',
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            useNavi: false          // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {          
                   read: 'w_ssa450skrv_ypService.selectList1'                    
            }
        }
        ,loadStoreRecords: function()   {           
            var param= Ext.getCmp('searchForm').getValues();
//          var authoInfo = pgmInfo.authoUser;              //권한정보(N-전체,A-자기사업장>5-자기부서)
//          var deptCode = UserInfo.deptCode;   //부서코드
//          if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
//              param.DEPT_CODE = deptCode;
//          }
            console.log( param );
            this.load({
                params: param
            });         
        },
        groupField: 'SALE_CUSTOM_NAME'
    });
    
    /**
     * 검색조건 (Search Panel)
     * @type 
     */
    var panelSearch = Unilite.createSearchPanel('searchForm', {          
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
            layout: {type: 'vbox', align: 'stretch'},
            items: [{   
                xtype: 'container',
                layout: {type: 'uniTable', columns:1},
                items: [{
                    fieldLabel: '사업장',
                    name: 'DIV_CODE',
                    xtype: 'uniCombobox',
                    comboType: 'BOR120',
                    value: UserInfo.divCode,
                    allowBlank: false,
                    listeners: {
                        change: function(combo, newValue, oldValue, eOpts) {    
                            combo.changeDivCode(combo, newValue, oldValue, eOpts);
                            var field = panelResult.getField('SALE_PRSN');  
                            field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
                            panelResult.setValue('DIV_CODE', newValue);
                        }
                    }
                },
                    Unilite.popup('AGENT_CUST',{
                    fieldLabel: '거래처',
                    
                    valueFieldName: 'SALE_CUSTOM_CODE',
                    textFieldName: 'SALE_CUSTOM_NAME',
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                panelResult.setValue('SALE_CUSTOM_CODE', panelSearch.getValue('SALE_CUSTOM_CODE'));
                                panelResult.setValue('SALE_CUSTOM_NAME', panelSearch.getValue('SALE_CUSTOM_NAME'));                                                                                                         
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            panelResult.setValue('SALE_CUSTOM_CODE', '');
                            panelResult.setValue('SALE_CUSTOM_NAME', '');
                        }
                    }
                }),{
                    fieldLabel: '영업담당'  ,
                    name: 'SALE_PRSN',
                    xtype: 'uniCombobox',
                    comboType: 'AU',
                    comboCode: 'S010',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('SALE_PRSN', newValue);
                        }
                    },
                    onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
                        if(eOpts){
                            combo.filterByRefCode('refCode1', newValue, eOpts.parent);
                        }else{
                            combo.divFilterByRefCode('refCode1', newValue, divCode);
                        }
                    }
                },
                    Unilite.popup('DIV_PUMOK', {
                    fieldLabel: '품목코드',
                    validateBlank: false,
                    listeners: {
                        onValueFieldChange: function(field, newValue){
                            panelResult.setValue('ITEM_CODE', newValue);                             
                        },
                        onTextFieldChange: function(field, newValue){
                            panelResult.setValue('ITEM_NAME', newValue);             
                        },
//                        onSelected: {
//                            fn: function(records, type) {
//                                panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
//                                panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));                                                                                                           
//                            },
//                            scope: this
//                        },
//                        onClear: function(type) {
//                            panelResult.setValue('ITEM_CODE', '');
//                            panelResult.setValue('ITEM_NAME', '');
//                        },
                        applyextparam: function(popup){                         
                        popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                    }
                    }
                }),{
                    xtype: 'uniTextfield',
                    name: 'PROJECT_NO',
                    fieldLabel: '관리번호',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('PROJECT_NO', newValue);
                        }
                    }
                }, {
                    fieldLabel: '매출일',
                    width: 315,
                    xtype: 'uniDateRangefield',
                    startFieldName: 'SALE_FR_DATE',
                    endFieldName: 'SALE_TO_DATE',
                    //startDate: UniDate.get('startOfMonth'),
                    startDate: UniDate.get('today'),
                    endDate: UniDate.get('today'),                  
                    onStartDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelResult) {
                            panelResult.setValue('SALE_FR_DATE',newValue);
                            //panelResult.getField('ISSUE_REQ_DATE_FR').validate();                         
                        }
                    },
                    onEndDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelResult) {
                            panelResult.setValue('SALE_TO_DATE',newValue);
                            //panelResult.getField('ISSUE_REQ_DATE_TO').validate();                         
                        }
                    }
                }]  
            }]                           
        },{
            title:'추가정보',
            id: 'search_panel2',
            itemId:'search_panel2',
            defaultType: 'uniTextfield',
            layout: {type: 'uniTable', columns: 1},
            items:[{
                    fieldLabel: '품목계정',
                    name: 'ITEM_ACCOUNT',
                    xtype: 'uniCombobox',
                    comboType: 'AU',
                    comboCode: 'B020'/*,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('ITEM_ACCOUNT', newValue);
                        }
                    }*/
                }, {
                    xtype: 'radiogroup',
                    fieldLabel: '매출기표유무',
                    //name: 'SALE_YN',
                    items: [{
                        boxLabel: '전체',
                        width: 50,
                        name: 'SALE_YN',
                        inputValue: 'A',
                        checked: true  
                    }, {
                        boxLabel: '기표', 
                        width: 50,
                        name: 'SALE_YN',
                        inputValue: 'Y'
                    }, {
                        boxLabel: '미기표',
                        width: 70,
                        name: 'SALE_YN',
                        inputValue: 'N'
                    }]/*,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            //panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
                            panelResult.getField('SALE_YN').setValue(newValue.SALE_YN);
                        }
                    }*/
               },{
                    fieldLabel: '생성경로',
                    name: 'TXT_CREATE_LOC',
                    xtype: 'uniCombobox',
                    comboType: 'AU',
                    comboCode: 'B031'/*,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('TXT_CREATE_LOC', newValue);
                        }
                    }*/
                }, {
                    fieldLabel: '부가세유형',
                    name: 'BILL_TYPE',
                    xtype: 'uniCombobox',
                    comboType: 'AU',
                    comboCode: 'S024'/*,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('BILL_TYPE', newValue);
                        }
                    }*/
            }, {             
                fieldLabel: '거래처분류' ,
                name: 'AGENT_TYPE',
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'B055'  
             },
                Unilite.popup('ITEM_GROUP',{ 
                fieldLabel: '대표모델코드', 
                textFieldName: 'ITEM_GROUP_CODE', 
                valueFieldName: 'ITEM_GROUP_NAME',
                 validateBlank: false,
                popupWidth: 710
             }), {
                fieldLabel: '출고유형',
                name: 'INOUT_TYPE_DETAIL',
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'S007'
             }, {
                fieldLabel: '지역',
                name: 'AREA_TYPE',
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'B056'  
            },
                Unilite.popup('AGENT_CUST',{
                fieldLabel: '집계거래처',
                validateBlank: false,
                
                valueFieldName: 'MANAGE_CUSTOM',
                textFieldName: 'MANAGE_CUSTOM_NAME',
                id: 'w_ssa450skrv_ypvCustPopup',
                extParam: {'CUSTOM_TYPE': ''}
            }),{
                fieldLabel: '판매유형'  ,
                name: 'ORDER_TYPE',
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'S002'
            }, { 
                fieldLabel: '대분류',
                name: 'ITEM_LEVEL1', 
                xtype: 'uniCombobox',
                store: Ext.data.StoreManager.lookup('itemLeve1Store'),
                child: 'ITEM_LEVEL2'
            }, {
                fieldLabel: '중분류',
                name: 'ITEM_LEVEL2',
                xtype: 'uniCombobox',
                store: Ext.data.StoreManager.lookup('itemLeve2Store'),
                child: 'ITEM_LEVEL3'
            }, {
                fieldLabel: '소분류',
                name: 'ITEM_LEVEL3', 
                xtype: 'uniCombobox',
                store: Ext.data.StoreManager.lookup('itemLeve3Store'),
                parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
                levelType:'ITEM'
            }, { 
                xtype: 'container',
                layout: {type: 'hbox', align: 'stretch'},
                width: 325,
                defaultType: 'uniTextfield',                                            
                items: [{
                    fieldLabel: '매출번호',
                    suffixTpl: '&nbsp;~&nbsp;',
                    name: 'BILL_FR_NO',
                    width: 218
                }, {
                    hideLabel: true,
                    name: 'BILL_TO_NO',
                    width: 107
                }] 
            }, { 
                xtype: 'container',
                layout: {type: 'hbox', align: 'stretch'},
                width: 325,
                defaultType: 'uniTextfield',                                            
                items: [{
                    fieldLabel: '계산서번호',
                    suffixTpl: '&nbsp;~&nbsp;',
                    name: 'PUB_FR_NUM',
                    width: 218
                }, {
                hideLabel: true,
                name: 'PUB_TO_NUM',
                width: 107
                }] 
            }, {
                fieldLabel: '매출량',
                name: 'SALE_FR_Q',
                suffixTpl: '&nbsp;이상'
            }, {
                fieldLabel: ' ',
                name: 'SALE_TO_Q',
                suffixTpl: '&nbsp;이하'
            }, {
                fieldLabel: '출고일',
                 xtype: 'uniDateRangefield',
                 startFieldName: 'INOUT_FR_DATE',
                 endFieldName: 'INOUT_TO_DATE',
                 width: 315                                       
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
                }
            }
            return r;
        }
    });
    
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
            fieldLabel: '사업장',
            name: 'DIV_CODE',
            xtype: 'uniCombobox',
            comboType: 'BOR120',
            value: UserInfo.divCode,
            allowBlank: false,
            listeners: {
                change: function(combo, newValue, oldValue, eOpts) {    
                    combo.changeDivCode(combo, newValue, oldValue, eOpts);
                    var field = panelSearch.getField('SALE_PRSN');  
                    field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
                    panelSearch.setValue('DIV_CODE', newValue);
                }
            }
        },
        Unilite.popup('AGENT_CUST',{
            fieldLabel: '거래처',
            
            extParam: {'CUSTOM_TYPE': '3'},
            valueFieldName: 'SALE_CUSTOM_CODE',
            textFieldName: 'SALE_CUSTOM_NAME',
            colspan: 2,
            listeners: {
                onSelected: {
                    fn: function(records, type) {
                        panelSearch.setValue('SALE_CUSTOM_CODE', panelResult.getValue('SALE_CUSTOM_CODE'));
                        panelSearch.setValue('SALE_CUSTOM_NAME', panelResult.getValue('SALE_CUSTOM_NAME'));                                                                                                         
                    },
                    scope: this
                },
                onClear: function(type) {
                    panelSearch.setValue('SALE_CUSTOM_CODE', '');
                    panelSearch.setValue('SALE_CUSTOM_NAME', '');
                }/*,  거래처팝업 고객구분(AGENT_TYPE) 의 필터 처리
                applyextparam: function(popup){
                    if(Ext.isDefined(panelSearch)){
                        popup.setExtParam({'AGENT_CUST_FILTER': ['3']});
                    }
                }*/
            }
        }), {
            fieldLabel: '매출일',
            width: 315,
            xtype: 'uniDateRangefield',
            allowBlank: false,
            startFieldName: 'SALE_FR_DATE',
            endFieldName: 'SALE_TO_DATE',
            //startDate: UniDate.get('startOfMonth'),
            startDate: UniDate.get('today'),
            endDate: UniDate.get('today'),                  
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelSearch) {
                    panelSearch.setValue('SALE_FR_DATE',newValue);
                    //panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
                    
                }
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelSearch) {
                    panelSearch.setValue('SALE_TO_DATE',newValue);
                    //panelSearch.getField('ISSUE_REQ_DATE_TO').validate();                         
                }
            }
        },{
            fieldLabel: '영업담당'  ,
            name: 'SALE_PRSN',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'S010',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('SALE_PRSN', newValue);
                }
            },
            onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
                if(eOpts){
                    combo.filterByRefCode('refCode1', newValue, eOpts.parent);
                }else{
                    combo.divFilterByRefCode('refCode1', newValue, divCode);
                }
            }
        },
            Unilite.popup('DIV_PUMOK', {
            fieldLabel: '품목코드',
            validateBlank: false,
            listeners: {
            	onValueFieldChange: function(field, newValue){
                        panelSearch.setValue('ITEM_CODE', newValue);                             
                    },
                    onTextFieldChange: function(field, newValue){
                        panelSearch.setValue('ITEM_NAME', newValue);             
                    },
//                onSelected: {
//                    fn: function(records, type) {
//                        panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
//                        panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));                                                                                                           
//                    },
//                    scope: this
//                },
//                onClear: function(type) {
//                    panelSearch.setValue('ITEM_CODE', '');
//                    panelSearch.setValue('ITEM_NAME', '');
//                },
                applyextparam: function(popup){                         
                    popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                }
            }
        })
        /*, {
            fieldLabel: '품목계정',
            name: 'ITEM_ACCOUNT',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'B020',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('ITEM_ACCOUNT', newValue);
                }
            }
        }, {
            xtype: 'radiogroup',
            fieldLabel: '매출기표유무',
            //name: 'SALE_YN',
            items: [{
                boxLabel: '전체',
                width: 50,
                name: 'SALE_YN',
                inputValue: 'A',
                checked: true  
            }, {
                boxLabel: '기표', 
                width: 50,
                name: 'SALE_YN',
                inputValue: 'Y'
            }, {
                boxLabel: '미기표',
                width: 70,
                name: 'SALE_YN',
                inputValue: 'N'
            }],
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    //panelSearch.getField('SALE_YN').setValue({SALE_YN: newValue});
                    panelSearch.getField('SALE_YN').setValue(newValue.SALE_YN);
                }
            }
       },{
            fieldLabel: '생성경로',
            name: 'TXT_CREATE_LOC',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'B031',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('TXT_CREATE_LOC', newValue);
                }
            }
        }, {
            fieldLabel: '부가세유형',
            name: 'BILL_TYPE',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'S024',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('BILL_TYPE', newValue);
                }
            }
        }*/]    
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('w_ssa450skrv_ypGrid1', {
        // for tab
        region: 'center',
        //layout: 'fit',    
        syncRowHeight: false,   
        store: directMasterStore1,
        uniOpt:{
             expandLastColumn: false,
             onLoadSelectFirst: false,
             useRowNumberer: false,
            state: {
                useState: false,         //그리드 설정 버튼 사용 여부
                useStateList: false      //그리드 설정 목록 사용 여부
            }
        },
        features: [ {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
                    {id: 'masterGridTotal',     ftype: 'uniSummary',  showSummaryRow: false} ],
        columns:  [        
                     { dataIndex: 'SALE_CUSTOM_CODE'                    ,           width: 80, locked: false,
                        summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                   return Unilite.renderSummaryRow(summaryData, metaData, '합계', '총계');
            }},             
                    { dataIndex: 'SALE_CUSTOM_NAME'         ,           width: 100, locked: false },        //거래처명
                    { dataIndex: 'BILL_TYPE'                ,           width: 80},                         //부가세유형
                    { dataIndex: 'SALE_DATE'                ,           width: 80},                         //매출일
                    { dataIndex: 'INOUT_TYPE_DETAIL'        ,           width: 123},                        //출고유형
                    { dataIndex: 'ITEM_CODE'                ,           width: 123},                        //품목코드
                    { dataIndex: 'ITEM_NAME'                ,           width: 123 },                       //품명
                    { dataIndex: 'SPEC'                     ,           width: 123 },                       //규격
                    { dataIndex: 'MONEY_UNIT'               ,           width: 80},                         //화폐
                    { dataIndex: 'EXCHG_RATE_O'             ,           width: 80, align: 'right'},         //환율
                    { dataIndex: 'SALE_UNIT'                ,           width: 53, align: 'center'},        //단위
                    { dataIndex: 'TRANS_RATE'               ,           width: 53, align: 'right'},         //입수
                    { dataIndex: 'SALE_Q'                   ,           width: 80, summaryType: 'sum'},     //매출량
                    { dataIndex: 'PRICE_TYPE'               ,           width: 53, hidden: true},           //단가구분
                    { dataIndex: 'SALE_P'                   ,           width: 113 },                       //단가
                    { dataIndex: 'SALE_LOC_AMT_F'           ,           width: 113},    //매출액(외화)
                    { dataIndex: 'TAX_AMT_O'                ,           width: 113},    //세액                     
                    { dataIndex: 'SUM_SALE_AMT'             ,           width: 113},   //매출계
                  
                    { dataIndex: 'SALE_AMT_WON'             ,           width: 113, summaryType: 'sum'},   //매출액(자사)
                    { dataIndex: 'TAX_AMT_WON'              ,           width: 113, summaryType: 'sum'},   //세액(자사)
                    { dataIndex: 'SUM_SALE_AMT_WON'         ,           width: 113, summaryType: 'sum'},   //매출계(자사)
                    
                    { dataIndex: 'DISCOUNT_RATE'            ,           width: 106 },                       //할인율(%)      
                    { dataIndex: 'SALE_LOC_AMT_I'           ,           width: 113, summaryType: 'sum' },   //매출액
                    { dataIndex: 'TAX_TYPE'                 ,           width: 80, align: 'center'},        //과세여부
                    
//                  { dataIndex: 'CONSIGNMENT_FEE'          ,           width: 113},
                                   
                    { dataIndex: 'ORDER_TYPE'               ,           width: 100 },                       //판매유형
                    { dataIndex: 'CUSTOM_CODE'              ,           width: 80},                         //수주거래처       
                    { dataIndex: 'CUSTOM_NAME'              ,           width: 113 },                       //수주거래처명
                    { dataIndex: 'SALE_WGT_Q'               ,           width: 100, hidden: true },         //매출량(중량)     
                    { dataIndex: 'SALE_VOL_Q'               ,           width: 80, hidden: true},           //매출량(부피)       
                    { dataIndex: 'SALE_FOR_WGT_P'           ,           width: 113, hidden: true },         //단가(중량)
                    { dataIndex: 'SALE_FOR_VOL_P'           ,           width: 113, hidden: true},          //단가(부피)         
                    { dataIndex: 'DIV_CODE'                 ,           width: 100 },                       //사업장      
                    { dataIndex: 'SALE_PRSN'                ,           width: 100},                        //영업담당       
                    { dataIndex: 'MANAGE_CUSTOM'            ,           width: 80},                         //집계거래처              
                    { dataIndex: 'MANAGE_CUSTOM_NM'         ,           width: 113 },                       //집계거래처명          
                    { dataIndex: 'AREA_TYPE'                ,           width: 66 },                        //지역                    
                    { dataIndex: 'AGENT_TYPE'               ,           width: 113 },                       //거래처분류
                    { dataIndex: 'PROJECT_NO'               ,           width: 113},                        //프로젝트번호              
                    { dataIndex: 'PUB_NUM'                  ,           width: 80},                         //계산서번호
                    { dataIndex: 'EX_NUM'                   ,           width: 93 },                        //전표번호
                    { dataIndex: 'BILL_NUM'                 ,           width: 106 },                       //매출번호
                    { dataIndex: 'ORDER_NUM'                ,           width: 106 },                       //수주번호
                    { dataIndex: 'PRICE_YN'                 ,           width: 106 },                       //단가구분
                    { dataIndex: 'WGT_UNIT'                 ,           width: 106, hidden: true },         //중량단위
                    { dataIndex: 'UNIT_WGT'                 ,           width: 106, hidden: true },         //단위중량
                    { dataIndex: 'VOL_UNIT'                 ,           width: 106, hidden: true },         //부피단위
                    { dataIndex: 'UNIT_VOL'                 ,           width: 106, hidden: true },         //단위부피
                    { dataIndex: 'COMP_CODE'                ,           width: 106, hidden: true },         //법인코드
                    { dataIndex: 'BILL_SEQ'                 ,           width: 106, hidden: true },         //계산서 순번
                    { dataIndex: 'CREATE_LOC'               ,           width: 80 }                         //생성경로
                    
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
        },
            panelSearch     
        ],
        fnInitBinding: function() {
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
//          panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
//          panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
            panelSearch.setValue('SALE_TO_DATE', UniDate.get('today'));
            panelSearch.setValue('SALE_FR_DATE', UniDate.get('today'));
            //panelSearch.setValue('SALE_FR_DATE', UniDate.get('startOfMonth', panelSearch.getValue('SALE_TO_DATE')));
            
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
//          panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
//          panelResult.setValue('DEPT_NAME', UserInfo.deptName);
            panelResult.setValue('SALE_TO_DATE', UniDate.get('today'));
            panelResult.setValue('SALE_FR_DATE', UniDate.get('today'));
            //panelResult.setValue('SALE_FR_DATE', UniDate.get('startOfMonth', panelSearch.getValue('SALE_TO_DATE')));
            
            var field = panelSearch.getField('SALE_PRSN');
            field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
            var field = panelResult.getField('SALE_PRSN');
            field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
            
            panelSearch.setValue('SALE_CUSTOM_CODE', '${gsCustomCode}');
            panelSearch.setValue('SALE_CUSTOM_NAME', '${gsCustomName}');
//            panelSearch.setValue('SALE_PRSN', '${gsBusiPrsn}');
//            panelSearch.setValue('ORDER_TYPE', '95');
            panelResult.setValue('SALE_CUSTOM_CODE', '${gsCustomCode}');
            panelResult.setValue('SALE_CUSTOM_NAME', '${gsCustomName}');
//            panelResult.setValue('SALE_PRSN', '${gsBusiPrsn}');
//            panelResult.setValue('ORDER_TYPE', '95');
            
            panelSearch.getField('SALE_CUSTOM_CODE').setReadOnly(true);
            panelSearch.getField('SALE_CUSTOM_NAME').setReadOnly(true);
            panelResult.getField('SALE_CUSTOM_CODE').setReadOnly(true);
            panelResult.getField('SALE_CUSTOM_NAME').setReadOnly(true);
        },
        onQueryButtonDown: function()   {
            if(!panelSearch.setAllFieldsReadOnly(true)){
                return false;
            }
            directMasterStore1.loadStoreRecords();
            var viewLocked = masterGrid.getView();
            var viewNormal = masterGrid.getView();
            viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
            viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
            viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
            viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);            
    
        },      
        onDetailButtonDown: function() {
            var as = Ext.getCmp('AdvanceSerch');    
            if(as.isHidden())   {
                as.show();
            }else {
                as.hide()
            }
        },
        onResetButtonDown: function() {
            panelSearch.clearForm();
            panelResult.clearForm();
            masterGrid.getStore().loadData({})
            this.fnInitBinding();
            
        }
    });

};


</script>
