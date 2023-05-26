//@charset UTF-8
/**
 * 영업 모듈용 공통 함수 모음
 * @class Unilite.module.UniStock
 * @singleton
 */
Ext.define('Unilite.module.UniStock', {
    alternateClassName: 'UniStock',
    singleton: true,
    
    fnStockQ: function(rtnRecord, fnCallbak, compCode, divCode, bParam3, itemCode,  whCode)	{
    	if(!Ext.isEmpty(compCode) && !Ext.isEmpty(divCode) && !Ext.isEmpty(itemCode))	{
        	var param = {'COMP_CODE':compCode
        				, 'DIV_CODE':divCode
        				, 'bParam3':bParam3
        				, 'ITEM_CODE':itemCode
        				, 'WH_CODE':whCode		};
        	Ext.getBody().mask();
        	//salesCommonServiceImpl
			salesCommonService.fnStockQ(param, function(provider, response)	{
					Ext.getBody().unmask();
					console.log(provider);
					if(!Ext.isEmpty(provider))	{
						var cbParams = {																					
						//	'orderQ':orderQ,		
							'rtnRecord':rtnRecord							
						}
						fnCallbak.call(this, provider, cbParams);
					}
			});
    	}
    }
}); 



