<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
    String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
    request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="sbs030ukrv"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="sbs030ukrv"/>           <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목계정-->
    <t:ExtComboStore comboType="AU" comboCode="B004" /> <!--화폐단위-->
    <t:ExtComboStore comboType="AU" comboCode="B013" /> <!--단위-->
    <t:ExtComboStore comboType="AU" comboCode="B015" /> <!--고객구분-->
    <t:ExtComboStore comboType="AU" comboCode="B055" /> <!--고객분류-->
    <t:ExtComboStore comboType="AU" comboCode="B058" /> <!--적요구분-->
    <t:ExtComboStore comboType="AU" comboCode="S065" /> <!--주문구분-->
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />



</t:appConfig>
<link rel="stylesheet" type="text/css" href='<c:url value="/${ext_root}/app/Ext/ux/css/GroupTabPanel.css" />' />
<script type="text/javascript" >

var BsaCodeInfo = {
    gsMoneyUnit: '${gsMoneyUnit}'
};
var showBtn = ('${showBtn}' == 'Y' ? false : true);

function appMain() {
	var selectedMasterGrid = 'sbs030ukrv0_Grid';

	var directProxy0_1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
           read : 'sbs030ukrsService.selectList0_1'
        }
    });

    var directProxy0_2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
           read    : 'sbs030ukrsService.selectList0_2',
           create  : 'sbs030ukrsService.insertDetail0_2',
           update  : 'sbs030ukrsService.updateDetail0_2',
           destroy : 'sbs030ukrsService.deleteDetail0_2',
           syncAll : 'sbs030ukrsService.saveAll0_2'
        }
    });

    var directProxy0_3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
           read    : 'sbs030ukrsService.selectList0_3',
           create  : 'sbs030ukrsService.insertDetail0_3',
           update  : 'sbs030ukrsService.updateDetail0_3',
           destroy : 'sbs030ukrsService.deleteDetail0_3',
           syncAll : 'sbs030ukrsService.saveAll0_3'
        }
    });

    var directProxy2_1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
           read : 'sbs030ukrsService.selectList2'
        }
    });

    var directProxy2_2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
           read    : 'sbs030ukrsService.selectList2_2',
           create  : 'sbs030ukrsService.insertDetail2_2',
           update  : 'sbs030ukrsService.updateDetail2_2',
           destroy : 'sbs030ukrsService.deleteDetail2_2',
           syncAll : 'sbs030ukrsService.saveAll2_2'
        }
    });

    var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
           read    : 'sbs030ukrsService.selectList3',
           create  : 'sbs030ukrsService.insertDetail3',
           update  : 'sbs030ukrsService.updateDetail3',
           destroy : 'sbs030ukrsService.deleteDetail3',
           syncAll : 'sbs030ukrsService.saveAll3'
        }
    });

    var directProxy4 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
           read    : 'sbs030ukrsService.selectList4',
           create  : 'sbs030ukrsService.insertDetail4',
           update  : 'sbs030ukrsService.updateDetail4',
           destroy : 'sbs030ukrsService.deleteDetail4',
           syncAll : 'sbs030ukrsService.saveAll4'
        }
    });

    var directProxy8_1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
           read    : 'sbs030ukrsService.selectList8_1',
           create  : 'sbs030ukrsService.insertDetail8_1',
           //update  : 'sbs030ukrsService.updateDetail8_1',
           destroy : 'sbs030ukrsService.deleteDetail8_1',
           syncAll : 'sbs030ukrsService.saveAll8_1'
        }
    });

    var directProxy8_2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
           read    : 'sbs030ukrsService.selectList8_2',
           create  : 'sbs030ukrsService.insertDetail8_2',
           update  : 'sbs030ukrsService.updateDetail8_2',
           destroy : 'sbs030ukrsService.deleteDetail8_2',
           syncAll : 'sbs030ukrsService.saveAll8_2'
        }
    });

    <%@include file="./sbs030ukrvModel.jsp" %>

    var panelDetail = Ext.create('Ext.panel.Panel', {
        layout : 'fit',
        region : 'center',
        disabled:false,
        items : [{
            xtype: 'grouptabpanel',
            itemId: 'sbs030Tab',
            activeGroup: 0,
            collapsible:true,
            items: [{
                defaults:{
                    xtype:'uniDetailForm',
                    disabled:false,
                    border:0,
                    layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},
                    padding: '10 10 10 10'
                },
                items:[
                    <%@include file="./sbs030ukrvs0.jsp" %> //판매단가등록
                ]
             },{
                defaults:{
                    xtype:'uniDetailForm',
                    disabled:false,
                    border:0,
                    layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},
                    padding: '10 10 10 10'
                },
                items:[
                    <%@include file="./sbs030ukrvs0_1.jsp" %> //고객품목등록
                ]
             }, /*{
                defaults:{
                    xtype:'uniDetailForm',
                    disabled:false,
                    border:0,
                    layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},
                    padding: '10 10 10 10'
                },
                items:[
                    <%@include file="./sbs030ukrvs1.jsp" %> //판매유형
                ]
             }, */{
                defaults:{
                    xtype:'uniDetailForm',
                    disabled:false,
                    border:3,
                    layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},
                    padding: '10 10 10 10'
                },
                items:[
                    <%@include file="./sbs030ukrvs2.jsp" %> //배송처등록
                ]
             }, {
                defaults:{
                    xtype:'uniDetailForm',
                    disabled:false,
                    border:0,
                    layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},
                    padding: '10 10 10 10'
                },
                items:[
                    <%@include file="./sbs030ukrvs3.jsp" %>  //적요등록
                ]
             }, {
                defaults:{
                    xtype:'uniDetailForm',
                    disabled:false,
                    border:0,
                    layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},
                    padding: '10 10 10 10'
                },
                items:[
                    <%@include file="./sbs030ukrvs4.jsp" %>  //거래처기초잔액등록
                ]
             }, /*{
                defaults:{
                    xtype:'uniDetailForm',
                    disabled:false,
                    border:0,
                    layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},
                    padding: '10 10 10 10'
                },
                items:[
                    <%@include file="./sbs030ukrvs5.jsp" %> //품목별 할인등록(고객분류별)
                ]
             }, {
                defaults:{
                    xtype:'uniDetailForm',
                    disabled:false,
                    border:0,
                    layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},
                    padding: '10 10 10 10'
                },
                items:[
                    <%@include file="./sbs030ukrvs6.jsp" %> //품목별 할인등록(고객별)
                ]
             }, {
                defaults:{
                    xtype:'uniDetailForm',
                    disabled:false,
                    border:0,
                    layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},
                    padding: '10 10 10 10'
                },
                items:[
                  <%@include file="./sbs030ukrvs7.jsp" %>  //기본정보 등록
                ]
             },*/ {
                defaults:{
                    xtype:'uniDetailForm',
                    disabled:false,
                    border:0,
                    layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},
                    padding: '10 10 10 10'
                },
                items:[
                  <%@include file="./sbs030ukrvs8.jsp" %>  //SET품목등록
                ]
             }]
        }],
        listeners: {
            beforetabchange: function ( grouptabPanel, newCard, oldCard, eOpts )    {
                if(Ext.isObject(oldCard))   {
                     if(UniAppManager.app._needSave())  {
                        if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {
                            UniAppManager.app.onSaveDataButtonDown();
                            this.setActiveTab(oldCard);
                        }else {
                            oldCard.getStore().rejectChanges();
                            UniAppManager.app.fnInitBinding();
                            UniAppManager.setToolbarButtons(['reset', 'excel', 'delete'],false);
                            UniAppManager.app.loadTabData(newCard, newCard.getItemId());

                        }
                     }else {
                            UniAppManager.app.fnInitBinding();
                            UniAppManager.setToolbarButtons(['reset', 'excel', 'delete'],false);
                            UniAppManager.app.loadTabData(newCard, newCard.getItemId());

                     }
                }
            }
       }
    });


     Unilite.Main( {
        borderItems:[
            panelDetail
        ],
        id : 'sbs030ukrvApp',
        fnInitBinding : function() {
            UniAppManager.setToolbarButtons(['reset', 'excel', 'delete'],false);
            UniAppManager.setToolbarButtons(['query'],true);

            var param =  panelDetail.down('#sbs030ukrvs4Tab').getValues();
            sbs030ukrsService.selectBasisYyyymm(param, function(provider, response){
            	if(!Ext.isEmpty(provider)) {
                	panelDetail.down('#sbs030ukrvs4Tab').setValue('BASIS_YYYYMM', provider[0].BASIS_YYYYMM);
	                //param.BASIS_YYYYMM = provider.BASIS_YYYYMM;
            	}
            });
        },
        onQueryButtonDown : function()  {
            var activeTab = panelDetail.down('#sbs030Tab').getActiveTab();
            UniAppManager.setToolbarButtons(['reset', 'newData'],true);
            if(activeTab.getId() == 'tab_sbs030ukrv0Tab'){
            	if(!UniAppManager.app.checkForNewDetail1()) {
                    return false;
                } else {
                    sbs030ukrvs0_1Store.loadStoreRecords();
    //                if(panelDetail.down('#sbs030ukrv0_Grid').getStore().getCount() > 0) {
    //                    UniAppManager.setToolbarButtons(['reset', 'newData'],true);
    //                } else {
    //                	UniAppManager.setToolbarButtons(['reset', 'excel', 'delete'],false);
    //                }
                }
            } else if(activeTab.getId() == 'tab_sbs030ukrv0_1Tab') {
            	if(!UniAppManager.app.checkForNewDetail2()) {
                    return false;
                } else {
                	sbs030ukrvs0_1Store.loadStoreRecords();
    //                if(panelDetail.down('#sbs030ukrv0_Grid').getStore().getCount() > 0) {
    //                    UniAppManager.setToolbarButtons(['reset', 'newData'],true);
    //                } else {
    //                    UniAppManager.setToolbarButtons(['reset', 'excel', 'delete'],false);
    //                }
                }
            } else if(activeTab.getId() == 'sbs030ukrvs2Tab') {
            	if(!UniAppManager.app.checkForNewDetail3()) {
                    return false;
                } else {
                    sbs030ukrvs2_1Store.loadStoreRecords();
    //                if(panelDetail.down('#sbs030ukrvs2_1Grid').getStore().getCount() > 0) {
    //                    UniAppManager.setToolbarButtons(['reset', 'newData'],true);
    //                } else {
    //                    UniAppManager.setToolbarButtons(['reset', 'excel', 'delete'],false);
    //                }
                }
            } else if(activeTab.getId() == 'sbs030ukrvs3Tab') {
            	if(!UniAppManager.app.checkForNewDetail4()) {
                    return false;
                } else {
                sbs030ukrvs3Store.loadStoreRecords();
    //                if(panelDetail.down('#sbs030ukrvs3Grid').getStore().getCount() > 0) {
    //                    UniAppManager.setToolbarButtons(['reset', 'newData'],true);
    //                } else {
    //                    UniAppManager.setToolbarButtons(['reset', 'excel', 'delete'],false);
    //                }
                }
            } else if(activeTab.getId() == 'sbs030ukrvs4Tab') {
            	if(!UniAppManager.app.checkForNewDetail5()) {
                    return false;
                } else {
                	if(Ext.isEmpty(panelDetail.down('#sbs030ukrvs4Tab').getValue('BASIS_YYYYMM'))) {
                		Unilite.messageBox('기초잔액을 등록하기 전에 기초년월을 입력해 주십시오.');
                		return false;
                	}
                    sbs030ukrvs4Store.loadStoreRecords();
    //                if(panelDetail.down('#sbs030ukrvs3Grid').getStore().getCount() > 0) {
    //                    UniAppManager.setToolbarButtons(['reset', 'newData'],true);
    //                } else {
    //                    UniAppManager.setToolbarButtons(['reset', 'excel', 'delete'],false);
    //                }
                }
            } else if(activeTab.getId() == 'sbs030ukrvs8Tab') {
            	if(!UniAppManager.app.checkForNewDetail6()) {
                    return false;
                } else {
                    sbs030ukrvs8_1Store.loadStoreRecords();
    //                if(panelDetail.down('#sbs030ukrvs3Grid').getStore().getCount() > 0) {
    //                    UniAppManager.setToolbarButtons(['reset', 'newData'],true);
    //                } else {
    //                    UniAppManager.setToolbarButtons(['reset', 'excel', 'delete'],false);
    //                }
                }
            }
        },
        onResetButtonDown: function() {     // 초기화
            var activeTab = panelDetail.down('#sbs030Tab').getActiveTab();
            if(activeTab.getId() == 'tab_sbs030ukrv0Tab'){
                UniAppManager.setToolbarButtons(['reset'],false);
                sbs030ukrvs0_1Store.clearData();
                sbs030ukrvs0_2Store.clearData();
                panelDetail.down('#sbs030ukrv0_Grid').reset();
                panelDetail.down('#sbs030ukrv0_Grid2').reset();
            } else if(activeTab.getId() == 'tab_sbs030ukrv0_1Tab') {
                UniAppManager.setToolbarButtons(['reset'],false);
                sbs030ukrvs0_1Store.clearData();
                sbs030ukrvs0_3Store.clearData();
                panelDetail.down('#sbs030ukrv0_1Grid').reset();
                panelDetail.down('#sbs030ukrv0_Grid3').reset();
            } else if(activeTab.getId() == 'sbs030ukrvs2Tab') {
                UniAppManager.setToolbarButtons(['reset'],false);
                sbs030ukrvs2_1Store.clearData();
                sbs030ukrvs2_2Store.clearData();
                panelDetail.down('#sbs030ukrvs2_1Grid').reset();
                panelDetail.down('#sbs030ukrvs2_2Grid').reset();
            } else if(activeTab.getId() == 'sbs030ukrvs3Tab') {
                UniAppManager.setToolbarButtons(['reset'],false);
                sbs030ukrvs3Store.clearData();
                panelDetail.down('#sbs030ukrvs3Grid').reset();
            } else if(activeTab.getId() == 'sbs030ukrvs4Tab') {
                UniAppManager.setToolbarButtons(['reset'],false);
                sbs030ukrvs4Store.clearData();
                panelDetail.down('#sbs030ukrvs4Grid').reset();
            } else if(activeTab.getId() == 'sbs030ukrvs8Tab') {
                UniAppManager.setToolbarButtons(['reset'],false);
                sbs030ukrvs8_1Store.clearData();
                sbs030ukrvs8_2Store.clearData();
                panelDetail.down('#sbs030ukrvs8_1Grid').reset();
                panelDetail.down('#sbs030ukrvs8_2Grid').reset();
            }
        },
        onNewDataButtonDown : function()    {
//        	if(panelDetail.setAllFieldsReadOnly(true) == false){
//                return false;
//            } else {
                var activeTab = panelDetail.down('#sbs030Tab').getActiveTab();
                if(activeTab.getId() == 'tab_sbs030ukrv0Tab'){
                	var param =  panelDetail.down('#tab_sbs030ukrv0Tab').getValues();
                	var record = Ext.getCmp('tab_sbs030ukrv0Tab').down('#sbs030ukrv0_Grid').getSelectedRecord();

                    var compCode = UserInfo.compCode;
                    var divCode = param.DIV_CODE;
                    var moneyUnit = BsaCodeInfo.gsMoneyUnit;
                    var orderUnit = param.STOCK_UNIT_TEMP;
                    var aplyStartDate = UniDate.get('today');
                    var type = '2';
                    var itemCode = param.ITEM_CODE_TEMP;

                    var r = {
                        COMP_CODE : compCode,
                        DIV_CODE : divCode,
                        MONEY_UNIT : moneyUnit,
                        ORDER_UNIT : orderUnit,
                        APLY_START_DATE : aplyStartDate,
                        TYPE : type,
                        ITEM_CODE : itemCode
                    }
                    panelDetail.down('#sbs030ukrv0_Grid2').createRow(r);
                } else if(activeTab.getId() == 'tab_sbs030ukrv0_1Tab') {
                    var param =  panelDetail.down('#tab_sbs030ukrv0_1Tab').getValues();
                    var record = Ext.getCmp('tab_sbs030ukrv0_1Tab').down('#sbs030ukrv0_1Grid').getSelectedRecord();

                    var itemCode      = param.ITEM_CODE_TEMP;
                    var type          = '2';
                    var orderUnit     = param.SALE_UNIT_TEMP;
                    var trnsRate      = param.TRNS_RATE_TEMP;
                    var aplyStartDate = UniDate.get('today');
                    var orderPrsn     = '*';
                    var makerName     = '*';
                    var agreeDate     = UniDate.get('today');
                    var orderRate     = '100';
                    var divCode       = param.DIV_CODE;
                    var compCode      = UserInfo.compCode;
                    var basisP        = '0';
                    var agentP        = '0';

                    var r = {
                        ITEM_CODE       : itemCode,
                        TYPE            : type,
                        ORDER_UNIT      : orderUnit,
                        TRNS_RATE       : trnsRate,
                        APLY_START_DATE : aplyStartDate,
                        ORDER_PRSN      : orderPrsn,
                        MAKER_NAME      : makerName,
                        AGREE_DATE      : agreeDate,
                        ORDER_RATE      : orderRate,
                        DIV_CODE        : divCode,
                        COMP_CODE       : compCode,
                        BASIS_P         : basisP,
                        AGENT_P         : agentP
                    }
                    panelDetail.down('#sbs030ukrv0_Grid3').createRow(r);
                } else if(activeTab.getId() == 'sbs030ukrvs2Tab') {
                    var param =  panelDetail.down('#sbs030ukrvs2Tab').getValues();
                    var record = Ext.getCmp('sbs030ukrvs2Tab').down('#sbs030ukrvs2_2Grid').getSelectedRecord();
                    var record2 = Ext.getCmp('sbs030ukrvs2Tab').down('#sbs030ukrvs2_1Grid').getSelectedRecord();

                    if(Ext.isEmpty(record2)){
                    	Unilite.messageBox('상단 그리드에 선택된 거래처가 없습니다.' + '\n' + '거래처 선택 후 다시 시도해주세요.');
                    	return false;
                    }
                    var customCode    = param.CUSTOM_CODE_TEMP;
                    var dvryCustSeq   = sbs030ukrvs2_2Store.max('DVRY_CUST_SEQ');
                    if(!dvryCustSeq) dvryCustSeq = 1;
                    else  dvryCustSeq += 1;
                    var compCode      = UserInfo.compCode;

                    var r = {
                        CUSTOM_CODE       : customCode,
                        DVRY_CUST_SEQ     : dvryCustSeq,
                        COMP_CODE         : compCode
                    }
                    panelDetail.down('#sbs030ukrvs2_2Grid').createRow(r);
                } else if(activeTab.getId() == 'sbs030ukrvs3Tab') {
                	var param =  panelDetail.down('#sbs030ukrvs3Tab').getValues();

                	var remarkType    = param.REMARK_TYPE;
                    var compCode      = UserInfo.compCode;

                    var r = {
                        COMP_CODE         : compCode,
                        REMARK_TYPE       : remarkType
                    }
                    panelDetail.down('#sbs030ukrvs3Grid').createRow(r);
                } else if(activeTab.getId() == 'sbs030ukrvs4Tab') {
                    var param =  panelDetail.down('#sbs030ukrvs4Tab').getValues();

                    var compCode      = UserInfo.compCode;
                    var basisYyyymm   = param.BASIS_YYYYMM;
                    var divCode       = param.DIV_CODE;
                    var moneyUnit     = BsaCodeInfo.gsMoneyUnit;
                    var basisAmoO     = '0';
                    var createLoc     = '2';

                    var r = {
                        COMP_CODE         : compCode,
                        BASIS_YYYYMM      : basisYyyymm,
                        DIV_CODE          : divCode,
                        MONEY_UNIT        : moneyUnit,
                        BASIS_AMT_O       : basisAmoO,
                        CREATE_LOC        : createLoc
                    }
                    panelDetail.down('#sbs030ukrvs4Grid').createRow(r);
                } else if(activeTab.getId() == 'sbs030ukrvs8Tab') {
    //            	var grid1 = panelDetail.down('#sbs030ukrvs8_1Grid');
    //                var grid2 = panelDetail.down('#sbs030ukrvs8_2Grid');
                    if(selectedMasterGrid == 'sbs030ukrvs8_1Grid') {
                        var param =  panelDetail.down('#sbs030ukrvs8Tab').getValues();

                        //var remarkType    = param.REMARK_TYPE;
                        var compCode      = UserInfo.compCode;
                        var divCode       = param.DIV_CODE;
                        var r = {
                            COMP_CODE         : compCode,
                            DIV_CODE          : divCode
                        }
                        panelDetail.down('#sbs030ukrvs8_1Grid').createRow(r);
                	} else if(selectedMasterGrid == 'sbs030ukrvs8_2Grid'){
                	    var param =  panelDetail.down('#sbs030ukrvs8Tab').getValues();

                        var divCode       = param.DIV_CODE;
                        var setItem_code  = param.SET_ITEM_CODE_TEMP;
                        var constQ        = '1';
                        var basisSetQ     = constQ;
                        var soKind        = '10';
                        var useYn         = 'Y';
                        var constSeq   = sbs030ukrvs8_2Store.max('CONST_SEQ');
                        if(!constSeq) constSeq = 1;
                        else  constSeq += 1;

                        var r = {
                            DIV_CODE          : divCode,
                            SET_ITEM_CODE     : setItem_code,
                            CONST_Q           : constQ,
                            BASIS_SET_Q       : basisSetQ,
                            SO_KIND           : soKind,
                            USE_YN            : useYn,
                            CONST_SEQ         : constSeq
                        }
                        panelDetail.down('#sbs030ukrvs8_2Grid').createRow(r);
                	}
                }
//            }
        },
        onDeleteDataButtonDown : function() {
            var activeTab = panelDetail.down('#sbs030Tab').getActiveTab();
            if(activeTab.getId() == 'tab_sbs030ukrv0Tab'){
                var grid = panelDetail.down('#sbs030ukrv0_Grid2');
                var selRow = grid.getSelectionModel().getSelection()[0];

                if (selRow.phantom === true)    {
                    grid.deleteSelectedRow();
                } else {
                    Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
                        if (btn == 'yes') {
                            grid.deleteSelectedRow();
                        }
                    });
                }
            } else if(activeTab.getId() == 'tab_sbs030ukrv0_1Tab') {
                var grid = panelDetail.down('#sbs030ukrv0_Grid3');
                var selRow = grid.getSelectionModel().getSelection()[0];

                if (selRow.phantom === true)    {
                    grid.deleteSelectedRow();
                } else {
                    Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
                        if (btn == 'yes') {
                            grid.deleteSelectedRow();
                        }
                    });
                }
            } else if(activeTab.getId() == 'sbs030ukrvs2Tab') {
                var grid = panelDetail.down('#sbs030ukrvs2_2Grid');
                var selRow = grid.getSelectionModel().getSelection()[0];

                if (selRow.phantom === true)    {
                    grid.deleteSelectedRow();
                } else {
                    Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
                        if (btn == 'yes') {
                            grid.deleteSelectedRow();
                        }
                    });
                }
            } else if(activeTab.getId() == 'sbs030ukrvs3Tab') {
                var grid = panelDetail.down('#sbs030ukrvs3Grid');
                var selRow = grid.getSelectionModel().getSelection()[0];

                if (selRow.phantom === true)    {
                    grid.deleteSelectedRow();
                } else {
                    Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
                        if (btn == 'yes') {
                            grid.deleteSelectedRow();
                        }
                    });
                }
            } else if(activeTab.getId() == 'sbs030ukrvs4Tab') {
                var grid = panelDetail.down('#sbs030ukrvs4Grid');
                var selRow = grid.getSelectionModel().getSelection()[0];

                if (selRow.phantom === true)    {
                    grid.deleteSelectedRow();
                } else {
                    Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
                        if (btn == 'yes') {
                            grid.deleteSelectedRow();
                        }
                    });
                }
            } else if(activeTab.getId() == 'sbs030ukrvs8Tab') {
            	var grid1 = panelDetail.down('#sbs030ukrvs8_1Grid');
                var grid2 = panelDetail.down('#sbs030ukrvs8_2Grid');
                if(selectedMasterGrid == 'sbs030ukrvs8_1Grid') {
                    var selRow = grid1.getSelectionModel().getSelection()[0].data;

                    if (selRow.phantom === true)    {
                        grid1.deleteSelectedRow();
                    } else {
                        Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn) {
                            if (btn == 'yes') {
                            	if(sbs030ukrvs8_2Store.getCount() > 0 ) {
                                    Unilite.messageBox('<t:message code="system.message.sales.message136" default="구성품목 먼저 삭제후 저장하십시오."/>');
                                } else {
                                    grid1.deleteSelectedRow();
                                }
                            }
                        });
                    }
                } else {
                    var selRow = grid2.getSelectionModel().getSelection()[0].data;

                    if (selRow.phantom === true)    {
                        grid2.deleteSelectedRow();
                    } else {
                        Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
                            if (btn == 'yes') {
                                grid2.deleteSelectedRow();
                            }
                        });
                    }
                }
            }
        },
        onSaveDataButtonDown: function (config) {
            var activeTab = panelDetail.down('#sbs030Tab').getActiveTab();
            if (activeTab.getId() == 'tab_sbs030ukrv0Tab') {
                 activeTab.down('#sbs030ukrv0_Grid2').getStore().syncAll();
//                 pbs070ukrvs_5Store.loadStoreRecords();

            } else if (activeTab.getId() == 'tab_sbs030ukrv0_1Tab'){
                 activeTab.down('#sbs030ukrv0_Grid3').getStore().syncAll();
//                 pbs070ukrvs_5Store.loadStoreRecords();
            } else if (activeTab.getId() == 'sbs030ukrvs2Tab'){
                 activeTab.down('#sbs030ukrvs2_2Grid').getStore().syncAll();
//                 pbs070ukrvs_5Store.loadStoreRecords();
            } else if (activeTab.getId() == 'sbs030ukrvs3Tab'){
                 activeTab.down('#sbs030ukrvs3Grid').getStore().syncAll();
//                 pbs070ukrvs_5Store.loadStoreRecords();
            } else if (activeTab.getId() == 'sbs030ukrvs4Tab'){
                 activeTab.down('#sbs030ukrvs4Grid').getStore().saveStore();
//                 pbs070ukrvs_5Store.loadStoreRecords();
            } else if (activeTab.getId() == 'sbs030ukrvs8Tab'){
            	var grid1 = panelDetail.down('#sbs030ukrvs8_1Grid');
            	var grid2 = panelDetail.down('#sbs030ukrvs8_2Grid');
            	if(selectedMasterGrid == 'sbs030ukrvs8_1Grid') {
                    activeTab.down('#sbs030ukrvs8_1Grid').getStore().syncAll();
            	} else if(selectedMasterGrid == 'sbs030ukrvs8_2Grid') {
            	    activeTab.down('#sbs030ukrvs8_2Grid').getStore().syncAll();
            	}
//                 pbs070ukrvs_5Store.loadStoreRecords();
            }
        },
        loadTabData: function(tab, itemId){
            if (tab.getItemId() == 'tab_sbs030ukrv0Tab') {
                UniAppManager.setToolbarButtons(['newData', 'reset', 'excel' , 'save', 'delete'],false);
                UniAppManager.setToolbarButtons(['query'],true);
            } else if(tab.getItemId() == "tab_sbs030ukrv0_1Tab") {
                UniAppManager.setToolbarButtons(['newData', 'reset', 'excel' , 'save', 'delete'],false);
                UniAppManager.setToolbarButtons(['query'],true);

            } else if(tab.getItemId() == "sbs030ukrvs2Tab") {
                UniAppManager.setToolbarButtons(['newData', 'reset', 'excel' , 'save', 'delete'],false);
                UniAppManager.setToolbarButtons(['query'],true);

            } else if(tab.getItemId() == "sbs030ukrvs3Tab") {
                UniAppManager.setToolbarButtons(['newData', 'reset', 'excel' , 'save', 'delete'],false);
                UniAppManager.setToolbarButtons(['query'],true);
            } else if(tab.getItemId() == "sbs030ukrvs4Tab") {
                UniAppManager.setToolbarButtons(['newData', 'reset', 'excel' , 'save', 'delete'],false);
                UniAppManager.setToolbarButtons(['query'],true);
            } else if(tab.getItemId() == "sbs030ukrvs8Tab") {
                UniAppManager.setToolbarButtons(['newData', 'reset', 'excel' , 'save', 'delete'],false);
                UniAppManager.setToolbarButtons(['query'],true);
            }
        },
        checkForNewDetail1:function() {
            return panelDetail.down('#tab_sbs030ukrv0Tab').setAllFieldsReadOnly1(true);
        },
        checkForNewDetail2:function() {
            return panelDetail.down('#tab_sbs030ukrv0_1Tab').setAllFieldsReadOnly1_2(true);
        },
        checkForNewDetail3:function() {
            return panelDetail.down('#sbs030ukrvs2Tab').setAllFieldsReadOnly2(true);
        },
        checkForNewDetail4:function() {
            return panelDetail.down('#sbs030ukrvs3Tab').setAllFieldsReadOnly3(true);
        },
        checkForNewDetail5:function() {
            return panelDetail.down('#sbs030ukrvs4Tab').setAllFieldsReadOnly4(true);
        },
        checkForNewDetail6:function() {
            return panelDetail.down('#sbs030ukrvs8Tab').setAllFieldsReadOnly8(true);
        }
    });

     Unilite.createValidator('validator01', {
 		store: sbs030ukrvs0_2Store,
 		grid: panelDetail.down('#sbs030ukrv0_Grid2'),
 		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
 			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
 			var rv = true;
 			switch(fieldName) {
 				case "APLY_START_DATE" : // 창고코드
 					if(newValue)	{
 	            	 	record.set('APLY_START_DATE',newValue);
 	            	 }
 				break;
 			}
 			return rv;
 		}
 	}); // validator

 	Unilite.createValidator('validator02', {
 		store: sbs030ukrvs0_3Store,
 		grid: panelDetail.down('#sbs030ukrv0_Grid3'),
 		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
 			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
 			var rv = true;
 			switch(fieldName) {
 				case "APLY_START_DATE" : // 창고코드
 					if(newValue)	{
 	            	 	record.set('APLY_START_DATE',newValue);
 	            	 }
 				break;

 			}
 			return rv;
 		}
 	}); // validator

};

</script>
