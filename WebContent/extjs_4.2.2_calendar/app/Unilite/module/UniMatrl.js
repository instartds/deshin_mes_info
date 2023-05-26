//@charset UTF-8
/**
 * 구매 모듈용 공통 함수 모음
 * @class Unilite.module.UniMatrl
 * @singleton
 */
Ext.define('Unilite.module.UniMatrl', {
    alternateClassName: 'UniMatrl',
    singleton: true,
    
    /**
     * Excel round / roundup / rounddown 함수 
     * roundup 과 rounddown은 ceil과 floor와 약간 다름 
     * roundup : 0 에서 먼 수
     * rounddown : 0 에서 가까운 수
     * 음수 round의 경우 abs 기준 round 사용 !!! 즉 -3.5 는 -4 임.
     * @param {number} dAmount
     * @param {String} sUnderCalBase 1: roundup, 2:rounddown, 기타 : round
     * @param {Integer} numDigit
     */
    fnAmtWonCalc: function(dAmount, sUnderCalBase, numDigit)	{
			var absAmt = 0, wasMinus = false;
			var numDigit = (numDigit == undefined) ? 0 : numDigit ;
			
			if( dAmount >= 0 ) {
				absAmt = dAmount;
			} else {
				absAmt = Math.abs(dAmount);
				wasMinus = true;
			}
			
			var mn = Math.pow(10,numDigit);
			switch (sUnderCalBase) {
				case  "1" :	//up : 0에서 멀어짐.
					absAmt = Math.ceil(absAmt * mn) / mn;
					break;
				case  "2" :	//cut : 0에서 가까와짐, 아래 자리수 버림.
					absAmt = Math.floor(absAmt * mn) / mn;
					break;
				default:						//round
					absAmt = Math.round(absAmt * mn) / mn;
			}
			// 음수 였다면 -1을 곱하여 복원.
			return (wasMinus) ? absAmt * (-1) : absAmt;

    },
    
    fnStockQ: function(rtnRecord, fnCallbak, compCode, divCode, bParam3, itemCode,  whCode)	{
    	if(!Ext.isEmpty(compCode) && !Ext.isEmpty(divCode) && !Ext.isEmpty(itemCode))	{
        	var param = {'COMP_CODE':compCode
        				, 'DIV_CODE':divCode
        				, 'bParam3':bParam3
        				, 'ITEM_CODE':itemCode
        				, 'WH_CODE':whCode		};
        	Ext.getBody().mask();
			matrlCommonService.fnStockQ(param, function(provider, response)	{
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



