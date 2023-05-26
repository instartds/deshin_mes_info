<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_str900skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_str900skrv_kd"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--매출구분-->
    <t:ExtComboStore comboType="AU" comboCode="S007" /> <!--출고유형-->
    <t:ExtComboStore comboType="AU" comboCode="B004" /> <!--화폐-->
    <t:ExtComboStore comboType="AU" comboCode="M201" /> <!--담당자-->
    <t:ExtComboStore comboType="AU" comboCode="B042" /> <!--계획금액단위-->
    <t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당-->
    <t:ExtComboStore comboType="AU" comboCode="B055" /> <!--고객분류-->
    <t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목계정-->
    <t:ExtComboStore comboType="AU" comboCode="B024" /> <!--수불담당-->
    <t:ExtComboStore comboType="AU" comboCode="B013" /> <!--판매단위-->
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--판매유형-->
    <t:ExtComboStore comboType="AU" comboCode="WB19" /> <!--부서구분-->
    <t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />       <!--창고-->
    <t:ExtComboStore comboType="AU" comboCode="WB17" /> <!-- 기안여부 -->
</t:appConfig>

<script type="text/javascript">

var BsaCodeInfo = {     //컨트롤러에서 값을 받아옴.
    gsBalanceOut:        '${gsBalanceOut}'
};

