<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sgp101ukrv"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="sgp101ukrv"/> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="S002" /> <!--매출구분-->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!--화폐-->
	<t:ExtComboStore comboType="AU" comboCode="B042" /> <!--계획금액단위-->	
</t:appConfig>
<script type="text/javascript" >


function appMain() {
	var gsConfirmYN = '';
	/**
	 *   Model 정의 
	 * @type 
	 */
   		
	Unilite.defineModel('Sgp101ukrvModel', {
	    fields: [{name: 'DIV_CODE'		  		,text: 'DIV_CODE'        ,type:'string'},	    		 
	    		 {name: 'PLAN_YEAR'		  		,text: 'PLAN_YEAR'       ,type:'string'},
	    		 {name: 'PLAN_TYPE1'		  	,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'      	 ,type:'string'},
	    		 {name: 'PLAN_TYPE2'		  	,text: 'TAB'      		 ,type:'string', defaultValue: '8'},
	    		 {name: 'PLAN_TYPE2_CODE'		,text: 'PLAN_TYPE2_CODE' ,type:'string'},
	    		 {name: 'LEVEL_KIND'		  	,text: 'LEVEL_KIND'      ,type:'string', defaultValue: '*'},
	    		 {name: 'MONEY_UNIT'		  	,text: 'MONEY_UNIT'      ,type:'string'},
	    		 {name: 'ENT_MONEY_UNIT'		,text: 'ENT_MONEY_UNIT'  ,type:'string'},
	    		 {name: 'CONFIRM_YN'		  	,text: 'CONFIRM_YN'      ,type:'string', defaultValue: 'N'},
	    		 {name: 'S_CODE'		  		,text: '<t:message code="system.label.sales.department" default="부서"/>'         ,type:'string', allowBlank: false},
	    		 {name: 'S_NAME'		  		,text: '<t:message code="system.label.sales.departmentname" default="부서명"/>'          ,type:'string'},
	    		 {name: 'PLAN_SUM'		  		,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'          ,type:'uniPrice'},
	    		 {name: 'MOD_PLAN_SUM'		  	,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'          ,type:'uniPrice'},
	    		 {name: 'A_D_RATE_SUM'		  	,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'  	         ,type:'uniPercent'},
	    		 {name: 'PLAN1'		  			,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'	         ,type:'uniPrice'},
	    		 {name: 'MOD_PLAN1'		  		,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'	         ,type:'uniPrice'},
	    		 {name: 'A_D_RATE1'		  		,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'	         ,type:'uniPercent'},
	    		 {name: 'PLAN2'				  	,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'	         ,type:'uniPrice'},
	    		 {name: 'MOD_PLAN2'		  		,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'	         ,type:'uniPrice'},
	    		 {name: 'A_D_RATE2'		  		,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'	         ,type:'uniPercent'},
	    		 {name: 'PLAN3'				  	,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'	         ,type:'uniPrice'},
	    		 {name: 'MOD_PLAN3'		  		,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'	         ,type:'uniPrice'},
	    		 {name: 'A_D_RATE3'		  		,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'	         ,type:'uniPercent'},
	    		 {name: 'PLAN4'				  	,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'	         ,type:'uniPrice'},
	    		 {name: 'MOD_PLAN4'		  		,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'	         ,type:'uniPrice'},
	    		 {name: 'A_D_RATE4'		  		,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'	         ,type:'uniPercent'},
	    		 {name: 'PLAN5'				  	,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'	         ,type:'uniPrice'},
	    		 {name: 'MOD_PLAN5'		  		,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'	         ,type:'uniPrice'},
	    		 {name: 'A_D_RATE5'		  		,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'	         ,type:'uniPercent'},
	    		 {name: 'PLAN6'				  	,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'	         ,type:'uniPrice'},
	    		 {name: 'MOD_PLAN6'		  		,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'	         ,type:'uniPrice'},
	    		 {name: 'A_D_RATE6'		  		,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'	         ,type:'uniPercent'},
	    		 {name: 'PLAN7'				  	,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'	         ,type:'uniPrice'},
	    		 {name: 'MOD_PLAN7'		  		,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'	         ,type:'uniPrice'},
	    		 {name: 'A_D_RATE7'		  		,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'	         ,type:'uniPercent'},
	    		 {name: 'PLAN8'				  	,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'	         ,type:'uniPrice'},
	    		 {name: 'MOD_PLAN8'		  		,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'	         ,type:'uniPrice'},
	    		 {name: 'A_D_RATE8'		  		,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'	         ,type:'uniPercent'},
	    		 {name: 'PLAN9'				  	,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'	         ,type:'uniPrice'},
	    		 {name: 'MOD_PLAN9'		  		,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'	         ,type:'uniPrice'},
	    		 {name: 'A_D_RATE9'		  		,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'	         ,type:'uniPercent'},
	    		 {name: 'PLAN10'				,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'	         ,type:'uniPrice'},
	    		 {name: 'MOD_PLAN10'		  	,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'	         ,type:'uniPrice'},
	    		 {name: 'A_D_RATE10'		  	,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'	         ,type:'uniPercent'},
	    		 {name: 'PLAN11'				,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'	         ,type:'uniPrice'},
	    		 {name: 'MOD_PLAN11'		  	,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'	         ,type:'uniPrice'},
	    		 {name: 'A_D_RATE11'		  	,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'	         ,type:'uniPercent'},
	    		 {name: 'PLAN12'				,text: '<t:message code="system.label.sales.yearplan" default="년초계획"/>'	         ,type:'uniPrice'},
	    		 {name: 'MOD_PLAN12'		  	,text: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>'	         ,type:'uniPrice'},
	    		 {name: 'A_D_RATE12'		  	,text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'	         ,type:'uniPercent'},
	    		 {name: 'UPDATE_DB_USER'		,text: 'UPDATE_DB_USER'  ,type:'string', defaultValue: UserInfo.userID},
	    		 {name: 'UPDATE_DB_TIME'		,text: 'UPDATE_DB_TIME'  ,type:'string'},
	    		 {name: 'COMP_CODE'		  		,text: 'COMP_CODE'	     ,type:'string', defaultValue: UserInfo.compCode}	
			]                                          
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'sgp101ukrvService.selectList',
			update: 'sgp101ukrvService.updateDetail',
			create: 'sgp101ukrvService.insertDetail',
			destroy: 'sgp101ukrvService.deleteDetail',
			syncAll: 'sgp101ukrvService.saveAll'
		}
	});
	var detailStore = Unilite.createStore('sgp101ukrvMasterStore1',{
		model: 'Sgp101ukrvModel',
		uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable:true,			// 삭제 가능 여부  
            useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
		loadStoreRecords : function()	{	
			var param= panelSearch.getValues();
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
//			param.AGENT_TYPE = customSubForm.getValue('AGENT_TYPE'); 
			console.log( param );
			this.load({
				params : param
			});			
		},saveStore : function(config)	{	
			var inValidRecs = this.getInvalidRecords();
        	
			if(inValidRecs.length == 0 )	{									
				config = {
					success: function(batch, option) {								
						panelSearch.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);	
						UniAppManager.app.onQueryButtonDown();
					 } 
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		_onStoreDataChanged: function( store, eOpts )	{
	    	if(this.uniOpt.isMaster) {
	       		console.log("_onStoreDataChanged store.count() : ", store.count());
	       		if(store.count() == 0)	{
	       			UniApp.setToolbarButtons(['delete'], false);
		    		Ext.apply(this.uniOpt.state, {'btn':{'delete':false}});
		    		if(this.uniOpt.useNavi) {
		       			UniApp.setToolbarButtons(['prev','next'], false);
		    		}
	       		}else {
	       			if(this.uniOpt.deletable)	{
	       				record = this.data.items[0];
	       				if(record.get('CONFIRM_YN') == "N"){
	       					UniApp.setToolbarButtons(['delete'], true);
	       				}		       			
			    		Ext.apply(this.uniOpt.state, {'btn':{'delete':true}});
	       			}
		    		if(this.uniOpt.useNavi) {
		       			UniApp.setToolbarButtons(['prev','next'], true);
		    		}
	       		}
	       		if(store.isDirty())	{
	       			UniApp.setToolbarButtons(['save'], true);
	       		}else {
	       			UniApp.setToolbarButtons(['save'], false);
	       		}
	    	}
	    },
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		if(store.getCount() != 0){
           			var fields = panelSearch.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ){
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;							
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
					
					fields = panelResult.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ){
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;							
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
           		}
           		if(!Ext.isEmpty(records[0])){
           			gsConfirmYN = records[0].get('CONFIRM_YN');	//확정여부
           			if(gsConfirmYN == "Y"){
           				Ext.getCmp('confirm_check').setText('<t:message code="system.label.sales.confirmationcancel" default="확정취소"/>');
           				Ext.getCmp('confirm_check2').setText('<t:message code="system.label.sales.confirmationcancel" default="확정취소"/>');
           				Ext.getCmp('confirm_check').show();
           				Ext.getCmp('confirm_check2').show();
           			}else if(gsConfirmYN == "N"){
           				Ext.getCmp('confirm_check').setText('<t:message code="system.label.sales.yearplanconfirm" default="년초계획확정"/>');
           				Ext.getCmp('confirm_check2').setText('<t:message code="system.label.sales.yearplanconfirm" default="년초계획확정"/>');
           				Ext.getCmp('confirm_check').show();           			
           				Ext.getCmp('confirm_check2').show();
           			}
           			panelSearch.setValue('MONEY_UNIT_DIV',records[0].get('ENT_MONEY_UNIT'));
           			panelResult.setValue('MONEY_UNIT_DIV',records[0].get('ENT_MONEY_UNIT'));
           		}else{
           			gsConfirmYN = 'C' //기초데이터 생성
           			Ext.getCmp('confirm_check').setText('기초데이타생성');
           			Ext.getCmp('confirm_check2').setText('기초데이타생성');
           			Ext.getCmp('confirm_check').show();
           			Ext.getCmp('confirm_check2').show();
           		}         		
           	}           	
		}
	});
	
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */	
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',		
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
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',   			
	    	items: [{
	        	fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
	        	name: 'DIV_CODE', 
	        	xtype: 'uniCombobox', 
	        	comboType: 'BOR120',
	        	allowBlank:false,
	        	holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
	        },{
				fieldLabel: '<t:message code="system.label.sales.planyear" default="계획년도"/>',
				name: 'PLAN_YEAR',
				xtype: 'uniYearField',
				value: new Date().getFullYear(),
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PLAN_YEAR', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
				name:'ORDER_TYPE',	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'S002',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ORDER_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.sales.currency" default="화폐"/>',
				name:'MONEY_UNIT',	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'B004',
				allowBlank: false,
				displayField: 'value',
				holdable: 'hold',
				fieldStyle: 'text-align: center;',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('MONEY_UNIT', newValue);
					}
				}
			},
			Unilite.popup('DEPT', { 
			fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
			valueFieldName: 'DEPT_CODE',
	   	 	textFieldName: 'DEPT_NAME',
			holdable: 'hold',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
						panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
                	},
					scope: this
				},
				onClear: function(type)	{
					panelResult.setValue('DEPT_CODE', '');
					panelResult.setValue('DEPT_NAME', '');
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
				fieldLabel: '<t:message code="system.label.sales.planamountunit" default="계획금액단위"/>',
				name:'MONEY_UNIT_DIV',	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'B042',
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('MONEY_UNIT_DIV', newValue);
					}
				}
			},{ xtype: 'container',
			items:[{
				margin: '0 0 0 95',
				xtype: 'button',
				name: 'CONFIRM_CHECK',
				id: 'confirm_check2',
				text: '',
				handler: function() {
					 
					if(gsConfirmYN == "C"){
						var param = panelSearch.getValues();
						var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
						var deptCode = UserInfo.deptCode;	//부서코드
						if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
							param.DEPT_CODE = deptCode;
						}
						sgp101ukrvService.createBaseData(param, function(provider, response)	{
							if(!panelSearch.setAllFieldsReadOnly(true)){
								return false;												
							}
							if(!panelResult.setAllFieldsReadOnly(true)){
								return false;	
							}
							Ext.each(provider, function(deptData){
								UniAppManager.app.onNewDataButtonDown(deptData);
			        		});
			        		Ext.getCmp('confirm_check').hide();
			        		Ext.getCmp('confirm_check2').hide();
							return false;
						});
					}else{
						if(!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled( )){		//needsave이면?
						//if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {
							//	me.onQueryButtonDown();
							//}
							Ext.Msg.show({
							     title:'확인',
							     msg: Msg.sMB017 + "\n" + Msg.sMB061,
							     buttons: Ext.Msg.YESNOCANCEL,
							     icon: Ext.Msg.QUESTION,
							     fn: function(res) {
							     	//console.log(res);
							     	if (res === 'yes' ) {
							     		UniAppManager.app.onSaveAndQueryButtonDown();
							     	} else if(res === 'no') {
							     		var record = detailStore.data.items[0];
										var param = {
											DIV_CODE: record.get('DIV_CODE'),
											PLAN_YEAR: record.get('PLAN_YEAR'),
											PLAN_TYPE1: record.get('PLAN_TYPE1'),
											PLAN_TYPE2: record.get('PLAN_TYPE2'),
											PLAN_TYPE2_CODE: record.get('PLAN_TYPE2_CODE'),
											LEVEL_KIND: record.get('LEVEL_KIND'),
											MONEY_UNIT: record.get('MONEY_UNIT')
										}
										if(gsConfirmYN == "Y"){
											sgp101ukrvService.selectConfirmN(param, function(provider, response)	{
												if(provider[0].CONFIRM_YN == "N"){
													Unilite.messageBox('<t:message code="system.message.sales.message137" default="이미 취소되었거나 확정되지 않았습니다."/>');
													return false;
												}else{
													sgp101ukrvService.confirmSetN(param, function(provider, response)	{
														UniAppManager.app.onQueryButtonDown();
													});
												}
											});	
												
										}else{
											sgp101ukrvService.selectConfirmY(param, function(provider, response)	{
												if(provider[0].CONFIRM_YN == "Y"){
													Unilite.messageBox('<t:message code="system.message.sales.message138" default="이미 확정되었습니다."/>');
													return false;
												}else{
													sgp101ukrvService.confirmSetY(param, function(provider, response)	{
														UniAppManager.app.onQueryButtonDown();
													});
												}
											});
										}
							     	}
							     }
							});
						}else{
							var record = detailStore.data.items[0];
							var param = {
								DIV_CODE: record.get('DIV_CODE'),
								PLAN_YEAR: record.get('PLAN_YEAR'),
								PLAN_TYPE1: record.get('PLAN_TYPE1'),
								PLAN_TYPE2: record.get('PLAN_TYPE2'),
								PLAN_TYPE2_CODE: record.get('PLAN_TYPE2_CODE'),
								LEVEL_KIND: record.get('LEVEL_KIND'),
								MONEY_UNIT: record.get('MONEY_UNIT')
							}
							if(gsConfirmYN == "Y"){							
								sgp101ukrvService.selectConfirmN(param, function(provider, response)	{
									if(provider[0].CONFIRM_YN == "N"){
										Unilite.messageBox('<t:message code="system.message.sales.message137" default="이미 취소되었거나 확정되지 않았습니다."/>');
										return false;
									}else{
										sgp101ukrvService.confirmSetN(param, function(provider, response)	{
											UniAppManager.app.onQueryButtonDown();
										});
									}
								});	
									
							}else{
								sgp101ukrvService.selectConfirmY(param, function(provider, response)	{
									if(provider[0].CONFIRM_YN == "Y"){
										Unilite.messageBox('<t:message code="system.message.sales.message138" default="이미 확정되었습니다."/>');
										return false;
									}else{
										sgp101ukrvService.confirmSetY(param, function(provider, response)	{
											UniAppManager.app.onQueryButtonDown();								
										});
									}
								});
								
							}
						}
					}
					
				}	
			}
		]}
		]
		}],
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

				   	Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
				   	invalid.items[0].focus();
				} else {
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ){
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;							
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
   				}
	  		} else {
				//this.unmask();
	  			var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false); 
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;	
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;  		
		}
	});
    var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
        	fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
        	name: 'DIV_CODE', 
        	xtype: 'uniCombobox', 
        	comboType: 'BOR120',
        	allowBlank:false,
        	holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
        },{
			fieldLabel: '<t:message code="system.label.sales.planyear" default="계획년도"/>',
			name: 'PLAN_YEAR',
			xtype: 'uniYearField',
			value: new Date().getFullYear(),
			allowBlank: false,
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PLAN_YEAR', newValue);
				}
			}
		}/*,{
			xtype: 'button',
			name: 'CONFIRM_N',
			id: 'confirm_n',
			text: '<t:message code="system.label.sales.confirmationcancel" default="확정취소"/>',
			hidden: true,
			handler: function() {
				
			}			
		},{
			xtype: 'button',
			name: 'CREDIT_DATA',
			id: 'credit_data',
			text: '기초데이타생성',
			hidden: true,
			handler: function() {
				
			}			
		}*/,
			Unilite.popup('DEPT', { 
			fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
			valueFieldName: 'DEPT_CODE',
	   	 	textFieldName: 'DEPT_NAME',
			holdable: 'hold',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
						panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
                	},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('DEPT_CODE', '');
					panelSearch.setValue('DEPT_NAME', '');
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
		}),{ xtype: 'container',
			items:[{
				margin: '0 0 0 50',
				xtype: 'button',
				name: 'CONFIRM_CHECK',
				id: 'confirm_check',
				text: '',
				handler: function() {
					 
					if(gsConfirmYN == "C"){
						var param = panelSearch.getValues();
						var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
						var deptCode = UserInfo.deptCode;	//부서코드
						if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
							param.DEPT_CODE = deptCode;
						}
						sgp101ukrvService.createBaseData(param, function(provider, response){
							Ext.each(provider, function(deptData){
								UniAppManager.app.onNewDataButtonDown(deptData);
			        		});
			        		if(!panelSearch.setAllFieldsReadOnly(true)){
								return false;												
							}
							if(!panelResult.setAllFieldsReadOnly(true)){
								return false;	
							}
			        		Ext.getCmp('confirm_check').hide();
			        		Ext.getCmp('confirm_check2').hide();
							return false;
						});
					}else{
						if(!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled( )){		//needsave이면?
						//if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {
							//	me.onQueryButtonDown();
							//}
							Ext.Msg.show({
							     title:'확인',
							     msg: Msg.sMB017 + "\n" + Msg.sMB061,
							     buttons: Ext.Msg.YESNOCANCEL,
							     icon: Ext.Msg.QUESTION,
							     fn: function(res) {
							     	//console.log(res);
							     	if (res === 'yes' ) {
							     		UniAppManager.app.onSaveAndQueryButtonDown();
							     	} else if(res === 'no') {
							     		var record = detailStore.data.items[0];
										var param = {
											DIV_CODE: record.get('DIV_CODE'),
											PLAN_YEAR: record.get('PLAN_YEAR'),
											PLAN_TYPE1: record.get('PLAN_TYPE1'),
											PLAN_TYPE2: record.get('PLAN_TYPE2'),
											PLAN_TYPE2_CODE: record.get('PLAN_TYPE2_CODE'),
											LEVEL_KIND: record.get('LEVEL_KIND'),
											MONEY_UNIT: record.get('MONEY_UNIT')
										}
										if(gsConfirmYN == "Y"){							
											sgp101ukrvService.selectConfirmN(param, function(provider, response)	{
												if(provider[0].CONFIRM_YN == "N"){
													Unilite.messageBox('<t:message code="system.message.sales.message137" default="이미 취소되었거나 확정되지 않았습니다."/>');
													return false;
												}else{
													sgp101ukrvService.confirmSetN(param, function(provider, response)	{
														UniAppManager.app.onQueryButtonDown();
													});
												}
											});	
												
										}else{
											sgp101ukrvService.selectConfirmY(param, function(provider, response)	{
												if(provider[0].CONFIRM_YN == "Y"){
													Unilite.messageBox('<t:message code="system.message.sales.message138" default="이미 확정되었습니다."/>');
													return false;
												}else{
													sgp101ukrvService.confirmSetY(param, function(provider, response)	{
														UniAppManager.app.onQueryButtonDown();								
													});
												}
											});
											
										}						     		
							     	}
							     }
							});
						}else{
							var record = detailStore.data.items[0];
							var param = {
								DIV_CODE: record.get('DIV_CODE'),
								PLAN_YEAR: record.get('PLAN_YEAR'),
								PLAN_TYPE1: record.get('PLAN_TYPE1'),
								PLAN_TYPE2: record.get('PLAN_TYPE2'),
								PLAN_TYPE2_CODE: record.get('PLAN_TYPE2_CODE'),
								LEVEL_KIND: record.get('LEVEL_KIND'),
								MONEY_UNIT: record.get('MONEY_UNIT')
							}
							if(gsConfirmYN == "Y"){
								sgp101ukrvService.selectConfirmN(param, function(provider, response)	{
									if(provider[0].CONFIRM_YN == "N"){
										Unilite.messageBox('<t:message code="system.message.sales.message137" default="이미 취소되었거나 확정되지 않았습니다."/>');
										return false;
									}else{
										sgp101ukrvService.confirmSetN(param, function(provider, response)	{
											UniAppManager.app.onQueryButtonDown();
										});
									}
								});	
									
							}else{
								sgp101ukrvService.selectConfirmY(param, function(provider, response)	{
									if(provider[0].CONFIRM_YN == "Y"){
										Unilite.messageBox('<t:message code="system.message.sales.message138" default="이미 확정되었습니다."/>');
										return false;
									}else{
										sgp101ukrvService.confirmSetY(param, function(provider, response)	{
											UniAppManager.app.onQueryButtonDown();
										});
									}
								});
								
							}
						}
					}
					
				}	
			}
		]},{
			fieldLabel: '<t:message code="system.label.sales.planamountunit" default="계획금액단위"/>',
			name:'MONEY_UNIT_DIV',	
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'B042',
			allowBlank: false,
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('MONEY_UNIT_DIV', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
			name:'ORDER_TYPE',	
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'S002',
			allowBlank: false,
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ORDER_TYPE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.sales.currency" default="화폐"/>',
			name:'MONEY_UNIT',	
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'B004',
			displayField: 'value',
			allowBlank: false,
			holdable: 'hold',
			fieldStyle: 'text-align: center;',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('MONEY_UNIT', newValue);
				}
			}
		}],
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

//				   	Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');	중복알림 금지
				   	invalid.items[0].focus();
				} else {
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ){
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;							
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
   				}
	  		} else {
				//this.unmask();
	  			var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false); 
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;	
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;  		
		}		
    });		
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */

    var masterGrid = Unilite.createGrid('sgp101ukrvCustomMasterGrid', {
        layout : 'fit',        
    	store: detailStore,
    	region: 'center',
    	flex: 1,
        uniOpt: {
			expandLastColumn: false,
			useMultipleSorting: true,
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
    		filter: {
				useFilter: true,
				autoCreate: true
			}
        },    		           	
        columns:  [{ dataIndex:	'DIV_CODE'		  		, 		   	width:86, hidden: true }
        		  ,{ dataIndex:	'PLAN_YEAR'		  		, 		   	width:86, hidden: true }
        		  ,{ dataIndex:	'PLAN_TYPE1'		  	, 		   	width:86, hidden: true }
        		  ,{ dataIndex:	'PLAN_TYPE2'		  	, 		   	width:86, hidden: true }
        		  ,{ dataIndex:	'PLAN_TYPE2_CODE'		, 		   	width:86, hidden: true }
        		  ,{ dataIndex:	'LEVEL_KIND'		  	, 		   	width:86, hidden: true }
        		  ,{ dataIndex:	'MONEY_UNIT'		  	, 		   	width:86, hidden: true }
        		  ,{ dataIndex:	'ENT_MONEY_UNIT'		, 		   	width:86, hidden: true }
        		  ,{ dataIndex:	'CONFIRM_YN'		  	, 		   	width:86, hidden: true }
        		  ,{  dataIndex:	'S_CODE'		  		, 		   	width:86,
					  editor: Unilite.popup('DEPT_G', {
						  			textFieldName: 'TREE_CODE',
				 	 				DBtextFieldName: 'TREE_CODE',
									autoPopup: true,
									listeners: {'onSelected': {
										fn: function(records, type) {
												var rtnRecord = masterGrid.uniOpt.currentRecord;									
												Ext.each(records, function(record,i) {
													rtnRecord.set('S_CODE', record['TREE_CODE']);
													rtnRecord.set('S_NAME', record['TREE_NAME']);
													rtnRecord.set('PLAN_TYPE2_CODE', record['TREE_CODE']);
												}); 
											},
										scope: this	
										},
										'onClear': function(type) {
											var rtnRecord = masterGrid.uniOpt.currentRecord;
											rtnRecord.set('S_CODE', '');
											rtnRecord.set('S_NAME', '');	
											rtnRecord.set('PLAN_TYPE2_CODE', '');
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
							})	
				  }
				  ,{dataIndex: 'S_NAME'						,		width:100,
					  editor: Unilite.popup('DEPT_G', {		
									autoPopup: true,
									listeners: {'onSelected': {
										fn: function(records, type) {
												var rtnRecord = masterGrid.getSelectedRecord();										
												Ext.each(records, function(record,i) {
													rtnRecord.set('S_CODE', record['TREE_CODE']);
													rtnRecord.set('S_NAME', record['TREE_NAME']);
													rtnRecord.set('PLAN_TYPE2_CODE', record['TREE_CODE']);
												}); 
											},
										scope: this	
										},
										'onClear': function(type) {
											var rtnRecord = masterGrid.getSelectedRecord();
											rtnRecord.set('S_CODE', '');
											rtnRecord.set('S_NAME', '');	
											rtnRecord.set('PLAN_TYPE2_CODE', '');
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
							})				  
				  }
        		  ,{
        		  	text: '<t:message code="system.label.sales.totalamount" default="합계"/>',
        		  	columns:[
        		  	    { dataIndex:	'PLAN_SUM'		  		, 		   	width:86 }
	        		   ,{ dataIndex:	'MOD_PLAN_SUM'		  	, 		   	width:86 }
	        		   ,{ dataIndex:	'A_D_RATE_SUM'		  	, 		   	width:86 }
        		  	]
        		  },{
        		  	text: '<t:message code="system.label.sales.january" default="1월"/>',
        		  	columns:[
        		  	    { dataIndex:	'PLAN1'		  			, 		   	width:86 }
	        		   ,{ dataIndex:	'MOD_PLAN1'		  		, 		   	width:86 }
	        		   ,{ dataIndex:	'A_D_RATE1'		  		, 		   	width:86 }
        		  	]
        		  },{
        		  	text: '<t:message code="system.label.sales.february" default="2월"/>',
        		  	columns:[
        		  	    { dataIndex:	'PLAN2'				  	, 		   	width:86 }
	        		   ,{ dataIndex:	'MOD_PLAN2'		  		, 		   	width:86 }
	        		   ,{ dataIndex:	'A_D_RATE2'		  		, 		   	width:86 }
        		  	]
        		  },{
        		  	text: '<t:message code="system.label.sales.march" default="3월"/>',
        		  	columns:[
        		  	    { dataIndex:	'PLAN3'				  	, 		   	width:86 }
	        		   ,{ dataIndex:	'MOD_PLAN3'		  		, 		   	width:86 }
	        		   ,{ dataIndex:	'A_D_RATE3'		  		, 		   	width:86 }
        		  	]
        		  },{
        		  	text: '<t:message code="system.label.sales.april" default="4월"/>',
        		  	columns:[
        		  	    { dataIndex:	'PLAN4'				  	, 		   	width:86 }
	        		   ,{ dataIndex:	'MOD_PLAN4'		  		, 		   	width:86 }
	        		   ,{ dataIndex:	'A_D_RATE4'		  		, 		   	width:86 }
        		  	]
        		  },{
        		  	text: '<t:message code="system.label.sales.may" default="5월"/>',
        		  	columns:[
        		  	   { dataIndex:	'PLAN5'				  	, 		   	width:86 }
	        		  ,{ dataIndex:	'MOD_PLAN5'		  		, 		   	width:86 }
	        		  ,{ dataIndex:	'A_D_RATE5'		  		, 		   	width:86 }
	        		
        		  	]
        		  },{
        		  	text: '<t:message code="system.label.sales.june" default="6월"/>',
        		  	columns:[
        		  	   { dataIndex:	'PLAN6'				  	, 		   	width:86 }
	        		  ,{ dataIndex:	'MOD_PLAN6'		  		, 		   	width:86 }
	        		  ,{ dataIndex:	'A_D_RATE6'		  		, 		   	width:86 }
        		  	]
        		  },{
        		  	text: '<t:message code="system.label.sales.july" default="7월"/>',
        		  	columns:[
        		  	   { dataIndex:	'PLAN7'				  	, 		   	width:86 }
	        		  ,{ dataIndex:	'MOD_PLAN7'		  		, 		   	width:86 }
	        		  ,{ dataIndex:	'A_D_RATE7'		  		, 		   	width:86 } 
        		  	]
        		  },{
        		  	text: '<t:message code="system.label.sales.august" default="8월"/>',
        		  	columns:[
        		  	   { dataIndex:	'PLAN8'				  	, 		   	width:86 }
	        		  ,{ dataIndex:	'MOD_PLAN8'		  		, 		   	width:86 }
	        		  ,{ dataIndex:	'A_D_RATE8'		  		, 		   	width:86 }
        		  	]
        		  },{
        		  	text: '<t:message code="system.label.sales.september" default="9월"/>',
        		  	columns:[
        		  	   { dataIndex:	'PLAN9'				  	, 		   	width:86 }
	        		  ,{ dataIndex:	'MOD_PLAN9'		  		, 		   	width:86 }
	        		  ,{ dataIndex:	'A_D_RATE9'		  		, 		   	width:86 }
        		  	]
        		  },{
        		  	text: '<t:message code="system.label.sales.october" default="10월"/>',
        		  	columns:[
        		  	   { dataIndex:	'PLAN10'				, 		   	width:86 }
	        		  ,{ dataIndex:	'MOD_PLAN10'		  	, 		   	width:86 }
	        		  ,{ dataIndex:	'A_D_RATE10'		  	, 		   	width:86 }
        		  	]
        		  },{
        		  	text: '<t:message code="system.label.sales.november" default="11월"/>',
        		  	columns:[
        		  	   { dataIndex:	'PLAN11'				, 		   	width:86 }
	        		  ,{ dataIndex:	'MOD_PLAN11'		  	, 		   	width:86 }
	        		  ,{ dataIndex:	'A_D_RATE11'		  	, 		   	width:86 }
        		  	]
        		  },{
        		  	text: '<t:message code="system.label.sales.december" default="12월"/>',
        		  	columns:[
        		  	   { dataIndex:	'PLAN12'				, 		   	width:86 }
	        		  ,{ dataIndex:	'MOD_PLAN12'		  	, 		   	width:86 }
	        		  ,{ dataIndex:	'A_D_RATE12'		  	, 		   	width:86 }
        		  	]
        		  }
        		  ,{ dataIndex:	'UPDATE_DB_USER'		, 		   	width:86, hidden: true }
        		  ,{ dataIndex:	'UPDATE_DB_TIME'		, 		   	width:86, hidden: true }
        		  ,{ dataIndex:	'COMP_CODE'		  		, 		   	width:86, hidden: true }
        		  
          ] ,
          listeners: { 
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field,['PLAN_SUM', 'MOD_PLAN_SUM', 'A_D_RATE_SUM',
											'A_D_RATE1','A_D_RATE2','A_D_RATE3','A_D_RATE4',
											'A_D_RATE5','A_D_RATE6','A_D_RATE7','A_D_RATE8',
											'A_D_RATE9','A_D_RATE10','A_D_RATE11','A_D_RATE12' ])) return false; //합계행들, 증감율쪽은 수정x
				if(gsConfirmYN == "Y"){	//확정되있을때.. 수정계획만 수정가능
					if (UniUtils.indexOf(e.field,['PLAN1','PLAN2','PLAN3','PLAN4',
												  'PLAN5','PLAN6','PLAN7','PLAN8',
												  'PLAN9','PLAN10','PLAN11','PLAN12' ])) return false; 
				}else{//확정취소되있을때..
					if (UniUtils.indexOf(e.field,['MOD_PLAN1','MOD_PLAN2','MOD_PLAN3','MOD_PLAN4',
												  'MOD_PLAN5','MOD_PLAN6','MOD_PLAN7','MOD_PLAN8',
												  'MOD_PLAN9','MOD_PLAN10','MOD_PLAN11','MOD_PLAN12' ])) return false; 
				}
			}
		} 
    });    

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
		id  : 'sgp101ukrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset', true);
			UniAppManager.setToolbarButtons(['save', 'newData' ], false);
			panelSearch.clearForm();
			panelResult.clearForm();					
			Ext.getCmp('confirm_check').hide();
			Ext.getCmp('confirm_check2').hide();
			this.setDefault();
		},
		onQueryButtonDown : function()	{
			
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
								
			}
			if(!panelResult.setAllFieldsReadOnly(true)){
				return false;	
			}
			
			detailStore.loadStoreRecords();
			UniAppManager.setToolbarButtons('newData', true);
		
		},
		onResetButtonDown: function() {
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			detailStore.clearData();
			this.fnInitBinding();
		},
		onNewDataButtonDown: function(deptData)	{			
			var divCode = '';
        	if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE')))	{
        	 	divCode = panelSearch.getValue('DIV_CODE');
        	}
        	 
        	var planYear = '';
        	if(!Ext.isEmpty(panelSearch.getValue('PLAN_YEAR')))	{
        	 	planYear = panelSearch.getValue('PLAN_YEAR');
        	}
        	 
        	var orderType = '';
        	if(!Ext.isEmpty(panelSearch.getValue('ORDER_TYPE')))	{
        		orderType = panelSearch.getValue('ORDER_TYPE');
        	}
        	 
        	var moneyUnit = '';
        	if(!Ext.isEmpty(panelSearch.getValue('MONEY_UNIT')))	{
        		moneyUnit = panelSearch.getValue('MONEY_UNIT');
        	}
        	
        	var moneyUnitDiv = '';
        	if(!Ext.isEmpty(panelSearch.getValue('MONEY_UNIT_DIV')))	{
        		moneyUnitDiv = panelSearch.getValue('MONEY_UNIT_DIV');
        	}
        	
        	var scode = ''; 
        	var sname = '';
        	var planType2Code = ''
        	if(!Ext.isEmpty(deptData)){
        		scode = deptData.TREE_CODE
        		sname = deptData.TREE_NAME
        		planType2Code = deptData.TREE_CODE
        	}
        	
        	var r = {
				DIV_CODE: divCode,
				PLAN_YEAR: planYear,
				PLAN_TYPE1: orderType,
				MONEY_UNIT: moneyUnit,
				ENT_MONEY_UNIT: moneyUnitDiv,
				S_CODE: scode,
				S_NAME: sname,
				PLAN_TYPE2_CODE: planType2Code
        	};		  			
			masterGrid.createRow(r, null);
			panelSearch.setAllFieldsReadOnly(true);
			panelResult.setAllFieldsReadOnly(true);
			
		},
		 onDeleteDataButtonDown: function() {	
		 	var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				masterGrid.deleteSelectedRow();				
			}			
		},
		onSaveDataButtonDown: function (config) {	
			detailStore.saveStore(config);			
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		setDefault: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
//			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
//        	panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
//        	panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
//        	panelResult.setValue('DEPT_NAME', UserInfo.deptName);
        	
			panelSearch.setValue('PLAN_YEAR', new Date().getFullYear());
			panelSearch.setValue('MONEY_UNIT', UserInfo.currency);
			panelSearch.setValue('MONEY_UNIT_DIV', '1');
						
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('PLAN_YEAR', new Date().getFullYear());
			panelResult.setValue('MONEY_UNIT', UserInfo.currency);
			panelResult.setValue('MONEY_UNIT_DIV', '1');
			
			
//			customSubForm.setValue('AGENT_TYPE', '1');			
		}
		
	});

};


</script>