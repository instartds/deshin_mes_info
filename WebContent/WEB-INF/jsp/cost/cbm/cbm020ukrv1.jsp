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
					cbm020ukrvService.selectCopy1(param, function(responseText, response){
						var grid  = Ext.getCmp('tab_calcuBasis').down('#calcuBasisGrid1');
						grid.reset();
						cbm020ukrvStore1.loadData(responseText);
						cbm020ukrvStore1.setCheckRecord(cbm020ukrvStore1.getData().items);
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
				name:'COST_GB'
			}]
		},{	
			xtype: 'uniGridPanel',
			region:'center',
			itemId:'calcuBasisGrid1',
		    store : cbm020ukrvStore1,
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
				{dataIndex: 'AC_CODE'			, width: 80},
				{dataIndex: 'ACC_NAME'			, width: 200},
				{dataIndex: 'DEPT_CODE'			, width: 80,		hidden: hideDept},
				{dataIndex: 'DEPT_NAME'			, width: 130,		hidden: hideDept},
				{dataIndex: 'WORK_SHOP_CD'		, width: 130,		hidden: hideDept},
				{dataIndex: 'ID_GB'				, width: 100},
				{dataIndex: 'COST_GB'			, width: 110},
				{dataIndex: 'DISTR_STND_CD'		, width: 110},
				{dataIndex: 'SUM_STND_CD'		, width: 130,		hidden: true}
				
			]
		}]      
	}
