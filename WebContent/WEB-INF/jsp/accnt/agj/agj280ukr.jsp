<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agj280ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 				<!-- 사업장 -->   
	<t:ExtComboStore comboType="AU" comboCode="A011" /> 	<!-- 입력경로 -->
</t:appConfig>
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}

ext-el-mask { color:gray; cursor:default; opacity:0.6; background-color:grey; }

.ext-el-mask-msg div {
	background-color: #EEEEEE;
	border-color: #A3BAD9;
	color: #222222;	
}

.ext-el-mask-msg {
	padding: 10px;
}   
</style>
<script type="text/javascript" >

function appMain() {

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
    
    var panelSearch = Unilite.createForm('searchForm', {		
		disabled :false
    ,	flex:1        
    ,	layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}}
	,	items: [{
			fieldLabel: '전표일',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'AC_DATE_FR',
	        endFieldName: 'AC_DATE_TO',
	        width: 470,
	        startDate: UniDate.get('startOfMonth'),
	        endDate: UniDate.get('today'),
	        allowBlank: false
		},{ 
			fieldLabel: '입력일',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'INPUT_DATE_FR',
	        endFieldName: 'INPUT_DATE_TO',
	        width: 470,
	        startDate: UniDate.get(''),
	        endDate: UniDate.get('')
		},{ 
			fieldLabel: '사업장',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			multiSelect: true, 
	        typeAhead: false,
			value : UserInfo.divCode,
			comboType: 'BOR120',
			width: 325
		},
			Unilite.popup('DEPT',{
		        fieldLabel: '입력부서',
		        validateBlank:false,
		        extParam:{'CUSTOM_TYPE':'3'},
			    valueFieldName:'IN_DEPT_CODE',
			    textFieldName:'IN_DEPT_NAME'
/*	        	listeners: {
					applyextparam: function(popup){							
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}*/
	    }),{
			fieldLabel: '입력경로'	,
			name:'INPUT_PATH', 
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'A011',
			width:325
		},{
			fieldLabel: '전표구분',
			xtype: 'uniCombobox',
			name: 'SLIP_DIVI',
			comboType: 'AU',
			comboCode:'A023',
			width: 172,
        	allowBlank: false,
        	value: '1'
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 3},
			width:600,
			items :[{
				fieldLabel:'회계번호', 
				xtype: 'uniTextfield',
				name: 'FR_SLIP_NUM', 
				width: 203,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						if(isNaN(newValue)){
							Ext.Msg.alert('확인','숫자만 입력가능합니다.');
							panelSearch.setValue('FR_SLIP_NUM','');
						}
					}
				}
			},{
				xtype:'component', 
				html:'~',
				style: {
					marginTop: '3px !important',
					font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
			},{
				fieldLabel:'', 
				xtype: 'uniTextfield',
				name: 'TO_SLIP_NUM', 
				width: 113,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						if(isNaN(newValue)){
							alert('확인','숫자만 입력가능합니다.');
							panelSearch.setValue('TO_SLIP_NUM','');
						}
					}
				}
			}]
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 3},
			width:600,
			items :[{
				fieldLabel:'결의번호', 
				xtype: 'uniTextfield',
				name: 'FR_EX_NUM', 
				width: 203,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						if(isNaN(newValue)){
							alert('확인','숫자만 입력가능합니다.');
							panelSearch.setValue('FR_EX_NUM','');
						}
					}
				}
			},{
				xtype:'component', 
				html:'~',
				style: {
					marginTop: '3px !important',
					font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
			},{
				fieldLabel:'', 
				xtype: 'uniTextfield',
				name: 'TO_EX_NUM', 
				width: 113,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						if(isNaN(newValue)){
							Ext.Msg.alert('확인','숫자만 입력가능합니다.');
							panelSearch.setValue('TO_EX_NUM','');
						}
					}
				}
			}]
		},
			Unilite.popup('ACCNT_PRSN',{
		        fieldLabel: '입력자',
		        validateBlank:false,
			    valueFieldName:'PRSN_CODE',
			    textFieldName:'PRSN_NAME'
	    }),{
	    	xtype: 'container',
	    	padding: '10 0 0 0',
	    	layout: {
	    		type: 'vbox',
				/*align: 'center',
				pack:'center'*/
	    	},
	    	items:[{
	    		xtype: 'button',
	    		text: '삭제',
	    		width: 100,
				margin: '10 0 5 150',
	    		handler: function(){
	    			if(!panelSearch.getInvalidMessage()){
						return false;
					}
					if(confirm(Msg.sMA0296)) {		// 삭제를 실행하시면 데이터의 복구가 불가능합니다. 그래도 삭제하시겠습니까?
						if(confirm(Msg.sMA0297)) {			// 정말 삭제 하시겠습니까?
							var param = panelSearch.getValues();
							param.TODAY_DATE = UniDate.get('today');
							Ext.getBody().mask('로딩중...','loading-indicator');
							agj280ukrService.insertMaster(param, function(provider, response)	{						
								if(provider){
									UniAppManager.updateStatus(Msg.sMB011);
								}
								Ext.getBody().unmask();
							});	
						}
					}
	    		}
	    	}]
	    }]
	});
  
    Unilite.Main( {
		items:[panelSearch],
		id  : 'agj280ukrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('query',false);
			panelSearch.onLoadSelectText('AC_DATE_FR');
		}
	});
};


</script>
	