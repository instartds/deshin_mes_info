<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//서비스 만족도 조회
request.setAttribute("PKGNAME","Unilite_app_gle110ukrv");
%>
<t:appConfig pgmId="gle110ukrv"  >
</t:appConfig>
<script type="text/javascript">
function appMain() {
	Ext.create('Ext.data.Store', {
		storeId:"mark",
	    fields: ['text', 'value'],
	    data : [
	        {text:"1", value:"1"},
	        {text:"2", value:"2"},
	        {text:"3", value:"3"},
	        {text:"4", value:"4"},
	        {text:"5", value:"5"}
	    ]
	});
	
	var formPanel = Unilite.createSearchForm('resultForm',{
    	region: 'center',
		layout : {type : 'uniTable', columns : 1},
		items: [{
				xtype: 'component',
				tdAttrs:{
					'height':'50px',
					'align':'center',
					'style':"font-size:24px;font-weight:bold"
				},
				html:'서비스 만족도'
			},{
				xtype: 'component',
				
				html:' &nbsp;1.&nbsp;당신이 타고 있는 버스의 기사분이 얼마나 친절합니까?'
			},{
				xtype: 'uniRadiogroup',
				name:  'KINDNESS',
				//store:  Ext.data.StoreManager.lookup('mark'),
				items:[
					{boxLabel:"1", width:40, inputValue:"1", name: 'KINDNESS'},
			        {boxLabel:"2", width:40, inputValue:"2", name: 'KINDNESS'},
			        {boxLabel:"3", width:40, inputValue:"3", name: 'KINDNESS'},
			        {boxLabel:"4", width:40, inputValue:"4", name: 'KINDNESS'},
			        {boxLabel:"5", width:40, inputValue:"5", name: 'KINDNESS', checked:true}
				],
				allowBlank:false
			},{
				xtype: 'component',
				html:'&nbsp;2.&nbsp;난폭운전을 했습니까?'
			},{
				xtype: 'uniRadiogroup',
				name: 'RECKLESS',
				//store:  Ext.data.StoreManager.lookup('mark'),
				allowBlank:false,
				items:[
					{boxLabel:"1", width:40, inputValue:"1", name: 'KINDNESS'},
			        {boxLabel:"2", width:40, inputValue:"2", name: 'KINDNESS'},
			        {boxLabel:"3", width:40, inputValue:"3", name: 'KINDNESS'},
			        {boxLabel:"4", width:40, inputValue:"4", name: 'KINDNESS'},
			        {boxLabel:"5", width:40, inputValue:"5", name: 'KINDNESS', checked:true}
				],
			},{
				xtype: 'button',
				text: '저장',
				tdAttrs:{'height':'50px','align':'center'},
				handler:function(btn, e)	{
					btn.disable();
					alert('설문에 응답해 주셔서 감사합니다 ')
				}
			}]
	});
	
                   
	                              	
      Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				 formPanel
			]
		}  	
		],
		id  : 'gle110ukrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['print'],false);
			UniAppManager.setToolbarButtons(['reset', 'excel' ],false);
		},
		
		onQueryButtonDown : function()	{
			masterStore.load();
		},
		onPrevDataButtonDown:  function()	{
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function()	{
			masterGrid.selectNextRow();
		},	
		onNewDataButtonDown:  function()	{
			masterGrid.createRow();
		},	
		
		onSaveDataButtonDown: function (config) {
			masterStore.saveStore();
					
		},
		onResetButtonDown:function() {
			var me = this;
			panelSearch.reset();
			masterGrid.reset();
			this.fnInitBinding();
		}
	});

	
	
}; // main
  
</script>