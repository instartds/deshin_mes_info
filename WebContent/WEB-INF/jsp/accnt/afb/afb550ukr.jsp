<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afb550ukr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="afb550ukr" /> 	<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A081" />			<!-- 매입매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A003"  /> 		<!-- 매입매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A022" /> 		<!-- 증빙유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A022" />			<!-- 증빙유형(매입일떄) -->
	<t:ExtComboStore comboType="AU" comboCode="A022" />			<!-- 증빙유형(매출일떄) -->
	<t:ExtComboStore comboType="AU" comboCode="A081" />			<!-- 부가세조정입력구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A132" />			<!-- 수지구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B042" />			<!-- 금액단위 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	Unilite.defineModel('Afb550Model1', {
		fields: [
			{name: ''					, text: ''				, type: 'string'},
			{name: ''					, text: ''				, type: 'string'},
			{name: ''					, text: ''				, type: 'string'},
			{name: ''					, text: ''				, type: 'string'},
			{name: ''					, text: ''				, type: 'string'},
			{name: ''					, text: ''				, type: 'string'},
			{name: ''					, text: ''				, type: 'string'},
			{name: ''					, text: ''				, type: 'string'}
	    ]
	});		// End of Ext.define('afb550ukrModel', {
	
	  
	/* Store 정의(Service 정의) @type
	 */					
	var MasterStore = Unilite.createStore('Afb510MasterStore',{
		model: 'Afb550Model1',
		uniOpt: {
            isMaster: true,				// 상위 버튼 연결
            editable: false,			// 수정 모드 사용
            deletable:false,			// 삭제 가능 여부
	        useNavi : false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct'
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
			
		}
	});
	
	var panelSearch = Unilite.createForm('searchForm', {
		disabled :false
        , flex:1        
        , layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}}
	    , items :[{ 
	        	fieldLabel: '예산년월',
				xtype: 'uniMonthRangefield',  
				startFieldName: 'FR_YYYYMM',
				endFieldName: 'TO_YYYYMM',
				allowBlank:false,
				width: 315,
				setDisabled: true
			},{
				xtype: 'container',
			    	padding: '10 0 0 0',
			    	layout: {
			    		type: 'hbox',
						align: 'center',
						pack:'center'
			    	},
			    	items:[{
			    		xtype: 'button',
			    		text: '실행',	
			    		width: 60,
						handler : function(records) {
							var rv = true;
							if(confirm(Msg.sMB063)) {
								var param= panelSearch.getValues();
								var me = this;
								panelSearch.getEl().mask('로딩중...','loading-indicator');
								afb550ukrService.accntCorrectBudgetbl({}, function(provider, response) {
									if(provider != null) {
										alert(Msg.sMB021);
									}
		 							panelSearch.getEl().unmask();
								});
							} else {
						   			
							}
							return rv;
						}
			    	}]
			}],
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
	});	// end panelSearch
    
    Unilite.Main({
		items:[panelSearch],
		id : 'Afb550App',
		fnInitBinding : function() {
			panelSearch.getField('FR_YYYYMM').setReadOnly(true);
			panelSearch.getField('TO_YYYYMM').setReadOnly(true);
			panelSearch.setValue('FR_YYYYMM', UniDate.get('startOfYear'));
			panelSearch.setValue('TO_YYYYMM', UniDate.get('endOfYear'));
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('query',false);
		}
	});
};
</script>
