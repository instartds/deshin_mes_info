<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sgp100skrv"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="sgp100skrv"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--매출구분-->
    <t:ExtComboStore comboType="AU" comboCode="B004" /> <!--화폐-->
    <t:ExtComboStore comboType="AU" comboCode="B042" /> <!--계획금액단위-->
    <t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당-->
    <t:ExtComboStore comboType="AU" comboCode="B055" /> <!--고객분류-->
    <t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목계정-->
    <t:ExtComboStore comboType="AU" comboCode="B109" /> <!--유통-->
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--판매유형-->
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />   <!-- 대분류 -->
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />   <!-- 중분류 -->
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />   <!-- 소분류 -->
</t:appConfig>
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>    
<script type="text/javascript" >

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
            read: 'sgp100skrvService.customSelectList'
        }
    });
    
    var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'sgp100skrvService.salePrsnSelectList'
        }
    });
    
    var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'sgp100skrvService.itemSelectList'
        }
    });
    
    var directProxy4 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'sgp100skrvService.itemSortSelectList'
        }
    });
    
    var directProxy5 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'sgp100skrvService.spokesItemSelectList'
        }
    });
    
    var directProxy6 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'sgp100skrvService.customerItemSelectList'
        }
    });
    
    var directProxy7 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'sgp100skrvService.saleTypeSelectList'
        }
    });
    
    var directProxy10 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'sgp100skrvService.customitemSortSelectList'
        }
    });
    
  
    
    /**
     *   Model 정의 
     * @type 
     */
        
    Unilite.defineModel('Sgp100skrvModel1', {
        fields: [{name: 'BIT_CD'                ,text: 'BIT_CD'       ,type:'string'},                
                 {name: 'PLAN_TYPE1'            ,text: 'PLAN_TYPE1'   ,type:'string'},                 
                 {name: 'S_CODE'                ,text: '<t:message code="system.label.sales.custom" default="거래처"/>'         ,type:'string'},
                 {name: 'S_NAME'                ,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'          ,type:'string'},
                 {name: 'ENT_MONEY_UNIT'        ,text: '금액단위'        ,type:'string'},
                 {name: 'MONEY_UNIT'            ,text: '화폐'          ,type:'string'},
                 {name: 'GUBUN'                 ,text: '구분'          ,type:'string'},
                 {name: 'PLAN_SUM'                ,text: '<t:message code="system.label.sales.totalamount" default="합계"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH1'                  ,text: '<t:message code="system.label.sales.january" default="1월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH2'                  ,text: '<t:message code="system.label.sales.february" default="2월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH3'                  ,text: '<t:message code="system.label.sales.march" default="3월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH4'                  ,text: '<t:message code="system.label.sales.april" default="4월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH5'                  ,text: '<t:message code="system.label.sales.may" default="5월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH6'                  ,text: '<t:message code="system.label.sales.june" default="6월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH7'                  ,text: '<t:message code="system.label.sales.july" default="7월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH8'                  ,text: '<t:message code="system.label.sales.august" default="8월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH9'                  ,text: '<t:message code="system.label.sales.september" default="9월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH10'                 ,text: '<t:message code="system.label.sales.october" default="10월"/>'         ,type:'uniPrice'}, 
                 {name: 'MONTH11'                 ,text: '<t:message code="system.label.sales.november" default="11월"/>'         ,type:'uniPrice'}, 
                 {name: 'MONTH12'                 ,text: '<t:message code="system.label.sales.december" default="12월"/>'         ,type:'uniPrice'}
            ]                                          
    });       
    
    Unilite.defineModel('Sgp100skrvModel2', {
        fields: [{name: 'BIT_CD'                ,text: 'BIT_CD'       ,type:'string'},                
                 {name: 'PLAN_TYPE1'            ,text: 'PLAN_TYPE1'   ,type:'string'},                 
                 {name: 'S_CODE'                ,text: '영업담당'        ,type:'string'},
                 {name: 'S_NAME'                ,text: '영업담당'        ,type:'string'},
                 {name: 'ENT_MONEY_UNIT'        ,text: '금액단위'        ,type:'string'},
                 {name: 'MONEY_UNIT'            ,text: '화폐'          ,type:'string'},
                 {name: 'GUBUN'                 ,text: '구분'          ,type:'string'},
                 {name: 'PLAN_SUM'                ,text: '<t:message code="system.label.sales.totalamount" default="합계"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH1'                  ,text: '<t:message code="system.label.sales.january" default="1월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH2'                  ,text: '<t:message code="system.label.sales.february" default="2월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH3'                  ,text: '<t:message code="system.label.sales.march" default="3월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH4'                  ,text: '<t:message code="system.label.sales.april" default="4월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH5'                  ,text: '<t:message code="system.label.sales.may" default="5월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH6'                  ,text: '<t:message code="system.label.sales.june" default="6월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH7'                  ,text: '<t:message code="system.label.sales.july" default="7월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH8'                  ,text: '<t:message code="system.label.sales.august" default="8월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH9'                  ,text: '<t:message code="system.label.sales.september" default="9월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH10'                 ,text: '<t:message code="system.label.sales.october" default="10월"/>'         ,type:'uniPrice'}, 
                 {name: 'MONTH11'                 ,text: '<t:message code="system.label.sales.november" default="11월"/>'         ,type:'uniPrice'}, 
                 {name: 'MONTH12'                 ,text: '<t:message code="system.label.sales.december" default="12월"/>'         ,type:'uniPrice'}
            ] 
    }); 
    
    Unilite.defineModel('Sgp100skrvModel3', {
        fields: [{name: 'BIT_CD'                ,text: 'BIT_CD'       ,type:'string'},                
                 {name: 'PLAN_TYPE1'            ,text: 'PLAN_TYPE1'   ,type:'string'},                 
                 {name: 'S_CODE'                ,text: '품목코드'        ,type:'string'},
                 {name: 'S_NAME'                ,text: '품목명'         ,type:'string'},
                 {name: 'SPEC'                  ,text: '규격'          ,type:'string'},
                 {name: 'ENT_MONEY_UNIT'        ,text: '금액단위'        ,type:'string'},
                 {name: 'MONEY_UNIT'            ,text: '화폐'          ,type:'string'},
                 {name: 'GUBUN'                 ,text: '구분'          ,type:'string'},
                 {name: 'PLAN_SUM'                ,text: '<t:message code="system.label.sales.totalamount" default="합계"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH1'                  ,text: '<t:message code="system.label.sales.january" default="1월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH2'                  ,text: '<t:message code="system.label.sales.february" default="2월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH3'                  ,text: '<t:message code="system.label.sales.march" default="3월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH4'                  ,text: '<t:message code="system.label.sales.april" default="4월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH5'                  ,text: '<t:message code="system.label.sales.may" default="5월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH6'                  ,text: '<t:message code="system.label.sales.june" default="6월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH7'                  ,text: '<t:message code="system.label.sales.july" default="7월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH8'                  ,text: '<t:message code="system.label.sales.august" default="8월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH9'                  ,text: '<t:message code="system.label.sales.september" default="9월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH10'                 ,text: '<t:message code="system.label.sales.october" default="10월"/>'         ,type:'uniPrice'}, 
                 {name: 'MONTH11'                 ,text: '<t:message code="system.label.sales.november" default="11월"/>'         ,type:'uniPrice'}, 
                 {name: 'MONTH12'                 ,text: '<t:message code="system.label.sales.december" default="12월"/>'         ,type:'uniPrice'}
            ] 
    });    
    
    Unilite.defineModel('Sgp100skrvModel4', {
        fields: [{name: 'BIT_CD'                ,text: 'BIT_CD'       ,type:'string'},                
                 {name: 'PLAN_TYPE1'            ,text: 'PLAN_TYPE1'   ,type:'string'},                 
                 {name: 'S_CODE'                ,text: '분류코드'        ,type:'string'},
                 {name: 'S_NAME'                ,text: '분류명'         ,type:'string'},
                 {name: 'ENT_MONEY_UNIT'        ,text: '금액단위'        ,type:'string'},
                 {name: 'MONEY_UNIT'            ,text: '화폐'          ,type:'string'},
                 {name: 'GUBUN'                 ,text: '구분'          ,type:'string'},
                 {name: 'PLAN_SUM'                ,text: '<t:message code="system.label.sales.totalamount" default="합계"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH1'                  ,text: '<t:message code="system.label.sales.january" default="1월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH2'                  ,text: '<t:message code="system.label.sales.february" default="2월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH3'                  ,text: '<t:message code="system.label.sales.march" default="3월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH4'                  ,text: '<t:message code="system.label.sales.april" default="4월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH5'                  ,text: '<t:message code="system.label.sales.may" default="5월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH6'                  ,text: '<t:message code="system.label.sales.june" default="6월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH7'                  ,text: '<t:message code="system.label.sales.july" default="7월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH8'                  ,text: '<t:message code="system.label.sales.august" default="8월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH9'                  ,text: '<t:message code="system.label.sales.september" default="9월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH10'                 ,text: '<t:message code="system.label.sales.october" default="10월"/>'         ,type:'uniPrice'}, 
                 {name: 'MONTH11'                 ,text: '<t:message code="system.label.sales.november" default="11월"/>'         ,type:'uniPrice'}, 
                 {name: 'MONTH12'                 ,text: '<t:message code="system.label.sales.december" default="12월"/>'         ,type:'uniPrice'}
            ] 
    });        
    
    Unilite.defineModel('Sgp100skrvModel5', {
        fields: [{name: 'BIT_CD'                ,text: 'BIT_CD'       ,type:'string'},                
                 {name: 'PLAN_TYPE1'            ,text: 'PLAN_TYPE1'   ,type:'string'},                 
                 {name: 'S_CODE'                ,text: '대표모델코드'        ,type:'string'},
                 {name: 'S_NAME'                ,text: '대표모델명'         ,type:'string'},
                 {name: 'SPEC'                  ,text: '규격'          ,type:'string'},
                 {name: 'ENT_MONEY_UNIT'        ,text: '금액단위'        ,type:'string'},
                 {name: 'MONEY_UNIT'            ,text: '화폐'          ,type:'string'},
                 {name: 'GUBUN'                 ,text: '구분'          ,type:'string'},
                 {name: 'PLAN_SUM'                ,text: '<t:message code="system.label.sales.totalamount" default="합계"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH1'                  ,text: '<t:message code="system.label.sales.january" default="1월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH2'                  ,text: '<t:message code="system.label.sales.february" default="2월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH3'                  ,text: '<t:message code="system.label.sales.march" default="3월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH4'                  ,text: '<t:message code="system.label.sales.april" default="4월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH5'                  ,text: '<t:message code="system.label.sales.may" default="5월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH6'                  ,text: '<t:message code="system.label.sales.june" default="6월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH7'                  ,text: '<t:message code="system.label.sales.july" default="7월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH8'                  ,text: '<t:message code="system.label.sales.august" default="8월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH9'                  ,text: '<t:message code="system.label.sales.september" default="9월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH10'                 ,text: '<t:message code="system.label.sales.october" default="10월"/>'         ,type:'uniPrice'}, 
                 {name: 'MONTH11'                 ,text: '<t:message code="system.label.sales.november" default="11월"/>'         ,type:'uniPrice'}, 
                 {name: 'MONTH12'                 ,text: '<t:message code="system.label.sales.december" default="12월"/>'         ,type:'uniPrice'}
            ] 
    });        
    
    Unilite.defineModel('Sgp100skrvModel6', {
        fields: [{name: 'BIT_CD'                ,text: 'BIT_CD'       ,type:'string'},                
                 {name: 'PLAN_TYPE1'            ,text: 'PLAN_TYPE1'   ,type:'string'},                 
                 {name: 'S_CODE'                ,text: '거래처코드'        ,type:'string'},
                 {name: 'S_NAME'                ,text: '거래처명'         ,type:'string'},
                 {name: 'S_CODE2'               ,text: '품목코드'        ,type:'string'},
                 {name: 'S_NAME2'               ,text: '품목명'         ,type:'string'},                 
                 {name: 'SPEC'                  ,text: '규격'          ,type:'string'},
                 {name: 'ENT_MONEY_UNIT'        ,text: '금액단위'        ,type:'string'},
                 {name: 'MONEY_UNIT'            ,text: '화폐'          ,type:'string'},
                 {name: 'GUBUN'                 ,text: '구분'          ,type:'string'},
                 {name: 'PLAN_SUM'                ,text: '<t:message code="system.label.sales.totalamount" default="합계"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH1'                  ,text: '<t:message code="system.label.sales.january" default="1월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH2'                  ,text: '<t:message code="system.label.sales.february" default="2월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH3'                  ,text: '<t:message code="system.label.sales.march" default="3월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH4'                  ,text: '<t:message code="system.label.sales.april" default="4월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH5'                  ,text: '<t:message code="system.label.sales.may" default="5월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH6'                  ,text: '<t:message code="system.label.sales.june" default="6월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH7'                  ,text: '<t:message code="system.label.sales.july" default="7월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH8'                  ,text: '<t:message code="system.label.sales.august" default="8월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH9'                  ,text: '<t:message code="system.label.sales.september" default="9월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH10'                 ,text: '<t:message code="system.label.sales.october" default="10월"/>'         ,type:'uniPrice'}, 
                 {name: 'MONTH11'                 ,text: '<t:message code="system.label.sales.november" default="11월"/>'         ,type:'uniPrice'}, 
                 {name: 'MONTH12'                 ,text: '<t:message code="system.label.sales.december" default="12월"/>'         ,type:'uniPrice'}
            ] 
    }); 
    
    Unilite.defineModel('Sgp100skrvModel7', {
        fields: [{name: 'BIT_CD'                  ,text: 'BIT_CD'        ,type:'string'}, 
                 {name: 'PLAN_TYPE1'              ,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'        ,type:'string'/*, comboType: "AU", comboCode:"S002"*/},
                 {name: 'PLAN_TYPE1_VIEW'         ,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'        ,type:'string'/*, comboType: "AU", comboCode:"S002"*/},
                 {name: 'ENT_MONEY_UNIT'          ,text: '<t:message code="system.label.sales.amountunit" default="금액단위"/>'        ,type:'string', comboType:"AU", comboCode:"B042"}, 
                 {name: 'MONEY_UNIT'              ,text: '<t:message code="system.label.sales.currency" default="화폐"/>'          ,type:'string'}, 
                 {name: 'CONFIRM_YN'              ,text: 'CONFIRM_YN'   ,type:'string'}, 
                 {name: 'GUBUN'                   ,text: '<t:message code="system.label.sales.classfication" default="구분"/>'          ,type:'string'}, 
                 {name: 'PLAN_SUM'                ,text: '<t:message code="system.label.sales.totalamount" default="합계"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH1'                  ,text: '<t:message code="system.label.sales.january" default="1월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH2'                  ,text: '<t:message code="system.label.sales.february" default="2월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH3'                  ,text: '<t:message code="system.label.sales.march" default="3월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH4'                  ,text: '<t:message code="system.label.sales.april" default="4월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH5'                  ,text: '<t:message code="system.label.sales.may" default="5월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH6'                  ,text: '<t:message code="system.label.sales.june" default="6월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH7'                  ,text: '<t:message code="system.label.sales.july" default="7월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH8'                  ,text: '<t:message code="system.label.sales.august" default="8월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH9'                  ,text: '<t:message code="system.label.sales.september" default="9월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH10'                 ,text: '<t:message code="system.label.sales.october" default="10월"/>'         ,type:'uniPrice'}, 
                 {name: 'MONTH11'                 ,text: '<t:message code="system.label.sales.november" default="11월"/>'         ,type:'uniPrice'}, 
                 {name: 'MONTH12'                 ,text: '<t:message code="system.label.sales.december" default="12월"/>'         ,type:'uniPrice'}
            ]
    });  
    
    Unilite.defineModel('Sgp100skrvModel10', {
        fields: [{name: 'BIT_CD'                ,text: 'BIT_CD'       ,type:'string'},                
                 {name: 'PLAN_TYPE1'            ,text: 'PLAN_TYPE1'   ,type:'string'},    
                 {name: 'S_CODE'                ,text: '거래처코드'        ,type:'string'},
                 {name: 'S_NAME'                ,text: '거래처명'         ,type:'string'},                 
                 {name: 'S_CODE2'               ,text: '분류코드'        ,type:'string'},
                 {name: 'S_NAME2'               ,text: '분류명'         ,type:'string'},
                 {name: 'ENT_MONEY_UNIT'        ,text: '금액단위'        ,type:'string'},
                 {name: 'MONEY_UNIT'            ,text: '화폐'          ,type:'string'},
                 {name: 'GUBUN'                 ,text: '구분'          ,type:'string'},
                 {name: 'PLAN_SUM'                ,text: '<t:message code="system.label.sales.totalamount" default="합계"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH1'                  ,text: '<t:message code="system.label.sales.january" default="1월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH2'                  ,text: '<t:message code="system.label.sales.february" default="2월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH3'                  ,text: '<t:message code="system.label.sales.march" default="3월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH4'                  ,text: '<t:message code="system.label.sales.april" default="4월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH5'                  ,text: '<t:message code="system.label.sales.may" default="5월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH6'                  ,text: '<t:message code="system.label.sales.june" default="6월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH7'                  ,text: '<t:message code="system.label.sales.july" default="7월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH8'                  ,text: '<t:message code="system.label.sales.august" default="8월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH9'                  ,text: '<t:message code="system.label.sales.september" default="9월"/>'          ,type:'uniPrice'}, 
                 {name: 'MONTH10'                 ,text: '<t:message code="system.label.sales.october" default="10월"/>'         ,type:'uniPrice'}, 
                 {name: 'MONTH11'                 ,text: '<t:message code="system.label.sales.november" default="11월"/>'         ,type:'uniPrice'}, 
                 {name: 'MONTH12'                 ,text: '<t:message code="system.label.sales.december" default="12월"/>'         ,type:'uniPrice'}
            ] 
    });      
      
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var customMasterStore = Unilite.createStore('sgp100skrvMasterStore1',{
        model: 'Sgp100skrvModel1',
        uniOpt : {
            isMaster: false,         // 상위 버튼 연결 
            editable: false,         // 수정 모드 사용 
            deletable:false,         // 삭제 가능 여부  
            useNavi : false         // prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {   
            var param= panelSearch.getValues();
            param.AGENT_TYPE = customSubForm.getValue('AGENT_TYPE'); 
            param.PRCENT_FR = customSubForm.getValue('PRCENT_FR'); 
            param.PRCENT_TO = customSubForm.getValue('PRCENT_TO');
            console.log( param );
            this.load({
                params : param
            });         
        }
    });
    
    var salePrsnMasterStore = Unilite.createStore('sgp100skrvMasterStore2',{
        model: 'Sgp100skrvModel2',
        uniOpt : {
            isMaster: false,         // 상위 버튼 연결 
            editable: false,         // 수정 모드 사용 
            deletable:false,         // 삭제 가능 여부 
            useNavi : false         // prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy2,
        loadStoreRecords : function()   {   
            var param= panelSearch.getValues();
            param.SALE_PRSN = salePrsnSubForm.getValue('SALE_PRSN'); 
            param.PRCENT_FR = salePrsnSubForm.getValue('PRCENT_FR'); 
            param.PRCENT_TO = salePrsnSubForm.getValue('PRCENT_TO');            
            this.load({
                  params : param
            });         
        }
    });
    
    var itemMasterStore = Unilite.createStore('sgp100skrvMasterStore3',{
        model: 'Sgp100skrvModel3',
        uniOpt : {
            isMaster: false,         // 상위 버튼 연결 
            editable: false,         // 수정 모드 사용 
            deletable:false,         // 삭제 가능 여부 
            useNavi : false         // prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy3,
        loadStoreRecords : function()   { 
            var param= panelSearch.getValues();
            param.ITEM_ACCOUNT = itemSubForm.getValue('ITEM_ACCOUNT');
            param.ITEM_CODE_FR = itemSubForm.getValue('ITEM_CODE_FR');
            param.ITEM_CODE_TO = itemSubForm.getValue('ITEM_CODE_TO');
            param.ITEM_NAME_FR = itemSubForm.getValue('ITEM_NAME_FR');
            param.ITEM_NAME_TO = itemSubForm.getValue('ITEM_NAME_TO');
            param.PRCENT_FR = itemSubForm.getValue('PRCENT_FR'); 
            param.PRCENT_TO = itemSubForm.getValue('PRCENT_TO');  
            param.GUBUN = Ext.getCmp('GUBUN_ID').getChecked()[0].inputValue;
            
            this.load({
                  params : param
            });         
        }
    });
    
    var itemSortMasterStore = Unilite.createStore('sgp100skrvMasterStore4',{
        model: 'Sgp100skrvModel4',
        uniOpt : {
            isMaster: false,         // 상위 버튼 연결 
            editable: false,         // 수정 모드 사용 
            deletable:false,         // 삭제 가능 여부 
            useNavi : false         // prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy4,
        loadStoreRecords : function()   {   
        /*  var param= Ext.getCmp('searchForm').getValues();            
            console.log( param );
            this.load({
                params : param*/
            var param= panelSearch.getValues();
            param.ITEM_LEVEL = Ext.getCmp('ITEM_LEVEL_ID').getChecked()[0].inputValue;
            param.ITEM_LEVEL1 = itemSortSubForm.getValue('ITEM_LEVEL1'); 
            param.ITEM_LEVEL2 = itemSortSubForm.getValue('ITEM_LEVEL2'); 
            param.ITEM_LEVEL3 = itemSortSubForm.getValue('ITEM_LEVEL3'); 
            param.PRCENT_FR = itemSortSubForm.getValue('PRCENT_FR'); 
            param.PRCENT_TO = itemSortSubForm.getValue('PRCENT_TO');             
            this.load({
                  params : param
            });         
        }
    });
    
    var spokesItemMasterStore = Unilite.createStore('sgp100skrvMasterStore5',{
        model: 'Sgp100skrvModel5',
        uniOpt : {
            isMaster: false,         // 상위 버튼 연결 
            editable: false,         // 수정 모드 사용 
            deletable:false,         // 삭제 가능 여부 
            useNavi : false         // prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy5,
        loadStoreRecords : function()   {
            var param= panelSearch.getValues();
            param.ITEM_ACCOUNT = spokesItemSubForm.getValue('ITEM_ACCOUNT');
            param.PRCENT_FR = spokesItemSubForm.getValue('PRCENT_FR'); 
            param.PRCENT_TO = spokesItemSubForm.getValue('PRCENT_TO');              
            this.load({
                  params : param
            });         
        }
    });
    
    var customerItemMasterStore = Unilite.createStore('sgp100skrvMasterStore6',{
        model: 'Sgp100skrvModel6',
        uniOpt : {
            isMaster: false,         // 상위 버튼 연결 
            editable: false,         // 수정 모드 사용 
            deletable:false,         // 삭제 가능 여부 
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
            param.PRCENT_FR = customerItemSubForm.getValue('PRCENT_FR'); 
            param.PRCENT_TO = customerItemSubForm.getValue('PRCENT_TO');            
            this.load({
                  params : param
            });         
        }
    });
    
    var saleTypeStore = Unilite.createStore('sgp100skrvMasterStore7',{
        model: 'Sgp100skrvModel7',
        uniOpt : {
            isMaster: false,         // 상위 버튼 연결 
            editable: false,         // 수정 모드 사용 
            deletable:false,         // 삭제 가능 여부 
            useNavi : false         // prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy7,
        loadStoreRecords : function()   {   
            var param= panelSearch.getValues();
            this.load({
                  params : param
            });         
        }
    });
    
    var customitemSortMasterStore = Unilite.createStore('sgp100skrvMasterStore10',{
        model: 'Sgp100skrvModel10',
        uniOpt : {
            isMaster: false,         // 상위 버튼 연결 
            editable: false,         // 수정 모드 사용 
            deletable:false,         // 삭제 가능 여부 
            useNavi : false         // prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy10,
        loadStoreRecords : function()   {   
        /*  var param= Ext.getCmp('searchForm').getValues();            
            console.log( param );
            this.load({
                params : param*/
            var param= panelSearch.getValues();
            param.ITEM_LEVEL = Ext.getCmp('CUSTOM_ITEM_LEVEL_ID').getChecked()[0].inputValue;
            param.ITEM_LEVEL1 = customitemSortSubForm.getValue('ITEM_LEVEL1'); 
            param.ITEM_LEVEL2 = customitemSortSubForm.getValue('ITEM_LEVEL2'); 
            param.ITEM_LEVEL3 = customitemSortSubForm.getValue('ITEM_LEVEL3'); 
            param.PRCENT_FR = customitemSortSubForm.getValue('PRCENT_FR'); 
            param.PRCENT_TO = customitemSortSubForm.getValue('PRCENT_TO');             
            this.load({
                  params : param
            });         
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
                xtype: 'radiogroup',
                fieldLabel: '<t:message code="system.label.sales.planselection" default="계획선택"/>',
                items : [{
                    boxLabel: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>',
                    name: 'PLAN_GUBUN' ,
                    inputValue: '2',
                    width: 80
                }, {
                    boxLabel: '<t:message code="system.label.sales.yearplan" default="년초계획"/>',
                    name: 'PLAN_GUBUN' ,
                    inputValue: '1',
                    checked: true,
                    width: 100
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                    	panelResult.getField('PLAN_GUBUN').setValue(newValue.PLAN_GUBUN);
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

                    Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
                    invalid.items[0].focus();
                } else {
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
        layout : {type : 'uniTable', columns : 3, tableAttrs: {width: '55%'}},
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
            xtype: 'radiogroup',
            fieldLabel: '<t:message code="system.label.sales.planselection" default="계획선택"/>',
            items : [{
                boxLabel: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>',
                name: 'PLAN_GUBUN' ,
                inputValue: '2', 
                width:80
            }, {
                boxLabel: '<t:message code="system.label.sales.yearplan" default="년초계획"/>',
                name: 'PLAN_GUBUN' ,
                inputValue: '1',
                checked: true,
                width:100
            }],
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                	panelSearch.getField('PLAN_GUBUN').setValue(newValue.PLAN_GUBUN);
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

                    invalid.items[0].focus();
                } else {
                    //this.mask();

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
            comboCode:'B055'
//            value: '1'
        },{
            xtype: 'container',
            defaultType: 'uniNumberfield',
            layout: {type: 'hbox', align:'stretch'},
            width:325,
            margin:0,
            items:[{
                fieldLabel:'<t:message code="system.label.sales.accompratepercent" default="달성율(%)"/>',
                suffixTpl:'&nbsp; <t:message code="system.label.sales.over" default="이상"/> ~&nbsp;',
                name: 'PRCENT_FR',
                width:218
            }, {
                name: 'PRCENT_TO',
                width:107,
                suffixTpl:'&nbsp; <t:message code="system.label.sales.below" default="이하"/> &nbsp;'
            }]
        }]           
    });
    
     var salePrsnSubForm = Unilite.createSearchForm('salePrsnSubForm',{                      
        padding: '0 0 0 0',
        layout:{type:'uniTable', columns: '2'},
        items: [{
            fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
            name:'SALE_PRSN',  
            xtype: 'uniCombobox', 
            comboType:'AU',
            comboCode:'S010'
        },{
            xtype: 'container',
            defaultType: 'uniNumberfield',
            layout: {type: 'hbox', align:'stretch'},
            width:325,
            margin:0,
            items:[{
                fieldLabel:'<t:message code="system.label.sales.accompratepercent" default="달성율(%)"/>',
                suffixTpl:'&nbsp; <t:message code="system.label.sales.over" default="이상"/> ~&nbsp;',
                name: 'PRCENT_FR',
                width:218
            }, {
                name: 'PRCENT_TO',
                width:107,
                suffixTpl:'&nbsp; <t:message code="system.label.sales.below" default="이하"/> &nbsp;'
            }]
        }]           
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
            comboCode:'B020'
        },{
            xtype: 'container',
            defaultType: 'uniNumberfield',
            layout: {type: 'hbox', align:'stretch'},
            width:325,
            margin:0,
            items:[{
                fieldLabel:'<t:message code="system.label.sales.accompratepercent" default="달성율(%)"/>',
                suffixTpl:'&nbsp; <t:message code="system.label.sales.over" default="이상"/> ~&nbsp;',
                name: 'PRCENT_FR',
                width:218
            }, {
                name: 'PRCENT_TO',
                width:107,
                suffixTpl:'&nbsp; <t:message code="system.label.sales.below" default="이하"/> &nbsp;'
            }]
        },          
            Unilite.popup('DIV_PUMOK',{ 
                    fieldLabel : '<t:message code="system.label.sales.item" default="품목"/>',
                    valueFieldName : 'ITEM_CODE_FR', 
                    textFieldName : 'ITEM_NAME_FR',
                    validateBlank : false,
                    listeners : {
						onValueFieldChange: function(field, newValue, oldValue){
							if(!Ext.isObject(oldValue)) {
								itemSubForm.setValue('ITEM_NAME_FR', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							if(!Ext.isObject(oldValue)) {
								itemSubForm.setValue('ITEM_CODE_FR', '');
							}
						},
                        applyextparam: function(popup){ 
                            popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                            popup.setExtParam({'ITEM_ACCOUNT_FILTER': ['00','10','40']});
                        }
                    }
         }),{
            xtype: 'radiogroup',
            fieldLabel: ' ',
            id: 'GUBUN_ID',
            items : [{
                boxLabel: '<t:message code="system.label.sales.amount" default="금액"/>',
                name: 'GUBUN' ,
                inputValue: '1',                        
                checked: true,
                width:60
            }, {
                boxLabel: '<t:message code="system.label.sales.qty" default="수량"/>',
                name: 'GUBUN' ,
                inputValue: '2',
                width:60
            }],
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                }
            }        
         	
         },          
            Unilite.popup('DIV_PUMOK',{ 
                fieldLabel: '~',
                valueFieldName : 'ITEM_CODE_TO', 
                textFieldName : 'ITEM_NAME_TO',
                validateBlank : false,
                listeners : {
					onValueFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							itemSubForm.setValue('ITEM_NAME_TO', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							itemSubForm.setValue('ITEM_CODE_TO', '');
						}
					},
                    applyextparam: function(popup){ 
                        popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                        popup.setExtParam({'ITEM_ACCOUNT_FILTER': ['00','10','40']});           
                    }
                }
     		})]           
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
                        UniAppManager.app.setHiddenColumn();  
                    }
                }
            },{
                name: 'ITEM_LEVEL1',
                fieldLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
                xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('itemLeve1Store')
              },{
                xtype: 'container',
                defaultType: 'uniNumberfield',
                layout: {type: 'hbox', align:'stretch'},
                width:325,
                margin:0,
                items:[{
                    fieldLabel:'<t:message code="system.label.sales.accompratepercent" default="달성율(%)"/>',
                    suffixTpl:'&nbsp; <t:message code="system.label.sales.over" default="이상"/> ~&nbsp;',
                    name: 'PRCENT_FR',
                    width:218
                }, {
                    name: 'PRCENT_TO',
                    width:107,
                    suffixTpl:'&nbsp; <t:message code="system.label.sales.below" default="이하"/> &nbsp;'
                }]
              },{
                name: 'ITEM_LEVEL2',
                fieldLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
                xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('itemLeve2Store'),
                disabled: true
                
             },{
                xtype: 'component'
             },{
                name: 'ITEM_LEVEL3',
                fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
                xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('itemLeve3Store'),
                disabled: true
            }]           
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
                comboCode:'B020'
            },{
            xtype: 'container',
            defaultType: 'uniNumberfield',
            layout: {type: 'hbox', align:'stretch'},
            width:325,
            margin:0,
            items:[{
                fieldLabel:'<t:message code="system.label.sales.accompratepercent" default="달성율(%)"/>',
                suffixTpl:'&nbsp; <t:message code="system.label.sales.over" default="이상"/> ~&nbsp;',
                name: 'PRCENT_FR',
                width:218
            }, {
                name: 'PRCENT_TO',
                width:107,
                suffixTpl:'&nbsp; <t:message code="system.label.sales.below" default="이하"/> &nbsp;'
            }]
        }]           
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
            comboCode:'B055'
//            value: '1'
        },{
            xtype: 'container',
            defaultType: 'uniNumberfield',
            layout: {type: 'hbox', align:'stretch'},
            width:325,
            margin:0,
            items:[{
                fieldLabel:'<t:message code="system.label.sales.accompratepercent" default="달성율(%)"/>',
                suffixTpl:'&nbsp; <t:message code="system.label.sales.over" default="이상"/> ~&nbsp;',
                name: 'PRCENT_FR',
                width:218
            }, {
                name: 'PRCENT_TO',
                width:107,
                suffixTpl:'&nbsp; <t:message code="system.label.sales.below" default="이하"/> &nbsp;'
            }]
        }]           
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
                        UniAppManager.app.setHiddenColumn();  
                    }
                }
            },{
                name: 'ITEM_LEVEL1',
                fieldLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
                xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('itemLeve1Store')
              },{
                xtype: 'container',
                defaultType: 'uniNumberfield',
                layout: {type: 'hbox', align:'stretch'},
                width:325,
                margin:0,
                items:[{
                    fieldLabel:'<t:message code="system.label.sales.accompratepercent" default="달성율(%)"/>',
                    suffixTpl:'&nbsp; <t:message code="system.label.sales.over" default="이상"/> ~&nbsp;',
                    name: 'PRCENT_FR',
                    width:218
                }, {
                    name: 'PRCENT_TO',
                    width:107,
                    suffixTpl:'&nbsp; <t:message code="system.label.sales.below" default="이하"/> &nbsp;'
                }]
              },{
                name: 'ITEM_LEVEL2',
                fieldLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
                xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('itemLeve2Store'),
                disabled: true
                
             },{
                xtype: 'component'
             },{
                name: 'ITEM_LEVEL3',
                fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
                xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('itemLeve3Store'),
                disabled: true
            }]           
        });
                
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */

    var customMasterGrid = Unilite.createGrid('sgp100skrvCustomMasterGrid', {
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
        columns:  [{ dataIndex: 'BIT_CD'              ,           width:86, hidden: true }
                  ,{ dataIndex: 'PLAN_TYPE1'          ,           width:86, hidden: true }
                  ,{ dataIndex: 'S_CODE'              ,           width:80}
                  ,{ dataIndex: 'S_NAME'              ,           width:150}
                  ,{ dataIndex: 'ENT_MONEY_UNIT'      ,           width:80}
                  ,{ dataIndex: 'MONEY_UNIT'          ,           width:80}
                  ,{ dataIndex: 'GUBUN'               ,           width:80}
                  ,{ dataIndex: 'PLAN_SUM'            ,           width:100}
                  ,{ dataIndex: 'MONTH1'              ,           width:100}
                  ,{ dataIndex: 'MONTH2'              ,           width:100}
                  ,{ dataIndex: 'MONTH3'              ,           width:100}
                  ,{ dataIndex: 'MONTH4'              ,           width:100}
                  ,{ dataIndex: 'MONTH5'              ,           width:100}
                  ,{ dataIndex: 'MONTH6'              ,           width:100}
                  ,{ dataIndex: 'MONTH7'              ,           width:100}
                  ,{ dataIndex: 'MONTH8'              ,           width:100}
                  ,{ dataIndex: 'MONTH9'              ,           width:100}
                  ,{ dataIndex: 'MONTH10'             ,           width:100}
                  ,{ dataIndex: 'MONTH11'             ,           width:100}
                  ,{ dataIndex: 'MONTH12'             ,           width:100}
                  
          ],
        viewConfig: {
            getRowClass: function(record, rowIndex, rowParams, store){
                var cls = '';
                
                if(record.get('BIT_CD') == '3'){
                    cls = 'x-change-cell_light';
                }
                else if(record.get('BIT_CD') == '5' || record.get('BIT_CD') == '6' || record.get('BIT_CD') == '7'){
                    cls = 'x-change-cell_normal';
                }else{
                    cls = 'x-change-cell_white';
                }
                return cls;
            }
        }          
    });
    
    var activeGrid = customMasterGrid;
    
    var salePrsnMasterGrid = Unilite.createGrid('sgp100skrvSalePrsnMasterGrid', { 
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
        columns:  [{ dataIndex: 'BIT_CD'              ,           width:86, hidden: true }
                  ,{ dataIndex: 'PLAN_TYPE1'          ,           width:86, hidden: true }
                  ,{ dataIndex: 'S_CODE'              ,           width:80, hidden: true }
                  ,{ dataIndex: 'S_NAME'              ,           width:100}
                  ,{ dataIndex: 'ENT_MONEY_UNIT'      ,           width:80}
                  ,{ dataIndex: 'MONEY_UNIT'          ,           width:80}
                  ,{ dataIndex: 'GUBUN'               ,           width:80}
                  ,{ dataIndex: 'PLAN_SUM'            ,           width:100}
                  ,{ dataIndex: 'MONTH1'              ,           width:100}
                  ,{ dataIndex: 'MONTH2'              ,           width:100}
                  ,{ dataIndex: 'MONTH3'              ,           width:100}
                  ,{ dataIndex: 'MONTH4'              ,           width:100}
                  ,{ dataIndex: 'MONTH5'              ,           width:100}
                  ,{ dataIndex: 'MONTH6'              ,           width:100}
                  ,{ dataIndex: 'MONTH7'              ,           width:100}
                  ,{ dataIndex: 'MONTH8'              ,           width:100}
                  ,{ dataIndex: 'MONTH9'              ,           width:100}
                  ,{ dataIndex: 'MONTH10'             ,           width:100}
                  ,{ dataIndex: 'MONTH11'             ,           width:100}
                  ,{ dataIndex: 'MONTH12'             ,           width:100}
                  
          ],
        viewConfig: {
            getRowClass: function(record, rowIndex, rowParams, store){
                var cls = '';
                
                if(record.get('BIT_CD') == '3'){
                    cls = 'x-change-cell_light';
                }
                else if(record.get('BIT_CD') == '5' || record.get('BIT_CD') == '6' || record.get('BIT_CD') == '7'){
                    cls = 'x-change-cell_normal';
                }else{
                    cls = 'x-change-cell_white';
                }
                return cls;
            }
        }          
    });
    
    var itemMasterGrid = Unilite.createGrid('sgp100skrvItemMasterGrid', { 
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
        columns:  [{ dataIndex: 'BIT_CD'              ,           width:86, hidden: true }
                  ,{ dataIndex: 'PLAN_TYPE1'          ,           width:86, hidden: true }
                  ,{ dataIndex: 'S_CODE'              ,           width:100}
                  ,{ dataIndex: 'S_NAME'              ,           width:120}
                  ,{ dataIndex: 'SPEC'                ,           width:130}
                  ,{ dataIndex: 'ENT_MONEY_UNIT'      ,           width:80}
                  ,{ dataIndex: 'MONEY_UNIT'          ,           width:80}
                  ,{ dataIndex: 'GUBUN'               ,           width:80}
                  ,{ dataIndex: 'PLAN_SUM'            ,           width:100}
                  ,{ dataIndex: 'MONTH1'              ,           width:100}
                  ,{ dataIndex: 'MONTH2'              ,           width:100}
                  ,{ dataIndex: 'MONTH3'              ,           width:100}
                  ,{ dataIndex: 'MONTH4'              ,           width:100}
                  ,{ dataIndex: 'MONTH5'              ,           width:100}
                  ,{ dataIndex: 'MONTH6'              ,           width:100}
                  ,{ dataIndex: 'MONTH7'              ,           width:100}
                  ,{ dataIndex: 'MONTH8'              ,           width:100}
                  ,{ dataIndex: 'MONTH9'              ,           width:100}
                  ,{ dataIndex: 'MONTH10'             ,           width:100}
                  ,{ dataIndex: 'MONTH11'             ,           width:100}
                  ,{ dataIndex: 'MONTH12'             ,           width:100}
                  
          ],
        viewConfig: {
            getRowClass: function(record, rowIndex, rowParams, store){
                var cls = '';
                
                if(record.get('BIT_CD') == '3'){
                    cls = 'x-change-cell_light';
                }
                else if(record.get('BIT_CD') == '5' || record.get('BIT_CD') == '6' || record.get('BIT_CD') == '7'){
                    cls = 'x-change-cell_normal';
                }else{
                    cls = 'x-change-cell_white';
                }
                return cls;
            }
        } 
    });
    
    var itemSortMasterGrid = Unilite.createGrid('sgp100skrvItemSortMasterGrid', { 
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
        columns:  [{ dataIndex: 'BIT_CD'              ,           width:86, hidden: true }
                  ,{ dataIndex: 'PLAN_TYPE1'          ,           width:86, hidden: true }
                  ,{ dataIndex: 'S_CODE'              ,           width:100}
                  ,{ dataIndex: 'S_NAME'              ,           width:120}
                  ,{ dataIndex: 'ENT_MONEY_UNIT'      ,           width:80}
                  ,{ dataIndex: 'MONEY_UNIT'          ,           width:80}
                  ,{ dataIndex: 'GUBUN'               ,           width:80}
                  ,{ dataIndex: 'PLAN_SUM'            ,           width:100}
                  ,{ dataIndex: 'MONTH1'              ,           width:100}
                  ,{ dataIndex: 'MONTH2'              ,           width:100}
                  ,{ dataIndex: 'MONTH3'              ,           width:100}
                  ,{ dataIndex: 'MONTH4'              ,           width:100}
                  ,{ dataIndex: 'MONTH5'              ,           width:100}
                  ,{ dataIndex: 'MONTH6'              ,           width:100}
                  ,{ dataIndex: 'MONTH7'              ,           width:100}
                  ,{ dataIndex: 'MONTH8'              ,           width:100}
                  ,{ dataIndex: 'MONTH9'              ,           width:100}
                  ,{ dataIndex: 'MONTH10'             ,           width:100}
                  ,{ dataIndex: 'MONTH11'             ,           width:100}
                  ,{ dataIndex: 'MONTH12'             ,           width:100}
                  
          ],
        viewConfig: {
            getRowClass: function(record, rowIndex, rowParams, store){
                var cls = '';
                
                if(record.get('BIT_CD') == '3'){
                    cls = 'x-change-cell_light';
                }
                else if(record.get('BIT_CD') == '5' || record.get('BIT_CD') == '6' || record.get('BIT_CD') == '7'){
                    cls = 'x-change-cell_normal';
                }else{
                    cls = 'x-change-cell_white';
                }
                return cls;
            }
        }
    });
    
    var spokesItemMasterGrid = Unilite.createGrid('sgp100skrvSpokesItemMasterGrid', { 
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
        columns:  [{ dataIndex: 'BIT_CD'              ,           width:86, hidden: true }
                  ,{ dataIndex: 'PLAN_TYPE1'          ,           width:86, hidden: true }
                  ,{ dataIndex: 'S_CODE'              ,           width:100}
                  ,{ dataIndex: 'S_NAME'              ,           width:120}
                  ,{ dataIndex: 'SPEC'                ,           width:130}
                  ,{ dataIndex: 'ENT_MONEY_UNIT'      ,           width:80}
                  ,{ dataIndex: 'MONEY_UNIT'          ,           width:80}
                  ,{ dataIndex: 'GUBUN'               ,           width:80}
                  ,{ dataIndex: 'PLAN_SUM'            ,           width:100}
                  ,{ dataIndex: 'MONTH1'              ,           width:100}
                  ,{ dataIndex: 'MONTH2'              ,           width:100}
                  ,{ dataIndex: 'MONTH3'              ,           width:100}
                  ,{ dataIndex: 'MONTH4'              ,           width:100}
                  ,{ dataIndex: 'MONTH5'              ,           width:100}
                  ,{ dataIndex: 'MONTH6'              ,           width:100}
                  ,{ dataIndex: 'MONTH7'              ,           width:100}
                  ,{ dataIndex: 'MONTH8'              ,           width:100}
                  ,{ dataIndex: 'MONTH9'              ,           width:100}
                  ,{ dataIndex: 'MONTH10'             ,           width:100}
                  ,{ dataIndex: 'MONTH11'             ,           width:100}
                  ,{ dataIndex: 'MONTH12'             ,           width:100}
                  
          ],
        viewConfig: {
            getRowClass: function(record, rowIndex, rowParams, store){
                var cls = '';
                
                if(record.get('BIT_CD') == '3'){
                    cls = 'x-change-cell_light';
                }
                else if(record.get('BIT_CD') == '5' || record.get('BIT_CD') == '6' || record.get('BIT_CD') == '7'){
                    cls = 'x-change-cell_normal';
                }else{
                    cls = 'x-change-cell_white';
                }
                return cls;
            }
        }
    });
    
    var customerItemMasterGrid = Unilite.createGrid('sgp100skrvCustomerItemMasterGrid', { 
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
        columns:  [{ dataIndex: 'BIT_CD'              ,           width:86, hidden: true }
                  ,{ dataIndex: 'PLAN_TYPE1'          ,           width:86, hidden: true }
                  ,{ dataIndex: 'S_CODE'              ,           width:100}
                  ,{ dataIndex: 'S_NAME'              ,           width:120}                  
                  ,{ dataIndex: 'S_CODE2'             ,           width:100}
                  ,{ dataIndex: 'S_NAME2'             ,           width:120}
                  ,{ dataIndex: 'SPEC'                ,           width:130}
                  ,{ dataIndex: 'ENT_MONEY_UNIT'      ,           width:80}
                  ,{ dataIndex: 'MONEY_UNIT'          ,           width:80}
                  ,{ dataIndex: 'GUBUN'               ,           width:80}
                  ,{ dataIndex: 'PLAN_SUM'            ,           width:100}
                  ,{ dataIndex: 'MONTH1'              ,           width:100}
                  ,{ dataIndex: 'MONTH2'              ,           width:100}
                  ,{ dataIndex: 'MONTH3'              ,           width:100}
                  ,{ dataIndex: 'MONTH4'              ,           width:100}
                  ,{ dataIndex: 'MONTH5'              ,           width:100}
                  ,{ dataIndex: 'MONTH6'              ,           width:100}
                  ,{ dataIndex: 'MONTH7'              ,           width:100}
                  ,{ dataIndex: 'MONTH8'              ,           width:100}
                  ,{ dataIndex: 'MONTH9'              ,           width:100}
                  ,{ dataIndex: 'MONTH10'             ,           width:100}
                  ,{ dataIndex: 'MONTH11'             ,           width:100}
                  ,{ dataIndex: 'MONTH12'             ,           width:100}
                  
          ],
        viewConfig: {
            getRowClass: function(record, rowIndex, rowParams, store){
                var cls = '';
                
                if(record.get('BIT_CD') == '3'){
                    cls = 'x-change-cell_light';
                }
                else if(record.get('BIT_CD') == '5' || record.get('BIT_CD') == '6' || record.get('BIT_CD') == '7'){
                    cls = 'x-change-cell_normal';
                }else{
                    cls = 'x-change-cell_white';
                }
                return cls;
            }
        }
    });
    
    var saleTypeGrid = Unilite.createGrid('sgp100skrvSaleTypeGrids', { 
        layout : 'fit',        
        store: saleTypeStore, 
        flex: 1,
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useRowNumberer: false,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        columns:  [{ dataIndex: 'BIT_CD'              ,           width:86, hidden: true }
                  ,{ dataIndex: 'PLAN_TYPE1'          ,           width:86, hidden: true }
                  ,{ dataIndex: 'PLAN_TYPE1_VIEW'     ,           width:100}
                  ,{ dataIndex: 'MONEY_UNIT'          ,           width:80}
                  ,{ dataIndex: 'GUBUN'               ,           width:80}
                  ,{ dataIndex: 'PLAN_SUM'            ,           width:100}
                  ,{ dataIndex: 'MONTH1'              ,           width:100}
                  ,{ dataIndex: 'MONTH2'              ,           width:100}
                  ,{ dataIndex: 'MONTH3'              ,           width:100}
                  ,{ dataIndex: 'MONTH4'              ,           width:100}
                  ,{ dataIndex: 'MONTH5'              ,           width:100}
                  ,{ dataIndex: 'MONTH6'              ,           width:100}
                  ,{ dataIndex: 'MONTH7'              ,           width:100}
                  ,{ dataIndex: 'MONTH8'              ,           width:100}
                  ,{ dataIndex: 'MONTH9'              ,           width:100}
                  ,{ dataIndex: 'MONTH10'             ,           width:100}
                  ,{ dataIndex: 'MONTH11'             ,           width:100}
                  ,{ dataIndex: 'MONTH12'             ,           width:100}
        ],
        viewConfig: {
            getRowClass: function(record, rowIndex, rowParams, store){
                var cls = '';
                
                if(record.get('BIT_CD') == '3'){
                    cls = 'x-change-cell_light';
                }
                else if(record.get('BIT_CD') == '5' || record.get('BIT_CD') == '6' || record.get('BIT_CD') == '7'){
                    cls = 'x-change-cell_normal';
                }else{
                    cls = 'x-change-cell_white';
                }
                return cls;
            }
        }
    });
    
    var customitemSortMasterGrid = Unilite.createGrid('sgp100skrvCsutomItemSortMasterGrid', { 
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
        columns:  [{ dataIndex: 'BIT_CD'              ,           width:86, hidden: true }
                  ,{ dataIndex: 'PLAN_TYPE1'          ,           width:86, hidden: true }
                  ,{ dataIndex: 'S_CODE'              ,           width:100}
                  ,{ dataIndex: 'S_NAME'              ,           width:120}
                  ,{ dataIndex: 'S_CODE2'             ,           width:100}
                  ,{ dataIndex: 'S_NAME2'             ,           width:120}                  
                  ,{ dataIndex: 'ENT_MONEY_UNIT'      ,           width:80}
                  ,{ dataIndex: 'MONEY_UNIT'          ,           width:80}
                  ,{ dataIndex: 'GUBUN'               ,           width:80}
                  ,{ dataIndex: 'PLAN_SUM'            ,           width:100}
                  ,{ dataIndex: 'MONTH1'              ,           width:100}
                  ,{ dataIndex: 'MONTH2'              ,           width:100}
                  ,{ dataIndex: 'MONTH3'              ,           width:100}
                  ,{ dataIndex: 'MONTH4'              ,           width:100}
                  ,{ dataIndex: 'MONTH5'              ,           width:100}
                  ,{ dataIndex: 'MONTH6'              ,           width:100}
                  ,{ dataIndex: 'MONTH7'              ,           width:100}
                  ,{ dataIndex: 'MONTH8'              ,           width:100}
                  ,{ dataIndex: 'MONTH9'              ,           width:100}
                  ,{ dataIndex: 'MONTH10'             ,           width:100}
                  ,{ dataIndex: 'MONTH11'             ,           width:100}
                  ,{ dataIndex: 'MONTH12'             ,           width:100}
                  
          ],
        viewConfig: {
            getRowClass: function(record, rowIndex, rowParams, store){
                var cls = '';
                
                if(record.get('BIT_CD') == '3'){
                    cls = 'x-change-cell_light';
                }
                else if(record.get('BIT_CD') == '5' || record.get('BIT_CD') == '6' || record.get('BIT_CD') == '7'){
                    cls = 'x-change-cell_normal';
                }else{
                    cls = 'x-change-cell_white';
                }
                return cls;
            }
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
                     ,id: 'sgp100skrvCustomGrid' 
                     ,hidden: !use2
                 },
                 {
                     title: '<t:message code="system.label.sales.saleschargeby" default="영업담당별"/>'
                     ,xtype:'container'
                     ,layout:{type:'vbox', align:'stretch'}
                     ,items:[salePrsnSubForm, salePrsnMasterGrid]
                     ,id: 'sgp100skrvSalePrsnGrid'
                     ,hidden: !use1
                 },
                 {
                     title: '<t:message code="system.label.sales.itemby" default="품목별"/>'
                     ,xtype:'container'
                     ,layout:{type:'vbox', align:'stretch'}
                     ,items:[itemSubForm, itemMasterGrid]
                     ,id: 'sgp100skrvItemGrid'
                     ,hidden: !use3
                 },
                 {
                     title: '<t:message code="system.label.sales.itemgroupby" default="품목분류별"/>'
                     ,xtype:'container'
                     ,layout:{type:'vbox', align:'stretch'}
                     ,items:[itemSortSubForm, itemSortMasterGrid]
                     ,id: 'sgp100skrvitemSortGrid' 
                     ,hidden: !use4
                 },
                 {
                     title: '<t:message code="system.label.sales.repmodelby" default="대표모델별"/>'
                     ,xtype:'container'
                     ,layout:{type:'vbox', align:'stretch'}
                     ,items:[spokesItemSubForm, spokesItemMasterGrid]
                     ,id: 'sgp100skrvspokesItemGrid' 
                     ,hidden: !use5
                 },
                 {
                     title: '<t:message code="system.label.sales.clientitemby" default="고객품목별"/>'
                     ,xtype:'container'
                     ,layout:{type:'vbox', align:'stretch'}
                     ,items:[customerItemSubForm, customerItemMasterGrid]
                     ,id: 'sgp100skrvcustomerItemGrid' 
                     ,hidden: !use6
                 },
                 {
                     title: '<t:message code="system.label.sales.sellingtypeby" default="판매유형별"/>'
                     ,xtype:'container'
                     ,layout:{type:'vbox', align:'stretch'}
                     ,items:[saleTypeGrid]
                     ,id: 'sgp100skrvSaleTypeGrid' 
                     ,hidden: !use9
                 },
                 {
                     title: '<t:message code="system.label.sales.customitemgroupby" default="고객품목분류별"/>'
                     ,xtype:'container'
                     ,layout:{type:'vbox', align:'stretch'}
                     ,items:[customitemSortSubForm, customitemSortMasterGrid]
                     ,id: 'sgp100skrvcustomitemSortGrid' 
                     ,hidden: !use10
                 }                 
        ],
        listeners:  {
            tabChange:  function ( tabPanel, newCard, oldCard, eOpts )  {

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
        id  : 'sgp100skrvApp',
        fnInitBinding : function() {
            
            var param= Ext.getCmp('searchForm').getValues(); 
            
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons('reset', true);
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'],false);
            panelSearch.clearForm();
            panelResult.clearForm();
            itemSubForm.clearForm();            
            var showTab = Ext.getCmp('sgp100skrvCustomGrid');
            
            if(use10){
                showTab = Ext.getCmp('sgp100skrvcustomitemSortGrid');
            }            
            if(use9){
                showTab = Ext.getCmp('sgp100skrvSaleTypeGrid');
            }
            if(use8){
                //유니라이트용
            }
            if(use7){
                //유니라이트용
            }
            if(use6){
                showTab = Ext.getCmp('sgp100skrvcustomerItemGrid');
            }
            if(use5){
                showTab = Ext.getCmp('sgp100skrvspokesItemGrid');
            }
            if(use4){
                showTab = Ext.getCmp('sgp100skrvitemSortGrid');
            }
            if(use3){
                showTab = Ext.getCmp('sgp100skrvItemGrid');
            }
            if(use1){
                showTab = Ext.getCmp('sgp100skrvSalePrsnGrid');
            }
            if(use2){
                showTab = Ext.getCmp('sgp100skrvCustomGrid');
            }
            showTab.show();
            this.setDefault();
        },
        onQueryButtonDown : function()  {
            if(!panelSearch.setAllFieldsReadOnly(true)){
                return false;
            }
            var activeTabId = tab.getActiveTab().getId();           
            if(activeTabId == 'sgp100skrvCustomGrid') {           
                customMasterStore.loadStoreRecords();
            } else if(activeTabId == 'sgp100skrvSalePrsnGrid') {
                salePrsnMasterStore.loadStoreRecords();
            } else if(activeTabId == 'sgp100skrvItemGrid') {
                itemMasterStore.loadStoreRecords();
            } else if(activeTabId == 'sgp100skrvitemSortGrid') {
                itemSortMasterStore.loadStoreRecords();
            } else if(activeTabId == 'sgp100skrvspokesItemGrid') {
                spokesItemMasterStore.loadStoreRecords();
            }  else if(activeTabId == 'sgp100skrvcustomerItemGrid') {
                customerItemMasterStore.loadStoreRecords();
            }  else if(activeTabId == 'sgp100skrvSaleTypeGrid') {
                saleTypeStore.loadStoreRecords();
            } else if(activeTabId == 'sgp100skrvcustomitemSortGrid') {
                customitemSortMasterStore.loadStoreRecords();
            }   
            UniAppManager.setToolbarButtons('newData', true);
        
        },
        setDefault: function() {
            panelSearch.setValue('DIV_CODE', UserInfo.divCode);
            panelSearch.setValue('PLAN_YEAR', new Date().getFullYear());
            panelSearch.setValue('MONEY_UNIT', UserInfo.currency);
            panelSearch.setValue('ORDER_TYPE', '10');
            panelSearch.setValue('MONEY_UNIT_DIV', BsaCodeInfo.gsEntMoneyUnit);
            
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('PLAN_YEAR', new Date().getFullYear());
            panelResult.setValue('MONEY_UNIT', UserInfo.currency);
            panelResult.setValue('ORDER_TYPE', '10');
            panelResult.setValue('MONEY_UNIT_DIV', BsaCodeInfo.gsEntMoneyUnit);
            customSubForm.setValue('AGENT_TYPE', '1'); 
            customerItemSubForm.setValue('AGENT_TYPE', '1'); 
            itemSubForm.setValue('ITEM_ACCOUNT', '10');
            spokesItemSubForm.setValue('ITEM_ACCOUNT', '10');
            
            panelSearch.getField('MONEY_UNIT_DIV').setReadOnly(false);
            panelResult.getField('MONEY_UNIT_DIV').setReadOnly(false);
        },
        setHiddenColumn: function() {
            if(itemSortSubForm.getValue('ITEM_LEVEL_ID').ITEM_LEVEL == '1') {
            	itemSortSubForm.setValue('ITEM_LEVEL2', '');
            	itemSortSubForm.setValue('ITEM_LEVEL3', '');
                itemSortSubForm.getField('ITEM_LEVEL1').setDisabled(false);
                itemSortSubForm.getField('ITEM_LEVEL2').setDisabled(true);
                itemSortSubForm.getField('ITEM_LEVEL3').setDisabled(true);
            } else if(itemSortSubForm.getValue('ITEM_LEVEL_ID').ITEM_LEVEL == '2') {
            	itemSortSubForm.setValue('ITEM_LEVEL1', '');
            	itemSortSubForm.setValue('ITEM_LEVEL3', '');            	
                itemSortSubForm.getField('ITEM_LEVEL1').setDisabled(true);
                itemSortSubForm.getField('ITEM_LEVEL2').setDisabled(false);
                itemSortSubForm.getField('ITEM_LEVEL3').setDisabled(true);
            } else if(itemSortSubForm.getValue('ITEM_LEVEL_ID').ITEM_LEVEL == '3') {
            	itemSortSubForm.setValue('ITEM_LEVEL1', '');
            	itemSortSubForm.setValue('ITEM_LEVEL2', '');            	
                itemSortSubForm.getField('ITEM_LEVEL1').setDisabled(true);
                itemSortSubForm.getField('ITEM_LEVEL2').setDisabled(true);
                itemSortSubForm.getField('ITEM_LEVEL3').setDisabled(false);
            }
            
            if(customitemSortSubForm.getValue('CUSTOM_ITEM_LEVEL_ID').ITEM_LEVEL == '1') {
            	customitemSortSubForm.setValue('ITEM_LEVEL2', '');
            	customitemSortSubForm.setValue('ITEM_LEVEL3', '');
                customitemSortSubForm.getField('ITEM_LEVEL1').setDisabled(false);
                customitemSortSubForm.getField('ITEM_LEVEL2').setDisabled(true);
                customitemSortSubForm.getField('ITEM_LEVEL3').setDisabled(true);
            } else if(customitemSortSubForm.getValue('CUSTOM_ITEM_LEVEL_ID').ITEM_LEVEL == '2') {
            	customitemSortSubForm.setValue('ITEM_LEVEL1', '');
            	customitemSortSubForm.setValue('ITEM_LEVEL3', '');            	
                customitemSortSubForm.getField('ITEM_LEVEL1').setDisabled(true);
                customitemSortSubForm.getField('ITEM_LEVEL2').setDisabled(false);
                customitemSortSubForm.getField('ITEM_LEVEL3').setDisabled(true);
            } else if(customitemSortSubForm.getValue('CUSTOM_ITEM_LEVEL_ID').ITEM_LEVEL == '3') {
            	customitemSortSubForm.setValue('ITEM_LEVEL1', '');
            	customitemSortSubForm.setValue('ITEM_LEVEL2', '');            	
                customitemSortSubForm.getField('ITEM_LEVEL1').setDisabled(true);
                customitemSortSubForm.getField('ITEM_LEVEL2').setDisabled(true);
                customitemSortSubForm.getField('ITEM_LEVEL3').setDisabled(false);
            }
            
        }
    });
};
</script>