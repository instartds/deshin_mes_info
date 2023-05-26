<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
    String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
    request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>

<t:appConfig pgmId="pbs070ukrv"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_sbx900ukrv_kd"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B018" />
    <t:ExtComboStore comboType="AU" comboCode="B010" />
    <t:ExtComboStore comboType="AU" comboCode="B013" />         <!-- 단위 -->
    <t:ExtComboStore comboType="AU" comboCode="B062" />         <!-- 카렌더타입 -->
    <t:ExtComboStore comboType="AU" comboCode="B011" />         <!-- 휴무구분 -->
    <t:ExtComboStore comboType="BOR120" pgmId="pbs070ukrvs"/>  <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B020"/>             <!-- 계정구분 -->
    <t:ExtComboStore comboType="AU" comboCode="B014"/>             <!-- 조달구분 -->
    <t:ExtComboStore comboType="AU" comboCode="P102"/> 				<!-- 적용여부 -->  
    <t:ExtComboStore comboType="WU" />  <!-- 작업장 -->
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />



</t:appConfig>
<link rel="stylesheet" type="text/css" href='<c:url value="/${ext_root}/app/Ext/ux/css/GroupTabPanel.css" />' />
<script type="text/javascript" >

function appMain() {
	var gsSiteCode = '${gsSiteCode}'
	var gsSiteFlag = false;
	if(gsSiteCode == 'INNO'){
		gsSiteFlag = true;
	}

    /* 생산휴일등록 */
    var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
            api: {
                read    : 'pbs070ukrvsService.selectList1',
                create  : 'pbs070ukrvsService.insertDetail1',
                update  : 'pbs070ukrvsService.updateDetail1',
                destroy : 'pbs070ukrvsService.deleteDetail1',
                syncAll : 'pbs070ukrvsService.saveAll1'
            }
     });

    Unilite.defineModel('pbs070ukrvs_1Model', {
        fields: [
                    {name: 'HOLY_MONTH'                 ,text:'휴일월'     ,type : 'string' , allowBlank: false, maxLength: 2},
                    {name: 'HOLY_DAY'                   ,text:'휴일일'     ,type : 'string' , allowBlank: false, maxLength: 2},
                    {name: 'REMARK'                     ,text:'사유'          ,type : 'string'},
                    {name: 'UPDATE_DB_USER'             ,text:'작성자'     ,type : 'string'},
                    {name: 'UPDATE_DB_TIME'             ,text:'작성시간'        ,type : 'string'},
                    {name: 'COMP_CODE'                  ,text:'<t:message code="system.label.product.compcode" default="법인코드"/>'        ,type : 'string'}

            ]
    });



    var pbs070ukrvs_1Store = Unilite.createStore('pbs070ukrvs_1Store',{
            model: 'pbs070ukrvs_1Model',
            autoLoad: false,
            uniOpt : {
                isMaster: true,         // 상위 버튼 연결
                editable: true,         // 수정 모드 사용
                deletable:true,         // 삭제 가능 여부
                useNavi : false         // prev | next 버튼 사용
            },
            proxy: directProxy1,

            loadStoreRecords : function(){
                this.load();
            }
        });
    /* 생산휴일등록 end */


    /* 카렌더정보생성 */
    var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
            api: {
                read    : 'pbs070ukrvsService.selectList2',
                create  : 'pbs070ukrvsService.insertDetail2',
                update  : 'pbs070ukrvsService.updateDetail2',
                //destroy   : 'pbs070ukrvsService.deleteDetail2',
                syncAll : 'pbs070ukrvsService.saveAll2'
            }
     });


    Unilite.defineModel('pbs070ukrvs_2Model', {
        fields: [
                    {name: 'HOLY_MONTH'                 ,text:'월'       ,type : 'string' , allowBlank: false, maxLength: 2},
                    {name: 'HOLY_DAY'                   ,text:'일'       ,type : 'string' , allowBlank: false, maxLength: 2},

                    {name: 'HOLY_MONTH_RENDER'          ,text:'월'       ,type : 'string' , allowBlank: false, maxLength: 2},
                    {name: 'HOLY_DAY_RENDER'            ,text:'일'       ,type : 'string' , allowBlank: false, maxLength: 2},

                    {name: 'REMARK'                     ,text:'사유'          ,type : 'string'},
                    {name: 'UPDATE_DB_USER'             ,text:'작성자'     ,type : 'string'},
                    {name: 'UPDATE_DB_TIME'             ,text:'작성시간'        ,type : 'string'},
                    {name: 'COMP_CODE'                  ,text:'<t:message code="system.label.product.compcode" default="법인코드"/>'        ,type : 'string'}

            ]
    });

    var pbs070ukrvs_2Store = Unilite.createStore('pbs070ukrvs_2Store',{
            model: 'pbs070ukrvs_2Model',
            autoLoad: false,
            uniOpt : {
                isMaster: true,         // 상위 버튼 연결
                editable: false,        // 수정 모드 사용
                deletable:false,        // 삭제 가능 여부
                useNavi : false         // prev | next 버튼 사용
            },
           proxy : directProxy2,
            saveStore : function()  {
                var inValidRecs = this.getInvalidRecords();

                var rv = true;

                if(inValidRecs.length == 0 )    {
                    this.syncAllDirect();
                }else {
                     panelDetail.down('#pbs070ukrvs_2Grid').uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            },
            loadStoreRecords : function(){
                this.load();
            }
        });
    /* 카렌더정보생성 end */


    /* 카렌더정보수정 */
    var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
            api: {
                read    : 'pbs070ukrvsService.selectList3',
                create  : 'pbs070ukrvsService.insertDetail3',
                update  : 'pbs070ukrvsService.updateDetail23',
                //destroy   : 'pbs070ukrvsService.deleteDetail2',
                syncAll : 'pbs070ukrvsService.saveAll3'
            }
     });


    Unilite.defineModel('pbs070ukrvs_3Model', {
        fields: [
                    {name: 'CAL_NO'                 ,text:'기간NO'        ,type : 'string'},
                    {name: 'START_DATE'             ,text:'기간시작일'       ,type : 'uniDate'},
                    {name: 'END_DATE'               ,text:'기간종료일'       ,type : 'uniDate'},
                    {name: 'WORK_DAY'               ,text:'가동일수'        ,type : 'string'}

            ]
    });

    var pbs070ukrvs_3Store = Unilite.createStore('pbs070ukrvs_3Store',{
            model: 'pbs070ukrvs_3Model',
            autoLoad: false,
            uniOpt : {
                isMaster: true,         // 상위 버튼 연결
                editable: false,        // 수정 모드 사용
                deletable:false,        // 삭제 가능 여부
                useNavi : false         // prev | next 버튼 사용
            },
           proxy : directProxy3,
            saveStore : function()  {
                var inValidRecs = this.getInvalidRecords();

                var rv = true;

                if(inValidRecs.length == 0 )    {
                    this.syncAllDirect();
                }else {
                     panelDetail.down('#pbs070ukrvs_3Grid').uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            },
            loadStoreRecords : function(){
                var param =  panelDetail.down('#tab_Cal_Revise').getValues();
                 this.load({
                    params: param
                 });
             }
        });
    /* 카렌더정보수정 end */

    /* 카렌더정보조회 */
    var directProxy4 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
            api: {
                read    : 'pbs070ukrvsService.selectList4'
            }
     });


    Unilite.defineModel('pbs070ukrvs_4Model', {
        fields: [
                    {name: 'CAL_NO'                 ,text:'기간NO'        ,type : 'string'},
                    {name: 'START_DATE'             ,text:'기간시작일'       ,type : 'uniDate'},
                    {name: 'END_DATE'               ,text:'기간종료일'       ,type : 'uniDate'},
                    {name: 'WORK_DAY'               ,text:'가동일수'        ,type : 'string'}

            ]
    });

    var pbs070ukrvs_4Store = Unilite.createStore('pbs070ukrvs_4Store',{
            model: 'pbs070ukrvs_4Model',
            autoLoad: false,
            uniOpt : {
                isMaster: true,         // 상위 버튼 연결
                editable: false,        // 수정 모드 사용
                deletable:false,        // 삭제 가능 여부
                useNavi : false         // prev | next 버튼 사용
            },
           proxy : directProxy4,
            saveStore : function()  {
                var inValidRecs = this.getInvalidRecords();

                var rv = true;

                if(inValidRecs.length == 0 )    {
                    this.syncAllDirect();
                }else {
                     panelDetail.down('#pbs070ukrvs_4Grid').uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            },
            loadStoreRecords : function(){
                var param =  panelDetail.down('#tab_Cal_Search').getValues();
                 this.load({
                    params: param
                 });
             }
        });


    //  공정등록

    /* 공정등록 */
    var directProxy5 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
            api: {
                read    : 'pbs070ukrvsService.selectList5',
                create  : 'pbs070ukrvsService.insertDetail5',
                update  : 'pbs070ukrvsService.updateDetail5',
                destroy : 'pbs070ukrvsService.deleteDetail5',
                syncAll : 'pbs070ukrvsService.saveAll5'
            }
     });
