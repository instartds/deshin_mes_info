<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'신용카드정보등록',
		border: false,
		
		xtype: 'uniDetailForm',
		layout: {type: 'vbox', align: 'stretch'},
		items:[
				Unilite.popup('ITEM',{
				fieldLabel: '신용카드', 
//				textFieldWidth: 170, 
				validateBlank: false
						
		}),{			
			layout: {type: 'hbox', align: 'stretch'},
			flex: 1,
			xtype: 'container',
			items: [{				
				xtype: 'uniGridPanel',
				
				layout: 'fit',
			    store : aba070ukrs1Store,
			    uniOpt: {
			    	expandLastColumn: true,
			        useRowNumberer: true,
			        useMultipleSorting: false
				},		        
				columns: [{dataIndex: 'CRDT_NUM'      	,		width: 120 },
						  {dataIndex: 'CRDT_NAME'		,		width: 120},
						  {dataIndex: 'CRDT_FULL_NUM'	,		width: 120,hidden: true},
						  {dataIndex: 'PERSON_NUMB'		,		width: 100,hidden: true},
						  {dataIndex: 'CRDT_DIVI'     	,		width: 100,hidden: true},
						  {dataIndex: 'NAME'          	,		width: 133,hidden: true},
						  {dataIndex: 'EXPR_DATE'    	,		width: 66, hidden: true},
						  {dataIndex: 'BANK_CODE'	    ,		width: 66, hidden: true},
						  {dataIndex: 'BANK_NM'  		,		width: 133,hidden: true},
						  {dataIndex: 'ACCOUNT_NUM'   	,		width: 133,hidden: true},
						  {dataIndex: 'SET_DATE'      	,		width: 66, hidden: true},
						  {dataIndex: 'CRDT_COMP_CD'	,		width: 66, hidden: true},
						  {dataIndex: 'CRDT_COMP_NM'	,		width: 66, hidden: true},
						  {dataIndex: 'UPDATE_DB_USER'	,		width: 66, hidden: true},
						  {dataIndex: 'UPDATE_DB_TIME'	,		width: 66, hidden: true},
						  {dataIndex: 'USE_YN'			,		width: 66, hidden: true},
						  {dataIndex: 'CRDT_KIND'		,		width: 66, hidden: true},
						  {dataIndex: 'CANC_DATE'		,		width: 66, hidden: true},
						  {dataIndex: 'REMARK'			,		width: 66, hidden: true},
						  {dataIndex: 'LIMIT_AMT'		,		width: 66, hidden: true},
						  {dataIndex: 'CRDT_GBN'		,		width: 66, hidden: true},
						  {dataIndex: 'COMP_CODE'		,		width: 66, hidden: true}				  
				]						
			}, {
				xtype: 'splitter',
				size: 3
			}, {
				xtype:'container',
				padding: '0 20 0 20',
				autoScroll: true,
   				border: false,
				layout: {type: 'uniTable', columns: 1},
				items: [{
					border: false,
					layout: {type: 'uniTable', columns: 2},
					items:[{
						border: false,
						html: "<font color= 'blue'><b>신용카드정보</b></font>",
						colspan: 2
					}, {
						fieldLabel: '법인/개인구분',
						name: 'A098',
						xtype: 'uniCombobox',
						comboType: 'AU',
						comboCode: 'A010',
						allowBlank: false,
						colspan: 2
					}, {
						fieldLabel: '카드종류',
						name: 'A010',
						xtype: 'uniCombobox',
						comboType: 'AU',
						comboCode: 'A028',
						allowBlank: false,
						colspan: 2
					}, {
						fieldLabel: '카드명',
						name: '',
						xtype: 'uniTextfield',
						allowBlank: false,
						colspan: 2
					}, {
						fieldLabel: '카드코드',
						name: '',
						xtype: 'uniTextfield',
						allowBlank: false
					}, {
						html: '(신용카드POPUP이나 전표입력시 코드로 사용)',
						border: false
					}, {
						fieldLabel: '카드번호(Full Number)',
						labelWidtn: 150,
						name: '',
						xtype: 'uniTextfield',
						allowBlank: false
					}, {
						html: '(부가세신고와 브랜치법인카드와 연계시 사용)',
						border: false
					}, {
						fieldLabel: '유효년월',
						name: '',
						xtype: 'uniTextfield',
						colspan: 2
					}, {
						fieldLabel: '사번',
						name: '',
						xtype: 'uniTextfield',
						colspan: 2
					}, {
						fieldLabel: '성명',
						name: '',
						xtype: 'uniTextfield',
						colspan: 2
					}, {
						fieldLabel: '카드구분',
						name: 'A010',
						xtype: 'uniCombobox',
						comboType: 'AU',
						comboCode: 'A098',
						allowBlank: false,
						colspan: 2
					}, {
						fieldLabel: '사용유무',
						name: 'A010',
						xtype: 'uniCombobox',
						comboType: 'AU',
						comboCode: 'A004',
						allowBlank: false,
						colspan: 2
					}, {
						fieldLabel: '해지일',
						xtype: 'uniDatefield',
						name: '',
						colspan: 2					
					}, {
						fieldLabel: '비고',
						name: '',
						xtype: 'uniTextfield',
						width: 400,
						colspan: 2
					}]
				}, {
					border: false,
					layout: {type: 'uniTable', columns: 1},
					items:[{
						border: false,
						html: "<font color= 'blue'><b>결제은행정보</b></font>",
						colspan: 2
					}, {
						fieldLabel: '은행코드',
						name: '',
						xtype: 'uniTextfield',
						colspan: 2
					}, {
						fieldLabel: '은행명',
						name: '',
						xtype: 'uniTextfield',
						width: 400,
						colspan: 2
					}, {
						fieldLabel: '계좌번호',
						name: '',
						xtype: 'uniTextfield',
						colspan: 2
					}, {
						fieldLabel: '결제일',
						name: '',
						xtype: 'uniTextfield',
						suffixTpl: '일',
						colspan: 2
					},
						Unilite.popup('ITEM',{
						fieldLabel: '신용카드사', 
//						textFieldWidth: 170, 
						validateBlank: false
					})]
				}]				
			}]
		}]
	}