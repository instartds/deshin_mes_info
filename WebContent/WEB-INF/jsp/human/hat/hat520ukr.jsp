R<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hat520ukr"  >
	<t:ExtComboStore comboType="A" comboCode="H028" /> <!-- 급여지급방식 -->
	<t:ExtComboStore comboType="A" comboCode="H031" /> <!-- 지급차수 --> 
	<t:ExtComboStore comboType="A" comboCode="H033" /> <!-- 근태구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 --> 
	<t:ExtComboStore comboType="A" comboCode="H004" /> <!-- 근무조 --> 
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_ATTEND}" storeId="hat510ukrsComboStore"/> <!-- 근태구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	var dutycodes = '' //근태구분
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hat520ukrModel', {
		fields: [
			
			{name: 'WORK_TEAM'    		, text: '<t:message code="system.label.human.workteam" default="근무조"/>'			, type: 'string', comboType:'AU', comboCode:'H004', allowBlank: false},
			{name: 'DIV_CODE'     		, text: '<t:message code="system.label.human.division" default="사업장"/>'			, type: 'string', comboType:'BOR120'},
			{name: 'DUTY_YYYYMMDD'		, text: '<t:message code="system.label.human.dutyyyymmdd" default="근무일"/>'		, type: 'uniDate', allowBlank: false},
			{name: 'DEPT_CODE'          , text: '<t:message code="system.label.human.deptcode" default="부서코드"/>'        , type: 'string'},
			{name: 'DEPT_NAME'    		, text: '<t:message code="system.label.human.department" default="부서"/>'		, type: 'string'},
			{name: 'POST_CODE'			, text: '<t:message code="system.label.human.postcode" default="직위"/>'			, type: 'string', comboType:'AU',comboCode:'H005'},
			{name: 'NAME'		   		, text: '<t:message code="system.label.human.name" default="성명"/>'			    , type: 'string', maxLength: 10},
			{name: 'PERSON_NUMB'		, text: '<t:message code="system.label.human.personnumb" default="사번"/>'		, type: 'string', allowBlank: false, maxLength: 20},
			{name: 'PAY_CODE'			, text: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>'	, type: 'string', comboType: 'AU', comboCode: 'H028', editable: false},
			{name: 'DUTY_CODE'			, text: '<t:message code="system.label.human.dutytype" default="근태구분"/>'		, type: 'string', comboType:'AU', comboCode:'H033', allowBlank: false, maxLength: 20},
			{name: 'DUTY_FR_D'			, text: '<t:message code="system.label.human.caldate" default="일자"/>'			, type: 'uniDate'},
			{name: 'DUTY_FR_H'			, text: '<t:message code="system.label.human.hour" default="시"/>'				, type: 'int', maxLength: 2},
			{name: 'DUTY_FR_M'			, text: '<t:message code="system.label.human.minute" default="분"/>'				, type: 'int', maxLength: 2},
			{name: 'DUTY_TO_D'			, text: '<t:message code="system.label.human.caldate" default="일자"/>'			, type: 'uniDate'},
			{name: 'DUTY_TO_H'    		, text: '<t:message code="system.label.human.hour" default="시"/>'				, type: 'int', maxLength: 2},
			{name: 'DUTY_TO_M'    		, text: '<t:message code="system.label.human.minute" default="분"/>'				, type: 'int', maxLength: 2},
			{name: 'DEDUCTION_MIN'		, text: '<t:message code="system.label.human.dedtime" default="차감시간"/>(<t:message code="system.label.human.minute" default="분"/>)'		, type: 'int'},
			{name: 'REMARK'       		, text: '<t:message code="system.label.human.remark" default="비고"/>'			, type: 'string', maxLength: 150}
		]
	});//End of Unilite.defineModel('Hat520ukrModel', {
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */			
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create: 'hat520ukrService.insertList',				
			read: 'hat520ukrService.selectList',
			update: 'hat520ukrService.updateList',
			destroy: 'hat520ukrService.deleteList',
			syncAll: 'hat520ukrService.saveAll'
		}
	});
	
	var directMasterStore1 = Unilite.createStore('hat520ukrMasterStore1', {
		model: 'Hat520ukrModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable: true,			// 삭제 가능 여부 
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();			
			console.log(param);
			this.load({
				params: param
			});
		},
        saveStore : function()	{				
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 )	{
				config = {
//					params: [paramMaster],
					success: function(batch, option) {
						
					 } 
				};
				this.syncAllDirect(config);				
			}else {    				
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function() {
				if (this.getCount() > 0) {
//	              	UniAppManager.setToolbarButtons('delete', true);
	                } else {
//	              	  	UniAppManager.setToolbarButtons('delete', false);
	                }  
			}
		}
	});//End of var directMasterStore1 = Unilite.createStore('hat520ukrMasterStore1', {
		
	/**
	 * Store 정의(Combobox)
	 * @type 
	 */					