//     /* 공정/설비등록 */
//    var directProxy5_2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
//            api: {
//                read    : 'pbs070ukrvsService.selectList5_2',
//                create  : 'pbs070ukrvsService.insertDetail5_2',
//                update  : 'pbs070ukrvsService.updateDetail5_2',
//                destroy : 'pbs070ukrvsService.deleteDetail5_2',
//                syncAll : 'pbs070ukrvsService.saveAll5_2'
//            }
//     });
//     /* 공정/금형등록 */
//    var directProxy5_3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
//            api: {
//                read    : 'pbs070ukrvsService.selectList5_3',
//                create  : 'pbs070ukrvsService.insertDetail5_3',
//                update  : 'pbs070ukrvsService.updateDetail5_3',
//                destroy : 'pbs070ukrvsService.deleteDetail5_3',
//                syncAll : 'pbs070ukrvsService.saveAll5_3'
//            }
//     });

    // 공정등록 모델
    Unilite.defineModel('pbs070ukrvs_5Model', {
        fields: [
                {name: 'DIV_CODE'                   ,text:'<t:message code="system.label.product.division" default="사업장"/>'             ,type : 'string', comboType:'BOR120'},
                {name: 'WORK_SHOP_CODE'             ,text:'<t:message code="system.label.product.workcenter" default="작업장"/>'             ,type : 'string', allowBlank: false},
                {name: 'WORK_SHOP_NAME'             ,text:'<t:message code="system.label.product.workcentername" default="작업장명"/>'            ,type : 'string',allowBlank:false},
                {name: 'PROG_WORK_CODE'             ,text:'<t:message code="system.label.product.routingcode" default="공정코드"/>'            ,type : 'string', allowBlank: false},
                {name: 'PROG_WORK_NAME'             ,text:'<t:message code="system.label.product.routingname" default="공정명"/>'             ,type : 'string', allowBlank: false},
                {name: 'STD_TIME'                   ,text:'<t:message code="system.label.product.routingstandardtime" default="공정표준시간"/>'      ,type : 'int', allowBlank: false},
                {name: 'PROG_UNIT'                  ,text:'<t:message code="system.label.product.routingunit" default="공정단위"/>'            ,type : 'string', comboType: 'AU', comboCode: 'B013'},
                {name: 'PROG_UNIT_COST'             ,text:'단위당원가'           ,type : 'uniPrice'},
                {name: 'USE_YN'                     ,text:'사용유무'            ,type : 'string', comboType: 'AU', comboCode: 'B010'},
                {name: 'UPDATE_DB_USER'             ,text:'<t:message code="system.label.product.updateuser" default="수정자"/>'             ,type : 'string'},
                {name: 'UPDATE_DB_TIME'             ,text:'<t:message code="system.label.product.updatedate" default="수정일"/>'             ,type : 'uniDate'},
                {name: 'EXIST'                      ,text:'공정수순등록여부'    ,type : 'string'},
                {name: 'COMP_CODE'                  ,text:'<t:message code="system.label.product.compcode" default="법인코드"/>'            ,type : 'string'},
                {name: 'REMARK'                  ,text:'<t:message code="system.label.product.remarks" default="비고"/>'            ,type : 'string'},
                {name: 'MAN_Q'               ,text:'<t:message code="system.label.product.system.label.product.standardmanpowerqty" default="표준인력"/>'         ,type : 'int'},
                {name: 'CAPA_Q'               ,text:'Capa/Hr'         ,type : 'int'},
                {name: 'BATCH_Q'               ,text:'<t:message code="system.label.product.batchqty" default="Batch량"/>'         ,type : 'int'},
                {name: 'EQU_CODE'                  ,text:'<t:message code="system.label.product.facilities" default="설비코드"/>'            ,type : 'string'},
                {name: 'EQU_NAME'                  ,text:'<t:message code="system.label.product.facilitiesname" default="설비명"/>'            ,type : 'string'},
                {name: 'LAST_YN'                   ,text:'최종공정'            ,type : 'string', comboType: 'AU', comboCode: 'B131'},
				{name: 'TEMPC_01'                  ,text:'<t:message code="system.label.product.qtycountgubun" default="진행수량집계구분"/>'            ,type : 'string', comboType: 'AU', comboCode: 'P522'},
				{name: 'WKORD_YN'                  ,text:'작업지시적용'            ,type : 'string', comboType: 'AU', comboCode: 'P102'}
        ]
    });
