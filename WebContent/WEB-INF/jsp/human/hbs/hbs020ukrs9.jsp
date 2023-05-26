<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'<t:message code="system.label.human.deductioncodeinfoupdate" default="지급/공제 코드등록"/>',
		id : 'hbs020ukrTab9',
		itemId: 'hbs020ukrPanel9',
		border: false,		
		xtype: 'tabpanel',
		layout: {type: 'vbox', align: 'stretch'},
		bodyCls: 'human-panel-form-background',
	    padding: '0 0 0 0',
		items:[
					  {
			         	title: '<t:message code="system.label.human.stdname" default="지급내역"/>',
			         	id: 'uniGridPanel9_2',
			         	itemId: 'uniGridPanel9_2',
			         	xtype: 'uniGridPanel',
						layout: 'fit',					
						region: 'center',
				        uniOpt:{
				        	expandLastColumn: false,
				        	useRowNumberer: true,
				            useMultipleSorting: true
				        },
				        subCode:'222',
						getSubCode: function()	{
							return this.subCode;
						},
				        store: hbs020ukrs9_2Store,
				        columns:[
//								{dataIndex: 'CODE_TYPE'     	  	,		width: 53, hidden: true},
								{dataIndex: 'WAGES_CODE'      		,		width: 60},
								{dataIndex: 'WAGES_NAME'      		,		width: 126},
								{dataIndex: 'WAGES_KIND'      		,		width: 126},
								{dataIndex: 'TAX_CODE'        		,		width: 93},
								{dataIndex: 'NON_TAX_CODE'          ,       width: 80,
                                editor: Unilite.popup('NONTAX_CODE_G',{
                                    autoPopup: true,
                                    DBtextFieldName: 'NONTAX_CODE',
                                    extParam:{
                                        'PAY_YM_FR': UniDate.getDbDateStr(UniDate.get('today')).substring(0,4)
                                    },
                                    listeners:{ 'onSelected': {
                                        fn: function(records, type  ){
                                            //var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
                                            var activeTab = panelDetail.down('#hbs020Tab').getActiveTab();
                                            var grdRecord = activeTab.down('#uniGridPanel9_2').uniOpt.currentRecord;
                                            grdRecord.set('NON_TAX_CODE',records[0]['NONTAX_CODE']);
                                            grdRecord.set('TAX_AMOUNT_LMT_I',records[0]['TAX_EXEMP_LMT']);
                                            grdRecord.set('SEND_YN',records[0]['SEND_YN']);
                                        },
                                        scope: this
                                   },
                                      'onClear' : function(type)    {
                                            var activeTab = panelDetail.down('#hbs020Tab').getActiveTab();
                                            var grdRecord = activeTab.down('#uniGridPanel9_2').uniOpt.currentRecord;
                                            grdRecord.set('NON_TAX_CODE', '');
                                            grdRecord.set('TAX_AMOUNT_LMT_I', '');
                                            grdRecord.set('SEND_YN', '');
                                      }
                                    }
                                })},
                                
                                {dataIndex: 'TAX_AMOUNT_LMT_I'      ,       width: 110},
								{dataIndex: 'INCOME_KIND'     		,		width: 93},
								{dataIndex: 'MINIMUM_WAGE'      	,       width: 90},
								{dataIndex: 'SEND_YN'               ,       width: 80},
								{dataIndex: 'EMP_TYPE'        		,		width: 80},
								{dataIndex: 'MED_TYPE'        		,		width: 80},
								{dataIndex: 'COM_PAY_TYPE'    		,		width: 80},								
								{dataIndex: 'RETR_WAGES'      		,		width: 80},
								{dataIndex: 'RETR_BONUS'         	,		width: 90},
								{dataIndex: 'ORD_WAGES'         	,		width: 80},
								
								
								{dataIndex: 'WAGES_SEQ'       		,		width: 80},
								{dataIndex: 'PRINT_SEQ'       		,		width: 80},
								{dataIndex: 'CALCU_SEQ'       		,		width: 80},
								{dataIndex: 'SORT_SEQ'        		,		width: 80},
								{dataIndex: 'USE_YN'          		,		minWidth: 80, flex: 1}
							],
						listeners:{
							edit: function(editor, e) {
								if(e.value == e.originalValue) return false;
								if(e.field == 'WAGES_CODE'){
									if(e.value == "100"){
										alert('<t:message code="system.message.human.message090" default="시스템지원 지급수당입니다. 수정이 불가능합니다."/>');
										e.record.set(e.field, e.originalValue);
										return false;
									}
								}
								if(e.field == 'TAX_CODE'){
									if(e.value == '1' || e.value == '7'){
										e.record.set('NON_TAX_CODE', '');
										e.record.set('TAX_AMOUNT_LMT_I', '');
									}
								}
								else if(e.field == 'WAGES_NAME' && !e.record.phantom){	
									if(e.record.get('WAGES_CODE') == "100"){
										alert('<t:message code="system.message.human.message090" default="시스템지원 지급수당입니다. 수정이 불가능합니다."/>');
										e.record.set(e.field, e.originalValue);
										return false;
									}
									var param = {WAGES_CODE: e.record.get('WAGES_CODE')}
									hbs020ukrService.useExistCheck9sub2(param, function(provider, response)	{
										if(provider && provider[0].COUNT > 0){
											alert('<t:message code="system.message.human.message091" default="고정금액 또는 급여에서 사용중인 코드는 수정,삭제가 불가능합니다."/>');
											e.record.set(e.field, e.originalValue);
											return false;
										}
									});
								}
							},
				          	beforeedit  : function( editor, e, eOpts ) {
								 if(e.field == "NON_TAX_CODE"){
									var sTaxCode = e.record.get('TAX_CODE');
									if(sTaxCode == "1" || sTaxCode == "7"){
										alert('<t:message code="system.message.human.message092" default="과세구분의 종류가 비과세일 경우만 선택할 수 있습니다."/>');
										return false;
									}								
								}else if(!e.record.phantom && e.field == "WAGES_CODE"){
									return false;
								}								
							}
								
						}
						
			         },
			         {
			         	title: '<t:message code="system.label.human.dedname" default="공제내역"/>',
			         	id: 'uniGridPanel9_3',
			         	itemId: 'uniGridPanel9_3',
			         	xtype: 'uniGridPanel',
						layout: 'fit',						
						region: 'center',
				        uniOpt:{	
				        	expandLastColumn: false,
				        	useRowNumberer: true,
				            useMultipleSorting: true
				        },
				        subCode:'111',
						getSubCode: function()	{
							return this.subCode;
						},			        
				        store: hbs020ukrs9_3Store,
				        columns:[
								{dataIndex: 'MAIN_CODE'            				,		width: 53, hidden: true},
								{dataIndex: 'SUB_CODE'          				,		width: 90},
								{dataIndex: 'CODE_NAME'            				,		width: 180},
								{dataIndex: 'CODE_NAME_EN'            			,		width: 90, hidden: true},
								{dataIndex: 'CODE_NAME_CN'              		,		width: 90, hidden: true},
								{dataIndex: 'CODE_NAME_JP'           			,		width: 90, hidden: true},
								{dataIndex: 'REF_CODE1'      					,		width: 100},
								{dataIndex: 'REF_CODE2'           			    ,		width: 100},
								{dataIndex: 'REF_CODE3'      					,		width: 220},
								{dataIndex: 'REF_CODE4'         			   	,		width: 73, hidden: true},
								{dataIndex: 'REF_CODE5'               			,		width: 73, hidden: true},
								{dataIndex: 'SUB_LENGTH'          				,		width: 66, hidden: true},
								{dataIndex: 'USE_YN'             				,		minWidth: 80, flex: 1},
								{dataIndex: 'SORT_SEQ'             				,		width: 66, hidden: true},
								{dataIndex: 'SYSTEM_CODE_YN'              		,		width: 66, hidden: true},
								{dataIndex: 'UPDATE_DB_USER'                	,		width: 66, hidden: true},
								{dataIndex: 'UPDATE_DB_TIME'               		,		width: 66, hidden: true},
								{dataIndex: 'COMP_CODE'                			,		width: 66, hidden: true}
							],
						listeners:{
							edit: function(editor, e) {
								
							},
				          	beforeedit  : function( editor, e, eOpts ) {
								 if((e.field == "SUB_CODE" || e.field == "CODE_NAME") && !e.record.phantom){
									return false;							
								}							
							}
								
						}
			         },
			         {
			         	title: '<t:message code="system.label.human.etc" default="기타"/>',
			         	id: 'uniGridPanel9_1',
			         	itemId: 'uniGridPanel9_1',
			         	xtype: 'uniGridPanel',
						layout: 'fit',						
						region: 'center',
				        uniOpt:{	
				        	expandLastColumn: false,
				        	useRowNumberer: true,
				            useMultipleSorting: true
				        },
				        subCode:'111',
						getSubCode: function()	{
							return this.subCode;
						},			        
				        store: hbs020ukrs9_1Store,
				        columns:[
								{dataIndex: 'MAIN_CODE'            				,		width: 53, hidden: true},
								{dataIndex: 'SUB_CODE'          				,		width: 120},
								{dataIndex: 'CODE_NAME'            				,		minWidth: 180, flex: 1},
								{dataIndex: 'CODE_NAME_EN'            			,		width: 126, hidden: true},
								{dataIndex: 'CODE_NAME_CN'              		,		width: 93, hidden: true},
								{dataIndex: 'CODE_NAME_JP'           			,		width: 93, hidden: true},
								{dataIndex: 'REF_CODE1'      						,		width: 100, hidden: true},
								{dataIndex: 'REF_CODE2'           			    ,		width: 73, hidden: true},
								{dataIndex: 'REF_CODE3'      					    ,		width: 73, hidden: true},
								{dataIndex: 'REF_CODE4'         			   	    ,		width: 73, hidden: true},
								{dataIndex: 'REF_CODE5'               			,		width: 73, hidden: true},
								{dataIndex: 'SUB_LENGTH'          				,		width: 66, hidden: true},
								{dataIndex: 'USE_YN'             					,		width: 66, hidden: true},
								{dataIndex: 'SORT_SEQ'             				,		width: 66, hidden: true},
								{dataIndex: 'SYSTEM_CODE_YN'              	,		width: 66, hidden: true},
								{dataIndex: 'UPDATE_DB_USER'                	,		width: 66, hidden: true},
								{dataIndex: 'UPDATE_DB_TIME'               	,		width: 66, hidden: true},
								{dataIndex: 'COMP_CODE'                			,		width: 66, hidden: true}
							]
			         }
			],
		listeners: {
			beforetabchange:  function ( tabPanel, newCard, oldCard, eOpts )  {		
//				if( tabCount > 0) return true; 
	     		var newTabId = newCard.getId();
	     		var isNewCardShow = true;		//newCard 보여줄것인지?
	     		var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
				switch(newTabId)	{
					case 'uniGridPanel9_2':
						if(needSave){
							isNewCardShow = false;
							Ext.Msg.show({
							     title:'<t:message code="system.label.human.confirm" default="확인"/>',
							     msg: '<t:message code="system.message.human.message074" default="내용이 변경되었습니다."/>' + "\n" + '<t:message code="system.message.human.message080" default="변경된 내용을 저장하시겠습니까?"/>',
							     buttons: Ext.Msg.YESNOCANCEL,
							     icon: Ext.Msg.QUESTION,
							     fn: function(res) {
							     	//console.log(res);
							     	if (res === 'yes' ) {
							     		var inValidRecs;
//							     		var activeStore
//							     		if(directDetailStore2.isDirty()){
//							     			inValidRecs = directDetailStore2.getInvalidRecords();
//							     			activeStore = directDetailStore2;							     			
//							     		}else if(directDetailStore3.isDirty()){
//							     			inValidRecs = directDetailStore3.getInvalidRecords();
//							     			activeStore = directDetailStore3;	
//							     		}
							     		inValidRecs = hbs020ukrs9_3Store.getInvalidRecords();
										if(inValidRecs.length > 0 )	{
											alert('<t:message code="system.message.human.message045" default="필수입력 항목입니다."/>');
										}else {
											hbs020ukrs9_3Store.saveStore(newCard);
//											tabCount = 1;											
										}
							     	}else if(res === 'no'){
//										tabCount = 1;
							     		UniAppManager.setToolbarButtons('save', false);
							     		tabPanel.setActiveTab(newCard);
							     	}else{
							     		
							     	}
							     }
							});
						}
						break;
						
					case 'uniGridPanel9_3':
						if(needSave)	{							
							isNewCardShow = false;
							Ext.Msg.show({
							     title:'<t:message code="system.label.human.confirm" default="확인"/>',
							     msg: '<t:message code="system.message.human.message074" default="내용이 변경되었습니다."/>' + "\n" + '<t:message code="system.message.human.message080" default="변경된 내용을 저장하시겠습니까?"/>',
							     buttons: Ext.Msg.YESNOCANCEL,
							     icon: Ext.Msg.QUESTION,
							     fn: function(res) {
							     	//console.log(res);
							     	if (res === 'yes' ) {
							     		var inValidRecs;
//							     		var activeStore;
//							     		if(directDetailStore1.isDirty()){
//							     			inValidRecs = directDetailStore1.getInvalidRecords();
//							     			activeStore = directDetailStore1;
//							     		}else if(directDetailStore3.isDirty()){
//							     			inValidRecs = directDetailStore3.getInvalidRecords();
//							     			activeStore = directDetailStore3;
//							     		}
							     		inValidRecs = hbs020ukrs9_2Store.getInvalidRecords();
										if(inValidRecs.length > 0 )	{
											alert('<t:message code="system.message.human.message045" default="필수입력 항목입니다."/>');
										}else {
											hbs020ukrs9_2Store.saveStore(newCard);
										}
							     	}else if(res === 'no'){
//							     		tabCount = 1;
							     		UniAppManager.setToolbarButtons('save', false);
							     		tabPanel.setActiveTab(newCard);
							     	}else{
							     		
							     	}
							     }
							});
						}
						break;						
					
					case 'uniGridPanel9_1':
						if(needSave)	{							
							isNewCardShow = false;
							Ext.Msg.show({
							     title:'<t:message code="system.label.human.confirm" default="확인"/>',
							     msg: '<t:message code="system.message.human.message074" default="내용이 변경되었습니다."/>' + "\n" + '<t:message code="system.message.human.message080" default="변경된 내용을 저장하시겠습니까?"/>',
							     buttons: Ext.Msg.YESNOCANCEL,
							     icon: Ext.Msg.QUESTION,
							     fn: function(res) {
							     	//console.log(res);
							     	if (res === 'yes' ) {
							     		var inValidRecs;
							     		var activeStore;
							     		if(hbs020ukrs9_2Store.isDirty()){
							     			inValidRecs = hbs020ukrs9_2Store.getInvalidRecords();
							     			activeStore = hbs020ukrs9_2Store;
							     		}else if(hbs020ukrs9_3Store.isDirty()){
							     			inValidRecs = hbs020ukrs9_3Store.getInvalidRecords();
							     			activeStore = hbs020ukrs9_3Store;
							     		}
										if(inValidRecs.length > 0 )	{
											alert('<t:message code="system.message.human.message045" default="필수입력 항목입니다."/>');
										}else {
											activeStore.saveStore(newCard);
										}
							     	}else if(res === 'no'){
//							     		tabCount = 1;
							     		UniAppManager.setToolbarButtons('save', false);
							     		tabPanel.setActiveTab(newCard);
							     	}else{
							     		
							     	}
							     }
							});
						}
						break;
						
					default:
						break;
				}
				return isNewCardShow;
	     	},
        	tabchange: function( tabPanel, newCard, oldCard ) {
   				if(newCard.getId() == 'uniGridPanel9_2')	{       				    	        		
	        		hbs020ukrs9_2Store.loadData({});
   				}else if(newCard.getId() == 'uniGridPanel9_3'){	
	        		hbs020ukrs9_3Store.loadData({});
   				}else if(newCard.getId() == 'uniGridPanel9_1'){
	        		hbs020ukrs9_1Store.loadData({});
   				}       			
        	}
		}
	}