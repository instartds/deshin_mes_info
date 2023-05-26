//@charset UTF-8
/**
 * 회계 모듈용 공통 함수 모음
 * @class Unilite.module.UniSales
 * @singleton
 */
var dynamicId = 'dynamicPopup';
var cnt = 1;
var gsBankValueFieldName = '';
var gsBankTextFieldName = '';
/**
 * 회계모듈 공통 함수
 */
Ext.define('Unilite.module.UniCost', {	
    alternateClassName: 'UniCost',
    /**
     * singleton
     */
    singleton: true, 
   
	setMorhFrText: function( divCode, workMonth, components)	{
		var pWorkMonth = UniDate.getDbDateStr(workMonth);
		var param = {
			  'DIV_CODE'	: divCode
			, 'WORK_MONTH'	:pWorkMonth
		}
		Ext.getBody().mask();
		costCommonService.selectWorkMonthFr(param, 
				function(responseText, response)	{
					if(responseText && responseText.WORK_MONTH_FR != '' && responseText.YEAR_EVALUATION_YN == 'Y')	{
						if(Ext.isArray(components))	{
							Ext.each(components, function(comp){
								comp.setVisible(true)
								comp.setHtml('(시작년월 : '+responseText.WORK_MONTH_FR+')');
							})
						}else {
							components.setVisible(true)
							components.setHtml('(시작년월 : '+responseText.WORK_MONTH_FR+')');
						}
					} else {
						if(Ext.isArray(components))	{
							Ext.each(components, function(comp){
								comp.setVisible(false)
							})
						}else {
							components.setVisible(false)
						}
					}
					Ext.getBody().unmask();
				}
		);
	}
	
    
}); 



