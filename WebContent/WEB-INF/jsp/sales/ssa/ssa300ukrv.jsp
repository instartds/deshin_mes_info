<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa300ukrv"  >	
	<t:ExtComboStore comboType="BOR120" pgmId="ssa300ukrv" /> 			<!-- 사업장 --> 
</t:appConfig>
<script type="text/javascript" >
///// 최종마감일이 없을시  rdo disabled처리 해야함 ssa300ukrv.htm  283줄
function appMain() { 
	var gsMonth = '';
	var orgInfo = '';
	
	var panelSearch = Unilite.createForm('bor100ukrvDetail', {
    	disabled :false
        , flex:1        
        , layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}}
	    , items :[{ 
				fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false ,
				width: 270
			}, {
				fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',            			 		       
				xtype: 'uniDatefield',
				name: 'SALE_DATE',
				allowBlank: false ,
				width: 270
		    }, {
	    		xtype: 'radiogroup',		            		
	    		fieldLabel: '<t:message code="system.label.sales.workselection" default="작업선택"/>',	
	    		id: 'rdo',
	    		items: [{
	    			boxLabel: '매출집계',
	    			width: 118,
	    			name: 'GUBUN',
	    			inputValue: 'N'
	    		}, {
	    			boxLabel: '<t:message code="system.label.sales.cancel" default="취소"/>',
	    			width: 95,
	    			name: 'GUBUN',
	    			inputValue: 'C'
	    		}],
	    		listeners: {
					change: function(field, newValue, oldValue, eOpts){
												
					}
				} 
	        },{
	        	margin: '10 0 0 40',
				xtype: 'button',
				id: 'startButton',
				text: '실행',	
	        	width: 231,
//	        	tdAttrs:{'align':'center'},							   	
				handler : function() {
					var me = this;
					panelSearch.getEl().mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');
					var param = panelSearch.getValues();
					ssa300ukrvService.insertMasterSsa300(param, function(provider, response)	{
						if(provider){
							UniAppManager.updateStatus(Msg.sMB011);							
						}
						panelSearch.getEl().unmask();
					});
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
   						var labelText = invalid.items[0]['fieldLabel']+' : ';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
   					}
				   	Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
				   	invalid.items[0].focus();
				}
	  		}
			return r;
  		}        
	});

    Unilite.Main({
		items 	: [ panelSearch],
		id: 'ssa300ukrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('query',false);
			UniAppManager.setToolbarButtons('reset',true);			
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('SALE_DATE', UniDate.add(new Date(),  {days: -1}));
			panelSearch.getField( 'GUBUN').setValue('N');
//			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
//			panelSearch.setValue('DEPT_NAME', UserInfo.deptName);			
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			this.fnInitBinding();
		}
	});
};
</script>
