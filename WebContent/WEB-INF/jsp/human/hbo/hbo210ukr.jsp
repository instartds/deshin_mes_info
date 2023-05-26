<%@page language="java" contentType="text/html; charset=utf-8"%>
	    
<t:appConfig pgmId="hbo210ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="H032" opts= '${gsList1}' /> <!-- 상여구분 --> 
</t:appConfig>	
<script type="text/javascript" >

function appMain() {
	var gsList1 = '${gsList1}';					//지급구분 '1'이 아닌 것만 콤보에서 보이도록 설정
	
	/* Model 정의 
	 * @type 
	 */
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	
	/* 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createForm('searchForm', {		
		disabled :false,
    	flex:1,
    	layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
		items: [{
			fieldLabel	: '지급년월',
			xtype		: 'uniMonthfield',
    		value		: UniDate.get('today'),
			name		: 'PAY_YYYYMM',                    
			id			: 'PAY_YYYYMM',
			labelWidth	: 115,
			allowBlank	: false
		},{
			fieldLabel	: '상여구분',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H032',
			value		: '2',
			name		: 'SUPP_TYPE',
			id			: 'SUPP_TYPE',
			labelWidth	: 115,
			allowBlank	: false
		},{
			fieldLabel	: '지급일',
			xtype		: 'uniDatefield',
			name		: 'SUPP_DATE',			                 
			labelWidth	: 115,
			allowBlank	: false
		},{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE', 
			labelWidth	: 115,
			xtype		: 'uniCombobox',
			comboType	: 'BOR120'
		},
		Unilite.popup('DEPT', { 
			fieldLabel		: '부서', 
			valueFieldName	: 'FR_DEPT_CODE',
			textFieldName	: 'FR_DEPT_NAME',
			holdable		: 'hold',
			labelWidth		: 115,
			listeners		: {
//		    	onValueFieldChange: function(field, newValue){
//					panelResult.setValue('DEPT_CODE', newValue);	
//				},
//				onTextFieldChange: function(field, newValue){
//					panelResult.setValue('DEPT_NAME', newValue);	
//				}
			}
		}),
		Unilite.popup('DEPT', { 
            fieldLabel      : '~', 
            valueFieldName  : 'TO_DEPT_CODE',
            textFieldName   : 'TO_DEPT_NAME',
            holdable        : 'hold',
            labelWidth      : 115,
            listeners       : {
//              onValueFieldChange: function(field, newValue){
//                  panelResult.setValue('DEPT_CODE', newValue);    
//              },
//              onTextFieldChange: function(field, newValue){
//                  panelResult.setValue('DEPT_NAME', newValue);    
//              }
            }
        })/*,
			Unilite.treePopup('DEPTTREE',{
			fieldLabel		: '부서',
			valueFieldName	: 'DEPT',
			textFieldName	: 'DEPT_NAME' ,
			valuesName		: 'DEPTS' ,
			DBvalueFieldName: 'TREE_CODE',
			DBtextFieldName	: 'TREE_NAME',
			labelWidth		: 115,
			selectChildren	: true,
		    autoPopup		: true,
			validateBlank	: false,
			useLike			: true
		})*/,{
			fieldLabel		: '급여지급방식',
			name			: 'PAY_CODE', 
			labelWidth		: 115,
			xtype			: 'uniCombobox',
			comboType		: 'AU',
			comboCode		: 'H028'
		},{
			fieldLabel		: '지급차수',
			name			: 'PAY_PROV_FLAG', 
			labelWidth		: 115,
			xtype			: 'uniCombobox',
			comboType		: 'AU',
			comboCode		: 'H031'
		},
	      	Unilite.popup('Employee',{
	      	fieldLabel 		: '사원',
			labelWidth		: 115,
		    valueFieldName	: 'PERSON_NUMB',
		    textFieldName	: 'NAME',
		    autoPopup		: true,
			validateBlank	: false,
			listeners: {
                    onSelected: {
                        fn: function(records, type) {
                           
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelSearch.setValue('PERSON_NUMB', '');
                        panelSearch.setValue('NAME', '');
                    }
			}
  		}),{ 
			fieldLabel		: '세금정산기간',
	        xtype			: 'uniMonthRangefield',
	        startFieldName	: 'BASE_DT_FR',
    		endFieldName	: 'BASE_DT_TO',
			labelWidth		: 115
// 		        startDate: UniDate.get('startOfMonth'),
// 		        endDate: UniDate.get('today')
        },{
			xtype			: 'radiogroup',		            		
			fieldLabel		: '세금정산대상',						            		
			id				: 'OPT_TAX_PAY',
			labelWidth		: 115,
			items: [{
				boxLabel	: '급여', 
				name		: 'OPT_TAX_PAY',
				inputValue	: 'PAY',
				width		: 120, 
				checked: true
			},{
				boxLabel	: '급여 + 상여', 
				name		: 'OPT_TAX_PAY',
				inputValue	: 'ALL', 
				width		: 120
			}]
		},{
			xtype			: 'radiogroup',		            		
			fieldLabel		: '세금계산여부',						            		
			id				: 'CALC_TAX',
			labelWidth		: 115,
			items: [{
				boxLabel	: '계산함', 
				name		: 'CALC_TAX',
				inputValue	: 'Y',
				width		: 120, 
				checked		: true
			},{
				boxLabel	: '계산안함', 
				name		: 'CALC_TAX',
				inputValue	: 'N' ,
				width		: 70
			}]
		},{
			xtype			: 'radiogroup',		            		
			fieldLabel		: '고용보험계산여부',						            		
			id				: 'OPT_HIR_CALCUY', 
			labelWidth		: 115,
			items: [{
				boxLabel	: '계산함', 
				name		: 'OPT_HIR_CALCUY',
				inputValue	: 'Y',
				width		: 120, 
				checked		: true
			},{
				boxLabel	: '계산안함', 
				name		: 'OPT_HIR_CALCUY',
				inputValue	: 'N',
				width		: 120
			}]
		},{
			xtype			: 'radiogroup',		            		
			fieldLabel		: '퇴직평균임금계산에',						            		
			id				: 'CHK_RETR_FLAGY',
			labelWidth		: 115,
			items: [{
				boxLabel	: '포함함', 
				name		: 'CHK_RETR_FLAGY',
				inputValue	: 'Y',
				width		: 120, 
				checked		: true
			},{
				boxLabel	: '포함안함', 
				name		: 'CHK_RETR_FLAGY',
				inputValue	: 'N',
				width		: 120
			}]
		},{
			fieldLabel		: '평균임금반영율',
    		xtype			: 'uniTextfield',
    		name			: 'BONUS_AVG_RATE',
    		suffixTpl		: '%',
    		fieldStyle      : 'text-align: center;',
			labelWidth		: 115,
    		value			: '100'
		},{
			xtype			: 'radiogroup',		            		
			fieldLabel		: '월정급여액에',						            		
			id				: 'COM_PAY_FLAG',
			labelWidth		: 115,
			items: [{
				boxLabel	: '포함함', 
				name		: 'COM_PAY_FLAG',
				inputValue	: 'Y',					
				width		: 70
			},{
				boxLabel	: '포함안함', 
				name		: 'COM_PAY_FLAG',
				inputValue	: 'N',
				width		: 120,
				checked		: true/*,
				listeners:{
					onTextSpecialKey: function(elm, e){
	                    if (e.getKey() == e.ENTER) {
	                    	panelSearch.getField('PERSON_NUMB').focus();  
	                	}
	                }
				}*/
			}]
		},{
	    	xtype		: 'container',
	    	layout: {
	    		type	: 'vbox',
				align	: 'center',
				pack	: 'center'
	    	},
	    	items:[{
	    		xtype	: 'button',
	    		text	: '실행',
	    		layout	: {align: 'center'},
	    		width	: 100,
	    		handler	: function(){
					if (panelSearch.isValid()) {
		    			if(confirm('상여 계산을 실행합니다.\n실행 하시겠습니까?')){
		    				runProc();
		    			}		    	
					} else {
						var invalid = panelSearch.getForm().getFields().filterBy(function(field) {
							return !field.validate();
						});
						if (invalid.length > 0) {
							r = false;
							var labelText = ''
				
							if (Ext.isDefined(invalid.items[0]['fieldLabel'])) {
								var labelText = invalid.items[0]['fieldLabel']
										+ '은(는)';
							} else if (Ext.isDefined(invalid.items[0].ownerCt)) {
								var labelText = invalid.items[0].ownerCt['fieldLabel']
										+ '은(는)';
							}		
							Ext.Msg.alert('확인', labelText + Msg.sMB083);
							invalid.items[0].focus();
						}
					}
	    		}
	    	}]
	    }]
	});    
	
	//상여계산
	function runProc() {		
		var param= Ext.getCmp('searchForm').getValues();

		panelSearch.getEl().mask('급여계산 중...','loading-indicator');
		hbo210ukrService.spCalcPay(param, function(provider, response)	{
			if(!Ext.isEmpty(provider))	{
				alert(Msg.sMH947)										//급여작업이 완료되었습니다.
			}
			panelSearch.getEl().unmask();						
		});	
	}

	
		
		
    /* Master Grid1 정의(Grid Panel)
     * @type 
     */
    Unilite.Main( {
		id				: 'hbo210ukrApp',
		items			: [ panelSearch ],
		
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('query',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			//상여구분 설정
			var store = Ext.getStore('CBS_AU_H032');						
			var selectedModel = store.getRange();
			Ext.each(selectedModel, function(record,i){       
				if (record.data.value == '1' || record.data.value == 'F'||record.data.value == 'G'||record.data.value == 'L'||record.data.value == 'M') {							    	
					store.remove(record);							    	  							    	  
				}			       
			});
			var combo = Ext.getCmp('SUPP_TYPE');
			console.log("combo",combo);
			combo.bindStore('CBS_AU_H032');
			
			//초기화 시 전표일로 포커스 이동
			panelSearch.onLoadSelectText('PAY_YYYYMM');
		}
	});

};


</script>
			