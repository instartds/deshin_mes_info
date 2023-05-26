<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pms400rkrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="pms400rkrv"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="W" /><!-- 작업장  -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'center',
		layout : {type : 'uniTable', columns : 1},
		padding:'1 1 1 1',
		border:true,
		items: [{
	    	fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
	    	name:'DIV_CODE',
	    	xtype: 'uniCombobox',
	    	comboType:'BOR120',
	    	allowBlank:false,
	    	value: UserInfo.divCode,
    		listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('WORK_SHOP_CODE','');
				}
    		}
    	},{
			fieldLabel: '<t:message code="system.label.product.inspecdate" default="검사일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'INSPEC_DATE_FR',
			endFieldName: 'INSPEC_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			width: 315,
			allowBlank: false
		},{
			fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name: 'WORK_SHOP_CODE',
			xtype: 'uniCombobox',
			comboType:'W',
				listeners: {
                    beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                        store.clearFilter()
                        if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                                return record.get('option') == panelResult.getValue('DIV_CODE');
                            });
                        }else{
                            store.filterBy(function(record){
                                return false;
                            });
                        }
                    }

				}
		}]
    });

    Unilite.Main({
    	borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult
			]
		}],
		id  : 'pms400rkrvApp',
		fnInitBinding : function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('INSPEC_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('INSPEC_DATE_TO',UniDate.get('today'));
			UniAppManager.setToolbarButtons('print',true);
			UniAppManager.setToolbarButtons('query',false);
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			this.fnInitBinding();
		},
        onPrintButtonDown: function() {
            if(!panelResult.getInvalidMessage()) return;   //필수체크
			var param = panelResult.getValues();
			param["sTxtValue2_fileTitle"]='완제품검사현황';
			param["RPT_ID"]='pms400rkrv';
			var win = Ext.create('widget.CrystalReport', {
                url: CPATH+'/prodt/pms400crkrv.do',
                prgID: 'pms400rkrv',
                extParam: param
            });
				win.center();
				win.show();
		}
	});
};

</script>