//    // 공정/설비등록 모델
//    Unilite.defineModel('pbs070ukrvs_5_2Model', {
//        fields: [
//            {name: 'COMP_CODE'             ,text:'법인'         ,type : 'string'},
//            {name: 'DIV_CODE'              ,text:'<t:message code="system.label.product.division" default="사업장"/>'       ,type : 'string', comboType:'BOR120'},
//            {name: 'WORK_SHOP_CODE'        ,text:'<t:message code="system.label.product.workcenter" default="작업장"/>'       ,type : 'string'},
//            {name: 'PROG_WORK_CODE'        ,text:'<t:message code="system.label.product.routingcode" default="공정코드"/>'     ,type : 'string'},
//            {name: 'EQUIP_CODE'            ,text:'설비코드'     ,type : 'string', allowBlank: false},
//            {name: 'EQUIP_NAME'            ,text:'설비명'       ,type : 'string', allowBlank: false},
//            {name: 'SELECT_BASIS'          ,text:'기본'         ,type : 'string'},
//            {name: 'REMARK '               ,text:'<t:message code="system.label.product.remarks" default="비고"/>'         ,type : 'string'}
//        ]
//    });
//    // 공정/금형등록 모델
//    Unilite.defineModel('pbs070ukrvs_5_3Model', {
//        fields: [
//            {name: 'COMP_CODE'             ,text:'법인'         ,type : 'string'},
//            {name: 'DIV_CODE'              ,text:'<t:message code="system.label.product.division" default="사업장"/>'       ,type : 'string', comboType:'BOR120'},
//            {name: 'WORK_SHOP_CODE'        ,text:'<t:message code="system.label.product.workcenter" default="작업장"/>'       ,type : 'string'},
//            {name: 'PROG_WORK_CODE'        ,text:'<t:message code="system.label.product.routingcode" default="공정코드"/>'     ,type : 'string'},
//            {name: 'MOLD_CODE'             ,text:'금형코드'     ,type : 'string', allowBlank: false},
//            {name: 'MOLD_NAME'             ,text:'금형명'       ,type : 'string', allowBlank: false},
//            {name: 'SELECT_BASIS'          ,text:'기본'         ,type : 'string'},
//            {name: 'REMARK '               ,text:'<t:message code="system.label.product.remarks" default="비고"/>'         ,type : 'string'}
//        ]
//    });

    // 공정등록 스토어
    var pbs070ukrvs_5Store = Unilite.createStore('pbs070ukrvs_5Store',{
            model: 'pbs070ukrvs_5Model',
            autoLoad: false,
            uniOpt : {
                isMaster: true,         // 상위 버튼 연결
                editable: true,         // 수정 모드 사용
                deletable:true,         // 삭제 가능 여부
                useNavi : false         // prev | next 버튼 사용
            },
            proxy : directProxy5,
            saveStore : function()  {
                var inValidRecs = this.getInvalidRecords();
                var rv = true;

                if(inValidRecs.length == 0 )    {

                    this.syncAllDirect();
                } else {
                     panelDetail.down('#pbs070ukrvs_5Grid').uniSelectInvalidColumnAndAlert(inValidRecs);

                }
            },
            loadStoreRecords : function(){
                var param =  panelDetail.down('#tab_pbs070ukrvs5Tab').getValues();
                this.load({
                    params: param
                });
             }
    });
