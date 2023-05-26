<%@page language="java" contentType="text/html; charset=utf-8"%> 
	<t:appConfig pgmId="afn210ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A031" /> <!-- 어음수표구분 조건 콤보 -->
	<t:ExtComboStore comboType="AU" comboCode="A064" /> <!-- 어음처리구분 -->
</t:appConfig>
<script type="text/javascript" >
function appMain() {

	/**
	 * 지급어음수표일괄등록 Master Form
	 * 
	 * @type
	 */     
	var panelSearch = Unilite.createForm('searchForm', {	
		disabled :false,
        layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
        padding: '50 0 0 0',
	    items :[{
		 	fieldLabel: '입고일',
		 	xtype: 'uniDatefield',
		 	name: 'txtInDt',
		 	value: UniDate.get('today'),
		 	allowBlank:false
		},{ 
	 		fieldLabel: '어음/수표구분',
	 		name:'txtTag', 
	 		xtype: 'uniCombobox',
	 		comboType:'AU',
	 		comboCode:'A031',
	 		allowBlank:false,
	 		value:'1'
 		},
		Unilite.popup('BANK',{ 
	    	fieldLabel: '은행코드', 
		    valueFieldName:'txtBank',
			textFieldName:'txtBankNm',
	    	popupWidth: 350,
	    	allowBlank:false
		}),
		{
            xtype: 'container',
            defaultType: 'uniTextfield',
            layout: {type: 'hbox', align:'stretch'},
            defaults : {enforceMaxLength: true},
            width:325,
            items:[{
            	fieldLabel:'어음/수표번호', 
                name: 'txtFrNo1', 
                width:155,
                maxLength:2,
                allowBlank:false
            },{
                name: 'txtFrNo2',
                width:155,
                maxLength:8,
                allowBlank:false
         	}]
        },{
            xtype: 'container',
            defaultType: 'uniTextfield',
            layout: {type: 'hbox', align:'stretch'},
            defaults : {enforceMaxLength: true},
            width:325,
            items:[{
            	fieldLabel:' ', 
                name: 'txtToNo1', 
                width:155,
                maxLength:2,
                allowBlank:false,
                readOnly:true
            },{
                name: 'txtToNo2',
                width:155,
                maxLength:8,
                allowBlank:false
         	}]
        },{
    		xtype: 'button',
    		text: '실행',	
    		margin: '0 0 5 150',
    		width: 60,
			handler : function() {
				if(!UniAppManager.app.checkForNewDetail()){
					return false;
				}else{
					var param= panelSearch.getValues();
					
					param.txtFrNo1 = panelSearch.getValue('txtFrNo1');
					
					param.txtFrNo2 = panelSearch.getValue('txtFrNo2');
					param.txtToNo2 = panelSearch.getValue('txtToNo2');
					
					panelSearch.getForm().submit({
					params : param,
						success : function(form, action) {
			 				panelSearch.getForm().wasDirty = false;
							panelSearch.resetDirtyStatus();											
							UniAppManager.setToolbarButtons('save', false);	
			            	UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.
//			            	UniAppManager.app.onQueryButtonDown();
						}	
					});
				}
			}
    	}],
    	api: {
	 		submit: 'afn210ukrService.syncMaster'	
		},
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
   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
   					}
				   	alert(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;							
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})      
   				}
	  		} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;	
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});
	
    Unilite.Main( {
		items:[panelSearch],
		id  : 'afn210ukrApp',
		fnInitBinding : function() {
			panelSearch.setValue('txtInDt',UniDate.get('today'));
			panelSearch.setValue('txtTag','1');
			UniAppManager.setToolbarButtons('query',false);
//			UniAppManager.setToolbarButtons('reset',false);
			
			panelSearch.onLoadSelectText('txtInDt');
			
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			this.fnInitBinding();
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
        fnCheckByte: function(newValue) {
        	var i= 0;
        	var lLen = 0;
        	var lByte = 0;
        	var sChr ='';
        	
        	lLen = newValue.length;
        	
        	for (i=0; i < lLen; i++){
        		sChr = newValue.substring(i,i+1);
        		
        		if(sChr >= " " && sChr <= "~"){
        			lByte = lByte + 1;	
        		}else{
        			lByte = lByte + 2;	
        		}
        	}
        	return lByte;
        }

	});

	Unilite.createValidator('validator01', {
		forms: {'formA:':panelSearch},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			switch(fieldName) {	
				case "txtFrNo1":
					if(UniAppManager.app.fnCheckByte(newValue) < 4){
						rv="어음/수표번호의 앞 두자리는 한글로 입력하십시오."; // 추후 코드화 필요
					}else{
						panelSearch.setValue('txtToNo1',newValue);
					}
					break;
					
				case "txtFrNo2":
					if(!Ext.isNumeric(newValue)){
						rv='<t:message code = "unilite.msg.sMB074"/>';
					}
					break;
					
				case "txtToNo2":
					if(!Ext.isNumeric(newValue)){
						rv='<t:message code = "unilite.msg.sMB074"/>';
						break;
					}
					
					if(Ext.isEmpty(panelSearch.getValue('txtFrNo2')) || newValue < panelSearch.getValue('txtFrNo2')){
						rv="어음/수표번호의 범위가 맞지 않습니다."; // 추후 코드화 필요
					}
					break;
				
			}
			return rv;
		}
	});	
};


</script>
