<%@page language="java" contentType="text/html; charset=utf-8"%>

	{
		title	: '월별배부기준등록',
		itemId	: 'tab_calcuBasis',
		id		: 'tab_calcuBasis',
		xtype	: 'panel',
		layout	: 'border',
		bodyStyle	: {
			'background-color': '#ffffff'
		},
		items	: [{
			xtype: 'uniSearchForm',
			itemId:'calcuBasisSearch1',
			region:'north',
			layout:{type:'uniTable', columns:'3'},
			items:[{
				xtype:'uniCombobox',
				comboType:'BOR120',
				fieldLabel:'사업장',
				name:'DIV_CODE',
				value:UserInfo.divCode
			},{
				xtype:'uniMonthfield',
				comboType:'BOR120',
				fieldLabel:'기준년월',
				labelWidth:120,
				name:'WORK_MONTH',
				value:UniDate.get('today')
			},{
				xtype:'uniTextfield',
				
				fieldLabel:'전월복사여부',
				labelWidth:120,
				name:'isCopy',
				value:'N',
				hidden:true
			},{
				xtype:'button',
				text:'전월데이타복사',
				tdAttrs:{align:'right', width:200},
				handler:function(){
					var form  = Ext.getCmp('tab_calcuBasis').down('#calcuBasisSearch1');
					var param = form.getValues();
					param.PREV_MONTH = UniDate.getMonthStr(UniDate.add(form.getValue('WORK_MONTH'), {'months':-1}));
					cbm050ukrvService.selectCopy1(param, function(responseText, response){
						var grid  = Ext.getCmp('tab_calcuBasis').down('#calcuBasisGrid1');
						grid.reset();
						cbm050ukrvStore1.loadData(responseText);
						cbm050ukrvStore1.setCheckRecord(cbm050ukrvStore1.getData().items);
						form.setValue('isCopy', 'Y');
					});
				}
			},
			Unilite.popup('ACCNT',{}),{
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'C007',
				fieldLabel:'노무비/경비구분',
				labelWidth:120,
				name:'COST_GB',
				value:UserInfo.divCode
			}]
		},{	
			xtype: 'uniGridPanel',
			region:'center',
			itemId:'calcuBasisGrid1',
		    store : cbm050ukrvStore1,
		    uniOpt: {			
			    useMultipleSorting	: true,		
			    useLiveSearch		: true,		
			    onLoadSelectFirst	: true,			
			    dblClickToEdit		: true,		
			    useGroupSummary		: false,		
				useContextMenu		: false,	
				useRowNumberer		: true,	
				expandLastColumn	: false,		
				useRowContext		: false,	
				copiedRow			: false,
			    filter: {				
					useFilter		: false,
					autoCreate		: false
				}			
			},		        
			columns: [
	 			{dataIndex: 'COMP_CODE'			, width: 100,		hidden: true},
				{dataIndex: 'DIV_CODE'			, width: 100,		hidden: true},
				{dataIndex: 'WORK_MONTH'		, width: 100,		hidden: true},
				{dataIndex: 'AC_DIVI'			, width: 80},
				{dataIndex: 'ACCNT'				, width: 80},
				{dataIndex: 'ACCNT_NAME'		, width: 130},
	    		{dataIndex: 'COST_CENTER_CODE'	, width: 120},
	    		{dataIndex: 'COST_CENTER_NAME'	, width: 140},
		    	{text:'집계정보',
		    	 columns:[
		    		{dataIndex: 'SUM_STND_CD'		, width: 140},
					{dataIndex: 'AMT_STND_CD'		, width: 100},
					{dataIndex: 'MANAGE_CODE1'		, width: 110},
					{dataIndex: 'MANAGE_CODE2'		, width: 110},
					{dataIndex: 'INOUT_TYPE_DETAIL'	, width: 110}
				 ]
				},
				{text:'배부정보',
		    	 columns:[
		    	 	{dataIndex: 'DISTR_STND_CD'		, width: 130},
					{dataIndex: 'CP_DIRECT_YN'		, width: 100},
					{dataIndex: 'DISTR_REFER_CD'	, width: 130}
				 ]
				},
				{text:'원가정보',
		    	 columns:[
					{dataIndex: 'ID_GB'				, width: 100},
					{dataIndex: 'COST_GB'			, width: 110}
				 ]}
			]
		}]      
	}