//	var comboStore = Unilite.createStore('comboStore', {
//        autoLoad: true,
//        fields: [
//                {name: 'SUB_CODE', type : 'string'}, 
//	    		{name: 'CODE_NAME', type : 'string'} 
//                ],
//        proxy: {
//				type: 'ajax', 
//				url: CPATH+'/human/getDutyList.do',
//				extraParams:{ S_COMP_CODE: UserInfo.compCode }
//        }
//	});//End of var comboStore = Unilite.createStore('comboStore', {

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */

	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.human.searchconditon" default="검색조건"/>',		
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,
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
				fieldLabel: '<t:message code="system.label.human.dutydate" default="근태일자"/>',
				xtype: 'uniDatefield',
				name: 'DUTY_YYYYMMDD',                
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DUTY_YYYYMMDD', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',
				name: 'PAY_CODE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H028',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_CODE', newValue);
						var param = {PAY_CODE : newValue}
						hat520ukrService.getDutyList(param, function(provider, response){								
							dutycodes = '';
							Ext.each(provider, function(rec, idx){
								dutycodes += provider[idx].SUB_CODE;
							});
						});
					}
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
				comboCode: 'H011'
			},
	         	Unilite.popup('Employee',{
									
				validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
//							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
//							panelResult.setValue('NAME', panelSearch.getValue('NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
//						panelResult.setValue('PERSON_NUMB', '');
//						panelResult.setValue('NAME', '');
					}
				}
	         })]
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '<t:message code="system.label.human.dutydate" default="근태일자"/>',
			xtype: 'uniDatefield',
			name: 'DUTY_YYYYMMDD',                
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DUTY_YYYYMMDD', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',
			name: 'PAY_CODE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H028',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAY_CODE', newValue);
					var param = {PAY_CODE : newValue}
					hat520ukrService.getDutyList(param, function(provider, response){								
						dutycodes = '';
						Ext.each(provider, function(rec, idx){
							dutycodes += provider[idx].SUB_CODE;
						});
					});
				}
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
		}]	
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('hat520ukrGrid1', {
    	// for tab    	
		layout: 'fit',
		region: 'center',
    	uniOpt: {
    		expandLastColumn: false,
		 	useRowNumberer: true,
		 	copiedRow: true
//		 	useContextMenu: true,
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
		store: directMasterStore1,
		columns: [	
			{dataIndex: 'WORK_TEAM'    		, width: 100},
			{dataIndex: 'DIV_CODE'     		, width: 130},
			{dataIndex: 'DUTY_YYYYMMDD'		, width: 120, hidden: true},
			{dataIndex: 'DEPT_CODE'         , width: 100, hidden: true},
			{dataIndex: 'DEPT_NAME'    		, width: 130},
			{dataIndex: 'POST_CODE'			, width: 86},
			{dataIndex: 'NAME'		  		, width: 86
				,editor: Unilite.popup('Employee_G', {
						autoPopup: true,
						listeners: {'onSelected': {
										fn: function(records, type) {
												console.log('records : ', records);
												console.log(records);
												var grdRecord = masterGrid.getSelectionModel().getSelection()[0];
												grdRecord.set('DIV_CODE', records[0].DIV_CODE);
												grdRecord.set('DUTY_YYYYMMDD', panelSearch.getValue('DUTY_YYYYMMDD'));
												grdRecord.set('DEPT_NAME', records[0].DEPT_NAME);
												grdRecord.set('POST_CODE', records[0].POST_CODE);
												grdRecord.set('NAME', records[0].NAME);
												grdRecord.set('PERSON_NUMB', records[0].PERSON_NUMB);
												grdRecord.set('PAY_CODE', records[0].PAY_CODE);
												//근무조 컬럼에 데이터를 넣음
												var params = {
													S_COMP_CODE: UserInfo.compCode, 
													DUTY_YYYYMMDD: dateChange(panelSearch.getValue('DUTY_YYYYMMDD')),
													PERSON_NUMB: records[0].PERSON_NUMB
												}												
												hat520ukrService.getWorkTeam(params, function(provider, response)	{							
													if(!Ext.isEmpty(provider)){
														grdRecord.set('WORK_TEAM', provider);
													}													
												});			
												
//												Ext.Ajax.request({
//													url     : CPATH+'/human/getWorkTeam.do',
//													params: {
//														S_COMP_CODE: UserInfo.compCode, 
//														DUTY_YYYYMMDD: dateChange(panelSearch.getValue('DUTY_YYYYMMDD')),
//														PERSON_NUMB: records[0].PERSON_NUMB
//													},
//													method: 'get',
//													success: function(response){
//														if (response.responseText.indexOf('fail') == -1) {
//															var data = JSON.parse(Ext.decode(response.responseText));
//															console.log(data);
//															if (data != null) {
//																grdRecord.set('WORK_TEAM', data);
//															}		
//														}
//													},
//													failure: function(response){ alert('fail');
//														console.log(response);
//														grdRecord.set('WORK_TEAM', '');
//													}
//												});	
												
											},
										scope: this
										},
									'onClear': function(type) {
										var grdRecord = masterGrid.getSelectionModel().getSelection()[0];
										grdRecord.set('DIV_CODE', '');
										grdRecord.set('DUTY_YYYYMMDD', '');
										grdRecord.set('DEPT_NAME', '');
										grdRecord.set('POST_CODE', '');
										grdRecord.set('NAME', '');
										grdRecord.set('PERSON_NUMB', '');
										grdRecord.set('PAY_CODE', '');
										}
					}
				})
			},
			{dataIndex: 'PERSON_NUMB'		, width: 86
				,editor: Unilite.popup('Employee_G', {
					autoPopup: true,
					DBtextFieldName: 'PERSON_NUMB',
					listeners: {'onSelected': {
									fn: function(records, type) {
											console.log('records : ', records);
											var grdRecord = masterGrid.getSelectionModel().getSelection()[0];
											grdRecord.set('DIV_CODE', records[0].DIV_CODE);
											grdRecord.set('DUTY_YYYYMMDD', panelSearch.getValue('DUTY_YYYYMMDD'));
											grdRecord.set('DEPT_NAME', records[0].DEPT_NAME);
											grdRecord.set('POST_CODE', records[0].POST_CODE);
											grdRecord.set('NAME', records[0].NAME);
											grdRecord.set('PERSON_NUMB', records[0].PERSON_NUMB);
											grdRecord.set('PAY_CODE', records[0].PAY_CODE);
											//근무조 컬럼에 데이터를 넣음
											var params = {
												S_COMP_CODE: UserInfo.compCode, 
												DUTY_YYYYMMDD: dateChange(panelSearch.getValue('DUTY_YYYYMMDD')),
												PERSON_NUMB: records[0].PERSON_NUMB
											}												
											hat520ukrService.getWorkTeam(params, function(provider, response)	{							
												if(!Ext.isEmpty(provider)){
													grdRecord.set('WORK_TEAM', provider);
												}													
											});
//											Ext.Ajax.request({
//												url     : CPATH+'/human/getWorkTeam.do',
//												params: {
//													S_COMP_CODE: UserInfo.compCode, 
//													DUTY_YYYYMMDD: dateChange(panelSearch.getValue('DUTY_YYYYMMDD')),
//													PERSON_NUMB: records[0].PERSON_NUMB
//												},
//												method: 'get',
//												success: function(response){
//													if (response.responseText.indexOf('fail') == -1) {
//														var data = JSON.parse(Ext.decode(response.responseText));
//														console.log(data);
//														if (data != null) {
//															grdRecord.set('WORK_TEAM', data);
//														}		
//													}
//												},
//												failure: function(response){
//													console.log(response);
//													grdRecord.set('WORK_TEAM', '');
//												}
//											});	
										},
									scope: this
									},
								'onClear': function(type) {
									var grdRecord = masterGrid.getSelectionModel().getSelection()[0];
									grdRecord.set('WORK_TEAM', '');
									grdRecord.set('DIV_CODE', '');
									grdRecord.set('DUTY_YYYYMMDD', '');
									grdRecord.set('DEPT_NAME', '');
									grdRecord.set('POST_CODE', '');
									grdRecord.set('NAME', '');
									grdRecord.set('PERSON_NUMB', '');
									grdRecord.set('PAY_CODE', '');
									}
					}
				})
			},
			{dataIndex: 'PAY_CODE'			, width: 100},
			{dataIndex: 'DUTY_CODE'			, width: 100
			 , editor: {
					xtype		: 'uniCombobox',
					store		: Ext.StoreManager.lookup('hat510ukrsComboStore'),
					listeners:{
						beforequery : function(queryPlan, eOpts){
							var store = queryPlan.combo.store;
							var record = masterGrid.getSelectedRecord();
							store.filter('option', record.get("PAY_CODE"));
						}
					}
				}
			},
			{text: '<t:message code="system.label.human.starttime" default="시작시간"/>',
        		columns: [
					{dataIndex: 'DUTY_FR_D'			, width: 110, editor:
						{
					        xtype: 'datefield',
					        allowBlank: false,
					        format: 'Y/m/d'
					    }
					},
					{dataIndex: 'DUTY_FR_H'			, width: 66, align: 'right'},
					{dataIndex: 'DUTY_FR_M'			, width: 66, align: 'right'}
				]
			},{text: '<t:message code="system.label.human.endtime" default="종료시간"/>',
        		columns: [
					{dataIndex: 'DUTY_TO_D'			, width: 110, editor: 
						{
					        xtype: 'datefield',
					        allowBlank: false,
					        format: 'Y/m/d'
					    }
					},
					{dataIndex: 'DUTY_TO_H'    		, width: 66, align: 'right'},
					{dataIndex: 'DUTY_TO_M'    		, width: 66, align: 'right'}
				]
			},
			{dataIndex: 'DEDUCTION_MIN'		, width: 133, align: 'right'},
			{dataIndex: 'REMARK'       		, minWidth: 300, flex: 1}
		],
        listeners: {
          	beforeedit: function(editor, e) {
				if (e.record.phantom) {
					//insert					
					if (e.field == 'WORK_TEAM' || e.field == 'DIV_CODE' || e.field == 'DEPT_NAME' || e.field == 'POST_CODE'|| e.field == 'PAY_CODE') return false;
				} else {
					// update					
					if (e.field == 'WORK_TEAM' || e.field == 'DIV_CODE' || e.field == 'DEPT_NAME' || e.field == 'POST_CODE' 
							|| e.field == 'NAME' || e.field == 'PERSON_NUMB' || e.field == 'DUTY_CODE' || e.field == 'DUTY_FR_D'|| e.field == 'PAY_CODE') return false;
				}
			}, edit: function(editor, e) {
				var fieldName = e.field;
				var num_check = /[0-9]/;
				if (fieldName.indexOf('_H') != -1 || fieldName.indexOf('_M') != -1) {
					if (!num_check.test(e.value)) {
							Ext.Msg.alert('<t:message code="system.label.human.confirm" default="확인"/>', '<t:message code="system.message.human.message033" default="숫자형식이 잘못되었습니다."/>');
							e.record.set(fieldName, e.originalValue);
							return false;
					}
					if (fieldName.indexOf('_H') != -1) {
						if (parseInt(e.value) > 24 || parseInt(e.value) < 0) {
							Ext.Msg.alert('<t:message code="system.label.human.confirm" default="확인"/>', '<t:message code="system.message.human.message034" default="정확한 시를 입력하십시오."/>');
							e.record.set(fieldName, e.originalValue);
							return false;
						}
					} else {
						if (parseInt(e.value) > 60 || parseInt(e.value) < 0) {
							Ext.Msg.alert('<t:message code="system.label.human.confirm" default="확인"/>', '<t:message code="system.message.human.message036" default="정확한 분을 입력하십시오."/>');
							e.record.set(fieldName, e.originalValue);
							return false;
						}
					}
				}
//				if (e.originalValue != e.value) {
//					UniAppManager.setToolbarButtons('save', true);
//				} 
// 				else {
// 					UniAppManager.setToolbarButtons('save', false);
// 				}
			}
          }
	});//End of var masterGrid = Unilite.createGr100id('hat520ukrGrid1', {   
                                                 
	Unilite.Main( {
		border: false,
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
		id: 'hat520ukrApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('DUTY_YYYYMMDD', UniDate.get('today'));
			//panelSearch.setValue('PAY_CODE', '0');			
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DUTY_YYYYMMDD', UniDate.get('today'));
			//panelResult.setValue('PAY_CODE', '0');
			var param = {PAY_CODE : panelResult.getValue('PAY_CODE')}
			hat520ukrService.getDutyList(param, function(provider, response){								
				dutycodes = '';
				Ext.each(provider, function(rec, idx){
					dutycodes += provider[idx].SUB_CODE;
				});				
			});			
			UniAppManager.setToolbarButtons(['reset','newData'], true);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DUTY_YYYYMMDD');
		},
		onQueryButtonDown: function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			var detailform = panelSearch.getForm();
			if (detailform.isValid()) {
				masterGrid.getStore().loadStoreRecords();
				panelSearch.getForm().getFields().each(function(field) {
				      field.setReadOnly(true);
				});
				panelResult.getForm().getFields().each(function(field) {
				      field.setReadOnly(true);
				});
				UniAppManager.setToolbarButtons('reset', true);
			} else {
				var invalid = panelSearch.getForm().getFields()
						.filterBy(function(field) {
							return !field.validate();
						});

				if (invalid.length > 0) {
					r = false;
					var labelText = ''

					if (Ext
							.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel']
								+ '은(는)';
					} else if (Ext
							.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']
								+ '은(는)';
					}

					Ext.Msg.alert('<t:message code="system.label.human.confirm" default="확인"/>', labelText + '<t:message code="system.message.human.message045" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				}
			}
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		onNewDataButtonDown : function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			panelSearch.getForm().getFields().each(function(field) {
			      field.setReadOnly(true);
			});
			panelResult.getForm().getFields().each(function(field) {
			      field.setReadOnly(true);
			});
			var record = {
					DUTY_FR_D: panelSearch.getValue('DUTY_YYYYMMDD'),
					DUTY_FR_H: 0,
					DUTY_FR_M: 0,
					DUTY_TO_D: panelSearch.getValue('DUTY_YYYYMMDD'),
					DUTY_TO_H: 0,
					DUTY_TO_M: 0,
					DEDUCTION_MIN: 0
			};
			masterGrid.createRow(record, 'PERSON_NUMB');
//			UniAppManager.setToolbarButtons('delete', true);
//			UniAppManager.setToolbarButtons('save', true);
		},
		onSaveDataButtonDown : function() {
			if (masterGrid.getStore().isDirty()) {
				// 입력데이터 validation
				if (!checkValidaionGrid()) {
					return false;
				}
				masterGrid.getStore().saveStore();
			}
		},
		onDeleteDataButtonDown : function()	{
//			var selRow = masterGrid.getSelectionModel().getSelection()[0];
//			if (selRow.phantom === true)	{
//				masterGrid.deleteSelectedRow();
//			} else {
//				Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
//					if (btn == 'yes') {
//						masterGrid.deleteSelectedRow();
//						masterGrid.getStore().sync();
//					}
//				});
//			}
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.human.message032" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onResetButtonDown : function() {
			panelSearch.getForm().getFields().each(function(field) {
			      field.setReadOnly(false);
			});
			panelResult.getForm().getFields().each(function(field) {
			      field.setReadOnly(false);
			});
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();;
		}
	});//End of Unilite.Main( {
	
	// 쿼리 조건에 이용하기 위하여 근태년월의 형식을 변경함
	function dateChange(value) {
		if (value == null || value == '') return '';
		var year = value.getFullYear();
		var mon = value.getMonth() + 1;
		var day = value.getDate();   
		return year + '' + (mon >= 10 ? mon : '0' + mon) + '' + (day >= 10 ? day : '0' + day);
	}
	
	// insert, update 전 입력값  검증(시작/종료 시간)
	 function checkValidaionGrid() {
		 // 시작시간/종료시간 검증
		 var rightTimeInputed = true;
		 // 필수 입력항목 입력 여부 검증
		 var necessaryFieldInputed = true;
		 var MsgTitle = '<t:message code="system.label.human.confirm" default="확인"/>';
		 var MsgErr01 = '<t:message code="system.message.human.message037" default="시작시간이 종료 시간 보다 클 수 없습니다."/>';
		 var MsgErr02 = '<t:message code="system.message.human.message039" default="은(는) 필수 입력 항목 입니다"/>';

//		 var selectedModel = masterGrid.getStore().getRange();
		 var records = directMasterStore1.data.items;
		 Ext.each(records, function(record,i){
			 if(record.dirty == true){
			 	var date_fr = parseInt(dateChange(record.data.DUTY_FR_D));
			 	var date_to = parseInt(dateChange(record.data.DUTY_TO_D));
			 	var fr_time = parseInt(record.data.DUTY_FR_H*60 + record.data.DUTY_FR_M);
				var to_time = parseInt(record.data.DUTY_TO_H*60 + record.data.DUTY_TO_M);
			 
				 if ( (date_fr != '' && date_to == '') || (date_fr == '' && date_to != '') ) {
					 rightTimeInputed = false;
					 return;
				 } else if (date_fr != '' && date_to != '') {
					 if ((date_fr > date_to)) {
						 rightTimeInputed = false;
						 return;
					 } else {
						if (date_fr == date_to && fr_time >= to_time) {
							rightTimeInputed = false;
							return;
						}
					 }
				 }
				 
	//			 if (record.data.WORK_TEAM == '') {
	//				 MsgErr02 = '근무조' + MsgErr02;
	//				 necessaryFieldInputed = false;
	//				 return;
	//			 } else if (record.data.DIV_CODE == '') {
	//				 MsgErr02 = '사업장' + MsgErr02;
	//				 necessaryFieldInputed = false;
	//				 return;
	//			 } else if (record.data.DEPT_NAME == '') {
	//				 MsgErr02 = '부서' + MsgErr02;
	//				 necessaryFieldInputed = false;
	//				 return;
	//			 } else if (record.data.POST_CODE == '') {
	//				 MsgErr02 = '직위' + MsgErr02;
	//				 necessaryFieldInputed = false;
	//				 return;
	//			 } else if (record.data.NAME == '') {
	//				 MsgErr02 = '성명' + MsgErr02;
	//				 necessaryFieldInputed = false;
	//				 return;
	//			 } else if (record.data.PERSON_NUMB == '') {
	//				 MsgErr02 = '사번' + MsgErr02;
	//				 necessaryFieldInputed = false;
	//				 return;
	//			 } else if (record.data.DUTY_CODE == '') {
	//				 MsgErr02 = '근태구분' + MsgErr02;
	//				 necessaryFieldInputed = false;
	//				 return;
	//			 }
			 }
		 });
		 if (!rightTimeInputed) {
			 Ext.Msg.alert(MsgTitle, MsgErr01);
			 return rightTimeInputed;
		 }
		 if (!necessaryFieldInputed) {
			 Ext.Msg.alert(MsgTitle, MsgErr02);
			 return necessaryFieldInputed;
		 }
		 return true;
	 }
};


</script>
