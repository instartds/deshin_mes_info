//@charset UTF-8
/**
 * @class Unilite
 * Popup 접근을 쉽게 하기 위한 함수 모음.
 */
Ext.apply(Unilite,{
	/**
	 * ## Tree Popup 설정 생성 함수. 
	 * 
	 */
	
	treePopup: function(sPopItem, config ) {
		var rv={} ;
		if (sPopItem == 'DEPTTREE' ) {		//사용자 정의 팝업
			rv = {
				xtype:'uniTreePopupField', 
				fieldLabel : '부서조직도',
			    valueFieldName:'DEPT_CODE',
			    textFieldName:'DEPT_NAME',
			    DBvalueFieldName: 'TREE_CODE',
			    DBtextFieldName: 'TREE_NAME',
			    selectChildren:true,
			    description:'DEPT_DESC',		// 필드에 입력된 건 외 표시
		    	valuesName:'DEPT_VALUES',
			    api: 'popupService.deptPopup',	// 필드 입력어 검색(Tree 아님)
                app: 'Unilite.app.popup.DeptTree',
                valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:400,
			    popupHeight:400,
			    pageTitle: '부서조직도',
			    useLike:true
			};
		} else if (sPopItem == 'PJT_TREE' || sPopItem == 'PJT_TREE_G' ) {		//사용자 정의 팝업
			rv = {
				xtype:'uniTreePopupField', 
				fieldLabel : '사업코드',
			    valueFieldName:'PJT_CODE',
			    textFieldName:'PJT_NAME',
			    DBvalueFieldName: 'PJT_CODE',
			    DBtextFieldName: 'PJT_NAME',
			    selectChildren:false,
			    description:'PJT_DESC',		// 필드에 입력된 건 외 표시
		    	valuesName:'PJT_VALUES',
			    api: 'popupService.pjtPopupW',
                app: 'Unilite.app.popup.PjtTree',
                valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:400,
			    popupHeight:400,
			    pageTitle: '사업코드',
			    useLike:true
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