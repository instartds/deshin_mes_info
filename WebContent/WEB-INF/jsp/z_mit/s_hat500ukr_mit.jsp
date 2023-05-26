<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hat500ukr_mit"  > 
	<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 --> 
	<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 --> 
	<t:ExtComboStore comboType="AU" comboCode="H004" /> <!-- 근무조 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /> <!-- 직위 --> 
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /> <!-- 사원구분 --> 
	<t:ExtComboStore comboType="AU" comboCode="H181" /> <!-- 사원그룹 --> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	
	var model_pay_code1 = null;
	var model_pay_code2 = null;
	var model_pay_code3 = null;
	
	var store_pay_code1 = null;
	var store_pay_code2 = null;
	var store_pay_code3 = null;
		
	var dutyRule = "${ dutyRule }";
	var colData = ${colData};
	console.log(colData);
	
	//급여지급 방식에 따른 근태구분 콤보store
	var cbStore = Unilite.createStore('s_hat500ukr_mitsComboStoreGrid',{
        autoLoad: false,
        uniOpt: {
			isMaster: false,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi: false			// prev | newxt 버튼 사용
		},
        fields: [
                {name: 'SUB_CODE', type : 'string'}, 
	    		{name: 'CODE_NAME', type : 'string'} 
                ],
        proxy: {
        	type: 'direct',
            api: {			
            	read: 's_hat500ukr_mitService.getComboList'                	
		    }
        },
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		}
    });
    //급여지급 방식에 따른 근태구분 콤보store2
	var cbStore2 = Unilite.createStore('s_hat500ukrs_mitComboStoreGrid2',{
        autoLoad: false,
        uniOpt: {
			isMaster: false,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi: false			// prev | newxt 버튼 사용
		},
        fields: [
                {name: 'value', type : 'string'}, 
	    		{name: 'text', type : 'string'} 
                ],
        proxy: {
        	type: 'direct',
            api: {			
            	read: 's_hat500ukr_mitService.getComboList2'                	
		    }
        },
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		}
    });
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */

	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.human.searchconditon" default="검색조건"/>',		
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,//true,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{	
			title: '<t:message code="system.label.human.basisinfo" default="기본정보"/>', 	
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.human.dutyyearmonth" default="근태년월"/>',
				xtype: 'uniDatefield',
				name: 'FR_DATE',                    
				value: new Date(),                    
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('FR_DATE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',
				id: 'PAY_CODE',
				name: 'PAY_CODE', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H028',
				allowBlank: true,
//				value: '0',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_CODE', newValue);
					}
					/*,
					select: function(cb, oldValue, newValue) {
						if (masterGrid.getStore().getCount() == -1) {
							switch (cb.lastValue) {
								case '0':
									if (store_pay_code0 == null) createModelStore(cb.lastValue);
									else masterGrid.reconfigure(store_pay_code0, columns0);
									break;
								case '1':
									if (store_pay_code1 == null) createModelStore(cb.lastValue);
									else masterGrid.reconfigure(store_pay_code1, columns1);
									break;
								case '2':
									if (store_pay_code2 == null) createModelStore(cb.lastValue);
									else masterGrid.reconfigure(store_pay_code2, columns2);
									break;
								case '3':
									if (store_pay_code3 == null) createModelStore(cb.lastValue);
									else masterGrid.reconfigure(store_pay_code3, columns3);																		
									break;
							}	
						}
					}*/
				}
			},{
    			fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
    			name: 'DIV_CODE',
    			xtype: 'uniCombobox',
    			comboType: 'BOR120',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
    		},
			Unilite.treePopup('DEPTTREE',{
				fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
				valueFieldName:'DEPT',
				textFieldName:'DEPT_NAME' ,
				valuesName:'DEPTS' ,
				DBvalueFieldName:'TREE_CODE',
				DBtextFieldName:'TREE_NAME',
				selectChildren:true,
				textFieldWidth:89,
				validateBlank:true,
				width:300,
				autoPopup:true,
				useLike:true,
				extParam:{'USE_YN':'Y'},
				listeners: {
	                'onValueFieldChange': function(field, newValue, oldValue  ){
	                    	panelResult.setValue('DEPT',newValue);
	                },
	                'onTextFieldChange':  function( field, newValue, oldValue  ){
	                    	panelResult.setValue('DEPT_NAME',newValue);
	                },
	                'onValuesChange':  function( field, records){
	                    	var tagfield = panelResult.getField('DEPTS') ;
	                    	tagfield.setStoreData(records)
	                }
				}
			}),{
				fieldLabel: '<t:message code="system.label.human.workteam" default="근무조"/>',
				name: 'WORK_TEAM', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H004',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WORK_TEAM', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.human.payprovflag2" default="지급차수"/>',
				name: 'PAY_PROV_FLAG', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H031',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_PROV_FLAG', newValue);
					}
				}
			}]
		},{	
			title: '<t:message code="system.label.human.addinfo" default="추가정보"/>', 	
	   		itemId: 'search_panel2',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.human.paygubun" default="고용형태"/>',
				name: 'PAY_GUBUN', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H011',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_GUBUN', newValue);
					}
				}
			},			
		     	Unilite.popup('Employee',{ 
				
				validateBlank: false,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);				
					}
				}
			}),{
				fieldLabel: '<t:message code="system.label.human.employtype" default="사원구분"/>',
				name: 'EMPLOY_TYPE', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H024',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('EMPLOY_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.human.employeegroup" default="사원그룹"/>',
				name: 'SUB_CODE', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H181',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SUB_CODE', newValue);
					}
				}
			},{
			fieldLabel: '근태일괄등록',
			name: 'DUTY_CODE', 
			xtype: 'uniCombobox',
			//comboType: 'WU',
			store: cbStore2, 
			//lazyRender: true,
			hidden:true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelResult.setValue('DUTY_CODE', newValue);
				}
			}
		}]
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 5},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '<t:message code="system.label.human.dutyyearmonth" default="근태년월"/>',
			xtype: 'uniDatefield',
			name: 'FR_DATE',                    
			value: new Date(),                    
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('FR_DATE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',
			name: 'PAY_CODE', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H028',
			allowBlank: true,
//			value: '0',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAY_CODE', newValue);
				}
				/*,
				select: function(cb, oldValue, newValue) {
					if (masterGrid.getStore().getCount() == -1) {
						switch (cb.lastValue) {
							case '0':
								if (store_pay_code0 == null) createModelStore(cb.lastValue);
								else masterGrid.reconfigure(store_pay_code0, columns0);
								break;
							case '1':
								if (store_pay_code1 == null) createModelStore(cb.lastValue);
								else masterGrid.reconfigure(store_pay_code1, columns1);
								break;
							case '2':
								if (store_pay_code2 == null) createModelStore(cb.lastValue);
								else masterGrid.reconfigure(store_pay_code2, columns2);
								break;
							case '3':
								if (store_pay_code3 == null) createModelStore(cb.lastValue);
								else masterGrid.reconfigure(store_pay_code3, columns3);																		
								break;
						}	
					}
				}*/
			}
		},{
			fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			xtype: 'component'
		},{
			xtype: 'component'
		},
		Unilite.treePopup('DEPTTREE',{
			fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
			valueFieldName:'DEPT',
			textFieldName:'DEPT_NAME' ,
			valuesName:'DEPTS' ,
			DBvalueFieldName:'TREE_CODE',
			DBtextFieldName:'TREE_NAME',
			selectChildren:true,
			textFieldWidth:89,
			validateBlank:true,
			width:300,
			autoPopup:true,
			useLike:true,
			extParam:{'USE_YN':'Y'},
			listeners: {
                'onValueFieldChange': function(field, newValue, oldValue  ){
                    	panelSearch.setValue('DEPT',newValue);
                },
                'onTextFieldChange':  function( field, newValue, oldValue  ){
                    	panelSearch.setValue('DEPT_NAME',newValue);
                },
                'onValuesChange':  function( field, records){
                    	var tagfield = panelSearch.getField('DEPTS') ;
                    	tagfield.setStoreData(records)
                }
			}
		}),{
			fieldLabel: '<t:message code="system.label.human.workteam" default="근무조"/>',
			name: 'WORK_TEAM', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H004',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('WORK_TEAM', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.human.payprovflag2" default="지급차수"/>',
			name: 'PAY_PROV_FLAG', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H031',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAY_PROV_FLAG', newValue);
				}
			}
		},{
			fieldLabel: '근태일괄등록',
			name: 'DUTY_CODE', 
			xtype: 'uniCombobox',
			//comboType: 'WU',
			store: cbStore2, 
			//lazyRender: true,
			hidden:true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DUTY_CODE', newValue);
					//UniAppManager.setToolbarButtons('save', true);
				}
			}
		},{
			xtype: 'button',
			Id: 'btnApply',
			hidden:true,
			text: '<t:message code="system.label.human.allapply" default="전체적용"/>',
			margin: '0 0 0 10',
			handler: function(){
				
				var duty_value = panelResult.getValue('DUTY_CODE');
				var Records = store_pay_code0.data.items;
				
				if(Records == null || Records.length == 0 ){
					alert("조회된 데이터가 없습니다.");
           			return false;
           		}				
				
				if(duty_value == '' || duty_value == null){
					alert("일괄등록을 하기 위해 근태코드를 선택하십시오.");
					return false;
				} else {
					Ext.each(Records, function(record, i){	
						
						if (dutyRule == 'Y' ) {
							record.set('DUTY_CODE'	,duty_value);
						} else {
							record.set('NUMC'		,duty_value);
						};
						
						// 근태코드에 값이 입력 된 경우 일자의 입력값을 공백처리함
						if ((dutyRule == 'Y' && record.data.DUTY_CODE != '')) {					
							
							record.set('DUTY_FR_D', '');
							record.set('DUTY_FR_H', '00');
							record.set('DUTY_FR_M', '00');
							record.set('DUTY_TO_D', '');
							record.set('DUTY_TO_H', '00');
							record.set('DUTY_TO_M', '00');
							record.set('DUTY_NUM', '1');
							
							UniAppManager.setToolbarButtons('save', true);
						}
						// 근태코드에 값이 입력 된 경우 이후 시/분에 0을 넣음
						if (dutyRule == 'N' && record.data.NUMC != '') {
							Ext.Ajax.request({
								url     : CPATH+'/z_mit/getDutycode.do',
								params: { PAY_CODE: Ext.getCmp('PAY_CODE').getValue(), S_COMP_CODE: UserInfo.compCode, DUTY_RULE: dutyRule },
								success: function(response){
									var data = JSON.parse(Ext.decode(response.responseText));
									Ext.each(data, function(item, index){
										
										record.set('TIMET' + item.SUB_CODE, '00');
										record.set('TIMEM' + item.SUB_CODE, '00');
										record.set('NUMN', '1');
										
										UniAppManager.setToolbarButtons('save', true);
									});
								},
								
								failure: function(response){
									console.log(response);
								}
							});
						}						
					});		
				};
			}
		}]	
    });
       
	var fields = createModelField(colData);
	columns0 = createGridColumn(colData);
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_hat500ukr_mitModel', {
		fields: fields
	});//End of Unilite.defineModel('Hat500ukrModel', {
	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_hat500ukr_mitService.selectList',
			update: 's_hat500ukr_mitService.updateList',
			destroy: 's_hat500ukr_mitService.deleteList',
			syncAll: 's_hat500ukr_mitService.saveAll'
		}
	});
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var store_pay_code0 = Unilite.createStore('s_hat500ukr_mitMasterStore1', {
		model: 's_hat500ukr_mitModel',
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			param.DUTY_RULE = dutyRule;
			console.log(param);
			this.load({
				params: param
			});
		},
		saveStore : function()	{				
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 )	{	
				var config = {
					
					success: function(batch, option) {
						store_pay_code0.loadStoreRecords();
						UniAppManager.setToolbarButtons('save', false);
					 } 
				};
				store_pay_code0.syncAllDirect(config);	
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function() {
				if (this.getCount() > 0) {
	              	UniAppManager.setToolbarButtons('delete', true);
	              	UniAppManager.setToolbarButtons('deleteAll', true);
	              	var record = masterGrid.getStore().getData();
                        Ext.each(record.items, function(record, idx){
                            if(record.get('FLAG') == 'Y'){
                                   UniAppManager.setToolbarButtons('save', true);
                                   record.set('FLAG', 'N');
                            }
                    });
                } else {
              	  	UniAppManager.setToolbarButtons('delete', false);
              	  	UniAppManager.setToolbarButtons('deleteAll', false);
                } 
//                dutyCodeStore.loadStoreRecords();
			}
		}
	});//End of var store_pay_code0 = Unilite.createStore('s_hat500ukr_mitMasterStore1', {	
		
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('s_hat500ukr_mitGrid1', {
		layout: 'fit',
		region: 'center',
		uniOpt:{	
			expandLastColumn: true,
			useRowNumberer: false
        },
		features: [{
			id: 'masterGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false 
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
		store: store_pay_code0,
		columns: columns0,
        listeners: {
          	beforeedit: function(editor, e) {
          		if(dutyRule == 'Y'){
          			if(e.field == 'WORK_TEAM') return true;
          		}else{
          			if(e.field == 'WORK_TEAM') return false;
          		}
				if (e.field == 'DIV_CODE' || e.field == 'DEPT_NAME' || e.field == 'POST_CODE' || e.field == 'NAME' || e.field == 'PERSON_NUMB') 
					return false;
			}, edit: function(editor, e) {
				var record = masterGrid.getSelectionModel().getSelection()[0];
				var fieldName = e.field;
				var num_check = /[0-9]/;
				console.log(e);
				
				
				// 근태코드에 값이 입력 된 경우 일자의 입력값을 공백처리함
				if ((dutyRule == 'Y' && e.record.data.DUTY_CODE != '')) {
					record.set('DUTY_FR_D', '');
					record.set('DUTY_FR_H', '00');
					record.set('DUTY_FR_M', '00');
					record.set('DUTY_TO_D', '');
					record.set('DUTY_TO_H', '00');
					record.set('DUTY_TO_M', '00');
					record.set('DUTY_NUM', '1');
				}
				// 근태코드에 값이 입력 된 경우 이후 시/분에 0을 넣음
				if (dutyRule == 'N' && e.record.data.NUMC != '') {
					Ext.Ajax.request({
						url     : CPATH+'/z_mit/getDutycode.do',
						params: { PAY_CODE: Ext.getCmp('PAY_CODE').getValue(), S_COMP_CODE: UserInfo.compCode, DUTY_RULE: dutyRule },
						success: function(response){
							var data = JSON.parse(Ext.decode(response.responseText));
							Ext.each(data, function(item, index){
								record.set('TIMET' + item.SUB_CODE, '00');
								record.set('TIMEM' + item.SUB_CODE, '00');
								record.set('NUMN', '1');
							});
						},
						failure: function(response){
							console.log(response);
						}
					});
				}
				// 숫자 형식 및 근태구분 입력 유/무 검사
				if (fieldName.indexOf('_H') != -1 || fieldName.indexOf('_M') != -1 || fieldName.indexOf('TIMET') != -1 || fieldName.indexOf('TIMEM') != -1 || fieldName.indexOf('_D') != -1 ) {
					if(Ext.isEmpty(e.value)){
						record.set(e.field, e.originalValue);
						return false;
					}
					if (isNaN(e.value)) {
							Ext.Msg.alert('<t:message code="system.label.human.confirm" default="확인"/>', '<t:message code="system.message.human.message033" default="숫자형식이 잘못되었습니다."/>');
							e.record.set(fieldName, e.originalValue);
							return false;
					}
					if (fieldName.indexOf('_H') != -1 || fieldName.indexOf('TIMET') != -1) {
						if (parseInt(e.value) > 24 || parseInt(e.value) < 0) {
							Ext.Msg.alert('<t:message code="system.label.human.confirm" default="확인"/>', '<t:message code="system.message.human.message034" default="정확한 시를 입력하십시오."/>');
							e.record.set(fieldName, e.originalValue);
							return false;
						}
						if (e.originalValue != e.value && ((dutyRule == 'Y' && e.record.data.DUTY_CODE != '') || (dutyRule == 'N' && e.record.data.NUMC != ''))) {
							Ext.Msg.alert('<t:message code="system.label.human.confirm" default="확인"/>', '<t:message code="system.message.human.message035" default="근태구분에 값이 있으면 입력할수 없습니다."/>');
							e.record.set(fieldName, e.originalValue);
							return false;
						}
					} else {
						if (parseInt(e.value) > 60 || parseInt(e.value) < 0) {
							Ext.Msg.alert('<t:message code="system.label.human.confirm" default="확인"/>', '<t:message code="system.message.human.message036" default="정확한 분을 입력하십시오."/>');
							e.record.set(fieldName, e.originalValue);
							return false;
						}
						if (e.originalValue != e.value && ((dutyRule == 'Y' && e.record.data.DUTY_CODE != '') || (dutyRule == 'N' && e.record.data.NUMC != ''))) {
							Ext.Msg.alert('<t:message code="system.label.human.confirm" default="확인"/>', '<t:message code="system.message.human.message035" default="근태구분에 값이 있으면 입력할수 없습니다."/>');
							e.record.set(fieldName, e.originalValue);
							return false;
						}
					}
			}
			if (e.originalValue != e.value) {	
				if (fieldName.indexOf('_H') != -1 || fieldName.indexOf('_M') != -1 || fieldName.indexOf('TIMET') != -1 || fieldName.indexOf('TIMEM') != -1) {
					if(e.value.length == 1){
						record.set(fieldName, '0' + e.value);													
					}				
				}
				UniAppManager.setToolbarButtons('save', true);
			} 
// 			else {
// 				UniAppManager.setToolbarButtons('save', false);
// 			}
		}
     }
		
		
		
		
	});//End of var masterGrid = Unilite.createGrid('s_hat500ukr_mitGrid1', {   

	Unilite.Main( {
		 borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch  	
		],
		id: 's_hat500ukr_mitApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset', false);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('PAY_CODE');
			cbStore.loadStoreRecords();
			cbStore2.loadStoreRecords();
			
			//Ext.getCmp('btnApply').setDisabled(true);
			//panelResult.down('#btnApply').setDisabled(false);
			//getField("MONEY_UNIT")
			//panelResult.getField("btnApply").setDisabled(true);
			
		},
		onQueryButtonDown: function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			cbStore.loadStoreRecords();
			cbStore2.loadStoreRecords();
			var detailform = panelSearch.getForm();
			//Ext.getCmp('btnApply').setDisabled(true);
			if (detailform.isValid()) {
			
				createModelStore('0');
				
				/*var pay_code = Ext.getCmp('PAY_CODE').getValue();
				switch (pay_code) {
					case '0':
						if (store_pay_code0 == null) {
							createModelStore(pay_code);
						} else {
							masterGrid.reconfigure(store_pay_code0, columns0);
							masterGrid.getStore().loadStoreRecords();						
						}
						break;
					case '1':
						if (store_pay_code1 == null) {
							createModelStore(pay_code);
						} else {
							masterGrid.reconfigure(store_pay_code1, columns1);
							masterGrid.getStore().loadStoreRecords();
						}
						break;
					case '2':
						if (store_pay_code2 == null) {
							createModelStore(pay_code);
						} else {
							masterGrid.reconfigure(store_pay_code2, columns2);
							masterGrid.getStore().loadStoreRecords();
						}
						break;
					case '3':
						if (store_pay_code3 == null) {
							createModelStore(pay_code);
						} else {
							masterGrid.reconfigure(store_pay_code3, columns3);																		
							masterGrid.getStore().loadStoreRecords();						
						}
						break;
				}*/
				
				masterGrid.reconfigure(store_pay_code0, columns0);
				masterGrid.getStore().loadStoreRecords();					
							
			} /*else {
				var invalid = panelSearch.getForm().getFields()
				.filterBy(function(field) {
					return !field.validate();
				});
				if (invalid.length > 0) {
					r = false;
					var labelText = ''
		
					if (Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel']
								+ '은(는)';
					} else if (Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']
								+ '은(는)';
					}		
					Ext.Msg.alert('확인', labelText + Msg.sMB083);
					invalid.items[0].focus();
				}
			}*/
		},
		onSaveDataButtonDown : function(config) {
			//if (masterGrid.getStore().isDirty()) {
				// 입력데이터 validation
//				if (!checkValidaionGrid(masterGrid.getStore())) {
//					return false;
//				}	
				//masterGrid.getStore().saveStore();
//				masterGrid.getStore().sync({						
//					success: function(response) {
//						UniAppManager.setToolbarButtons('save', false); 
//		            },
//		            failure: function(response) {
//		            	UniAppManager.setToolbarButtons('save', true); 
//		            }
//				});
			//}
			var detailform = panelSearch.getForm();
            if (detailform.isValid()) {
			
            	masterGrid.reconfigure(store_pay_code0, columns0);
                masterGrid.getStore().saveStore();      
                            
                /*var pay_code = Ext.getCmp('PAY_CODE').getValue();
                switch (pay_code) {
                    case '0':
                        if (store_pay_code0 == null) {
                            createModelStore(pay_code);
                        } else {
                            masterGrid.reconfigure(store_pay_code0, columns0);
                            masterGrid.getStore().saveStore();                       
                        }
                        break;
                    case '1':
                        if (store_pay_code1 == null) {
                            createModelStore(pay_code);
                        } else {
                            masterGrid.reconfigure(store_pay_code1, columns1);
                            masterGrid.getStore().saveStore();
                        }
                        break;
                    case '2':
                        if (store_pay_code2 == null) {
                            createModelStore(pay_code);
                        } else {
                            masterGrid.reconfigure(store_pay_code2, columns2);
                            masterGrid.getStore().saveStore();
                        }
                        break;
                    case '3':
                        if (store_pay_code3 == null) {
                            createModelStore(pay_code);
                        } else {
                            masterGrid.reconfigure(store_pay_code3, columns3);                                                                      
                            masterGrid.getStore().saveStore();                       
                        }
                        break;
                }*/
            }
		},
		onDeleteDataButtonDown : function()	{
			var selRow = masterGrid.getSelectionModel().getSelection()[0];
			if (selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			} else {
				Ext.Msg.confirm('<t:message code="system.label.human.delete" default="삭제"/>', '<t:message code="system.message.human.message032" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>', function(btn){
					if (btn == 'yes') {
						masterGrid.deleteSelectedRow();		
						UniAppManager.setToolbarButtons('save', true);
					}
				});
			}
		},
		onDeleteAllButtonDown : function() {
			Ext.Msg.confirm('<t:message code="system.label.human.delete" default="삭제"/>', '<t:message code="system.message.human.message032" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>', function(btn){
				if (btn == 'yes') {
					masterGrid.reset();			
					UniAppManager.app.onSaveDataButtonDown();
//					Ext.getCmp('hat420ukrGrid1').getStore().removeAll();
//					Ext.getCmp('hat420ukrGrid1').getStore().sync({
//						success: function(response) {
//							Ext.Msg.alert('확인', '삭제 되었습니다.');
//							UniAppManager.setToolbarButtons('delete', false);
//							UniAppManager.setToolbarButtons('deleteAll', false);
//							UniAppManager.setToolbarButtons('excel', false);
//				           },
//				           failure: function(response) {
//				           }
//			           });
					
				}
			});
		}
	});//End of Unilite.Main( {
    Unilite.createValidator('validator01', {
        store: store_pay_code0,
        grid: masterGrid,
        validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
            if(newValue == oldValue){
                return false;
            }           
            var rv = true;          
            switch(fieldName) {
                case "WORK_TEAM" :  
                    if(!Ext.isEmpty(newValue) && dutyRule == 'Y') {
                        var param = masterGrid.getSelectedRecord().data;
                        s_hat500ukr_mitService.getDutycodeTime(param, function(provider, response)  {
                            if(!Ext.isEmpty(provider)){
                            	record.set('DUTY_FR_H', provider[0].DUTY_FR_H);
                            	record.set('DUTY_FR_M', provider[0].DUTY_FR_M);
                            	record.set('DUTY_TO_H', provider[0].DUTY_TO_H);
                            	record.set('DUTY_TO_M', provider[0].DUTY_TO_M);
                            }                   
                        });
                    }
                    break;                  
            }
            return rv;
        }
    }); 
	// 모델 필드 생성
	function createModelField(colData) {
		var fields = [
		              	{name: 'PAY_CODE'			, text: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>', type: 'string'},
						{name: 'WORK_TEAM'			, text: '<t:message code="system.label.human.workteam" default="근무조"/>'	, type: 'string', comboType: 'AU', comboCode: 'H004'},
						{name: 'DIV_CODE'			, text: '<t:message code="system.label.human.division" default="사업장"/>'	, type: 'string', comboType: 'BOR120'},
						{name: 'FLAG'				, text: ''   			, type: 'string'},
						{name: 'APPLY_YN'			, text: 'PASS적용여부'   	, type: 'string'},						
						{name: 'DUTY_YYYYMMDD'		, text: '<t:message code="system.label.human.dutyyearmonth" default="근태년월"/>'	, type: 'uniDate'},
						{name: 'DEPT_NAME'			, text: '<t:message code="system.label.human.department" default="부서"/>'	, type: 'string'},
						{name: 'POST_CODE'			, text: '<t:message code="system.label.human.postcode" default="직위"/>'	, type: 'string', comboType: 'AU', comboCode: 'H005'},
						{name: 'NAME'				, text: '<t:message code="system.label.human.name" default="성명"/>'	, type: 'string'},
						{name: 'PERSON_NUMB'		, text: '<t:message code="system.label.human.personnumb" default="사번"/>'	, type: 'string'},
						{name: 'REQUST_SRAL_NO'		, text: '고유번호'		, type: 'string'},
						{name: 'USER_ID'			, text: '패스아이디'	, type: 'string'}
						
					 ];
		
		if (dutyRule == 'Y') {
			fields.push({name: 'DUTY_CODE'		, text: '<t:message code="system.label.human.dutytype" default="근태구분"/>'	, type: 'string'});
			fields.push({name: 'DUTY_FR_D'		, text: '<t:message code="system.label.human.caldate" default="일자"/>'	, type: 'uniDate'});
			fields.push({name: 'DUTY_FR_H'		, text: '<t:message code="system.label.human.hour" default="시"/>'		, type: 'string', maxLength: 2});
			fields.push({name: 'DUTY_FR_M'		, text: '<t:message code="system.label.human.minute" default="분"/>'		, type: 'string', maxLength: 2});
			fields.push({name: 'DUTY_TO_D'		, text: '<t:message code="system.label.human.caldate" default="일자"/>'	, type: 'uniDate'});
			fields.push({name: 'DUTY_TO_H'		, text: '<t:message code="system.label.human.hour" default="시"/>'		, type: 'string', maxLength: 2});
			fields.push({name: 'DUTY_TO_M'		, text: '<t:message code="system.label.human.minute" default="분"/>'		, type: 'string', maxLength: 2});
		} else {
			fields.push({name: 'NUMF'			, text: 'NUMF'	, type: 'string'});
			fields.push({name: 'NUMC1'			, text: 'NUMC1'	, type: 'string'});
			fields.push({name: 'NUMC'			, text: '<t:message code="system.label.human.dutytype" default="근태구분"/>'	, type: 'string'});
			fields.push({name: 'NUMN'			, text: 'NUMN'	, type: 'string'});
			fields.push({name: 'NUMT'			, text: 'NUMT'	, type: 'string'});
			fields.push({name: 'NUMM'			, text: 'NUMM'	, type: 'string'});
			Ext.each(colData, function(item, index){
				fields.push({name: 'TIMEF' + item.SUB_CODE, text: 'TIMEF'	, type: 'string'});
				fields.push({name: 'TIMEC' + item.SUB_CODE, text: 'TIMEC'	, type: 'string'});
				fields.push({name: 'TIMEN' + item.SUB_CODE, text: 'TIMEN'	, type: 'string'});
				fields.push({name: 'TIMET' + item.SUB_CODE, text: '<t:message code="system.label.human.hour" default="시"/>'		, type: 'string'});
				fields.push({name: 'TIMEM' + item.SUB_CODE, text: '<t:message code="system.label.human.minute" default="분"/>'		, type: 'string'});
			});
		}		
		console.log(fields);
		return fields;
	}
	
	// 그리드 컬럼 생성
	function createGridColumn(colData) {
		var columns = [ {
						xtype: 'rownumberer', 
						sortable:false, 
						//locked: true, 
						width: 35,
						align:'center  !important',
						resizable: true
					},
						{dataIndex: 'PAY_CODE'			, text: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',   hidden: true},
						{dataIndex: 'FLAG'              , width: 20,   text: ''},
						{dataIndex: 'APPLY_YN'          , width: 100,  text: 'PASS적용여부'},
						{dataIndex: 'WORK_TEAM'			, width: 96,   text: '<t:message code="system.label.human.workteam" default="근무조"/>', style: 'text-align: center', editor:
                            {
                                xtype: 'uniCombobox',
                                lazyRender: true,
                                comboType: 'AU',
                                comboCode: 'H004'
                            },
				            renderer: function (value) {
				            	var record = Ext.getStore('CBS_AU_H004').findRecord('value', value);
								if (record == null || record == undefined ) {
									return '';
								} else {
									return record.data.text
								}
				            }				
						},
						{dataIndex: 'DIV_CODE'			, width: 160,  text: '<t:message code="system.label.human.division" default="사업장"/>', style: 'text-align: center', comboType: 'BOR120',
				            renderer: function (value) {
				            	var record = Ext.getStore('CBS_BOR120_').findRecord('value', value);
								if (record == null || record == undefined ) {
									return '';
								} else {
									return record.data.text
								}
				            }						
						},
						
						{dataIndex: 'DUTY_YYYYMMDD'		, width: 96,  hidden: true,   text: '<t:message code="system.label.human.dutyyearmonth" default="근태년월"/>'},
						{dataIndex: 'DEPT_NAME'			, width: 150,   text: '<t:message code="system.label.human.department" default="부서"/>', style: 'text-align: center'},
						{dataIndex: 'POST_CODE'			, width: 96,   text: '<t:message code="system.label.human.postcode" default="직위"/>', style: 'text-align: center', comboType: 'AU',
				            renderer: function (value) {
				            	var record = Ext.getStore('CBS_AU_H005').findRecord('value', value);
								if (record == null || record == undefined ) {
									return '';
								} else {
									return record.data.text
								}
				            }						
						},
						{dataIndex: 'NAME'				, width: 96,   text: '<t:message code="system.label.human.name" default="성명"/>', style: 'text-align: center'},
						{dataIndex: 'PERSON_NUMB'		, width: 96,   text: '<t:message code="system.label.human.personnumb" default="사번"/>', style: 'text-align: center'},
						{dataIndex: 'REQUST_SRAL_NO'	, width: 96,   text: '고유번호', style: 'text-align: center',   hidden: true},
						{dataIndex: 'USER_ID'			, width: 96,   text: '패스아이디', style: 'text-align: center',   hidden: true}
					  ];
		if (dutyRule == 'Y') {
			columns.push({dataIndex: 'DUTY_CODE'		, width: 96, text: '<t:message code="system.label.human.dutytype" default="근태구분"/>', style: 'text-align: center', editor:
	            {
	                xtype: 'uniCombobox',
	                store: cbStore,
	                lazyRender: true,
	                displayField : 'CODE_NAME',
	                valueField : 'SUB_CODE',
	                hiddenName: 'SUB_CODE',
	                hiddenValue: 'SUB_CODE'
	            },
	            renderer: function (value) {
	            	var record = Ext.getStore('s_hat500ukr_mitsComboStoreGrid').findRecord('SUB_CODE', value);
					if (record == null || record == undefined ) {
						return '';
					} else {
						return record.data.CODE_NAME
					}
            }});
			columns.push({text: '<t:message code="system.label.human.attendtime" default="출근시간"/>',
					columns:[{dataIndex: 'DUTY_FR_D'		, width: 96, text: '<t:message code="system.label.human.caldate" default="일자"/>', style: 'text-align: center', align: 'center', xtype:'uniDateColumn', editor: {xtype: 'uniDatefield'}},
							 {dataIndex: 'DUTY_FR_H'		, width: 96, text: '<t:message code="system.label.human.hour" default="시"/>', style: 'text-align: center', align: 'right', style: 'text-align: center', align: 'right', editor: {xtype: 'uniTextfield'}},
							 {dataIndex: 'DUTY_FR_M'		, width: 96, text: '<t:message code="system.label.human.minute" default="분"/>', style: 'text-align: center', align: 'right', style: 'text-align: center', align: 'right', editor: {xtype: 'uniTextfield'}}
					]});
			columns.push({text: '<t:message code="system.label.human.offworktime" default="퇴근시간"/>',
					columns:[{dataIndex: 'DUTY_TO_D'		, width: 96, text: '<t:message code="system.label.human.caldate" default="일자"/>', style: 'text-align: center', align: 'center', xtype:'uniDateColumn', editor: {xtype: 'uniDatefield'}},
							 {dataIndex: 'DUTY_TO_H'		, width: 96, text: '<t:message code="system.label.human.hour" default="시"/>', style: 'text-align: center', align: 'right', style: 'text-align: center', align: 'right', editor: {xtype: 'uniTextfield'}},
							 {dataIndex: 'DUTY_TO_M'		, width: 96, text: '<t:message code="system.label.human.minute" default="분"/>', style: 'text-align: center', align: 'right', style: 'text-align: center', align: 'right', editor: {xtype: 'uniTextfield'}}
					]});
		} else {
			columns.push({dataIndex: 'NUMF'				, width: 96		, hidden: true, text: 'NUMF'});
			columns.push({dataIndex: 'NUMC1'			, width: 96		, hidden: true, text: 'NUMC1'});
			columns.push({dataIndex: 'NUMC'				, width: 96		, text: '<t:message code="system.label.human.dutytype" default="근태구분"/>', style: 'text-align: center', editor:
	            {
	                xtype: 'uniCombobox',
	                store: cbStore,
	                lazyRender: true,
	                displayField : 'CODE_NAME',
	                valueField : 'SUB_CODE',
	                hiddenName: 'SUB_CODE',
	                hiddenValue: 'SUB_CODE'
	            },
	            renderer: function (value) {
	            	var record = Ext.getStore('s_hat500ukr_mitsComboStoreGrid').findRecord('SUB_CODE', value);
					if (record == null || record == undefined ) {
						return '';
					} else {
						return record.data.CODE_NAME
					}
            }});
			columns.push({dataIndex: 'NUMN'				, width: 96		, hidden: true, text: 'NUMN'});
			columns.push({dataIndex: 'NUMT'				, width: 96		, hidden: true, text: 'NUMT'});
			columns.push({dataIndex: 'NUMM'				, width: 96		, hidden: true, text: 'NUMM'});
			Ext.each(colData, function(item, index){
				columns.push(
					{text: item.CODE_NAME,
						columns:[ 
							{dataIndex: 'TIMEF' + item.SUB_CODE, width:66, hidden: true, text: 'TIMEF', align: 'right'},
							{dataIndex: 'TIMEC' + item.SUB_CODE, width:66, hidden: true, text: 'TIMEC', align: 'right'},
							{dataIndex: 'TIMEN' + item.SUB_CODE, width:66, hidden: true, text: 'TIMEN', align: 'right'},
							{dataIndex: 'TIMET' + item.SUB_CODE, width:66, text: '<t:message code="system.label.human.hour" default="시"/>', style: 'text-align: center', align: 'right', editor: {xtype: 'uniTextfield'}},
							{dataIndex: 'TIMEM' + item.SUB_CODE, width:66, text: '<t:message code="system.label.human.minute" default="분"/>', style: 'text-align: center', align: 'right', editor: {xtype: 'uniTextfield'}}
						]
					});
			});
		}
		console.log(columns);
		return columns;
	}
	
	function createModelStore(pay_value) {
		Ext.Ajax.request({
			url     : CPATH+'/z_mit/getDutycode.do',
			params: { PAY_CODE: pay_value, S_COMP_CODE: UserInfo.compCode, DUTY_RULE: dutyRule },
			success: function(response){
				var data = JSON.parse(Ext.decode(response.responseText));
				var fields = createModelField(data);
				switch (pay_value) {
					case '0':
						store_pay_code0.loadStoreRecords();
						masterGrid.reconfigure(store_pay_code0, columns0);
						
						//UniAppManager.setToolbarButtons('save', true);
						 
						break;
					case '1':
						columns1 = createGridColumn(data);
						model_pay_code1 = Unilite.defineModel('model_pay_code1', {
							fields: fields
						});
						store_pay_code1 = Unilite.createStore('store_pay_code1', {
							model: 'model_pay_code1',
							uniOpt: {
								isMaster: false,			// 상위 버튼 연결 
								editable: true,			// 수정 모드 사용 
								deletable: false,			// 삭제 가능 여부 
								useNavi: false			// prev | newxt 버튼 사용
							},
							autoLoad: false,
							proxy: directProxy,
							loadStoreRecords: function(){
								var param= Ext.getCmp('searchForm').getValues();
								param.DUTY_RULE = dutyRule;
								console.log(param);
								this.load({
									params: param
								});
							},
							saveStore : function()	{				
								var inValidRecs = this.getInvalidRecords();
								if(inValidRecs.length == 0 )	{	
									var config = {
										
										success: function(batch, option) {
											store_pay_code1.loadStoreRecords();
											UniAppManager.setToolbarButtons('save', false);
										 } 
									};
									store_pay_code1.syncAllDirect(config);	
								}else {
									masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
								}
							},
							listeners: {
								load: function() {
									if (this.getCount() > 0) {
						              	UniAppManager.setToolbarButtons('delete', true);
						              	UniAppManager.setToolbarButtons('deleteAll', true);
						              	var record = masterGrid.getStore().getData();
                                            Ext.each(record.items, function(record, idx){
                                                if(record.get('FLAG') == 'Y'){
                                                       UniAppManager.setToolbarButtons('save', true);
                                                       record.set('FLAG', 'N');
                                                }
                                        });
					                } else {
					              	  	UniAppManager.setToolbarButtons('delete', false);
					              	  	UniAppManager.setToolbarButtons('deleteAll', false);
					                }
//					                dutyCodeStore.loadStoreRecords();
					                masterGrid.getSelectionModel().select(0);
								}
							}
						});
						store_pay_code1.loadStoreRecords();
						masterGrid.setColumnInfo(masterGrid, columns1, fields);
						masterGrid.reconfigure(store_pay_code1, columns1);
						break;
					case '2':
						columns2 = createGridColumn(data);
						model_pay_code2 = Unilite.defineModel('model_pay_code2', {
							fields: fields
						});
						store_pay_code2 = Unilite.createStore('store_pay_code2', {
							model: 'model_pay_code2',
							uniOpt: {
								isMaster: false,			// 상위 버튼 연결 
								editable: true,			// 수정 모드 사용 
								deletable: false,			// 삭제 가능 여부 
								useNavi: false			// prev | newxt 버튼 사용
							},
							autoLoad: false,
							proxy: directProxy,
							loadStoreRecords: function(){
								var param= Ext.getCmp('searchForm').getValues();
								param.DUTY_RULE = dutyRule;
								console.log(param);
								this.load({
									params: param
								});
							},
							saveStore : function()	{				
								var inValidRecs = this.getInvalidRecords();
								if(inValidRecs.length == 0 )	{	
									var config = {
										
										success: function(batch, option) {
											store_pay_code2.loadStoreRecords();
											UniAppManager.setToolbarButtons('save', false);
										 } 
									};
									store_pay_code2.syncAllDirect(config);	
								}else {
									masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
								}
							},
							listeners: {
								load: function() {
									if (this.getCount() > 0) {
						              	UniAppManager.setToolbarButtons('delete', true);
						              	UniAppManager.setToolbarButtons('deleteAll', true);
						              	var record = masterGrid.getStore().getData();
                                            Ext.each(record.items, function(record, idx){
                                                if(record.get('FLAG') == 'Y'){
                                                       UniAppManager.setToolbarButtons('save', true);
                                                       record.set('FLAG', 'N');
                                                }
                                        });
					                } else {
					              	  	UniAppManager.setToolbarButtons('delete', false);
					              	  	UniAppManager.setToolbarButtons('deleteAll', false);
					                }
//					                dutyCodeStore.loadStoreRecords();
					                masterGrid.getSelectionModel().select(0);
								}
							}
						});
						store_pay_code2.loadStoreRecords();
						masterGrid.setColumnInfo(masterGrid, columns2, fields);
						masterGrid.reconfigure(store_pay_code2, columns2);
						break;
					case '3':
						columns3 = createGridColumn(data);
						model_pay_code3 = Unilite.defineModel('model_pay_code3', {
							fields: fields
						});
						store_pay_code3 = Unilite.createStore('store_pay_code3', {
							model: 'model_pay_code3',
							uniOpt: {
								isMaster: false,			// 상위 버튼 연결 
								editable: true,			// 수정 모드 사용 
								deletable: false,			// 삭제 가능 여부 
								useNavi: false			// prev | newxt 버튼 사용
							},
							autoLoad: false,
							proxy: directProxy,
							loadStoreRecords: function(){
								var param= Ext.getCmp('searchForm').getValues();
								param.DUTY_RULE = dutyRule;
								console.log(param);
								this.load({
									params: param
								});
							},
							saveStore : function()	{				
								var inValidRecs = this.getInvalidRecords();
								if(inValidRecs.length == 0 )	{	
									var config = {
										
										success: function(batch, option) {
											store_pay_code3.loadStoreRecords();
											UniAppManager.setToolbarButtons('save', false);
										 } 
									};
									store_pay_code3.syncAllDirect(config);	
								}else {
									masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
								}
							},
							listeners: {
								load: function() {
									if (this.getCount() > 0) {
						              	UniAppManager.setToolbarButtons('delete', true);
						              	UniAppManager.setToolbarButtons('deleteAll', true);
						              	var record = masterGrid.getStore().getData();
                                            Ext.each(record.items, function(record, idx){
                                                if(record.get('FLAG') == 'Y'){
                                                       UniAppManager.setToolbarButtons('save', true);
                                                       record.set('FLAG', 'N');
                                                }   
                                        });
					                } else {
					              	  	UniAppManager.setToolbarButtons('delete', false);
					              	  	UniAppManager.setToolbarButtons('deleteAll', false);
					                }
//					                dutyCodeStore.loadStoreRecords();
					                masterGrid.getSelectionModel().select(0);
								}
							}
						});
						store_pay_code3.loadStoreRecords();
						masterGrid.setColumnInfo(masterGrid, columns3, fields);
						masterGrid.reconfigure(store_pay_code3, columns3);
						break;
				}
				
			},
			failure: function(response){
				console.log(response);
			}
		});
	}
	
	function checkValidaionGrid(store) {
		 // 시작시간이 종료시간 보다 큰 값이 입력이 됨
		 var rightTimeInputed = true;
		 
		 var MsgTitle = '<t:message code="system.label.human.confirm" default="확인"/>';
		 var MsgErr01 = '<t:message code="system.message.human.message037" default="시작시간이 종료 시간 보다 클 수 없습니다."/>';
		 
		 var grid = Ext.getCmp('s_hat500ukr_mitGrid1');
		 var selectedModel = grid.getStore().getRange();
		 Ext.each(selectedModel, function(record,i){
			 
			 if ( (record.data.DUTY_FR_D != '' && record.data.DUTY_TO_D == '') ||
				  (record.data.DUTY_FR_D == '' && record.data.DUTY_TO_D != '') ) {
				 rightTimeInputed = false;
				 return;
			 } else if (record.data.DUTY_FR_D != '' && record.data.DUTY_TO_D != '') {
				 if ((record.data.DUTY_FR_D > record.data.DUTY_TO_D)) {
					 rightTimeInputed = false;
					 return;
				 } else {
					var fr_time = parseInt(record.data.DUTY_FR_H + record.data.DUTY_FR_M);
					var to_time = parseInt(record.data.DUTY_TO_H + record.data.DUTY_TO_M);
					if (record.data.DUTY_FR_D == record.data.DUTY_TO_D && fr_time > to_time) {
						rightTimeInputed = false;
						return;
					}
				 }
			 }
		 });
		 
		 if (!rightTimeInputed) {
			 Ext.Msg.alert(MsgTitle, MsgErr01);
		 }else{//일자 필수값 체크..
		 	if(dutyRule == "Y"){
			 	var toCreate = store.getNewRecords();
	        	var toUpdate = store.getUpdatedRecords();
	        	var list = [].concat(toUpdate,toCreate);            	
				var isErr = false;
	        	Ext.each(list, function(record, index) {
	        		if(Ext.isEmpty(record.get('DUTY_CODE')) && (Ext.isEmpty(record.get('DUTY_FR_D')) || Ext.isEmpty(record.get('DUTY_TO_D')))){
						alert('<t:message code="system.message.human.message038" default="일자를 입력해 주세요."/>');
						isErr = true;
						return false;
					}
	        	});
	        	if(isErr) return false;
		 	}
		 return rightTimeInputed;
		 }
	}

	
};


</script>
