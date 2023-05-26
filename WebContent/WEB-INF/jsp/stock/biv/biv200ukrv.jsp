<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biv200ukrv"  >	
	<t:ExtComboStore comboType="BOR120" pgmId="biv200ukrv" /> 			<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
</t:appConfig>
<script type="text/javascript" >
///// 최종마감일이 없을시  rdo disabled처리 해야함 biv200ukrv.htm  283줄
function appMain() { 
	var gsMonth = '';
	var orgInfo = '';
	var gsWhCode = '';		//창고코드
	
	var panelSearch = Unilite.createForm('bor100ukrvDetail', {
		
    	disabled :false
        , flex:1        
        , layout: {type: 'uniTable', columns: 2, tdAttrs: {valign:'top'}}
        , defaults:{colspan: 2}
	    , items :[{ 
				fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				child:'WH_CODE',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts){
												
					}
				} 
			}, {
				xtype: 'uniMonthfield',
				fieldLabel: '매출년월',
				name: 'BASIS_YYMM',
				allowBlank: false
			},
			Unilite.popup('DEPT', { 
				fieldLabel: '부서', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							gsWhCode = records[0]['WH_CODE'];
							var whStore = panelSearch.getField('WH_CODE').getStore();							
							console.log("whStore : ",whStore);							
							whStore.clearFilter(true);
							whStore.filter([
								 {property:'option', value:panelSearch.getValue('DIV_CODE')}
								,{property:'value', value: records[0]['WH_CODE']}
							]);
							panelSearch.getField('WH_CODE').setValue(records[0]['WH_CODE']);
                    	},
						scope: this
					},
					onClear: function(type)	{
						
					},
					applyextparam: function(popup){							
						var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
						var deptCode = UserInfo.deptCode;	//부서정보
						var divCode = '';					//사업장
						
						if(authoInfo == "A"){	//자기사업장	
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							
						}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							
						}else if(authoInfo == "5"){		//부서권한
							popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}
					}
				}
			}),{
				name: 'WH_CODE',
				fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>', 
				xtype:'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList')
			},{
	        	margin: '0 0 0 55',
				xtype: 'button',
				id: 'startButton',
				text: '<t:message code="system.label.inventory.execute" default="실행"/>',	
	        	width: 80,
	        	colspan: 1,
//	        	tdAttrs:{'align':'center'},							   	
				handler : function() {
					if(!panelSearch.setAllFieldsReadOnly(true)){
			    		return false;
			    	}
					var param = {
						COMP_CODE: UserInfo.compCode,
						DIV_CODE: panelSearch.getValue('DIV_CODE'),
						BASIS_YYMM: UniDate.getDbDateStr(panelSearch.getValue('BASIS_YYMM')).substring(0, 6),
						DEPT_CODE: Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))? '' : panelSearch.getValue('DEPT_CODE'),
						WH_CODE: Ext.isEmpty(panelSearch.getValue('WH_CODE'))? '' : panelSearch.getValue('WH_CODE'),
						GUBUN: 'E',
						USER_ID: UserInfo.userID
					}
					panelSearch.getEl().mask('<t:message code="system.label.inventory.loading" default="로딩중..."/>','loading-indicator');
					biv200ukrvService.insertMaster(param, function(provider, response)	{							
						if(provider){	
							UniAppManager.updateStatus(Msg.sMB011);
						}
						panelSearch.getEl().unmask();						
					});
   				}
			},{
	        	margin: '0 0 0 2',
				xtype: 'button',
				id: 'cancelButton',
				text: '취소',	
	        	width: 80,
//	        	tdAttrs:{'align':'center'},							   	
				handler : function() {
					if(!panelSearch.setAllFieldsReadOnly(true)){
			    		return false;
			    	}
			    	
					var param = {
						COMP_CODE: UserInfo.compCode,
						DIV_CODE: panelSearch.getValue('DIV_CODE'),
						BASIS_YYMM: UniDate.getDbDateStr(panelSearch.getValue('BASIS_YYMM')).substring(0, 6),
						DEPT_CODE: Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))? '' : panelSearch.getValue('DEPT_CODE'),
						WH_CODE: Ext.isEmpty(panelSearch.getValue('WH_CODE'))? '' : panelSearch.getValue('WH_CODE'),
						GUBUN: 'C',
						USER_ID: UserInfo.userID
					}
					var me = this;
					me.setDisabled(true);
					panelSearch.down('#startButton').setDisabled(true);
					panelSearch.getField('DIV_CODE').setReadOnly(true);
					panelSearch.getField('BASIS_YYMM').setReadOnly(true);
					panelSearch.getField('DEPT_CODE').setReadOnly(true);
					panelSearch.getField('DEPT_NAME').setReadOnly(true);
					panelSearch.getField('WH_CODE').setReadOnly(true);
					biv200ukrvService.insertMaster(param, function(provider, response)	{							
						if(provider){	
							UniAppManager.updateStatus(Msg.sMB011);					
						}
						me.setDisabled(false);
						panelSearch.down('#startButton').setDisabled(false);
						panelSearch.down('#cancelButton').setDisabled(false);
						panelSearch.getField('DIV_CODE').setReadOnly(false);
						panelSearch.getField('BASIS_YYMM').setReadOnly(false);
						panelSearch.getField('DEPT_CODE').setReadOnly(false);
						panelSearch.getField('DEPT_NAME').setReadOnly(false);
						panelSearch.getField('WH_CODE').setReadOnly(false);
					});
				}
			}
			
	    
        ],		
		    setAllFieldsReadOnly: function(b) {
				var r= true
				if(b) {
					var invalid = this.getForm().getFields().filterBy(function(field) {
																		return !field.validate();
																	});
	   				if(invalid.length > 0) {
						r=false;
	   					var labelText = ''
	   	
						if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
	   						var labelText = invalid.items[0]['fieldLabel']+' : ';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
	   					}	
					   	alert(labelText+Msg.sMB083);
					   	invalid.items[0].focus();
					}
		  		}
				return r;
	  		}        
	});

    Unilite.Main({
		items 	: [ panelSearch],
		id: 'biv200ukrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons(['query', 'detail', 'reset'],false);			
			panelSearch.setValue('BASIS_YYMM', UniDate.get('today'));
        	biv200ukrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('WH_CODE',provider['WH_CODE']);
				}
			})
		}
	});
//		Unilite.createValidator('formValidator', {
//		forms: {'formA:':panelSearch},		
//		validate: function( type, fieldName, newValue, oldValue) {
//			if(newValue == oldValue){
//				return false;
//			}
//			var rv = true;
//			switch(fieldName) {	
//				case "WORK_DATE" :
//					if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
//						UniAppManager.app.fnDateDIffCal();
//					}										
//				break;
//			}
//			return rv;
//		}
//	}); 
};
</script>
