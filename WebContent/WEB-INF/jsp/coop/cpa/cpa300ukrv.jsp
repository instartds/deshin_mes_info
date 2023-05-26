<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="cpa300ukrv"  >	
	<t:ExtComboStore comboType="BOR120" pgmId="cpa300ukrv" /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="YP32"/>					<!-- 차수  -->

</t:appConfig>
<script type="text/javascript" >
///// 최종마감일이 없을시  rdo disabled처리 해야함 mrp600ukrv.htm  283줄
function appMain() { 
	var gsMonth = '';
	var orgInfo = '';
	
	var panelSearch = Unilite.createForm('cpa300ukrvDetail', {	
    	disabled :false
        , flex:1        
        , layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}}
	    , items :[{
				fieldLabel: '최종적용',
				name: 'MAX_YYYY',
				xtype: 'uniYearField',
				readOnly :true
				//value: new Date().getFullYear()
	    	}, {
				fieldLabel: '차수',
				name: 'MAX_SEQ',
				xtype : 'uniCombobox',
				comboType:'AU',
				comboCode:'YP32',
				readOnly :true
			},{
				fieldLabel: '작업년도',
				name: 'COOP_YYYY',
				xtype: 'uniYearField',
				value: new Date().getFullYear(),
				allowBlank: false
	    	},{
				fieldLabel: '차수',
				name: 'COOP_SEQ',
				xtype : 'uniCombobox',
				allowBlank: false,
				comboType:'AU',
				comboCode:'YP32'
			},{
				fieldLabel: '퇴직/졸업일자',
				name: 'GRADUATE_DATE',
				xtype : 'uniDatefield',
				value: new Date(),
				allowBlank: false
			},{
	        	xtype: 'uniTextfield',
	        	name: 'COMP_CODE',
	        	value: UserInfo.compCode,
	        	hidden: true	        	
	        },{
	        	margin: '10 0 0 40',
				xtype: 'button',
				id: 'startButton',
				text: '실행',	
	        	width: 285,
//	        	tdAttrs:{'align':'center'},							   	
				handler : function() {
					var me = this;
					if(confirm('조합원 배당작업을 실행 하시겠습니까?')){	
						me.setDisabled(true);
						panelSearch.getField('MAX_YYYY').setReadOnly(true);
						panelSearch.getField('MAX_SEQ').setReadOnly(true);
						panelSearch.getField('COOP_YYYY').setReadOnly(true);
						panelSearch.getField('COOP_SEQ').setReadOnly(true);
						panelSearch.getField('GRADUATE_DATE').setReadOnly(true);
						
						var param = panelSearch.getValues();
						panelSearch.getEl().mask('로딩중...','loading-indicator');
						cpa300ukrvService.insertMaster(param, function(provider, response)	{
							me.setDisabled(false);
							panelSearch.getField('MAX_YYYY').setReadOnly(true);
							panelSearch.getField('MAX_SEQ').setReadOnly(true);
							panelSearch.getField('COOP_YYYY').setReadOnly(false);
							panelSearch.getField('COOP_SEQ').setReadOnly(false);
							panelSearch.getField('GRADUATE_DATE').setReadOnly(false);
							if(provider){	
								UniAppManager.updateStatus(Msg.sMB011);		
							}
							panelSearch.getEl().unmask();
						});
						
						var param = {};
						cpa300ukrvService.selectMaster(param, function(provider, response)	{
							panelSearch.setValue('MAX_YYYY', provider.MAX_YYYY);
							panelSearch.setValue('MAX_SEQ', provider.MAX_SEQ);
						});
					}
					else {
						alert("조합원 배당작업을 취소 하였습니다.")
					}
   				}
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
				}
	  		}
			return r;
  		}        
	});

    Unilite.Main({
		items 	: [ panelSearch],
		id: 'cpa300ukrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('query',false);
			UniAppManager.setToolbarButtons('reset',true);
			
			panelSearch.setValue('COMP_CODE', UserInfo.compCode);
			panelSearch.setValue('COOP_YYYY', new Date().getFullYear());
			panelSearch.setValue('COOP_SEQ', 2);
			panelSearch.setValue('GRADUATE_DATE', new Date());

			var param = {};
			cpa300ukrvService.selectMaster(param, function(provider, response)	{
				panelSearch.setValue('MAX_YYYY', provider.MAX_YYYY);
				panelSearch.setValue('MAX_SEQ', provider.MAX_SEQ);
			});
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			this.fnInitBinding();
		}
	});
};
</script>
