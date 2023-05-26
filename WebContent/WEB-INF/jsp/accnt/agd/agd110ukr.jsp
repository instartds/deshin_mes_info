<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="agd110ukr"  >
<t:ExtComboStore comboType="BOR120"  /> 							<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S024" /> 			<!-- 부가세유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B002" />				<!-- 법인구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B012" />				<!-- 국가코드 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> 			<!-- 자사화폐 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	/* 매출자동기표 Form
	 * 
	 * @type
	 */     
	var panelSearch = Unilite.createForm('agd110ukrvDetail', {
    	disabled :false,
    	flex:1,
    	layout: {type: 'uniTable', columns: 2, tdAttrs: {valign:'top'}},
    	items :[{
			fieldLabel: '계산서일',
	 		width: 315,
	        xtype: 'uniDateRangefield',
	        startFieldName: 'PUB_DATE_FR',
	        endFieldName: 'PUB_DATE_TO',
	        startDate: UniDate.get('startOfMonth'),
	        endDate: UniDate.get('today'),
		  	colspan: 2,
	        allowBlank: false
	     },{ 
			fieldLabel: '사업장',
			name: 'ACCNT_DIV_CODE',
			xtype: 'uniCombobox',
			multiSelect: false, 
			typeAhead: false,
			value : UserInfo.divCode,
		  	colspan: 2,
			comboType: 'BOR120'
		},		    
        	Unilite.popup('CUST',{
	        fieldLabel: '거래처',
	        validateBlank:true,
	        autoPopup:true,
		    valueFieldName:'CUSTOM_CODE_FR',
		    textFieldName:'CUSTOM_NAME_FR',
		  	colspan: 2
	    }),		    
        	Unilite.popup('CUST',{
	        fieldLabel: '~',
	        validateBlank:true,
	        autoPopup:true,
		    valueFieldName:'CUSTOM_CODE_TO',
		    textFieldName:'CUSTOM_NAME_TO',
		  	colspan: 2
	    }),{
            fieldLabel: '부가세유형',
            name: 'BILL_TYPE',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'S024',
            allowBlank: false,
			colspan: 2
		 },{
			fieldLabel: '실행일',
	        xtype: 'uniDatefield',
	 		name: 'WORK_DATE',
	 		value: UniDate.get('today'),
	 		readOnly: true,
	        allowBlank: false
	     },{
			xtype: 'radiogroup',		            		
			fieldLabel: '',
			id: 'rdoSelect',
			items: [{
				boxLabel: '계산서일', 
				width: 80, 
				name: 'PUB_DATE',
	    		inputValue: '1',
				checked: true  
			},{
				boxLabel : '실행일', 
				width: 80,
				name: 'PUB_DATE',
	    		inputValue: '2'
			}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						if(panelSearch.getValue('PUB_DATE') == '1'){
							panelSearch.getField('WORK_DATE').setReadOnly(true);
						}else{
							panelSearch.getField('WORK_DATE').setReadOnly(false);
						}
					}
				}
			 },{
				xtype: 'container',
		    	items:[{
		    		xtype: 'button',
		    		text: '실행',
		    		width: 60,
		    		margin: '0 0 0 120',	
					handler : function() {
						if(panelSearch.setAllFieldsReadOnly(true)){
							var param = panelSearch.getValues();
							param.SYS_DATE		= UniDate.getDbDateStr(UniDate.get('today'));		//시스템일자
							param.LANG_TYPE		= 'ko';												//언어구분
							param.CALL_PATH		= 'Batch';											//호출경로(Batch, List)
							param.BILL_PUB_NUM	= '';												//계산서번호/계산서발행번호
							param.KEY_VALUE		= '';												//KEY 문자열
							
							panelSearch.getEl().mask('로딩중...','loading-indicator');
							agd110ukrService.procButton(param, 
								function(provider, response) {
									if(provider) {	
										UniAppManager.updateStatus("자동기표가 완료 되었습니다.");
									}
									console.log("response",response)
									panelSearch.getEl().unmask();
								}
							)
						return panelSearch.setAllFieldsReadOnly(true);
						}
					}
		    	},{
		    		xtype: 'button',
		    		text: '취소',
		    		width: 60,
		    		margin: '0 0 0 0',                                                       
					handler : function() {
						if(panelSearch.setAllFieldsReadOnly(true)){
							var param = panelSearch.getValues();
							param.SYS_DATE		= UniDate.getDbDateStr(UniDate.get('today'));		//시스템일자
							param.LANG_TYPE		= 'ko';												//언어구분
							param.CALL_PATH		= 'Batch';											//호출경로(Batch, List)
							param.BILL_PUB_NUM	= '';												//계산서번호/계산서발행번호
							param.KEY_VALUE		= '';												//KEY 문자열
							
							panelSearch.getEl().mask('로딩중...','loading-indicator');
							agd110ukrService.cancButton(param, 
								function(provider, response) {
									if(provider) {	
										UniAppManager.updateStatus("취소 되었습니다.");
									}
									console.log("response",response)
									panelSearch.getEl().unmask();
								}
							)
							return panelSearch.setAllFieldsReadOnly(true);
						}
					}
	    		}]
			}
		],
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
					//this.mask();		    
	   			}
		  	} else {
				this.unmask();
			}
			return r;
		}
	});

    /**
	 * main app
	 */
    Unilite.Main( {
		id  : 'agd110ukrvApp',
		items 	: [ panelSearch],
		fnInitBinding : function() {
			//공통코드(S024)에서 부가세 유형콤보 첫번째 값 가져오기
			if(Ext.data.StoreManager.lookup('CBS_AU_S024').data.length != 0) {
	      		var billTypeSelect = Ext.data.StoreManager.lookup('CBS_AU_S024').getAt(0).get('value');
				panelSearch.setValue('BILL_TYPE', billTypeSelect);
				
			} else {
				alert('매출 부가세 유형을 등록해 주시기 바랍니다.');
			}
/*			//공통코드(S024)첫 번째 값(billTypeSelect)의 ref2값(Subcode값)
 			var sRefCode2 = UniAppManager.app.fnGetSubCode(null, billTypeSelect);		*/
			UniAppManager.setToolbarButtons('query',false);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			var activeSForm = panelSearch;
			activeSForm.onLoadSelectText('PUB_DATE_FR');
		}
	});
}
</script>
