//@charset UTF-8
/**
 * 인사 모듈용 공통 함수 모음
 * @class Unilite.module.UniHuman
 * @singleton
 */
Ext.define('Unilite.module.UniHuman', {	
    alternateClassName: 'UniHuman',
    singleton: true,    
	
	/**
	 * Combobox refcode 값 가져오기, 해당 공통코드는 페이지에 정의되어 있어야 함.
	 * @param {} param
	 * 	param = {
	 * 	'MAIN_CODE':'A001'
	 *  'SUB_CODE':'01'
	 *  'field':'refCode1'
	 *  'storeId':'CustomStore'
	 * }
	 * @return {}
	 */
	fnGetRefCode:function(param)	{
		var store ;
		if(param.storeId)	{
			store = Ext.StoreManager.lookup(param.storeId);
		}else {
			store = Ext.StoreManager.lookup("CBS_AU_"+param.MAIN_CODE);
		}
		var r ;
		if(store)	{
			var selRecordIdx = store.findBy(function(record){return (record.get("value") == param.SUB_CODE)});
			if(selRecordIdx > -1){
				var selRecord = store.getAt(selRecordIdx);
				if(param.field) r = selRecord.get(param.field);
			}
		}
		return r;		
	},
	fnGetTaxAdjustmentYYYYMMDD: function(stdMMDD){
		var rtnDate = '';
		var today = UniDate.getDbDateStr(UniDate.get('today')).substring(4, 8);
		if(today > stdMMDD){	//정산날짜가 지났으면 당해년도
			rtnDate = UniDate.getDbDateStr(UniDate.add(UniDate.extParseDate(UniDate.get('today')), {years: +1})).substring(0, 4);
		}else{		//정산날짜가 아직 안지났으면 이전년도
			rtnDate = UniDate.getDbDateStr(UniDate.get('today')).substring(0, 4);
		}
		return rtnDate + stdMMDD;
	},
	fix:function(value)	{
		var rValue = 0;
		if(value > 0)	{
			rValue = 	Math.floor(value);
		}else if(value < 0) {
			rValue = 	Math.ceil(value);
		}
		return rValue;
	},
	/**
	 * 부서권한관련  ( 부서 팝업 -> 권환걸린 부서멀티콤보로 변경)
	 * @param {} checkValue    부서권한(Y,N)
	 * @param {} Form          관련폼
	 * @param {} popId       부서팝업 itemID
	 * @param {} comboNm       부서멀티콤보 name
	 */
	deptAuth:function(checkValue, Form, popId, comboNm )    { 
		if(checkValue == 'Y'){
            Form.getField(comboNm).setDisabled(false);
            Form.getField(comboNm).setHidden(false);
             
            Form.down('#'+popId).setDisabled(true);
            Form.down('#'+popId).setHidden(true);
            
            Form.getField(comboNm).select(Form.getField(comboNm).getStore().collect(Form.getField(comboNm).valueField));
        
        }else{
            Form.getField(comboNm).setDisabled(true);
            Form.getField(comboNm).setHidden(true);
             
            Form.down('#'+popId).setDisabled(false);
            Form.down('#'+popId).setHidden(false);
        }
		
	},
	
	getTaxReturnYear:function()	{
		var dToday = new Date();
		var curMonth = dToday.getMonth()+1;		// getMonth는 0~11 을 반환함
		return curMonth > 3 ? dToday.getFullYear() : Ext.Date.add(dToday, Ext.Date.YEAR, -1).getFullYear();
	},
	
	getTaxReturnStartDate:function()	{
		return this.getTaxReturnYear()+'0101';
	},
	
	getTaxReturnEndDate:function()	{
		return this.getTaxReturnYear()+'1231';
	}
	
	
	
	/*,
	//연말정산 년도 가져오기	 
	fnGetTaxAdjustmentYear: function(){
		humanCommonService.getAdjustmentStdDate(param, function(provider, response)	{			
			var stdDate = '';
			var rtnDate = '';
			if(!Ext.isEmpty(provider)){
				stdDate = provider[0].CODE_NAME;
			}else{
				stdDate = '0310';
			}
			
			var today = UniDate.getDbDateStr(UniDate.get('today')).substring(4, 8);
			if(today > stdDate){	//정산날짜가 지났으면 당해년도
				rtnDate = UniDate.getDbDateStr(UniDate.get('today')).substring(0, 4);
			}else{		//정산날짜가 아직 안지났으면 이전년도
				rtnDate = UniDate.getDbDateStr(UniDate.add(UniDate.get('today'), {years: -1})).substring(0, 4);
			}
			return rtnDate;
		});
	},
	
	//연말정산년도 설정 기준일 가져오기
	fnGetAdjustmentStdDate: function(){
		humanCommonService.getAdjustmentStdDate(param, function(provider, response)	{			
			var stdDate = '';
			if(!Ext.isEmpty(provider)){
				stdDate = provider[0].CODE_NAME;
			}else{
				stdDate = '0310';
			}
			return stdDate;
		});
	}
	*/
	
}); 