function appMain() {

	var groupUrl = '${groupUrl}'; //그룹웨어 호출 url

    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_str900skrv_kdService.selectList'
        }
    });

    Unilite.defineModel('s_str900skrv_kdModel', {
        fields: [
            {name: 'COMP_CODE',             text: '법인코드',       type : 'string'},
            {name: 'DIV_CODE',              text: '사업장',        type : 'string', comboType : "BOR120"},
            {name: 'INOUT_CODE',            text: '거래처코드',      type : 'string'},
            {name: 'INOUT_NAME',            text: '거래처명',       type : 'string'},
            {name: 'INOUT_TYPE_DETAIL',     text: '출고유형',       type : 'string', comboType: "AU", comboCode: "S007"},
            {name:  'WH_CODE',              text: '창고',         type : 'string', store : Ext.data.StoreManager.lookup('whList')},

            {name: 'INOUT_NUM',             text: '출고번호',       type : 'string'},
            {name: 'INOUT_SEQ',             text: '순번',         type : 'string'},
            {name: 'ITEM_CODE',             text: '품목코드',       type : 'string'},
            {name: 'ITEM_NAME',             text: '품목명',        type : 'string'},
            {name: 'SPEC',                  text: '규격',         type : 'string'},
            {name: 'ITEM_STATUS',           text: '품목상태',       type : 'string', comboType : 'AU', comboCode : 'B021'},
            {name: 'ORDER_UNIT',            text: '판매단위',       type : 'string'},
            {name: 'TRNS_RATE',             text: '입수',         type : 'string'},
            {name: 'INOUT_DATE',            text: '출고일',        type : 'uniDate'},
            {name: 'INOUT_Q',               text: '출고량',        type : 'uniQty'},
            {name: 'LOT_NO',                text: 'LOT번호',      type : 'string'},
            {name: 'MONEY_UNIT',            text: '화폐단위',       type : 'string'},
            {name: 'INOUT_FOR_P',               text: '단가',         type : 'uniUnitPrice'},
            {name: 'INOUT_FOR_O',               text: '금액',         type : 'uniFC'},
            {name: 'INOUT_I',               text: '금액(자사)',         type : 'uniFC'},
            {name: 'TAX_TYPE',              text: '과세구분',       type : 'string', comboType : 'AU', comboCode : 'B059'},
            {name: 'INOUT_TAX_AMT',         text: '부가세액',       type : 'uniPrice'},
            {name: 'PRICE_TYPE',            text: '단가구분',       type : 'string', comboType : 'AU', comboCode : 'B116'},
            {name: 'ACCOUNT_YNC',           text: '매출대상',       type : 'string', comboType : 'AU', comboCode : 'B010'},
            {name: 'SALE_CUSTOM_CODE',      text: '매출처코드',      type : 'string'},
            {name: 'SALE_CUSTOM_NAME',      text: '매출처명',       type : 'string'},
            {name: 'DVRY_CUST_CD',          text: '배송처코드',      type : 'string'},
            {name: 'DVRY_CUST_NM',          text: '배송처명',       type : 'string'},
            {name: 'ORDER_CUST_CD',         text: '수주처코드',      type : 'string'},
            {name: 'ORDER_CUST_NM',         text: '수주처명',       type : 'string'},
            {name: 'DEPT_CODE',             text: '부서코드',       type : 'string'},
            {name: 'DEPT_NAME',             text: '부서명',        type : 'string'},
            {name: 'INOUT_PRSN',            text: '담당자' ,       type : 'string', comboType : 'AU', comboCode : 'B024'},
            {name: 'UNIQUE_ID',             text: '검수번호',       type : 'string'},
            {name: 'DEPT_GUBUN',            text: '부서구분',       type : 'string', comboType : 'AU', comboCode : 'WB19'},
            {name: 'GW_FLAG',               text: '기안여부',    type : 'string', comboType: 'AU', comboCode: 'WB17'},
            {name: 'GW_DOC',                text: '기안문서번호',     type : 'string'},
            {name: 'DRAFT_NO',              text: 'DRAFT_NO',     type : 'string'},
            {name: 'COMP_CODE',             text: '법인코드',       type : 'string'},
            {name: 'DIV_CODE',              text: '사업장코드',      type : 'string'}
        ]
    });

    var directMasterStore = Unilite.createStore('s_str900skrv_kdMasterStore',{
        model: 's_str900skrv_kdModel',
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
                  params : param,
                  callback: function(records, operation, success){
                  	console.log(records);
                  	if(success){
                  		if(masterGrid.getStore().getCount() == 0){
                  			Ext.getCmp('GW').setDisabled(true);
                  			UniAppManager.setToolbarButtons('print', false);
                  		}else if(masterGrid.getStore().getCount() != 0){
                  			UniBase.fnGwBtnControl('GW', directMasterStore.data.items[0].data.GW_FLAG);
                  			UniAppManager.setToolbarButtons('print', true);
                  		}
                  	}
                  }
            });
        },
        listeners: {
            load:function( store, records, successful, operation, eOpts ) {

            }
        },
        groupField: 'INOUT_NAME'
    });

    //panelResult(검색조건)
    var panelResult = Unilite.createSearchForm('resultForm', {
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
                fieldLabel: '수불기간',
                xtype: 'uniDateRangefield',
                startFieldName: 'FR_INOUT_DATE',
                endFieldName: 'TO_INOUT_DATE',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank:false
            },
    		Unilite.popup('DIV_PUMOK',{
    			fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
    			valueFieldName: 'ITEM_CODE',
    			textFieldName: 'ITEM_NAME',
    			validateBlank: false,
    			listeners: {
    				onValueFieldChange: function(field, newValue){

    				},
    				onTextFieldChange: function(field, newValue){

    				},
    				applyextparam: function(popup){
    					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
    				}
    			}
    		}),
            Unilite.popup('CUST',{
                    fieldLabel: '매출처',
                    valueFieldName:'SALE_CUSTOM_CODE',
                    textFieldName:'SALE_CUSTOM_NAME'
            }),
            Unilite.popup('CUST',{
                    fieldLabel: '출고처',
                    valueFieldName:'INOUT_CODE',
                    textFieldName:'INOUT_NAME'
            }),{
                fieldLabel:  '창고',
                name: 'WH_CODE',
                xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('whList')
            },
            Unilite.popup('DEPT', {
                    fieldLabel: '부서',
                    valueFieldName: 'DEPT_CODE',
                    textFieldName: 'DEPT_NAME'
            }),{
                fieldLabel: '담당자',
                name: 'INOUT_PRSN',
                xtype:'uniCombobox',
                comboType: 'AU',
                comboCode: 'B024',
                onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
                    if(eOpts){
                        combo.filterByRefCode('refCode1', newValue, eOpts.parent);
                    }else{
                        combo.divFilterByRefCode('refCode1', newValue, divCode);
                    }
                }
            },{
                fieldLabel: '부서구분',
                name:'DEPT_GUBUN',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'WB19'
            },{
                xtype: 'radiogroup',
                fieldLabel: '반품포함여부',
                itemId:'RETURN_FLAG',
                width: 300,
                items: [{
                    boxLabel:'포함',
                    name:'RETURN_FLAG',
                    inputValue: 'Y',
                    checked: true
                },{
                    boxLabel:'포함안함',
                    name:'RETURN_FLAG',
                    inputValue: 'N'
                }]
            },{
                xtype: 'radiogroup',
                fieldLabel: 'GW기안',
                itemId:'GW_FLAG',
                width: 300,
                items: [{
                    boxLabel:'전체',
                    name:'GW_FLAG',
                    inputValue: '1'
                },{
                    boxLabel:'기안',
                    name:'GW_FLAG',
                    inputValue: '2'
                },{
                    boxLabel:'미기안',
                    name:'GW_FLAG',
                    inputValue: '3',
                    checked: true
                }]
            }
            /*,{
                xtype:'button',           //필드 타입
                text: '기안',
//                margin: '0 0 0 0',
                width: 80,
                handler : function() {
                    if(panelResult.setAllFieldsReadOnly(true) == false){
                        return false;
                    }
                    else {
                        alert('SP실행');
                    }
                }
            }*/
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

    var subForm = Unilite.createSearchForm('subForm', {
        padding: '0 0 0 0',
        layout:{type:'uniTable', columns: '1', tableAttrs: {width: '99.5%'}},
        items:[{
            xtype: 'container',
            layout:{type:'uniTable', columns: '4'},
            tdAttrs: {align: 'right'},
            items:[
                Unilite.popup('Employee',{
                    fieldLabel: '담당자',
                    valueFieldName:'PERSON_NUMB',
                    textFieldName:'NAME',
                    validateBlank:false,
                    autoPopup:true
                }),{
                    xtype : 'button',
                    text:'기안',
                    id:'GW',
                    handler: function() {
                        var masterRecord = masterGrid.getSelectedRecord();
                        var count = masterGrid.getStore().getCount();
                        var param = panelResult.getValues();

                        if(count == 0) {
                            alert('출력할 항목을 선택 후 진행하십시오.');
                            return false;
                        }

                        if(Ext.isEmpty(subForm.getValue('NAME'))) {
                            alert('담당자를 선택 후 진행하십시오.');
                            return false;
                        }
                        param.DIV_CODE  = masterRecord.data['DIV_CODE'];
                        param.DRAFT_NO  = UserInfo.compCode + masterRecord.data['INOUT_NUM'];
                        param.INOUT_NUM = masterRecord.data['INOUT_NUM'];
                        if(confirm('기안 하시겠습니까?')) {
                            s_str900skrv_kdService.selectGwData(param, function(provider, response) {
                                if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
//                                    panelResult.setValue('GW_TEMP', '기안중');
                                    s_str900skrv_kdService.makeDraftNum(param, function(provider2, response)   {
                                        UniAppManager.app.requestApprove1();
                                    });
                                } else {
                                    alert('이미 기안된 자료입니다.');
                                    return false;
                                }
                            });
                        }

                    }
                 }, {
     				fieldLabel: '영업일보기준일',
    				xtype: 'uniDatefield',
    				name: 'TO_DATE'
    			  },{
                    xtype : 'button',
                    text:'영업일보 출력',
                    handler: function() {
                        var masterRecord = masterGrid.getSelectedRecord();
                        var count = masterGrid.getStore().getCount();
                        var param = panelResult.getValues();

//                        if(count == 0) {
//                            alert('출력할 항목을 선택 후 진행하십시오.');
//                            return false;
//                        }
//
//                        if(subForm.getValue('NAME') == '') {
//                            alert('담당자를 선택 후 진행하십시오.');
//                            return false;
//                        }

                        if(panelResult.getValue('FR_INOUT_DATE') == panelResult.getValue('TO_INOUT_DATE')) {
                            alert('수불기간(FROM, TO) 이 동일합니다. 수정 후 진행하십시오.');
                            return false;
                        }

                        UniAppManager.app.requestApprove2();

                    }
                 }
            ]}
        ]
    });

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
    var masterGrid = Unilite.createGrid('s_str900skrv_kdmasterGrid', {
        layout : 'fit',
        region: 'center',
        store: directMasterStore,
        selModel: 'rowmodel',
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
            {dataIndex: 'INOUT_CODE', width: 100,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
                }
            },
            {dataIndex : 'INOUT_NAME',          width : 180},
            {dataIndex : 'INOUT_TYPE_DETAIL',   width : 100},
            {dataIndex : 'WH_CODE',             width : 100},
            {dataIndex : 'INOUT_NUM',           width : 120},
            {dataIndex : 'INOUT_SEQ',           width : 50},
            {dataIndex : 'ITEM_CODE',           width : 100},
            {dataIndex : 'ITEM_NAME',           width : 200},
            {dataIndex : 'SPEC',                width : 80, hidden : true},
            {dataIndex : 'ITEM_STATUS',         width : 90},
            {dataIndex : 'ORDER_UNIT',          width : 90},
            {dataIndex : 'TRNS_RATE',           width : 60},
            {dataIndex : 'INOUT_DATE',          width : 100},
            {dataIndex : 'INOUT_Q',             width : 100, summaryType : 'sum'},
            {dataIndex : 'LOT_NO',              width : 100},
            {dataIndex : 'MONEY_UNIT',          width : 90, align: 'center'},
            {dataIndex : 'INOUT_FOR_P',         width : 100},
            {dataIndex : 'INOUT_FOR_O',         width : 100, summaryType : 'sum'},
            {dataIndex : 'INOUT_I',             width : 130, summaryType : 'sum'},
            {dataIndex : 'TAX_TYPE',            width : 100, align: 'center'},
            {dataIndex : 'INOUT_TAX_AMT',       width : 120, summaryType : 'sum'},
            {dataIndex : 'PRICE_TYPE',          width : 100},
            {dataIndex : 'ACCOUNT_YNC',         width : 100},
            {dataIndex : 'SALE_CUSTOM_CODE',    width : 100, hidden : true},
            {dataIndex : 'SALE_CUSTOM_NAME',    width : 100},
            {dataIndex : 'DVRY_CUST_CD',        width : 100, hidden : true},
            {dataIndex : 'DVRY_CUST_NM',        width : 100, hidden : true},
            {dataIndex : 'ORDER_CUST_CD',       width : 100, hidden : true},
            {dataIndex : 'ORDER_CUST_NM',       width : 100},
            {dataIndex : 'DEPT_CODE',           width : 100, hidden : true},
            {dataIndex : 'DEPT_NAME',           width : 100},
            {dataIndex : 'INOUT_PRSN',          width : 100},
            {dataIndex : 'UNIQUE_ID',           width : 100},
            {dataIndex : 'DEPT_GUBUN',          width : 100},
            {dataIndex : 'GW_FLAG',             width : 100},
            {dataIndex : 'GW_DOC',              width : 100},
            {dataIndex : 'DRAFT_NO',            width : 100, hidden : true},
            {dataIndex : 'COMP_CODE',           width : 100, hidden : true},
            {dataIndex : 'DIV_CODE',            width : 100, hidden : true}
        ],
        listeners: {
        	 cellclick: function(view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
        		 var gwFlag = directMasterStore.data.items[rowIndex].data.GW_FLAG;
				 UniBase.fnGwBtnControl('GW', gwFlag);
	          }
        }
    });

    Unilite.Main( {
        borderItems:[{
//            region:'center',
//            layout: 'border',
//            border: false,
        	layout: {type: 'vbox', align: 'stretch'},
            region: 'center',
            items:[
                panelResult, subForm, masterGrid
            ]
        }],
        id  : 's_str900skrv_kdApp',
        fnInitBinding : function() {
            panelResult.clearForm();
            directMasterStore.clearData();
            this.setDefault();
        },
        onQueryButtonDown : function()  {
        	if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
        	masterGrid.reset();
            directMasterStore.loadStoreRecords();
            var viewLocked = masterGrid.getView();
            var viewNormal = masterGrid.getView();
            viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
            viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
            viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
            viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
            UniAppManager.setToolbarButtons('reset', true);
        },
        onResetButtonDown: function() {
        	Ext.getCmp('GW').setDisabled(true);
            panelResult.setAllFieldsReadOnly(false);
            masterGrid.reset();
            this.fnInitBinding();
        },
        onPrintButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return;    //필수체크
			var param = panelResult.getValues();

            param.PGM_ID = 's_str900skrv_kd';  //프로그램ID
            param.sTxtValue2_fileTitle = '출고현황';

            param.BASIS_DATE = UniDate.getDbDateStr(subForm.getValue('TO_DATE'));

			var win = Ext.create('widget.ClipReport', {
				url: CPATH+'/z_kd/s_str900skrv_kd_clrkrv.do',
				prgID: 's_str900skrv_kd',
				extParam: param
			});
			win.center();
			win.show();
        },
        requestApprove1: function(){     //결재 요청
            var gsWin = window.open('about:blank','payviewer','width=500,height=500');

            var frm         = document.f1;
            var record      = masterGrid.getSelectedRecord();
            var compCode    = UserInfo.compCode;
            var divCode     = record.data['DIV_CODE'];
            var inoutNum    = record.data['INOUT_NUM'];
            var personNumb  = subForm.getValue('PERSON_NUMB');
            var userId      = UserInfo.userID;
            var spText      = 'EXEC omegaplus_kdg.unilite.USP_GW_S_STR900SKRV1_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + inoutNum + "'" + ', ' + "'" + personNumb + "'"  + ', ' + "'" + userId + "'";
            var spCall      = encodeURIComponent(spText);

//            frm.action = '/payment/payreq.php';
//            frm.action   = groupUrl + "&prg_no=s_str900skrv1_kd&draft_no=" + UserInfo.compCode + inoutNum + "&sp=" + spCall + Base64.encode();
//            frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_str900skrv1_kd&draft_no=" + UserInfo.compCode + inoutNum + "&sp=" + spCall;
//            frm.target   = "payviewer";
//            frm.method   = "post";
//            frm.submit();

            var gwurl = groupUrl + "viewMode=docuDraft" + "&prg_no=s_str900skrv1_kd&draft_no=" + UserInfo.compCode + inoutNum + "&sp=" + spCall;

            UniBase.fnGw_Call(gwurl,frm,'GW');
        },
        requestApprove2: function(){     //결재 요청
            var gsWin = window.open('about:blank','payviewer','width=500,height=500');

            var frm             = document.f1;
            var record          = masterGrid.getSelectedRecord();
            var compCode        = UserInfo.compCode;
            var divCode         = panelResult.getValue('DIV_CODE');
            var basisDate       = UniDate.getDbDateStr(subForm.getValue('TO_DATE'));//UniDate.getDbDateStr(panelResult.getValue('TO_INOUT_DATE'));

            if(Ext.isEmpty(panelResult.getValue('INOUT_PRSN'))) {
                var inoutPrsn       = '';
            } else {
                var inoutPrsn       = panelResult.getValue('INOUT_PRSN');
            }
            if(Ext.isEmpty(panelResult.getValue('WH_CODE'))) {
                var whCode          = '';
            } else {
                var whCode          = panelResult.getValue('WH_CODE');
            }
            if(Ext.isEmpty(panelResult.getValue('DEPT_CODE'))) {
                var deptCode        = '';
            } else {
                var deptCode        = panelResult.getValue('DEPT_CODE');
            }
            if(Ext.isEmpty(panelResult.getValue('SALE_CUSTOM_CODE'))) {
                var saleCustomCode  = '';
            } else {
                var saleCustomCode  = panelResult.getValue('SALE_CUSTOM_CODE');
            }
            if(Ext.isEmpty(panelResult.getValue('INOUT_CODE'))) {
                var inout_code      = '';
            } else {
                var inout_code      = panelResult.getValue('INOUT_CODE');
            }
            if(Ext.isEmpty(panelResult.getValue('DEPT_GUBUN'))) {
                var deptGubun       = '';
            } else {
                var deptGubun       = panelResult.getValue('DEPT_GUBUN');
            }

//            var personNumb      = subForm.getValue('PERSON_NUMB');
//            var returnFlag      = panelResult.getValue('RETURN_FLAG');
            var userId          = UserInfo.userID;
            var spText          = 'EXEC omegaplus_kdg.unilite.USP_GW_S_STR900SKRV2_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + basisDate + "'" + ', ' + "'" + inoutPrsn + "'"  + ', ' + "'" + whCode + "'"  + ', ' + "'" + deptCode + "'"  + ', ' + "'" + saleCustomCode + "'"  + ', ' + "'" + inout_code + "'"  + ', ' + "'" + deptGubun + "'" /* + ', ' + "'" + personNumb + "'" */ + ', ' + "'" + userId + "'";
            var spCall          = encodeURIComponent(spText);

//            frm.action = '/payment/payreq.php';
            frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_str900skrv2_kd&draft_no=" + '0' + "&sp=" + spCall;
//            frm.action   = groupUrl + "&prg_no=s_str900skrv2_kd&draft_no=" + UserInfo.compCode + inoutNum + "&sp=" + spCall + Base64.encode();
            frm.target   = "payviewer";
            frm.method   = "post";
            frm.submit();
        },
        setDefault: function() {
        	subForm.setValue('TO_DATE', UniDate.get('today'));
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('FR_INOUT_DATE', UniDate.get('startOfMonth'));
            panelResult.setValue('TO_INOUT_DATE', UniDate.get('today'));
        }
    });
};

</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>