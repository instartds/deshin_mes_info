//@charset UTF-8
/**
 * 회계 모듈용 공통 함수 모음
 * @class Unilite.module.UniSales
 * @singleton
 */
Ext.define('Unilite.module.UniAccnt', {
    alternateClassName: 'UniAccnt',
    singleton: true,
	makeItem: function( acCode,  acName,  fName, fDataName, acType, acPopup, acLen, acCtl, acFormat)	{
		var field = {};
		// acType
		if(acPopup == 'Y')	{  
			if(acCode.substring(0,1) != "Z")	{
    			switch(acCode)	{
	    			case 'A2': Ext.apply(field, Unilite.popup('DEPT',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));		//부서
	    				break;
	    			case 'A3': Ext.apply(field, Unilite.popup('BANK',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));		//은행
	    				break;
	    			case 'A4': Ext.apply(field, Unilite.popup('CUST',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));		//거래처
	    				break;
	    			case 'A6': Ext.apply(field, Unilite.popup('Employee',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));	//사번
	    				break;
	    			case 'A7': Ext.apply(field, Unilite.popup('CUST',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));			//예산코드
	    				break;
	    			case 'A9': Ext.apply(field, Unilite.popup('CUST',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));			//Cost Pool
	    				break;
	    			case 'B1': Ext.apply(field, Unilite.popup('DIV_PUMOK',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));			//사업장별 품목팝업
	    				break;
	    			case 'C2': Ext.apply(field, Unilite.popup('CUST',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));			//어음번호
	    				break;
	    			case 'C7': Ext.apply(field, Unilite.popup('CUST',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));			//수표번호
	    				break;
	    			case 'D5': Ext.apply(field, Unilite.popup('CUST',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));			//L/C번호(수출)
	    				break;
	    			case 'D6': Ext.apply(field, Unilite.popup('CUST',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));			//L/C번호(수입)
	    				break;
	    			case 'D7': Ext.apply(field, Unilite.popup('CUST',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));			//B/L번호(수출)
	    				break;
	    			case 'D8': Ext.apply(field, Unilite.popup('CUST',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));			//B/L번호(수입)
	    				break;
	    			case 'E1': Ext.apply(field, Unilite.popup('CUST',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));			//프로젝트
	    				break;
	    			case 'G5': Ext.apply(field, Unilite.popup('CUST',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));			//증빙유형
	    				break;
	    			case 'M1': Ext.apply(field, Unilite.popup('CUST',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));			//자산코드
	    				break;
	    			case 'O1': Ext.apply(field, Unilite.popup('CUST',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));			//Deposit
	    				break;
	    			case 'P2': Ext.apply(field, Unilite.popup('CUST',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));			//차입금번호
	    				break;
	    			case 'B5': Ext.apply(field, {fieldLabel:acName, xtype:'uniCombobox', name:fName, comboType:'AU', comboCode: 'B013'});
	    				break;
	    			case 'C0': Ext.apply(field, {fieldLabel:acName, xtype:'uniCombobox', name:fName, comboType:'AU', comboCode: 'A058'});
	    				break;
	    			case 'D2': Ext.apply(field, {fieldLabel:acName, xtype:'uniCombobox', name:fName, comboType:'AU', comboCode: 'B004'});
	    				break;
	    			case 'I4': Ext.apply(field, {fieldLabel:acName, xtype:'uniCombobox', name:fName, comboType:'AU', comboCode: 'A003'});
	    				break;
	    			case 'I5': Ext.apply(field, {fieldLabel:acName, xtype:'uniCombobox', name:fName, comboType:'AU', comboCode: 'A022'});
	    				break;
	    			case 'I7': Ext.apply(field, {fieldLabel:acName, xtype:'uniCombobox', name:fName, comboType:'AU', comboCode: 'A149'});
	    				break;    				
	    			default:
	    				break;
	    		}
			}else {
				//  Z로 시작하는 관리항목은 사용자 정의 항목임
				Ext.apply(field, {fieldLabel:acName, xtype:'uniTextfield', name:fName, maxLength: acLen});
			}
		}else {
    		switch(acType)	{
    			case 'A': Ext.apply(field, {fieldLabel:acName, xtype:'uniTextfield', name:fName, maxLength: acLen});
    				break;
    			case 'N': Ext.apply(field, {fieldLabel:acName, xtype:'uniNumberfield', name:fName, maxLength: acLen });
    				break;
    			case 'D': Ext.apply(field, {fieldLabel:acName, xtype:'uniDatefield', name:fName});
    				break;
    			default:
    				break;
    		}
		}
		
		if(acType=='N')	{
			switch(acFormat)	{
    			case 'Q': Ext.apply(field, {uniType:'uniQty'});	
    				break;
    			case 'P': Ext.apply(field, {uniType:'uniUnitPrice'}); 
    				break;
    			case 'I': Ext.apply(field, {uniType:'uniPrice'});
    				break;
    			case 'O': Ext.apply(field, {uniType:'uniFC'});
    				break;
    			case 'R': Ext.apply(field, {uniType:'uniER'});
    				break;
    			default:
    				break;
    		}
		}
		
		if(acCtl == 'Y')	{
			Ext.apply(field, {allowBlank: false, labelClsExtra:'required_field_label'});
		}
		return field;
	},
	makeBlankField: function()	{
		var field={xtype:'component', html:'&nbsp;'};
		return field;
	},	
	
	addMadeFields : function( form, dataMap )	{
    	var fName, acCode, acName, acType, acPopup, acLen, acCtl, acFormat;
		console.log('dataMap: ',dataMap)
		form.removeAll();
    	/*form.remove('AC_CODE1');
    	form.remove('AC_DATA_NAME1');
    	form.remove('AC_DATA1');
    	form.remove('AC_CODE2');
    	form.remove('AC_DATA_NAME2');
    	form.remove('AC_DATA2');
    	form.remove('AC_CODE3');
    	form.remove('AC_DATA_NAME3');
    	form.remove('AC_DATA3');*/
    	
		acCode= dataMap['AC_CODE1'];
		if(!Ext.isEmpty(acCode))	{
			fName = 'AC_DATA1';
			fDataName = 'AC_DATA_NAME1';
			acName = dataMap['AC_NAME1'];
			acType = dataMap['AC_TYPE1'];
			acPopup = dataMap['AC_POPUP1'];
			acLen = dataMap['AC_LEN1'];
			acCtl = dataMap['AC_CTL1'];
			acFormat = dataMap['AC_FORMAT1'];
			form.add(UniAccnt.makeItem(acCode,  acName,	fName,	fDataName,	acType, acPopup, acLen, acCtl, acFormat));
		}else {
			form.add(UniAccnt.makeBlankField());	
		}
		
		acCode= dataMap['AC_CODE4'];
		if(!Ext.isEmpty(acCode))	{
			fName = 'AC_DATA4' 
			fDataName = 'AC_DATA_NAME4';
			acName = dataMap['AC_NAME4'];
			acType = dataMap['AC_TYPE4'];
			acPopup = dataMap['AC_POPUP4'];
			acLen = dataMap['AC_LEN4'];
			acCtl = dataMap['AC_CTL4'];
			acFormat = dataMap['AC_FORMAT4'];
			form.add(UniAccnt.makeItem(acCode,  acName,	fName,	fDataName, acType, acPopup, acLen, acCtl, acFormat));
		}else {
			form.add(UniAccnt.makeBlankField());	
		}
		
		acCode= dataMap['AC_CODE2'];
		if(!Ext.isEmpty(acCode))	{
			fName = 'AC_DATA2' 
			fDataName = 'AC_DATA_NAME2';
			acName = dataMap['AC_NAME2'];
			acType = dataMap['AC_TYPE2'];
			acPopup = dataMap['AC_POPUP2'];
			acLen = dataMap['AC_LEN2'];
			acCtl = dataMap['AC_CTL2'];
			acFormat = dataMap['AC_FORMAT2'];
			form.add(UniAccnt.makeItem(acCode,  acName,	fName,	fDataName, acType, acPopup, acLen, acCtl, acFormat));
		}else {
			form.add(UniAccnt.makeBlankField());	
		}
		
		acCode= dataMap['AC_CODE5'];
		if(!Ext.isEmpty(acCode))	{
			fName = 'AC_DATA5' 
			fDataName = 'AC_DATA_NAME5';
			acName = dataMap['AC_NAME5'];
			acType = dataMap['AC_TYPE5'];
			acPopup = dataMap['AC_POPUP5'];
			acLen = dataMap['AC_LEN5'];
			acCtl = dataMap['AC_CTL5'];
			acFormat = dataMap['AC_FORMAT5'];
			form.add(UniAccnt.makeItem(acCode,  acName,	fName,	fDataName, acType, acPopup, acLen, acCtl, acFormat));
		}else {
			form.add(UniAccnt.makeBlankField());	
		}
			
		acCode= dataMap['AC_CODE3'];
		if(!Ext.isEmpty(acCode))	{
			fName = 'AC_DATA3' 
			fDataName = 'AC_DATA_NAME3';
			acName = dataMap['AC_NAME3'];
			acType = dataMap['AC_TYPE3'];
			acPopup = dataMap['AC_POPUP3'];
			acLen = dataMap['AC_LEN3'];
			acCtl = dataMap['AC_CTL3'];
			acFormat = dataMap['AC_FORMAT3'];
			form.add(UniAccnt.makeItem(acCode,  acName,	fName,	fDataName, acType, acPopup, acLen, acCtl, acFormat));
		}else {
			form.add(UniAccnt.makeBlankField());	
		}
		
		acCode= dataMap['AC_CODE6'];
		if(!Ext.isEmpty(acCode))	{
			fName = 'AC_DATA6' 
			fDataName = 'AC_DATA_NAME6';
			acName = dataMap['AC_NAME6'];
			acType = dataMap['AC_TYPE6'];
			acPopup = dataMap['AC_POPUP6'];
			acLen = dataMap['AC_LEN6'];
			acCtl = dataMap['AC_CTL6'];
			acFormat = dataMap['AC_FORMAT6'];
			form.add(UniAccnt.makeItem(acCode,  acName,	fName,	fDataName, acType, acPopup, acLen, acCtl, acFormat));
		}else {
			form.add(UniAccnt.makeBlankField());	
		}
		
		//form.masterGrid.addChildForm(form);
		form._onAfterRenderFunction(form);
		 
		console.log('form:', form);
	},
	ChargeCode : function(){
		
		var param = {'COMP_CODE' : UserInfo.compCode};
		accntCommonService.fnGetChargeCode(param, function(provider, response){
			
			if(!Ext.isEmpty(provider))	{
				return provider.SUB_CODE;
			}
		});
	}
}); 



