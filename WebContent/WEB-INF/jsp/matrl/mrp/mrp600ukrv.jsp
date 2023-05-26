<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mrp600ukrv"  >	
	<t:ExtComboStore comboType="BOR120" pgmId="mrp600ukrv" /> 			<!-- 사업장 --> 
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>
<script type="text/javascript" >
///// 최종마감일이 없을시  rdo disabled처리 해야함 mrp600ukrv.htm  283줄
function appMain() { 
	var gsMonth = '';
	var orgInfo = '';
	
	var panelSearch = Unilite.createForm('bor100ukrvDetail', {
    	disabled :false
        , flex:1        
        , layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}}
	    , items :[{ 
				fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false 
			}, {
				fieldLabel: '기준일자',            			 		       
				xtype: 'uniDateRangefield',
				startFieldName: 'START_DATE',
				endFieldName: 'END_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width:315,
				allowBlank: false 
		    },
				Unilite.popup('DEPT', { 
				fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				textFieldWidth: 170,
				holdable: 'hold',
				listeners: {
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
				fieldLabel: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>',
				name: 'ITEM_LEVEL1', 
				xtype: 'uniCombobox',  
				store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
				child: 'ITEM_LEVEL2'
			},{
				fieldLabel: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>',
				name: 'ITEM_LEVEL2', 
				xtype: 'uniCombobox',  
				store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
				child: 'ITEM_LEVEL3'
			},{
				fieldLabel: '<t:message code="system.label.purchase.minorgroup" default="소분류"/>',
				name: 'ITEM_LEVEL3', 
				xtype: 'uniCombobox',  
				store: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
	            levelType:'ITEM'
			},
				Unilite.popup('DIV_PUMOK',{
            	fieldLabel:'<t:message code="system.label.purchase.itemcode" default="품목코드"/>' ,
            	textFieldWidth:170,
            	validateBlank: false,
				listeners: {
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
            }),{
	        	margin: '10 0 0 40',
				xtype: 'button',
				id: 'startButton',
				text: '실행',	
	        	width: 285,
//	        	tdAttrs:{'align':'center'},							   	
				handler : function() {
//					var me = this;
//					me.setDisabled(true);
//					panelSearch.getField('DIV_CODE').setReadOnly(true);
//					panelSearch.getField('START_DATE').setReadOnly(true);
//					panelSearch.getField('END_DATE').setReadOnly(true);
//					panelSearch.getField('DEPT_CODE').setReadOnly(true);
//					panelSearch.getField('DEPT_NAME').setReadOnly(true);
//					panelSearch.getField('ITEM_LEVEL1').setReadOnly(true);
//					panelSearch.getField('ITEM_LEVEL2').setReadOnly(true);
//					panelSearch.getField('ITEM_LEVEL3').setReadOnly(true);
//					panelSearch.getField('ITEM_CODE').setReadOnly(true);
//					panelSearch.getField('ITEM_NAME').setReadOnly(true);
					panelSearch.getEl().mask('로딩중...','loading-indicator');
					var param = panelSearch.getValues();
					mrp600ukrvService.insertMaster(param, function(provider, response)	{
//						me.setDisabled(false);
//						panelSearch.getField('DIV_CODE').setReadOnly(false);
//						panelSearch.getField('START_DATE').setReadOnly(false);
//						panelSearch.getField('END_DATE').setReadOnly(false);
//						panelSearch.getField('DEPT_CODE').setReadOnly(false);
//						panelSearch.getField('DEPT_NAME').setReadOnly(false);
//						panelSearch.getField('ITEM_LEVEL1').setReadOnly(false);
//						panelSearch.getField('ITEM_LEVEL2').setReadOnly(false);
//						panelSearch.getField('ITEM_LEVEL3').setReadOnly(false);
//						panelSearch.getField('ITEM_CODE').setReadOnly(false);
//						panelSearch.getField('ITEM_NAME').setReadOnly(false);
						if(provider){
							UniAppManager.updateStatus(Msg.sMB011);							
						}
						panelSearch.getEl().unmask();
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
   						var labelText = invalid.items[0]['fieldLabel']+':';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
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
		id: 'mrp600ukrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('query',false);
			UniAppManager.setToolbarButtons('reset',true);			
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
			panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
			panelSearch.setValue('START_DATE', UniDate.get('startOfMonth'));
			panelSearch.setValue('END_DATE', UniDate.get('today'));
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			this.fnInitBinding();
		}
	});
};
</script>
