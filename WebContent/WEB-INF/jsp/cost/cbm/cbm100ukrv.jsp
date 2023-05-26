<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="cbm100ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="CD03" />	<!-- 원가담당자 -->	
	<t:ExtComboStore comboType="AU" comboCode="CC05" />	<!-- 원가적용단가 -->	
	<t:ExtComboStore comboType="AU" comboCode="C101" />	<!-- 제조경비를 제품/반제품 배부유형 -->
	<t:ExtComboStore comboType="AU" comboCode="C102" />	<!-- 간접재료비를 제품/반제품 배부유형 -->
	<t:ExtComboStore comboType="AU" comboCode="CA08" />	<!-- 생산량 집계시 집계 대상 -->
	<t:ExtComboStore comboType="AU" comboCode="CA06" />	<!-- 노무비/경비 데이터 -->
	<t:ExtComboStore comboType="AU" comboCode="CA13"/>	<!-- 노무비/경비 데이터 -->
</t:appConfig>	
<link rel="stylesheet" type="text/css" href='<c:url value="/${ext_root}/app/Ext/ux/css/GroupTabPanel.css" />' />
<script type="text/javascript" >

function appMain() {     
	var baseInfo = {
		applyUnit : "${applyUnit}",	//CC05 원가적용단가
		distKind  : "${distKind}",	//C101 제조부문의 제조경비를 제품/반제품에 배부할 유형
		distKind2 : "${distKind2}",	//C102 제조부문의 간접재료비를 제품/반제품에 배부할 유형
		distKind3 : "${distKind3}",	//CA08 생산량 집계시 집계 대상
		distKind4 : "${distKind4}"	//CA02 생산량 집계시 집계 대상
	}
	/* 조회 데이터 포맷 */
	var cbm900ukrvCombo = Ext.create('Ext.data.Store',{
		storeId: 'cbm900ukrvCombo',
        fields:[
        	'value',
        	'text'
        ],
        data:[
        	{'value':'0' , text:'0'},
        	{'value':'1' , text:'0.9'},
        	{'value':'2' , text:'0.99'},
        	{'value':'3' , text:'0.999'},
        	{'value':'4' , text:'0.9999'},
        	{'value':'5' , text:'0.99999'},        	
        	{'value':'6' , text:'0.999999'}
        ]
	});
	Unilite.defineModel('systemCodeModelCA', {
	    fields : [ 	  
	    	  {name : 'MAIN_CODE',		text : UniUtils.getLabel('system.label.commonJS.codeGrid.textMainCode','종합코드')	, allowBlank : false, readOnly:true}
			, {name : 'SUB_CODE',		text : UniUtils.getLabel('system.label.commonJS.codeGrid.textSubCode','상세코드')	, allowBlank : false, isPk:true,  pkGen:'user', readOnly:true}
			, {name : 'CODE_NAME',		text : UniUtils.getLabel('system.label.commonJS.codeGrid.textCodeName','상세코드명')	, allowBlank : false}
			, {name : 'SYSTEM_CODE_YN',	text : UniUtils.getLabel('system.label.commonJS.codeGrid.textSystemCodeYn','시스템'),	type : 'string',		comboType : 'AU', comboCode : 'B018', defaultValue:'2'}
			, {name : 'SORT_SEQ',		text : UniUtils.getLabel('system.label.commonJS.codeGrid.textSortSeq','정렬순서'),	type : 'int',			defaultValue:1	, allowBlank : false}
			, {name : 'REF_CODE1',		text : UniUtils.getLabel('system.label.commonJS.codeGrid.textRefCode1','관련1'),		type : 'string'	}
			, {name : 'USE_YN',			text : UniUtils.getLabel('system.label.commonJS.codeGrid.textUserYn','사용여부'),	type : 'string',		defaultValue:'Y'	, allowBlank : false, comboType : 'AU', comboCode : 'B010'} 
			, {name : 'S_COMP_CODE',	text : UniUtils.getLabel('system.label.commonJS.codeGrid.textCompCode','법인코드'),		type : 'string', 	defaultValue: UserInfo.compCode	} 
		]
	});
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read 	: 'bsa100ukrvService.selectDetailCodeList',
			create 	: 'bsa100ukrvService.insertCodes',
			update 	: 'bsa100ukrvService.updateCodes',
			destroy	: 'bsa100ukrvService.deleteCodes',
			syncAll	: 'bsa100ukrvService.saveAll'
		}
	});
 	var ca02Store = Ext.create('Unilite.com.data.UniStore', {
		model: 'systemCodeModelCA',
        autoLoad: false,
        uniOpt : {
        	isMaster: false,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable:true,			// 삭제 가능 여부 
            useNavi : false			// prev | next 버튼 사용
        },
        proxy: Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
    		api: {
    			read 	: 'bsa100ukrvService.selectDetailCodeList'
    		}
    	})
	});
 	var ca03Store = Ext.create('Unilite.com.data.UniStore', {
		model: 'systemCodeModelCA',
        autoLoad: false,
        uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable:true,			// 삭제 가능 여부 
            useNavi : false			// prev | next 버튼 사용
        },
        proxy: directProxy,

        saveStore : function()	{				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 )	{
				this.syncAllDirect();					
			}else {
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}

	});
	var ca02Grid = Unilite.createGrid('cbm100ukrvCa02Grid', {
	
			title:'집계유형',
			itemId:'CA02Grid',
			region : 'north',
			flex : .5,
			dockedItems: [{
		        xtype: 'toolbar',
		        dock: 'top',
		        padding:'0px',
		        border:0
		    }],
	        //padding: '0 0 0 0',
		    store : ca02Store,
		    uniOpt: {
		    	expandLastColumn: false,
		        useRowNumberer: true,
		        useMultipleSorting: false
			},		        
			//bodyCls: 'human-panel-form-background',
			columns: [{	dataIndex : 'MAIN_CODE',		width : 100, 	hidden : true}
					, {	dataIndex : 'SUB_CODE',			width : 100	}
					, {	dataIndex : 'CODE_NAME',		flex: 1	}
					, {	dataIndex : 'SYSTEM_CODE_YN',	width : 100	}
					, {	dataIndex : 'SORT_SEQ',			width : 100,		hidden : true	}
					, {	dataIndex : 'REF_CODE1',		width : 110,	hidden : true	}
					, {	dataIndex : 'REF_CODE2',		width : 110,	hidden : true	}
					, {	dataIndex : 'USE_YN',			width : 100	}  
			]
		});
	var ca03Grid = Unilite.createGrid('cbm100ukrvCa03Grid', {
		
			title:'집계유형 중 사용자정의의 사용자정의배부유형',
			itemId:'CA03Grid',
			region : 'center',
			flex : .5,
			dockedItems: [{
		        xtype: 'toolbar',
		        dock: 'top',
		        padding:'0px',
		        border:0
		    }],
	        //padding: '0 0 0 0',
			//bodyCls: 'human-panel-form-background',
		    store : ca03Store,
		    uniOpt: {
		    	expandLastColumn: false,
		        useRowNumberer: true,
		        useMultipleSorting: false
			},		        
			columns: [{	dataIndex : 'MAIN_CODE',		width : 100, 	hidden : true}
					, {	dataIndex : 'SUB_CODE',			width : 100	}
					, {	dataIndex : 'CODE_NAME',		flex: 1	}
					, {	dataIndex : 'SYSTEM_CODE_YN',	width : 100	}
					, {	dataIndex : 'SORT_SEQ',			width : 100,		hidden : true	}
					, {	dataIndex : 'REF_CODE1',		width : 110,	hidden : true	}
					, {	dataIndex : 'REF_CODE2',		width : 110,	hidden : true	}
					, {	dataIndex : 'USE_YN',			width : 100	}  
			]
			
		});
	/* 기준코드등록 */
	var panelDetail = Ext.create('Ext.panel.Panel', {
    	layout: 'fit',
        region: 'center',
        disabled: false,
	    items: [{ 
	    	xtype: 'grouptabpanel',
	    	itemId: 'cbm100Tab',
	    	activeGroup: 0,
	    	collapsible:true,
	    	items: [{
		    	defaults:{
 					xtype: 'uniDetailForm',
				    disabled: false,
					border: 0,
				    layout: {type: 'uniTable', columns: '1', tdAttrs: {valign:'top'}},		
						margin: '10 10 10 10'
				},
				items:[{
					title: '원가업무설정',
					itemId: 'tab_cbm002ukrv',
					id: 'tab_cbm002ukrv',
					xtype: 'uniDetailForm',
					layout: {type: 'vbox', align: 'stretch'},
					api: {
						load: 'cbm100ukrvService.selectMaster',
						submit: 'cbm100ukrvService.syncMaster'	
					},
					items:[{
						xtype: 'fieldset',
						title: '기본설정',
						layout: {type: 'uniTable', columns: 2},
						items:[{
							border: false,
							html: "<font color = 'blue' >[직/간접재료비 적상시 사용할 적용 단가]</font>",
							width: 350
						}, {
					 		name: 'APPLY_UNIT', 
					 		fieldLabel: '',
					 		xtype: 'uniCombobox',
						  	value: Ext.isEmpty(baseInfo.applyUnit) ? '02':baseInfo.applyUnit,
					 		comboType: 'AU',
					 		comboCode: 'CC05',
					 		allowBlank: false,
					 		listeners:{
								change:function( field, newValue, oldValue ) {
									var formpanel = panelDetail.down('#tab_cbm002ukrv');
									if(!formpanel.uniOpt.inLoading)	{
										UniAppManager.setToolbarButtons('save', true);
									}
								}
					 		}
				        }, {
							border: false,
							html: "<font color = 'blue' >[제조부문의 제조경비를 제품/반제품에 배부할 유형]</font>",
							width: 350
						}, {
					 		name: 'DIST_KIND', 
					 		fieldLabel: '',
					 		xtype: 'uniCombobox',
						  	value: Ext.isEmpty(baseInfo.distKind) ? '01':baseInfo.distKind, 
					 		comboType: 'AU',
					 		comboCode: 'C101',
					 		allowBlank: false,
					 		listeners:{
								change:function( field, newValue, oldValue ) {
									var formpanel = panelDetail.down('#tab_cbm002ukrv');
									if(!formpanel.uniOpt.inLoading)	{
										UniAppManager.setToolbarButtons('save', true);
									}
								}
					 		}
				        }, {
							border: false,
							html: "<font color = 'blue' >[제조부문의 간접재료비를 제품/반제품에 배부할 유형]</font>",
							width: 350
						}, {
					 		name: 'DIST_KIND2', 
					 		fieldLabel: '',
					 		xtype: 'uniCombobox',
						  	value: Ext.isEmpty(baseInfo.distKind2) ? '01':baseInfo.distKind2, 
					 		comboType: 'AU',
					 		comboCode: 'C102',
					 		allowBlank: false,
					 		listeners:{
								change:function( field, newValue, oldValue ) {
									var formpanel = panelDetail.down('#tab_cbm002ukrv');
									if(!formpanel.uniOpt.inLoading)	{
										UniAppManager.setToolbarButtons('save', true);
									}
								}
					 		}
				        }, {
							border: false,
							html: "<font color = 'blue' >[생산량 집계시 집계 대상]</font>",
							width: 350
						}, {
					 		name: 'DIST_KIND3', 
					 		fieldLabel: '',
					 		xtype: 'uniCombobox',
						  	value: Ext.isEmpty(baseInfo.distKind3) ? '01':baseInfo.distKind3, 
					 		comboType: 'AU',
					 		comboCode: 'CA08',
					 		allowBlank: false,
					 		listeners:{
								change:function( field, newValue, oldValue ) {
									var formpanel = panelDetail.down('#tab_cbm002ukrv');
									if(!formpanel.uniOpt.inLoading)	{
										UniAppManager.setToolbarButtons('save', true);
									}
								}
					 		}
				        }, {
							border: false,
							html: "<font color = 'blue' >[보조부문에서 제조부문에 배부할 유형]</font><br/><br/><br/>",
							width: 350
						}, {
					 		name: 'DIST_KIND4', 
					 		fieldLabel: '',
					 		xtype: 'uniRadiogroup',
						  	value: Ext.isEmpty(baseInfo.distKind4) ? '01':baseInfo.distKind4, 
					 		comboType: 'AU',
					 		comboCode: 'CA13',
					 		allowBlank: false,
					 		layout: {
					 		    type: 'vbox',
					 		    align: 'left'
					 		},
					 		listeners:{
								change:function( field, newValue, oldValue ) {
									var formpanel = panelDetail.down('#tab_cbm002ukrv');
									if(!formpanel.uniOpt.inLoading)	{
										UniAppManager.setToolbarButtons('save', true);
									}
								}
					 		}
				        }]			
					},{
						xtype: 'fieldset',
						title: '간접재료비 비목 정보',//공통코드 C007
						layout: {type: 'uniTable', columns: 2},
						items:[{
							xtype: 'uniTextfield',
							name:'MAIN_CODE',
							value:'C007',
							hidden:true
						}, {
							border: false,
							html: "<font color = 'blue' >[재료비 코드]</font>",
							width: 350
						}, {
					 		name: 'M_COST_CODE', 
					 		fieldLabel: '',
					 		xtype: 'uniTextfield',
					 		allowBlank: false,
					 		listeners:{
								change:function( field, newValue, oldValue ) {
									var formpanel = panelDetail.down('#tab_cbm002ukrv');
									if(!formpanel.uniOpt.inLoading)	{
										UniAppManager.setToolbarButtons('save', true);
									}
								}
					 		}
				        }, {
							border: false,
							html: "<font color = 'blue' >[재료비 코드명]</font>",
							width: 350
						}, {
					 		name: 'M_COST_NAME', 
					 		fieldLabel: '',
					 		xtype: 'uniTextfield',
					 		allowBlank: false,
					 		listeners:{
								change:function( field, newValue, oldValue ) {
									var formpanel = panelDetail.down('#tab_cbm002ukrv');
									if(!formpanel.uniOpt.inLoading)	{
										UniAppManager.setToolbarButtons('save', true);
									}
								}
					 		}
				        }]			
					
					
					},{
						xtype: 'fieldset',
						title: '노무비/경비 데이터',
						layout: {type: 'uniTable', columns: 2},
						items:[{
							border: false,
							html: "<font color = 'blue' >[노무비/경비 집계 대상 데이터]</font>",
							width: 350
						}, {
					 		name: 'SUMMARY_DATA', 
					 		fieldLabel: '',
					 		xtype: 'uniCombobox',
					 		comboType: 'AU',
					 		comboCode: 'CA06',
					 		allowBlank: false,
					 		listeners:{
								change:function( field, newValue, oldValue ) {
									var formpanel = panelDetail.down('#tab_cbm002ukrv');
									if(!formpanel.uniOpt.inLoading)	{
										UniAppManager.setToolbarButtons('save', true);
										

										if(newValue == '01'){
											//SUMMARY_REF02_DATA.
											//panelDetail.Set
											formpanel.setValue('SUMMARY_REF02_DATA', 'N');
											formpanel.getField("SUMMARY_REF02_DATA").setDisabled(true);
										} else {
											formpanel.getField("SUMMARY_REF02_DATA").setDisabled(false);
										}
									}
								}
					 		}
				        },{
							border: false,
							html: "<font color = 'blue' >[간접재료비 수동입력여부]</font>",
							width: 350
						}, {
					 		name: 'SUMMARY_REF02_DATA', 
					 		fieldLabel: '',
					 		xtype: 'checkbox',
					 		inputValue: 'Y',
					 		uncheckedValue: 'N',
					 		//allowBlank: false,
					 		listeners:{
								change:function( field, newValue, oldValue ) {
									var formpanel = panelDetail.down('#tab_cbm002ukrv');
									if(!formpanel.uniOpt.inLoading)	{
										UniAppManager.setToolbarButtons('save', true);
									}
								}
					 		}
				        }]			
					}],
					listeners: {
			           	afterrender: function(form) {
			           		var me = form;
			           		me.uniOpt.inLoading = true;
			           		form.getForm().load({
			           			success:function(form, action){
			           				me.uniOpt.inLoading = false;
			           				UniAppManager.setToolbarButtons('save',false);
           							
			           				var formpanel = panelDetail.down('#tab_cbm002ukrv');
									if(!formpanel.uniOpt.inLoading)	{
										var refValue = formpanel.getValue('SUMMARY_DATA');
										if(refValue == '01'){
											formpanel.getField("SUMMARY_REF02_DATA").setDisabled(true);
										} else {
											formpanel.getField("SUMMARY_REF02_DATA").setDisabled(false);
										}
									}
			           			},
			           			failure:function(){
			           				me.uniOpt.inLoading = false;
			           			}
			           		});
			           	}/*,
						dirtychange:function( basicForm, dirty, eOpts ) {
							var formpanel = panelDetail.down('#tab_cbm002ukrv');
							if(!formpanel.uniOpt.inLoading)	{
								UniAppManager.setToolbarButtons('save', true);
							}
						}*/
					}
				}
				]
	    	 },{
	    		 items:[{
	    			 xtype:'panel',
	    			 title:'비목을 부문별로<br/>&nbsp;&nbsp;&nbsp;집계시 기준정보',
					 itemId: 'tab_ca03',
					 layout: 'border',
	    			 items:[ca02Grid,ca03Grid]
		    			 
	    		 	}]
	    	 },{
				xtype:'ConfigCodeGrid', 
				subCode:'CA04', 
				codeName:'보조부문을 제조<br/>&nbsp;&nbsp;&nbsp;부문별로 배부시<br/>&nbsp;&nbsp;&nbsp;배부항목'
			}, {
				xtype:'ConfigCodeGrid', 
				subCode:'CD03', 
				codeName:'원가담당자'
			}, {
	    	 	defaults:{
					xtype:'uniDetailForm',
				    disabled:false,
				    border:0,
				    layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},		
					margin: '10 10 10 10'
				},
				items:[
				    {
						title:'조회데이타포맷설정',
						xtype: 'uniDetailForm',
						itemId: 'tab_format',
						api: {
				                load : 'cbm100ukrvService.selectFormat',
				                submit: 'cbm100ukrvService.syncFormat'	
				            },
						layout: {tyep: 'hbox', align: 'stretch'},
						items:[{
							border: false,
							xtype: 'panel',
							layout: {tyep: 'hbox', align: 'stretch'},
							items:[{
								title: '조회용 데이타포맷',
								name: '',
								xtype: 'fieldset',
								layout: {tyep: 'hbox', align: 'stretch'},
								items:[{					
									fieldLabel: '[수량]',
									name: 'FORMAT_QTY',
									xtype: 'uniCombobox',
									store: Ext.data.StoreManager.lookup('cbm900ukrvCombo'),
									allowBlank: false,
							 		listeners:{
										change:function( field, newValue, oldValue ) {
											var formpanel = panelDetail.down('#tab_format');
											if(!formpanel.uniOpt.inLoading)	{
												UniAppManager.setToolbarButtons('save', true);
											}
										}
							 		}
								}, {					
									fieldLabel: '[단가]',
									name: 'FORMAT_PRICE',
									xtype: 'uniCombobox',
									store: Ext.data.StoreManager.lookup('cbm900ukrvCombo'),
									allowBlank: false	,
							 		listeners:{
										change:function( field, newValue, oldValue ) {
											var formpanel = panelDetail.down('#tab_format');
											if(!formpanel.uniOpt.inLoading)	{
												UniAppManager.setToolbarButtons('save', true);
											}
										}
							 		}	
								}, {					
									fieldLabel: '[자국화폐금액]',
									name: 'FORMAT_IN',
									xtype: 'uniCombobox',
									store: Ext.data.StoreManager.lookup('cbm900ukrvCombo'),
									allowBlank: false	,
							 		listeners:{
										change:function( field, newValue, oldValue ) {
											var formpanel = panelDetail.down('#tab_format');
											if(!formpanel.uniOpt.inLoading)	{
												UniAppManager.setToolbarButtons('save', true);
											}
										}
							 		}
								}, {					
									fieldLabel: '[외화화폐금액]',
									name: 'FORMAT_OUT',
									xtype: 'uniCombobox',
									store: Ext.data.StoreManager.lookup('cbm900ukrvCombo'),
									allowBlank: false	,
							 		listeners:{
										change:function( field, newValue, oldValue ) {
											var formpanel = panelDetail.down('#tab_format');
											if(!formpanel.uniOpt.inLoading)	{
												UniAppManager.setToolbarButtons('save', true);
											}
										}
							 		}
								}, {					
									fieldLabel: '[환율]',
									name: 'FORMAT_RATE',
									xtype: 'uniCombobox',
									store: Ext.data.StoreManager.lookup('cbm900ukrvCombo'),
									allowBlank: false		,
							 		listeners:{
										change:function( field, newValue, oldValue ) {
											var formpanel = panelDetail.down('#tab_format');
											if(!formpanel.uniOpt.inLoading)	{
												UniAppManager.setToolbarButtons('save', true);
											}
										}
							 		}
								}]
							}]			
						}],
							listeners: {
					           	afterrender: function(form) {
					           		var me = form;
					           		me.uniOpt.inLoading = true;
					           		form.getForm().load({
					           			success:function(form, action){
					           				me.uniOpt.inLoading = false;
					           				UniAppManager.setToolbarButtons('save',false);
					           			},
					           			failure:function(){
					           				me.uniOpt.inLoading = false;
					           			}
					           		});
					           	}/*,
								dirtychange:function( basicForm, dirty, eOpts ) {
									var formpanel = panelDetail.down('#tab_format');
									if(!formpanel.uniOpt.inLoading)	{
										UniAppManager.setToolbarButtons('save', true);
										UniAppManager.setToolbarButtons('newData', false);
									}
								}*/
							}
					}
			    ]
			}],
			listeners: {
				beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts )	{
					if(Ext.isObject(oldCard))	{
						if(UniAppManager.app._needSave())	{
							if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
								UniAppManager.app.onSaveDataButtonDown();
								this.setActiveTab(oldCard);
							}else {
								UniAppManager.setToolbarButtons('save',false);
								UniAppManager.app.loadTabData(newCard, newCard.getItemId());							
							}
		    			 }else {
							UniAppManager.app.loadTabData(newCard, newCard.getItemId());							
		    			 }
		    		}
					else {		 	
						UniAppManager.setToolbarButtons(['reset'],false);
						UniAppManager.setToolbarButtons(['query','newData','delete','excel'],true);
					}
		    	}
		    }
	    }]
    })

	/* 기준코드등록	*/
	Unilite.Main( {
		id: 'cbm100ukrvApp',
		borderItems: [ 
			panelDetail		 	
		], 
		fnInitBinding : function() {				
			UniAppManager.setToolbarButtons(['reset','newData','delete','excel'],false);
			UniAppManager.setToolbarButtons(['query'],true);
		},
		onQueryButtonDown : function()	{		
			var activeTab = panelDetail.down('#cbm100Tab').getActiveTab();
			
			if(activeTab.getItemId() == "tab_cbm002ukrv"){
				var form = panelDetail.down('#tab_cbm002ukrv').getForm();
				var formpanel = panelDetail.down('#tab_cbm002ukrv');
				formpanel.uniOpt.inLoading = true;
				form.load({
           			success:function(form, action){
           				var formpanel = panelDetail.down('#tab_cbm002ukrv');
           				formpanel.uniOpt.inLoading = false;
           				UniAppManager.setToolbarButtons('save',false);
           			},
           			failure:function(){
           				var formpanel = panelDetail.down('#tab_cbm002ukrv');
           				formpanel.uniOpt.inLoading = false;
           			}
           		});
				
			}
			else if(activeTab.getItemId() == "tab_format"){
				var form = panelDetail.down('#tab_format').getForm();
				var formpanel = panelDetail.down('#tab_format');
				formpanel.uniOpt.inLoading = true;
				form.load({
           			success:function(form, action){
           				var formpanel = panelDetail.down('#tab_format');
           				formpanel.uniOpt.inLoading = false;
           				UniAppManager.setToolbarButtons('save',false);
           			},
           			failure:function(){
           				var formpanel = panelDetail.down('#tab_format');
           				formpanel.uniOpt.inLoading = false;
           			}
           		});
			} else if (activeTab.getItemId() == 'tab_ca03'){
				ca02Store.load({params:{'MAIN_CODE':"CA02"}});
				ca03Store.load({params:{'MAIN_CODE':"CA03"}});
				
			} else {
				activeTab.getStore().load({params:{'MAIN_CODE':activeTab.subCode}});
			}
			
		},
		onDeleteDataButtonDown : function()	{
			var activeTab = panelDetail.down('#cbm100Tab').getActiveTab();
			if (activeTab.getItemId() == 'tab_ca03'){
				activeTab.down('#CA03Grid').deleteSelectedRow({'MAIN_CODE':"CA03"});
			} else if(!Ext.isEmpty(activeTab.getSubCode()))	{
				activeTab.deleteSelectedRow();
			}
		},
		onNewDataButtonDown : function()	{
			var activeTab = panelDetail.down('#cbm100Tab').getActiveTab();
			if (activeTab.getItemId() == 'tab_ca03'){
				activeTab.down('#CA03Grid').createRow({'MAIN_CODE':"CA03"});
			} else if(!Ext.isEmpty(activeTab.getSubCode()))	{
				activeTab.createRow({'MAIN_CODE':activeTab.getSubCode()});
			}
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		
		onSaveDataButtonDown: function () {
			var activeTab = panelDetail.down('#cbm100Tab').getActiveTab();
			
			if(activeTab.getItemId() == "tab_cbm002ukrv"){
				var form = panelDetail.down('#tab_cbm002ukrv').getForm();
				form.submit({
					success:function(){
						UniAppManager.setToolbarButtons(['save'],false);
					}
				});
				
			}
			else if(activeTab.getItemId() == "tab_format"){
				var form = panelDetail.down('#tab_format').getForm();
				form.submit({
					success:function(){
						UniAppManager.setToolbarButtons(['save'],false);
					}
				});
			} else if (activeTab.getItemId() == 'tab_ca03'){
				if(ca03Store.isDirty()) {
					ca03Store.saveStore();
				}
			} else {
				activeTab.getStore().saveStore();
			}
		},
		loadTabData: function(tab, itemId){
			if (tab.getItemId() == 'tab_cbm002ukrv'){
				UniAppManager.setToolbarButtons(['reset','newData','delete','excel'],false);
				UniAppManager.setToolbarButtons(['query'],true);
			} else if (tab.getItemId() == 'tab_format'){
				UniAppManager.setToolbarButtons(['reset','newData','delete','excel'],false);
				UniAppManager.setToolbarButtons(['query'],true);
			} else if (tab.getItemId() == 'tab_ca03'){
				ca02Store.load({params:{'MAIN_CODE':"CA02"}});
				ca03Store.load({params:{'MAIN_CODE':"CA03"}});
				UniAppManager.setToolbarButtons(['delete','reset','excel'],false);
				UniAppManager.setToolbarButtons(['newData','query'],true);
			} else {
				tab.getStore().load({params:{'MAIN_CODE':tab.subCode}});
				UniAppManager.setToolbarButtons(['delete','excel'],false);
				UniAppManager.setToolbarButtons(['reset','newData','query'],true);
			}
		}
	});
};
</script>
