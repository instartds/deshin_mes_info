//@charset UTF-8
/**
 * @class Unilite
 * 모듈 Popup 접근을 쉽게 하기 위한 함수 모음.
 */
Ext.define('Unilite.module.UniTempPopup', {	
    alternateClassName: 'UniTempPopup',
    singleton: true, 
	
	popup: function(sPopItem, config ) {
		var rv={} ;
		
		if (sPopItem == 'TEMPLATE' ) {		//템플릿 팝업
			rv = {
				xtype:'uniPopupField', 
				fieldLabel : 'TEPLETE 팝업',
			    valueFieldName:'TMP_CD',
			    textFieldName:'TMP_NM',
			    DBvalueFieldName: 'TMP_CD',
			    DBtextFieldName: 'TMP_NM',
			    api: 'templatePopupService.templatePopup',
                app: 'Unilite.app.popup.templatePopup',
                valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:725,
			    popupHeight:455,
			    pageTitle: 'TEMPLATE'
			};
		} else if (sPopItem == 'TEMPLATE_G' ) {		//템플릿 팝업 그리드
			rv = {
				xtype:'uniPopupColumn', 
//				fieldLabel : '사용자 정의 팝업',
			    textFieldName:'TMP_NM',
			    DBtextFieldName: 'TMP_NM',
			    api: 'templatePopupService.templatePopup',
                app: 'Unilite.app.popup.templatePopup',
                valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:725,
			    popupHeight:455,
			    pageTitle: 'TEMPLATE'
			};
		}
				
		
       // console.log("BEFORE", rv.allowBlank, config.allowBlank)
		if (config) {
            rv = Ext.apply(rv, config);
            console.log('uniPopup Config : ', config);
            console.log('uniPopup rv : ', rv);
        }
        //console.log("AFTER", rv.allowBlank, config)
		return rv;
				
	}
}) 