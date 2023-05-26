<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_afb730ukr_gl"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_afb730ukr_gl" /> 	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A132" />			<!-- 수지구분 --> 
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	Unilite.defineModel('s_afb730ukr_glModel', {
		fields:[
			{name: 'TYPE_FLAG'				, text: 'TYPE_FLAG'		, type: 'string'},
			{name: 'SEQ'					, text: '순번'			, type: 'int'},
			{name: 'BUDG_CODE'				, text: '예산코드'			, type: 'string'},
			{name: 'TRANS_DATE'				, text: '지급일'			, type: 'string'},
			{name: 'DRAFT_DATE'				, text: '기안(추산)일'		, type: 'uniDate'},
			{name: 'DRAFT_TITLE'			, text: '기안(추산)건명'	, type: 'string'},
			{name: 'CUSTOM_NAME'			, text: '거래처명'			, type: 'string'},
			{name: 'BUDG_CONF_I'			, text: '예산액'			, type: 'uniPrice'},
			{name: 'DRAFT_AMT'				, text: '기안(추산)금액'	, type: 'uniPrice'},
			{name: 'DRAFT_REMIND_AMT'		, text: '기안(추산)잔액'	, type: 'uniPrice'},
			{name: 'TRANS_AMT'				, text: '지급액'			, type: 'uniPrice'},
			{name: 'NON_PAY_AMT'			, text: '미지급액'			, type: 'uniPrice'},
			{name: 'BUDG_BALN_I'			, text: '집행잔액'			, type: 'uniPrice'}
//			{name: 'REMARK'					, text: '비고'			, type: 'string'}
	   
	   ]
	});		// End of Ext.define('s_afb730ukr_glModel', {
	  
			
	var directMasterStore = Unilite.createStore('s_afb730ukr_gldirectMasterStore',{
		model: 's_afb730ukr_glModel',
		uniOpt: {
            isMaster: true,				// 상위 버튼 연결
            editable: false,			// 수정 모드 사용
            deletable:false,			// 삭제 가능 여부
	        useNavi : false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 's_afb730ukr_glService.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
	});
	
	var panelSearch = Unilite.createForm('searchForm', {
		disabled :false
        , flex:1        
        , layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}}
	    , items :[{ 
	        	fieldLabel: '지급년월',
				xtype: 'uniMonthRangefield',  
				startFieldName: 'FR_YYYYMM',
				endFieldName: 'TO_YYYYMM',
				allowBlank:false,
				width: 315
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '소득자구분',						            		
				itemId: 'RADIO4',
				labelWidth: 90,
				items: [{
					boxLabel: '전체', 
					width: 50, 
					name: 'rdoSelect1',
					inputValue: 'dept',
					checked: true  
				},{
					boxLabel: '사업소득자', 
					width: 90, 
					name: 'rdoSelect1',
					inputValue: 'dept'
				},{
					boxLabel: '기타소득자', 
					width: 140, 
					name: 'rdoSelect1',
					inputValue: 'dept'
				}]
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
						handler : function(records) {}
			    	},{
			    		xtype: 'button',
			    		text: '취소',	
			    		width: 60,
						handler : function(records) {}
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
		id : 's_afb730ukr_gl',
		fnInitBinding : function() {
			panelSearch.setValue('FR_YYYYMM', UniDate.get('startOfYear'));
			panelSearch.setValue('TO_YYYYMM', UniDate.get('endOfYear'));
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('query',false);
		}
	});
};


</script>
