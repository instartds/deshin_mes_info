<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_externalDBskrv_wm">
	<t:ExtComboStore comboType="BOR120"/>					<!-- 사업장 -->
	<t:ExtComboStore comboType="WU"/>						<!-- 작업장-->
	<t:ExtComboStore comboType="W"/>						<!-- 작업장 (전체)-->
	<t:ExtComboStore comboType="AU" comboCode="S011"/>		<!-- 주문상태(기존 마감/미마감에서 - 마감 flag에 '취소' 설정) -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
	.x-component.x-html-editor-input.x-box-item.x-component-default {
		border-top: 1px solid #b5b8c8;
	}
</style>
<script type="text/javascript" >

function appMain() {
	/* 조회조건
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region		: 'center',
		layout		: {type : 'uniTable', columns : 2
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding		: '1 1 1 1',
		border		: true,
		items		: [{
			xtype : 'button',
			text :'List TEST',
			handler:function()	{
				s_extDBTemplate_wmService.selectList({'PARAM1' : '01'}, function(responseText){
					console.log("responseText : ", responseText);
					panelResult.setValue("test1", Ext.JSON.encode(responseText));
				});
			}
		},{
			xtype : 'textarea',
			name  : 'test1',
			width : 500,
			height : 50
		},{
			xtype : 'button',
			text :'Select TEST',
			handler:function()	{
				s_extDBTemplate_wmService.selectMaster({'PARAM1' : '01'}, function(responseText){
					console.log("responseText : ", responseText);
					panelResult.setValue("test2", Ext.JSON.encode(responseText));
				});
			}
		},{
			xtype : 'textarea',
			name  : 'test2',
			width : 500,
			height : 50
		},{
			xtype : 'button',
			text :'Update TEST',
			handler:function()	{
				s_extDBTemplate_wmService.update([{'PARAM1' : '01'}], function(responseText){
					console.log("responseText : ", responseText);
					panelResult.setValue("test13", Ext.JSON.encode(responseText));
				});
			}
		},{
			xtype : 'textarea',
			name  : 'test3',
			width : 500,
			height : 50
		}]
	});


	Unilite.Main({
		id			: 's_externalDBskrv_wm',
		borderItems : [
				panelResult
		],
		fnInitBinding : function(params) {
			this.setDefault();
		},
		setDefault: function() {
			
		},
		onQueryButtonDown: function () {
			
		},
		onResetButtonDown: function() {
			
		}
	});
};
</script>