//@charset UTF-8
/**
 * @class Unilite
 * Site Popup 
 */
Ext.apply(Unilite,{
	
	s_popup: function(sPopItem, config ) {
		var rv={} ;

		if (sPopItem == 'BUDG_KOCIS' ) {  //KOCIS(해외문화홍보원) -  예산과목
                rv = {
                    xtype:'uniPopupField',                  // applyextparam: ADD_QUERY, ACCNT
                    valueFieldName:'BUDG_CODE',
                    textFieldName:'BUDG_NAME',   
                    DBvalueFieldName: 'BUDG_CODE',
                    DBtextFieldName: 'BUDG_NAME',
                    api: 's_kocisPopupService.budgKocisPopup',
                    app: 'Unilite.app.popup.BudgKocisPopup',
                    valueFieldWidth: 90,
                    textFieldWidth: 140,
                    popupWidth:936,
                    popupHeight:650,
                    pageTitle: '예산과목'
                };
        } else if (sPopItem == 'BUDG_KOCIS_G' ) { //KOCIS(해외문화홍보원) -  예산과목 그리드
            rv = {
                xtype:'uniPopupColumn',                 // applyextparam: ADD_QUERY, ACCNT
                textFieldName:'BUDG_NAME',   
                DBtextFieldName: 'BUDG_NAME',
                api: 's_kocisPopupService.budgKocisPopup',
                app: 'Unilite.app.popup.BudgKocisPopup',
                pageTitle: '예산과목',
                popupWidth:1100,
                popupHeight:650
                
            };
        } else if (sPopItem == 'BUDG_KOCIS_NORMAL' ) {  //KOCIS(해외문화홍보원) -  예산과목-normal
            rv = {
                xtype:'uniPopupField',                  // applyextparam: ADD_QUERY, ACCNT
                valueFieldName:'BUDG_CODE',
                textFieldName:'BUDG_NAME',   
                DBvalueFieldName: 'BUDG_CODE',
                DBtextFieldName: 'BUDG_NAME',
                api: 's_kocisPopupService.budgKocisNormalPopup',
                app: 'Unilite.app.popup.BudgKocisNormalPopup',
                valueFieldWidth: 90,
                textFieldWidth: 140,
//                    popupWidth:936,
//                    popupHeight:650,
                pageTitle: '예산과목'
            };
        } else if (sPopItem == 'BUDG_KOCIS_NORMAL_G' ) { //KOCIS(해외문화홍보원) -  예산과목-normal 그리드
            rv = {
                xtype:'uniPopupColumn',                 // applyextparam: ADD_QUERY, ACCNT
                textFieldName:'BUDG_NAME',   
                DBtextFieldName: 'BUDG_NAME',
                api: 's_kocisPopupService.budgKocisNormalPopup',
                app: 'Unilite.app.popup.BudgKocisNormalPopup',
                pageTitle: '예산과목',
                popupWidth:500,
                popupHeight:500
                
            };
        } else if (sPopItem == 'CUST_KOCIS' ) {  //KOCIS(해외문화홍보원) -  거래처
            rv = {
                    xtype:'uniPopupField',                  // applyextparam: ADD_QUERY, ACCNT
                    valueFieldName:'CUST_CODE',
                    textFieldName:'CUST_NAME',   
                    DBvalueFieldName: 'CUSTOM_CODE',
                    DBtextFieldName: 'CUSTOM_NAME',
                    api: 's_kocisPopupService.custKocisPopup',
                    app: 'Unilite.app.popup.CustKocisPopup',
                    valueFieldWidth: 90,
                    textFieldWidth: 140,
//                        popupWidth:936,
//                        popupHeight:650,
                    pageTitle: '거래처'
                };
        } else if (sPopItem == 'CUST_KOCIS_G' ) { //KOCIS(해외문화홍보원) -  거래처 그리드
            rv = {
                xtype:'uniPopupColumn',                 // applyextparam: ADD_QUERY, ACCNT
                textFieldName:'CUST_NAME',   
                DBtextFieldName: 'CUSTOM_NAME',
                api: 's_kocisPopupService.custKocisPopup',
                app: 'Unilite.app.popup.CustKocisPopup',
                pageTitle: '거래처'
//                        popupWidth:1100,
//                        popupHeight:650
                
            };
        } else if (sPopItem == 'ART_KOCIS' ) {  //KOCIS(해외문화홍보원) -  미술품
            rv = {
                    xtype:'uniPopupField',                  // applyextparam: ADD_QUERY, ACCNT
                    valueFieldName:'ITEM_CODE',
                    textFieldName:'ITEM_NAME',   
                    DBvalueFieldName: 'ITEM_CODE',
                    DBtextFieldName: 'ITEM_NAME',
                    api: 's_kocisPopupService.artKocisPopup',
                    app: 'Unilite.app.popup.ArtKocisPopup',
                    valueFieldWidth: 90,
                    textFieldWidth: 140,
                    pageTitle: '미술품'
                };
        } else if (sPopItem == 'ART_KOCIS_G' ) { //KOCIS(해외문화홍보원) -  미술품 그리드
            rv = {
                xtype:'uniPopupColumn',                 // applyextparam: ADD_QUERY, ACCNT
                textFieldName:'ITEM_NAME',   
                DBtextFieldName: 'ITEM_NAME',
                api: 's_kocisPopupService.artKocisPopup',
                app: 'Unilite.app.popup.ArtKocisPopup',
                pageTitle: '미술품'
                
            };
        } else if (sPopItem == 'EMPLOYEE_KOCIS' ) {
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '사원',
			    valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
			    DBvalueFieldName: 'PERSON_NUMB',
			    DBtextFieldName: 'NAME',
			    api: 's_kocisPopupService.employeeKocisPopup',
			    app: 'Unilite.app.popup.EmployeeKocisPopup',
			    //popupPage: '/com/popup/bk/EmployeePopup.do',
			    popupWidth:660,
			    popupHeight:490,
			    valueFieldWidth: 90,
			    textFieldWidth: 140,
			    pageTitle: '직원조회 POPUP'
			};
		} else if (sPopItem == 'EMPLOYEE_KOCIS_G' ) {
			rv = {
				xtype:'uniPopupColumn',
			    textFieldName:'NAME',
			    DBtextFieldName: 'NAME',
			    api: 's_kocisPopupService.employeeKocisPopup',
			    app: 'Unilite.app.popup.EmployeeKocisPopup',
			    //popupPage: '/com/popup/bk/EmployeePopup.do',
			    popupWidth:660,
			    popupHeight:490,
			    pageTitle: '직원조회 POPUP'
			};
		}
				
		
       // console.log("BEFORE", rv.allowBlank, config.allowBlank)
		if (config) {
			
			if(rv.listeners)	{
            	config.listeners = Ext.apply(config.listeners, rv.listeners);
            }
            rv = Ext.apply(rv, config);
            
            console.log('uniPopup Config : ', config);
            console.log('uniPopup rv : ', rv);
        }
        //console.log("AFTER", rv.allowBlank, config)
		return rv;
				
	}
}) ;