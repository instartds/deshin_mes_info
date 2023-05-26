<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mtr130rkrv_yg"  >
   <t:ExtComboStore comboType="BOR120"  />          <!-- 사업장 -->
   <t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
   <t:ExtComboStore comboType="AU" comboCode="B024" /> <!-- 입고담당(=수불담당?) --> 
   <t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 (O) --> 
   <t:ExtComboStore comboType="AU" comboCode="M103" /> <!-- 품목계정 B004? -->
   <t:ExtComboStore comboType="AU" comboCode="M103" /> <!-- 입고유형 -->
   <t:ExtComboStore comboType="AU" comboCode="M505" /> <!-- 생성경로 --> 
   <t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 통화 -->       
   <t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
   <t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
   <t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
   <t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />   
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
	var BsaCodeInfo = {
		gsInOutPrsn: '${gsInOutPrsn}'
	};
	function appMain() {
		var panelSearch = Unilite.createSearchForm('searchForm',{
			region: 'center',
			layout : {type : 'uniTable', columns : 1},
			padding:'1 1 1 1',
			border:true,
			items:[{
				xtype: 'radiogroup',		            		
        		fieldLabel: '보고서유형',
    			items: [{
    				boxLabel: '품목별',  
    				name: 'PRINT_GB', 
                    width:70,
    				inputValue: 'S', 
    				checked: true 
    			},{
    				boxLabel: '거래처별', 
    				name: 'PRINT_GB' , 
    				inputValue: 'T'
    			}]
			},{
				fieldLabel:'사업장',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				name:'DIV_CODE',
				allowBlank:false,
				value: UserInfo.divCode
			},{
				fieldLabel:'입고일',
        		xtype: 'uniDateRangefield',
        		startFieldName: 'FR_DATE',
        		endFieldName:'TO_DATE',
        		width:315,
        		startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today')
			},{
				fieldLabel: '발주형태',
				name: 'ORDER_TYPE',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'M001'
			},Unilite.popup('AGENT_CUST', {
                fieldLabel: '거래처',
                valueFieldName: 'CUSTOM_CODE', 
                textFieldName: 'CUSTOM_NAME', 
                validateBlank:false
            }),Unilite.popup('DIV_PUMOK',{
                fieldLabel: '품목코드',
                valueFieldName: 'ITEM_CODE', 
                textFieldName: 'ITEM_NAME', 
                validateBlank: false
           }),{
	           	fieldLabel: '입고담당', 
				name: 'INOUT_PRSN', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B024'
           },{
           		fieldLabel: '입고유형',
				name: 'INOUT_TYPE_DETAIL', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'M103'
           },{
				fieldLabel: '입고창고', 
				name:'WH_CODE', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('whList')
           },{
           		fieldLabel: '품목계정', 
				name: 'ITEM_ACCOUNT', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B020'
           },{
           		fieldLabel: '대분류', 
				name: 'ITEM_LEVEL1', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
				child: 'TXTLV_L2'
           },{
           		fieldLabel: '중분류', 
				name: 'ITEM_LEVEL2', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
				child: 'TXTLV_L3'
           },{
           		fieldLabel: '소분류', 
				name: 'ITEM_LEVEL3', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('itemLeve3Store')
           }]
		});
		Unilite.Main({
			borderItems:[{
				region:'center',
				layout: 'border',
				border: true,
				items:[
					panelSearch
				]
			}],
			id  : 's_mtr130rkrv_ygApp',
			fnInitBinding : function() {
				UniAppManager.setToolbarButtons('print',true);
				UniAppManager.setToolbarButtons('query',false);
				panelSearch.setValue('DIV_CODE',UserInfo.divCode);
                panelSearch.setValue('FR_DATE',UniDate.get('startOfMonth'));
                panelSearch.setValue('TO_DATE',UniDate.get('today'));
                panelSearch.setValue('PRINT_GB','S');
			},
			onResetButtonDown: function() {
				panelSearch.clearForm();
				this.fnInitBinding();
			},
			onPrintButtonDown: function() {
                if(!panelSearch.getInvalidMessage()) return;   //필수체크
				var param = panelSearch.getValues();
				if(param.PRINT_GB=='S'){
					param.sPrintFlag = "ITEM";
					param.sPrintFlagStr = "품목별";
					param["sTxtValue2_fileTitle"]='입고현황(품목별)';
					param["RPT_ID"]='s_mtr130rkrv1_yg';
				}else{
					param.sPrintFlag = "CUSTOM";
					param.sPrintFlagStr = "거래처별";
					param["sTxtValue2_fileTitle"]='입고현황(거래처별)';
					param["RPT_ID"]='s_mtr130rkrv2_yg';
				}
				param["PGM_ID"]='s_mtr130rkrv_yg';
				param["DIV_NAME"]=panelSearch.getField('DIV_CODE').getRawValue();
				
				var win = Ext.create('widget.CrystalReport', {
                    url: CPATH+'/z_yg/s_mtr130crkrv_yg.do',
                    prgID: 's_mtr130rkrv_yg',
                    extParam: param
                });
					win.center();
					win.show();
	        	
			}
		});
	}
</script>