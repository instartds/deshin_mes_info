<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bsa510ukrv" >
	<t:ExtComboStore comboType="BOR120"  /><!-- 사업장 -->
</t:appConfig>
<script type="text/javascript">
	
function appMain() {
	Unilite.defineModel('bsa510ukrvMasterModel', {

		fields : [ {name : 'USER_ID'			, text : '<t:message code="system.label.base.userid" default="사용자ID"/>'			, type : 'string'}
				 , {name : 'USER_NAME'			, text : '<t:message code="system.label.base.username" default="사용자명"/>'			, type : 'string'}
				 , {name : 'PERSON_NUMB'		, text : '<t:message code="system.label.base.personnumb" default="사번"/>'				, type : 'string'}
				 , {name : 'ERP_USER'			, text : '<t:message code="system.label.base.erpuser" default="ERP사용자"/>'			, type : 'string'}
				 , {name : 'DIV_CODE'			, text : '<t:message code="system.label.base.division" default="사업장"/>'				, type : 'string' , comboType:'BOR120'}
				 , {name : 'DEPT_CODE'			, text : '<t:message code="system.label.base.department" default="부서"/>'				, type : 'string'}
				 , {name : 'USE_YN'				, text : '<t:message code="system.label.base.useyn" default="사용여부"/>'			, type : 'string'}
				 , {name : 'REF_ITEM'			, text : '<t:message code="system.label.base.authotype" default="권한형태"/>'			, type : 'string'}
				 , {name : 'UPDATE_MAN'			, text : '<t:message code="system.label.base.updateuser" default="수정자"/>'				, type : 'string'}
				 , {name : 'UPDATE_DATE'		, text : '<t:message code="system.label.base.updatedate" default="수정일"/>'				, type : 'string'}
				 , {name : 'PWD_UPDATE_DATE'	, text : '<t:message code="system.label.base.passupdate" default="암호수정"/>'			, type : 'string'}
				 , {name : 'COMP_CODE'			, text : '<t:message code="system.label.base.companycode" default="법인코드"/>'			, type : 'string'}
				]
	});

	var directMasterStore = Unilite.createStore('bsa510ukrvMasterStore', { 
		model : 'bsa510ukrvMasterModel',
		autoLoad : false,
		uniOpt : {
        	isMaster: false,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable:false,			// 삭제 가능 여부 
            useNavi : false			// prev | next 버튼 사용
        },
		proxy : {
			type : 'direct',
			api : {
				read : 	 'bsa510ukrvService.selectList'
				
			}
		}
		,loadStoreRecords : function()	{
			var param= Ext.getCmp('bsa510ukrvSearchForm').getValues();	
			if(panelSearch.getValue('ORG_USER_ID') != '')	{					
				this.load({
					params : param
				});
			}else {
				//Unilite.messageBox(Msg.sMB216);  // fsbMsgB sMB216'원본 사용자ID를 입력하십시오'  fsbMsgH sMB216'처음 자료입니다' 둘중에  Base file id 값을 받아오지 않음.
			 	Unilite.messageBox('<t:message code="system.message.base.message023" default="원본 사용자ID를 입력하십시오."/>');
			}
		}	
	});
			
	// 검색
	var panelSearch = Unilite.createSearchForm('bsa510ukrvSearchForm',{				
		layout : {type : 'uniTable', columns : 2},
		items : [  
			{ 
				fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',		
				name : 'DIV_CODE',		
				xtype:'uniCombobox',  
				comboType : 'BOR120', 
				allowBlank:false
			},{
				xtype: 'component',      
				html: '<div id="bsa510ukrvMessage" class="x-hide-display">'+
						  '<div style="font-weight:bold; color:blue;">'+'<t:message code="system.label.base.noticse" default="※주의 : 사용자 권한을 복사하시면 기존 권한은 삭제되고 원본과 같은 권한이 생성됩니다."/>'+'</font>'+
						  '</div>'	
			}
		    ,Unilite.popup('USER',{ 
		    	fieldLabel: '<t:message code="system.label.base.originaluserid" default="원본 사용자ID"/>', 
		    	valueFieldName:'ORG_USER_ID', 
		    	textFieldName:'ORG_USER_NAME',
				allowBlank:false,	
				textFieldWidth:170, 
				valueFieldWidth:100,
				listeners : {
					'onSelected': {
						fn: function(records, type ){
							var frm = panelSearch.getForm();
	                    	frm.findField('ORG_USER_ID').setReadOnly( true );
	                    	frm.findField('ORG_USER_NAME').setReadOnly( true );
	                    	frm.findField('DIV_CODE').setReadOnly( true );
	                    },
	                    scope: this
	            	}
				}
			})     											 
			,{ 
				text: '<t:message code="system.label.base.authcopy" default="권한복사"/>',
				margin :'0 0 0 10',
				xtype: 'button',
				id:'btncopy',
				name : 'btncopy',
				disabled: true,
				handler: function() {
							var selectedUserId = new Array();
							var selectedRecord = masterGrid.getSelectedRecords();
							var me = this;
							Ext.each(selectedRecord, function(record,i){												      
						        if(record.data['USER_ID'])	{   
									selectedUserId[i] = record.data['USER_ID'];
						        }
						    }); 
						    if(selectedUserId.length <= 0) {
						    	//Ext.getCmp('btncopy').disable();
						    	Unilite.messageBox(Msg.sMB083);
						    	return;
						    }
						    if(panelSearch.getValue('ORG_USER_ID') == '' ) {
						    	//Ext.getCmp('btncopy').disable();
						    	Unilite.messageBox(Msg.sMB083);
						    	return;
						    }
						    if(confirm(Msg.sMB147))	{
					        	var param = {'ORG_USER_ID': panelSearch.getValue('ORG_USER_ID'),
					        				 'USER_ID[]' : selectedUserId};
					        	Ext.getBody().mask();
					        	bsa510ukrvService.insert(param, function(provider, response) {
					        		Ext.getBody().unmask();				
									UniAppManager.updateStatus(Msg.sMB011);
									//masterGrid.getSelectionModel().deselectAll();
								});
						    }else {
						    	return
						    }
					    }
		    	}
				,Unilite.popup('USER',{ 
					fieldLabel: '<t:message code="system.label.base.objectuserid" default="대상 사용자ID"/>',  
					textFieldWidth:170, 
					valueFieldWidth:100, 
					validateBlank:false
				}) 
				,Unilite.popup('DEPT',{ 
					textFieldWidth:170, 
					valueFieldWidth:100, 
					validateBlank:false
				}) 							  
			]
	});
	
	// create the Grid
	var masterGrid = Unilite.createGrid('bsa510ukrvMasterGrid', {
		store: directMasterStore,
		selModel: Ext.create('Ext.selection.CheckboxModel', {
    	checkOnly: true,
    	toggleOnClick: false,
    	listeners: {
    		beforedeselect: function( grid, record, index, eOpts ){
				if(this.getCount() >= 0){
					Ext.getCmp('btncopy').enable();
				}
			},
    		
			select: function(grid, record, index, eOpts ){					
				Ext.getCmp('btncopy').enable();
          	},
			deselect:  function(grid, record, index, eOpts ){
				if(this.getCount() < 1){
					Ext.getCmp('btncopy').disable();
				}
    		}
    	}
    }),
    uniOpt:{
        	onLoadSelectFirst : false
        },
		columns : [   {dataIndex : 'USER_ID',			width:100	}
					, {dataIndex : 'USER_NAME',			width:200	}
					, {dataIndex : 'PERSON_NUMB',		width:100/*,		hidden : true	*/}
					, {dataIndex : 'ERP_USER',			width:100,		hidden : true	}
					, {dataIndex : 'DIV_CODE',			width:100	}
					, {dataIndex : 'DEPT_CODE',			flex:1	}
					, {dataIndex : 'USE_YN',			width:100,		hidden : true	}
					, {dataIndex : 'REF_ITEM',			width:100,		hidden : true	}
					, {dataIndex : 'UPDATE_MAN',		width:100,		hidden : true	}
					, {dataIndex : 'UPDATE_DATE',		width:100,		hidden : true	}
					, {dataIndex : 'PWD_UPDATE_DATE',	width:100,		hidden : true	}
					, {dataIndex : 'COMP_CODE',			width:100,		hidden : true	}
				]		
	});
	
	Unilite.Main({
		items : [ panelSearch, masterGrid ]
		,fnInitBinding : function() {
			masterGrid.reset();
			panelSearch.clearForm();				
			UniAppManager.setToolbarButtons(['reset'],true);
			var frm = panelSearch.getForm();
        	frm.findField('ORG_USER_ID').setReadOnly( false );
        	frm.findField('ORG_USER_NAME').setReadOnly( false );
        	frm.findField('DIV_CODE').setReadOnly( false );
        	panelSearch.setValue('DIV_CODE',UserInfo.divCode);
		}
		, onQueryButtonDown:function() {
			masterGrid.getStore().loadStoreRecords();				
		},
		
		onResetButtonDown:function() {				
			this.fnInitBinding();
		}
	});	

	Unilite.createValidator('bsa510ukrvValidator', {
	forms: {'formA:':bsa510ukrvSearchForm},
	validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			if(fieldName == "ORG_USER_ID")	{		
					if(newValue == '')	{
						rv='<t:message code="unilite.msg.sMB216"/>';
					}
			}
			return rv;
		}
	});	

};	// appMain
</script>


