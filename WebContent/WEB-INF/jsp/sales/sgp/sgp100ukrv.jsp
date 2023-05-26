<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="sgp100ukrv"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="sgp100ukrv"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--매출구분-->
    <t:ExtComboStore comboType="AU" comboCode="B004" /> <!--화폐-->
    <t:ExtComboStore comboType="AU" comboCode="B042" /> <!--계획금액단위-->
    <t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당-->
    <t:ExtComboStore comboType="AU" comboCode="B055" /> <!--고객분류-->
    <t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목계정-->
    <t:ExtComboStore comboType="AU" comboCode="B109" /> <!--유통-->
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />   <!-- 대분류 -->
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />   <!-- 중분류 -->
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />   <!-- 소분류 -->
</t:appConfig>

<script type="text/javascript" >

var excelWindow1;    // 엑셀참조(고객별)
var excelWindow2;    // 엑셀참조(영업담당별)
var excelWindow3;    // 엑셀참조(품목별)
var excelWindow4;    // 엑셀참조(품목분류별)
var excelWindow5;    // 엑셀참조(대표모델별)
var excelWindow6;    // 엑셀참조(고객품목별)
var excelWindow7;    // 엑셀참조(판매유형별)
var excelWindow8;    // 엑셀참조
var excelWindow9;    // 엑셀참조
var excelWindow10;    // 엑셀참조(고객품목분류별)

var BsaCodeInfo = { 
	gsEntMoneyUnit: '${gsEntMoneyUnit}',
    gsUseCode1: '${useCode1}',
    gsUseCode2: '${useCode2}',
    gsUseCode3: '${useCode3}',
    gsUseCode4: '${useCode4}',
    gsUseCode5: '${useCode5}',
    gsUseCode6: '${useCode6}',
    gsUseCode7: '${useCode7}',
    gsUseCode8: '${useCode8}',
    gsUseCode9: '${useCode9}',
    gsUseCode10: '${useCode10}'
};
var use1 = false;
var use2 = false;
var use3 = false;
var use4 = false;
var use5 = false;
var use6 = false;
var use7 = false;
var use8 = false;
var use9 = false;
var use10 = false;

BsaCodeInfo.gsUseCode1 == "Y" ? use1 = true : use1 = false;
BsaCodeInfo.gsUseCode2 == "Y" ? use2 = true : use2 = false;
BsaCodeInfo.gsUseCode3 == "Y" ? use3 = true : use3 = false;
BsaCodeInfo.gsUseCode4 == "Y" ? use4 = true : use4 = false;
BsaCodeInfo.gsUseCode5 == "Y" ? use5 = true : use5 = false;
BsaCodeInfo.gsUseCode6 == "Y" ? use6 = true : use6 = false;
BsaCodeInfo.gsUseCode7 == "Y" ? use7 = true : use7 = false;
BsaCodeInfo.gsUseCode8 == "Y" ? use8 = true : use8 = false;
BsaCodeInfo.gsUseCode9 == "Y" ? use9 = true : use9 = false;
BsaCodeInfo.gsUseCode10 == "Y" ? use10 = true : use10 = false;

function appMain() {
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'sgp100ukrvService.customSelectList',
            update: 'sgp100ukrvService.updateDetail',
            create: 'sgp100ukrvService.insertDetail',
            destroy: 'sgp100ukrvService.deleteDetail',
            syncAll: 'sgp100ukrvService.saveAll'
        }
    });
    
    var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'sgp100ukrvService.salePrsnSelectList',
            update: 'sgp100ukrvService.updateDetail2',
            create: 'sgp100ukrvService.insertDetail2',
            destroy: 'sgp100ukrvService.deleteDetail2',
            syncAll: 'sgp100ukrvService.saveAll2'
        }
    });
    
    var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'sgp100ukrvService.itemSelectList',
            update: 'sgp100ukrvService.updateDetail3',
            create: 'sgp100ukrvService.insertDetail3',
            destroy: 'sgp100ukrvService.deleteDetail3',
            syncAll: 'sgp100ukrvService.saveAll3'
        }
    });
    
    var directProxy4 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'sgp100ukrvService.itemSortSelectList',
            update: 'sgp100ukrvService.updateDetail4',
            create: 'sgp100ukrvService.insertDetail4',
            destroy: 'sgp100ukrvService.deleteDetail4',
            syncAll: 'sgp100ukrvService.saveAll4'
        }
    });
    
    var directProxy5 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'sgp100ukrvService.spokesItemSelectList',
            update: 'sgp100ukrvService.updateDetail5',
            create: 'sgp100ukrvService.insertDetail5',
            destroy: 'sgp100ukrvService.deleteDetail5',
            syncAll: 'sgp100ukrvService.saveAll5'
        }
    });
    
    var directProxy6 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'sgp100ukrvService.customerItemSelectList',
            update: 'sgp100ukrvService.updateDetail6',
            create: 'sgp100ukrvService.insertDetail6',
            destroy: 'sgp100ukrvService.deleteDetail6',
            syncAll: 'sgp100ukrvService.saveAll6'
        }
    });
    
    var directProxy7 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'sgp100ukrvService.saleTypeSelectList',
            update: 'sgp100ukrvService.updateDetail7',
            create: 'sgp100ukrvService.insertDetail7',
            destroy: 'sgp100ukrvService.deleteDetail7',
            syncAll: 'sgp100ukrvService.saveAll7'
        }
    });
    
    var directProxy10 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'sgp100ukrvService.customitemSortSelectList',
            update: 'sgp100ukrvService.updateDetail10',
            create: 'sgp100ukrvService.insertDetail10',
            destroy: 'sgp100ukrvService.deleteDetail10',
            syncAll: 'sgp100ukrvService.saveAll10'
        }
    });    
    
    /**
     *   Model 정의 
     * @type 
     */
        
    Unilite.defineModel('Sgp100ukrvModel1', {
        fields: [{name: 'DIV_CODE'              ,text: 'DIV_CODE'        ,type:'string'},                
                 {name: 'PLAN_YEAR'             ,text: 'PLAN_YEAR'       ,type:'string'},
                 {name: 'PLAN_TYPE1'            ,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'        ,type:'string'},
                 {name: 'PLAN_TYPE2'            ,text: 'TAB'             ,type:'string', defaultValue: '2'},
                 {name: 'PLAN_TYPE2_CODE'       ,text: 'PLAN_TYPE2_CODE' ,type:'string'},
                 {name: 'LEVEL_KIND'            ,text: 'LEVEL_KIND'      ,type:'string', defaultValue: '*'},
                 {name: 'MONEY_UNIT'            ,text: 'MONEY_UNIT'      ,type:'string'},
                 {name: 'ENT_MONEY_UNIT'        ,text: 'ENT_MONEY_UNIT'  ,type:'string'},
                 {name: 'CONFIRM_YN'            ,text: 'CONFIRM_YN'      ,type:'string', defaultValue: 'N'},
                 {name: 'CUSTOM_CODE'           ,text: '<t:message code="system.label.sales.custom" default="거래처"/>'         ,type:'string', allowBlank: false},
                 {name: 'CUSTOM_NAME'           ,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'          ,type:'string', allowBlank: false},
                 {name: 'PLAN_SUM'              ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'          ,type:'uniPrice'},
                 {name: 'MOD_PLAN_SUM'          ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'          ,type:'uniPrice'},
                 {name: 'A_D_RATE_SUM'          ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'             ,type:'uniPercent'},
                 {name: 'PLAN1'                 ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'            ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN1'             ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'            ,type:'uniPrice'},
                 {name: 'A_D_RATE1'             ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'             ,type:'uniPercent'},
                 {name: 'PLAN2'                 ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'            ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN2'             ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'            ,type:'uniPrice'},
                 {name: 'A_D_RATE2'             ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'             ,type:'uniPercent'},
                 {name: 'PLAN3'                 ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'            ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN3'             ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'            ,type:'uniPrice'},
                 {name: 'A_D_RATE3'             ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'             ,type:'uniPercent'},
                 {name: 'PLAN4'                 ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'            ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN4'             ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'            ,type:'uniPrice'},
                 {name: 'A_D_RATE4'             ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'             ,type:'uniPercent'},
                 {name: 'PLAN5'                 ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'            ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN5'             ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'            ,type:'uniPrice'},
                 {name: 'A_D_RATE5'             ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'             ,type:'uniPercent'},
                 {name: 'PLAN6'                 ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'            ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN6'             ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'            ,type:'uniPrice'},
                 {name: 'A_D_RATE6'             ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'             ,type:'uniPercent'},
                 {name: 'PLAN7'                 ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'            ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN7'             ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'            ,type:'uniPrice'},
                 {name: 'A_D_RATE7'             ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'             ,type:'uniPercent'},
                 {name: 'PLAN8'                 ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'            ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN8'             ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'            ,type:'uniPrice'},
                 {name: 'A_D_RATE8'             ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'             ,type:'uniPercent'},
                 {name: 'PLAN9'                 ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'            ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN9'             ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'            ,type:'uniPrice'},
                 {name: 'A_D_RATE9'             ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'             ,type:'uniPercent'},
                 {name: 'PLAN10'                ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'            ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN10'            ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'            ,type:'uniPrice'},
                 {name: 'A_D_RATE10'            ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'             ,type:'uniPercent'},
                 {name: 'PLAN11'                ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'            ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN11'            ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'            ,type:'uniPrice'},
                 {name: 'A_D_RATE11'            ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'             ,type:'uniPercent'},
                 {name: 'PLAN12'                ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'            ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN12'            ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'            ,type:'uniPrice'},
                 {name: 'A_D_RATE12'            ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'             ,type:'uniPercent'},
                 {name: 'UPDATE_DB_USER'        ,text: 'UPDATE_DB_USER'  ,type:'string'},
                 {name: 'UPDATE_DB_TIME'        ,text: 'UPDATE_DB_TIME'  ,type:'string'},
                 {name: 'COMP_CODE'             ,text: 'COMP_CODE'       ,type:'string', defaultValue: UserInfo.compCode}   
            ]                                          
    });       
    
    Unilite.defineModel('Sgp100ukrvModel2', {
        fields: [{name: 'DIV_CODE'              ,text: 'DIV_CODE'        ,type:'string'},                
                 {name: 'PLAN_YEAR'             ,text: 'PLAN_YEAR'       ,type:'string'},
                 {name: 'PLAN_TYPE1'            ,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'        ,type:'string'},
                 {name: 'PLAN_TYPE2'            ,text: 'TAB'             ,type:'string', defaultValue: '1'},
                 {name: 'PLAN_TYPE2_CODE'       ,text: 'PLAN_TYPE2_CODE' ,type:'string'},
                 {name: 'LEVEL_KIND'            ,text: 'LEVEL_KIND'      ,type:'string', defaultValue: '*'},
                 {name: 'MONEY_UNIT'            ,text: 'MONEY_UNIT'      ,type:'string'},
                 {name: 'ENT_MONEY_UNIT'        ,text: 'ENT_MONEY_UNIT'  ,type:'string'},
                 {name: 'CONFIRM_YN'            ,text: 'CONFIRM_YN'      ,type:'string', defaultValue: 'N'},
                 {name: 'S_CODE'                ,text: '<t:message code="system.label.sales.saleschargename" default="영업담당명"/>'      ,type:'string', comboType: 'AU', comboCode: 'S010', allowBlank: false},
                 {name: 'S_NAME'                ,text: '<t:message code="system.label.sales.saleschargename" default="영업담당명"/>'      ,type:'string'},
                 {name: 'PLAN_SUM'              ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},
                 {name: 'MOD_PLAN_SUM'          ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},
                 {name: 'A_D_RATE_SUM'          ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},
                 {name: 'PLAN1'                 ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN1'             ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},
                 {name: 'A_D_RATE1'             ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},
                 {name: 'PLAN2'                 ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN2'             ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},
                 {name: 'A_D_RATE2'             ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},
                 {name: 'PLAN3'                 ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN3'             ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},
                 {name: 'A_D_RATE3'             ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},
                 {name: 'PLAN4'                 ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN4'             ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},
                 {name: 'A_D_RATE4'             ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},
                 {name: 'PLAN5'                 ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN5'             ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},
                 {name: 'A_D_RATE5'             ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},
                 {name: 'PLAN6'                 ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN6'             ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},
                 {name: 'A_D_RATE6'             ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},
                 {name: 'PLAN7'                 ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN7'             ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},
                 {name: 'A_D_RATE7'             ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},
                 {name: 'PLAN8'                 ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN8'             ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},
                 {name: 'A_D_RATE8'             ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},
                 {name: 'PLAN9'                 ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN9'             ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},
                 {name: 'A_D_RATE9'             ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},
                 {name: 'PLAN10'                ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN10'            ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},
                 {name: 'A_D_RATE10'            ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},
                 {name: 'PLAN11'                ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN11'            ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},
                 {name: 'A_D_RATE11'            ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},
                 {name: 'PLAN12'                ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN12'            ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},
                 {name: 'A_D_RATE12'            ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},
                 {name: 'UPDATE_DB_USER'        ,text: 'UPDATE_DB_USER'  ,type:'string'},
                 {name: 'UPDATE_DB_TIME'        ,text: 'UPDATE_DB_TIME'  ,type:'string'},
                 {name: 'COMP_CODE'             ,text: 'COMP_CODE'       ,type:'string', defaultValue: UserInfo.compCode}               
            ]
    }); 
    
    Unilite.defineModel('Sgp100ukrvModel3', {
        fields: [{name: 'DIV_CODE'                  ,text: 'DIV_CODE'        ,type:'string'},                
                 {name: 'PLAN_YEAR'                 ,text: 'PLAN_YEAR'       ,type:'string'},
                 {name: 'PLAN_TYPE1'                ,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'        ,type:'string'},
                 {name: 'PLAN_TYPE2'                ,text: 'TAB'             ,type:'string', defaultValue: '3'},
                 {name: 'PLAN_TYPE2_CODE'           ,text: 'PLAN_TYPE2_CODE' ,type:'string'},
                 {name: 'LEVEL_KIND'                ,text: 'LEVEL_KIND'      ,type:'string', defaultValue: '*'},
                 {name: 'MONEY_UNIT'                ,text: 'MONEY_UNIT'      ,type:'string'},
                 {name: 'ENT_MONEY_UNIT'            ,text: 'ENT_MONEY_UNIT'  ,type:'string'},
                 {name: 'CONFIRM_YN'                ,text: 'CONFIRM_YN'      ,type:'string', defaultValue: 'N'},
                 {name: 'SALE_BASIS_P'              ,text: 'SALE_BASIS_P'    ,type:'string'},
                 {name: 'ITEM_CODE'                 ,text: '<t:message code="system.label.sales.item" default="품목"/>'        ,type:'string', allowBlank: false},
                 {name: 'ITEM_NAME'                 ,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'          ,type:'string', allowBlank: false},
                 {name: 'S_OTHER1'                  ,text: '<t:message code="system.label.sales.spec" default="규격"/>'            ,type:'string'},
                 {name: 'PLAN_SUM_Q'                ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'},
                 {name: 'PLAN_SUM_AMT'              ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'},
                 {name: 'MOD_PLAN_SUM_Q'            ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},
                 {name: 'MOD_PLAN_SUM_AMT'          ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},
                 {name: 'PLAN_QTY1'                 ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},
                 {name: 'PLAN_AMT1'                 ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN_Q1'               ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},
                 {name: 'MOD_PLAN_AMT1'             ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},
                 {name: 'PLAN_QTY2'                 ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},
                 {name: 'PLAN_AMT2'                 ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN_Q2'               ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},
                 {name: 'MOD_PLAN_AMT2'             ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},
                 {name: 'PLAN_QTY3'                 ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},
                 {name: 'PLAN_AMT3'                 ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN_Q3'               ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},
                 {name: 'MOD_PLAN_AMT3'             ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},
                 {name: 'PLAN_QTY4'                 ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},
                 {name: 'PLAN_AMT4'                 ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN_Q4'               ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},
                 {name: 'MOD_PLAN_AMT4'             ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},
                 {name: 'PLAN_QTY5'                 ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},
                 {name: 'PLAN_AMT5'                 ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN_Q5'               ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},
                 {name: 'MOD_PLAN_AMT5'             ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},
                 {name: 'PLAN_QTY6'                 ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},
                 {name: 'PLAN_AMT6'                 ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN_Q6'               ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},
                 {name: 'MOD_PLAN_AMT6'             ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},
                 {name: 'PLAN_QTY7'                 ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},
                 {name: 'PLAN_AMT7'                 ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN_Q7'               ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},
                 {name: 'MOD_PLAN_AMT7'             ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},
                 {name: 'PLAN_QTY8'                 ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},
                 {name: 'PLAN_AMT8'                 ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN_Q8'               ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},
                 {name: 'MOD_PLAN_AMT8'             ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},
                 {name: 'PLAN_QTY9'                 ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},
                 {name: 'PLAN_AMT9'                 ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN_Q9'               ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},
                 {name: 'MOD_PLAN_AMT9'             ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},
                 {name: 'PLAN_QTY10'                ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},
                 {name: 'PLAN_AMT10'                ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN_Q10'              ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},
                 {name: 'MOD_PLAN_AMT10'            ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},
                 {name: 'PLAN_QTY11'                ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},
                 {name: 'PLAN_AMT11'                ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN_Q11'              ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},
                 {name: 'MOD_PLAN_AMT11'            ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},
                 {name: 'PLAN_QTY12'                ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},
                 {name: 'PLAN_AMT12'                ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},
                 {name: 'MOD_PLAN_Q12'              ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},
                 {name: 'MOD_PLAN_AMT12'            ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},
                 {name: 'UPDATE_DB_USER'            ,text: 'UPDATE_DB_USER'  ,type:'string'},
                 {name: 'UPDATE_DB_TIME'            ,text: 'UPDATE_DB_TIME'  ,type:'string'},
                 {name: 'COMP_CODE'                 ,text: 'COMP_CODE'       ,type:'string', defaultValue: UserInfo.compCode}
            ]
    });    
    
    Unilite.defineModel('Sgp100ukrvModel4', {
        fields: [{name: 'DIV_CODE'                  ,text: '<t:message code="system.label.sales.division" default="사업장"/>'          ,type:'string'}, 
                 {name: 'PLAN_YEAR'                 ,text: '<t:message code="system.label.sales.planyear" default="계획년도"/>'        ,type:'string'}, 
                 {name: 'PLAN_TYPE1'                ,text: '<t:message code="system.label.sales.domesticclass" default="내수구분"/>'        ,type:'string'}, 
                 {name: 'PLAN_TYPE2'                ,text: '<t:message code="system.label.sales.planclass" default="계획구분"/>'        ,type:'string', defaultValue: '4'}, 
                 {name: 'PLAN_TYPE2_CODE'           ,text: '<t:message code="system.label.sales.classficationcode" default="구분코드"/>'        ,type:'string'}, 
                 {name: 'LEVEL_KIND'                ,text: '<t:message code="system.label.sales.groupcode" default="그룹코드"/>'        ,type:'string'}, 
                 {name: 'MONEY_UNIT'                ,text: '<t:message code="system.label.sales.currencytype" default="환종"/>'            ,type:'string'}, 
                 {name: 'ENT_MONEY_UNIT'            ,text: '<t:message code="system.label.sales.amountunit" default="금액단위"/>'        ,type:'string'}, 
                 {name: 'CONFIRM_YN'                ,text: '<t:message code="system.label.sales.confirmedpending" default="확정여부"/>'        ,type:'string', defaultValue: 'N'}, 
                 {name: 'S_CODE1'                   ,text: '<t:message code="system.label.sales.majorgroup" default="대분류"/>'           ,type:'string', store: Ext.data.StoreManager.lookup('itemLeve1Store') ,child:'ITEM_LEVEL2'}, 
                 {name: 'S_CODE2'                   ,text: '<t:message code="system.label.sales.middlegroup" default="중분류"/>'          ,type:'string', store: Ext.data.StoreManager.lookup('itemLeve2Store') ,child:'ITEM_LEVEL3'}, 
                 {name: 'S_CODE3'                   ,text: '<t:message code="system.label.sales.minorgroup" default="소분류"/>'           ,type:'string', store: Ext.data.StoreManager.lookup('itemLeve3Store')}, 
                 {name: 'PLAN_SUM'                  ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'}, 
                 {name: 'MOD_PLAN_SUM'              ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'}, 
                 {name: 'A_D_RATE_SUM'              ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'}, 
                 {name: 'PLAN1'                     ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},      
                 {name: 'MOD_PLAN1'                 ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},      
                 {name: 'A_D_RATE1'                 ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},   
                 {name: 'PLAN2'                     ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},      
                 {name: 'MOD_PLAN2'                 ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},      
                 {name: 'A_D_RATE2'                 ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},   
                 {name: 'PLAN3'                     ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},       
                 {name: 'MOD_PLAN3'                 ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},       
                 {name: 'A_D_RATE3'                 ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},    
                 {name: 'PLAN4'                     ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},       
                 {name: 'MOD_PLAN4'                 ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},       
                 {name: 'A_D_RATE4'                 ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},    
                 {name: 'PLAN5'                     ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},       
                 {name: 'MOD_PLAN5'                 ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},       
                 {name: 'A_D_RATE5'                 ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},    
                 {name: 'PLAN6'                     ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},         
                 {name: 'MOD_PLAN6'                 ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},         
                 {name: 'A_D_RATE6'                 ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},     
                 {name: 'PLAN7'                     ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},         
                 {name: 'MOD_PLAN7'                 ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},         
                 {name: 'A_D_RATE7'                 ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},     
                 {name: 'PLAN8'                     ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},         
                 {name: 'MOD_PLAN8'                 ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},         
                 {name: 'A_D_RATE8'                 ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},     
                 {name: 'PLAN9'                     ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},     
                 {name: 'MOD_PLAN9'                 ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},     
                 {name: 'A_D_RATE9'                 ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'}, 
                 {name: 'PLAN10'                    ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},     
                 {name: 'MOD_PLAN10'                ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},     
                 {name: 'A_D_RATE10'                ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'}, 
                 {name: 'PLAN11'                    ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},     
                 {name: 'MOD_PLAN11'                ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},     
                 {name: 'A_D_RATE11'                ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'}, 
                 {name: 'PLAN12'                    ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},     
                 {name: 'MOD_PLAN12'                ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},     
                 {name: 'A_D_RATE12'                ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'}, 
                 {name: 'UPDATE_DB_USER'            ,text: '<t:message code="system.label.sales.updateuser" default="수정자"/>'          ,type:'string'}, 
                 {name: 'UPDATE_DB_TIME'            ,text: '<t:message code="system.label.sales.updatedate" default="수정일"/>'          ,type:'uniDate'}, 
                 {name: 'COMP_CODE'                 ,text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'        ,type:'string'}
            ]
    });        
    
    Unilite.defineModel('Sgp100ukrvModel5', {
        fields: [
            {name: 'DIV_CODE'                       ,text: 'DIV_CODE'        ,type:'string'},                                            
            {name: 'PLAN_YEAR'                      ,text: 'PLAN_YEAR'       ,type:'string'},                                            
            {name: 'PLAN_TYPE1'                     ,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'        ,type:'string'},                                                
            {name: 'PLAN_TYPE2'                     ,text: 'TAB'             ,type:'string', defaultValue: '5'},                         
            {name: 'PLAN_TYPE2_CODE'                ,text: 'PLAN_TYPE2_CODE' ,type:'string'},                                            
            {name: 'LEVEL_KIND'                     ,text: 'LEVEL_KIND'      ,type:'string', defaultValue: '*'},                         
            {name: 'MONEY_UNIT'                     ,text: 'MONEY_UNIT'      ,type:'string'},                                            
            {name: 'ENT_MONEY_UNIT'                 ,text: 'ENT_MONEY_UNIT'  ,type:'string'},                                            
            {name: 'CONFIRM_YN'                     ,text: 'CONFIRM_YN'      ,type:'string', defaultValue: 'N'},                         
            {name: 'SALE_BASIS_P'                   ,text: 'SALE_BASIS_P'    ,type:'string'},                                            
            {name: 'ITEM_CODE'                      ,text: '<t:message code="system.label.sales.repmodel" default="대표모델"/>'    ,type:'string', allowBlank: false},                             
            {name: 'ITEM_NAME'                      ,text: '<t:message code="system.label.sales.repmodelname" default="대표모델명"/>'      ,type:'string', allowBlank: false},                            
            {name: 'S_OTHER1'                       ,text: '<t:message code="system.label.sales.spec" default="규격"/>'            ,type:'string'},                                              
            {name: 'PLAN_SUM_Q'                     ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'},                                                
            {name: 'PLAN_SUM_AMT'                   ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'},                                              
            {name: 'MOD_PLAN_SUM_Q'                 ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},                                                
            {name: 'MOD_PLAN_SUM_AMT'               ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},                                              
            {name: 'PLAN_QTY1'                      ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},                         
            {name: 'PLAN_AMT1'                      ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},                       
            {name: 'MOD_PLAN_Q1'                    ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},                                                
            {name: 'MOD_PLAN_AMT1'                  ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},                                              
            {name: 'PLAN_QTY2'                      ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},                         
            {name: 'PLAN_AMT2'                      ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},                       
            {name: 'MOD_PLAN_Q2'                    ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},                                                
            {name: 'MOD_PLAN_AMT2'                  ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},                                              
            {name: 'PLAN_QTY3'                      ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},                         
            {name: 'PLAN_AMT3'                      ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},                       
            {name: 'MOD_PLAN_Q3'                    ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},                                                
            {name: 'MOD_PLAN_AMT3'                  ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},                                              
            {name: 'PLAN_QTY4'                      ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},                         
            {name: 'PLAN_AMT4'                      ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},                       
            {name: 'MOD_PLAN_Q4'                    ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},                                                
            {name: 'MOD_PLAN_AMT4'                  ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},                                              
            {name: 'PLAN_QTY5'                      ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},                         
            {name: 'PLAN_AMT5'                      ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},                       
            {name: 'MOD_PLAN_Q5'                    ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},                                                
            {name: 'MOD_PLAN_AMT5'                  ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},                                              
            {name: 'PLAN_QTY6'                      ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},                         
            {name: 'PLAN_AMT6'                      ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},                       
            {name: 'MOD_PLAN_Q6'                    ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},                                                
            {name: 'MOD_PLAN_AMT6'                  ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},                                              
            {name: 'PLAN_QTY7'                      ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},                         
            {name: 'PLAN_AMT7'                      ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},                       
            {name: 'MOD_PLAN_Q7'                    ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},                                                
            {name: 'MOD_PLAN_AMT7'                  ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},                                              
            {name: 'PLAN_QTY8'                      ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},                         
            {name: 'PLAN_AMT8'                      ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},                       
            {name: 'MOD_PLAN_Q8'                    ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},                                                
            {name: 'MOD_PLAN_AMT8'                  ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},                                              
            {name: 'PLAN_QTY9'                      ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},                         
            {name: 'PLAN_AMT9'                      ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},                       
            {name: 'MOD_PLAN_Q9'                    ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},                                                
            {name: 'MOD_PLAN_AMT9'                  ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},                                              
            {name: 'PLAN_QTY10'                     ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},                         
            {name: 'PLAN_AMT10'                     ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},                       
            {name: 'MOD_PLAN_Q10'                   ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},                                                
            {name: 'MOD_PLAN_AMT10'                 ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},                                              
            {name: 'PLAN_QTY11'                     ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},                         
            {name: 'PLAN_AMT11'                     ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},                       
            {name: 'MOD_PLAN_Q11'                   ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},                                                
            {name: 'MOD_PLAN_AMT11'                 ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},                                              
            {name: 'PLAN_QTY12'                     ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},                         
            {name: 'PLAN_AMT12'                     ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},                       
            {name: 'MOD_PLAN_Q12'                   ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},                                                
            {name: 'MOD_PLAN_AMT12'                 ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},                                              
            {name: 'UPDATE_DB_USER'                 ,text: 'UPDATE_DB_USER'  ,type:'string'},                                            
            {name: 'UPDATE_DB_TIME'                 ,text: 'UPDATE_DB_TIME'  ,type:'string'},                                            
            {name: 'COMP_CODE'                      ,text: 'COMP_CODE'       ,type:'string', defaultValue: UserInfo.compCode}            
        ]
    });        
    
    Unilite.defineModel('Sgp100ukrvModel6', {
        fields: [
            {name: 'DIV_CODE'                       ,text: 'DIV_CODE'        ,type:'string'},                                            
            {name: 'PLAN_YEAR'                      ,text: 'PLAN_YEAR'       ,type:'string'},                                            
            {name: 'PLAN_TYPE1'                     ,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'        ,type:'string'},                                                
            {name: 'PLAN_TYPE2'                     ,text: 'TAB'             ,type:'string', defaultValue: '6'},                         
            {name: 'PLAN_TYPE2_CODE'                ,text: 'PLAN_TYPE2_CODE' ,type:'string'},                                         
            {name: 'PLAN_TYPE2_CODE2'               ,text: 'PLAN_TYPE2_CODE2' ,type:'string'},                                              
            {name: 'LEVEL_KIND'                     ,text: 'LEVEL_KIND'      ,type:'string', defaultValue: '*'},                         
            {name: 'MONEY_UNIT'                     ,text: 'MONEY_UNIT'      ,type:'string'},                                            
            {name: 'ENT_MONEY_UNIT'                 ,text: 'ENT_MONEY_UNIT'  ,type:'string'},                                            
            {name: 'CONFIRM_YN'                     ,text: 'CONFIRM_YN'      ,type:'string', defaultValue: 'N'},                         
            {name: 'SALE_BASIS_P'                   ,text: 'SALE_BASIS_P'    ,type:'string'},                                             
            {name: 'CUSTOM_CODE'                    ,text: '<t:message code="system.label.sales.custom" default="거래처"/>'      ,type:'string', allowBlank: false},                             
            {name: 'CUSTOM_NAME'                    ,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'        ,type:'string', allowBlank: false},                         
            {name: 'ITEM_CODE'                      ,text: '<t:message code="system.label.sales.item" default="품목"/>'        ,type:'string', allowBlank: false},                             
            {name: 'ITEM_NAME'                      ,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'          ,type:'string'},                          
            {name: 'SPEC'                           ,text: '<t:message code="system.label.sales.spec" default="규격"/>'            ,type:'string'},                                              
            {name: 'PLAN_SUM_Q'                     ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'},                                                
            {name: 'PLAN_SUM_AMT'                   ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'},                                              
            {name: 'MOD_PLAN_SUM_Q'                 ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},                                                
            {name: 'MOD_PLAN_SUM_AMT'               ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},                                              
            {name: 'PLAN_QTY1'                      ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},                         
            {name: 'PLAN_AMT1'                      ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},                       
            {name: 'MOD_PLAN_Q1'                    ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},                                                
            {name: 'MOD_PLAN_AMT1'                  ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},                                              
            {name: 'PLAN_QTY2'                      ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},                         
            {name: 'PLAN_AMT2'                      ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},                       
            {name: 'MOD_PLAN_Q2'                    ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},                                                
            {name: 'MOD_PLAN_AMT2'                  ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},                                              
            {name: 'PLAN_QTY3'                      ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},                         
            {name: 'PLAN_AMT3'                      ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},                       
            {name: 'MOD_PLAN_Q3'                    ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},                                                
            {name: 'MOD_PLAN_AMT3'                  ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},                                              
            {name: 'PLAN_QTY4'                      ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},                         
            {name: 'PLAN_AMT4'                      ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},                       
            {name: 'MOD_PLAN_Q4'                    ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},                                                
            {name: 'MOD_PLAN_AMT4'                  ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},                                              
            {name: 'PLAN_QTY5'                      ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},                         
            {name: 'PLAN_AMT5'                      ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},                       
            {name: 'MOD_PLAN_Q5'                    ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},                                                
            {name: 'MOD_PLAN_AMT5'                  ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},                                              
            {name: 'PLAN_QTY6'                      ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},                         
            {name: 'PLAN_AMT6'                      ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},                       
            {name: 'MOD_PLAN_Q6'                    ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},                                                
            {name: 'MOD_PLAN_AMT6'                  ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},                                              
            {name: 'PLAN_QTY7'                      ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},                         
            {name: 'PLAN_AMT7'                      ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},                       
            {name: 'MOD_PLAN_Q7'                    ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},                                                
            {name: 'MOD_PLAN_AMT7'                  ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},                                              
            {name: 'PLAN_QTY8'                      ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},                         
            {name: 'PLAN_AMT8'                      ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},                       
            {name: 'MOD_PLAN_Q8'                    ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},                                                
            {name: 'MOD_PLAN_AMT8'                  ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},                                              
            {name: 'PLAN_QTY9'                      ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},                         
            {name: 'PLAN_AMT9'                      ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},                       
            {name: 'MOD_PLAN_Q9'                    ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},                                                
            {name: 'MOD_PLAN_AMT9'                  ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},                                              
            {name: 'PLAN_QTY10'                     ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},                         
            {name: 'PLAN_AMT10'                     ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},                       
            {name: 'MOD_PLAN_Q10'                   ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},                                                
            {name: 'MOD_PLAN_AMT10'                 ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},                                              
            {name: 'PLAN_QTY11'                     ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},                         
            {name: 'PLAN_AMT11'                     ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},                       
            {name: 'MOD_PLAN_Q11'                   ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},                                                
            {name: 'MOD_PLAN_AMT11'                 ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},                                              
            {name: 'PLAN_QTY12'                     ,text: '<t:message code="system.label.sales.yearqty" default="년초수량"/>'        ,type:'uniQty'/*, allowBlank: false*/},                         
            {name: 'PLAN_AMT12'                     ,text: '<t:message code="system.label.sales.yearamount" default="년초금액"/>'        ,type:'uniPrice'/*, allowBlank: false*/},                       
            {name: 'MOD_PLAN_Q12'                   ,text: '<t:message code="system.label.sales.changeqty" default="수정수량"/>'        ,type:'uniQty'},                                                
            {name: 'MOD_PLAN_AMT12'                 ,text: '<t:message code="system.label.sales.changeamount" default="수정금액"/>'        ,type:'uniPrice'},                                              
            {name: 'UPDATE_DB_USER'                 ,text: 'UPDATE_DB_USER'  ,type:'string'},                                            
            {name: 'UPDATE_DB_TIME'                 ,text: 'UPDATE_DB_TIME'  ,type:'string'},                                            
            {name: 'COMP_CODE'                      ,text: 'COMP_CODE'       ,type:'string', defaultValue: UserInfo.compCode}            
        ]
    }); 
    
    Unilite.defineModel('Sgp100ukrvModel7', {
        fields: [{name: 'DIV_CODE'                  ,text: '<t:message code="system.label.sales.division" default="사업장"/>'          ,type:'string'}, 
                 {name: 'PLAN_YEAR'                 ,text: '<t:message code="system.label.sales.planyear" default="계획년도"/>'        ,type:'string'}, 
                 {name: 'PLAN_TYPE1'                ,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'        ,type:'string', comboType:'AU', comboCode:'S002', allowBlank: false}, 
                 {name: 'PLAN_TYPE2'                ,text: 'PLAN_TYPE2'        ,type:'string', defaultValue: '4'}, 
                 {name: 'PLAN_TYPE2_CODE'           ,text: '<t:message code="system.label.sales.classficationcode" default="구분코드"/>'        ,type:'string'}, 
                 {name: 'LEVEL_KIND'                ,text: '<t:message code="system.label.sales.groupcode" default="그룹코드"/>'        ,type:'string'}, 
                 {name: 'MONEY_UNIT'                ,text: '<t:message code="system.label.sales.currencytype" default="환종"/>'            ,type:'string'}, 
                 {name: 'ENT_MONEY_UNIT'            ,text: '<t:message code="system.label.sales.amountunit" default="금액단위"/>'        ,type:'string'}, 
                 {name: 'CONFIRM_YN'                ,text: '<t:message code="system.label.sales.confirmedpending" default="확정여부"/>'        ,type:'string', defaultValue: 'N'},
                 {name: 'MONEY_UNIT_DIV'            ,text: '<t:message code="system.label.sales.planamountunit" default="계획금액단위"/>'     ,type:'string'},
                 {name: 'S_CODE1'                   ,text: '<t:message code="system.label.sales.majorgroup" default="대분류"/>'          ,type:'string', store: Ext.data.StoreManager.lookup('itemLeve1Store') ,child:'ITEM_LEVEL2'}, 
                 {name: 'S_NAME1'                   ,text: '<t:message code="system.label.sales.classficationname" default="분류명"/>'          ,type:'string'}, 
                 {name: 'S_CODE2'                   ,text: '<t:message code="system.label.sales.middlegroup" default="중분류"/>'          ,type:'string', store: Ext.data.StoreManager.lookup('itemLeve2Store') ,child:'ITEM_LEVEL3'}, 
                 {name: 'S_NAME2'                   ,text: '<t:message code="system.label.sales.classficationname" default="분류명"/>'          ,type:'string'}, 
                 {name: 'S_CODE3'                   ,text: '<t:message code="system.label.sales.minorgroup" default="소분류"/>'          ,type:'string', store: Ext.data.StoreManager.lookup('itemLeve3Store')}, 
                 {name: 'S_NAME3'                   ,text: '<t:message code="system.label.sales.classficationname" default="분류명"/>'          ,type:'string'}, 
                 {name: 'PLAN_SUM'                  ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'}, 
                 {name: 'MOD_PLAN_SUM'              ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'}, 
                 {name: 'A_D_RATE_SUM'              ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'}, 
                 {name: 'PLAN1'                     ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},      
                 {name: 'MOD_PLAN1'                 ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},      
                 {name: 'A_D_RATE1'                 ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},   
                 {name: 'PLAN2'                     ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},      
                 {name: 'MOD_PLAN2'                 ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},      
                 {name: 'A_D_RATE2'                 ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},   
                 {name: 'PLAN3'                     ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},       
                 {name: 'MOD_PLAN3'                 ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},       
                 {name: 'A_D_RATE3'                 ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},    
                 {name: 'PLAN4'                     ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},       
                 {name: 'MOD_PLAN4'                 ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},       
                 {name: 'A_D_RATE4'                 ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},    
                 {name: 'PLAN5'                     ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},       
                 {name: 'MOD_PLAN5'                 ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},       
                 {name: 'A_D_RATE5'                 ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},    
                 {name: 'PLAN6'                     ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},         
                 {name: 'MOD_PLAN6'                 ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},         
                 {name: 'A_D_RATE6'                 ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},     
                 {name: 'PLAN7'                     ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},         
                 {name: 'MOD_PLAN7'                 ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},         
                 {name: 'A_D_RATE7'                 ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},     
                 {name: 'PLAN8'                     ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},         
                 {name: 'MOD_PLAN8'                 ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},         
                 {name: 'A_D_RATE8'                 ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},     
                 {name: 'PLAN9'                     ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},     
                 {name: 'MOD_PLAN9'                 ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},     
                 {name: 'A_D_RATE9'                 ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'}, 
                 {name: 'PLAN10'                    ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},     
                 {name: 'MOD_PLAN10'                ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},     
                 {name: 'A_D_RATE10'                ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'}, 
                 {name: 'PLAN11'                    ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},     
                 {name: 'MOD_PLAN11'                ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},     
                 {name: 'A_D_RATE11'                ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'}, 
                 {name: 'PLAN12'                    ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},     
                 {name: 'MOD_PLAN12'                ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},     
                 {name: 'A_D_RATE12'                ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'}, 
                 {name: 'UPDATE_DB_USER'            ,text: '<t:message code="system.label.sales.updateuser" default="수정자"/>'          ,type:'string'}, 
                 {name: 'UPDATE_DB_TIME'            ,text: '<t:message code="system.label.sales.updatedate" default="수정일"/>'          ,type:'uniDate'}, 
                 {name: 'COMP_CODE'                 ,text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'        ,type:'string'}
            ]
    });  
    
    Unilite.defineModel('Sgp100ukrvModel10', {
        fields: [{name: 'DIV_CODE'                  ,text: '<t:message code="system.label.sales.division" default="사업장"/>'          ,type:'string'}, 
                 {name: 'PLAN_YEAR'                 ,text: '<t:message code="system.label.sales.planyear" default="계획년도"/>'        ,type:'string'}, 
                 {name: 'PLAN_TYPE1'                ,text: '<t:message code="system.label.sales.domesticclass" default="내수구분"/>'        ,type:'string'}, 
                 {name: 'PLAN_TYPE2'                ,text: '<t:message code="system.label.sales.planclass" default="계획구분"/>'        ,type:'string', defaultValue: '4'}, 
                 {name: 'PLAN_TYPE2_CODE'           ,text: 'PLAN_TYPE2_CODE'        ,type:'string'}, 
                 {name: 'PLAN_TYPE2_CODE2'          ,text: 'PLAN_TYPE2_CODE2'        ,type:'string'}, 
                 {name: 'LEVEL_KIND'                ,text: '<t:message code="system.label.sales.groupcode" default="그룹코드"/>'        ,type:'string'}, 
                 {name: 'MONEY_UNIT'                ,text: '<t:message code="system.label.sales.currencytype" default="환종"/>'            ,type:'string'}, 
                 {name: 'ENT_MONEY_UNIT'            ,text: '<t:message code="system.label.sales.amountunit" default="금액단위"/>'        ,type:'string'}, 
                 {name: 'CONFIRM_YN'                ,text: '<t:message code="system.label.sales.confirmedpending" default="확정여부"/>'        ,type:'string', defaultValue: 'N'}, 
                 {name: 'CUSTOM_CODE'               ,text: '<t:message code="system.label.sales.custom" default="거래처"/>'      ,type:'string', allowBlank: false},                             
            	 {name: 'CUSTOM_NAME'               ,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'        ,type:'string', allowBlank: false},                         
				 {name: 'S_CODE1'                   ,text: '<t:message code="system.label.sales.majorgroup" default="대분류"/>'          ,type:'string', store: Ext.data.StoreManager.lookup('itemLeve1Store') ,child:'ITEM_LEVEL2'}, 
                 {name: 'S_CODE2'                   ,text: '<t:message code="system.label.sales.middlegroup" default="중분류"/>'          ,type:'string', store: Ext.data.StoreManager.lookup('itemLeve2Store') ,child:'ITEM_LEVEL3'},
                 {name: 'S_CODE3'                   ,text: '<t:message code="system.label.sales.minorgroup" default="소분류"/>'          ,type:'string', store: Ext.data.StoreManager.lookup('itemLeve3Store')}, 
                 {name: 'PLAN_SUM'                  ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'}, 
                 {name: 'MOD_PLAN_SUM'              ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'}, 
                 {name: 'A_D_RATE_SUM'              ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'}, 
                 {name: 'PLAN1'                     ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},      
                 {name: 'MOD_PLAN1'                 ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},      
                 {name: 'A_D_RATE1'                 ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},   
                 {name: 'PLAN2'                     ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},      
                 {name: 'MOD_PLAN2'                 ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},      
                 {name: 'A_D_RATE2'                 ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},   
                 {name: 'PLAN3'                     ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},       
                 {name: 'MOD_PLAN3'                 ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},       
                 {name: 'A_D_RATE3'                 ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},    
                 {name: 'PLAN4'                     ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},       
                 {name: 'MOD_PLAN4'                 ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},       
                 {name: 'A_D_RATE4'                 ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},    
                 {name: 'PLAN5'                     ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},       
                 {name: 'MOD_PLAN5'                 ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},       
                 {name: 'A_D_RATE5'                 ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},    
                 {name: 'PLAN6'                     ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},         
                 {name: 'MOD_PLAN6'                 ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},         
                 {name: 'A_D_RATE6'                 ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},     
                 {name: 'PLAN7'                     ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},         
                 {name: 'MOD_PLAN7'                 ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},         
                 {name: 'A_D_RATE7'                 ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},     
                 {name: 'PLAN8'                     ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},         
                 {name: 'MOD_PLAN8'                 ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},         
                 {name: 'A_D_RATE8'                 ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'},     
                 {name: 'PLAN9'                     ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},     
                 {name: 'MOD_PLAN9'                 ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},     
                 {name: 'A_D_RATE9'                 ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'}, 
                 {name: 'PLAN10'                    ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},     
                 {name: 'MOD_PLAN10'                ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},     
                 {name: 'A_D_RATE10'                ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'}, 
                 {name: 'PLAN11'                    ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},     
                 {name: 'MOD_PLAN11'                ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},     
                 {name: 'A_D_RATE11'                ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'}, 
                 {name: 'PLAN12'                    ,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'        ,type:'uniPrice'},     
                 {name: 'MOD_PLAN12'                ,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'        ,type:'uniPrice'},     
                 {name: 'A_D_RATE12'                ,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'          ,type:'uniPercent'}, 
                 {name: 'UPDATE_DB_USER'            ,text: '<t:message code="system.label.sales.updateuser" default="수정자"/>'          ,type:'string'}, 
                 {name: 'UPDATE_DB_TIME'            ,text: '<t:message code="system.label.sales.updatedate" default="수정일"/>'          ,type:'uniDate'}, 
                 {name: 'COMP_CODE'                 ,text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'        ,type:'string'}
            ]
    });   
    
// 엑셀참조
    Unilite.Excel.defineModel('sgp100ukrvModel_1', {
        fields: [
                 {name: 'CUSTOM_CODE'               ,text: '<t:message code="system.label.sales.custom" default="거래처"/>'      ,type:'string', allowBlank: false},                             
            	 {name: 'CUSTOM_NAME'               ,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'    ,type:'string'},                         
				 {name: 'PLAN1'                     ,text: '<t:message code="system.label.sales.yearplan" default="1월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN2'                     ,text: '<t:message code="system.label.sales.yearplan" default="2월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN3'                     ,text: '<t:message code="system.label.sales.yearplan" default="3월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN4'                     ,text: '<t:message code="system.label.sales.yearplan" default="4월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN5'                     ,text: '<t:message code="system.label.sales.yearplan" default="5월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN6'                     ,text: '<t:message code="system.label.sales.yearplan" default="6월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN7'                     ,text: '<t:message code="system.label.sales.yearplan" default="7월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN8'                     ,text: '<t:message code="system.label.sales.yearplan" default="8월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN9'                     ,text: '<t:message code="system.label.sales.yearplan" default="9월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN10'                     ,text: '<t:message code="system.label.sales.yearplan" default="10월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN11'                     ,text: '<t:message code="system.label.sales.yearplan" default="11월"/>'        ,type:'uniPrice'},
                 {name: 'PLAN12'                     ,text: '<t:message code="system.label.sales.yearplan" default="12월"/>'        ,type:'uniPrice'}
                            

        ]
    });
    
    Unilite.Excel.defineModel('sgp100ukrvModel_2', {
        fields: [
                 {name: 'S_CODE'               ,text: '<t:message code="system.label.sales.saleschargecode" default="영엄담당코드"/>'      ,type:'string', allowBlank: false},                             
            	 {name: 'PLAN1'                ,text: '<t:message code="system.label.sales.yearplan" default="1월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN2'                ,text: '<t:message code="system.label.sales.yearplan" default="2월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN3'                ,text: '<t:message code="system.label.sales.yearplan" default="3월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN4'                ,text: '<t:message code="system.label.sales.yearplan" default="4월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN5'                ,text: '<t:message code="system.label.sales.yearplan" default="5월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN6'                ,text: '<t:message code="system.label.sales.yearplan" default="6월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN7'                ,text: '<t:message code="system.label.sales.yearplan" default="7월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN8'                ,text: '<t:message code="system.label.sales.yearplan" default="8월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN9'                ,text: '<t:message code="system.label.sales.yearplan" default="9월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN10'               ,text: '<t:message code="system.label.sales.yearplan" default="10월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN11'               ,text: '<t:message code="system.label.sales.yearplan" default="11월"/>'        ,type:'uniPrice'},
                 {name: 'PLAN12'               ,text: '<t:message code="system.label.sales.yearplan" default="12월"/>'        ,type:'uniPrice'}
                            

        ]
    }); 

    Unilite.Excel.defineModel('sgp100ukrvModel_3', {
        fields: [
                 {name: 'ITEM_CODE'          ,text: '품목코드'        ,type:'string', allowBlank: false},                             
            	 {name: 'ITEM_NAME'          ,text: '품목명'         ,type:'string'},                         
				 {name: 'PLAN_QTY1'            ,text: '1월수량'        ,type:'uniPrice'}, 
				 {name: 'PLAN_AMT1'            ,text: '1월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY2'            ,text: '2월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT2'            ,text: '2월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY3'            ,text: '3월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT3'            ,text: '3월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY4'            ,text: '4월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT4'            ,text: '4월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY5'            ,text: '5월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT5'            ,text: '5월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY6'            ,text: '6월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT6'            ,text: '6월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY7'            ,text: '7월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT7'            ,text: '7월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY8'            ,text: '8월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT8'            ,text: '8월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY9'            ,text: '9월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT9'            ,text: '9월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY10'           ,text: '10월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT10'           ,text: '10월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY11'           ,text: '11월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT11'           ,text: '11월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY12'           ,text: '12월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT12'           ,text: '12월금액'        ,type:'uniQty'}                 
                            

        ]
    }); 
    
    Unilite.Excel.defineModel('sgp100ukrvModel_4', {
        fields: [
                 {name: 'ITEM_LEVEL1'                   ,text: '<t:message code="system.label.sales.majorgroup" default="대분류"/>'           ,type:'string', store: Ext.data.StoreManager.lookup('itemLeve1Store') ,child:'ITEM_LEVEL2'}, 
                 {name: 'ITEM_LEVEL2'                   ,text: '<t:message code="system.label.sales.middlegroup" default="중분류"/>'          ,type:'string', store: Ext.data.StoreManager.lookup('itemLeve2Store') ,child:'ITEM_LEVEL3'}, 
                 {name: 'ITEM_LEVEL3'                   ,text: '<t:message code="system.label.sales.minorgroup" default="소분류"/>'           ,type:'string', store: Ext.data.StoreManager.lookup('itemLeve3Store')}, 
                 {name: 'PLAN1'                     ,text: '<t:message code="system.label.sales.yearplan" default="1월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN2'                     ,text: '<t:message code="system.label.sales.yearplan" default="2월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN3'                     ,text: '<t:message code="system.label.sales.yearplan" default="3월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN4'                     ,text: '<t:message code="system.label.sales.yearplan" default="4월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN5'                     ,text: '<t:message code="system.label.sales.yearplan" default="5월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN6'                     ,text: '<t:message code="system.label.sales.yearplan" default="6월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN7'                     ,text: '<t:message code="system.label.sales.yearplan" default="7월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN8'                     ,text: '<t:message code="system.label.sales.yearplan" default="8월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN9'                     ,text: '<t:message code="system.label.sales.yearplan" default="9월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN10'                     ,text: '<t:message code="system.label.sales.yearplan" default="10월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN11'                     ,text: '<t:message code="system.label.sales.yearplan" default="11월"/>'        ,type:'uniPrice'},
                 {name: 'PLAN12'                     ,text: '<t:message code="system.label.sales.yearplan" default="12월"/>'        ,type:'uniPrice'}
                            

        ]
    });   
    
    Unilite.Excel.defineModel('sgp100ukrvModel_5', {
        fields: [
                 {name: 'ITEM_CODE'          ,text: '대표모델코드'        ,type:'string', allowBlank: false},                             
            	 {name: 'ITEM_NAME'          ,text: '대표모델명'         ,type:'string', allowBlank: false},                         
				 {name: 'PLAN_QTY1'            ,text: '1월수량'        ,type:'uniPrice'}, 
				 {name: 'PLAN_AMT1'            ,text: '1월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY2'            ,text: '2월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT2'            ,text: '2월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY3'            ,text: '3월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT3'            ,text: '3월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY4'            ,text: '4월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT4'            ,text: '4월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY5'            ,text: '5월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT5'            ,text: '5월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY6'            ,text: '6월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT6'            ,text: '6월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY7'            ,text: '7월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT7'            ,text: '7월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY8'            ,text: '8월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT8'            ,text: '8월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY9'            ,text: '9월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT9'            ,text: '9월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY10'           ,text: '10월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT10'           ,text: '10월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY11'           ,text: '11월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT11'           ,text: '11월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY12'           ,text: '12월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT12'           ,text: '12월금액'        ,type:'uniQty'}                 
                            

        ]
    });     
    
    Unilite.Excel.defineModel('sgp100ukrvModel_6', {
        fields: [
                 {name: 'CUSTOM_CODE'               ,text: '고객코드'      ,type:'string', allowBlank: false},                             
            	 {name: 'CUSTOM_NAME'               ,text: '고객명'        ,type:'string'},                         
				 {name: 'ITEM_CODE'                 ,text: '품목코드'      ,type:'string', allowBlank: false},                             
            	 {name: 'ITEM_NAME'                 ,text: '품목명'        ,type:'string'},                         
				 {name: 'PLAN_QTY1'            ,text: '1월수량'        ,type:'uniPrice'}, 
				 {name: 'PLAN_AMT1'            ,text: '1월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY2'            ,text: '2월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT2'            ,text: '2월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY3'            ,text: '3월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT3'            ,text: '3월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY4'            ,text: '4월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT4'            ,text: '4월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY5'            ,text: '5월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT5'            ,text: '5월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY6'            ,text: '6월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT6'            ,text: '6월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY7'            ,text: '7월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT7'            ,text: '7월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY8'            ,text: '8월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT8'            ,text: '8월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY9'            ,text: '9월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT9'            ,text: '9월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY10'           ,text: '10월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT10'           ,text: '10월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY11'           ,text: '11월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT11'           ,text: '11월금액'        ,type:'uniQty'}, 
                 {name: 'PLAN_QTY12'           ,text: '12월수량'        ,type:'uniPrice'}, 
                 {name: 'PLAN_AMT12'           ,text: '12월금액'        ,type:'uniQty'} 
                            

        ]
    });       
         
    
    Unilite.Excel.defineModel('sgp100ukrvModel_7', {
        fields: [
                 {name: 'S_CODE'               ,text: '판매유형코드'      ,type:'string', allowBlank: false},                             
            	 {name: 'PLAN1'                ,text: '<t:message code="system.label.sales.yearplan" default="1월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN2'                ,text: '<t:message code="system.label.sales.yearplan" default="2월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN3'                ,text: '<t:message code="system.label.sales.yearplan" default="3월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN4'                ,text: '<t:message code="system.label.sales.yearplan" default="4월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN5'                ,text: '<t:message code="system.label.sales.yearplan" default="5월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN6'                ,text: '<t:message code="system.label.sales.yearplan" default="6월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN7'                ,text: '<t:message code="system.label.sales.yearplan" default="7월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN8'                ,text: '<t:message code="system.label.sales.yearplan" default="8월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN9'                ,text: '<t:message code="system.label.sales.yearplan" default="9월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN10'               ,text: '<t:message code="system.label.sales.yearplan" default="10월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN11'               ,text: '<t:message code="system.label.sales.yearplan" default="11월"/>'        ,type:'uniPrice'},
                 {name: 'PLAN12'               ,text: '<t:message code="system.label.sales.yearplan" default="12월"/>'        ,type:'uniPrice'}
                            

        ]
    }); 
    
        
    Unilite.Excel.defineModel('sgp100ukrvModel_10', {
        fields: [
                 {name: 'CUSTOM_CODE'               ,text: '<t:message code="system.label.sales.custom" default="거래처"/>'      ,type:'string', allowBlank: false},                             
            	 {name: 'CUSTOM_NAME'               ,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'        ,type:'string'},                         
				 {name: 'S_CODE1'                   ,text: '<t:message code="system.label.sales.majorgroup" default="대분류"/>'           ,type:'string', store: Ext.data.StoreManager.lookup('itemLeve1Store') ,child:'ITEM_LEVEL2'}, 
                 {name: 'S_CODE2'                   ,text: '<t:message code="system.label.sales.middlegroup" default="중분류"/>'          ,type:'string', store: Ext.data.StoreManager.lookup('itemLeve2Store') ,child:'ITEM_LEVEL3'}, 
                 {name: 'S_CODE3'                   ,text: '<t:message code="system.label.sales.minorgroup" default="소분류"/>'           ,type:'string', store: Ext.data.StoreManager.lookup('itemLeve3Store')}, 
                 {name: 'PLAN1'                     ,text: '<t:message code="system.label.sales.yearplan" default="1월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN2'                     ,text: '<t:message code="system.label.sales.yearplan" default="2월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN3'                     ,text: '<t:message code="system.label.sales.yearplan" default="3월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN4'                     ,text: '<t:message code="system.label.sales.yearplan" default="4월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN5'                     ,text: '<t:message code="system.label.sales.yearplan" default="5월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN6'                     ,text: '<t:message code="system.label.sales.yearplan" default="6월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN7'                     ,text: '<t:message code="system.label.sales.yearplan" default="7월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN8'                     ,text: '<t:message code="system.label.sales.yearplan" default="8월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN9'                     ,text: '<t:message code="system.label.sales.yearplan" default="9월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN10'                     ,text: '<t:message code="system.label.sales.yearplan" default="10월"/>'        ,type:'uniPrice'}, 
                 {name: 'PLAN11'                     ,text: '<t:message code="system.label.sales.yearplan" default="11월"/>'        ,type:'uniPrice'},
                 {name: 'PLAN12'                     ,text: '<t:message code="system.label.sales.yearplan" default="12월"/>'        ,type:'uniPrice'}
                            

        ]
    });
        
        
    function openExcelWindow1() {
        var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.ExcelUploadWin';
        
		//필수 입력정보 체크
		if (!panelResult.getInvalidMessage()) {
			return false;
		}
		if(customMasterStore.isDirty())	{									//화면에 저장할 내용이 있을 경우 저장여부 확인
			if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
				UniAppManager.app.onSaveDataButtonDown();
				return;
			}else {
			}
		}

        if(!Ext.isEmpty(excelWindow1)){
            excelWindow1.extParam.DIV_CODE = panelSearch.getValue('DIV_CODE');
        }
        if(!excelWindow1) {
            excelWindow1 =  Ext.WindowMgr.get(appName);
            excelWindow1 = Ext.create( appName, {
                modal: false,
                excelConfigName: 'sgp100ukrv_1',
                extParam: {
                    'PGM_ID': 'sgp100ukrv_1',
                    'DIV_CODE'  : panelSearch.getValue('DIV_CODE'),
                    'PLAN_YEAR' : panelSearch.getValue('PLAN_YEAR'),
                    'ORDER_TYPE' : panelSearch.getValue('ORDER_TYPE'),
                    'MONEY_UNIT' : panelSearch.getValue('MONEY_UNIT')
                    
                },
                grids: [{
                    itemId: 'grid01',
                    title: '고객별판매계획엑셀참조',
                    useCheckbox: true,
                    model : 'sgp100ukrvModel_1',
                    readApi: 'sgp100ukrvService.selectExcelUploadSheet1',
                    columns: [

                        {dataIndex: 'CUSTOM_CODE'      ,       width: 100},
                        {dataIndex: 'CUSTOM_NAME'      ,       width: 250},
                        {dataIndex: 'PLAN1'            ,       width: 100},
                        {dataIndex: 'PLAN2'            ,       width: 100},
                        {dataIndex: 'PLAN3'            ,       width: 100},
                        {dataIndex: 'PLAN4'            ,       width: 100},
                        {dataIndex: 'PLAN5'            ,       width: 100},
                        {dataIndex: 'PLAN6'            ,       width: 100},
                        {dataIndex: 'PLAN7'            ,       width: 100},
                        {dataIndex: 'PLAN8'            ,       width: 100},
                        {dataIndex: 'PLAN9'            ,       width: 100},
                        {dataIndex: 'PLAN10'           ,       width: 100},
                        {dataIndex: 'PLAN11'           ,       width: 100},
                        {dataIndex: 'PLAN12'           ,       width: 100}
                    ]
                }],
                listeners: {
					beforeshow: function( panel, eOpts ) {
						this.down('#grid01').getStore().sort({property : '_EXCEL_ROWNUM', direction: 'ASC'});
					},
					beforehide: function(me, eOpt) {
						var me		= this;
						var grid	= this.down('#grid01');
						excelWindow1.getEl().unmask();
						grid.getStore().removeAll();
					},
					close: function() {
						var me		= this;
						var grid	= this.down('#grid01');
						excelWindow1.getEl().unmask();
						grid.getStore().removeAll();						
						this.hide();
					}
                },                 
				onApply:function() {
					
                	var flag = true
                    var grid = this.down('#grid01');
                    var records =  grid.getStore().data.items;
                    var selectedrecords = grid.getSelectionModel().getSelection();
                    
                    if(selectedrecords.length > 0){
	                    Ext.each(records, function(record,i){
	                    	if(record.get('_EXCEL_HAS_ERROR') == 'Y') {
								console.log("_EXCEL_HAS_ERROR : ", record.get('_EXCEL_HAS_ERROR'));
								flag = false;
								return false;
							}
	                    });
	
						if(!flag){
							Ext.MessageBox.show({
								msg : '고객코드에러가 있는 행은 적용시 제외됩니다.' ,
								icon: Ext.Msg.WARNING,
								buttons : Ext.MessageBox.OKCANCEL,
								fn : function(buttonId) {
									switch (buttonId) {
										case 'ok' :
	//										var records = grid.getSelectionModel().getSelection();
											customMasterGrid.store.loadData({});
						
						                    var beforeRM = grid.getStore().count();
						                    grid.getStore().remove(selectedrecords);
						                    var afterRM = grid.getStore().count();
						                    if (beforeRM > 0 && afterRM == 0){
						                       excelWindow1.close();
						                    }
						                    customMasterGrid.setExcelData(selectedrecords);	
											break;
										case 'cancel' :
											break;
									}
								},
								scope : this
							}); // MessageBox
							
						}else{
	//						var records = grid.getSelectionModel().getSelection(); 
							customMasterGrid.store.loadData({});
		                    var beforeRM = grid.getStore().count();
		                    grid.getStore().remove(selectedrecords);
		                    var afterRM = grid.getStore().count();
		                    if (beforeRM > 0 && afterRM == 0){
		                       excelWindow1.close();
		                    }	
	                        customMasterGrid.setExcelData(selectedrecords);		                       
						}
                    }
					
				} 
             });
        }
        excelWindow1.center();
        excelWindow1.show();
    }   
    
    function openExcelWindow2() {
        var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.ExcelUploadWin';
        
		//필수 입력정보 체크
		if (!panelResult.getInvalidMessage()) {
			return false;
		}
		if(salePrsnMasterStore.isDirty())	{									//화면에 저장할 내용이 있을 경우 저장여부 확인
			if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
				UniAppManager.app.onSaveDataButtonDown();
				return;
			}else {
			}
		}

        if(!Ext.isEmpty(excelWindow2)){
            excelWindow2.extParam.DIV_CODE = panelSearch.getValue('DIV_CODE');
        }
        if(!excelWindow2) {
            excelWindow2 =  Ext.WindowMgr.get(appName);
            excelWindow2 = Ext.create( appName, {
                modal: false,
                excelConfigName: 'sgp100ukrv_2',
                extParam: {
                    'PGM_ID': 'sgp100ukrv_2',
                    'DIV_CODE'  : panelSearch.getValue('DIV_CODE'),
                    'PLAN_YEAR' : panelSearch.getValue('PLAN_YEAR'),
                    'ORDER_TYPE' : panelSearch.getValue('ORDER_TYPE'),
                    'MONEY_UNIT' : panelSearch.getValue('MONEY_UNIT')
                    
                },
                grids: [{
                    itemId: 'grid02',
                    title: '영업담당별판매계획엑셀참조',
                    useCheckbox: true,
                    model : 'sgp100ukrvModel_2',
                    readApi: 'sgp100ukrvService.selectExcelUploadSheet2',
                    columns: [

                        {dataIndex: 'S_CODE'           ,       width: 100},
                        {dataIndex: 'PLAN1'            ,       width: 100},
                        {dataIndex: 'PLAN2'            ,       width: 100},
                        {dataIndex: 'PLAN3'            ,       width: 100},
                        {dataIndex: 'PLAN4'            ,       width: 100},
                        {dataIndex: 'PLAN5'            ,       width: 100},
                        {dataIndex: 'PLAN6'            ,       width: 100},
                        {dataIndex: 'PLAN7'            ,       width: 100},
                        {dataIndex: 'PLAN8'            ,       width: 100},
                        {dataIndex: 'PLAN9'            ,       width: 100},
                        {dataIndex: 'PLAN10'           ,       width: 100},
                        {dataIndex: 'PLAN11'           ,       width: 100},
                        {dataIndex: 'PLAN12'           ,       width: 100}
                    ]
                }],
                listeners: {
					beforeshow: function( panel, eOpts ) {
						this.down('#grid02').getStore().sort({property : '_EXCEL_ROWNUM', direction: 'ASC'});
					},
					beforehide: function(me, eOpt) {
						var me		= this;
						var grid	= this.down('#grid02');
						excelWindow2.getEl().unmask();
						grid.getStore().removeAll();
					},
					close: function() {
						var me		= this;
						var grid	= this.down('#grid02');
						excelWindow2.getEl().unmask();
						grid.getStore().removeAll();						
						this.hide();
					}
                },                 
				onApply:function() {
					
                	var flag = true
                    var grid = this.down('#grid02');
                    var records =  grid.getStore().data.items;
                    var selectedrecords = grid.getSelectionModel().getSelection();
                    
                    if(selectedrecords.length > 0){
	                    Ext.each(records, function(record,i){
	                    	if(record.get('_EXCEL_HAS_ERROR') == 'Y') {
								console.log("_EXCEL_HAS_ERROR : ", record.get('_EXCEL_HAS_ERROR'));
								flag = false;
								return false;
							}
	                    });
	
						if(!flag){
							Ext.MessageBox.show({
								msg : '영업담당코드에러가 있는 행은 적용시 제외됩니다.' ,
								icon: Ext.Msg.WARNING,
								buttons : Ext.MessageBox.OKCANCEL,
								fn : function(buttonId) {
									switch (buttonId) {
										case 'ok' :
	//										var records = grid.getSelectionModel().getSelection();
											salePrsnMasterGrid.store.loadData({});
						
						                    var beforeRM = grid.getStore().count();
						                    grid.getStore().remove(selectedrecords);
						                    var afterRM = grid.getStore().count();
						                    if (beforeRM > 0 && afterRM == 0){
						                       excelWindow2.close();
						                    }
						                    salePrsnMasterGrid.setExcelData(selectedrecords);	
											break;
										case 'cancel' :
											break;
									}
								},
								scope : this
							}); // MessageBox
							
						}else{
	//						var records = grid.getSelectionModel().getSelection(); 
							salePrsnMasterGrid.store.loadData({});
		                    var beforeRM = grid.getStore().count();
		                    grid.getStore().remove(selectedrecords);
		                    var afterRM = grid.getStore().count();
		                    if (beforeRM > 0 && afterRM == 0){
		                       excelWindow2.close();
		                    }	
	                        salePrsnMasterGrid.setExcelData(selectedrecords);		                       
						}
                    }
					
				} 
             });
        }
        excelWindow2.center();
        excelWindow2.show();
    } 
    
    function openExcelWindow3() {
        var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.ExcelUploadWin';
        
		//필수 입력정보 체크
		if (!panelResult.getInvalidMessage()) {
			return false;
		}
		if(itemMasterStore.isDirty())	{									//화면에 저장할 내용이 있을 경우 저장여부 확인
			if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
				UniAppManager.app.onSaveDataButtonDown();
				return;
			}else {
			}
		}

        if(!Ext.isEmpty(excelWindow3)){
            excelWindow3.extParam.DIV_CODE = panelSearch.getValue('DIV_CODE');
        }
        if(!excelWindow3) {
            excelWindow3 =  Ext.WindowMgr.get(appName);
            excelWindow3 = Ext.create( appName, {
                modal: false,
                excelConfigName: 'sgp100ukrv_3',
                extParam: {
                    'PGM_ID': 'sgp100ukrv_3',
                    'DIV_CODE'  : panelSearch.getValue('DIV_CODE'),
                    'PLAN_YEAR' : panelSearch.getValue('PLAN_YEAR'),
                    'ORDER_TYPE' : panelSearch.getValue('ORDER_TYPE'),
                    'MONEY_UNIT' : panelSearch.getValue('MONEY_UNIT')
                    
                },
                grids: [{
                    itemId: 'grid03',
                    title: '품목별판매계획엑셀참조',
                    useCheckbox: true,
                    model : 'sgp100ukrvModel_3',
                    readApi: 'sgp100ukrvService.selectExcelUploadSheet3',
                    columns: [

                        {dataIndex: 'ITEM_CODE'      ,       width: 100},
                        {dataIndex: 'ITEM_NAME'      ,       width: 250},
                        {dataIndex: 'PLAN_QTY1'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT1'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY2'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT2'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY3'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT3'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY4'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT4'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY5'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT5'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY6'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT6'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY7'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT7'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY8'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT8'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY9'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT9'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY10'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT10'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY11'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT11'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY12'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT12'            ,       width: 100}                      
                    ]
                }],
                listeners: {
					beforeshow: function( panel, eOpts ) {
						this.down('#grid03').getStore().sort({property : '_EXCEL_ROWNUM', direction: 'ASC'});
					},
					beforehide: function(me, eOpt) {
						var me		= this;
						var grid	= this.down('#grid03');
						excelWindow3.getEl().unmask();
						grid.getStore().removeAll();
					},
					close: function() {
						var me		= this;
						var grid	= this.down('#grid03');
						excelWindow3.getEl().unmask();
						grid.getStore().removeAll();						
						this.hide();
					}
                },                 
				onApply:function() {
					
                	var flag = true
                    var grid = this.down('#grid03');
                    var records =  grid.getStore().data.items;
                    var selectedrecords = grid.getSelectionModel().getSelection();
                    
                    if(selectedrecords.length > 0){
	                    Ext.each(records, function(record,i){
	                    	if(record.get('_EXCEL_HAS_ERROR') == 'Y') {
								console.log("_EXCEL_HAS_ERROR : ", record.get('_EXCEL_HAS_ERROR'));
								flag = false;
								return false;
							}
	                    });
	
						if(!flag){
							Ext.MessageBox.show({
								msg : '품목코드에러가 있는 행은 적용시 제외됩니다.' ,
								icon: Ext.Msg.WARNING,
								buttons : Ext.MessageBox.OKCANCEL,
								fn : function(buttonId) {
									switch (buttonId) {
										case 'ok' :
	//										var records = grid.getSelectionModel().getSelection();
											itemMasterGrid.store.loadData({});
						
						                    var beforeRM = grid.getStore().count();
						                    grid.getStore().remove(selectedrecords);
						                    var afterRM = grid.getStore().count();
						                    if (beforeRM > 0 && afterRM == 0){
						                       excelWindow3.close();
						                    }
						                    itemMasterGrid.setExcelData(selectedrecords);	
											break;
										case 'cancel' :
											break;
									}
								},
								scope : this
							}); // MessageBox
							
						}else{
	//						var records = grid.getSelectionModel().getSelection(); 
							itemMasterGrid.store.loadData({});
		                    var beforeRM = grid.getStore().count();
		                    grid.getStore().remove(selectedrecords);
		                    var afterRM = grid.getStore().count();
		                    if (beforeRM > 0 && afterRM == 0){
		                       excelWindow3.close();
		                    }	
	                        itemMasterGrid.setExcelData(selectedrecords);		                       
						}
                    }
					
				} 
             });
        }
        excelWindow3.center();
        excelWindow3.show();
    } 
    
    function openExcelWindow4() {
        var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.ExcelUploadWin';
        
		//필수 입력정보 체크
		if (!panelResult.getInvalidMessage()) {
			return false;
		}
		if(itemSortMasterStore.isDirty())	{									//화면에 저장할 내용이 있을 경우 저장여부 확인
			if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
				UniAppManager.app.onSaveDataButtonDown();
				return;
			}else {
			}
		}
		
        var excelItemLevel = Ext.getCmp('ITEM_LEVEL_ID').getChecked()[0].inputValue;
        var scode1Hidden = false;
        var scode2Hidden = true;
        var scode3Hidden = true;
        
        if(excelItemLevel == '1'){
	        scode1Hidden = false;
	        scode2Hidden = true;
	        scode3Hidden = true;        
        	
        }else if(excelItemLevel == '2'){
	        scode1Hidden = true;
	        scode2Hidden = false;
	        scode3Hidden = true;         	
        	
        }else{
	        scode1Hidden = true;
	        scode2Hidden = true;
	        scode3Hidden = false;         	
        	
        }

        if(!Ext.isEmpty(excelWindow4)){
            excelWindow4.extParam.DIV_CODE = panelSearch.getValue('DIV_CODE');
        }
        if(!excelWindow4) {
            excelWindow4 =  Ext.WindowMgr.get(appName);
            excelWindow4 = Ext.create( appName, {
                modal: false,
                excelConfigName: 'sgp100ukrv_4',
                extParam: {
                    'PGM_ID': 'sgp100ukrv_4',
                    'DIV_CODE'  : panelSearch.getValue('DIV_CODE'),
                    'ITEM_LEVEL' : excelItemLevel, 
                    'PLAN_YEAR' : panelSearch.getValue('PLAN_YEAR'),
                    'ORDER_TYPE' : panelSearch.getValue('ORDER_TYPE'),
                    'MONEY_UNIT' : panelSearch.getValue('MONEY_UNIT')
                    
                },
                grids: [{
                    itemId: 'grid04',
                    title: '품목분류별판매계획엑셀참조',
                    useCheckbox: true,
                    model : 'sgp100ukrvModel_4',
                    readApi: 'sgp100ukrvService.selectExcelUploadSheet4',
                    columns: [

                        {dataIndex: 'ITEM_LEVEL1'          ,       width: 80, hidden: scode1Hidden},
                        {dataIndex: 'ITEM_LEVEL2'          ,       width: 80, hidden: scode2Hidden},
                        {dataIndex: 'ITEM_LEVEL3'          ,       width: 80, hidden: scode3Hidden},
                        {dataIndex: 'PLAN1'            ,       width: 100},
                        {dataIndex: 'PLAN2'            ,       width: 100},
                        {dataIndex: 'PLAN3'            ,       width: 100},
                        {dataIndex: 'PLAN4'            ,       width: 100},
                        {dataIndex: 'PLAN5'            ,       width: 100},
                        {dataIndex: 'PLAN6'            ,       width: 100},
                        {dataIndex: 'PLAN7'            ,       width: 100},
                        {dataIndex: 'PLAN8'            ,       width: 100},
                        {dataIndex: 'PLAN9'            ,       width: 100},
                        {dataIndex: 'PLAN10'           ,       width: 100},
                        {dataIndex: 'PLAN11'           ,       width: 100},
                        {dataIndex: 'PLAN12'           ,       width: 100}
                    ]
                }],
                listeners: {
					beforeshow: function( panel, eOpts ) {
						this.down('#grid04').getStore().sort({property : '_EXCEL_ROWNUM', direction: 'ASC'});
					},
					beforehide: function(me, eOpt) {
						var me		= this;
						var grid	= this.down('#grid04');
						excelWindow4.getEl().unmask();
						grid.getStore().removeAll();
					},
					close: function() {
						var me		= this;
						var grid	= this.down('#grid04');
						excelWindow4.getEl().unmask();
						grid.getStore().removeAll();						
						this.hide();
					}
                },                 
				onApply:function() {
					
                	var flag = true
                    var grid = this.down('#grid04');
                    var records =  grid.getStore().data.items;
                    var selectedrecords = grid.getSelectionModel().getSelection();
                    
                    if(selectedrecords.length > 0){
	                    Ext.each(records, function(record,i){
	                    	if(record.get('_EXCEL_HAS_ERROR') == 'Y') {
								console.log("_EXCEL_HAS_ERROR : ", record.get('_EXCEL_HAS_ERROR'));
								flag = false;
								return false;
							}
	                    });
	
						if(!flag){
							Ext.MessageBox.show({
								msg : '(고객코드오류/분류코드오류/이미 확정된 판매계획건이 존재)에러가 있는 행은 적용시 제외됩니다.' ,
								icon: Ext.Msg.WARNING,
								buttons : Ext.MessageBox.OKCANCEL,
								fn : function(buttonId) {
									switch (buttonId) {
										case 'ok' :
	//										var records = grid.getSelectionModel().getSelection();
											itemSortMasterGrid.store.loadData({});
						
						                    var beforeRM = grid.getStore().count();
						                    grid.getStore().remove(selectedrecords);
						                    var afterRM = grid.getStore().count();
						                    if (beforeRM > 0 && afterRM == 0){
						                       excelWindow4.close();
						                    }
						                    itemSortMasterGrid.setExcelData(selectedrecords);	
											break;
										case 'cancel' :
											break;
									}
								},
								scope : this
							}); // MessageBox
							
						}else{
	//						var records = grid.getSelectionModel().getSelection(); 
							itemSortMasterGrid.store.loadData({});
		                    var beforeRM = grid.getStore().count();
		                    grid.getStore().remove(selectedrecords);
		                    var afterRM = grid.getStore().count();
		                    if (beforeRM > 0 && afterRM == 0){
		                       excelWindow4.close();
		                    }	
	                        itemSortMasterGrid.setExcelData(selectedrecords);		                       
						}
                    }
					
				} 
             });
        }
        excelWindow4.center();
        excelWindow4.show();
    }    
    
   function openExcelWindow5() {
        var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.ExcelUploadWin';
        
		//필수 입력정보 체크
		if (!panelResult.getInvalidMessage()) {
			return false;
		}
		if(spokesItemMasterStore.isDirty())	{									//화면에 저장할 내용이 있을 경우 저장여부 확인
			if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
				UniAppManager.app.onSaveDataButtonDown();
				return;
			}else {
			}
		}

        if(!Ext.isEmpty(excelWindow5)){
            excelWindow5.extParam.DIV_CODE = panelSearch.getValue('DIV_CODE');
        }
        if(!excelWindow5) {
            excelWindow5 =  Ext.WindowMgr.get(appName);
            excelWindow5 = Ext.create( appName, {
                modal: false,
                excelConfigName: 'sgp100ukrv_5',
                extParam: {
                    'PGM_ID': 'sgp100ukrv_5',
                    'DIV_CODE'  : panelSearch.getValue('DIV_CODE'),
                    'PLAN_YEAR' : panelSearch.getValue('PLAN_YEAR'),
                    'ORDER_TYPE' : panelSearch.getValue('ORDER_TYPE'),
                    'MONEY_UNIT' : panelSearch.getValue('MONEY_UNIT')
                    
                },
                grids: [{
                    itemId: 'grid05',
                    title: '대표모델별판매계획엑셀참조',
                    useCheckbox: true,
                    model : 'sgp100ukrvModel_5',
                    readApi: 'sgp100ukrvService.selectExcelUploadSheet5',
                    columns: [

                        {dataIndex: 'ITEM_CODE'      ,       width: 100},
                        {dataIndex: 'ITEM_NAME'      ,       width: 250},
                        {dataIndex: 'PLAN_QTY1'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT1'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY2'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT2'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY3'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT3'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY4'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT4'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY5'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT5'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY6'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT6'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY7'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT7'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY8'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT8'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY9'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT9'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY10'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT10'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY11'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT11'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY12'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT12'            ,       width: 100}                      
                    ]
                }],
                listeners: {
					beforeshow: function( panel, eOpts ) {
						this.down('#grid05').getStore().sort({property : '_EXCEL_ROWNUM', direction: 'ASC'});
					},
					beforehide: function(me, eOpt) {
						var me		= this;
						var grid	= this.down('#grid05');
						excelWindow5.getEl().unmask();
						grid.getStore().removeAll();
					},
					close: function() {
						var me		= this;
						var grid	= this.down('#grid05');
						excelWindow5.getEl().unmask();
						grid.getStore().removeAll();						
						this.hide();
					}
                },                 
				onApply:function() {
					
                	var flag = true
                    var grid = this.down('#grid05');
                    var records =  grid.getStore().data.items;
                    var selectedrecords = grid.getSelectionModel().getSelection();
                    
                    if(selectedrecords.length > 0){
	                    Ext.each(records, function(record,i){
	                    	if(record.get('_EXCEL_HAS_ERROR') == 'Y') {
								console.log("_EXCEL_HAS_ERROR : ", record.get('_EXCEL_HAS_ERROR'));
								flag = false;
								return false;
							}
	                    });
	
						if(!flag){
							Ext.MessageBox.show({
								msg : '품목코드에러가 있는 행은 적용시 제외됩니다.' ,
								icon: Ext.Msg.WARNING,
								buttons : Ext.MessageBox.OKCANCEL,
								fn : function(buttonId) {
									switch (buttonId) {
										case 'ok' :
	//										var records = grid.getSelectionModel().getSelection();
											spokesItemMasterGrid.store.loadData({});
						
						                    var beforeRM = grid.getStore().count();
						                    grid.getStore().remove(selectedrecords);
						                    var afterRM = grid.getStore().count();
						                    if (beforeRM > 0 && afterRM == 0){
						                       excelWindow5.close();
						                    }
						                    spokesItemMasterGrid.setExcelData(selectedrecords);	
											break;
										case 'cancel' :
											break;
									}
								},
								scope : this
							}); // MessageBox
							
						}else{
	//						var records = grid.getSelectionModel().getSelection(); 
							spokesItemMasterGrid.store.loadData({});
		                    var beforeRM = grid.getStore().count();
		                    grid.getStore().remove(selectedrecords);
		                    var afterRM = grid.getStore().count();
		                    if (beforeRM > 0 && afterRM == 0){
		                       excelWindow5.close();
		                    }	
	                        spokesItemMasterGrid.setExcelData(selectedrecords);		                       
						}
                    }
					
				} 
             });
        }
        excelWindow5.center();
        excelWindow5.show();
    } 
        
    
    function openExcelWindow6() {
        var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.ExcelUploadWin';
        
		//필수 입력정보 체크
		if (!panelResult.getInvalidMessage()) {
			return false;
		}
		if(customerItemMasterStore.isDirty())	{									//화면에 저장할 내용이 있을 경우 저장여부 확인
			if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
				UniAppManager.app.onSaveDataButtonDown();
				return;
			}else {
			}
		}

        if(!Ext.isEmpty(excelWindow6)){
            excelWindow6.extParam.DIV_CODE = panelSearch.getValue('DIV_CODE');
        }
        if(!excelWindow6) {
            excelWindow6 =  Ext.WindowMgr.get(appName);
            excelWindow6 = Ext.create( appName, {
                modal: false,
                excelConfigName: 'sgp100ukrv_6',
                extParam: {
                    'PGM_ID': 'sgp100ukrv_6',
                    'DIV_CODE'  : panelSearch.getValue('DIV_CODE'),
                    'PLAN_YEAR' : panelSearch.getValue('PLAN_YEAR'),
                    'ORDER_TYPE' : panelSearch.getValue('ORDER_TYPE'),
                    'MONEY_UNIT' : panelSearch.getValue('MONEY_UNIT')
                    
                },
                grids: [{
                    itemId: 'grid06',
                    title: '고객품목별판매계획엑셀참조',
                    useCheckbox: true,
                    model : 'sgp100ukrvModel_6',
                    readApi: 'sgp100ukrvService.selectExcelUploadSheet6',
                    columns: [
                        {dataIndex: 'CUSTOM_CODE'      ,       width: 100},
                        {dataIndex: 'CUSTOM_NAME'      ,       width: 250},
                        {dataIndex: 'ITEM_CODE'           ,       width: 100},
                        {dataIndex: 'ITEM_NAME'           ,       width: 250},
                        {dataIndex: 'PLAN_QTY1'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT1'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY2'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT2'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY3'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT3'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY4'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT4'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY5'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT5'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY6'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT6'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY7'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT7'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY8'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT8'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY9'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT9'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY10'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT10'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY11'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT11'            ,       width: 100},
                        {dataIndex: 'PLAN_QTY12'            ,       width: 100},
                        {dataIndex: 'PLAN_AMT12'            ,       width: 100} 
                    ]
                }],
                listeners: {
					beforeshow: function( panel, eOpts ) {
						this.down('#grid06').getStore().sort({property : '_EXCEL_ROWNUM', direction: 'ASC'});
					},
					beforehide: function(me, eOpt) {
						var me		= this;
						var grid	= this.down('#grid06');
						excelWindow6.getEl().unmask();
						grid.getStore().removeAll();
					},
					close: function() {
						var me		= this;
						var grid	= this.down('#grid06');
						excelWindow6.getEl().unmask();
						grid.getStore().removeAll();						
						this.hide();
					}
                },                 
				onApply:function() {
					
                	var flag = true
                    var grid = this.down('#grid06');
                    var records =  grid.getStore().data.items;
                    var selectedrecords = grid.getSelectionModel().getSelection();
                    
                    if(selectedrecords.length > 0){
	                    Ext.each(records, function(record,i){
	                    	if(record.get('_EXCEL_HAS_ERROR') == 'Y') {
								console.log("_EXCEL_HAS_ERROR : ", record.get('_EXCEL_HAS_ERROR'));
								flag = false;
								return false;
							}
	                    });
	
						if(!flag){
							Ext.MessageBox.show({
								msg : '품목코드에러가 있는 행은 적용시 제외됩니다.' ,
								icon: Ext.Msg.WARNING,
								buttons : Ext.MessageBox.OKCANCEL,
								fn : function(buttonId) {
									switch (buttonId) {
										case 'ok' :
	//										var records = grid.getSelectionModel().getSelection();
											customerItemMasterGrid.store.loadData({});
						
						                    var beforeRM = grid.getStore().count();
						                    grid.getStore().remove(selectedrecords);
						                    var afterRM = grid.getStore().count();
						                    if (beforeRM > 0 && afterRM == 0){
						                       excelWindow6.close();
						                    }
						                    customerItemMasterGrid.setExcelData(selectedrecords);	
											break;
										case 'cancel' :
											break;
									}
								},
								scope : this
							}); // MessageBox
							
						}else{
	//						var records = grid.getSelectionModel().getSelection(); 
							customerItemMasterGrid.store.loadData({});
		                    var beforeRM = grid.getStore().count();
		                    grid.getStore().remove(selectedrecords);
		                    var afterRM = grid.getStore().count();
		                    if (beforeRM > 0 && afterRM == 0){
		                       excelWindow6.close();
		                    }	
	                        customerItemMasterGrid.setExcelData(selectedrecords);		                       
						}
                    }
					
				} 
             });
        }
        excelWindow6.center();
        excelWindow6.show();
    }   
    
    function openExcelWindow7() {
        var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.ExcelUploadWin';
        
		//필수 입력정보 체크
		if (!panelResult.getInvalidMessage()) {
			return false;
		}
		if(saleTypeStore.isDirty())	{									//화면에 저장할 내용이 있을 경우 저장여부 확인
			if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
				UniAppManager.app.onSaveDataButtonDown();
				return;
			}else {
			}
		}

        if(!Ext.isEmpty(excelWindow7)){
            excelWindow7.extParam.DIV_CODE = panelSearch.getValue('DIV_CODE');
        }
        if(!excelWindow7) {
            excelWindow7 =  Ext.WindowMgr.get(appName);
            excelWindow7 = Ext.create( appName, {
                modal: false,
                excelConfigName: 'sgp100ukrv_7',
                extParam: {
                    'PGM_ID': 'sgp100ukrv_7',
                    'DIV_CODE'  : panelSearch.getValue('DIV_CODE'),
                    'PLAN_YEAR' : panelSearch.getValue('PLAN_YEAR'),
                    'ORDER_TYPE' : panelSearch.getValue('ORDER_TYPE'),
                    'MONEY_UNIT' : panelSearch.getValue('MONEY_UNIT')
                    
                },
                grids: [{
                    itemId: 'grid07',
                    title: '판매유형별판매계획엑셀참조',
                    useCheckbox: true,
                    model : 'sgp100ukrvModel_7',
                    readApi: 'sgp100ukrvService.selectExcelUploadSheet7',
                    columns: [

                        {dataIndex: 'S_CODE'           ,       width: 100},
                        {dataIndex: 'PLAN1'            ,       width: 100},
                        {dataIndex: 'PLAN2'            ,       width: 100},
                        {dataIndex: 'PLAN3'            ,       width: 100},
                        {dataIndex: 'PLAN4'            ,       width: 100},
                        {dataIndex: 'PLAN5'            ,       width: 100},
                        {dataIndex: 'PLAN6'            ,       width: 100},
                        {dataIndex: 'PLAN7'            ,       width: 100},
                        {dataIndex: 'PLAN8'            ,       width: 100},
                        {dataIndex: 'PLAN9'            ,       width: 100},
                        {dataIndex: 'PLAN10'           ,       width: 100},
                        {dataIndex: 'PLAN11'           ,       width: 100},
                        {dataIndex: 'PLAN12'           ,       width: 100}
                    ]
                }],
                listeners: {
					beforeshow: function( panel, eOpts ) {
						this.down('#grid07').getStore().sort({property : '_EXCEL_ROWNUM', direction: 'ASC'});
					},
					beforehide: function(me, eOpt) {
						var me		= this;
						var grid	= this.down('#grid07');
						excelWindow7.getEl().unmask();
						grid.getStore().removeAll();
					},
					close: function() {
						var me		= this;
						var grid	= this.down('#grid07');
						excelWindow7.getEl().unmask();
						grid.getStore().removeAll();						
						this.hide();
					}
                },                 
				onApply:function() {
					
                	var flag = true
                    var grid = this.down('#grid07');
                    var records =  grid.getStore().data.items;
                    var selectedrecords = grid.getSelectionModel().getSelection();
                    
                    if(selectedrecords.length > 0){
	                    Ext.each(records, function(record,i){
	                    	if(record.get('_EXCEL_HAS_ERROR') == 'Y') {
								console.log("_EXCEL_HAS_ERROR : ", record.get('_EXCEL_HAS_ERROR'));
								flag = false;
								return false;
							}
	                    });
	
						if(!flag){
							Ext.MessageBox.show({
								msg : '영업담당코드에러가 있는 행은 적용시 제외됩니다.' ,
								icon: Ext.Msg.WARNING,
								buttons : Ext.MessageBox.OKCANCEL,
								fn : function(buttonId) {
									switch (buttonId) {
										case 'ok' :
	//										var records = grid.getSelectionModel().getSelection();
											saleTypeGrid.store.loadData({});
						
						                    var beforeRM = grid.getStore().count();
						                    grid.getStore().remove(selectedrecords);
						                    var afterRM = grid.getStore().count();
						                    if (beforeRM > 0 && afterRM == 0){
						                       excelWindow7.close();
						                    }
						                    saleTypeGrid.setExcelData(selectedrecords);	
											break;
										case 'cancel' :
											break;
									}
								},
								scope : this
							}); // MessageBox
							
						}else{
	//						var records = grid.getSelectionModel().getSelection(); 
							saleTypeGrid.store.loadData({});
		                    var beforeRM = grid.getStore().count();
		                    grid.getStore().remove(selectedrecords);
		                    var afterRM = grid.getStore().count();
		                    if (beforeRM > 0 && afterRM == 0){
		                       excelWindow7.close();
		                    }	
	                        saleTypeGrid.setExcelData(selectedrecords);		                       
						}
                    }
					
				} 
             });
        }
        excelWindow7.center();
        excelWindow7.show();
    } 
        
    

    function openExcelWindow10() {
        var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.ExcelUploadWin';
        
		//필수 입력정보 체크
		if (!panelResult.getInvalidMessage()) {
			return false;
		}
		if(customitemSortMasterStore.isDirty())	{									//화면에 저장할 내용이 있을 경우 저장여부 확인
			if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
				UniAppManager.app.onSaveDataButtonDown();
				return;
			}else {
			}
		}
		
        var excelItemLevel = Ext.getCmp('CUSTOM_ITEM_LEVEL_ID').getChecked()[0].inputValue;
        var scode1Hidden = false;
        var scode2Hidden = true;
        var scode3Hidden = true;
        
        if(excelItemLevel == '1'){
	        scode1Hidden = false;
	        scode2Hidden = true;
	        scode3Hidden = true;        
        	
        }else if(excelItemLevel == '2'){
	        scode1Hidden = true;
	        scode2Hidden = false;
	        scode3Hidden = true;         	
        	
        }else{
	        scode1Hidden = true;
	        scode2Hidden = true;
	        scode3Hidden = false;         	
        	
        }

        if(!Ext.isEmpty(excelWindow10)){
            excelWindow10.extParam.DIV_CODE = panelSearch.getValue('DIV_CODE');
        }
        if(!excelWindow10) {
            excelWindow10 =  Ext.WindowMgr.get(appName);
            excelWindow10 = Ext.create( appName, {
                modal: false,
                excelConfigName: 'sgp100ukrv_10',
                extParam: {
                    'PGM_ID': 'sgp100ukrv_10',
                    'DIV_CODE'  : panelSearch.getValue('DIV_CODE'),
                    'ITEM_LEVEL' : excelItemLevel, 
                    'PLAN_YEAR' : panelSearch.getValue('PLAN_YEAR'),
                    'ORDER_TYPE' : panelSearch.getValue('ORDER_TYPE'),
                    'MONEY_UNIT' : panelSearch.getValue('MONEY_UNIT')
                    
                },
                grids: [{
                    itemId: 'grid10',
                    title: '고객품목분류별판매계획엑셀참조',
                    useCheckbox: true,
                    model : 'sgp100ukrvModel_10',
                    readApi: 'sgp100ukrvService.selectExcelUploadSheet10',
                    columns: [

                        {dataIndex: 'CUSTOM_CODE'      ,       width: 100},
                        {dataIndex: 'CUSTOM_NAME'      ,       width: 250},
                        {dataIndex: 'S_CODE1'          ,       width: 80, hidden: scode1Hidden},
                        {dataIndex: 'S_CODE2'          ,       width: 80, hidden: scode2Hidden},
                        {dataIndex: 'S_CODE3'          ,       width: 80, hidden: scode3Hidden},
                        {dataIndex: 'PLAN1'            ,       width: 100},
                        {dataIndex: 'PLAN2'            ,       width: 100},
                        {dataIndex: 'PLAN3'            ,       width: 100},
                        {dataIndex: 'PLAN4'            ,       width: 100},
                        {dataIndex: 'PLAN5'            ,       width: 100},
                        {dataIndex: 'PLAN6'            ,       width: 100},
                        {dataIndex: 'PLAN7'            ,       width: 100},
                        {dataIndex: 'PLAN8'            ,       width: 100},
                        {dataIndex: 'PLAN9'            ,       width: 100},
                        {dataIndex: 'PLAN10'           ,       width: 100},
                        {dataIndex: 'PLAN11'           ,       width: 100},
                        {dataIndex: 'PLAN12'           ,       width: 100}
                    ]
                }],
                listeners: {
					beforeshow: function( panel, eOpts ) {
						this.down('#grid10').getStore().sort({property : '_EXCEL_ROWNUM', direction: 'ASC'});
					},
					beforehide: function(me, eOpt) {
						var me		= this;
						var grid	= this.down('#grid10');
						excelWindow10.getEl().unmask();
						grid.getStore().removeAll();
					},
					close: function() {
						var me		= this;
						var grid	= this.down('#grid10');
						excelWindow10.getEl().unmask();
						grid.getStore().removeAll();						
						this.hide();
					}
                },                 
				onApply:function() {
					
                	var flag = true
                    var grid = this.down('#grid10');
                    var records =  grid.getStore().data.items;
                    var selectedrecords = grid.getSelectionModel().getSelection();
                    
                    if(selectedrecords.length > 0){
	                    Ext.each(records, function(record,i){
	                    	if(record.get('_EXCEL_HAS_ERROR') == 'Y') {
								console.log("_EXCEL_HAS_ERROR : ", record.get('_EXCEL_HAS_ERROR'));
								flag = false;
								return false;
							}
	                    });
	
						if(!flag){
							Ext.MessageBox.show({
								msg : '(고객코드오류/분류코드오류/이미 확정된 판매계획건이 존재)에러가 있는 행은 적용시 제외됩니다.' ,
								icon: Ext.Msg.WARNING,
								buttons : Ext.MessageBox.OKCANCEL,
								fn : function(buttonId) {
									switch (buttonId) {
										case 'ok' :
	//										var records = grid.getSelectionModel().getSelection();
											customitemSortMasterGrid.store.loadData({});
						
						                    var beforeRM = grid.getStore().count();
						                    grid.getStore().remove(selectedrecords);
						                    var afterRM = grid.getStore().count();
						                    if (beforeRM > 0 && afterRM == 0){
						                       excelWindow10.close();
						                    }
						                    customitemSortMasterGrid.setExcelData(selectedrecords);	
											break;
										case 'cancel' :
											break;
									}
								},
								scope : this
							}); // MessageBox
							
						}else{
	//						var records = grid.getSelectionModel().getSelection(); 
							customitemSortMasterGrid.store.loadData({});
		                    var beforeRM = grid.getStore().count();
		                    grid.getStore().remove(selectedrecords);
		                    var afterRM = grid.getStore().count();
		                    if (beforeRM > 0 && afterRM == 0){
		                       excelWindow10.close();
		                    }	
	                        customitemSortMasterGrid.setExcelData(selectedrecords);		                       
						}
                    }
					
				} 
             });
        }
        excelWindow10.center();
        excelWindow10.show();
    }   
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var customMasterStore = Unilite.createStore('sgp100ukrvMasterStore1',{
        model: 'Sgp100ukrvModel1',
        uniOpt : {
            isMaster: true,         // 상위 버튼 연결 
            editable: true,         // 수정 모드 사용 
            deletable:true,         // 삭제 가능 여부  
            useNavi : false         // prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {   
            var param= panelSearch.getValues();
            param.AGENT_TYPE = customSubForm.getValue('AGENT_TYPE'); 
            console.log( param );
            this.load({
                params : param
            });         
        },
        saveStore : function(config)    {             
            var inValidRecs = this.getInvalidRecords();
            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();
            console.log("toUpdate",toUpdate);

            var rv = true;
    
            if(inValidRecs.length == 0 )    {                                       
                config = {
                    success: function(batch, option) {                              
                        panelResult.resetDirtyStatus();
                        UniAppManager.setToolbarButtons('save', false);         
                     } 
                };                  
                this.syncAllDirect(config);
            } else {
                customMasterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
                    var record = customMasterStore.data.items; 
                    if(record[0].data.CONFIRM_YN == 'Y') {
                        Ext.getCmp('CONFIRM_DATA1').setText('<t:message code="system.label.sales.confirmationcancel" default="확정취소"/>');
                        Ext.getCmp('CONFIRM_DATA2').setText('<t:message code="system.label.sales.confirmationcancel" default="확정취소"/>');
                        Ext.getCmp('CREATE_DATA1').setDisabled(true);
                        Ext.getCmp('CREATE_DATA2').setDisabled(true);
                        Ext.getCmp('CONFIRM_DATA1').setDisabled(false);
                        Ext.getCmp('CONFIRM_DATA2').setDisabled(false);
                    } else if(record[0].data.CONFIRM_YN == 'N') {
                        Ext.getCmp('CONFIRM_DATA1').setText('<t:message code="system.label.sales.yearplanconfirm" default="년초계획확정"/>');
                        Ext.getCmp('CONFIRM_DATA2').setText('<t:message code="system.label.sales.yearplanconfirm" default="년초계획확정"/>');
                        Ext.getCmp('CREATE_DATA1').setDisabled(true);
                        Ext.getCmp('CREATE_DATA2').setDisabled(true);
                        Ext.getCmp('CONFIRM_DATA1').setDisabled(false);
                        Ext.getCmp('CONFIRM_DATA2').setDisabled(false);
                    }
                } else {
                    Ext.getCmp('CREATE_DATA1').setDisabled(false);
                    Ext.getCmp('CREATE_DATA2').setDisabled(false);
                    Ext.getCmp('CONFIRM_DATA1').setDisabled(true);
                    Ext.getCmp('CONFIRM_DATA2').setDisabled(true);
                }
            }               
        }
    });
    
    var salePrsnMasterStore = Unilite.createStore('sgp100ukrvMasterStore2',{
        model: 'Sgp100ukrvModel2',
        uniOpt : {
            isMaster: true,         // 상위 버튼 연결 
            editable: true,         // 수정 모드 사용 
            deletable:true,         // 삭제 가능 여부 
            useNavi : false         // prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy2,
        loadStoreRecords : function()   {   
            var param= panelSearch.getValues();
            this.load({
                  params : param
            });         
        },
        saveStore : function(config)    {   
            var inValidRecs = this.getInvalidRecords();
            
            if(inValidRecs.length == 0 )    {                                   
                config = {
                    success: function(batch, option) {                              
                        panelSearch.resetDirtyStatus();
                        UniAppManager.setToolbarButtons('save', false); 
                        UniAppManager.app.onQueryButtonDown();
                     } 
                };
                this.syncAllDirect(config);
            }else {
                salePrsnMasterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
                    var record = salePrsnMasterStore.data.items; 
                    if(record[0].data.CONFIRM_YN == 'Y') {
                        Ext.getCmp('CONFIRM_DATA1').setText('<t:message code="system.label.sales.confirmationcancel" default="확정취소"/>');
                        Ext.getCmp('CONFIRM_DATA2').setText('<t:message code="system.label.sales.confirmationcancel" default="확정취소"/>');
                        Ext.getCmp('CREATE_DATA1').setDisabled(true);
                        Ext.getCmp('CREATE_DATA2').setDisabled(true);
                        Ext.getCmp('CONFIRM_DATA1').setDisabled(false);
                        Ext.getCmp('CONFIRM_DATA2').setDisabled(false);
                    } else if(record[0].data.CONFIRM_YN == 'N') {
                        Ext.getCmp('CONFIRM_DATA1').setText('<t:message code="system.label.sales.yearplanconfirm" default="년초계획확정"/>');
                        Ext.getCmp('CONFIRM_DATA2').setText('<t:message code="system.label.sales.yearplanconfirm" default="년초계획확정"/>');
                        Ext.getCmp('CREATE_DATA1').setDisabled(true);
                        Ext.getCmp('CREATE_DATA2').setDisabled(true);
                        Ext.getCmp('CONFIRM_DATA1').setDisabled(false);
                        Ext.getCmp('CONFIRM_DATA2').setDisabled(false);
                    }
                } else {
                    Ext.getCmp('CREATE_DATA1').setDisabled(false);
                    Ext.getCmp('CREATE_DATA2').setDisabled(false);
                    Ext.getCmp('CONFIRM_DATA1').setDisabled(true);
                    Ext.getCmp('CONFIRM_DATA2').setDisabled(true);
                }
            }               
        }
    });
    
    var itemMasterStore = Unilite.createStore('sgp100ukrvMasterStore3',{
        model: 'Sgp100ukrvModel3',
        uniOpt : {
            isMaster: true,         // 상위 버튼 연결 
            editable: true,         // 수정 모드 사용 
            deletable:true,         // 삭제 가능 여부 
            useNavi : false         // prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy3,
        loadStoreRecords : function()   {   
        /*  var param= Ext.getCmp('searchForm').getValues();            
            console.log( param );
            this.load({
                params : param*/
            var param= panelSearch.getValues();
            param.ITEM_ACCOUNT = itemSubForm.getValue('ITEM_ACCOUNT');
            this.load({
                  params : param
            });         
        },
        saveStore : function(config)    {   
            var inValidRecs = this.getInvalidRecords();
            
            if(inValidRecs.length == 0 )    {                                   
                config = {
                    success: function(batch, option) {                              
                        panelSearch.resetDirtyStatus();
                        UniAppManager.setToolbarButtons('save', false); 
                        UniAppManager.app.onQueryButtonDown();
                     } 
                };
                this.syncAllDirect(config);
            }else {
                itemMasterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
                    var record = itemMasterStore.data.items; 
                    if(record[0].data.CONFIRM_YN == 'Y') {
                        Ext.getCmp('CONFIRM_DATA1').setText('<t:message code="system.label.sales.confirmationcancel" default="확정취소"/>');
                        Ext.getCmp('CONFIRM_DATA2').setText('<t:message code="system.label.sales.confirmationcancel" default="확정취소"/>');
                        Ext.getCmp('CREATE_DATA1').setDisabled(true);
                        Ext.getCmp('CREATE_DATA2').setDisabled(true);
                        Ext.getCmp('CONFIRM_DATA1').setDisabled(false);
                        Ext.getCmp('CONFIRM_DATA2').setDisabled(false);
                    } else if(record[0].data.CONFIRM_YN == 'N') {
                        Ext.getCmp('CONFIRM_DATA1').setText('<t:message code="system.label.sales.yearplanconfirm" default="년초계획확정"/>');
                        Ext.getCmp('CONFIRM_DATA2').setText('<t:message code="system.label.sales.yearplanconfirm" default="년초계획확정"/>');
                        Ext.getCmp('CREATE_DATA1').setDisabled(true);
                        Ext.getCmp('CREATE_DATA2').setDisabled(true);
                        Ext.getCmp('CONFIRM_DATA1').setDisabled(false);
                        Ext.getCmp('CONFIRM_DATA2').setDisabled(false);
                    }
                } else {
                    Ext.getCmp('CREATE_DATA1').setDisabled(false);
                    Ext.getCmp('CREATE_DATA2').setDisabled(false);
                    Ext.getCmp('CONFIRM_DATA1').setDisabled(true);
                    Ext.getCmp('CONFIRM_DATA2').setDisabled(true);
                }
            }               
        }
    });
    
    var itemSortMasterStore = Unilite.createStore('sgp100ukrvMasterStore4',{
        model: 'Sgp100ukrvModel4',
        uniOpt : {
            isMaster: true,         // 상위 버튼 연결 
            editable: true,         // 수정 모드 사용 
            deletable:true,         // 삭제 가능 여부 
            useNavi : false         // prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy4,
        loadStoreRecords : function(newValue)   {   
        /*  var param= Ext.getCmp('searchForm').getValues();            
            console.log( param );
            this.load({
                params : param*/
            var param= panelSearch.getValues();
            param.ITEM_LEVEL = newValue //Ext.getCmp('ITEM_LEVEL_ID').getChecked()[0].inputValue;
            this.load({
                  params : param
            });         
        },
        saveStore : function(config)    {   
            var inValidRecs = this.getInvalidRecords();
            
            if(inValidRecs.length == 0 )    {                                   
                config = {
                    success: function(batch, option) {                              
                        panelSearch.resetDirtyStatus();
                        UniAppManager.setToolbarButtons('save', false); 
                        UniAppManager.app.onQueryButtonDown();
                     } 
                };
                this.syncAllDirect(config);
            }else {
                itemSortMasterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
                    var record = itemSortMasterStore.data.items; 
                    if(record[0].data.CONFIRM_YN == 'Y') {
                        Ext.getCmp('CONFIRM_DATA1').setText('<t:message code="system.label.sales.confirmationcancel" default="확정취소"/>');
                        Ext.getCmp('CONFIRM_DATA2').setText('<t:message code="system.label.sales.confirmationcancel" default="확정취소"/>');
                        Ext.getCmp('CREATE_DATA1').setDisabled(true);
                        Ext.getCmp('CREATE_DATA2').setDisabled(true);
                        Ext.getCmp('CONFIRM_DATA1').setDisabled(false);
                        Ext.getCmp('CONFIRM_DATA2').setDisabled(false);
                    } else if(record[0].data.CONFIRM_YN == 'N') {
                        Ext.getCmp('CONFIRM_DATA1').setText('<t:message code="system.label.sales.yearplanconfirm" default="년초계획확정"/>');
                        Ext.getCmp('CONFIRM_DATA2').setText('<t:message code="system.label.sales.yearplanconfirm" default="년초계획확정"/>');
                        Ext.getCmp('CREATE_DATA1').setDisabled(true);
                        Ext.getCmp('CREATE_DATA2').setDisabled(true);
                        Ext.getCmp('CONFIRM_DATA1').setDisabled(false);
                        Ext.getCmp('CONFIRM_DATA2').setDisabled(false);
                    }
                } else {
                    Ext.getCmp('CREATE_DATA1').setDisabled(false);
                    Ext.getCmp('CREATE_DATA2').setDisabled(false);
                    Ext.getCmp('CONFIRM_DATA1').setDisabled(true);
                    Ext.getCmp('CONFIRM_DATA2').setDisabled(true);
                }
            }               
        }
    });
    
    var spokesItemMasterStore = Unilite.createStore('sgp100ukrvMasterStore5',{
        model: 'Sgp100ukrvModel5',
        uniOpt : {
            isMaster: true,         // 상위 버튼 연결 
            editable: true,         // 수정 모드 사용 
            deletable:true,         // 삭제 가능 여부 
            useNavi : false         // prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy5,
        loadStoreRecords : function()   {
            var param= panelSearch.getValues();
            param.ITEM_ACCOUNT = spokesItemSubForm.getValue('ITEM_ACCOUNT');
            this.load({
                  params : param
            });         
        },
        saveStore : function(config)    {   
            var inValidRecs = this.getInvalidRecords();
            
            if(inValidRecs.length == 0 )    {                                   
                config = {
                    success: function(batch, option) {                              
                        panelSearch.resetDirtyStatus();
                        UniAppManager.setToolbarButtons('save', false); 
                        UniAppManager.app.onQueryButtonDown();
                     } 
                };
                this.syncAllDirect(config);
            }else {
                spokesItemMasterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
                    var record = spokesItemMasterStore.data.items; 
                    if(record[0].data.CONFIRM_YN == 'Y') {
                        Ext.getCmp('CONFIRM_DATA1').setText('<t:message code="system.label.sales.confirmationcancel" default="확정취소"/>');
                        Ext.getCmp('CONFIRM_DATA2').setText('<t:message code="system.label.sales.confirmationcancel" default="확정취소"/>');
                        Ext.getCmp('CREATE_DATA1').setDisabled(true);
                        Ext.getCmp('CREATE_DATA2').setDisabled(true);
                        Ext.getCmp('CONFIRM_DATA1').setDisabled(false);
                        Ext.getCmp('CONFIRM_DATA2').setDisabled(false);
                    } else if(record[0].data.CONFIRM_YN == 'N') {
                        Ext.getCmp('CONFIRM_DATA1').setText('<t:message code="system.label.sales.yearplanconfirm" default="년초계획확정"/>');
                        Ext.getCmp('CONFIRM_DATA2').setText('<t:message code="system.label.sales.yearplanconfirm" default="년초계획확정"/>');
                        Ext.getCmp('CREATE_DATA1').setDisabled(true);
                        Ext.getCmp('CREATE_DATA2').setDisabled(true);
                        Ext.getCmp('CONFIRM_DATA1').setDisabled(false);
                        Ext.getCmp('CONFIRM_DATA2').setDisabled(false);
                    }
                } else {
                    Ext.getCmp('CREATE_DATA1').setDisabled(false);
                    Ext.getCmp('CREATE_DATA2').setDisabled(false);
                    Ext.getCmp('CONFIRM_DATA1').setDisabled(true);
                    Ext.getCmp('CONFIRM_DATA2').setDisabled(true);
                }
            }               
        }
    });
    
    var customerItemMasterStore = Unilite.createStore('sgp100ukrvMasterStore6',{
        model: 'Sgp100ukrvModel6',
        uniOpt : {
            isMaster: true,         // 상위 버튼 연결 
            editable: true,         // 수정 모드 사용 
            deletable:true,         // 삭제 가능 여부 
            useNavi : false         // prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy6,
        loadStoreRecords : function()   {   
        /*  var param= Ext.getCmp('searchForm').getValues();            
            console.log( param );
            this.load({
                params : param*/
            var param= panelSearch.getValues();
            param.AGENT_TYPE = customerItemSubForm.getValue('AGENT_TYPE'); 
            this.load({
                  params : param
            });         
        },
        saveStore : function(config)    {   
            var inValidRecs = this.getInvalidRecords();
            
            if(inValidRecs.length == 0 )    {                                   
                config = {
                    success: function(batch, option) {                              
                        panelSearch.resetDirtyStatus();
                        UniAppManager.setToolbarButtons('save', false); 
                        UniAppManager.app.onQueryButtonDown();
                     } 
                };
                this.syncAllDirect(config);
            }else {
                customerItemMasterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
                    var record = customerItemMasterStore.data.items; 
                    if(record[0].data.CONFIRM_YN == 'Y') {
                        Ext.getCmp('CONFIRM_DATA1').setText('<t:message code="system.label.sales.confirmationcancel" default="확정취소"/>');
                        Ext.getCmp('CONFIRM_DATA2').setText('<t:message code="system.label.sales.confirmationcancel" default="확정취소"/>');
                        Ext.getCmp('CREATE_DATA1').setDisabled(true);
                        Ext.getCmp('CREATE_DATA2').setDisabled(true);
                        Ext.getCmp('CONFIRM_DATA1').setDisabled(false);
                        Ext.getCmp('CONFIRM_DATA2').setDisabled(false);
                    } else if(record[0].data.CONFIRM_YN == 'N') {
                        Ext.getCmp('CONFIRM_DATA1').setText('<t:message code="system.label.sales.yearplanconfirm" default="년초계획확정"/>');
                        Ext.getCmp('CONFIRM_DATA2').setText('<t:message code="system.label.sales.yearplanconfirm" default="년초계획확정"/>');
                        Ext.getCmp('CREATE_DATA1').setDisabled(true);
                        Ext.getCmp('CREATE_DATA2').setDisabled(true);
                        Ext.getCmp('CONFIRM_DATA1').setDisabled(false);
                        Ext.getCmp('CONFIRM_DATA2').setDisabled(false);
                    }
                } else {
                    Ext.getCmp('CREATE_DATA1').setDisabled(false);
                    Ext.getCmp('CREATE_DATA2').setDisabled(false);
                    Ext.getCmp('CONFIRM_DATA1').setDisabled(true);
                    Ext.getCmp('CONFIRM_DATA2').setDisabled(true);
                }
            }               
        }
    });
    
    var saleTypeStore = Unilite.createStore('sgp100ukrvMasterStore7',{
        model: 'Sgp100ukrvModel7',
        uniOpt : {
            isMaster: true,         // 상위 버튼 연결 
            editable: true,         // 수정 모드 사용 
            deletable:true,         // 삭제 가능 여부 
            useNavi : false         // prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy7,
        loadStoreRecords : function()   {   
        /*  var param= Ext.getCmp('searchForm').getValues();            
            console.log( param );
            this.load({
                params : param*/
            var param= panelSearch.getValues();
            this.load({
                  params : param
            });         
        },
        saveStore : function(config)    {   
            var inValidRecs = this.getInvalidRecords();
            var paramMaster= panelSearch.getValues();
            if(inValidRecs.length == 0 )    {                                   
                config = {
                	params: [paramMaster],
                    success: function(batch, option) {                              
                        panelSearch.resetDirtyStatus();
                        UniAppManager.setToolbarButtons('save', false); 
                        UniAppManager.app.onQueryButtonDown();
                     } 
                };
                this.syncAllDirect(config);
            }else {
                saleTypeGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
                    var record = saleTypeStore.data.items; 
                    if(record[0].data.CONFIRM_YN == 'Y') {
                        Ext.getCmp('CONFIRM_DATA1').setText('<t:message code="system.label.sales.confirmationcancel" default="확정취소"/>');
                        Ext.getCmp('CONFIRM_DATA2').setText('<t:message code="system.label.sales.confirmationcancel" default="확정취소"/>');
                        Ext.getCmp('CREATE_DATA1').setDisabled(true);
                        Ext.getCmp('CREATE_DATA2').setDisabled(true);
                        Ext.getCmp('CONFIRM_DATA1').setDisabled(false);
                        Ext.getCmp('CONFIRM_DATA2').setDisabled(false);
                    } else if(record[0].data.CONFIRM_YN == 'N') {
                        Ext.getCmp('CONFIRM_DATA1').setText('<t:message code="system.label.sales.yearplanconfirm" default="년초계획확정"/>');
                        Ext.getCmp('CONFIRM_DATA2').setText('<t:message code="system.label.sales.yearplanconfirm" default="년초계획확정"/>');
                        Ext.getCmp('CREATE_DATA1').setDisabled(true);
                        Ext.getCmp('CREATE_DATA2').setDisabled(true);
                        Ext.getCmp('CONFIRM_DATA1').setDisabled(false);
                        Ext.getCmp('CONFIRM_DATA2').setDisabled(false);
                    }
                    panelSearch.setValue('MONEY_UNIT_DIV', record[0].data.ENT_MONEY_UNIT);
                    panelResult.setValue('MONEY_UNIT_DIV', record[0].data.ENT_MONEY_UNIT);
                    panelSearch.getField('MONEY_UNIT_DIV').setReadOnly(true);
                    panelResult.getField('MONEY_UNIT_DIV').setReadOnly(true);
                } else {
                    Ext.getCmp('CREATE_DATA1').setDisabled(false);
                    Ext.getCmp('CREATE_DATA2').setDisabled(false);
                    Ext.getCmp('CONFIRM_DATA1').setDisabled(true);
                    Ext.getCmp('CONFIRM_DATA2').setDisabled(true);
                    panelSearch.getField('MONEY_UNIT_DIV').setReadOnly(false);
                    panelResult.getField('MONEY_UNIT_DIV').setReadOnly(false);
                }
            }               
        }
    });
    
    var customitemSortMasterStore = Unilite.createStore('sgp100ukrvMasterStore10',{
        model: 'Sgp100ukrvModel10',
        uniOpt : {
            isMaster: true,         // 상위 버튼 연결 
            editable: true,         // 수정 모드 사용 
            deletable:true,         // 삭제 가능 여부 
            useNavi : false         // prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy10,
        loadStoreRecords : function(newValue)   {   
        /*  var param= Ext.getCmp('searchForm').getValues();            
            console.log( param );
            this.load({
                params : param*/
            var param= panelSearch.getValues();
            param.ITEM_LEVEL = newValue; //Ext.getCmp('CUSTOM_ITEM_LEVEL_ID').getChecked()[0].inputValue;
            this.load({
                  params : param
            });         
        },
        saveStore : function(config)    {   
            var inValidRecs = this.getInvalidRecords();
            
            if(inValidRecs.length == 0 )    {                                   
                config = {
                    success: function(batch, option) {                              
                        panelSearch.resetDirtyStatus();
                        UniAppManager.setToolbarButtons('save', false); 
                        UniAppManager.app.onQueryButtonDown();
                     } 
                };
                this.syncAllDirect(config);
            }else {
                customitemSortMasterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
                    var record = customitemSortMasterStore.data.items; 
                    if(record[0].data.CONFIRM_YN == 'Y') {
                        Ext.getCmp('CONFIRM_DATA1').setText('<t:message code="system.label.sales.confirmationcancel" default="확정취소"/>');
                        Ext.getCmp('CONFIRM_DATA2').setText('<t:message code="system.label.sales.confirmationcancel" default="확정취소"/>');
                        Ext.getCmp('CREATE_DATA1').setDisabled(true);
                        Ext.getCmp('CREATE_DATA2').setDisabled(true);
                        Ext.getCmp('CONFIRM_DATA1').setDisabled(false);
                        Ext.getCmp('CONFIRM_DATA2').setDisabled(false);
                    } else if(record[0].data.CONFIRM_YN == 'N') {
                        Ext.getCmp('CONFIRM_DATA1').setText('<t:message code="system.label.sales.yearplanconfirm" default="년초계획확정"/>');
                        Ext.getCmp('CONFIRM_DATA2').setText('<t:message code="system.label.sales.yearplanconfirm" default="년초계획확정"/>');
                        Ext.getCmp('CREATE_DATA1').setDisabled(true);
                        Ext.getCmp('CREATE_DATA2').setDisabled(true);
                        Ext.getCmp('CONFIRM_DATA1').setDisabled(false);
                        Ext.getCmp('CONFIRM_DATA2').setDisabled(false);
                    }
                } else {
                    Ext.getCmp('CREATE_DATA1').setDisabled(false);
                    Ext.getCmp('CREATE_DATA2').setDisabled(false);
                    Ext.getCmp('CONFIRM_DATA1').setDisabled(true);
                    Ext.getCmp('CONFIRM_DATA2').setDisabled(true);
                }
            }               
        }
    });
        
    /**
     * 검색조건 (Search Panel)
     * @type 
     */ 
    var panelSearch = Unilite.createSearchPanel('searchForm', {     
        title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',      
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
            title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',  
            itemId: 'search_panel1',
            layout: {type: 'uniTable', columns: 1},
            defaultType: 'uniTextfield',            
            items: [{
                fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
                name: 'DIV_CODE', 
                xtype: 'uniCombobox', 
                comboType: 'BOR120',
                allowBlank:false,
                holdable: 'hold',
                value: UserInfo.divCode,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('DIV_CODE', newValue);
                    }
                }
            },{
                fieldLabel: '<t:message code="system.label.sales.planyear" default="계획년도"/>',
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
                fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
                name:'ORDER_TYPE',  
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'S002',
                allowBlank: false,
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('ORDER_TYPE', newValue);
                    }
                }
            },{
                fieldLabel: '<t:message code="system.label.sales.currency" default="화폐"/>',
                name:'MONEY_UNIT',  
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'B004',
                displayField: 'value',
                allowBlank: false,
                holdable: 'hold',
                fieldStyle: 'text-align: center;',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('MONEY_UNIT', newValue);
                    }
                }
            },{
                fieldLabel: '<t:message code="system.label.sales.planamountunit" default="계획금액단위"/>',
                name:'MONEY_UNIT_DIV',  
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'B042',
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('MONEY_UNIT_DIV', newValue);
                    }
                }
            },{
                xtype: 'container',
                padding: '0 0 0 20',
                layout: {
                    type: 'hbox',
                    align: 'center',
                    pack: 'center'
                },
                items:[{
                        xtype: 'button',
                        text: '<t:message code="system.label.sales.yearplanconfirm" default="년초계획확정"/>', 
                        id: 'CONFIRM_DATA1',
                        name: 'EXECUTE_TYPE',
                        //inputValue: '1',
                        width: 110,  
                        handler : function(records, grid, record) {
                            var me = this;
                            var activeTabId = tab.getActiveTab().getId(); 
                            Ext.getBody().mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');          
                            if(activeTabId == 'sgp100ukrvCustomGrid') {
                                var record = customMasterGrid.getSelectedRecord();
                                var param= panelSearch.getValues();
                                param.AGENT_TYPE = customSubForm.getValue('AGENT_TYPE');
                                param.PLAN_TYPE1 = record.data['PLAN_TYPE1']
                                param.PLAN_TYPE2 = record.data['PLAN_TYPE2']
                                param.PLAN_TYPE2_CODE = record.data['PLAN_TYPE2_CODE']
                                param.LEVEL_KIND = record.data['LEVEL_KIND']
                                param.AGENT_TYPE = customSubForm.getValue('AGENT_TYPE');
                                param.TAB = "CUSTOM";
                                if(record.get('CONFIRM_YN') == 'Y') {
                                    sgp100ukrvService.cancleDataList(param, 
                                        function(provider, response) {
                                            UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                            UniAppManager.app.onQueryButtonDown();
                                            me.setDisabled(true); 
                                            Ext.getBody().unmask();
                                        }
                                    )
                                } else if(record.get('CONFIRM_YN') == 'N') {
                                    sgp100ukrvService.confirmDataList(param, 
                                        function(provider, response) {
                                            UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                            UniAppManager.app.onQueryButtonDown();
                                            me.setDisabled(true);
                                            UniAppManager.setToolbarButtons(['deleteAll'],false); 
                                            Ext.getBody().unmask();
                                        }
                                    )
                                }
                            } else if(activeTabId == 'sgp100ukrvSalePrsnGrid') {
                                var record = salePrsnMasterGrid.getSelectedRecord();
                                var param= panelSearch.getValues();
                                param.PLAN_TYPE1 = record.data['PLAN_TYPE1']
                                param.PLAN_TYPE2 = record.data['PLAN_TYPE2']
                                param.PLAN_TYPE2_CODE = record.data['PLAN_TYPE2_CODE']
                                param.LEVEL_KIND = record.data['LEVEL_KIND']
                                param.TAB = "PERSON";
                                if(record.get('CONFIRM_YN') == 'Y') {
                                    sgp100ukrvService.cancleDataList(param, 
                                        function(provider, response) {
                                            UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                            UniAppManager.app.onQueryButtonDown();
                                            me.setDisabled(true);
                                            Ext.getBody().unmask(); 
                                        }
                                    )
                                } else if(record.get('CONFIRM_YN') == 'N') {
                                    sgp100ukrvService.confirmDataList(param, 
                                        function(provider, response) {
                                            UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                            UniAppManager.app.onQueryButtonDown();
                                            me.setDisabled(true);
                                            UniAppManager.setToolbarButtons(['deleteAll'],false);  
                                            Ext.getBody().unmask();
                                        }
                                    )
                                }
                            } else if(activeTabId == 'sgp100ukrvItemGrid') {
                                var record = itemMasterGrid.getSelectedRecord();
                                var param= panelSearch.getValues();
                                param.PLAN_TYPE1 = record.data['PLAN_TYPE1']
                                param.PLAN_TYPE2 = record.data['PLAN_TYPE2']
                                param.PLAN_TYPE2_CODE = record.data['PLAN_TYPE2_CODE']
                                param.LEVEL_KIND = record.data['LEVEL_KIND']
                                param.ITEM_ACCOUNT = itemSubForm.getValue('ITEM_ACCOUNT');
                                param.TAB = "ITEM";
                                if(record.get('CONFIRM_YN') == 'Y') {
                                    sgp100ukrvService.cancleDataList(param, 
                                        function(provider, response) {
                                            UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                            UniAppManager.app.onQueryButtonDown();
                                            me.setDisabled(true); 
                                            Ext.getBody().unmask();
                                        }
                                    )
                                } else if(record.get('CONFIRM_YN') == 'N') {
                                    sgp100ukrvService.confirmDataList(param, 
                                        function(provider, response) {
                                            UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                            UniAppManager.app.onQueryButtonDown();
                                            me.setDisabled(true);
                                            UniAppManager.setToolbarButtons(['deleteAll'],false); 
                                            Ext.getBody().unmask(); 
                                        }
                                    )
                                }
                            } else if(activeTabId == 'sgp100ukrvitemSortGrid') {
                                var record = itemSortMasterGrid.getSelectedRecord();
                                var param= panelSearch.getValues();
                                param.PLAN_TYPE1 = record.data['PLAN_TYPE1']
                                param.PLAN_TYPE2 = record.data['PLAN_TYPE2']
                                param.PLAN_TYPE2_CODE = record.data['PLAN_TYPE2_CODE']
                                param.LEVEL_KIND = record.data['LEVEL_KIND']
                                param.ITEM_LEVEL = Ext.getCmp('ITEM_LEVEL_ID').getChecked()[0].inputValue;
                                param.TAB = "ITEM_SORT";
                                if(record.get('CONFIRM_YN') == 'Y') {
                                    sgp100ukrvService.cancleDataList(param, 
                                        function(provider, response) {
                                            UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                            UniAppManager.app.onQueryButtonDown();
                                            me.setDisabled(true); 
                                            Ext.getBody().unmask();
                                        }
                                    )
                                } else if(record.get('CONFIRM_YN') == 'N') {
                                    sgp100ukrvService.confirmDataList(param, 
                                        function(provider, response) {
                                            UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                            UniAppManager.app.onQueryButtonDown();
                                            me.setDisabled(true);
                                            UniAppManager.setToolbarButtons(['deleteAll'],false); 
                                            Ext.getBody().unmask();
                                        }
                                    )
                                }
                            } else if(activeTabId == 'sgp100ukrvspokesItemGrid') {
                                var record = spokesItemMasterGrid.getSelectedRecord();
                                var param= panelSearch.getValues();
                                param.PLAN_TYPE1 = record.data['PLAN_TYPE1']
                                param.PLAN_TYPE2 = record.data['PLAN_TYPE2']
                                param.PLAN_TYPE2_CODE = record.data['PLAN_TYPE2_CODE']
                                param.LEVEL_KIND = record.data['LEVEL_KIND']
                                param.ITEM_ACCOUNT = itemSubForm.getValue('ITEM_ACCOUNT');
                                param.TAB = "MODEL";
                                if(record.get('CONFIRM_YN') == 'Y') {
                                    sgp100ukrvService.cancleDataList(param, 
                                        function(provider, response) {
                                            UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                            UniAppManager.app.onQueryButtonDown();
                                            me.setDisabled(true); 
                                            Ext.getBody().unmask();
                                        }
                                    )
                                } else if(record.get('CONFIRM_YN') == 'N') {
                                    sgp100ukrvService.confirmDataList(param, 
                                        function(provider, response) {
                                            UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                            UniAppManager.app.onQueryButtonDown();
                                            me.setDisabled(true);
                                            UniAppManager.setToolbarButtons(['deleteAll'],false);
                                            Ext.getBody().unmask(); 
                                        }
                                    )
                                }
                            } else if(activeTabId == 'sgp100ukrvcustomerItemGrid') {
                                var record = customerItemMasterGrid.getSelectedRecord();
                                var param= panelSearch.getValues();
                                param.PLAN_TYPE1 = record.data['PLAN_TYPE1']
                                param.PLAN_TYPE2 = record.data['PLAN_TYPE2']
                                param.PLAN_TYPE2_CODE = record.data['PLAN_TYPE2_CODE']
                                param.LEVEL_KIND = record.data['LEVEL_KIND']
                                param.AGENT_TYPE = customSubForm.getValue('AGENT_TYPE');
                                param.TAB = "";
                                if(record.get('CONFIRM_YN') == 'Y') {
                                    sgp100ukrvService.cancleDataList(param, 
                                        function(provider, response) {
                                            UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                            UniAppManager.app.onQueryButtonDown();
                                            me.setDisabled(true); 
                                            Ext.getBody().unmask();
                                        }
                                    )
                                } else if(record.get('CONFIRM_YN') == 'N') {
                                    sgp100ukrvService.confirmDataList(param, 
                                        function(provider, response) {
                                            UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                            UniAppManager.app.onQueryButtonDown();
                                            me.setDisabled(true);
                                            UniAppManager.setToolbarButtons(['deleteAll'],false); 
                                            Ext.getBody().unmask();
                                        }
                                    )
                                }
                            } else if(activeTabId == 'sgp100ukrvSaleTypeGrid') {
                                var record = saleTypeGrid.getSelectedRecord();
                                var param= panelSearch.getValues();
                                param.PLAN_TYPE1 = record.data['PLAN_TYPE1']
                                param.PLAN_TYPE2 = record.data['PLAN_TYPE2']
                                param.PLAN_TYPE2_CODE = record.data['PLAN_TYPE2_CODE']
                                param.LEVEL_KIND = '*'
                                param.TAB = "SALE_TYPE";
                                if(record.get('CONFIRM_YN') == 'Y') {
                                    sgp100ukrvService.cancleDataList(param, 
                                        function(provider, response) {
                                            UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                            UniAppManager.app.onQueryButtonDown();
                                            me.setDisabled(true); 
                                            saleTypeGrid.getEl().unmask();
                                        }
                                    )
                                } else if(record.get('CONFIRM_YN') == 'N') {
                                    sgp100ukrvService.confirmDataList(param, 
                                        function(provider, response) {
                                            UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                            UniAppManager.app.onQueryButtonDown();
                                            me.setDisabled(true);
                                            UniAppManager.setToolbarButtons(['deleteAll'],false); 
                                            saleTypeGrid.getEl().unmask();
                                        }
                                    )
                                }
                            }else if(activeTabId == 'sgp100ukrvcustomitemSortGrid') {
                                var record = customitemSortMasterGrid.getSelectedRecord();
                                var param= panelSearch.getValues();
                                param.PLAN_TYPE1 = record.data['PLAN_TYPE1']
                                param.PLAN_TYPE2 = record.data['PLAN_TYPE2']
                                param.PLAN_TYPE2_CODE = record.data['PLAN_TYPE2_CODE']
                                param.LEVEL_KIND = record.data['LEVEL_KIND']
                                param.ITEM_LEVEL = Ext.getCmp('CUSTOM_ITEM_LEVEL_ID').getChecked()[0].inputValue;
                                param.TAB = "CUSTOM_ITEM_SORT";
                                if(record.get('CONFIRM_YN') == 'Y') {
                                    sgp100ukrvService.cancleDataList(param, 
                                        function(provider, response) {
                                            UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                            UniAppManager.app.onQueryButtonDown();
                                            me.setDisabled(true); 
                                            Ext.getBody().unmask();
                                        }
                                    )
                                } else if(record.get('CONFIRM_YN') == 'N') {
                                    sgp100ukrvService.confirmDataList(param, 
                                        function(provider, response) {
                                            UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                            UniAppManager.app.onQueryButtonDown();
                                            me.setDisabled(true);
                                            UniAppManager.setToolbarButtons(['deleteAll'],false); 
                                            Ext.getBody().unmask();
                                        }
                                    )
                                }
                            }
                        }
                    },{
                        xtype: 'button',
                        text: '<t:message code="system.label.sales.basicdatacreation" default="기초데이터생성"/>',  
                        id: 'CREATE_DATA1',
                        name: '',
                        //inputValue: '2',
                        margin: '0 50 10 20',
                        width: 110,                      
                        handler : function(records, grid, record) {
                            var me = this;
                            var activeTabId = tab.getActiveTab().getId(); 
                            Ext.getBody().mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');  
                            //var record = customMasterGrid.getSelectedRecord();
                            if(activeTabId == 'sgp100ukrvCustomGrid') {
                                var param= panelSearch.getValues();
                                param.AGENT_TYPE = customSubForm.getValue('AGENT_TYPE');
                                param.TAB = "CUSTOM";
                                sgp100ukrvService.creatCustomDataList(param,function(provider, response) {
                                    if(!Ext.isEmpty(provider)){
                                    	var newMasterRecords = new Array();
                                    	Ext.each(provider, function(record,i){
                                            
                                    		var newMasterData = {
                                            		'DIV_CODE'             : panelSearch.getValue('DIV_CODE')
                                                    ,'PLAN_YEAR'            : panelSearch.getValue('PLAN_YEAR')
                                                    ,'PLAN_TYPE1'           : panelSearch.getValue('ORDER_TYPE')
                                                    ,'PLAN_TYPE2'           : '2'
                                                    ,'PLAN_TYPE2_CODE'      : record['CUSTOM_CODE']
                                                    ,'LEVEL_KIND'           : '*'
                                                    ,'MONEY_UNIT'           : panelSearch.getValue('MONEY_UNIT')
                                                    ,'ENT_MONEY_UNIT'       : panelSearch.getValue('MONEY_UNIT_DIV')
                                                    ,'CONFIRM_YN'           : record['CONFIRM_YN']
                                                    ,'CUSTOM_CODE'          : record['CUSTOM_CODE']
                                                    ,'CUSTOM_NAME'          : record['CUSTOM_NAME']
                                                    ,'PLAN_SUM'             : record['PLAN_SUM']
                                                    ,'MOD_PLAN_SUM'         : record['MOD_PLAN_SUM']
                                                    ,'A_D_RATE_SUM'         : record['A_D_RATE_SUM']
                                                    ,'PLAN1'                : record['PLAN1']
                                                    ,'MOD_PLAN1'            : record['MOD_PLAN1']
                                                    ,'A_D_RATE1'            : record['A_D_RATE1']
                                                    ,'PLAN2'                : record['PLAN2']
                                                    ,'MOD_PLAN2'            : record['MOD_PLAN2']
                                                    ,'A_D_RATE2'            : record['A_D_RATE2']
                                                    ,'PLAN3'                : record['PLAN3']
                                                    ,'MOD_PLAN3'            : record['MOD_PLAN3']
                                                    ,'A_D_RATE3'            : record['A_D_RATE3']
                                                    ,'PLAN4'                : record['PLAN4']
                                                    ,'MOD_PLAN4'            : record['MOD_PLAN4']
                                                    ,'A_D_RATE4'            : record['A_D_RATE4']
                                                    ,'PLAN5'                : record['PLAN5']
                                                    ,'MOD_PLAN5'            : record['MOD_PLAN5']
                                                    ,'A_D_RATE5'            : record['A_D_RATE5']
                                                    ,'PLAN6'                : record['PLAN6']
                                                    ,'MOD_PLAN6'            : record['MOD_PLAN6']
                                                    ,'A_D_RATE6'            : record['A_D_RATE6']
                                                    ,'PLAN7'                : record['PLAN7']
                                                    ,'MOD_PLAN7'            : record['MOD_PLAN7']
                                                    ,'A_D_RATE7'            : record['A_D_RATE7']
                                                    ,'PLAN8'                : record['PLAN8']
                                                    ,'MOD_PLAN8'            : record['MOD_PLAN8']
                                                    ,'A_D_RATE8'            : record['A_D_RATE8']
                                                    ,'PLAN9'                : record['PLAN9']
                                                    ,'MOD_PLAN9'            : record['MOD_PLAN9']
                                                    ,'A_D_RATE9'            : record['A_D_RATE9']
                                                    ,'PLAN10'               : record['PLAN10']
                                                    ,'MOD_PLAN10'           : record['MOD_PLAN10']
                                                    ,'A_D_RATE10'           : record['A_D_RATE10']
                                                    ,'PLAN11'               : record['PLAN11']
                                                    ,'MOD_PLAN11'           : record['MOD_PLAN11']
                                                    ,'A_D_RATE11'           : record['A_D_RATE11']
                                                    ,'PLAN12'               : record['PLAN12']
                                                    ,'MOD_PLAN12'           : record['MOD_PLAN12']
                                                    ,'A_D_RATE12'           : record['A_D_RATE12']
                                                    ,'UPDATE_DB_USER'       : record['UPDATE_DB_USER']
                                                    ,'UPDATE_DB_TIME'       : record['UPDATE_DB_TIME']
                                                    ,'COMP_CODE'            : record['COMP_CODE']
               								}
               								newMasterRecords[i] = customMasterStore.model.create(newMasterData);
                                            //me.setDisabled(true);   
                                        });
                                    	customMasterStore.loadData(newMasterRecords, true);
                                        UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                        Ext.getBody().unmask();
                                    }
                                }
                                )
                            } else if(activeTabId == 'sgp100ukrvSalePrsnGrid') {
                                var param= panelSearch.getValues();
                                param.TAB = "PERSON";
                                sgp100ukrvService.creatPersonDataList(param, 
                                    function(provider, response) {
                                        if(!Ext.isEmpty(provider)){
                                            Ext.each(provider, function(record,i){
                                                UniAppManager.app.onNewDataButtonDown();
                                                salePrsnMasterGrid.setPersonData(record); 
                                                me.setDisabled(true);   
                                            });
                                            UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                            Ext.getBody().unmask();
                                        }
                                    }
                                )
                            } else if(activeTabId == 'sgp100ukrvItemGrid') {
                                var param= panelSearch.getValues();
                                param.ITEM_ACCOUNT = itemSubForm.getValue('ITEM_ACCOUNT');
                                param.TAB = "ITEM";
                                sgp100ukrvService.creatItemDataList(param, 
                                    function(provider, response) {
                                        if(!Ext.isEmpty(provider)){
                                            Ext.each(provider, function(record,i){
                                                UniAppManager.app.onNewDataButtonDown();
                                                itemMasterGrid.setItemData(record); 
                                                me.setDisabled(true);   
                                            });
                                            UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                            Ext.getBody().unmask();
                                        }
                                    }
                                )
                            } else if(activeTabId == 'sgp100ukrvitemSortGrid') {
                                var param= panelSearch.getValues();
                                param.ITEM_LEVEL = Ext.getCmp('ITEM_LEVEL_ID').getChecked()[0].inputValue;
                                param.TAB = "ITEM_SORT";
                                sgp100ukrvService.creatItemSortDataList(param, 
                                    function(provider, response) {
                                        if(!Ext.isEmpty(provider)){
                                            Ext.each(provider, function(record,i){
                                                UniAppManager.app.onNewDataButtonDown();
                                                itemSortMasterGrid.setItemSortData(record); 
                                                me.setDisabled(true);   
                                            });
                                            UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                            Ext.getBody().unmask();
                                        }
                                    }
                                )
                            } else if(activeTabId == 'sgp100ukrvspokesItemGrid') {
                                var param= panelSearch.getValues();
                                param.ITEM_ACCOUNT = spokesItemSubForm.getValue('ITEM_ACCOUNT');
                                param.TAB = "MODEL";
                                sgp100ukrvService.creatSpokesItemDataList(param, 
                                    function(provider, response) {
                                        if(!Ext.isEmpty(provider)){
                                            Ext.each(provider, function(record,i){
                                                UniAppManager.app.onNewDataButtonDown();
                                                spokesItemMasterGrid.setSpokesItemData(record); 
                                                me.setDisabled(true);   
                                            });
                                            UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                            Ext.getBody().unmask();
                                        }
                                    }
                                )
                            } else if(activeTabId == 'sgp100ukrvcustomerItemGrid') {
                                var param= panelSearch.getValues();
                                param.AGENT_TYPE = customerItemSubForm.getValue('AGENT_TYPE');
                                param.TAB = "CUSTOMMODEL";
                                sgp100ukrvService.creatCustomerItemDataList(param, 
                                    function(provider, response) {
                                        if(!Ext.isEmpty(provider)){
                                            Ext.each(provider, function(record,i){
                                                UniAppManager.app.onNewDataButtonDown();
                                                customerItemMasterGrid.setCustomItemData(record); 
                                                me.setDisabled(true);   
                                            });
                                            UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                            Ext.getBody().unmask();
                                        }
                                    }
                                )
                            } else if(activeTabId == 'sgp100ukrvSaleTypeGrid') {
                                var param= panelSearch.getValues();
                                param.TAB = "SALE_TYPE";
                                sgp100ukrvService.creatSaleTypeDataList(param, 
                                    function(provider, response) {
                                        if(!Ext.isEmpty(provider)){
                                            Ext.each(provider, function(record,i){
                                                UniAppManager.app.onNewDataButtonDown();
                                                saleTypeGrid.setSaleTypeData(record); 
                                                me.setDisabled(true);   
                                            });
                                            UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                            Ext.getBody().unmask();
                                        }
                                    }
                                )
                            } else if(activeTabId == 'sgp100ukrvcustomitemSortGrid') {
                                var param= panelSearch.getValues();
                                param.ITEM_LEVEL = Ext.getCmp('CUSTOM_ITEM_LEVEL_ID').getChecked()[0].inputValue;
                                param.TAB = "CUSTOM_ITEM_SORT";
                                sgp100ukrvService.creatCustomItemSortDataList(param, 
                                    function(provider, response) {
                                        if(!Ext.isEmpty(provider)){
                                            Ext.each(provider, function(record,i){
                                                UniAppManager.app.onNewDataButtonDown();
                                                customitemSortMasterGrid.setCustomItemSortData(record); 
                                                me.setDisabled(true);   
                                            });
                                            UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                            Ext.getBody().unmask();
                                        }
                                    }
                                )
                            }
                        }
                    }
               ]
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
                        var labelText = invalid.items[0]['fieldLabel']+' : ';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
                    }

                    Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
                    invalid.items[0].focus();
                } else {
//                  this.mask();
//                  var fields = this.getForm().getFields();
//                  Ext.each(fields.items, function(item) {
//                      if(Ext.isDefined(item.holdable) ){
//                          if (item.holdable == 'hold') {
//                              item.setReadOnly(true); 
//                          }
//                      } 
//                      if(item.isPopupField)   {
//                          var popupFC = item.up('uniPopupField')  ;                           
//                          if(popupFC.holdable == 'hold') {
//                              popupFC.setReadOnly(true);
//                          }
//                      }
//                  })
                }
            } else {
                //this.unmask();
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
    });
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 4, tableAttrs: {width: '100%'}},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
            fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
            name: 'DIV_CODE', 
            xtype: 'uniCombobox', 
            comboType: 'BOR120',
            allowBlank:false,
            holdable: 'hold',
            value: UserInfo.divCode,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('DIV_CODE', newValue);
                }
            }
        },{
            fieldLabel: '<t:message code="system.label.sales.planyear" default="계획년도"/>',
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
            fieldLabel: '<t:message code="system.label.sales.planamountunit" default="계획금액단위"/>',
            name:'MONEY_UNIT_DIV',  
            xtype: 'uniCombobox', 
            comboType:'AU',
            comboCode:'B042',
            allowBlank: false,
            holdable: 'hold',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('MONEY_UNIT_DIV', newValue);
                }
            }
        },{
            xtype: 'container',
            layout : {type : 'uniTable'},
            tdAttrs: {align: 'right'},  
            padding: '0 20 0 0',
            items:[{
                xtype: 'button',
                text: '<t:message code="system.label.sales.yearplanconfirm" default="년초계획확정"/>',   
                name: '',
                id: 'CONFIRM_DATA2',
                itemId: 'btnViewAutoSlip',
                width: 110,                  
                handler : function(records, grid, record) {
                    var me = this;
                    var activeTabId = tab.getActiveTab().getId(); 
                    Ext.getBody().mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');          
                    if(activeTabId == 'sgp100ukrvCustomGrid') {
                        var record = customMasterGrid.getSelectedRecord();
                        var param= panelSearch.getValues();
                        param.AGENT_TYPE = customSubForm.getValue('AGENT_TYPE');
                        param.PLAN_TYPE1 = record.data['PLAN_TYPE1']
                        param.PLAN_TYPE2 = record.data['PLAN_TYPE2']
                        param.PLAN_TYPE2_CODE = record.data['PLAN_TYPE2_CODE']
                        param.LEVEL_KIND = record.data['LEVEL_KIND']
                        param.AGENT_TYPE = customSubForm.getValue('AGENT_TYPE');
                        param.TAB = "CUSTOM";
                        if(record.get('CONFIRM_YN') == 'Y') {
                            sgp100ukrvService.cancleDataList(param, 
                                function(provider, response) {
                                    UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                    UniAppManager.app.onQueryButtonDown();
                                    me.setDisabled(true); 
                                    Ext.getBody().unmask();
                                }
                            )
                        } else if(record.get('CONFIRM_YN') == 'N') {
                            sgp100ukrvService.confirmDataList(param, 
                                function(provider, response) {
                                    UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                    UniAppManager.app.onQueryButtonDown();
                                    me.setDisabled(true);
                                    UniAppManager.setToolbarButtons(['deleteAll'],false); 
                                    Ext.getBody().unmask();
                                }
                            )
                        }
                    } else if(activeTabId == 'sgp100ukrvSalePrsnGrid') {
                        var record = salePrsnMasterGrid.getSelectedRecord();
                        var param= panelSearch.getValues();
                        param.PLAN_TYPE1 = record.data['PLAN_TYPE1']
                        param.PLAN_TYPE2 = record.data['PLAN_TYPE2']
                        param.PLAN_TYPE2_CODE = record.data['PLAN_TYPE2_CODE']
                        param.LEVEL_KIND = record.data['LEVEL_KIND']
                        param.TAB = "PERSON";
                        if(record.get('CONFIRM_YN') == 'Y') {
                            sgp100ukrvService.cancleDataList(param, 
                                function(provider, response) {
                                    UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                    UniAppManager.app.onQueryButtonDown();
                                    me.setDisabled(true);
                                    Ext.getBody().unmask(); 
                                }
                            )
                        } else if(record.get('CONFIRM_YN') == 'N') {
                            sgp100ukrvService.confirmDataList(param, 
                                function(provider, response) {
                                    UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                    UniAppManager.app.onQueryButtonDown();
                                    me.setDisabled(true);
                                    UniAppManager.setToolbarButtons(['deleteAll'],false);  
                                    Ext.getBody().unmask();
                                }
                            )
                        }
                    } else if(activeTabId == 'sgp100ukrvItemGrid') {
                        var record = itemMasterGrid.getSelectedRecord();
                        var param= panelSearch.getValues();
                        param.PLAN_TYPE1 = record.data['PLAN_TYPE1']
                        param.PLAN_TYPE2 = record.data['PLAN_TYPE2']
                        param.PLAN_TYPE2_CODE = record.data['PLAN_TYPE2_CODE']
                        param.LEVEL_KIND = record.data['LEVEL_KIND']
                        param.ITEM_ACCOUNT = itemSubForm.getValue('ITEM_ACCOUNT');
                        param.TAB = "ITEM";
                        if(record.get('CONFIRM_YN') == 'Y') {
                            sgp100ukrvService.cancleDataList(param, 
                                function(provider, response) {
                                    UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                    UniAppManager.app.onQueryButtonDown();
                                    me.setDisabled(true); 
                                    Ext.getBody().unmask();
                                }
                            )
                        } else if(record.get('CONFIRM_YN') == 'N') {
                            sgp100ukrvService.confirmDataList(param, 
                                function(provider, response) {
                                    UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                    UniAppManager.app.onQueryButtonDown();
                                    me.setDisabled(true);
                                    UniAppManager.setToolbarButtons(['deleteAll'],false); 
                                    Ext.getBody().unmask(); 
                                }
                            )
                        }
                    } else if(activeTabId == 'sgp100ukrvitemSortGrid') {
                        var record = itemSortMasterGrid.getSelectedRecord();
                        var param= panelSearch.getValues();
                        param.PLAN_TYPE1 = record.data['PLAN_TYPE1']
                        param.PLAN_TYPE2 = record.data['PLAN_TYPE2']
                        param.PLAN_TYPE2_CODE = record.data['PLAN_TYPE2_CODE']
                        param.LEVEL_KIND = record.data['LEVEL_KIND']
                        param.ITEM_LEVEL = Ext.getCmp('ITEM_LEVEL_ID').getChecked()[0].inputValue;
                        param.TAB = "ITEM_SORT";
                        if(record.get('CONFIRM_YN') == 'Y') {
                            sgp100ukrvService.cancleDataList(param, 
                                function(provider, response) {
                                    UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                    UniAppManager.app.onQueryButtonDown();
                                    me.setDisabled(true); 
                                    Ext.getBody().unmask();
                                }
                            )
                        } else if(record.get('CONFIRM_YN') == 'N') {
                            sgp100ukrvService.confirmDataList(param, 
                                function(provider, response) {
                                    UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                    UniAppManager.app.onQueryButtonDown();
                                    me.setDisabled(true);
                                    UniAppManager.setToolbarButtons(['deleteAll'],false); 
                                    Ext.getBody().unmask();
                                }
                            )
                        }
                    } else if(activeTabId == 'sgp100ukrvspokesItemGrid') {
                        var record = spokesItemMasterGrid.getSelectedRecord();
                        var param= panelSearch.getValues();
                        param.PLAN_TYPE1 = record.data['PLAN_TYPE1']
                        param.PLAN_TYPE2 = record.data['PLAN_TYPE2']
                        param.PLAN_TYPE2_CODE = record.data['PLAN_TYPE2_CODE']
                        param.LEVEL_KIND = record.data['LEVEL_KIND']
                        param.ITEM_ACCOUNT = itemSubForm.getValue('ITEM_ACCOUNT');
                        param.TAB = "MODEL";
                        if(record.get('CONFIRM_YN') == 'Y') {
                            sgp100ukrvService.cancleDataList(param, 
                                function(provider, response) {
                                    UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                    UniAppManager.app.onQueryButtonDown();
                                    me.setDisabled(true); 
                                    Ext.getBody().unmask();
                                }
                            )
                        } else if(record.get('CONFIRM_YN') == 'N') {
                            sgp100ukrvService.confirmDataList(param, 
                                function(provider, response) {
                                    UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                    UniAppManager.app.onQueryButtonDown();
                                    me.setDisabled(true);
                                    UniAppManager.setToolbarButtons(['deleteAll'],false);
                                    Ext.getBody().unmask(); 
                                }
                            )
                        }
                    } else if(activeTabId == 'sgp100ukrvcustomerItemGrid') {
                        var record = customerItemMasterGrid.getSelectedRecord();
                        var param= panelSearch.getValues();
                        param.PLAN_TYPE1 = record.data['PLAN_TYPE1']
                        param.PLAN_TYPE2 = record.data['PLAN_TYPE2']
                        param.PLAN_TYPE2_CODE = record.data['PLAN_TYPE2_CODE']
                        param.LEVEL_KIND = record.data['LEVEL_KIND']
                        param.AGENT_TYPE = customSubForm.getValue('AGENT_TYPE');
                        param.TAB = "";
                        if(record.get('CONFIRM_YN') == 'Y') {
                            sgp100ukrvService.cancleDataList(param, 
                                function(provider, response) {
                                    UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                    UniAppManager.app.onQueryButtonDown();
                                    me.setDisabled(true); 
                                    Ext.getBody().unmask();
                                }
                            )
                        } else if(record.get('CONFIRM_YN') == 'N') {
                            sgp100ukrvService.confirmDataList(param, 
                                function(provider, response) {
                                    UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                    UniAppManager.app.onQueryButtonDown();
                                    me.setDisabled(true);
                                    UniAppManager.setToolbarButtons(['deleteAll'],false); 
                                    Ext.getBody().unmask();
                                }
                            )
                        }
                    } else if(activeTabId == 'sgp100ukrvSaleTypeGrid') {
                        var record = saleTypeGrid.getSelectedRecord();
                        var param= panelSearch.getValues();
                        param.PLAN_TYPE1 = record.data['PLAN_TYPE1']
                        param.PLAN_TYPE2 = record.data['PLAN_TYPE2']
                        param.PLAN_TYPE2_CODE = record.data['PLAN_TYPE2_CODE']
                        param.LEVEL_KIND = '*'
                        param.TAB = "SALE_TYPE";
                        if(record.get('CONFIRM_YN') == 'Y') {
                            sgp100ukrvService.cancleDataList(param, 
                                function(provider, response) {
                                    UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                    UniAppManager.app.onQueryButtonDown();
                                    me.setDisabled(true); 
                                    Ext.getBody().unmask();
                                }
                            )
                        } else if(record.get('CONFIRM_YN') == 'N') {
                            sgp100ukrvService.confirmDataList(param, 
                                function(provider, response) {
                                    UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                    UniAppManager.app.onQueryButtonDown();
                                    me.setDisabled(true);
                                    UniAppManager.setToolbarButtons(['deleteAll'],false);
                                    Ext.getBody().unmask();
                                }
                            )
                        }
                    } else if(activeTabId == 'sgp100ukrvcustomitemSortGrid') {
                        var record = customitemSortMasterGrid.getSelectedRecord();
                        var param= panelSearch.getValues();
                        param.PLAN_TYPE1 = record.data['PLAN_TYPE1']
                        param.PLAN_TYPE2 = record.data['PLAN_TYPE2']
                        param.PLAN_TYPE2_CODE = record.data['PLAN_TYPE2_CODE']
                        param.LEVEL_KIND = record.data['LEVEL_KIND']
                        param.ITEM_LEVEL = Ext.getCmp('CUSTOM_ITEM_LEVEL_ID').getChecked()[0].inputValue;
                        param.TAB = "CUSTOM_ITEM_SORT";
                        if(record.get('CONFIRM_YN') == 'Y') {
                            sgp100ukrvService.cancleDataList(param, 
                                function(provider, response) {
                                    UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                    UniAppManager.app.onQueryButtonDown();
                                    me.setDisabled(true); 
                                    Ext.getBody().unmask();
                                }
                            )
                        } else if(record.get('CONFIRM_YN') == 'N') {
                            sgp100ukrvService.confirmDataList(param, 
                                function(provider, response) {
                                    UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                    UniAppManager.app.onQueryButtonDown();
                                    me.setDisabled(true);
                                    UniAppManager.setToolbarButtons(['deleteAll'],false); 
                                    Ext.getBody().unmask();
                                }
                            )
                        }
                    } 
                }   
            }]
        },{
            fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
            name:'ORDER_TYPE',  
            xtype: 'uniCombobox', 
            comboType:'AU',
            comboCode:'S002',
            allowBlank: false,
            holdable: 'hold',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('ORDER_TYPE', newValue);
                }
            }
        },{
            fieldLabel: '<t:message code="system.label.sales.currency" default="화폐"/>',
            name:'MONEY_UNIT',  
            xtype: 'uniCombobox', 
            comboType:'AU',
            comboCode:'B004',
            displayField: 'value',
            allowBlank: false,
            holdable: 'hold',
            fieldStyle: 'text-align: center;',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('MONEY_UNIT', newValue);
                }
            }
        },{
            xtype: 'component'
        },{
            xtype: 'container',
            layout : {type : 'uniTable'},
            tdAttrs: {align: 'right'},  
            padding: '0 20 0 0',
            items:[{
                xtype: 'button',
                text: '<t:message code="system.label.sales.basicdatacreation" default="기초데이터생성"/>',   
                name: '',
                id: 'CREATE_DATA2',
                width: 110,                  
                handler : function(records, grid, record) {
                    var me = this;
                    var activeTabId = tab.getActiveTab().getId();  
                    Ext.getBody().mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');           
                    if(activeTabId == 'sgp100ukrvCustomGrid') {
                        var param= panelSearch.getValues();
                        param.AGENT_TYPE = customSubForm.getValue('AGENT_TYPE');
                        param.TAB = "CUSTOM";
                        sgp100ukrvService.creatCustomDataList(param,function(provider, response) {
                                if(!Ext.isEmpty(provider)){
                                	var newMasterRecords = new Array();
                                	Ext.each(provider, function(record,i){
                                        
                                		var newMasterData = {
                                        		'DIV_CODE'             : panelSearch.getValue('DIV_CODE')
                                                ,'PLAN_YEAR'            : panelSearch.getValue('PLAN_YEAR')
                                                ,'PLAN_TYPE1'           : panelSearch.getValue('ORDER_TYPE')
                                                ,'PLAN_TYPE2'           : '2'
                                                ,'PLAN_TYPE2_CODE'      : record['CUSTOM_CODE']
                                                ,'LEVEL_KIND'           : '*'
                                                ,'MONEY_UNIT'           : panelSearch.getValue('MONEY_UNIT')
                                                ,'ENT_MONEY_UNIT'       : panelSearch.getValue('MONEY_UNIT_DIV')
                                                ,'CONFIRM_YN'           : record['CONFIRM_YN']
                                                ,'CUSTOM_CODE'          : record['CUSTOM_CODE']
                                                ,'CUSTOM_NAME'          : record['CUSTOM_NAME']
                                                ,'PLAN_SUM'             : record['PLAN_SUM']
                                                ,'MOD_PLAN_SUM'         : record['MOD_PLAN_SUM']
                                                ,'A_D_RATE_SUM'         : record['A_D_RATE_SUM']
                                                ,'PLAN1'                : record['PLAN1']
                                                ,'MOD_PLAN1'            : record['MOD_PLAN1']
                                                ,'A_D_RATE1'            : record['A_D_RATE1']
                                                ,'PLAN2'                : record['PLAN2']
                                                ,'MOD_PLAN2'            : record['MOD_PLAN2']
                                                ,'A_D_RATE2'            : record['A_D_RATE2']
                                                ,'PLAN3'                : record['PLAN3']
                                                ,'MOD_PLAN3'            : record['MOD_PLAN3']
                                                ,'A_D_RATE3'            : record['A_D_RATE3']
                                                ,'PLAN4'                : record['PLAN4']
                                                ,'MOD_PLAN4'            : record['MOD_PLAN4']
                                                ,'A_D_RATE4'            : record['A_D_RATE4']
                                                ,'PLAN5'                : record['PLAN5']
                                                ,'MOD_PLAN5'            : record['MOD_PLAN5']
                                                ,'A_D_RATE5'            : record['A_D_RATE5']
                                                ,'PLAN6'                : record['PLAN6']
                                                ,'MOD_PLAN6'            : record['MOD_PLAN6']
                                                ,'A_D_RATE6'            : record['A_D_RATE6']
                                                ,'PLAN7'                : record['PLAN7']
                                                ,'MOD_PLAN7'            : record['MOD_PLAN7']
                                                ,'A_D_RATE7'            : record['A_D_RATE7']
                                                ,'PLAN8'                : record['PLAN8']
                                                ,'MOD_PLAN8'            : record['MOD_PLAN8']
                                                ,'A_D_RATE8'            : record['A_D_RATE8']
                                                ,'PLAN9'                : record['PLAN9']
                                                ,'MOD_PLAN9'            : record['MOD_PLAN9']
                                                ,'A_D_RATE9'            : record['A_D_RATE9']
                                                ,'PLAN10'               : record['PLAN10']
                                                ,'MOD_PLAN10'           : record['MOD_PLAN10']
                                                ,'A_D_RATE10'           : record['A_D_RATE10']
                                                ,'PLAN11'               : record['PLAN11']
                                                ,'MOD_PLAN11'           : record['MOD_PLAN11']
                                                ,'A_D_RATE11'           : record['A_D_RATE11']
                                                ,'PLAN12'               : record['PLAN12']
                                                ,'MOD_PLAN12'           : record['MOD_PLAN12']
                                                ,'A_D_RATE12'           : record['A_D_RATE12']
                                                ,'UPDATE_DB_USER'       : record['UPDATE_DB_USER']
                                                ,'UPDATE_DB_TIME'       : record['UPDATE_DB_TIME']
                                                ,'COMP_CODE'            : record['COMP_CODE']
           								}
           								newMasterRecords[i] = customMasterStore.model.create(newMasterData);
                                        //me.setDisabled(true);   
                                    });
                                	customMasterStore.loadData(newMasterRecords, true);
                                    UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                    Ext.getBody().unmask();
                                }
                            }
                        )
                    } else if(activeTabId == 'sgp100ukrvSalePrsnGrid') {
                        var param= panelSearch.getValues();
                        param.TAB = "PERSON";
                        sgp100ukrvService.creatPersonDataList(param, 
                            function(provider, response) {
                                if(!Ext.isEmpty(provider)){
                                    Ext.each(provider, function(record,i){
                                        UniAppManager.app.onNewDataButtonDown();
                                        salePrsnMasterGrid.setPersonData(record); 
                                        me.setDisabled(true);   
                                    });
                                    UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                    Ext.getBody().unmask();
                                }
                            }
                        )
                    } else if(activeTabId == 'sgp100ukrvItemGrid') {
                        var param= panelSearch.getValues();
                        param.ITEM_ACCOUNT = itemSubForm.getValue('ITEM_ACCOUNT');
                        param.TAB = "ITEM";
                        sgp100ukrvService.creatItemDataList(param, 
                            function(provider, response) {
                                if(!Ext.isEmpty(provider)){
                                    Ext.each(provider, function(record,i){
                                        UniAppManager.app.onNewDataButtonDown();
                                        itemMasterGrid.setItemData(record); 
                                        me.setDisabled(true);   
                                    });
                                    UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                    Ext.getBody().unmask();
                                }
                            }
                        )
                    } else if(activeTabId == 'sgp100ukrvitemSortGrid') {
                        var param= panelSearch.getValues();
                        param.ITEM_LEVEL = Ext.getCmp('ITEM_LEVEL_ID').getChecked()[0].inputValue;
                        param.TAB = "ITEM_SORT";
                        sgp100ukrvService.creatItemSortDataList(param, 
                            function(provider, response) {
                                if(!Ext.isEmpty(provider)){
                                    Ext.each(provider, function(record,i){
                                        UniAppManager.app.onNewDataButtonDown();
                                        itemSortMasterGrid.setItemSortData(record); 
                                        me.setDisabled(true);   
                                    });
                                    UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                    Ext.getBody().unmask();
                                }
                            }
                        )
                    } else if(activeTabId == 'sgp100ukrvspokesItemGrid') {
                        var param= panelSearch.getValues();
                        param.ITEM_ACCOUNT = spokesItemSubForm.getValue('ITEM_ACCOUNT');
                        param.TAB = "MODEL";
                        sgp100ukrvService.creatSpokesItemDataList(param, 
                            function(provider, response) {
                                if(!Ext.isEmpty(provider)){
                                    Ext.each(provider, function(record,i){
                                        UniAppManager.app.onNewDataButtonDown();
                                        spokesItemMasterGrid.setSpokesItemData(record); 
                                        me.setDisabled(true);   
                                    });
                                    UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                    Ext.getBody().unmask();
                                }
                            }
                        )
                    } else if(activeTabId == 'sgp100ukrvcustomerItemGrid') {
                        var param= panelSearch.getValues();
                        param.AGENT_TYPE = customerItemSubForm.getValue('AGENT_TYPE');
                        param.TAB = "CUSTOMMODEL";
                        sgp100ukrvService.creatCustomerItemDataList(param, 
                            function(provider, response) {
                                if(!Ext.isEmpty(provider)){
                                    Ext.each(provider, function(record,i){
                                        UniAppManager.app.onNewDataButtonDown();
                                        customerItemMasterGrid.setCustomItemData(record); 
                                        me.setDisabled(true);   
                                    });
                                    UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                    Ext.getBody().unmask();
                                }
                            }
                        )
                    } else if(activeTabId == 'sgp100ukrvSaleTypeGrid') {
                                var param= panelSearch.getValues();
                                param.TAB = "SALE_TYPE";
                                sgp100ukrvService.creatSaleTypeDataList(param, 
                                    function(provider, response) {
                                        if(!Ext.isEmpty(provider)){
                                            Ext.each(provider, function(record,i){
                                                UniAppManager.app.onNewDataButtonDown();
                                                saleTypeGrid.setSaleTypeData(record); 
                                                me.setDisabled(true);   
                                            });
                                            UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                            Ext.getBody().unmask();
                                        }
                                    }
                                )
                      } else if(activeTabId == 'sgp100ukrvcustomitemSortGrid') {
                        var param= panelSearch.getValues();
                        param.ITEM_LEVEL = Ext.getCmp('CUSTOM_ITEM_LEVEL_ID').getChecked()[0].inputValue;
                        param.TAB = "CUSTOM_ITEM_SORT";
                        sgp100ukrvService.creatCustomItemSortDataList(param, 
                            function(provider, response) {
                                if(!Ext.isEmpty(provider)){
                                    Ext.each(provider, function(record,i){
                                        UniAppManager.app.onNewDataButtonDown();
                                        customitemSortMasterGrid.setCustomItemSortData(record); 
                                        me.setDisabled(true);   
                                    });
                                    UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                    Ext.getBody().unmask();
                                }
                            }
                        )
                    }
                }   
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
                        var labelText = invalid.items[0]['fieldLabel']+' : ';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
                    }

//                  Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');    중복알림 금지
                    invalid.items[0].focus();
                } else {
                    //this.mask();
//                  var fields = this.getForm().getFields();
//                  Ext.each(fields.items, function(item) {
//                      if(Ext.isDefined(item.holdable) ){
//                          if (item.holdable == 'hold') {
//                              item.setReadOnly(true); 
//                          }
//                      } 
//                      if(item.isPopupField)   {
//                          var popupFC = item.up('uniPopupField')  ;                           
//                          if(popupFC.holdable == 'hold') {
//                              popupFC.setReadOnly(true);
//                          }
//                      }
//                  })
                }
            } else {
                //this.unmask();
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
    });
    
    var customSubForm = Unilite.createSearchForm('customSubForm',{                      
        padding: '0 0 0 0',
        layout:{type:'uniTable', columns: '2'},
        items: [{
//              margin: '5 0 5 0',
                fieldLabel: '<t:message code="system.label.sales.clienttype" default="고객분류"/>',
                name:'AGENT_TYPE',  
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'B055',
                value: '1',
                allowBlank: false
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
                        var labelText = invalid.items[0]['fieldLabel']+' : ';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
                    }

                    Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
                    invalid.items[0].focus();
                }
            }
            return r;
        }           
        });       

        
    var itemSubForm = Unilite.createSearchForm('itemSubForm',{
        padding: '0 0 0 0',
        layout: {type:'uniTable', columns: '2'},
        items: [{
//              margin: '5 0 5 0',
                fieldLabel: '<t:message code="system.label.sales.itemaccount" default="품목계정"/>',
                name:'ITEM_ACCOUNT',    
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'B020',
                allowBlank: false
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
                        var labelText = invalid.items[0]['fieldLabel']+' : ';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
                    }

                    Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
                    invalid.items[0].focus();
                } 
            }
            return r;
        }           
        });
        
        var itemSortSubForm = Unilite.createSearchForm('itemSortSubForm',{
        padding: '0 0 0 0',
        layout: {type:'uniTable', columns: '2'},
        items: [{
                xtype: 'radiogroup',
                fieldLabel: '<t:message code="system.label.sales.classficationselection" default="분류선택"/>',
                id: 'ITEM_LEVEL_ID',
                items : [{
                    boxLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
                    name: 'ITEM_LEVEL' ,
                    inputValue: '1',                        
                    checked: true,
                    width:60
                }, {boxLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
                    name: 'ITEM_LEVEL' ,
                    inputValue: '2',
                    width:60
                }, {boxLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
                    name: 'ITEM_LEVEL' ,
                    inputValue: '3',
                    width:60
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                    	
//                    	UniAppManager.app.onQueryButtonDown(newValue.ITEM_LEVEL); 
                    	itemSortMasterStore.loadStoreRecords(newValue.ITEM_LEVEL); 
                    	
			            if(newValue.ITEM_LEVEL == '1') {
			                itemSortMasterGrid.getColumn('S_CODE1').setVisible(true);
			                itemSortMasterGrid.getColumn('S_CODE2').setVisible(false);
			                itemSortMasterGrid.getColumn('S_CODE3').setVisible(false);		                
			            } else if(newValue.ITEM_LEVEL == '2') {
			                itemSortMasterGrid.getColumn('S_CODE1').setVisible(false);
			                itemSortMasterGrid.getColumn('S_CODE2').setVisible(true);
			                itemSortMasterGrid.getColumn('S_CODE3').setVisible(false);		                
			            } else {
			                itemSortMasterGrid.getColumn('S_CODE1').setVisible(false);
			                itemSortMasterGrid.getColumn('S_CODE2').setVisible(false);
			                itemSortMasterGrid.getColumn('S_CODE3').setVisible(true);		                
			            }                    	
//                        UniAppManager.app.setHiddenColumn();
			            
			            excelWindow4 = '';   //엑셀참조팝업 분류구분에 따라 컬럼HIDDEN처리 되도록
                          
                    }
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
                        var labelText = invalid.items[0]['fieldLabel']+' : ';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
                    }

                    Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
                    invalid.items[0].focus();
                } 
            }
            return r;
        }           
        });
        
        var spokesItemSubForm = Unilite.createSearchForm('spokesItemSubForm',{
        padding: '0 0 0 0',
        layout: {type:'uniTable', columns: '2'},
        items: [{
//              margin: '5 0 5 0',
                fieldLabel: '<t:message code="system.label.sales.itemaccount" default="품목계정"/>',
                name:'ITEM_ACCOUNT',    
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'B020',
                allowBlank: false
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
                        var labelText = invalid.items[0]['fieldLabel']+' : ';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
                    }

                    Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
                    invalid.items[0].focus();
                } 
            }
            return r;
        }           
        });
        
        var customerItemSubForm = Unilite.createSearchForm('customerItemSubForm',{
        padding: '0 0 0 0',
        layout: {type:'uniTable', columns: '2'},
        items: [{
//              margin: '5 0 5 0',
                fieldLabel: '<t:message code="system.label.sales.clienttype" default="고객분류"/>',
                name:'AGENT_TYPE',  
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'B055',
                value: '1',
                allowBlank: false
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
                        var labelText = invalid.items[0]['fieldLabel']+' : ';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
                    }

                    Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
                    invalid.items[0].focus();
                } 
            }
            return r;
        }           
        });
           
        
        var customitemSortSubForm = Unilite.createSearchForm('customitemSortSubForm',{
        padding: '0 0 0 0',
        layout: {type:'uniTable', columns: '2'},
        items: [{
                xtype: 'radiogroup',
                fieldLabel: '<t:message code="system.label.sales.classficationselection" default="분류선택"/>',
                id: 'CUSTOM_ITEM_LEVEL_ID',
                items : [{
                    boxLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
                    name: 'ITEM_LEVEL' ,
                    inputValue: '1',                        
                    checked: true,
                    width:60
                }, {boxLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
                    name: 'ITEM_LEVEL' ,
                    inputValue: '2',
                    width:60
                }, {boxLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
                    name: 'ITEM_LEVEL' ,
                    inputValue: '3',
                    width:60
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
//                        UniAppManager.app.onQueryButtonDown(newValue.ITEM_LEVEL); 
                        customitemSortMasterStore.loadStoreRecords(newValue.ITEM_LEVEL); 
                        
			            if(newValue.ITEM_LEVEL == '1') {
			                customitemSortMasterGrid.getColumn('S_CODE1').setVisible(true);
			                customitemSortMasterGrid.getColumn('S_CODE2').setVisible(false);
			                customitemSortMasterGrid.getColumn('S_CODE3').setVisible(false);		                
			            } else if(newValue.ITEM_LEVEL == '2') {
			                customitemSortMasterGrid.getColumn('S_CODE1').setVisible(false);
			                customitemSortMasterGrid.getColumn('S_CODE2').setVisible(true);
			                customitemSortMasterGrid.getColumn('S_CODE3').setVisible(false);			                
			            } else {
			                customitemSortMasterGrid.getColumn('S_CODE1').setVisible(false);
			                customitemSortMasterGrid.getColumn('S_CODE2').setVisible(false);
			                customitemSortMasterGrid.getColumn('S_CODE3').setVisible(true);	                
			            } 
			            
			            excelWindow10 = '';   //엑셀참조팝업 분류구분에 따라 컬럼HIDDEN처리 되도록
				            
                    }
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
                        var labelText = invalid.items[0]['fieldLabel']+' : ';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
                    }

                    Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
                    invalid.items[0].focus();
                } 
            }
            return r;
        }           
        });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */

    var customMasterGrid = Unilite.createGrid('sgp100ukrvCustomMasterGrid', {
        layout : 'fit',        
        store: customMasterStore,
        flex: 1,
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
		tbar: [{
			itemId: 'excelBtn1',
			text: '엑셀업로드',
			handler: function() {
					openExcelWindow1();
			}
		}],        
        columns:  [{ dataIndex: 'DIV_CODE'              ,           width:86, hidden: true }
                  ,{ dataIndex: 'PLAN_YEAR'             ,           width:86, hidden: true }
                  ,{ dataIndex: 'PLAN_TYPE1'            ,           width:86, hidden: true }
                  ,{ dataIndex: 'PLAN_TYPE2'            ,           width:86, hidden: true }
                  ,{ dataIndex: 'PLAN_TYPE2_CODE'       ,           width:86, hidden: true }
                  ,{ dataIndex: 'LEVEL_KIND'            ,           width:86, hidden: true }
                  ,{ dataIndex: 'MONEY_UNIT'            ,           width:86, hidden: true }
                  ,{ dataIndex: 'ENT_MONEY_UNIT'        ,           width:86, hidden: true }
                  ,{ dataIndex: 'CONFIRM_YN'            ,           width:86, hidden: true }
				  ,{ dataIndex: 'CUSTOM_CODE'			, width: 100	,
						editor: Unilite.popup('AGENT_CUST_G',{
							autoPopup:true,
							listeners		: { 
								'onSelected': {
									fn: function(records, type  ){
										var grdRecord = customMasterGrid.uniOpt.currentRecord;
										grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
										grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
										grdRecord.set('PLAN_TYPE2_CODE', records[0]['CUSTOM_CODE']);
									},
									scope: this
								},
								'onClear' : function(type)	{
									var grdRecord = customMasterGrid.uniOpt.currentRecord;
									grdRecord.set('CUSTOM_CODE','');
									grdRecord.set('CUSTOM_NAME','');
									grdRecord.set('PLAN_TYPE2_CODE'      , '');
								},
								applyextparam: function(popup){
									popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
									popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
								}						
							}
						})
					},
					{ dataIndex: 'CUSTOM_NAME'			, width: 160	,
						editor: Unilite.popup('AGENT_CUST_G',{
							autoPopup:true,
							listeners		: { 
								'onSelected': {
									fn: function(records, type  ){
										var grdRecord = customMasterGrid.uniOpt.currentRecord;
										grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
										grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
										grdRecord.set('PLAN_TYPE2_CODE', records[0]['CUSTOM_CODE']);
									},
									scope: this
								},
								'onClear' : function(type)	{
									var grdRecord = customMasterGrid.uniOpt.currentRecord;
									grdRecord.set('CUSTOM_CODE','');
									grdRecord.set('CUSTOM_NAME','');
									grdRecord.set('PLAN_TYPE2_CODE'      , '');
								},
								applyextparam: function(popup){
									popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
									popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
								}						
							}
						})
					}
                  ,{
                    text: '<t:message code="system.label.sales.totalamount" default="합계"/>',
                    columns:[
                        { dataIndex:    'PLAN_SUM'              ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_SUM'          ,           width:86 }
                       ,{ dataIndex:    'A_D_RATE_SUM'          ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.january" default="1월"/>',
                    columns:[
                        { dataIndex:    'PLAN1'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN1'             ,           width:86 }
                       ,{ dataIndex:    'A_D_RATE1'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.february" default="2월"/>',
                    columns:[
                        { dataIndex:    'PLAN2'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN2'             ,           width:86 }
                       ,{ dataIndex:    'A_D_RATE2'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.march" default="3월"/>',
                    columns:[
                        { dataIndex:    'PLAN3'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN3'             ,           width:86 }
                       ,{ dataIndex:    'A_D_RATE3'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.april" default="4월"/>',
                    columns:[
                        { dataIndex:    'PLAN4'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN4'             ,           width:86 }
                       ,{ dataIndex:    'A_D_RATE4'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.may" default="5월"/>',
                    columns:[
                       { dataIndex: 'PLAN5'                 ,           width:86 }
                      ,{ dataIndex: 'MOD_PLAN5'             ,           width:86 }
                      ,{ dataIndex: 'A_D_RATE5'             ,           width:86 }
                    
                    ]
                  },{
                    text: '<t:message code="system.label.sales.june" default="6월"/>',
                    columns:[
                       { dataIndex: 'PLAN6'                 ,           width:86 }
                      ,{ dataIndex: 'MOD_PLAN6'             ,           width:86 }
                      ,{ dataIndex: 'A_D_RATE6'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.july" default="7월"/>',
                    columns:[
                       { dataIndex: 'PLAN7'                 ,           width:86 }
                      ,{ dataIndex: 'MOD_PLAN7'             ,           width:86 }
                      ,{ dataIndex: 'A_D_RATE7'             ,           width:86 } 
                    ]
                  },{
                    text: '<t:message code="system.label.sales.august" default="8월"/>',
                    columns:[
                       { dataIndex: 'PLAN8'                 ,           width:86 }
                      ,{ dataIndex: 'MOD_PLAN8'             ,           width:86 }
                      ,{ dataIndex: 'A_D_RATE8'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.september" default="9월"/>',
                    columns:[
                       { dataIndex: 'PLAN9'                 ,           width:86 }
                      ,{ dataIndex: 'MOD_PLAN9'             ,           width:86 }
                      ,{ dataIndex: 'A_D_RATE9'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.october" default="10월"/>',
                    columns:[
                       { dataIndex: 'PLAN10'                ,           width:86 }
                      ,{ dataIndex: 'MOD_PLAN10'            ,           width:86 }
                      ,{ dataIndex: 'A_D_RATE10'            ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.november" default="11월"/>',
                    columns:[
                       { dataIndex: 'PLAN11'                ,           width:86 }
                      ,{ dataIndex: 'MOD_PLAN11'            ,           width:86 }
                      ,{ dataIndex: 'A_D_RATE11'            ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.december" default="12월"/>',
                    columns:[
                       { dataIndex: 'PLAN12'                ,           width:86 }
                      ,{ dataIndex: 'MOD_PLAN12'            ,           width:86 }
                      ,{ dataIndex: 'A_D_RATE12'            ,           width:86 }
                    ]
                  }
                  ,{ dataIndex: 'UPDATE_DB_USER'        ,           width:86, hidden: true }
                  ,{ dataIndex: 'UPDATE_DB_TIME'        ,           width:86, hidden: true }
                  ,{ dataIndex: 'COMP_CODE'             ,           width:86, hidden: true }
                  
          ],
          listeners: { 
            beforeedit  : function( editor, e, eOpts ) {
                if(e.record.phantom == false) {
                	var record = customMasterGrid.getSelectedRecord();
                	if(record.get('CONFIRM_YN') == 'N') {
                        if(UniUtils.indexOf(e.field, ['PLAN1', 'PLAN2', 'PLAN3', 'PLAN4', 'PLAN5', 'PLAN6', 'PLAN7', 'PLAN8', 'PLAN9', 'PLAN10', 'PLAN11', 'PLAN12'])) {
                            return true;
                        } else {
                            return false;
                        }
                	} else {
                	   if(UniUtils.indexOf(e.field, ['MOD_PLAN1', 'MOD_PLAN2', 'MOD_PLAN3', 'MOD_PLAN4', 'MOD_PLAN5', 'MOD_PLAN6', 'MOD_PLAN7', 'MOD_PLAN8', 'MOD_PLAN9', 'MOD_PLAN10', 'MOD_PLAN11', 'MOD_PLAN12'])) {
                            return true;
                        } else {
                            return false;
                        }
                	}
                } else {
                    if(UniUtils.indexOf(e.field, ['CUSTOM_CODE', 'CUSTOM_NAME', 'PLAN1', 'PLAN2', 'PLAN3', 'PLAN4', 'PLAN5', 'PLAN6', 'PLAN7', 'PLAN8', 'PLAN9', 'PLAN10', 'PLAN11', 'PLAN12'])) {
                        return true;
                    } else {
                        return false;
                    }
                }
            }
        },
		setExcelData: function(records) {
			var grdRecord			= this.getSelectedRecord();
			var newDetailRecords	= new Array();
			var columns				= this.getColumns();
			Ext.each(records, function(record, i){
				var r = {            					
				};
				newDetailRecords[i] = customMasterStore.model.create( r );
				Ext.each(columns, function(column, index) {
					newDetailRecords[i].set(column.initialConfig.dataIndex, record.get(column.initialConfig.dataIndex));

				});
				
	            newDetailRecords[i].set('DIV_CODE'             ,panelSearch.getValue('DIV_CODE'));
	            newDetailRecords[i].set('PLAN_YEAR'            ,panelSearch.getValue('PLAN_YEAR'));
	            newDetailRecords[i].set('PLAN_TYPE1'           ,panelSearch.getValue('ORDER_TYPE'));
	            newDetailRecords[i].set('PLAN_TYPE2'           ,'2');	
	            newDetailRecords[i].set('LEVEL_KIND'           ,'*');
				newDetailRecords[i].set('PLAN_TYPE2_CODE'      , record.get('CUSTOM_CODE'));	            
	            newDetailRecords[i].set('MONEY_UNIT'           ,panelSearch.getValue('MONEY_UNIT'));
	            newDetailRecords[i].set('ENT_MONEY_UNIT'       ,panelSearch.getValue('MONEY_UNIT_DIV'));	
	            newDetailRecords[i].set('CONFIRM_YN'           , 'N');
	            newDetailRecords[i].set('CUSTOM_CODE'          , record.get('CUSTOM_CODE'));	

			});
			
			customMasterStore.loadData(newDetailRecords, true);
		},          
        setCustomData:function(record){
            var grdRecord = this.getSelectedRecord();
            grdRecord.set('DIV_CODE'             ,panelSearch.getValue('DIV_CODE'));
            grdRecord.set('PLAN_YEAR'            ,panelSearch.getValue('PLAN_YEAR'));
            grdRecord.set('PLAN_TYPE1'           ,panelSearch.getValue('ORDER_TYPE'));
            grdRecord.set('PLAN_TYPE2'           ,'2');
            grdRecord.set('PLAN_TYPE2_CODE'      ,record['CUSTOM_CODE']);
            grdRecord.set('LEVEL_KIND'           ,'*');
            grdRecord.set('MONEY_UNIT'           ,panelSearch.getValue('MONEY_UNIT'));
            grdRecord.set('ENT_MONEY_UNIT'       ,panelSearch.getValue('MONEY_UNIT_DIV'));
            grdRecord.set('CONFIRM_YN'           ,record['CONFIRM_YN']);
            grdRecord.set('CUSTOM_CODE'          ,record['CUSTOM_CODE']);
            grdRecord.set('CUSTOM_NAME'          ,record['CUSTOM_NAME']);
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
    
    var activeGrid = customMasterGrid;
    
    var salePrsnMasterGrid = Unilite.createGrid('sgp100ukrvSalePrsnMasterGrid', { 
        layout : 'fit',        
        store: salePrsnMasterStore,
        flex: 1,
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
		tbar: [{
			itemId: 'excelBtn2',
			text: '엑셀업로드',
			handler: function() {
					openExcelWindow2();
			}
		}],         
        columns:  [{ dataIndex: 'DIV_CODE'              ,           width:86, hidden: true }
                  ,{ dataIndex: 'PLAN_YEAR'             ,           width:86, hidden: true }
                  ,{ dataIndex: 'PLAN_TYPE1'            ,           width:86, hidden: true }
                  ,{ dataIndex: 'PLAN_TYPE2'            ,           width:86, hidden: true }
                  ,{ dataIndex: 'PLAN_TYPE2_CODE'       ,           width:86, hidden: true }
                  ,{ dataIndex: 'LEVEL_KIND'            ,           width:86, hidden: true }
                  ,{ dataIndex: 'MONEY_UNIT'            ,           width:86, hidden: true }
                  ,{ dataIndex: 'ENT_MONEY_UNIT'        ,           width:86, hidden: true }
                  ,{ dataIndex: 'CONFIRM_YN'            ,           width:86, hidden: true }
                  ,{ dataIndex: 'S_CODE'                ,           width:86}
                  ,{ dataIndex: 'S_NAME'                ,           width:86, hidden: true}
                  ,{
                    text: '<t:message code="system.label.sales.totalamount" default="합계"/>',
                    columns:[
                        { dataIndex:    'PLAN_SUM'              ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_SUM'          ,           width:86 }
                       ,{ dataIndex:    'A_D_RATE_SUM'          ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.january" default="1월"/>',
                    columns:[
                        { dataIndex:    'PLAN1'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN1'             ,           width:86 }
                       ,{ dataIndex:    'A_D_RATE1'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.february" default="2월"/>',
                    columns:[
                        { dataIndex:    'PLAN2'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN2'             ,           width:86 }
                       ,{ dataIndex:    'A_D_RATE2'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.march" default="3월"/>',
                    columns:[
                        { dataIndex:    'PLAN3'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN3'             ,           width:86 }
                       ,{ dataIndex:    'A_D_RATE3'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.april" default="4월"/>',
                    columns:[
                        { dataIndex:    'PLAN4'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN4'             ,           width:86 }
                       ,{ dataIndex:    'A_D_RATE4'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.may" default="5월"/>',
                    columns:[
                       { dataIndex: 'PLAN5'                 ,           width:86 }
                      ,{ dataIndex: 'MOD_PLAN5'             ,           width:86 }
                      ,{ dataIndex: 'A_D_RATE5'             ,           width:86 }
                    
                    ]
                  },{
                    text: '<t:message code="system.label.sales.june" default="6월"/>',
                    columns:[
                       { dataIndex: 'PLAN6'                 ,           width:86 }
                      ,{ dataIndex: 'MOD_PLAN6'             ,           width:86 }
                      ,{ dataIndex: 'A_D_RATE6'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.july" default="7월"/>',
                    columns:[
                       { dataIndex: 'PLAN7'                 ,           width:86 }
                      ,{ dataIndex: 'MOD_PLAN7'             ,           width:86 }
                      ,{ dataIndex: 'A_D_RATE7'             ,           width:86 } 
                    ]
                  },{
                    text: '<t:message code="system.label.sales.august" default="8월"/>',
                    columns:[
                       { dataIndex: 'PLAN8'                 ,           width:86 }
                      ,{ dataIndex: 'MOD_PLAN8'             ,           width:86 }
                      ,{ dataIndex: 'A_D_RATE8'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.september" default="9월"/>',
                    columns:[
                       { dataIndex: 'PLAN9'                 ,           width:86 }
                      ,{ dataIndex: 'MOD_PLAN9'             ,           width:86 }
                      ,{ dataIndex: 'A_D_RATE9'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.october" default="10월"/>',
                    columns:[
                       { dataIndex: 'PLAN10'                ,           width:86 }
                      ,{ dataIndex: 'MOD_PLAN10'            ,           width:86 }
                      ,{ dataIndex: 'A_D_RATE10'            ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.november" default="11월"/>',
                    columns:[
                       { dataIndex: 'PLAN11'                ,           width:86 }
                      ,{ dataIndex: 'MOD_PLAN11'            ,           width:86 }
                      ,{ dataIndex: 'A_D_RATE11'            ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.december" default="12월"/>',
                    columns:[
                       { dataIndex: 'PLAN12'                ,           width:86 }
                      ,{ dataIndex: 'MOD_PLAN12'            ,           width:86 }
                      ,{ dataIndex: 'A_D_RATE12'            ,           width:86 }
                    ]
                  }
                  ,{ dataIndex: 'UPDATE_DB_USER'        ,           width:86, hidden: true }
                  ,{ dataIndex: 'UPDATE_DB_TIME'        ,           width:86, hidden: true }
                  ,{ dataIndex: 'COMP_CODE'             ,           width:86, hidden: true }
          ],
          isteners: { 
            beforeedit  : function( editor, e, eOpts ) {
                if(e.record.phantom == false) {
                	var record = customMasterGrid.getSelectedRecord();
                    if(record.get('CONFIRM_YN') == 'N') {
                        if(UniUtils.indexOf(e.field, ['PLAN1', 'PLAN2', 'PLAN3', 'PLAN4', 'PLAN5', 'PLAN6', 'PLAN7', 'PLAN8', 'PLAN9', 'PLAN10', 'PLAN11', 'PLAN12'])) {
                            return true;
                        } else {
                            return false;
                        }
                    } else {
                    	if(UniUtils.indexOf(e.field, ['MOD_PLAN1', 'MOD_PLAN2', 'MOD_PLAN3', 'MOD_PLAN4', 'MOD_PLAN5', 'MOD_PLAN6', 'MOD_PLAN7', 'MOD_PLAN8', 'MOD_PLAN9', 'MOD_PLAN10', 'MOD_PLAN11', 'MOD_PLAN12'])) {
                            return true;
                        } else {
                            return false;
                        }
                    }
                } else {
                    if(UniUtils.indexOf(e.field, ['PLAN1', 'PLAN2', 'PLAN3', 'PLAN4', 'PLAN5', 'PLAN6', 'PLAN7', 'PLAN8', 'PLAN9', 'PLAN10', 'PLAN11', 'PLAN12'])) {
                        return true;
                    } else {
                        return false;
                    }
                }
            }
         },
		setExcelData: function(records) {
			var grdRecord			= this.getSelectedRecord();
			var newDetailRecords	= new Array();
			var columns				= this.getColumns();
			Ext.each(records, function(record, i){
				var r = {            					
				};
				newDetailRecords[i] = salePrsnMasterStore.model.create( r );
				Ext.each(columns, function(column, index) {
					newDetailRecords[i].set(column.initialConfig.dataIndex, record.get(column.initialConfig.dataIndex));

				});
				
	            newDetailRecords[i].set('DIV_CODE'             ,panelSearch.getValue('DIV_CODE'));
	            newDetailRecords[i].set('PLAN_YEAR'            ,panelSearch.getValue('PLAN_YEAR'));
	            newDetailRecords[i].set('PLAN_TYPE1'           ,panelSearch.getValue('ORDER_TYPE'));
	            newDetailRecords[i].set('PLAN_TYPE2'           ,'1');	
	            newDetailRecords[i].set('LEVEL_KIND'           ,'*');
				newDetailRecords[i].set('PLAN_TYPE2_CODE'      , record.get('S_CODE'));	            
	            newDetailRecords[i].set('MONEY_UNIT'           ,panelSearch.getValue('MONEY_UNIT'));
	            newDetailRecords[i].set('ENT_MONEY_UNIT'       ,panelSearch.getValue('MONEY_UNIT_DIV'));	
	            newDetailRecords[i].set('CONFIRM_YN'           , 'N');
	            newDetailRecords[i].set('S_CODE'               , record.get('S_CODE'));	

			});
			
			salePrsnMasterStore.loadData(newDetailRecords, true);
		},           
        setPersonData:function(record){
            var grdRecord = this.getSelectedRecord();
            grdRecord.set('DIV_CODE'             ,panelSearch.getValue('DIV_CODE'));
            grdRecord.set('PLAN_YEAR'            ,panelSearch.getValue('PLAN_YEAR'));
            grdRecord.set('PLAN_TYPE1'           ,panelSearch.getValue('ORDER_TYPE'));
            grdRecord.set('PLAN_TYPE2'           ,'1');
            grdRecord.set('PLAN_TYPE2_CODE'      ,record['S_CODE']);
            grdRecord.set('LEVEL_KIND'           ,'*');
            grdRecord.set('MONEY_UNIT'           ,panelSearch.getValue('MONEY_UNIT'));
            grdRecord.set('ENT_MONEY_UNIT'       ,panelSearch.getValue('MONEY_UNIT_DIV'));
            grdRecord.set('CONFIRM_YN'           ,record['CONFIRM_YN']);
            grdRecord.set('S_CODE'               ,record['S_CODE']);
            grdRecord.set('S_NAME'               ,record['S_NAME']);
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
    
    var itemMasterGrid = Unilite.createGrid('sgp100ukrvItemMasterGrid', { 
        layout : 'fit',        
        store: itemMasterStore,
        flex: 1,
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
		tbar: [{
			itemId: 'excelBtn3',
			text: '엑셀업로드',
			handler: function() {
					openExcelWindow3();
			}
		}],         
        columns:  [ { dataIndex:    'DIV_CODE'                  ,           width:86, hidden: true }
                   ,{ dataIndex:    'PLAN_YEAR'                 ,           width:86, hidden: true }
                   ,{ dataIndex:    'PLAN_TYPE1'                ,           width:86, hidden: true }
                   ,{ dataIndex:    'PLAN_TYPE2'                ,           width:86, hidden: true }
                   ,{ dataIndex:    'PLAN_TYPE2_CODE'           ,           width:86, hidden: true }
                   ,{ dataIndex:    'LEVEL_KIND'                ,           width:86, hidden: true }
                   ,{ dataIndex:    'MONEY_UNIT'                ,           width:86, hidden: true }
                   ,{ dataIndex:    'ENT_MONEY_UNIT'            ,           width:86, hidden: true }
                   ,{ dataIndex:    'CONFIRM_YN'                ,           width:86, hidden: true }
                   ,{ dataIndex:    'SALE_BASIS_P'              ,           width:86, hidden: true }
                   ,{ dataIndex:  'ITEM_CODE'                ,           width:133, locked: true,
                        'editor' : Unilite.popup('DIV_PUMOK_G', {       
                                    textFieldName: 'ITEM_CODE',
                                    DBtextFieldName: 'ITEM_CODE',
//                                    extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
									autoPopup: true,
                                    listeners: {'onSelected': {
                                                        fn: function(records, type) {
                                                                console.log('records : ', records);
                                                                Ext.each(records, function(record,i) {                                                                     
                                                                                    if(i==0) {
                                                                                                itemMasterGrid.setItemCodeData(record,false, itemMasterGrid.uniOpt.currentRecord);
                                                                                            } else {
                                                                                                UniAppManager.app.onNewDataButtonDown();
                                                                                                itemMasterGrid.setItemCodeData(record,false, itemMasterGrid.getSelectedRecord());
                                                                                            }
                                                                }); 
                                                        },
                                                        scope: this
                                                },
                                                'onClear': function(type) {
                                                    itemMasterGrid.setItemCodeData(null,true, itemMasterGrid.uniOpt.currentRecord);
                                                },
                                                applyextparam: function(popup){                         
                                                    popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                                                }
                                        }
                     })      
                      }
                  ,{ dataIndex: 'ITEM_NAME'                ,           width:166, locked: true ,
                        'editor' : Unilite.popup('DIV_PUMOK_G', {
//                                    extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
									autoPopup: true,
                                    listeners: {'onSelected': {
                                                        fn: function(records, type) {
                                                                console.log('records : ', records);
                                                                Ext.each(records, function(record,i) {                                                                     
                                                                                    if(i==0) {
                                                                                                itemMasterGrid.setItemCodeData(record,false, itemMasterGrid.uniOpt.currentRecord);
                                                                                            } else {
                                                                                                UniAppManager.app.onNewDataButtonDown();
                                                                                                itemMasterGrid.setItemCodeData(record,false, itemMasterGrid.getSelectedRecord());
                                                                                            }
                                                                }); 
                                                        },
                                                        scope: this
                                                },
                                                'onClear': function(type) {
                                                    itemMasterGrid.setItemCodeData(null,true, itemMasterGrid.uniOpt.currentRecord);
                                                },
                                                applyextparam: function(popup){                         
                                                    popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                                                }
                                        }
                    })      
                     }
                   ,{ dataIndex:    'S_OTHER1'                  ,           width:105, locked: true }
                   ,{
                    text: '<t:message code="system.label.sales.totalamount" default="합계"/>',
                    columns:[
                        { dataIndex:    'PLAN_SUM_Q'                ,           width:86 }
                       ,{ dataIndex:    'PLAN_SUM_AMT'              ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_SUM_Q'            ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_SUM_AMT'          ,           width:86 } 
                    ]
                  },{
                    text: '<t:message code="system.label.sales.january" default="1월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY1'                 ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT1'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q1'               ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT1'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.february" default="2월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY2'                 ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT2'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q2'               ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT2'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.march" default="3월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY3'                 ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT3'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q3'               ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT3'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.april" default="4월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY4'                 ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT4'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q4'               ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT4'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.may" default="5월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY5'                 ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT5'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q5'               ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT5'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.june" default="6월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY6'                 ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT6'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q6'               ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT6'             ,           width:86 } 
                    ]
                  },{
                    text: '<t:message code="system.label.sales.july" default="7월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY7'                 ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT7'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q7'               ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT7'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.august" default="8월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY8'                 ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT8'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q8'               ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT8'             ,           width:86 }                     
                    ]
                  },{
                    text: '<t:message code="system.label.sales.september" default="9월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY9'                 ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT9'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q9'               ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT9'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.october" default="10월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY10'                ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT10'                ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q10'              ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT10'            ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.november" default="11월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY11'                ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT11'                ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q11'              ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT11'            ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.december" default="12월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY12'                ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT12'                ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q12'              ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT12'            ,           width:86 }
                    ]
                  }
                   ,{ dataIndex:    'UPDATE_DB_USER'            ,           width:86, hidden: true }
                   ,{ dataIndex:    'UPDATE_DB_TIME'            ,           width:86, hidden: true }
                   ,{ dataIndex:    'COMP_CODE'                 ,           width:86, hidden: true }
                   
          ],
          isteners: { 
                beforeedit  : function( editor, e, eOpts ) {
                    if(e.record.phantom == false) {
                        var record = customMasterGrid.getSelectedRecord();
                        if(record.get('CONFIRM_YN') == 'N') {
                            if(UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME', 'PLAN_QTY1', 'PLAN_AMT1', 'PLAN_QTY2', 'PLAN_AMT2', 'PLAN_QTY3', 'PLAN_AMT3', 'PLAN_QTY4', 'PLAN_AMT4', 'PLAN_QTY5', 'PLAN_AMT5'
                                                            , 'PLAN_QTY6', 'PLAN_AMT6', 'PLAN_QTY7', 'PLAN_AMT7', 'PLAN_QTY8', 'PLAN_AMT8', 'PLAN_QTY9', 'PLAN_AMT9', 'PLAN_QTY10', 'PLAN_AMT10', 'PLAN_QTY11', 'PLAN_AMT11', 'PLAN_QTY12', 'PLAN_AMT12'])) {
                                return true;
                            } else {
                                return false;
                            }
                        } else {
                            if(UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME', 'MOD_PLAN_QTY1', 'MOD_PLAN_AMT1', 'MOD_PLAN_QTY2', 'MOD_PLAN_AMT2', 'MOD_PLAN_QTY3', 'MOD_PLAN_AMT3', 'MOD_PLAN_QTY4', 'MOD_PLAN_AMT4', 'MOD_PLAN_QTY5', 'MOD_PLAN_AMT5'
                                                            , 'MOD_PLAN_QTY6', 'MOD_PLAN_AMT6', 'MOD_PLAN_QTY7', 'MOD_PLAN_AMT7', 'MOD_PLAN_QTY8', 'MOD_PLAN_AMT8', 'MOD_PLAN_QTY9', 'MOD_PLAN_AMT9', 'MOD_PLAN_QTY10', 'MOD_PLAN_AMT10', 'MOD_PLAN_QTY11', 'MOD_PLAN_AMT11', 'MOD_PLAN_QTY12', 'MOD_PLAN_AMT12'])) {
                                return true;
                            } else {
                                return false;
                            }
                        }
                    } else {
                        if(UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME', 'PLAN_QTY1', 'PLAN_AMT1', 'PLAN_QTY2', 'PLAN_AMT2', 'PLAN_QTY3', 'PLAN_AMT3', 'PLAN_QTY4', 'PLAN_AMT4', 'PLAN_QTY5', 'PLAN_AMT5'
                                                        , 'PLAN_QTY6', 'PLAN_AMT6', 'PLAN_QTY7', 'PLAN_AMT7', 'PLAN_QTY8', 'PLAN_AMT8', 'PLAN_QTY9', 'PLAN_AMT9', 'PLAN_QTY10', 'PLAN_AMT10', 'PLAN_QTY11', 'PLAN_AMT11', 'PLAN_QTY12', 'PLAN_AMT12'])) {
                            return true;
                        } else {
                            return false;
                        }
                    }
                }
            },
			setExcelData: function(records) {
				var grdRecord			= this.getSelectedRecord();
				var newDetailRecords	= new Array();
				var columns				= this.getColumns();
				Ext.each(records, function(record, i){
					var r = {            					
					};
					newDetailRecords[i] = itemMasterStore.model.create( r );
					Ext.each(columns, function(column, index) {
						newDetailRecords[i].set(column.initialConfig.dataIndex, record.get(column.initialConfig.dataIndex));
	
					});
					
		            newDetailRecords[i].set('DIV_CODE'             ,panelSearch.getValue('DIV_CODE'));
		            newDetailRecords[i].set('PLAN_YEAR'            ,panelSearch.getValue('PLAN_YEAR'));
		            newDetailRecords[i].set('PLAN_TYPE1'           ,panelSearch.getValue('ORDER_TYPE'));
		            newDetailRecords[i].set('PLAN_TYPE2'           ,'3');	
		            newDetailRecords[i].set('LEVEL_KIND'           ,'*');
					newDetailRecords[i].set('PLAN_TYPE2_CODE'      , record.get('ITEM_CODE'));	            
		            newDetailRecords[i].set('MONEY_UNIT'           ,panelSearch.getValue('MONEY_UNIT'));
		            newDetailRecords[i].set('ENT_MONEY_UNIT'       ,panelSearch.getValue('MONEY_UNIT_DIV'));	
		            newDetailRecords[i].set('CONFIRM_YN'           , 'N');
		            newDetailRecords[i].set('ITEM_CODE'            , record.get('ITEM_CODE'));	
	
				});
				
				itemMasterStore.loadData(newDetailRecords, true);
			},             
            setItemCodeData: function(record, dataClear, grdRecord) {   
                var grdRecord = this.uniOpt.currentRecord;
                if(dataClear) {
                    grdRecord.set('ITEM_CODE'          , '');
                    grdRecord.set('ITEM_NAME'          , '');
                    grdRecord.set('PLAN_TYPE2_CODE'      , '');
                    
                } else {
                    grdRecord.set('ITEM_CODE'          , record['ITEM_CODE']);
                    grdRecord.set('ITEM_NAME'          , record['ITEM_NAME']);
                    grdRecord.set('PLAN_TYPE2_CODE'      , record['ITEM_CODE']);
                }
            },
            setItemData:function(record){
                var grdRecord = this.getSelectedRecord();
                grdRecord.set('DIV_CODE'             ,panelSearch.getValue('DIV_CODE'));
                grdRecord.set('PLAN_YEAR'            ,panelSearch.getValue('PLAN_YEAR'));
                grdRecord.set('PLAN_TYPE1'           ,panelSearch.getValue('ORDER_TYPE'));
                grdRecord.set('PLAN_TYPE2'           ,'3');
                grdRecord.set('PLAN_TYPE2_CODE'      ,record['ITEM_CODE']);
                grdRecord.set('LEVEL_KIND'           ,'*');
                grdRecord.set('MONEY_UNIT'           ,panelSearch.getValue('MONEY_UNIT'));
                grdRecord.set('ENT_MONEY_UNIT'       ,panelSearch.getValue('MONEY_UNIT_DIV'));
                grdRecord.set('CONFIRM_YN'           ,record['CONFIRM_YN']);
                grdRecord.set('SALE_BASIS_P'         ,record['SALE_BASIS_P']);
                grdRecord.set('ITEM_CODE'            ,record['ITEM_CODE']);
                grdRecord.set('ITEM_NAME'            ,record['ITEM_NAME']);
                grdRecord.set('S_OTHER1'             ,record['S_OTHER1']);
                grdRecord.set('PLAN_SUM_Q '          ,record['PLAN_SUM_Q ']);
                grdRecord.set('PLAN_SUM_AMT '        ,record['PLAN_SUM_AMT ']);
                grdRecord.set('MOD_PLAN_SUM_Q '      ,record['MOD_PLAN_SUM_Q ']);
                grdRecord.set('MOD_PLAN_SUM_AM'      ,record['MOD_PLAN_SUM_AM']);
                grdRecord.set('PLAN_QTY1'            ,record['PLAN_QTY1']);
                grdRecord.set('PLAN_AMT1'            ,record['PLAN_AMT1']);
                grdRecord.set('MOD_PLAN_Q1'          ,record['MOD_PLAN_Q1']);
                grdRecord.set('MOD_PLAN_AMT1'        ,record['MOD_PLAN_AMT1']);
                grdRecord.set('PLAN_QTY2'            ,record['PLAN_QTY2']);
                grdRecord.set('PLAN_AMT2'            ,record['PLAN_AMT2']);
                grdRecord.set('MOD_PLAN_Q2'          ,record['MOD_PLAN_Q2']);
                grdRecord.set('MOD_PLAN_AMT2'        ,record['MOD_PLAN_AMT2']);
                grdRecord.set('PLAN_QTY3'            ,record['PLAN_QTY3']);
                grdRecord.set('PLAN_AMT3'            ,record['PLAN_AMT3']);
                grdRecord.set('MOD_PLAN_Q3'          ,record['MOD_PLAN_Q3']);
                grdRecord.set('MOD_PLAN_AMT3'        ,record['MOD_PLAN_AMT3']);
                grdRecord.set('PLAN_QTY4'            ,record['PLAN_QTY4']);
                grdRecord.set('PLAN_AMT4'            ,record['PLAN_AMT4']);
                grdRecord.set('MOD_PLAN_Q4'          ,record['MOD_PLAN_Q4']);
                grdRecord.set('MOD_PLAN_AMT4'        ,record['MOD_PLAN_AMT4']);
                grdRecord.set('PLAN_QTY5'            ,record['PLAN_QTY5']);
                grdRecord.set('PLAN_AMT5'            ,record['PLAN_AMT5']);
                grdRecord.set('MOD_PLAN_Q5'          ,record['MOD_PLAN_Q5']);
                grdRecord.set('MOD_PLAN_AMT5'        ,record['MOD_PLAN_AMT5']);
                grdRecord.set('PLAN_QTY6'            ,record['PLAN_QTY6']);
                grdRecord.set('PLAN_AMT6'            ,record['PLAN_AMT6']);
                grdRecord.set('MOD_PLAN_Q6'          ,record['MOD_PLAN_Q6']);
                grdRecord.set('MOD_PLAN_AMT6'        ,record['MOD_PLAN_AMT6']);
                grdRecord.set('PLAN_QTY7'            ,record['PLAN_QTY7']);
                grdRecord.set('PLAN_AMT7'            ,record['PLAN_AMT7']);
                grdRecord.set('MOD_PLAN_Q7'          ,record['MOD_PLAN_Q7']);
                grdRecord.set('MOD_PLAN_AMT7'        ,record['MOD_PLAN_AMT7']);
                grdRecord.set('PLAN_QTY8'            ,record['PLAN_QTY8']);
                grdRecord.set('PLAN_AMT8'            ,record['PLAN_AMT8']);
                grdRecord.set('MOD_PLAN_Q8'          ,record['MOD_PLAN_Q8']);
                grdRecord.set('MOD_PLAN_AMT8'        ,record['MOD_PLAN_AMT8']);
                grdRecord.set('PLAN_QTY9'            ,record['PLAN_QTY9']);
                grdRecord.set('PLAN_AMT9'            ,record['PLAN_AMT9']);
                grdRecord.set('MOD_PLAN_Q9'          ,record['MOD_PLAN_Q9']);
                grdRecord.set('MOD_PLAN_AMT9'        ,record['MOD_PLAN_AMT9']);
                grdRecord.set('PLAN_QTY10'           ,record['PLAN_QTY10']);
                grdRecord.set('PLAN_AMT10'           ,record['PLAN_AMT10']);
                grdRecord.set('MOD_PLAN_Q10'         ,record['MOD_PLAN_Q10']);
                grdRecord.set('MOD_PLAN_AMT10'       ,record['MOD_PLAN_AMT10']);
                grdRecord.set('PLAN_QTY11'           ,record['PLAN_QTY11']);
                grdRecord.set('PLAN_AMT11'           ,record['PLAN_AMT11']);
                grdRecord.set('MOD_PLAN_Q11'         ,record['MOD_PLAN_Q11']);
                grdRecord.set('MOD_PLAN_AMT11'       ,record['MOD_PLAN_AMT11']);
                grdRecord.set('PLAN_QTY12'           ,record['PLAN_QTY12']);
                grdRecord.set('PLAN_AMT12'           ,record['PLAN_AMT12']);
                grdRecord.set('MOD_PLAN_Q12'         ,record['MOD_PLAN_Q12']);
                grdRecord.set('MOD_PLAN_AMT12'       ,record['MOD_PLAN_AMT12']);
                grdRecord.set('UPDATE_DB_USER'       ,record['UPDATE_DB_USER']);
                grdRecord.set('UPDATE_DB_TIME'       ,record['UPDATE_DB_TIME']);
                grdRecord.set('COMP_CODE'            ,record['COMP_CODE']);
            }   
    });
    
    var itemSortMasterGrid = Unilite.createGrid('sgp100ukrvItemSortMasterGrid', { 
        layout : 'fit',        
        store: itemSortMasterStore,
        flex: 1,
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
		tbar: [{
			itemId: 'excelBtn4',
			text: '엑셀업로드',
			handler: function() {
					openExcelWindow4();
			}
		}],         
        columns:  [
            { dataIndex: 'DIV_CODE'                        ,           width:86, hidden: true},
            { dataIndex: 'PLAN_YEAR'                       ,           width:86, hidden: true},
            { dataIndex: 'PLAN_TYPE1'                      ,           width:86, hidden: true},
            { dataIndex: 'PLAN_TYPE2'                      ,           width:86, hidden: true},
            { dataIndex: 'PLAN_TYPE2_CODE'                 ,           width:86, hidden: true},
            { dataIndex: 'LEVEL_KIND'                      ,           width:86, hidden: true},
            { dataIndex: 'MONEY_UNIT'                      ,           width:86, hidden: true},
            { dataIndex: 'ENT_MONEY_UNIT'                  ,           width:86, hidden: true},
            { dataIndex: 'CONFIRM_YN'                      ,           width:86, hidden: true},
            { dataIndex: 'S_CODE1'                         ,           width:86},
            { dataIndex: 'S_CODE2'                         ,           width:86},
            { dataIndex: 'S_CODE3'                         ,           width:86},
            {
                text: '<t:message code="system.label.sales.totalamount" default="합계"/>',
                columns:[
                    { dataIndex: 'PLAN_SUM'                        ,           width:86},
                    { dataIndex: 'MOD_PLAN_SUM'                    ,           width:86},
                    { dataIndex: 'A_D_RATE_SUM'                    ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.january" default="1월"/>',
                columns:[
                    { dataIndex: 'PLAN1'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN1'                        ,           width:86},
                    { dataIndex: 'A_D_RATE1'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.february" default="2월"/>',
                columns:[
                    { dataIndex: 'PLAN2'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN2'                        ,           width:86},
                    { dataIndex: 'A_D_RATE2'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.march" default="3월"/>',
                columns:[
                    { dataIndex: 'PLAN3'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN3'                        ,           width:86},
                    { dataIndex: 'A_D_RATE3'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.april" default="4월"/>',
                columns:[
                    { dataIndex: 'PLAN4'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN4'                        ,           width:86},
                    { dataIndex: 'A_D_RATE4'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.may" default="5월"/>',
                columns:[
                    { dataIndex: 'PLAN5'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN5'                        ,           width:86},
                    { dataIndex: 'A_D_RATE5'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.june" default="6월"/>',
                columns:[
                    { dataIndex: 'PLAN6'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN6'                        ,           width:86},
                    { dataIndex: 'A_D_RATE6'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.july" default="7월"/>',
                columns:[
                    { dataIndex: 'PLAN7'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN7'                        ,           width:86},
                    { dataIndex: 'A_D_RATE7'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.august" default="8월"/>',
                columns:[
                    { dataIndex: 'PLAN8'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN8'                        ,           width:86},
                    { dataIndex: 'A_D_RATE8'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.september" default="9월"/>',
                columns:[
                    { dataIndex: 'PLAN9'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN9'                        ,           width:86},
                    { dataIndex: 'A_D_RATE9'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.october" default="10월"/>',
                columns:[
                    { dataIndex: 'PLAN10'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN10'                        ,           width:86},
                    { dataIndex: 'A_D_RATE10'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.november" default="11월"/>',
                columns:[
                    { dataIndex: 'PLAN11'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN11'                        ,           width:86},
                    { dataIndex: 'A_D_RATE11'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.december" default="12월"/>',
                columns:[
                    { dataIndex: 'PLAN12'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN12'                        ,           width:86},
                    { dataIndex: 'A_D_RATE12'                        ,           width:86}
                ]
            },
            { dataIndex: 'UPDATE_DB_USER'                  ,           width:86, hidden: true},
            { dataIndex: 'UPDATE_DB_TIME'                  ,           width:86, hidden: true},
            { dataIndex: 'COMP_CODE'                       ,           width:86, hidden: true}
        ],
          listeners: { 
            beforeedit  : function( editor, e, eOpts ) {
                if(e.record.phantom == false) {
                    var record = itemSortMasterGrid.getSelectedRecord();
                    if(record.get('CONFIRM_YN') == 'N') {
                        if(UniUtils.indexOf(e.field, ['PLAN1', 'PLAN2', 'PLAN3', 'PLAN4', 'PLAN5', 'PLAN6', 'PLAN7', 'PLAN8', 'PLAN9', 'PLAN10', 'PLAN11', 'PLAN12'])) {
                            return true;
                        } else {
                            return false;
                        }
                    } else {
                        if(UniUtils.indexOf(e.field, ['MOD_PLAN1', 'MOD_PLAN2', 'MOD_PLAN3', 'MOD_PLAN4', 'MOD_PLAN5', 'MOD_PLAN6', 'MOD_PLAN7', 'MOD_PLAN8', 'MOD_PLAN9', 'MOD_PLAN10', 'MOD_PLAN11', 'MOD_PLAN12'])) {
                            return true;
                        } else {
                            return false;
                        }
                    }
                } else {
                    if(UniUtils.indexOf(e.field, ['S_CODE1', 'S_CODE2', 'S_CODE3', 'PLAN1', 'PLAN2', 'PLAN3', 'PLAN4', 'PLAN5', 'PLAN6', 'PLAN7', 'PLAN8', 'PLAN9', 'PLAN10', 'PLAN11', 'PLAN12'])) {
                        return true;
                    } else {
                        return false;
                    }
                }
            }
         },
 		setExcelData: function(records) {
			var grdRecord			= this.getSelectedRecord();
			var newDetailRecords	= new Array();
			var columns				= this.getColumns();
			Ext.each(records, function(record, i){
				var r = {            					
				};
				newDetailRecords[i] = itemSortMasterStore.model.create( r );
				Ext.each(columns, function(column, index) {
					newDetailRecords[i].set(column.initialConfig.dataIndex, record.get(column.initialConfig.dataIndex));

				});
				
	            newDetailRecords[i].set('DIV_CODE'             ,panelSearch.getValue('DIV_CODE'));
	            newDetailRecords[i].set('PLAN_YEAR'            ,panelSearch.getValue('PLAN_YEAR'));
	            newDetailRecords[i].set('PLAN_TYPE1'           ,panelSearch.getValue('ORDER_TYPE'));
	            newDetailRecords[i].set('PLAN_TYPE2'           ,'4');				
				
	            if(Ext.getCmp('ITEM_LEVEL_ID').getChecked()[0].inputValue == '1') {
		            newDetailRecords[i].set('S_CODE1', record.get('ITEM_LEVEL1'));
		            newDetailRecords[i].set('PLAN_TYPE2_CODE', record.get('ITEM_LEVEL1'));
		            
	            } else if(Ext.getCmp('ITEM_LEVEL_ID').getChecked()[0].inputValue == '2') {
		            newDetailRecords[i].set('S_CODE2', record.get('ITEM_LEVEL2'));
		            newDetailRecords[i].set('PLAN_TYPE2_CODE', record.get('ITEM_LEVEL2'));
	            } else {
		            newDetailRecords[i].set('S_CODE3', record.get('ITEM_LEVEL3'));
		            newDetailRecords[i].set('PLAN_TYPE2_CODE', record.get('ITEM_LEVEL3'));
	            }
	            
	            
	            
	            newDetailRecords[i].set('LEVEL_KIND'           ,itemSortSubForm.getValue('ITEM_LEVEL_ID').ITEM_LEVEL);
	            newDetailRecords[i].set('MONEY_UNIT'           ,panelSearch.getValue('MONEY_UNIT'));
	            newDetailRecords[i].set('ENT_MONEY_UNIT'       ,panelSearch.getValue('MONEY_UNIT_DIV'));	
	            newDetailRecords[i].set('CONFIRM_YN'           , 'N');

			});
			
			itemSortMasterStore.loadData(newDetailRecords, true);
		},          
        setItemSortData:function(record){
            var grdRecord = this.getSelectedRecord();
            grdRecord.set('DIV_CODE'             ,panelSearch.getValue('DIV_CODE'));
            grdRecord.set('PLAN_YEAR'            ,panelSearch.getValue('PLAN_YEAR'));
            grdRecord.set('PLAN_TYPE1'           ,panelSearch.getValue('ORDER_TYPE'));
            grdRecord.set('PLAN_TYPE2'           ,'4');
            grdRecord.set('PLAN_TYPE2_CODE'      ,record['S_CODE']);
            grdRecord.set('LEVEL_KIND'           ,itemSortSubForm.getValue('ITEM_LEVEL_ID').ITEM_LEVEL);
            grdRecord.set('MONEY_UNIT'           ,panelSearch.getValue('MONEY_UNIT'));
            grdRecord.set('ENT_MONEY_UNIT'       ,panelSearch.getValue('MONEY_UNIT_DIV'));
            grdRecord.set('CONFIRM_YN'           ,record['CONFIRM_YN']);
            
            if(Ext.getCmp('ITEM_LEVEL_ID').getChecked()[0].inputValue == '1') {
	            grdRecord.set('S_CODE1'               ,record['S_CODE']);
            } else if(Ext.getCmp('ITEM_LEVEL_ID').getChecked()[0].inputValue == '2') {
	            grdRecord.set('S_CODE2'               ,record['S_CODE']);
            } else {
	            grdRecord.set('S_CODE3'               ,record['S_CODE']);
            }  
            
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
    
    var spokesItemMasterGrid = Unilite.createGrid('sgp100ukrvSpokesItemMasterGrid', { 
        layout : 'fit',                             
        store: spokesItemMasterStore,
        flex: 1,
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
		tbar: [{
			itemId: 'excelBtn5',
			text: '엑셀업로드',
			handler: function() {
					openExcelWindow5();
			}
		}],         
        columns:  [ { dataIndex:    'DIV_CODE'                  ,           width:86, hidden: true }
                   ,{ dataIndex:    'PLAN_YEAR'                 ,           width:86, hidden: true }
                   ,{ dataIndex:    'PLAN_TYPE1'                ,           width:86, hidden: true }
                   ,{ dataIndex:    'PLAN_TYPE2'                ,           width:86, hidden: true }
                   ,{ dataIndex:    'PLAN_TYPE2_CODE'           ,           width:86, hidden: true }
                   ,{ dataIndex:    'LEVEL_KIND'                ,           width:86, hidden: true }
                   ,{ dataIndex:    'MONEY_UNIT'                ,           width:86, hidden: true }
                   ,{ dataIndex:    'ENT_MONEY_UNIT'            ,           width:86, hidden: true }
                   ,{ dataIndex:    'CONFIRM_YN'                ,           width:86, hidden: true }
                   ,{ dataIndex:    'SALE_BASIS_P'              ,           width:86, hidden: true }
                   ,{ dataIndex:  'ITEM_CODE'                ,           width:100,
                        'editor' : Unilite.popup('DIV_PUMOK_GROUP_G', {       
                                    textFieldName: 'ITEM_CODE',
                                    DBtextFieldName: 'ITEM_CODE',
//                                    extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
									autoPopup: true,
                                    listeners: {'onSelected': {
                                                        fn: function(records, type) {
                                                                console.log('records : ', records);
                                                                Ext.each(records, function(record,i) {                                                                     
                                                                                    if(i==0) {
                                                                                                itemMasterGrid.setItemCodeData2(record,false, itemMasterGrid.uniOpt.currentRecord);
                                                                                            } else {
                                                                                                UniAppManager.app.onNewDataButtonDown();
                                                                                                itemMasterGrid.setItemCodeData2(record,false, itemMasterGrid.getSelectedRecord());
                                                                                            }
                                                                }); 
                                                        },
                                                        scope: this
                                                },
                                                'onClear': function(type) {
                                                    itemMasterGrid.setItemCodeData2(null,true, itemMasterGrid.uniOpt.currentRecord);
                                                },
                                                applyextparam: function(popup){                         
                                                    popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                                                }
                                        }
                     })      
                      }
                  ,{ dataIndex: 'ITEM_NAME'                ,           width:100 ,
                        'editor' : Unilite.popup('DIV_PUMOK_GROUP_G', {
//                                    extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
									autoPopup: true,
                                    listeners: {'onSelected': {
                                                        fn: function(records, type) {
                                                                console.log('records : ', records);
                                                                Ext.each(records, function(record,i) {                                                                     
                                                                                    if(i==0) {
                                                                                                itemMasterGrid.setItemCodeData2(record,false, itemMasterGrid.uniOpt.currentRecord);
                                                                                            } else {
                                                                                                UniAppManager.app.onNewDataButtonDown();
                                                                                                itemMasterGrid.setItemCodeData2(record,false, itemMasterGrid.getSelectedRecord());
                                                                                            }
                                                                }); 
                                                        },
                                                        scope: this
                                                },
                                                'onClear': function(type) {
                                                    itemMasterGrid.setItemCodeData2(null,true, itemMasterGrid.uniOpt.currentRecord);
                                                },
                                                applyextparam: function(popup){                         
                                                    popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                                                }
                                        }
                    })      
                     }
                   ,{ dataIndex:    'S_OTHER1'                  ,           width:105 }
                   ,{
                    text: '<t:message code="system.label.sales.totalamount" default="합계"/>',
                    columns:[
                        { dataIndex:    'PLAN_SUM_Q'                ,           width:86 }
                       ,{ dataIndex:    'PLAN_SUM_AMT'              ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_SUM_Q'            ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_SUM_AMT'          ,           width:86 } 
                    ]
                  },{
                    text: '<t:message code="system.label.sales.january" default="1월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY1'                 ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT1'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q1'               ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT1'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.february" default="2월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY2'                 ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT2'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q2'               ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT2'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.march" default="3월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY3'                 ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT3'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q3'               ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT3'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.april" default="4월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY4'                 ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT4'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q4'               ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT4'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.may" default="5월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY5'                 ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT5'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q5'               ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT5'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.june" default="6월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY6'                 ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT6'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q6'               ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT6'             ,           width:86 } 
                    ]
                  },{
                    text: '<t:message code="system.label.sales.july" default="7월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY7'                 ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT7'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q7'               ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT7'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.august" default="8월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY8'                 ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT8'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q8'               ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT8'             ,           width:86 }                     
                    ]
                  },{
                    text: '<t:message code="system.label.sales.september" default="9월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY9'                 ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT9'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q9'               ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT9'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.october" default="10월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY10'                ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT10'                ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q10'              ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT10'            ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.november" default="11월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY11'                ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT11'                ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q11'              ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT11'            ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.december" default="12월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY12'                ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT12'                ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q12'              ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT12'            ,           width:86 }
                    ]
                  }
                   ,{ dataIndex:    'UPDATE_DB_USER'            ,           width:86, hidden: true }
                   ,{ dataIndex:    'UPDATE_DB_TIME'            ,           width:86, hidden: true }
                   ,{ dataIndex:    'COMP_CODE'                 ,           width:86, hidden: true }
                   
          ],
          isteners: { 
                beforeedit  : function( editor, e, eOpts ) {
                    if(e.record.phantom == false) {
                        var record = spokesItemMasterGrid.getSelectedRecord();
                        if(record.get('CONFIRM_YN') == 'N') {
                            if(UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME', 'PLAN_QTY1', 'PLAN_AMT1', 'PLAN_QTY2', 'PLAN_AMT2', 'PLAN_QTY3', 'PLAN_AMT3', 'PLAN_QTY4', 'PLAN_AMT4', 'PLAN_QTY5', 'PLAN_AMT5'
                                                            , 'PLAN_QTY6', 'PLAN_AMT6', 'PLAN_QTY7', 'PLAN_AMT7', 'PLAN_QTY8', 'PLAN_AMT8', 'PLAN_QTY9', 'PLAN_AMT9', 'PLAN_QTY10', 'PLAN_AMT10', 'PLAN_QTY11', 'PLAN_AMT11', 'PLAN_QTY12', 'PLAN_AMT12'])) {
                                return true;
                            } else {
                                return false;
                            }
                        } else {
                            if(UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME', 'MOD_PLAN_QTY1', 'MOD_PLAN_AMT1', 'MOD_PLAN_QTY2', 'MOD_PLAN_AMT2', 'MOD_PLAN_QTY3', 'MOD_PLAN_AMT3', 'MOD_PLAN_QTY4', 'MOD_PLAN_AMT4', 'MOD_PLAN_QTY5', 'MOD_PLAN_AMT5'
                                                            , 'MOD_PLAN_QTY6', 'MOD_PLAN_AMT6', 'MOD_PLAN_QTY7', 'MOD_PLAN_AMT7', 'MOD_PLAN_QTY8', 'MOD_PLAN_AMT8', 'MOD_PLAN_QTY9', 'MOD_PLAN_AMT9', 'MOD_PLAN_QTY10', 'MOD_PLAN_AMT10', 'MOD_PLAN_QTY11', 'MOD_PLAN_AMT11', 'MOD_PLAN_QTY12', 'MOD_PLAN_AMT12'])) {
                                return true;
                            } else {
                                return false;
                            }
                        }
                    } else {
                        if(UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME', 'PLAN_QTY1', 'PLAN_AMT1', 'PLAN_QTY2', 'PLAN_AMT2', 'PLAN_QTY3', 'PLAN_AMT3', 'PLAN_QTY4', 'PLAN_AMT4', 'PLAN_QTY5', 'PLAN_AMT5'
                                                        , 'PLAN_QTY6', 'PLAN_AMT6', 'PLAN_QTY7', 'PLAN_AMT7', 'PLAN_QTY8', 'PLAN_AMT8', 'PLAN_QTY9', 'PLAN_AMT9', 'PLAN_QTY10', 'PLAN_AMT10', 'PLAN_QTY11', 'PLAN_AMT11', 'PLAN_QTY12', 'PLAN_AMT12'])) {
                            return true;
                        } else {
                            return false;
                        }
                    }
                }
            },
			setExcelData: function(records) {
				var grdRecord			= this.getSelectedRecord();
				var newDetailRecords	= new Array();
				var columns				= this.getColumns();
				Ext.each(records, function(record, i){
					var r = {            					
					};
					newDetailRecords[i] = spokesItemMasterStore.model.create( r );
					Ext.each(columns, function(column, index) {
						newDetailRecords[i].set(column.initialConfig.dataIndex, record.get(column.initialConfig.dataIndex));
	
					});
					
		            newDetailRecords[i].set('DIV_CODE'             ,panelSearch.getValue('DIV_CODE'));
		            newDetailRecords[i].set('PLAN_YEAR'            ,panelSearch.getValue('PLAN_YEAR'));
		            newDetailRecords[i].set('PLAN_TYPE1'           ,panelSearch.getValue('ORDER_TYPE'));
		            newDetailRecords[i].set('PLAN_TYPE2'           ,'5');	
		            newDetailRecords[i].set('LEVEL_KIND'           ,'*');
					newDetailRecords[i].set('PLAN_TYPE2_CODE'      , record.get('ITEM_CODE'));	            
		            newDetailRecords[i].set('MONEY_UNIT'           ,panelSearch.getValue('MONEY_UNIT'));
		            newDetailRecords[i].set('ENT_MONEY_UNIT'       ,panelSearch.getValue('MONEY_UNIT_DIV'));	
		            newDetailRecords[i].set('CONFIRM_YN'           , 'N');
		            newDetailRecords[i].set('ITEM_CODE'            , record.get('ITEM_CODE'));	
		            newDetailRecords[i].set('ITEM_NAME'            , record.get('ITEM_NAME'));
	
				});
				
				spokesItemMasterStore.loadData(newDetailRecords, true);
			},                
            setItemCodeData2: function(record, dataClear, grdRecord) {   
                var grdRecord = this.uniOpt.currentRecord;
                if(dataClear) {
                    grdRecord.set('ITEM_CODE'          , '');
                    grdRecord.set('ITEM_NAME'          , '');
                    grdRecord.set('PLAN_TYPE2_CODE'      , '');
                    
                } else {
                    grdRecord.set('ITEM_CODE'          , record['ITEM_CODE']);
                    grdRecord.set('ITEM_NAME'          , record['ITEM_NAME']);
                    grdRecord.set('PLAN_TYPE2_CODE'      , record['ITEM_CODE']);
                }
            },
            setSpokesItemData:function(record){
                var grdRecord = this.getSelectedRecord();
                grdRecord.set('DIV_CODE'             ,panelSearch.getValue('DIV_CODE'));
                grdRecord.set('PLAN_YEAR'            ,panelSearch.getValue('PLAN_YEAR'));
                grdRecord.set('PLAN_TYPE1'           ,panelSearch.getValue('ORDER_TYPE'));
                grdRecord.set('PLAN_TYPE2'           ,'5');
                grdRecord.set('PLAN_TYPE2_CODE'      ,record['ITEM_CODE']);
                grdRecord.set('LEVEL_KIND'           ,'*');
                grdRecord.set('MONEY_UNIT'           ,panelSearch.getValue('MONEY_UNIT'));
                grdRecord.set('ENT_MONEY_UNIT'       ,panelSearch.getValue('MONEY_UNIT_DIV'));
                grdRecord.set('CONFIRM_YN'           ,record['CONFIRM_YN']);
                grdRecord.set('SALE_BASIS_P'         ,record['SALE_BASIS_P']);
                grdRecord.set('ITEM_CODE'            ,record['ITEM_CODE']);
                grdRecord.set('ITEM_NAME'            ,record['ITEM_NAME']);
                grdRecord.set('S_OTHER1'             ,record['S_OTHER1']);
                grdRecord.set('PLAN_SUM_Q '          ,record['PLAN_SUM_Q ']);
                grdRecord.set('PLAN_SUM_AMT '        ,record['PLAN_SUM_AMT ']);
                grdRecord.set('MOD_PLAN_SUM_Q '      ,record['MOD_PLAN_SUM_Q ']);
                grdRecord.set('MOD_PLAN_SUM_AM'      ,record['MOD_PLAN_SUM_AM']);
                grdRecord.set('PLAN_QTY1'            ,record['PLAN_QTY1']);
                grdRecord.set('PLAN_AMT1'            ,record['PLAN_AMT1']);
                grdRecord.set('MOD_PLAN_Q1'          ,record['MOD_PLAN_Q1']);
                grdRecord.set('MOD_PLAN_AMT1'        ,record['MOD_PLAN_AMT1']);
                grdRecord.set('PLAN_QTY2'            ,record['PLAN_QTY2']);
                grdRecord.set('PLAN_AMT2'            ,record['PLAN_AMT2']);
                grdRecord.set('MOD_PLAN_Q2'          ,record['MOD_PLAN_Q2']);
                grdRecord.set('MOD_PLAN_AMT2'        ,record['MOD_PLAN_AMT2']);
                grdRecord.set('PLAN_QTY3'            ,record['PLAN_QTY3']);
                grdRecord.set('PLAN_AMT3'            ,record['PLAN_AMT3']);
                grdRecord.set('MOD_PLAN_Q3'          ,record['MOD_PLAN_Q3']);
                grdRecord.set('MOD_PLAN_AMT3'        ,record['MOD_PLAN_AMT3']);
                grdRecord.set('PLAN_QTY4'            ,record['PLAN_QTY4']);
                grdRecord.set('PLAN_AMT4'            ,record['PLAN_AMT4']);
                grdRecord.set('MOD_PLAN_Q4'          ,record['MOD_PLAN_Q4']);
                grdRecord.set('MOD_PLAN_AMT4'        ,record['MOD_PLAN_AMT4']);
                grdRecord.set('PLAN_QTY5'            ,record['PLAN_QTY5']);
                grdRecord.set('PLAN_AMT5'            ,record['PLAN_AMT5']);
                grdRecord.set('MOD_PLAN_Q5'          ,record['MOD_PLAN_Q5']);
                grdRecord.set('MOD_PLAN_AMT5'        ,record['MOD_PLAN_AMT5']);
                grdRecord.set('PLAN_QTY6'            ,record['PLAN_QTY6']);
                grdRecord.set('PLAN_AMT6'            ,record['PLAN_AMT6']);
                grdRecord.set('MOD_PLAN_Q6'          ,record['MOD_PLAN_Q6']);
                grdRecord.set('MOD_PLAN_AMT6'        ,record['MOD_PLAN_AMT6']);
                grdRecord.set('PLAN_QTY7'            ,record['PLAN_QTY7']);
                grdRecord.set('PLAN_AMT7'            ,record['PLAN_AMT7']);
                grdRecord.set('MOD_PLAN_Q7'          ,record['MOD_PLAN_Q7']);
                grdRecord.set('MOD_PLAN_AMT7'        ,record['MOD_PLAN_AMT7']);
                grdRecord.set('PLAN_QTY8'            ,record['PLAN_QTY8']);
                grdRecord.set('PLAN_AMT8'            ,record['PLAN_AMT8']);
                grdRecord.set('MOD_PLAN_Q8'          ,record['MOD_PLAN_Q8']);
                grdRecord.set('MOD_PLAN_AMT8'        ,record['MOD_PLAN_AMT8']);
                grdRecord.set('PLAN_QTY9'            ,record['PLAN_QTY9']);
                grdRecord.set('PLAN_AMT9'            ,record['PLAN_AMT9']);
                grdRecord.set('MOD_PLAN_Q9'          ,record['MOD_PLAN_Q9']);
                grdRecord.set('MOD_PLAN_AMT9'        ,record['MOD_PLAN_AMT9']);
                grdRecord.set('PLAN_QTY10'           ,record['PLAN_QTY10']);
                grdRecord.set('PLAN_AMT10'           ,record['PLAN_AMT10']);
                grdRecord.set('MOD_PLAN_Q10'         ,record['MOD_PLAN_Q10']);
                grdRecord.set('MOD_PLAN_AMT10'       ,record['MOD_PLAN_AMT10']);
                grdRecord.set('PLAN_QTY11'           ,record['PLAN_QTY11']);
                grdRecord.set('PLAN_AMT11'           ,record['PLAN_AMT11']);
                grdRecord.set('MOD_PLAN_Q11'         ,record['MOD_PLAN_Q11']);
                grdRecord.set('MOD_PLAN_AMT11'       ,record['MOD_PLAN_AMT11']);
                grdRecord.set('PLAN_QTY12'           ,record['PLAN_QTY12']);
                grdRecord.set('PLAN_AMT12'           ,record['PLAN_AMT12']);
                grdRecord.set('MOD_PLAN_Q12'         ,record['MOD_PLAN_Q12']);
                grdRecord.set('MOD_PLAN_AMT12'       ,record['MOD_PLAN_AMT12']);
                grdRecord.set('UPDATE_DB_USER'       ,record['UPDATE_DB_USER']);
                grdRecord.set('UPDATE_DB_TIME'       ,record['UPDATE_DB_TIME']);
                grdRecord.set('COMP_CODE'            ,record['COMP_CODE']);
            }   
    });
    
    var customerItemMasterGrid = Unilite.createGrid('sgp100ukrvCustomerItemMasterGrid', { 
        layout : 'fit',                             
        store: customerItemMasterStore,
        flex: 1,
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
		tbar: [{
			itemId: 'excelBtn6',
			text: '엑셀업로드',
			handler: function() {
					openExcelWindow6();
			}
		}],         
        columns:  [ { dataIndex:    'DIV_CODE'                  ,           width:86, hidden: true }
                   ,{ dataIndex:    'PLAN_YEAR'                 ,           width:86, hidden: true }
                   ,{ dataIndex:    'PLAN_TYPE1'                ,           width:86, hidden: true }
                   ,{ dataIndex:    'PLAN_TYPE2'                ,           width:86, hidden: true }
                   ,{ dataIndex:    'PLAN_TYPE2_CODE'           ,           width:86, hidden: true }
                   ,{ dataIndex:    'PLAN_TYPE2_CODE2'          ,           width:86, hidden: true }
                   ,{ dataIndex:    'LEVEL_KIND'                ,           width:86, hidden: true }
                   ,{ dataIndex:    'MONEY_UNIT'                ,           width:86, hidden: true }
                   ,{ dataIndex:    'ENT_MONEY_UNIT'            ,           width:86, hidden: true }
                   ,{ dataIndex:    'CONFIRM_YN'                ,           width:86, hidden: true }
                   ,{ dataIndex:    'SALE_BASIS_P'              ,           width:86, hidden: true }
				   ,{ dataIndex: 'CUSTOM_CODE'			, width: 100	,
						editor: Unilite.popup('AGENT_CUST_G',{
							autoPopup:true,
							listeners		: { 
								'onSelected': {
									fn: function(records, type  ){
										var grdRecord = customerItemMasterGrid.uniOpt.currentRecord;
										grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
										grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
										grdRecord.set('PLAN_TYPE2_CODE2', records[0]['CUSTOM_CODE']);
									},
									scope: this
								},
								'onClear' : function(type)	{
									var grdRecord = customerItemMasterGrid.uniOpt.currentRecord;
									grdRecord.set('CUSTOM_CODE','');
									grdRecord.set('CUSTOM_NAME','');
									grdRecord.set('PLAN_TYPE2_CODE2'      , '');
								},
								applyextparam: function(popup){
									popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
									popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
								}						
							}
						})
					},
					{ dataIndex: 'CUSTOM_NAME'			, width: 160	,
						editor: Unilite.popup('AGENT_CUST_G',{
							autoPopup:true,
							listeners		: { 
								'onSelected': {
									fn: function(records, type  ){
										var grdRecord = customerItemMasterGrid.uniOpt.currentRecord;
										grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
										grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
										grdRecord.set('PLAN_TYPE2_CODE2', records[0]['CUSTOM_CODE']);
									},
									scope: this
								},
								'onClear' : function(type)	{
									var grdRecord = customerItemMasterGrid.uniOpt.currentRecord;
									grdRecord.set('CUSTOM_CODE','');
									grdRecord.set('CUSTOM_NAME','');
									grdRecord.set('PLAN_TYPE2_CODE2'      , '');
								},
								applyextparam: function(popup){
									popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
									popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
								}						
							}
						})
					},                  

                   { dataIndex:  'ITEM_CODE'                ,           width:100,
                        'editor' : Unilite.popup('DIV_PUMOK_G', {       
                                    textFieldName: 'ITEM_CODE',
                                    DBtextFieldName: 'ITEM_CODE',
//                                    extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
									autoPopup: true,
                                    listeners: {'onSelected': {
                                                        fn: function(records, type) {
                                                                console.log('records : ', records);
                                                                Ext.each(records, function(record,i) {                                                                     
                                                                                    if(i==0) {
                                                                                                customerItemMasterGrid.setItemCodeData3(record,false, customerItemMasterGrid.uniOpt.currentRecord);
                                                                                            } else {
                                                                                                UniAppManager.app.onNewDataButtonDown();
                                                                                                customerItemMasterGrid.setItemCodeData3(record,false, customerItemMasterGrid.getSelectedRecord());
                                                                                            }
                                                                }); 
                                                        },
                                                        scope: this
                                                },
                                                'onClear': function(type) {
                                                    customerItemMasterGrid.setItemCodeData3(null,true, customerItemMasterGrid.uniOpt.currentRecord);
                                                },
                                                applyextparam: function(popup){                         
                                                    popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                                                }
                                        }
                     })      
                      }
                  ,{ dataIndex: 'ITEM_NAME'                ,           width:100 ,
                        'editor' : Unilite.popup('DIV_PUMOK_G', {
//                                    extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
									autoPopup: true,
                                    listeners: {'onSelected': {
                                                        fn: function(records, type) {
                                                                console.log('records : ', records);
                                                                Ext.each(records, function(record,i) {                                                                     
                                                                                    if(i==0) {
                                                                                                customerItemMasterGrid.setItemCodeData3(record,false, customerItemMasterGrid.uniOpt.currentRecord);
                                                                                            } else {
                                                                                                UniAppManager.app.onNewDataButtonDown();
                                                                                                customerItemMasterGrid.setItemCodeData3(record,false, customerItemMasterGrid.getSelectedRecord());
                                                                                            }
                                                                }); 
                                                        },
                                                        scope: this
                                                },
                                                'onClear': function(type) {
                                                    customerItemMasterGrid.setItemCodeData3(null,true, customerItemMasterGrid.uniOpt.currentRecord);
                                                },
                                                applyextparam: function(popup){                         
                                                    popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                                                }
                                        }
                    })      
                     }
                   ,{ dataIndex:    'SPEC'                          ,           width:105 }
                   ,{
                    text: '<t:message code="system.label.sales.totalamount" default="합계"/>',
                    columns:[
                        { dataIndex:    'PLAN_SUM_Q'                ,           width:86 }
                       ,{ dataIndex:    'PLAN_SUM_AMT'              ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_SUM_Q'            ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_SUM_AMT'          ,           width:86 } 
                    ]
                  },{
                    text: '<t:message code="system.label.sales.january" default="1월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY1'                 ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT1'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q1'               ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT1'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.february" default="2월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY2'                 ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT2'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q2'               ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT2'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.march" default="3월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY3'                 ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT3'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q3'               ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT3'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.april" default="4월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY4'                 ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT4'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q4'               ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT4'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.may" default="5월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY5'                 ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT5'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q5'               ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT5'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.june" default="6월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY6'                 ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT6'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q6'               ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT6'             ,           width:86 } 
                    ]
                  },{
                    text: '<t:message code="system.label.sales.july" default="7월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY7'                 ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT7'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q7'               ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT7'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.august" default="8월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY8'                 ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT8'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q8'               ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT8'             ,           width:86 }                     
                    ]
                  },{
                    text: '<t:message code="system.label.sales.september" default="9월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY9'                 ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT9'                 ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q9'               ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT9'             ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.october" default="10월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY10'                ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT10'                ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q10'              ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT10'            ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.november" default="11월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY11'                ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT11'                ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q11'              ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT11'            ,           width:86 }
                    ]
                  },{
                    text: '<t:message code="system.label.sales.december" default="12월"/>',
                    columns:[
                        { dataIndex:    'PLAN_QTY12'                ,           width:86 }
                       ,{ dataIndex:    'PLAN_AMT12'                ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_Q12'              ,           width:86 }
                       ,{ dataIndex:    'MOD_PLAN_AMT12'            ,           width:86 }
                    ]
                  }
                   ,{ dataIndex:    'UPDATE_DB_USER'            ,           width:86, hidden: true }
                   ,{ dataIndex:    'UPDATE_DB_TIME'            ,           width:86, hidden: true }
                   ,{ dataIndex:    'COMP_CODE'                 ,           width:86, hidden: true }
                   
          ],
          isteners: { 
                beforeedit  : function( editor, e, eOpts ) {
                    if(e.record.phantom == false) {
                        var record = customerItemMasterGrid.getSelectedRecord();
                        if(record.get('CONFIRM_YN') == 'N') {
                            if(UniUtils.indexOf(e.field, ['PLAN_QTY1', 'PLAN_AMT1', 'PLAN_QTY2', 'PLAN_AMT2', 'PLAN_QTY3', 'PLAN_AMT3', 'PLAN_QTY4', 'PLAN_AMT4', 'PLAN_QTY5', 'PLAN_AMT5'
                                                            , 'PLAN_QTY6', 'PLAN_AMT6', 'PLAN_QTY7', 'PLAN_AMT7', 'PLAN_QTY8', 'PLAN_AMT8', 'PLAN_QTY9', 'PLAN_AMT9', 'PLAN_QTY10', 'PLAN_AMT10', 'PLAN_QTY11', 'PLAN_AMT11', 'PLAN_QTY12', 'PLAN_AMT12'])) {
                                return true;
                            } else {
                                return false;
                            }
                        } else {
                            if(UniUtils.indexOf(e.field, ['MOD_PLAN_QTY1', 'MOD_PLAN_AMT1', 'MOD_PLAN_QTY2', 'MOD_PLAN_AMT2', 'MOD_PLAN_QTY3', 'MOD_PLAN_AMT3', 'MOD_PLAN_QTY4', 'MOD_PLAN_AMT4', 'MOD_PLAN_QTY5', 'MOD_PLAN_AMT5'
                                                            , 'MOD_PLAN_QTY6', 'MOD_PLAN_AMT6', 'MOD_PLAN_QTY7', 'MOD_PLAN_AMT7', 'MOD_PLAN_QTY8', 'MOD_PLAN_AMT8', 'MOD_PLAN_QTY9', 'MOD_PLAN_AMT9', 'MOD_PLAN_QTY10', 'MOD_PLAN_AMT10', 'MOD_PLAN_QTY11', 'MOD_PLAN_AMT11', 'MOD_PLAN_QTY12', 'MOD_PLAN_AMT12'])) {
                                return true;
                            } else {
                                return false;
                            }
                        }
                    } else {
                        if(UniUtils.indexOf(e.field, ['CUSTOM_CODE', 'CUSTOM_NAME', 'ITEM_CODE', 'ITEM_NAME', 'PLAN_QTY1', 'PLAN_AMT1', 'PLAN_QTY2', 'PLAN_AMT2', 'PLAN_QTY3', 'PLAN_AMT3', 'PLAN_QTY4', 'PLAN_AMT4', 'PLAN_QTY5', 'PLAN_AMT5'
                                                        , 'PLAN_QTY6', 'PLAN_AMT6', 'PLAN_QTY7', 'PLAN_AMT7', 'PLAN_QTY8', 'PLAN_AMT8', 'PLAN_QTY9', 'PLAN_AMT9', 'PLAN_QTY10', 'PLAN_AMT10', 'PLAN_QTY11', 'PLAN_AMT11', 'PLAN_QTY12', 'PLAN_AMT12'])) {
                            return true;
                        } else {
                            return false;
                        }
                    }
                }
            },
		setExcelData: function(records) {
			var grdRecord			= this.getSelectedRecord();
			var newDetailRecords	= new Array();
			var columns				= this.getColumns();
			Ext.each(records, function(record, i){
				var r = {            					
				};
				newDetailRecords[i] = customerItemMasterStore.model.create( r );
				Ext.each(columns, function(column, index) {
					newDetailRecords[i].set(column.initialConfig.dataIndex, record.get(column.initialConfig.dataIndex));

				});
				
	            newDetailRecords[i].set('DIV_CODE'             ,panelSearch.getValue('DIV_CODE'));
	            newDetailRecords[i].set('PLAN_YEAR'            ,panelSearch.getValue('PLAN_YEAR'));
	            newDetailRecords[i].set('PLAN_TYPE1'           ,panelSearch.getValue('ORDER_TYPE'));
	            newDetailRecords[i].set('PLAN_TYPE2'           ,'6');	
	            newDetailRecords[i].set('LEVEL_KIND'           ,'*');
				newDetailRecords[i].set('PLAN_TYPE2_CODE2'     , record.get('CUSTOM_CODE'));	
				newDetailRecords[i].set('PLAN_TYPE2_CODE'     , record.get('CUSTOM_NAME'));
	            newDetailRecords[i].set('MONEY_UNIT'           ,panelSearch.getValue('MONEY_UNIT'));
	            newDetailRecords[i].set('ENT_MONEY_UNIT'       ,panelSearch.getValue('MONEY_UNIT_DIV'));	
	            newDetailRecords[i].set('CONFIRM_YN'           , 'N');
	            newDetailRecords[i].set('CUSTOM_CODE'          , record.get('CUSTOM_CODE'));	
	            newDetailRecords[i].set('ITEM_CODE'            , record.get('CUSTOM_NAME'));

	            newDetailRecords[i].set('PLAN_SUM_Q'            , record.get('PLAN_SUM_Q'));
	            newDetailRecords[i].set('PLAN_SUM_AMT'          , record.get('PLAN_SUM_AMT'));
	            
	            newDetailRecords[i].set('PLAN_QTY1'            , record.get('PLAN_QTY1'));
	            newDetailRecords[i].set('PLAN_AMT1'            , record.get('PLAN_AMT1'));
	            newDetailRecords[i].set('PLAN_QTY2'            , record.get('PLAN_QTY2'));
	            newDetailRecords[i].set('PLAN_AMT2'            , record.get('PLAN_AMT2'));
	            newDetailRecords[i].set('PLAN_QTY3'            , record.get('PLAN_QTY3'));
	            newDetailRecords[i].set('PLAN_AMT3'            , record.get('PLAN_AMT3'));
	            newDetailRecords[i].set('PLAN_QTY4'            , record.get('PLAN_QTY4'));
	            newDetailRecords[i].set('PLAN_AMT4'            , record.get('PLAN_AMT4'));
	            newDetailRecords[i].set('PLAN_QTY5'            , record.get('PLAN_QTY5'));
	            newDetailRecords[i].set('PLAN_AMT5'            , record.get('PLAN_AMT5'));
	            newDetailRecords[i].set('PLAN_QTY6'            , record.get('PLAN_QTY6'));
	            newDetailRecords[i].set('PLAN_AMT6'            , record.get('PLAN_AMT6'));
	            newDetailRecords[i].set('PLAN_QTY7'            , record.get('PLAN_QTY7'));
	            newDetailRecords[i].set('PLAN_AMT7'            , record.get('PLAN_AMT7'));
	            newDetailRecords[i].set('PLAN_QTY8'            , record.get('PLAN_QTY8'));
	            newDetailRecords[i].set('PLAN_AMT8'            , record.get('PLAN_AMT8'));
	            newDetailRecords[i].set('PLAN_QTY9'            , record.get('PLAN_QTY9'));
	            newDetailRecords[i].set('PLAN_AMT9'            , record.get('PLAN_AMT9'));
	            newDetailRecords[i].set('PLAN_QTY10'            , record.get('PLAN_QTY10'));
	            newDetailRecords[i].set('PLAN_AMT10'            , record.get('PLAN_AMT10'));
	            newDetailRecords[i].set('PLAN_QTY11'            , record.get('PLAN_QTY11'));
	            newDetailRecords[i].set('PLAN_AMT11'            , record.get('PLAN_AMT11'));
	            newDetailRecords[i].set('PLAN_QTY12'            , record.get('PLAN_QTY12'));
	            newDetailRecords[i].set('PLAN_AMT12'            , record.get('PLAN_AMT12'));	            

			});
			
			customerItemMasterStore.loadData(newDetailRecords, true);
		},             
            setItemCodeData3: function(record, dataClear, grdRecord) {   
                var grdRecord = this.uniOpt.currentRecord;
                if(dataClear) {
                    grdRecord.set('ITEM_CODE'          , '');
                    grdRecord.set('ITEM_NAME'          , '');
                    grdRecord.set('PLAN_TYPE2_CODE'   , '');
                    grdRecord.set('SPEC'               , '');
                    
                } else {
                    grdRecord.set('ITEM_CODE'          , record['ITEM_CODE']);
                    grdRecord.set('ITEM_NAME'          , record['ITEM_NAME']);
                    grdRecord.set('PLAN_TYPE2_CODE'   , record['ITEM_CODE']);
                    grdRecord.set('SPEC'               , record['SPEC']);
                }
            },
            setCustomItemData:function(record){
                var grdRecord = this.getSelectedRecord();
                grdRecord.set('DIV_CODE'             ,panelSearch.getValue('DIV_CODE'));
                grdRecord.set('PLAN_YEAR'            ,panelSearch.getValue('PLAN_YEAR'));
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
    
    var saleTypeGrid = Unilite.createGrid('sgp100ukrvSaleTypeGrids', { 
        layout : 'fit',        
        store: saleTypeStore, 
        flex: 1,
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
		tbar: [{
			itemId: 'excelBtn7',
			text: '엑셀업로드',
			handler: function() {
					openExcelWindow7();
			}
		}],         
        columns:  [ 
            { dataIndex: 'DIV_CODE'                        ,           width:86, hidden: true},
            { dataIndex: 'PLAN_YEAR'                       ,           width:86, hidden: true},
            { dataIndex: 'PLAN_TYPE1'                      ,           width:100},
            { dataIndex: 'PLAN_TYPE2'                      ,           width:86, hidden: true},
            { dataIndex: 'PLAN_TYPE2_CODE'                 ,           width:86, hidden: true},
            { dataIndex: 'LEVEL_KIND'                      ,           width:86, hidden: true},
            { dataIndex: 'MONEY_UNIT'                      ,           width:86, hidden: true},
            { dataIndex: 'ENT_MONEY_UNIT'                  ,           width:86, hidden: true},
            { dataIndex: 'CONFIRM_YN'                      ,           width:86, hidden: true},
            { dataIndex: 'MONEY_UNIT_DIV'                  ,           width:86, hidden: true},
            { dataIndex: 'S_CODE1'                         ,           width:86, hidden: true},
            { dataIndex: 'S_CODE2'                         ,           width:86, hidden: true},
            { dataIndex: 'S_CODE3'                         ,           width:86, hidden: true},
//            { dataIndex: 'S_NAME'                          ,           width:86},
            {
                text: '<t:message code="system.label.sales.totalamount" default="합계"/>',
                columns:[
                    { dataIndex: 'PLAN_SUM'                        ,           width:86},
                    { dataIndex: 'MOD_PLAN_SUM'                    ,           width:86},
                    { dataIndex: 'A_D_RATE_SUM'                    ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.january" default="1월"/>',
                columns:[
                    { dataIndex: 'PLAN1'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN1'                        ,           width:86},
                    { dataIndex: 'A_D_RATE1'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.february" default="2월"/>',
                columns:[
                    { dataIndex: 'PLAN2'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN2'                        ,           width:86},
                    { dataIndex: 'A_D_RATE2'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.march" default="3월"/>',
                columns:[
                    { dataIndex: 'PLAN3'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN3'                        ,           width:86},
                    { dataIndex: 'A_D_RATE3'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.april" default="4월"/>',
                columns:[
                    { dataIndex: 'PLAN4'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN4'                        ,           width:86},
                    { dataIndex: 'A_D_RATE4'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.may" default="5월"/>',
                columns:[
                    { dataIndex: 'PLAN5'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN5'                        ,           width:86},
                    { dataIndex: 'A_D_RATE5'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.june" default="6월"/>',
                columns:[
                    { dataIndex: 'PLAN6'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN6'                        ,           width:86},
                    { dataIndex: 'A_D_RATE6'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.july" default="7월"/>',
                columns:[
                    { dataIndex: 'PLAN7'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN7'                        ,           width:86},
                    { dataIndex: 'A_D_RATE7'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.august" default="8월"/>',
                columns:[
                    { dataIndex: 'PLAN8'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN8'                        ,           width:86},
                    { dataIndex: 'A_D_RATE8'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.september" default="9월"/>',
                columns:[
                    { dataIndex: 'PLAN9'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN9'                        ,           width:86},
                    { dataIndex: 'A_D_RATE9'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.october" default="10월"/>',
                columns:[
                    { dataIndex: 'PLAN10'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN10'                        ,           width:86},
                    { dataIndex: 'A_D_RATE10'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.november" default="11월"/>',
                columns:[
                    { dataIndex: 'PLAN11'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN11'                        ,           width:86},
                    { dataIndex: 'A_D_RATE11'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.december" default="12월"/>',
                columns:[
                    { dataIndex: 'PLAN12'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN12'                        ,           width:86},
                    { dataIndex: 'A_D_RATE12'                        ,           width:86}
                ]
            },
            { dataIndex: 'UPDATE_DB_USER'                  ,           width:86, hidden: true},
            { dataIndex: 'UPDATE_DB_TIME'                  ,           width:86, hidden: true},
            { dataIndex: 'COMP_CODE'                       ,           width:86, hidden: true}
        ],
          listeners: { 
            beforeedit  : function( editor, e, eOpts ) {
                if(e.record.phantom == false) {
                    var record = saleTypeGrid.getSelectedRecord();
                    if(record.get('CONFIRM_YN') == 'N') {
                        if(UniUtils.indexOf(e.field, ['PLAN1', 'PLAN2', 'PLAN3', 'PLAN4', 'PLAN5', 'PLAN6', 'PLAN7', 'PLAN8', 'PLAN9', 'PLAN10', 'PLAN11', 'PLAN12'])) {
                            return true;
                        } else {
                            return false;
                        }
                    } else {
                        if(UniUtils.indexOf(e.field, ['MOD_PLAN1', 'MOD_PLAN2', 'MOD_PLAN3', 'MOD_PLAN4', 'MOD_PLAN5', 'MOD_PLAN6', 'MOD_PLAN7', 'MOD_PLAN8', 'MOD_PLAN9', 'MOD_PLAN10', 'MOD_PLAN11', 'MOD_PLAN12'])) {
                            return true;
                        } else {
                            return false;
                        }
                    }
                } else {
                    if(UniUtils.indexOf(e.field, ['PLAN_TYPE1', 'S_CODE1', 'S_CODE2', 'S_CODE3', 'PLAN1', 'PLAN2', 'PLAN3', 'PLAN4', 'PLAN5', 'PLAN6', 'PLAN7', 'PLAN8', 'PLAN9', 'PLAN10', 'PLAN11', 'PLAN12'])) {
                        return true;
                    } else {
                        return false;
                    }
                }
            }
         },
         
		setExcelData: function(records) {
			var grdRecord			= this.getSelectedRecord();
			var newDetailRecords	= new Array();
			var columns				= this.getColumns();
			Ext.each(records, function(record, i){
				var r = {            					
				};
				newDetailRecords[i] = saleTypeStore.model.create( r );
				Ext.each(columns, function(column, index) {
					newDetailRecords[i].set(column.initialConfig.dataIndex, record.get(column.initialConfig.dataIndex));

				});
				
	            newDetailRecords[i].set('DIV_CODE'             ,panelSearch.getValue('DIV_CODE'));
	            newDetailRecords[i].set('PLAN_YEAR'            ,panelSearch.getValue('PLAN_YEAR'));
	            newDetailRecords[i].set('PLAN_TYPE1'           ,record.get('S_CODE'));	
	            newDetailRecords[i].set('PLAN_TYPE2'           ,'S');	
	            newDetailRecords[i].set('LEVEL_KIND'           ,'*');
				newDetailRecords[i].set('PLAN_TYPE2_CODE'      ,'*');        
	            newDetailRecords[i].set('MONEY_UNIT'           ,panelSearch.getValue('MONEY_UNIT'));
	            newDetailRecords[i].set('ENT_MONEY_UNIT'       ,panelSearch.getValue('MONEY_UNIT_DIV'));	
	            newDetailRecords[i].set('CONFIRM_YN'           , 'N');

			});
			
			saleTypeStore.loadData(newDetailRecords, true);
		},          
        setSaleTypeData:function(record){
            var grdRecord = this.getSelectedRecord();
            grdRecord.set('DIV_CODE'             ,panelSearch.getValue('DIV_CODE'));
            grdRecord.set('PLAN_YEAR'            ,panelSearch.getValue('PLAN_YEAR'));
            grdRecord.set('PLAN_TYPE1'           ,record['PLAN_TYPE1']);
            grdRecord.set('PLAN_TYPE2'           ,'S');
            grdRecord.set('PLAN_TYPE2_CODE'      ,'*');
            grdRecord.set('LEVEL_KIND'           ,'*');
            grdRecord.set('MONEY_UNIT'           ,panelSearch.getValue('MONEY_UNIT'));
            grdRecord.set('ENT_MONEY_UNIT'       ,panelSearch.getValue('MONEY_UNIT_DIV'));
            grdRecord.set('CONFIRM_YN'           ,record['CONFIRM_YN']);
            grdRecord.set('S_CODE'               ,record['S_CODE']);
            grdRecord.set('S_NAME'               ,record['S_NAME']);
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
    
    var customitemSortMasterGrid = Unilite.createGrid('sgp100ukrvCustomItemSortMasterGrid', { 
        layout : 'fit',        
        store: customitemSortMasterStore,
        flex: 1,
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
		tbar: [{
			itemId: 'excelBtn10',
			text: '엑셀업로드',
			handler: function() {
					openExcelWindow10();
			}
		}],         
        columns:  [
            { dataIndex: 'DIV_CODE'                        ,           width:86, hidden: true},
            { dataIndex: 'PLAN_YEAR'                       ,           width:86, hidden: true},
            { dataIndex: 'PLAN_TYPE1'                      ,           width:86, hidden: true},
            { dataIndex: 'PLAN_TYPE2'                      ,           width:86, hidden: true},
            { dataIndex: 'PLAN_TYPE2_CODE'                 ,           width:86, hidden: true},
            { dataIndex: 'PLAN_TYPE2_CODE2'                ,           width:86, hidden: true},
            { dataIndex: 'LEVEL_KIND'                      ,           width:86, hidden: true},
            { dataIndex: 'MONEY_UNIT'                      ,           width:86, hidden: true},
            { dataIndex: 'ENT_MONEY_UNIT'                  ,           width:86, hidden: true},
            { dataIndex: 'CONFIRM_YN'                      ,           width:86, hidden: true},
			{ dataIndex: 'CUSTOM_CODE'			, width: 100	,
				editor: Unilite.popup('AGENT_CUST_G',{
					autoPopup:true,
					listeners		: { 
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = customitemSortMasterGrid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
								grdRecord.set('PLAN_TYPE2_CODE', records[0]['CUSTOM_CODE']);
							},
							scope: this
						},
						'onClear' : function(type)	{
							var grdRecord = customitemSortMasterGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
							grdRecord.set('PLAN_TYPE2_CODE'      , '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
							popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
						}						
					}
				})
			},
			{ dataIndex: 'CUSTOM_NAME'			, width: 160	,
				editor: Unilite.popup('AGENT_CUST_G',{
					autoPopup:true,
					listeners		: { 
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = customitemSortMasterGrid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
								grdRecord.set('PLAN_TYPE2_CODE', records[0]['CUSTOM_CODE']);
							},
							scope: this
						},
						'onClear' : function(type)	{
							var grdRecord = customitemSortMasterGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
							grdRecord.set('PLAN_TYPE2_CODE'      , '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
							popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
						}						
					}
				})
			},
            { dataIndex: 'S_CODE1'                         ,           width:86},
            { dataIndex: 'S_CODE2'                         ,           width:86},
            { dataIndex: 'S_CODE3'                         ,           width:86},
            {
                text: '<t:message code="system.label.sales.totalamount" default="합계"/>',
                columns:[
                    { dataIndex: 'PLAN_SUM'                        ,           width:86},
                    { dataIndex: 'MOD_PLAN_SUM'                    ,           width:86},
                    { dataIndex: 'A_D_RATE_SUM'                    ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.january" default="1월"/>',
                columns:[
                    { dataIndex: 'PLAN1'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN1'                        ,           width:86},
                    { dataIndex: 'A_D_RATE1'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.february" default="2월"/>',
                columns:[
                    { dataIndex: 'PLAN2'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN2'                        ,           width:86},
                    { dataIndex: 'A_D_RATE2'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.march" default="3월"/>',
                columns:[
                    { dataIndex: 'PLAN3'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN3'                        ,           width:86},
                    { dataIndex: 'A_D_RATE3'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.april" default="4월"/>',
                columns:[
                    { dataIndex: 'PLAN4'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN4'                        ,           width:86},
                    { dataIndex: 'A_D_RATE4'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.may" default="5월"/>',
                columns:[
                    { dataIndex: 'PLAN5'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN5'                        ,           width:86},
                    { dataIndex: 'A_D_RATE5'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.june" default="6월"/>',
                columns:[
                    { dataIndex: 'PLAN6'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN6'                        ,           width:86},
                    { dataIndex: 'A_D_RATE6'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.july" default="7월"/>',
                columns:[
                    { dataIndex: 'PLAN7'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN7'                        ,           width:86},
                    { dataIndex: 'A_D_RATE7'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.august" default="8월"/>',
                columns:[
                    { dataIndex: 'PLAN8'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN8'                        ,           width:86},
                    { dataIndex: 'A_D_RATE8'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.september" default="9월"/>',
                columns:[
                    { dataIndex: 'PLAN9'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN9'                        ,           width:86},
                    { dataIndex: 'A_D_RATE9'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.october" default="10월"/>',
                columns:[
                    { dataIndex: 'PLAN10'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN10'                        ,           width:86},
                    { dataIndex: 'A_D_RATE10'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.november" default="11월"/>',
                columns:[
                    { dataIndex: 'PLAN11'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN11'                        ,           width:86},
                    { dataIndex: 'A_D_RATE11'                        ,           width:86}
                ]
            },
            {
                text: '<t:message code="system.label.sales.december" default="12월"/>',
                columns:[
                    { dataIndex: 'PLAN12'                            ,           width:86},
                    { dataIndex: 'MOD_PLAN12'                        ,           width:86},
                    { dataIndex: 'A_D_RATE12'                        ,           width:86}
                ]
            },
            { dataIndex: 'UPDATE_DB_USER'                  ,           width:86, hidden: true},
            { dataIndex: 'UPDATE_DB_TIME'                  ,           width:86, hidden: true},
            { dataIndex: 'COMP_CODE'                       ,           width:86, hidden: true}
        ],
          listeners: { 
            beforeedit  : function( editor, e, eOpts ) {
                if(e.record.phantom == false) {
                    var record = customitemSortMasterGrid.getSelectedRecord();
                    if(record.get('CONFIRM_YN') == 'N') {
                        if(UniUtils.indexOf(e.field, ['PLAN1', 'PLAN2', 'PLAN3', 'PLAN4', 'PLAN5', 'PLAN6', 'PLAN7', 'PLAN8', 'PLAN9', 'PLAN10', 'PLAN11', 'PLAN12'])) {
                            return true;
                        } else {
                            return false;
                        }
                    } else {
                        if(UniUtils.indexOf(e.field, ['MOD_PLAN1', 'MOD_PLAN2', 'MOD_PLAN3', 'MOD_PLAN4', 'MOD_PLAN5', 'MOD_PLAN6', 'MOD_PLAN7', 'MOD_PLAN8', 'MOD_PLAN9', 'MOD_PLAN10', 'MOD_PLAN11', 'MOD_PLAN12'])) {
                            return true;
                        } else {
                            return false;
                        }
                    }
                } else {
                    if(UniUtils.indexOf(e.field, ['CUSTOM_CODE', 'CUSTOM_NAME', 'S_CODE1', 'S_CODE2', 'S_CODE3', 'PLAN1', 'PLAN2', 'PLAN3', 'PLAN4', 'PLAN5', 'PLAN6', 'PLAN7', 'PLAN8', 'PLAN9', 'PLAN10', 'PLAN11', 'PLAN12'])) {
                        return true;
                    } else {
                        return false;
                    }
                }
            }
         },  
		setExcelData: function(records) {
			var grdRecord			= this.getSelectedRecord();
			var newDetailRecords	= new Array();
			var columns				= this.getColumns();
			Ext.each(records, function(record, i){
				var r = {            					
				};
				newDetailRecords[i] = customitemSortMasterStore.model.create( r );
				Ext.each(columns, function(column, index) {
					newDetailRecords[i].set(column.initialConfig.dataIndex, record.get(column.initialConfig.dataIndex));

				});
				
	            newDetailRecords[i].set('DIV_CODE'             ,panelSearch.getValue('DIV_CODE'));
	            newDetailRecords[i].set('PLAN_YEAR'            ,panelSearch.getValue('PLAN_YEAR'));
	            newDetailRecords[i].set('PLAN_TYPE1'           ,panelSearch.getValue('ORDER_TYPE'));
	            newDetailRecords[i].set('PLAN_TYPE2'           ,'A');				
				newDetailRecords[i].set('PLAN_TYPE2_CODE', record.get('CUSTOM_CODE'));
				
	            if(Ext.getCmp('CUSTOM_ITEM_LEVEL_ID').getChecked()[0].inputValue == '1') {
		            newDetailRecords[i].set('PLAN_TYPE2_CODE2', record.get('S_CODE1'));
	            } else if(Ext.getCmp('CUSTOM_ITEM_LEVEL_ID').getChecked()[0].inputValue == '2') {
		            newDetailRecords[i].set('PLAN_TYPE2_CODE2', record.get('S_CODE2'));
	            } else {
		            newDetailRecords[i].set('PLAN_TYPE2_CODE2', record.get('S_CODE3'));
	            } 
	            
	            newDetailRecords[i].set('LEVEL_KIND'           ,customitemSortSubForm.getValue('CUSTOM_ITEM_LEVEL_ID').ITEM_LEVEL);
	            newDetailRecords[i].set('MONEY_UNIT'           ,panelSearch.getValue('MONEY_UNIT'));
	            newDetailRecords[i].set('ENT_MONEY_UNIT'       ,panelSearch.getValue('MONEY_UNIT_DIV'));	
	            newDetailRecords[i].set('CONFIRM_YN'           , 'N');

			});
			
			customitemSortMasterStore.loadData(newDetailRecords, true);
		},        
        setCustomItemSortData:function(record){
            var grdRecord = this.getSelectedRecord();
            grdRecord.set('DIV_CODE'             ,panelSearch.getValue('DIV_CODE'));
            grdRecord.set('PLAN_YEAR'            ,panelSearch.getValue('PLAN_YEAR'));
            grdRecord.set('PLAN_TYPE1'           ,panelSearch.getValue('ORDER_TYPE'));
            grdRecord.set('PLAN_TYPE2'           ,'A');
            grdRecord.set('PLAN_TYPE2_CODE'      ,record['CUSTOM_CODE']);
            grdRecord.set('PLAN_TYPE2_CODE2'     ,record['S_CODE']);
            grdRecord.set('LEVEL_KIND'           ,customitemSortSubForm.getValue('CUSTOM_ITEM_LEVEL_ID').ITEM_LEVEL);
            grdRecord.set('MONEY_UNIT'           ,panelSearch.getValue('MONEY_UNIT'));
            grdRecord.set('ENT_MONEY_UNIT'       ,panelSearch.getValue('MONEY_UNIT_DIV'));
            grdRecord.set('CONFIRM_YN'           ,record['CONFIRM_YN']);
            grdRecord.set('CUSTOM_CODE'          ,record['CUSTOM_CODE']);
            grdRecord.set('CUSTOM_NAME'          ,record['CUSTOM_NAME']);
            
            if(Ext.getCmp('CUSTOM_ITEM_LEVEL_ID').getChecked()[0].inputValue == '1') {
	            grdRecord.set('S_CODE1'               ,record['S_CODE']);
            } else if(Ext.getCmp('CUSTOM_ITEM_LEVEL_ID').getChecked()[0].inputValue == '2') {
	            grdRecord.set('S_CODE2'               ,record['S_CODE']);
            } else {
	            grdRecord.set('S_CODE3'               ,record['S_CODE']);
            }   
            
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
        
    var tab = Unilite.createTabPanel('tabPanel',{
        activeTab: 0,
        region: 'center',
        items: [
                 {
                     title: '<t:message code="system.label.sales.clientby" default="고객별"/>'
                     ,xtype:'container'
                     ,layout:{type:'vbox', align:'stretch'}
                     ,items:[customSubForm, customMasterGrid]
                     ,id: 'sgp100ukrvCustomGrid' 
                     ,hidden: !use2
                 },
                 {
                     title: '<t:message code="system.label.sales.saleschargeby" default="영업담당별"/>'
                     ,xtype:'container'
                     ,layout:{type:'vbox', align:'stretch'}
                     ,items:[salePrsnMasterGrid]
                     ,id: 'sgp100ukrvSalePrsnGrid'
                     ,hidden: !use1
                 },
                 {
                     title: '<t:message code="system.label.sales.itemby" default="품목별"/>'
                     ,xtype:'container'
                     ,layout:{type:'vbox', align:'stretch'}
                     ,items:[itemSubForm, itemMasterGrid]
                     ,id: 'sgp100ukrvItemGrid'
                     ,hidden: !use3
                 },
                 {
                     title: '<t:message code="system.label.sales.itemgroupby" default="품목분류별"/>'
                     ,xtype:'container'
                     ,layout:{type:'vbox', align:'stretch'}
                     ,items:[itemSortSubForm, itemSortMasterGrid]
                     ,id: 'sgp100ukrvitemSortGrid' 
                     ,hidden: !use4
                 },
                 {
                     title: '<t:message code="system.label.sales.repmodelby" default="대표모델별"/>'
                     ,xtype:'container'
                     ,layout:{type:'vbox', align:'stretch'}
                     ,items:[spokesItemSubForm, spokesItemMasterGrid]
                     ,id: 'sgp100ukrvspokesItemGrid' 
                     ,hidden: !use5
                 },
                 {
                     title: '<t:message code="system.label.sales.clientitemby" default="고객품목별"/>'
                     ,xtype:'container'
                     ,layout:{type:'vbox', align:'stretch'}
                     ,items:[customerItemSubForm, customerItemMasterGrid]
                     ,id: 'sgp100ukrvcustomerItemGrid' 
                     ,hidden: !use6
                 },
                 {
                     title: '<t:message code="system.label.sales.sellingtypeby" default="판매유형별"/>'
                     ,xtype:'container'
                     ,layout:{type:'vbox', align:'stretch'}
                     ,items:[saleTypeGrid]
                     ,id: 'sgp100ukrvSaleTypeGrid' 
                     ,hidden: !use9
                 },
                 {
                     title: '<t:message code="system.label.sales.customitemgroupby" default="고객품목분류별"/>'
                     ,xtype:'container'
                     ,layout:{type:'vbox', align:'stretch'}
                     ,items:[customitemSortSubForm, customitemSortMasterGrid]
                     ,id: 'sgp100ukrvcustomitemSortGrid' 
                     ,hidden: !use10
                 }
        ],
        listeners:  {
            beforetabchange: function ( grouptabPanel, newCard, oldCard, eOpts )    {
                if(Ext.isObject(oldCard))   {
                     if(UniAppManager.app._needSave())  {
                        if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {
                            UniAppManager.app.onSaveDataButtonDown();
                            this.setActiveTab(oldCard);
                        }else {
                        	UniAppManager.setToolbarButtons('reset', true);
            				UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'],false);
                            UniAppManager.setToolbarButtons(['excel', 'delete'],false);
                            UniAppManager.app.loadTabData(newCard, newCard.getItemId());

                        }
                     }else {
                        	UniAppManager.setToolbarButtons('reset', true);
            				UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'],false);
                            UniAppManager.setToolbarButtons(['excel', 'delete'],false);
                            UniAppManager.app.loadTabData(newCard, newCard.getItemId());

                     }
	                }
	            },    	
            tabChange:  function ( tabPanel, newCard, oldCard, eOpts )  {
            	
                var newTabId = newCard.getId();
                console.log("newCard:  " + newCard.getId());
                console.log("oldCard:  " + oldCard.getId());        

                panelSearch.setAllFieldsReadOnly(false);
                panelResult.setAllFieldsReadOnly(false);
                activeGrid.reset(); 
                var activeTabId = tab.getActiveTab().getId();
                if(activeTabId == 'sgp100ukrvSaleTypeGrid'){
                	panelSearch.setValue('ORDER_TYPE', '');
                	panelResult.setValue('ORDER_TYPE', '');
                	panelSearch.getField('ORDER_TYPE').setReadOnly(true);
                	panelSearch.getField('ORDER_TYPE').allowBlank = true;
                	panelResult.getField('ORDER_TYPE').setReadOnly(true);
                    panelResult.getField('ORDER_TYPE').allowBlank = true;
                }else{
                	panelSearch.setValue('ORDER_TYPE', '10');
                    panelResult.setValue('ORDER_TYPE', '10');
                    panelSearch.getField('ORDER_TYPE').setReadOnly(false);
                    panelSearch.getField('ORDER_TYPE').allowBlank = false;
                    panelResult.getField('ORDER_TYPE').setReadOnly(false);
                    panelResult.getField('ORDER_TYPE').allowBlank = false;
                }
                
                UniAppManager.setToolbarButtons(['save'],false);
                                
            } 
        }
    });
    

    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                tab, panelResult
            ]
        },
            panelSearch     
        ],
        id  : 'sgp100ukrvApp',
        fnInitBinding : function() {
//          itemSortMasterGrid.getColumn('S_CODE').setText('<t:message code="system.label.sales.majorgroup" default="대분류"/>');
            
            itemSortMasterGrid.getColumn('S_CODE1').setVisible(true);
            itemSortMasterGrid.getColumn('S_CODE2').setVisible(false);
            itemSortMasterGrid.getColumn('S_CODE3').setVisible(false);          
            
            customitemSortMasterGrid.getColumn('S_CODE1').setVisible(true);
            customitemSortMasterGrid.getColumn('S_CODE2').setVisible(false);
            customitemSortMasterGrid.getColumn('S_CODE3').setVisible(false);          
            
            var param= Ext.getCmp('searchForm').getValues(); 
            
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons('reset', true);
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'],false);
            panelSearch.clearForm();
            panelResult.clearForm();
            itemSubForm.clearForm();            
            Ext.getCmp('CREATE_DATA1').setDisabled(true);
            Ext.getCmp('CREATE_DATA2').setDisabled(true);
            Ext.getCmp('CONFIRM_DATA1').setDisabled(true);
            Ext.getCmp('CONFIRM_DATA2').setDisabled(true);
            
            var showTab = Ext.getCmp('sgp100ukrvCustomGrid');
            if(use10){
                showTab = Ext.getCmp('sgp100ukrvcustomitemSortGrid');
            }            
            if(use9){
                showTab = Ext.getCmp('sgp100ukrvSaleTypeGrid');
            }
            if(use8){
                //유니라이트용
            }
            if(use7){
                //유니라이트용
            }
            if(use6){
                showTab = Ext.getCmp('sgp100ukrvcustomerItemGrid');
            }
            if(use5){
                showTab = Ext.getCmp('sgp100ukrvspokesItemGrid');
            }
            if(use4){
                showTab = Ext.getCmp('sgp100ukrvitemSortGrid');
            }
            if(use3){
                showTab = Ext.getCmp('sgp100ukrvItemGrid');
            }
            if(use1){
                showTab = Ext.getCmp('sgp100ukrvSalePrsnGrid');
            }
            if(use2){
                showTab = Ext.getCmp('sgp100ukrvCustomGrid');
            }
            showTab.show();
            this.setDefault();
        },
        onQueryButtonDown : function(newValue)  {
            if(!panelSearch.setAllFieldsReadOnly(true)){
                return false;
            }
            UniAppManager.setToolbarButtons('deleteAll', true);
            var activeTabId = tab.getActiveTab().getId();           
            if(activeTabId == 'sgp100ukrvCustomGrid') {
                if(!customSubForm.setAllFieldsReadOnly(true)){
                    return false;
                }           
                customMasterStore.loadStoreRecords();
            } else if(activeTabId == 'sgp100ukrvSalePrsnGrid') {
                salePrsnMasterStore.loadStoreRecords();
            } else if(activeTabId == 'sgp100ukrvItemGrid') {
                if(!itemSubForm.setAllFieldsReadOnly(true)){
                    return false;
                }
                itemMasterStore.loadStoreRecords();
            } else if(activeTabId == 'sgp100ukrvitemSortGrid') {
                if(!itemSortSubForm.setAllFieldsReadOnly(true)){
                    return false;
                }
                
           		var newValue = Ext.getCmp('ITEM_LEVEL_ID').getChecked()[0].inputValue;                
                itemSortMasterStore.loadStoreRecords(newValue);
			            
            } else if(activeTabId == 'sgp100ukrvspokesItemGrid') {
                if(!spokesItemSubForm.setAllFieldsReadOnly(true)){
                    return false;
                }
                spokesItemMasterStore.loadStoreRecords();
            }  else if(activeTabId == 'sgp100ukrvcustomerItemGrid') {
                if(!customerItemSubForm.setAllFieldsReadOnly(true)){
                    return false;
                }
                customerItemMasterStore.loadStoreRecords();
            }  else if(activeTabId == 'sgp100ukrvSaleTypeGrid') {
                saleTypeStore.loadStoreRecords();
            }  else if(activeTabId == 'sgp100ukrvcustomitemSortGrid') {
                if(!customitemSortSubForm.setAllFieldsReadOnly(true)){
                    return false;
                }
                var newValue = Ext.getCmp('CUSTOM_ITEM_LEVEL_ID').getChecked()[0].inputValue;   
                customitemSortMasterStore.loadStoreRecords(newValue);               
                
            }   
            UniAppManager.setToolbarButtons('newData', true);
        
        },
        onResetButtonDown: function() {
            panelSearch.setAllFieldsReadOnly(false);
            panelResult.setAllFieldsReadOnly(false);
            customMasterGrid.reset();
            salePrsnMasterGrid.reset();
            itemMasterGrid.reset();
            itemSortMasterGrid.reset();
            spokesItemMasterGrid.reset();
            customerItemMasterGrid.reset();
            customitemSortMasterGrid.reset();
            saleTypeGrid.reset();
            
            this.fnInitBinding();
        },
        onNewDataButtonDown: function() {
            var activeTabId = tab.getActiveTab().getId(); 
            if(activeTabId == 'sgp100ukrvCustomGrid') {
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
                
                var r = {
                    DIV_CODE: divCode,
                    PLAN_YEAR: planYear,
                    PLAN_TYPE1: orderType,
                    MONEY_UNIT: moneyUnit,
                    ENT_MONEY_UNIT: moneyUnitDiv
                };        
                customMasterGrid.createRow(r, null);
            } else if(activeTabId == 'sgp100ukrvSalePrsnGrid') {
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
                
                var r = {
                    DIV_CODE: divCode,
                    PLAN_YEAR: planYear,
                    PLAN_TYPE1: orderType,
                    MONEY_UNIT: moneyUnit,
                    ENT_MONEY_UNIT: moneyUnitDiv
                };        
                salePrsnMasterGrid.createRow(r, null);
            } else if(activeTabId == 'sgp100ukrvItemGrid') {
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
                
                var r = {
                    DIV_CODE: divCode,
                    PLAN_YEAR: planYear,
                    PLAN_TYPE1: orderType,
                    MONEY_UNIT: moneyUnit,
                    ENT_MONEY_UNIT: moneyUnitDiv
                };        
                itemMasterGrid.createRow(r, null);
            } else if(activeTabId == 'sgp100ukrvitemSortGrid') {
                var itemLevel = Ext.getCmp('ITEM_LEVEL_ID').getChecked()[0].inputValue;
                if(itemLevel == '1') {
                    levelKind = '1';
                } else if(itemLevel == '2') {
                    levelKind = '2';
                } else {
                    levelKind = '3';
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
                
                var r = {
                    DIV_CODE: divCode,
                    PLAN_YEAR: planYear,
                    PLAN_TYPE1: orderType,
                    MONEY_UNIT: moneyUnit,
                    ENT_MONEY_UNIT: moneyUnitDiv,
                    LEVEL_KIND: levelKind
                };        
                itemSortMasterGrid.createRow(r, null);
            } else if(activeTabId == 'sgp100ukrvspokesItemGrid') {
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
                
                var r = {
                    DIV_CODE: divCode,
                    PLAN_YEAR: planYear,
                    PLAN_TYPE1: orderType,
                    MONEY_UNIT: moneyUnit,
                    ENT_MONEY_UNIT: moneyUnitDiv
                };        
                spokesItemMasterGrid.createRow(r, null);
            } else if(activeTabId == 'sgp100ukrvcustomerItemGrid') {
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
                
                var r = {
                    DIV_CODE: divCode,
                    PLAN_YEAR: planYear,
                    PLAN_TYPE1: orderType,
                    MONEY_UNIT: moneyUnit,
                    ENT_MONEY_UNIT: moneyUnitDiv
                };        
                customerItemMasterGrid.createRow(r, null);
            } else if(activeTabId == 'sgp100ukrvSaleTypeGrid') {
            	
                panelSearch.getField('MONEY_UNIT_DIV').setReadOnly(true);
                panelResult.getField('MONEY_UNIT_DIV').setReadOnly(true);
                
//            	var itemLevel = Ext.getCmp('ITEM_LEVEL_ID').getChecked()[0].inputValue;
//                if(itemLevel == '1') {
//                    levelKind = '1';
//                } else if(itemLevel == '2') {
//                    levelKind = '2';
//                } else {
//                    levelKind = '3';
//                }
//                
                var divCode = '';
                if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE')))  {
                    divCode = panelSearch.getValue('DIV_CODE');
                }
                 
                var planYear = '';
                if(!Ext.isEmpty(panelSearch.getValue('PLAN_YEAR'))) {
                    planYear = panelSearch.getValue('PLAN_YEAR');
                }
                /* 
                var orderType = '';
                if(!Ext.isEmpty(panelSearch.getValue('ORDER_TYPE')))    {
                    orderType = panelSearch.getValue('ORDER_TYPE');
                }*/
                 
                var moneyUnit = '';
                if(!Ext.isEmpty(panelSearch.getValue('MONEY_UNIT')))    {
                    moneyUnit = panelSearch.getValue('MONEY_UNIT');
                }
                
                var moneyUnitDiv = '';
                if(!Ext.isEmpty(panelSearch.getValue('MONEY_UNIT_DIV')))    {
                    moneyUnitDiv = panelSearch.getValue('MONEY_UNIT_DIV');
                }
                var r = {
                    DIV_CODE: divCode,
                    PLAN_YEAR: planYear,
                    MONEY_UNIT: moneyUnit,
                    ENT_MONEY_UNIT: moneyUnitDiv,
//                    LEVEL_KIND: '',
                    PLAN_TYPE2: 'S', 
                    MONEY_UNIT_DIV: panelSearch.getValue('MONEY_UNIT_DIV')
                };        
                saleTypeGrid.createRow(r, null);
            }else if(activeTabId == 'sgp100ukrvcustomitemSortGrid') {
                var itemLevel = Ext.getCmp('CUSTOM_ITEM_LEVEL_ID').getChecked()[0].inputValue;
                if(itemLevel == '1') {
                    levelKind = '1';
                } else if(itemLevel == '2') {
                    levelKind = '2';
                } else {
                    levelKind = '3';
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
                
                var r = {
                    DIV_CODE: divCode,
                    PLAN_YEAR: planYear,
                    PLAN_TYPE1: orderType,
                    MONEY_UNIT: moneyUnit,
                    ENT_MONEY_UNIT: moneyUnitDiv,
                    LEVEL_KIND: levelKind
                };        
                customitemSortMasterGrid.createRow(r, null);
            }   
            panelSearch.setAllFieldsReadOnly(true);
            panelResult.setAllFieldsReadOnly(true);
            
        },
        onSaveDataButtonDown: function () {
            var activeTabId = tab.getActiveTab().getId();           
            if(activeTabId == 'sgp100ukrvCustomGrid') {
                customMasterStore.saveStore();
            } else if(activeTabId == 'sgp100ukrvSalePrsnGrid') {
                salePrsnMasterStore.saveStore();
            } else if(activeTabId == 'sgp100ukrvItemGrid') {
                itemMasterStore.saveStore();
            } else if(activeTabId == 'sgp100ukrvitemSortGrid') {
                itemSortMasterStore.saveStore();
            } else if(activeTabId == 'sgp100ukrvspokesItemGrid') {
                spokesItemMasterStore.saveStore();
            } else if(activeTabId == 'sgp100ukrvcustomerItemGrid') {
                customerItemMasterStore.saveStore();
            } else if(activeTabId == 'sgp100ukrvSaleTypeGrid') {
                saleTypeStore.saveStore();
            } else if(activeTabId == 'sgp100ukrvcustomitemSortGrid') {
                customitemSortMasterStore.saveStore();
            }
        },
        onDeleteDataButtonDown: function() {
            var activeTabId = tab.getActiveTab().getId();           
            if(activeTabId == 'sgp100ukrvCustomGrid') {
                if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {              
                    customMasterGrid.deleteSelectedRow();
                }
            } else if(activeTabId == 'sgp100ukrvSalePrsnGrid') {
                if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {              
                    salePrsnMasterGrid.deleteSelectedRow();
                }
            } else if(activeTabId == 'sgp100ukrvItemGrid') {
                if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {              
                    itemMasterGrid.deleteSelectedRow();
                }
            } else if(activeTabId == 'sgp100ukrvitemSortGrid') {
                if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {              
                    itemSortMasterGrid.deleteSelectedRow();
                }
            } else if(activeTabId == 'sgp100ukrvcustomerItemGrid') {
                if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {              
                    customerItemMasterGrid.deleteSelectedRow();
                }
            } else if(activeTabId == 'sgp100ukrvSaleTypeGrid') {
                if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {              
                    saleTypeGrid.deleteSelectedRow();
                }
            } else if(activeTabId == 'sgp100ukrvcustomitemSortGrid') {
                if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {              
                    customitemSortMasterGrid.deleteSelectedRow();
                }
            }  
        },
        onDeleteAllButtonDown: function() {
            var activeTabId = tab.getActiveTab().getId();           
            if(activeTabId == 'sgp100ukrvCustomGrid') {
                var records1 = customMasterStore.data.items;
                var isNewData = false;
                Ext.each(records1, function(record,i) {
                    if(record.phantom) {                     //신규 레코드일시 isNewData에 true를 반환
                        isNewData = true;
                    }else{                                  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
                        if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
                            var deletable = true;
                            if(deletable){      
                                customMasterGrid.reset();         
                                UniAppManager.app.onSaveDataButtonDown();   
                            }
                            isNewData = false;  
                        }
                        return false;
                    }
                });
                if(isNewData){                              //신규 레코드들만 있을시 그리드 리셋          
                    customMasterGrid.reset();
                    UniAppManager.app.onResetButtonDown();  //삭제후 RESET..
                }
            } else if(activeTabId == 'sgp100ukrvSalePrsnGrid') {
                var records2 = salePrsnMasterStore.data.items;
                var isNewData = false;
                Ext.each(records2, function(record,i) {
                    if(record.phantom) {                     //신규 레코드일시 isNewData에 true를 반환
                        isNewData = true;
                    }else{                                  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
                        if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
                            var deletable = true;
                            if(deletable){      
                                salePrsnMasterGrid.reset();         
                                UniAppManager.app.onSaveDataButtonDown();   
                            }
                            isNewData = false;  
                        }
                        return false;
                    }
                });
                if(isNewData){                              //신규 레코드들만 있을시 그리드 리셋          
                    salePrsnMasterGrid.reset();
                    UniAppManager.app.onResetButtonDown();  //삭제후 RESET..
                }
            } else if(activeTabId == 'sgp100ukrvItemGrid') {
                if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
                    var records3 = itemMasterStore.data.items;
                    var isNewData = false;
                    Ext.each(records3, function(record,i) {
                        if(record.phantom) {                     //신규 레코드일시 isNewData에 true를 반환
                            isNewData = true;
                        }else{                                  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
                            if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
                                var deletable = true;
                                if(deletable){      
                                    itemMasterGrid.reset();         
                                    UniAppManager.app.onSaveDataButtonDown();   
                                }
                                isNewData = false;  
                            }
                            return false;
                        }
                    });
                    if(isNewData){                              //신규 레코드들만 있을시 그리드 리셋          
                        itemMasterGrid.reset();
                        UniAppManager.app.onResetButtonDown();  //삭제후 RESET..
                    }
                }
            } else if(activeTabId == 'sgp100ukrvitemSortGrid') {
                var records1 = itemSortMasterStore.data.items;
                var isNewData = false;
                Ext.each(records1, function(record,i) {
                    if(record.phantom) {                     //신규 레코드일시 isNewData에 true를 반환
                        isNewData = true;
                    }else{                                  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
                        if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
                            var deletable = true;
                            if(deletable){      
                                itemSortMasterGrid.reset();         
                                UniAppManager.app.onSaveDataButtonDown();   
                            }
                            isNewData = false;  
                        }
                        return false;
                    }
                });
                if(isNewData){                              //신규 레코드들만 있을시 그리드 리셋          
                    itemSortMasterGrid.reset();
                    UniAppManager.app.onResetButtonDown();  //삭제후 RESET..
                }
            } else if(activeTabId == 'sgp100ukrvspokesItemGrid') {
                var records1 = spokesItemMasterStore.data.items;
                var isNewData = false;
                Ext.each(records1, function(record,i) {
                    if(record.phantom) {                     //신규 레코드일시 isNewData에 true를 반환
                        isNewData = true;
                    }else{                                  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
                        if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
                            var deletable = true;
                            if(deletable){      
                                spokesItemMasterGrid.reset();         
                                UniAppManager.app.onSaveDataButtonDown();   
                            }
                            isNewData = false;  
                        }
                        return false;
                    }
                });
                if(isNewData){                              //신규 레코드들만 있을시 그리드 리셋          
                    spokesItemMasterGrid.reset();
                    UniAppManager.app.onResetButtonDown();  //삭제후 RESET..
                }
            } else if(activeTabId == 'sgp100ukrvcustomerItemGrid') {
                var records1 = customerItemMasterStore.data.items;
                var isNewData = false;
                Ext.each(records1, function(record,i) {
                    if(record.phantom) {                     //신규 레코드일시 isNewData에 true를 반환
                        isNewData = true;
                    }else{                                  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
                        if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
                            var deletable = true;
                            if(deletable){      
                                customerItemMasterGrid.reset();         
                                UniAppManager.app.onSaveDataButtonDown();   
                            }
                            isNewData = false;  
                        }
                        return false;
                    }
                });
                if(isNewData){                              //신규 레코드들만 있을시 그리드 리셋          
                    customerItemMasterGrid.reset();
                    UniAppManager.app.onResetButtonDown();  //삭제후 RESET..
                }
            } else if(activeTabId == 'sgp100ukrvSaleTypeGrid') {
                var records1 = saleTypeStore.data.items;
                var isNewData = false;
                Ext.each(records1, function(record,i) {
                    if(record.phantom) {                     //신규 레코드일시 isNewData에 true를 반환
                        isNewData = true;
                    }else{                                  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
                        if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
                            var deletable = true;
                            if(deletable){      
                                saleTypeGrid.reset();         
                                UniAppManager.app.onSaveDataButtonDown();   
                            }
                            isNewData = false;  
                        }
                        return false;
                    }
                });
                if(isNewData){                              //신규 레코드들만 있을시 그리드 리셋          
                    saleTypeGrid.reset();
                    UniAppManager.app.onResetButtonDown();  //삭제후 RESET..
                }
            }else if(activeTabId == 'sgp100ukrvcustomitemSortGrid') {
                var records1 = customitemSortMasterStore.data.items;
                var isNewData = false;
                Ext.each(records1, function(record,i) {
                    if(record.phantom) {                     //신규 레코드일시 isNewData에 true를 반환
                        isNewData = true;
                    }else{                                  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
                        if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
                            var deletable = true;
                            if(deletable){      
                                customitemSortMasterGrid.reset();         
                                UniAppManager.app.onSaveDataButtonDown();   
                            }
                            isNewData = false;  
                        }
                        return false;
                    }
                });
                if(isNewData){                              //신규 레코드들만 있을시 그리드 리셋          
                    customitemSortMasterGrid.reset();
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
        setDefault: function() {
            panelSearch.setValue('DIV_CODE', UserInfo.divCode);
            panelSearch.setValue('PLAN_YEAR', new Date().getFullYear());
            panelSearch.setValue('MONEY_UNIT', UserInfo.currency);
            panelSearch.setValue('MONEY_UNIT_DIV', '1');
            panelSearch.setValue('ORDER_TYPE', '10');
            panelSearch.setValue('MONEY_UNIT_DIV', BsaCodeInfo.gsEntMoneyUnit);
                                    
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('PLAN_YEAR', new Date().getFullYear());
            panelResult.setValue('MONEY_UNIT', UserInfo.currency);
            panelResult.setValue('MONEY_UNIT_DIV', '1');
            panelResult.setValue('ORDER_TYPE', '10');
            panelResult.setValue('MONEY_UNIT_DIV', BsaCodeInfo.gsEntMoneyUnit);
            
            
            customSubForm.setValue('AGENT_TYPE', '1');      
            itemSubForm.setValue('ITEM_ACCOUNT', '10');
            spokesItemSubForm.setValue('ITEM_ACCOUNT', '10');
            customitemSortSubForm.setValue('CUSTOM_ITEM_LEVEL_ID', '1');
            itemSortSubForm.setValue('ITEM_LEVEL_ID', '1');           
            
            
            panelSearch.getField('MONEY_UNIT_DIV').setReadOnly(false);
            panelResult.getField('MONEY_UNIT_DIV').setReadOnly(false);
        },
		loadTabData: function(tab, itemId){
			
            Ext.getCmp('CREATE_DATA1').setDisabled(true);
            Ext.getCmp('CREATE_DATA2').setDisabled(true);
            Ext.getCmp('CONFIRM_DATA1').setDisabled(true);
            Ext.getCmp('CONFIRM_DATA2').setDisabled(true);
            
            panelSearch.getField('MONEY_UNIT_DIV').setReadOnly(false);
            panelResult.getField('MONEY_UNIT_DIV').setReadOnly(false);            
            			
			
            if(itemId == 'sgp100ukrvCustomGrid') {
            	customSubForm.setValue('AGENT_TYPE', '1');  
                customMasterGrid.reset();
            } else if(itemId == 'sgp100ukrvSalePrsnGrid') {
                salePrsnMasterGrid.reset();
            } else if(itemId == 'sgp100ukrvItemGrid') {
            	itemSubForm.setValue('ITEM_ACCOUNT', '10');
                itemMasterGrid.reset();
            } else if(itemId == 'sgp100ukrvitemSortGrid') {
            	itemSortSubForm.setValue('ITEM_LEVEL_ID', '1');      
                itemSortMasterGrid.reset();
	            itemSortMasterGrid.getColumn('S_CODE1').setVisible(true);
	            itemSortMasterGrid.getColumn('S_CODE2').setVisible(false);
	            itemSortMasterGrid.getColumn('S_CODE3').setVisible(false);                    
            } else if(itemId == 'sgp100ukrvspokesItemGrid') {
            	spokesItemSubForm.setValue('ITEM_ACCOUNT', '10');
                spokesItemMasterGrid.reset();
            } else if(itemId == 'sgp100ukrvcustomerItemGrid') {
                customerItemMasterGrid.reset();   
            } else if(itemId == 'sgp100ukrvSaleTypeGrid') {
                saleTypeGrid.reset();       
            }else if(itemId == 'sgp100ukrvcustomitemSortGrid') {
            	customitemSortSubForm.setValue('CUSTOM_ITEM_LEVEL_ID', '1');
                customitemSortMasterGrid.reset();
	            customitemSortMasterGrid.getColumn('S_CODE1').setVisible(true);
	            customitemSortMasterGrid.getColumn('S_CODE2').setVisible(false);
	            customitemSortMasterGrid.getColumn('S_CODE3').setVisible(false);                   
            } 	

		}
    });
    
    Unilite.createValidator('validator01', {
        store: customMasterStore,
        grid: customMasterGrid,
        validate: function( type, fieldName, newValue, oldValue, record, eopt) {
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;
            switch(fieldName) {
                case "PLAN1" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', newValue + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN2" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + newValue + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN3" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + newValue + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN4" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + newValue + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN5" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + newValue + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN6" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + newValue + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN7" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + newValue
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN8" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + newValue + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN9" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + newValue + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN10" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + newValue + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN11" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + newValue + record.get('PLAN12')); 
                    break; 
                case "PLAN12" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + newValue); 
                    break;
                break;
                
                case "MOD_PLAN1" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', newValue + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN2" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + newValue + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN3" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + newValue + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN4" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + newValue + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN5" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + newValue + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break;  
                case "MOD_PLAN6" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + newValue + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN7" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + newValue
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN8" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + newValue + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN9" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + newValue + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN10" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + newValue + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN11" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + newValue + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN12" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + newValue); 
                    break; 
                
                case "A_D_RATE1" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', newValue + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE2" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', newValue + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE3" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + newValue + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE4" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + newValue + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE5" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + record.get('A_D_RATE3') + newValue + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE6" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + newValue + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE7" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + newValue + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE8" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + newValue
                                             + newValue + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE9" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + newValue + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE10" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + newValue + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE11" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + newValue + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE12" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + newValue); 
                    break; 
            }
            return rv;
        }
    })
    
    Unilite.createValidator('validator02', {
        store: salePrsnMasterStore,
        grid: salePrsnMasterGrid,
        validate: function( type, fieldName, newValue, oldValue, record, eopt) {
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;
            switch(fieldName) {
                case "PLAN1" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', newValue + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN2" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + newValue + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN3" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + newValue + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN4" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + newValue + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN5" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + newValue + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN6" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + newValue + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN7" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + newValue
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN8" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + newValue + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN9" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + newValue + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN10" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + newValue + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN11" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + newValue + record.get('PLAN12')); 
                    break; 
                case "PLAN12" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + newValue); 
                    break;
                break;
                
                case "MOD_PLAN1" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', newValue + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN2" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + newValue + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN3" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + newValue + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN4" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + newValue + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN5" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + newValue + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break;  
                case "MOD_PLAN6" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + newValue + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN7" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + newValue
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN8" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + newValue + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN9" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + newValue + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN10" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + newValue + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN11" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + newValue + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN12" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + newValue); 
                    break; 
                
                case "A_D_RATE1" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', newValue + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE2" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', newValue + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE3" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + newValue + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE4" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + newValue + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE5" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + record.get('A_D_RATE3') + newValue + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE6" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + newValue + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE7" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + newValue + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE8" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + newValue
                                             + newValue + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE9" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + newValue + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE10" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + newValue + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE11" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + newValue + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE12" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + newValue); 
                    break; 
            }
            return rv;
        }
    })
    
    Unilite.createValidator('validator03', {
        store: itemMasterStore,
        grid: itemMasterGrid,
        validate: function( type, fieldName, newValue, oldValue, record, eopt) {
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;
            switch(fieldName) {
                case "PLAN_QTY1" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', newValue + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY2" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + newValue + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY3" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + newValue + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY4" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + newValue + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY5" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + newValue + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY6" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + newValue + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY7" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + newValue
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY8" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + newValue + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY9" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + newValue + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY10" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + newValue + record.get('PLAN_QTY11') + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY11" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + newValue + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY12" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + newValue); 
                    break; 
                
                case "PLAN_AMT1" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', newValue + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12')); 
                    break;   
                case "PLAN_AMT2" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + newValue + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12')); 
                    break; 
                case "PLAN_AMT3" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + newValue + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12')); 
                    break; 
                case "PLAN_AMT4" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + newValue + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12')); 
                    break; 
                case "PLAN_AMT5" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + newValue + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12')); 
                    break;  
                case "PLAN_AMT6" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + newValue + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12')); 
                    break;  
                case "PLAN_AMT7" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + newValue
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12')); 
                    break; 
                case "PLAN_AMT8" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + newValue + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12')); 
                    break; 
                case "PLAN_AMT9" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + newValue + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12')); 
                    break; 
                case "PLAN_AMT10" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + newValue + record.get('PLAN_AMT11') + record.get('PLAN_AMT12')); 
                    break; 
                case "PLAN_AMT11" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + newValue + record.get('PLAN_AMT12')); 
                    break; 
                case "PLAN_AMT12" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + newValue); 
                    break; 
                
                case "MOD_PLAN_Q1" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', newValue + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12')); 
                    break;  
                case "MOD_PLAN_Q2" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + newValue + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12')); 
                    break;  
                case "MOD_PLAN_Q3" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + newValue + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12')); 
                    break;  
                case "MOD_PLAN_Q4" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + newValue + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12')); 
                    break;  
                case "MOD_PLAN_Q5" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + newValue + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12')); 
                    break;  
                case "MOD_PLAN_Q6" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + newValue + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12')); 
                    break;  
                case "MOD_PLAN_Q7" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + newValue
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12')); 
                    break;   
                case "MOD_PLAN_Q8" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + newValue + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12')); 
                    break;  
                case "MOD_PLAN_Q9" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + newValue + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12')); 
                    break;  
                case "MOD_PLAN_Q10" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + newValue + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12')); 
                    break;  
                case "MOD_PLAN_Q11" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + newValue + record.get('MOD_PLAN_Q12')); 
                    break;  
                case "MOD_PLAN_Q12" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + newValue); 
                    break;  
                
                case "MOD_PLAN_AMT1" :  
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', newValue + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT2" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + newValue + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT3" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + newValue + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT4" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + newValue + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT5" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + newValue + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT6" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + newValue + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT7" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + newValue
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT8" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + newValue + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT9" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + newValue + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT10" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + newValue + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT11" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + newValue + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT12" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + newValue); 
                    break;  
            }
            return rv;
        }
    })
    
    Unilite.createValidator('validator04', {
        store: itemSortMasterStore,
        grid: itemSortMasterGrid,
        validate: function( type, fieldName, newValue, oldValue, record, eopt) {
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;
            switch(fieldName) {
                case "PLAN1" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', newValue + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN2" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + newValue + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN3" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + newValue + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN4" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + newValue + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN5" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + newValue + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN6" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + newValue + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN7" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + newValue
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN8" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + newValue + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN9" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + newValue + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN10" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + newValue + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN11" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + newValue + record.get('PLAN12')); 
                    break; 
                case "PLAN12" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + newValue); 
                    break;
                break;
                
                case "MOD_PLAN1" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', newValue + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN2" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + newValue + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN3" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + newValue + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN4" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + newValue + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN5" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + newValue + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break;  
                case "MOD_PLAN6" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + newValue + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN7" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + newValue
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN8" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + newValue + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN9" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + newValue + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN10" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + newValue + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN11" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + newValue + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN12" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + newValue); 
                    break; 
                
                case "A_D_RATE1" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', newValue + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE2" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', newValue + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE3" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + newValue + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE4" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + newValue + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE5" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + record.get('A_D_RATE3') + newValue + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE6" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + newValue + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE7" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + newValue + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE8" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + newValue
                                             + newValue + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE9" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + newValue + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE10" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + newValue + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE11" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + newValue + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE12" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + newValue); 
                    break; 
            }
            return rv;
        }
    })
    
    Unilite.createValidator('validator05', {
        store: itemSortMasterStore,
        grid: spokesItemMasterGrid,
        validate: function( type, fieldName, newValue, oldValue, record, eopt) {
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;
            switch(fieldName) {
                case "PLAN_QTY1" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', newValue + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY2" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + newValue + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY3" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + newValue + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY4" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + newValue + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY5" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + newValue + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY6" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + newValue + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY7" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + newValue
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY8" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + newValue + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY9" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + newValue + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY10" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + newValue + record.get('PLAN_QTY11') + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY11" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + newValue + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY12" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + newValue); 
                    break; 
                
                case "PLAN_AMT1" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', newValue + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12')); 
                    break;   
                case "PLAN_AMT2" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + newValue + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12')); 
                    break; 
                case "PLAN_AMT3" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + newValue + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12')); 
                    break; 
                case "PLAN_AMT4" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + newValue + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12')); 
                    break; 
                case "PLAN_AMT5" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + newValue + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12')); 
                    break;  
                case "PLAN_AMT6" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + newValue + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12')); 
                    break;  
                case "PLAN_AMT7" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + newValue
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12')); 
                    break; 
                case "PLAN_AMT8" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + newValue + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12')); 
                    break; 
                case "PLAN_AMT9" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + newValue + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12')); 
                    break; 
                case "PLAN_AMT10" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + newValue + record.get('PLAN_AMT11') + record.get('PLAN_AMT12')); 
                    break; 
                case "PLAN_AMT11" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + newValue + record.get('PLAN_AMT12')); 
                    break; 
                case "PLAN_AMT12" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + newValue); 
                    break; 
                
                case "MOD_PLAN_Q1" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', newValue + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12')); 
                    break;  
                case "MOD_PLAN_Q2" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + newValue + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12')); 
                    break;  
                case "MOD_PLAN_Q3" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + newValue + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12')); 
                    break;  
                case "MOD_PLAN_Q4" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + newValue + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12')); 
                    break;  
                case "MOD_PLAN_Q5" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + newValue + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12')); 
                    break;  
                case "MOD_PLAN_Q6" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + newValue + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12')); 
                    break;  
                case "MOD_PLAN_Q7" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + newValue
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12')); 
                    break;   
                case "MOD_PLAN_Q8" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + newValue + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12')); 
                    break;  
                case "MOD_PLAN_Q9" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + newValue + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12')); 
                    break;  
                case "MOD_PLAN_Q10" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + newValue + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12')); 
                    break;  
                case "MOD_PLAN_Q11" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + newValue + record.get('MOD_PLAN_Q12')); 
                    break;  
                case "MOD_PLAN_Q12" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + newValue); 
                    break;  
                
                case "MOD_PLAN_AMT1" :  
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', newValue + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT2" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + newValue + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT3" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + newValue + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT4" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + newValue + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT5" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + newValue + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT6" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + newValue + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT7" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + newValue
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT8" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + newValue + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT9" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + newValue + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT10" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + newValue + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT11" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + newValue + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT12" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + newValue); 
                    break;  
            }
            return rv;
        }
    })
    
    Unilite.createValidator('validator06', {
        store: customerItemMasterStore,
        grid: customerItemMasterGrid,
        validate: function( type, fieldName, newValue, oldValue, record, eopt) {
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;
            switch(fieldName) {
                case "PLAN_QTY1" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', newValue + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY2" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + newValue + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY3" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + newValue + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY4" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + newValue + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY5" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + newValue + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY6" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + newValue + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY7" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + newValue
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY8" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + newValue + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY9" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + newValue + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY10" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + newValue + record.get('PLAN_QTY11') + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY11" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + newValue + record.get('PLAN_QTY12')); 
                    break; 
                case "PLAN_QTY12" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_Q', record.get('PLAN_QTY1') + record.get('PLAN_QTY2') + record.get('PLAN_QTY3') + record.get('PLAN_QTY4') + record.get('PLAN_QTY5') + record.get('PLAN_QTY6') + record.get('PLAN_QTY7')
                                             + record.get('PLAN_QTY8') + record.get('PLAN_QTY9') + record.get('PLAN_QTY10') + record.get('PLAN_QTY11') + newValue); 
                    break; 
                
                case "PLAN_AMT1" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', newValue + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12')); 
                    break;   
                case "PLAN_AMT2" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + newValue + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12')); 
                    break; 
                case "PLAN_AMT3" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + newValue + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12')); 
                    break; 
                case "PLAN_AMT4" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + newValue + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12')); 
                    break; 
                case "PLAN_AMT5" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + newValue + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12')); 
                    break;  
                case "PLAN_AMT6" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + newValue + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12')); 
                    break;  
                case "PLAN_AMT7" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + newValue
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12')); 
                    break; 
                case "PLAN_AMT8" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + newValue + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12')); 
                    break; 
                case "PLAN_AMT9" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + newValue + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + record.get('PLAN_AMT12')); 
                    break; 
                case "PLAN_AMT10" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + newValue + record.get('PLAN_AMT11') + record.get('PLAN_AMT12')); 
                    break; 
                case "PLAN_AMT11" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + newValue + record.get('PLAN_AMT12')); 
                    break; 
                case "PLAN_AMT12" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM_AMT', record.get('PLAN_AMT1') + record.get('PLAN_AMT2') + record.get('PLAN_AMT3') + record.get('PLAN_AMT4') + record.get('PLAN_AMT5') + record.get('PLAN_AMT6') + record.get('PLAN_AMT7')
                                             + record.get('PLAN_AMT8') + record.get('PLAN_AMT9') + record.get('PLAN_AMT10') + record.get('PLAN_AMT11') + newValue); 
                    break; 
                
                case "MOD_PLAN_Q1" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', newValue + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12')); 
                    break;  
                case "MOD_PLAN_Q2" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + newValue + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12')); 
                    break;  
                case "MOD_PLAN_Q3" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + newValue + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12')); 
                    break;  
                case "MOD_PLAN_Q4" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + newValue + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12')); 
                    break;  
                case "MOD_PLAN_Q5" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + newValue + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12')); 
                    break;  
                case "MOD_PLAN_Q6" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + newValue + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12')); 
                    break;  
                case "MOD_PLAN_Q7" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + newValue
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12')); 
                    break;   
                case "MOD_PLAN_Q8" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + newValue + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12')); 
                    break;  
                case "MOD_PLAN_Q9" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + newValue + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12')); 
                    break;  
                case "MOD_PLAN_Q10" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + newValue + record.get('MOD_PLAN_Q11') + record.get('MOD_PLAN_Q12')); 
                    break;  
                case "MOD_PLAN_Q11" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + newValue + record.get('MOD_PLAN_Q12')); 
                    break;  
                case "MOD_PLAN_Q12" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_Q', record.get('MOD_PLAN_Q1') + record.get('MOD_PLAN_Q2') + record.get('MOD_PLAN_Q3') + record.get('MOD_PLAN_Q4') + record.get('MOD_PLAN_Q5') + record.get('MOD_PLAN_Q6') + record.get('MOD_PLAN_Q7')
                                             + record.get('MOD_PLAN_Q8') + record.get('MOD_PLAN_Q9') + record.get('MOD_PLAN_Q10') + record.get('MOD_PLAN_Q11') + newValue); 
                    break;  
                
                case "MOD_PLAN_AMT1" :  
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', newValue + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT2" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + newValue + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT3" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + newValue + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT4" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + newValue + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT5" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + newValue + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT6" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + newValue + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT7" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + newValue
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT8" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + newValue + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT9" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + newValue + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT10" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + newValue + record.get('MOD_PLAN_AMT11') + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT11" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + newValue + record.get('MOD_PLAN_AMT12')); 
                    break;  
                case "MOD_PLAN_AMT12" :   
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM_AMT', record.get('MOD_PLAN_AMT1') + record.get('MOD_PLAN_AMT2') + record.get('MOD_PLAN_AMT3') + record.get('MOD_PLAN_AMT4') + record.get('MOD_PLAN_AMT5') + record.get('MOD_PLAN_AMT6') + record.get('MOD_PLAN_AMT7')
                                             + record.get('MOD_PLAN_AMT8') + record.get('MOD_PLAN_AMT9') + record.get('MOD_PLAN_AMT10') + record.get('MOD_PLAN_AMT11') + newValue); 
                    break;  
            }
            return rv;
        }
    })
    
    Unilite.createValidator('validator10', {
        store: customitemSortMasterStore,
        grid: customitemSortMasterGrid,
        validate: function( type, fieldName, newValue, oldValue, record, eopt) {
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;
            switch(fieldName) {
                case "PLAN1" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', newValue + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN2" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + newValue + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN3" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + newValue + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN4" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + newValue + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN5" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + newValue + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN6" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + newValue + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN7" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + newValue
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN8" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + newValue + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN9" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + newValue + record.get('PLAN10') + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN10" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + newValue + record.get('PLAN11') + record.get('PLAN12')); 
                    break;
                case "PLAN11" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + newValue + record.get('PLAN12')); 
                    break; 
                case "PLAN12" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('PLAN_SUM', record.get('PLAN1') + record.get('PLAN2') + record.get('PLAN3') + record.get('PLAN4') + record.get('PLAN5') + record.get('PLAN6') + record.get('PLAN7')
                                             + record.get('PLAN8') + record.get('PLAN9') + record.get('PLAN10') + record.get('PLAN11') + newValue); 
                    break;
                break;
                
                case "MOD_PLAN1" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', newValue + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN2" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + newValue + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN3" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + newValue + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN4" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + newValue + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN5" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + newValue + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break;  
                case "MOD_PLAN6" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + newValue + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN7" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + newValue
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN8" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + newValue + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN9" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + newValue + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN10" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + newValue + record.get('MOD_PLAN11') + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN11" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + newValue + record.get('MOD_PLAN12')); 
                    break; 
                case "MOD_PLAN12" :
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('MOD_PLAN_SUM', record.get('MOD_PLAN1') + record.get('MOD_PLAN2') + record.get('MOD_PLAN3') + record.get('MOD_PLAN4') + record.get('MOD_PLAN5') + record.get('MOD_PLAN6') + record.get('MOD_PLAN7')
                                             + record.get('MOD_PLAN8') + record.get('MOD_PLAN9') + record.get('MOD_PLAN10') + record.get('MOD_PLAN11') + newValue); 
                    break; 
                
                case "A_D_RATE1" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', newValue + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE2" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', newValue + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE3" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + newValue + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE4" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + newValue + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE5" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + record.get('A_D_RATE3') + newValue + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE6" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + newValue + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE7" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + newValue + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE8" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + newValue
                                             + newValue + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE9" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + newValue + record.get('A_D_RATE10') + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE10" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + newValue + record.get('A_D_RATE11') + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE11" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + newValue + record.get('A_D_RATE12')); 
                    break;  
                case "A_D_RATE12" : 
                    if(newValue < '0') {
                        Unilite.messageBox('<t:message code="system.message.sales.datacheck017" default="양수를 입력해 주세요."/>');   
                        break;
                    } 
                    record.set('A_D_RATE_SUM', record.get('A_D_RATE1') + record.get('A_D_RATE2') + record.get('A_D_RATE3') + record.get('A_D_RATE4') + record.get('A_D_RATE5') + record.get('A_D_RATE6') + record.get('A_D_RATE7')
                                             + record.get('A_D_RATE8') + record.get('A_D_RATE9') + record.get('A_D_RATE10') + record.get('A_D_RATE11') + newValue); 
                    break; 
            }
            return rv;
        }
    })    
};
</script>