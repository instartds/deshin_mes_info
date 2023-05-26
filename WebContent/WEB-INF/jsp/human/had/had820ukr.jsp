<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="had820ukr">
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL"/> 			<!-- 신고 사업장 -->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var stdDate = '${stdDate}'
	var panelSearch = Unilite.createForm('had820ukrDetail', {
		  disabled :false
		, url: CPATH+'/human/buildTaxSumitTxt'
		, standardSubmit: true
		, id: 'searchForm'
		, flex:1
		, layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}}
		, defaults: {labelWidth: 100}
		, items :[{
			xtype: 'radiogroup',
			fieldLabel: '전산매체유형',
			id: 'rdoSelect1',
			items: [{
				boxLabel: '갑종근로소득',
				width: 100,
				name: 'DATA_FLAG',
				inputValue: 'optWorkPay',
				checked: true
			},{
				boxLabel : '의료비',
				width: 70,
				name: 'DATA_FLAG',
				inputValue: 'optMedical'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(newValue.DATA_FLAG != "optWorkPay"){
						Ext.getCmp('rdoSelect3').hide();
					}else{
						Ext.getCmp('rdoSelect3').show();
					}
				}
			}
		},{
			xtype: 'radiogroup',
			fieldLabel: '제출방법',
			readOnly: true,
			id: 'rdoSelect2',
			items: [{
				boxLabel: '연간 합산제출',
				width: 100,
				name: 'SUBMIT_FLAG',
				inputValue: '1',
				checked: true
			}]
		},{
			fieldLabel: '정산년도',
			xtype: 'uniTextfield',
			name : "CAL_YEAR",
			value: UniHuman.getTaxReturnYear(),
			allowBlank: false,
			fieldStyle: 'text-align: center'
		},{
			fieldLabel: '제출년월일',
			xtype: 'uniDatefield',
			name: 'SUBMIT_DATE',
			value: new Date(),
			allowBlank: false
		},{
			fieldLabel: '홈텍스ID',
			xtype: 'uniTextfield',
			name : "HOME_TAX_ID",
			allowBlank: false
		},{
			fieldLabel: '신고사업장',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			comboCode: 'BILL',
			value:'${billDivCode}',
			allowBlank: false
		},{
			fieldLabel: '관리번호',
			xtype: 'uniTextfield',
			name:'TAX_AGENT_NO'
		},{
			xtype: 'container',
			height: 20,
			items:[{
				xtype: 'radiogroup',
				fieldLabel: '생성대상',
				id: 'rdoSelect3',
				items: [{
					boxLabel: '연말정산',
					width: 100,
					name: 'RETR_FLAG',
					inputValue: 'N'
				},{
					boxLabel : '연말 + 중도',
					width: 100,
					name: 'RETR_FLAG',
					inputValue: 'A',
					checked: true
				}]
			}]
		},{
			xtype: 'container',
			padding: '10 0 0 0',
			layout: {
				type: 'vbox',
				align: 'center',
				pack:'center'
			},
			items:[{
				width : 100,
				xtype: 'button',
				text: '실행',
				handler: function(){
					if(!panelSearch.getInvalidMessage()) {
						return;
					}
					
					var param = panelSearch.getValues();
					
					panelSearch.submit({
						success:function(form, action) {
							//alert('Success!');
						},
						failure : function(form, action) {
							//alert('Failure!');
						}
					});
				}
			}]
		}]
	});
	
	Unilite.Main({
		items:[
			panelSearch
		],
		id : 'had820ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset', 'query'], false);
			panelSearch.setValue('FR_DATE', UniHuman.fnGetTaxAdjustmentYYYYMMDD(stdDate));
		}
	});

};

</script>