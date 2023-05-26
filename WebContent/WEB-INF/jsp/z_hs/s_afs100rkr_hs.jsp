<%@page language="java" contentType="text/html; charset=utf-8"%> 
	<t:appConfig pgmId="s_afs100rkr_hs"  >
	<t:ExtComboStore comboType="BOR120"  /> 									<!-- 사업장 -->
	<!--제약조건-->
	<!--<t:ExtComboStore comboType="AU" comboCode="H032" opts='1;2;3;4'/>--> 	<!--지급구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H032" />				 			<!-- 지급구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> 						<!-- 지급일구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H011" /> 
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
var getChargeCode = ${getChargeCode};
var getStDt = ${getStDt};

	/* 급상여자동기표 Master Form
	 * 
	 * @type
	 */     
	var panelSearch = Unilite.createForm('searchForm', {	
		disabled :false,
		flex:1,
		layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
		items :[{
			 	fieldLabel: '전표일',
			 	xtype: 'uniDatefield',
			 	name: 'WORK_DATE',
		        value: UniDate.get('today'),
			 	allowBlank:false
			},{
			 	fieldLabel: '당기시작년월',
			 	xtype: 'uniMonthfield',
			 	name: 'ST_DATE',
			 	value:getStDt[0].STDT,
			 	allowBlank:false
			},{ 
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
//				multiSelect: true, 
				typeAhead: false,
				//value : UserInfo.divCode,
				comboType: 'BOR120'
			},   
			{
				xtype: 'container',
				height:3
			},	         
			{
				xtype: 'container',
				height:3
			},		   
			{
				xtype: 'container',
		    	items:[{
		    		xtype: 'button',
		    		text: '엑셀 출력',
		    		width: 120,
		    		margin: '0 0 0 100',	
					handler : function() {
						UniAppManager.app.onPrintButtonDown();
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
	
    Unilite.Main( {
		items:[panelSearch],
		id  : 's_afs100rkr_hsApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			//var gsThisStDate = getStDt[0].STDT;
			panelSearch.setValue('ST_DATE'	, getStDt[0].STDT);			// 당기시작년월
			//panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.getField('ST_DATE').focus();
			
			UniAppManager.setToolbarButtons('query',false);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			//panelSearch.setValue('ST_DATE',getStDt[0].STDT);

			var activeSForm = panelSearch;
			activeSForm.onLoadSelectText('WORK_DATE');
		},
        onPrintButtonDown: function() {
        	
        	//			var param2 = Ext.getCmp('resultForm2').getValues();			// 하단 검색조건
        	if(!panelSearch.getInvalidMessage()) return;   //필수체크
			
	       var form	= panelFileDown;
					var param	= Ext.getCmp('searchForm').getValues();
					form.submit({
						params	: param,
						success	: function() {
//									Ext.getCmp('bpr130ukrvApp').unmask();
						},
						failure: function(form, action){
//									Ext.getCmp('bpr130ukrvApp').unmask();
						}
					});
	            
	    }
	}); //End of 	Unilite.Main( {
	
		var panelFileDown = Unilite.createForm('FileDownForm', {
		url				: CPATH + '/z_hs/s_afs100rkr_hsExcelDownLoad.do',
		layout			: {type: 'uniTable', columns: 1},
		disabled		: false,
		autoScroll		: false,
		standardSubmit	: true,  
		items			: []
	});
};
</script>