//    // 공정/설비등록 스토어
//    var pbs070ukrvs_5_2Store = Unilite.createStore('pbs070ukrvs_5_2Store',{
//            model: 'pbs070ukrvs_5_2Model',
//            autoLoad: false,
//            uniOpt : {
//                isMaster: true,         // 상위 버튼 연결
//                editable: true,         // 수정 모드 사용
//                deletable:true,         // 삭제 가능 여부
//                useNavi : false         // prev | next 버튼 사용
//            },
//            proxy : directProxy5_2,
//            saveStore : function()  {
//                var inValidRecs = this.getInvalidRecords();
//
//                var rv = true;
//
//                if(inValidRecs.length == 0 )    {
//                    this.syncAllDirect();
//                } else {
//                     panelDetail.down('#pbs070ukrvs_5_2Grid').uniSelectInvalidColumnAndAlert(inValidRecs);
//                }
//            },
//            loadStoreRecords : function(param){
//                this.load({
//                    params: param
//                });
//             }
//    });
//    // 공정/금형등록 스토어
//    var pbs070ukrvs_5_3Store = Unilite.createStore('pbs070ukrvs_5_3Store',{
//            model: 'pbs070ukrvs_5_3Model',
//            autoLoad: false,
//            uniOpt : {
//                isMaster: true,         // 상위 버튼 연결
//                editable: true,         // 수정 모드 사용
//                deletable:true,         // 삭제 가능 여부
//                useNavi : false         // prev | next 버튼 사용
//            },
//            proxy : directProxy5_3,
//            saveStore : function()  {
//                var inValidRecs = this.getInvalidRecords();
//
//                var rv = true;
//
//                if(inValidRecs.length == 0 )    {
//                    this.syncAllDirect();
//                } else {
//                     panelDetail.down('#pbs070ukrvs_5_3Grid').uniSelectInvalidColumnAndAlert(inValidRecs);
//                }
//            },
//            loadStoreRecords : function(param){
//                this.load({
//                    params: param
//                });
//             }
//    });


    /////////////////////////////////////////////////////   공정수순등록   //////////////////////////////////////////////////

    /* 공정수순등록 */
    var directProxy6 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
            api: {
                read    : 'pbs070ukrvsService.selectList6',
                create  : 'pbs070ukrvsService.insertDetail6_2',
                update  : 'pbs070ukrvsService.updateDetail6_2',
                destroy : 'pbs070ukrvsService.deleteDetail6_2',
                syncAll : 'pbs070ukrvsService.saveAll6_2'
            }
     });

     var directProxy6_2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
            api: {
                read    : 'pbs070ukrvsService.selectList6_2',
                create  : 'pbs070ukrvsService.insertDetail6_2',
                update  : 'pbs070ukrvsService.updateDetail6_2',
                destroy : 'pbs070ukrvsService.deleteDetail6_2',
                syncAll : 'pbs070ukrvsService.saveAll6_2'
            }
     });

        // 공정수순등록 모델
    Unilite.defineModel('pbs070ukrvs_6Model_1', {
        fields: [
                    {name: 'ITEM_CODE'              ,text:'<t:message code="system.label.product.item" default="품목"/>'            ,type : 'string'},
                    {name: 'ITEM_NAME'              ,text:'<t:message code="system.label.product.itemname" default="품목명"/>'              ,type : 'string'},
                    {name: 'SPEC'                   ,text:'<t:message code="system.label.product.spec" default="규격"/>'              ,type : 'string'},
                    {name: 'STOCK_UNIT'             ,text:'<t:message code="system.label.product.unit" default="단위"/>'              ,type : 'string'},
                    {name: 'ITEM_ACCOUNT'           ,text:'계정코드'            ,type : 'string'},
                    {name: 'ITEMACCOUNT_NAME'       ,text:'<t:message code="system.label.product.itemaccount" default="품목계정"/>'            ,type : 'string'/*, comboType:'AU', comboCode:'B020'*/},
                    {name: 'SUPPLY_TYPE'            ,text:'<t:message code="system.label.product.procurementclassification" default="조달구분"/>'            ,type : 'string', comboType:'AU', comboCode:'B014'},
                    {name: 'PROG_CNT'               ,text:'등록수'         ,type : 'uniQty'},
                    {name: 'ITEMLEVEL1_NAME'        ,text:'<t:message code="system.label.product.majorgroup" default="대분류"/>'         ,type : 'string'},
                    {name: 'ITEMLEVEL2_NAME'        ,text:'<t:message code="system.label.product.middlegroup" default="중분류"/>'         ,type : 'string'},
                    {name: 'ITEMLEVEL3_NAME'        ,text:'<t:message code="system.label.product.minorgroup" default="소분류"/>'         ,type : 'string'}



            ]
    });

            // 공정수순등록 모델2
    Unilite.defineModel('pbs070ukrvs_6Model_2', {
        fields: [
                    {name: 'SORT_FLD'                   ,text:'<t:message code="system.label.product.division" default="사업장"/>'             ,type : 'string'},
                    {name: 'DIV_CODE'                   ,text:'<t:message code="system.label.product.division" default="사업장"/>'             ,type : 'string'},
                    {name: 'ITEM_CODE'                  ,text:'<t:message code="system.label.product.item" default="품목"/>'                ,type : 'string'},
                    {name: 'WORK_SHOP_CODE'             ,text:'<t:message code="system.label.product.workcenter" default="작업장"/>'             ,type : 'string'},
                    {name: 'PROG_WORK_CODE'             ,text:'<t:message code="system.label.product.routingcode" default="공정코드"/>'                ,type : 'string'},
                    {name: 'PROG_WORK_NAME'             ,text:'<t:message code="system.label.product.routingname" default="공정명"/>'             ,type : 'string'},
                    {name: 'LINE_SEQ'                   ,text:'<t:message code="system.label.product.routingorder" default="공정순서"/>'                ,type : 'int'},
                    {name: 'MAKE_LDTIME'                ,text:'<t:message code="system.label.product.routingstandardtime" default="표준공수"/>'          ,type : 'int'},
                    {name: 'PROG_RATE'                  ,text:'<t:message code="system.label.product.routingprocessrate" default="공정진척율(%)"/>'               ,type : 'int'},
                    {name: 'PROG_UNIT_Q'                ,text:'<t:message code="system.label.product.routingunitqty" default="공정원단위량"/>'          ,type: 'float' ,decimalPrecision:6, format:'0,000.000000', allowBlank: false},
                    {name: 'PROG_UNIT'                  ,text:'<t:message code="system.label.product.routingunit" default="공정단위"/>'                ,type : 'string'}
            ]
    });

        // 공정수순등록 스토어
    var pbs070ukrvs_6Store = Unilite.createStore('pbs070ukrvs_6Store',{
            model: 'pbs070ukrvs_6Model_1',
            autoLoad: false,
            uniOpt : {
                isMaster: true,         // 상위 버튼 연결
                editable: true,         // 수정 모드 사용
                deletable:false,            // 삭제 가능 여부
                allDeletable: true,     //전체삭제 가능 여부
                useNavi : false         // prev | next 버튼 사용
            },
            proxy : directProxy6,
            saveStore : function()  {
                var inValidRecs = this.getInvalidRecords();

                var rv = true;

                if(inValidRecs.length == 0 )    {
                    this.syncAllDirect();
                } else {
                     panelDetail.down('#pbs070ukrvs_6Grid').uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            },
            loadStoreRecords : function(){
                var param =  panelDetail.down('#tab_pbs070ukrvs6Tab').getValues();
                this.load({
                    params: param
                });
             }
        });

    var pbs070ukrvs_6Store2 = Unilite.createStore('pbs070ukrvs_6Store2',{
            model: 'pbs070ukrvs_6Model_2',
            autoLoad: false,
            uniOpt : {
                isMaster: true,         // 상위 버튼 연결
                editable: true,         // 수정 모드 사용
                deletable:true,         // 삭제 가능 여부
                allDeletable: true,     //전체삭제 가능 여부
                useNavi : false         // prev | next 버튼 사용
            },
            proxy : directProxy6_2,
            saveStore : function()  {
                var inValidRecs = this.getInvalidRecords();
				var toCreate = this.getNewRecords();
				var toUpdate = this.getUpdatedRecords();
				var toDelete = this.getRemovedRecords();
				var list = [].concat(toUpdate, toCreate);

				Ext.each(list, function(record, i) {
					record.set('ITEM_CODE', record.get('ITEM_CODE').split(','));
				});
				var rv = true;

				//저장 전 체크로직
				var progRate= 0;
				var list = pbs070ukrvs_6Store2.data.items;
				Ext.each(list, function(record, index) {// PROG_RATE
					progRate = progRate + record.get('PROG_RATE');
					if(record.get('LINE_SEQ') == 0&&record.get('MAKE_LDTIME') == 0&&record.get('PROG_UNIT_Q') == 0) {
						alert('<t:message code="system.label.product.routingorder" default="공정순서"/>:'
							+ '<t:message code="system.message.product.datacheck009" default="0보다 큰 값이 입력되어야 합니다."/>');
						rv = false;
						return false;
					}
					/* if(record.get('MAKE_LDTIME') == 0) {
						alert('<t:message code="system.label.product.routingstandardtime" default="공정표준시간"/>:'
							+ '<t:message code="system.message.product.datacheck009" default="0보다 큰 값이 입력되어야 합니다."/>');
						rv = false;
						return false;
					}
					if(record.get('PROG_UNIT_Q') == 0) {
						alert('<t:message code="system.label.product.routingunitqty" default="공정원단위량"/>:'
							+ '<t:message code="system.message.product.datacheck009" default="0보다 큰 값이 입력되어야 합니다."/>');
						rv = false;
						return false;
					} */
				});
				if (!Ext.isEmpty(progRate)) {
    					if(rv && progRate > 0 && progRate < 100){
    						alert('<t:message code="system.message.product.datacheck003" default="공정진척율의 합계는 100 이어야  합니다."/>');
    						rv = false;
    						return false;
    					}
					}
				if(!rv) {
					return false;
				}

                if( rv && inValidRecs.length == 0 )    {
	                config = {
	                    success : function(batch, option) {
	                        UniAppManager.app.onQueryButtonDown();
	                     },
	                     failure: function(batch, option) {
	                     	
	                     }
	                };
                    this.syncAllDirect(config);
                } else {
                     panelDetail.down('#pbs070ukrvs_6Grid2').uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            },
            loadStoreRecords : function(){
                var param =  panelDetail.down('#tab_pbs070ukrvs6Tab').getValues();
                if(!Ext.isEmpty(param.ITEM_CODE1)){
                    this.load({
                        params: param
                });
             }
            }
        });

//


    /* 카렌더정보조회 end*/

	// 생산계획등록
	<%@include file="./pbs070ukrvs1.jsp" %>

	// 카렌더정보생성
	<%@include file="./pbs070ukrvs2.jsp" %>

	// 카렌더정보수정
	<%@include file="./pbs070ukrvs3.jsp" %>

	// 카렌더정보조회
	<%@include file="./pbs070ukrvs4.jsp" %>

    // 공정등록
    <%@include file="./pbs070ukrvs5.jsp" %>

    // 공정수순등록
    <%@include file="./pbs070ukrvs6.jsp" %>


    var panelDetail = Ext.create('Ext.panel.Panel', {
        layout : 'fit',
        region : 'center',
        disabled:false,
        items : [{
            xtype: 'uniGroupTabPanel',
            itemId: 'pbs070Tab',
            id:'pbs070Tab',
            cls:'human-panel',
            activeGroup: 0,
            collapsible:true,
            items: [
				// 생산계획등록
	    		prodt_Holy,

	    		// 카렌더정보생성
	    		prodt_Calender_Info,

	    		// 카렌더정보수정
	    		prodt_Calender_Revise,

	    		// 카렌더정보조회
	    		prodt_Calender_Search,

//              // 공정등록
                process_register,
//
//              // 공정수순등록
                process_count_register

            ],
            listeners:{
                beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts )    {
                    if(Ext.isObject(oldCard))   {
                         if(UniAppManager.app._needSave())  {
                            if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {
                                UniAppManager.app.onSaveDataButtonDown();
                                this.setActiveTab(oldCard);
                            }else {
                                //oldCard.getStore().rejectChanges();
                                UniAppManager.app.fnInitBinding();
//                                UniAppManager.app.loadTabData(newCard, newCard.getItemId());

                            }
                         }
                   /*    //카렌더정보 수정은 메인 버튼 모두 비활성화 처리한다.
                       if(oldCard.getItemId() == "tab_Cal_Info" || oldCard.getItemId() == "tab_Cal_Revise" || oldCard.getItemId() == "tab_Cal_Search"){
                           UniAppManager.app.fnInitBinding();
                            UniAppManager.setToolbarButtons(['reset', 'excel', 'delete'],false);
//                            UniAppManager.app.loadTabData(newCard, newCard.getItemId());
                       }*/
                    }
           /*         if(Ext.isObject(newCard)) {
                        //this.setActiveTab(newCard);
                        //var activeTab = panelDetail.down('#pbs070Tab').getActiveTab();
                        //카렌더정보 수정은 메인 버튼 모두 비활성화 처리한다.
                        if(newCard.getItemId() == "tab_Cal_Revise"){
                            UniAppManager.setToolbarButtons(['query', 'reset', 'excel', 'delete', 'save', 'newData'],false);
                        }
                    }*/
                },
				tabChange : function ( tabPanel, newCard, oldCard, eOpts )  {
//					var activeTabId = panelDetail.down('#pbs070Tab').getActiveTab().getId();
					if(newCard.getItemId() == 'tab_holy' || newCard.getItemId() == 'tab_pbs070ukrvs5Tab') {
                        UniAppManager.setToolbarButtons(['query', 'newData', 'delete'],true);
					}else{
                        UniAppManager.setToolbarButtons(['query'],true);
                        UniAppManager.setToolbarButtons(['newData', 'delete'],false);
					}
					
				}
            }
        }]
    })
      Unilite.createValidator('validator01', {
        store: pbs070ukrvs_6Store2,
        grid: panelDetail.down('#pbs070ukrvs_6Grid2'),
        validate: function( type, fieldName, newValue, oldValue, record, eopt) {
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;
            switch(fieldName) {
                case "PROG_RATE" : // 공정진척율
                    if(!Ext.isEmpty(newValue) ) {
                        var records =  pbs070ukrvs_6Store2.data.items;
                        var sum = 0;
                           Ext.each(records, function(record,i) {
                           	   sum += record.get('PROG_RATE');

                           })
                           sum = sum - (oldValue) + newValue;
                         if( sum > 100){
                               rv = '<t:message code="system.message.product.datacheck003" default="공정진척율의 합계는 100 이어야  합니다."/>';
                               record.set('PROG_RATE', oldValue);
                         }
                        break;
                    }
                    break;
                    
                case "LINE_SEQ" : // 공정진척율
                    if(!Ext.isEmpty(newValue) ) {
                        var records =  pbs070ukrvs_6Store2.data.items;
                               //record.set('MAKE_LDTIME', '8');
                               record.set('PROG_UNIT_Q', '1');
                               //alert('공정진척율의 합계는 100으로 입력해 주세요.');
                        break;
                    }
                    break;
                
            }
            return rv;
        }
    }); // validator
    var selectedMasterGrid = panelDetail.down('#pbs070ukrvs_1Grid');

     Unilite.Main( {
        borderItems:[
            panelDetail
        ],
        id : 'pbs070ukrvApp',
        fnInitBinding : function() {

//            UniAppManager.setToolbarButtons(['reset', 'excel', 'delete', 'deleteAll'],false);
//            UniAppManager.setToolbarButtons(['query'],true);
            var activeTab = panelDetail.down('#pbs070Tab').getActiveTab();
            if(activeTab.getId() == 'tab_holyTab'){
                pbs070ukrvs_1Store.loadStoreRecords();
	            UniAppManager.setToolbarButtons(['query','newData','delete'],true);
            }else if(activeTab.getId() == 'tab_pbs070ukrvs5Tab'){
	            UniAppManager.setToolbarButtons(['query','newData','delete'],true);
            }else{
	            UniAppManager.setToolbarButtons(['reset','newData', 'delete', 'deleteAll'],false);
	            UniAppManager.setToolbarButtons(['query'],true);
            }
            //UniAppManager.app.onQueryButtonDown();
        },checkForNewDetail:function() {
            return panelDetail.down('#tab_Cal_Search').setAllFieldsReadOnly(true);
        },checkForNewDetail5:function() {
            return panelDetail.down('#tab_pbs070ukrvs5Tab').setAllFieldsReadOnly5(true);
        },checkForNewDetail6:function() {
            return panelDetail.down('#tab_pbs070ukrvs6Tab').setAllFieldsReadOnly6(true);
        },
        checkForNewDetail2:function() {
            return panelDetail.down('#tab_Cal_Info').setAllFieldsReadOnly(true);
        },
        onQueryButtonDown : function()  {
            var activeTab = panelDetail.down('#pbs070Tab').getActiveTab();
            /*this.loadTabData(activeTab, activeTab.getItemId(), activeTab.getSubCode())*/
            if(activeTab.getId() == 'tab_holyTab'){
                pbs070ukrvs_1Store.loadStoreRecords();
            }else if(activeTab.getItemId() == "tab_Cal_Info"){
                pbs070ukrvs_2Store.loadStoreRecords();
            }else if(activeTab.getItemId() == "tab_Cal_Search"){
                if(!UniAppManager.app.checkForNewDetail()){
                    return false;
                }else{
                    pbs070ukrvs_4Store.loadStoreRecords();
                }
            }else if(activeTab.getItemId() == "tab_pbs070ukrvs5Tab"){
                if(!UniAppManager.app.checkForNewDetail5()) {
                    return false;
                } else {
                    pbs070ukrvs_5Store.loadStoreRecords();
                    UniAppManager.setToolbarButtons(['reset', 'newData'],true);
                }
            }else if(activeTab.getItemId() == "tab_pbs070ukrvs6Tab" ){
                if(!UniAppManager.app.checkForNewDetail6()) {
                    return false;
                } else {
                    pbs070ukrvs_6Store.loadStoreRecords();
                    pbs070ukrvs_6Store2.loadStoreRecords();
                    UniAppManager.setToolbarButtons(['reset'],true);
                    UniAppManager.setToolbarButtons(['newData'],false);
                    UniAppManager.setToolbarButtons(['delete'],false);
                }
            }

        },
        onResetButtonDown: function() {     // 초기화
            var activeTab = panelDetail.down('#pbs070Tab').getActiveTab();
            if(activeTab.getItemId() == "tab_holy"){
                pbs070ukrvs_1Store.clearData();
                panelDetail.down('#pbs070ukrvs_1Grid').reset();
            }else if(activeTab.getItemId() == "tab_pbs070ukrvs5Tab"){
                UniAppManager.setToolbarButtons(['reset'],false);
                pbs070ukrvs_5Store.clearData();
                panelDetail.down('#pbs070ukrvs_5Grid').reset();
//                pbs070ukrvs_5_2Store.clearData();
//                panelDetail.down('#pbs070ukrvs_5_2Grid').reset();
//                pbs070ukrvs_5_3Store.clearData();
//                panelDetail.down('#pbs070ukrvs_5_3Grid').reset();
                //panelDetail.clearForm();
                //panelDetail.down('#tab_pbs070ukrvs5Tab').clearForm();
            }else if(activeTab.getItemId() == "tab_pbs070ukrvs6Tab"){
                UniAppManager.setToolbarButtons(['reset'],false);

                panelDetail.down('#tab_pbs070ukrvs6Tab').reset();
                panelDetail.down('#pbs070ukrvs_6Grid').reset();
                panelDetail.down('#pbs070ukrvs_6Grid2').reset();
                panelDetail.down('#tab_pbs070ukrvs6Tab').setValues({'ITEM_CODE1':''});
                panelDetail.down('#tab_pbs070ukrvs6Tab').setValues({'ITEM_FR_CODE':''});
                panelDetail.down('#tab_pbs070ukrvs6Tab').setValues({'ITEM_FR_NAME':''});
                panelDetail.down('#tab_pbs070ukrvs6Tab').setValues({'ITEM_TO_CODE':''});
                panelDetail.down('#tab_pbs070ukrvs6Tab').setValues({'ITEM_TO_NAME':''});
                UniAppManager.setToolbarButtons(['save'],false);

                pbs070ukrvs_6Store.clearData();
                pbs070ukrvs_6Store2.clearData();
            }
        },
        onNewDataButtonDown : function()    {
            var activeTab = panelDetail.down('#pbs070Tab').getActiveTab();
            var selectedMasterGrid = panelDetail.down('#pbs070ukrvs_1Grid');

            /*this.createTabData(activeTab, activeTab.getSubCode())*/

            if(activeTab.getId() == 'tab_holyTab'){
                var compCode = UserInfo.compCode

                var r = {
                    COMP_CODE : compCode
                }
                panelDetail.down('#pbs070ukrvs_1Grid').createRow(r);
            } else if(activeTab.getId() == 'tab_pbs070ukrvs5Tab'){
                var param =  panelDetail.down('#tab_pbs070ukrvs5Tab').getValues();
                var grid = Ext.getCmp('pbs070ukrvs_5Grid');
                if(!Ext.isEmpty(selectedGrid)){
                if (selectedGrid == 'pbs070ukrvs_5Grid') {
                    var compCode = UserInfo.compCode;
                    var divCode = param.DIV_CODE;
                    var workShopCode = param.WORK_SHOP_CODE;
                    var workShopName = panelDetail.down('#tab_pbs070ukrvs5Tab').getField('WORK_SHOP_CODE').getRawValue();
                    var stdTime = '0';
                    var progUnit = 'BOX';
                    var progUnitCost = '0';
                    var useYn = 'Y';
                    var wkord_yn = 'Y';		// 20210910 작업지시적용 유무 추가

                    var r = {
                        COMP_CODE : compCode,
                        DIV_CODE : divCode,
                        WORK_SHOP_CODE : workShopCode,
                        WORK_SHOP_NAME : workShopName,
                        STD_TIME : stdTime,
                        PROG_UNIT : progUnit,
                        PROG_UNIT_COST : progUnitCost,
                        USE_YN : useYn,
                        WKORD_YN : wkord_yn	// 20210910 작업지시적용 유무 추가
                    }
                    grid.createRow(r);
                  }
                }
//                else if(selectedGrid == 'pbs070ukrvs_5_2Grid') {
//                    var param =  panelDetail.down('#tab_pbs070ukrvs5Tab').getValues();
//                    var grid = Ext.getCmp('pbs070ukrvs_5_2Grid');
//                    var record = Ext.getCmp('tab_pbs070ukrvs5Tab').down('#pbs070ukrvs_5Grid').getSelectedRecord();
//                    var compCode = UserInfo.compCode;
//                    var divCode = record.get('DIV_CODE');
//                    var workShopCode = record.get('WORK_SHOP_CODE');
//                    var progWorkCode = record.get('PROG_WORK_CODE');
//
//                    var r = {
//                        COMP_CODE : compCode,
//                        DIV_CODE : divCode,
//                        WORK_SHOP_CODE : workShopCode,
//                        PROG_WORK_CODE : progWorkCode
//                    }
//                    grid.createRow(r);
//                } else if(selectedGrid == 'pbs070ukrvs_5_3Grid') {
//                    var param =  panelDetail.down('#tab_pbs070ukrvs5Tab').getValues();
//                    var record = Ext.getCmp('tab_pbs070ukrvs5Tab').down('#pbs070ukrvs_5Grid').getSelectedRecord();
//                    var grid = Ext.getCmp('pbs070ukrvs_5_3Grid');
//                    var compCode = UserInfo.compCode;
//                    var divCode = record.get('DIV_CODE');
//                    var workShopCode = record.get('WORK_SHOP_CODE');
//                    var progWorkCode = record.get('PROG_WORK_CODE')
//
//                    var r = {
//                        COMP_CODE : compCode,
//                        DIV_CODE : divCode,
//                        WORK_SHOP_CODE : workShopCode,
//                        PROG_WORK_CODE : progWorkCode
//                    }
//                    grid.createRow(r);
//                }
//                UniAppManager.setToolbarButtons('delete', true);
//                UniAppManager.setToolbarButtons('save', true);

           }
        },

        onSaveDataButtonDown: function (config) {
            var activeTab = panelDetail.down('#pbs070Tab').getActiveTab();
            if (activeTab.getId() == 'tab_holyTab'){
                 activeTab.down('#pbs070ukrvs_1Grid').getStore().syncAll();
            }else if (activeTab.getId() == 'tab_pbs070ukrvs5Tab'){
                var selectedMasterGrid = panelDetail.down('#pbs070ukrvs_1Grid');
                if(selectedMasterGrid = 'pbs070ukrvs_5Grid') {
                    pbs070ukrvs_5Store.saveStore();
                }
//                else if(selectedMasterGrid = 'pbs070ukrvs_5_2Grid') {
//                    pbs070ukrvs_5_2Store.saveStore();
//                } else if(selectedMasterGrid = 'pbs070ukrvs_5_3Grid') {
//                    pbs070ukrvs_5_3Store.saveStore();
//                }
            }else if (activeTab.getId() == 'tab_pbs070ukrvs6Tab'){
                pbs070ukrvs_6Store2.saveStore();
                //UniAppManager.app.onQueryButtonDown();
                //activeTab.down('#pbs070ukrvs_6Grid').getStore().syncAll();
                //pbs070ukrvs_6Store2.loadStoreRecords();
            }
        },
        confirmDelete : function(activeTab,index){
            var gridPanel = '#uniGridPanel';
            gridPanel = gridPanel + index;

            var selRow = activeTab.down(gridPanel).getSelectedRecord();
            if(selRow.phantom === true) {
                activeTab.down(gridPanel).deleteSelectedRow();
            }else {
                Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
                    if (btn == 'yes') {
                        activeTab.down(gridPanel).deleteSelectedRow();
//                      activeTab.down(gridPanel).getStore().sync();
                    }
                });
            }
        },
        onDeleteDataButtonDown : function() {
            var activeTab = panelDetail.down('#pbs070Tab').getActiveTab();

            if(activeTab.getItemId() == "tab_holy"){
                var grid = panelDetail.down('#pbs070ukrvs_1Grid');
                var selRow = grid.getSelectionModel().getSelection()[0];

                if (selRow.phantom === true)    {
                    grid.deleteSelectedRow();
                } else {

                    Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
                        if (btn == 'yes') {
                            grid.deleteSelectedRow();
                            //grid.getStore().syncAll();
                        }
                    });
                }

            }else if(activeTab.getId() == 'tab_pbs070ukrvs5Tab') {
                var grid = Ext.getCmp('pbs070ukrvs_5Grid');
//                if (selectedGrid == 'pbs070ukrvs_5_2Grid') {
//                    grid = Ext.getCmp('pbs070ukrvs_5_2Grid');
//                } else if(selectedGrid == 'pbs070ukrvs_5_3Grid') {
//                    grid = Ext.getCmp('pbs070ukrvs_5_3Grid');
//                }
                //if (grid.getStore().getCount == 0) return;
                var selRow = grid.getSelectionModel().getSelection()[0];
                if (selRow.phantom === true)    {
                    grid.deleteSelectedRow();
                } else {
                    var grdRecord = Ext.getCmp('tab_pbs070ukrvs5Tab').down('#pbs070ukrvs_5Grid').getSelectedRecord();
                    if(grdRecord.get('EXIST') == 'Y') {
                        alert('공정수순에 반영되어 있습니다.');
                        return false;
                    } else {

                        Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
                            if (btn == 'yes') {
                                grid.deleteSelectedRow();
                                //grid.getStore().sync();
                            }
                        });
                    }
                }
                if (Ext.getCmp('pbs070ukrvs_5Grid').getStore().getCount() == 0) {
                    UniAppManager.setToolbarButtons('delete', false);
                    UniAppManager.setToolbarButtons( 'save', false);
                }
                if (!Ext.getCmp('pbs070ukrvs_5Grid').getStore().isDirty()) {
                    UniAppManager.setToolbarButtons( 'save', false);
                }
            }else if(activeTab.getItemId() == "tab_pbs070ukrvs6Tab"){
                var grid = panelDetail.down('#pbs070ukrvs_6Grid2');
                var selRow = grid.getSelectionModel().getSelection()[0];
                var grdRecord = Ext.getCmp('tab_pbs070ukrvs6Tab').down('#pbs070ukrvs_6Grid2').getSelectedRecord();
                if (selRow.phantom === true)    {
                    grid.deleteSelectedRow();
                } else {
                    Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
                        if (btn == 'yes') {
                            grid.deleteSelectedRow();
                            //grid.getStore().syncAll();
                        }
                    });
                }
            }
        },onDeleteAllButtonDown: function() {
        	var activeTab = panelDetail.down('#pbs070Tab').getActiveTab();
        	if(activeTab.getItemId() == "tab_pbs070ukrvs6Tab"){
                var records = pbs070ukrvs_6Store2.data.items;    
                Ext.each(records, function(record,i) {
                    if(record.phantom){                     //신규 레코드일시 isNewData에 true를 반환
                        isNewData = true;
                    }else{                                  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
                        if(confirm('<t:message code="system.message.purchase.message008" default="전체삭제 하시겠습니까?"/>')) {
                            var deletable = true;
                            if(deletable){
                                activeTab.down('#pbs070ukrvs_6Grid2').reset();
                                UniAppManager.app.onSaveDataButtonDown();
                            }
                            isNewData = false;
                        }
                        return false;
                    }
                });
    
                if(isNewData){                              //신규 레코드들만 있을시 그리드 리셋
                    activeTab.down('#pbs070ukrvs_6Grid2').reset();
                    UniAppManager.app.onResetButtonDown();  //삭제후 RESET..
                }
            }
        },
        onDetailButtonDown:function() {
            var as = Ext.getCmp('AdvanceSerch');
            if(as.isHidden())   {
                as.show();
            }else {
                as.hide()
            }
        },
        loadTabData: function(tab, itemId){

//            if (tab.getItemId() == 'tab_holyTab'){
////              UniAppManager.setToolbarButtons('newData',true);
//               // UniAppManager.setToolbarButtons(['newData', 'delete'],true);
//                UniAppManager.setToolbarButtons(['query'],true);
//                pbs070ukrvs_1Store.loadStoreRecords();
//            }
//            else if(tab.getItemId() == "tab_Cal_Info"){
//                UniAppManager.setToolbarButtons(['newData', 'reset', 'excel' , 'save', 'delete', 'query'],false);
//                pbs070ukrvs_2Store.loadStoreRecords();
//
//            }
//            /*else if(tab.getItemId() == "tab_Cal_Revise"){
//                UniAppManager.setToolbarButtons(['newData', 'reset', 'excel' , 'save', 'delete'],false);
//                pbs070ukrvs_3Store.loadStoreRecords();
//
//            }*/
//            else if(tab.getItemId() == "tab_Cal_Search"){
//                UniAppManager.setToolbarButtons(['newData', 'reset', 'excel' , 'save', 'delete'],false);
//                UniAppManager.setToolbarButtons(['query'],true);
//            }
        }
    });
};


</script>

