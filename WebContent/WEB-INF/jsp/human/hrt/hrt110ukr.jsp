<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="hrt110ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B083" /> <!-- BOM PATH 정보 --> 
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 --> 
	<t:ExtComboStore comboType="AU" comboCode="B097" /> <!-- BOM구성여부 --> 
	<t:ExtComboStore comboType="AU" comboCode="M105" /> <!-- 사급구분 -->     
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
.x-grid-item-focused  .x-grid-cell-inner:before {
    border: 0px; 
}
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	
	// 선택 되어있는 그리드 저장
	var selectedGrid = '';
	
	var comboStore01 = Ext.create('Ext.data.Store', { 
        autoLoad: true,
        fields: [
                {name: 'WAGES_CODE'	,type : 'string'},
				{name: 'WAGES_NAME'	,type : 'string'}
                ],
        proxy: {
			type: 'direct',
		    api: { 
				read : 'hrt110ukrService.selectComboList01'
			}
        }
	});
	
	var comboStore02 = Ext.create('Ext.data.Store', { 
        autoLoad: true,
        storeId: 'comboStore02' ,
        fields: [
                {name: 'value'	,type : 'string'},
				{name: 'text'	,type : 'string'},
				{name: 'search'	,type : 'string'}
                ],
        proxy: {
			type: 'direct',
		    api: { 
				read : 'hrt110ukrService.selectComboList02'
			}
        }
	});
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Hrt110ukrModel1', {		
	    fields: [{name: 'OT_KIND'  		,text: '분류값' 			,type: 'string'},	 
				 {name: 'DUTY_YYYY'		,text: '근속개월(이상)' 	,type: 'string'},	 
				 {name: 'ADD_MONTH'		,text: '누진개월(율)' 		,type: 'string'}				 	 	 
		]
	});	
	
	
	
	Unilite.defineModel('Hrt110ukrModel2', {		
	    fields: [{name: 'POST_CODE'		,text: '임원직급' 		,type: 'string', store:Ext.StoreManager.lookup('comboStore02')},	 
				 {name: 'ADD_MONTH'		,text: '누진개월' 		,type: 'string'}	
		]
	});
	
	Unilite.defineModel('Hrt110ukrModel3', {		
	    fields: [{name: 'SUB_CODE'		,text: '계산식코드' 		,type: 'string'},	 
				 {name: 'CODE_NAME'		,text: '계산식항목' 		,type: 'string'}	
		]
	});	
	
	Unilite.defineModel('Hrt110ukrModel4', {		
	    fields: [{name: 'SUPP_TYPE'		,text: '구분' 		,type: 'string', comboType : 'AU', comboCode: 'H111'},	 
				 {name: 'OT_KIND_01'	,text: '분류' 		,type: 'string', comboType : 'AU', comboCode: 'H112'},
				 {name: 'SELECT_VALUE'	,text: '공식' 		,type: 'string'}
		]
	});	
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('hrt110ukrMasterStore1',{
			model: 'Hrt110ukrModel1',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	   create: 'hrt110ukrService.insertList01',
                	   read: 'hrt110ukrService.selectList01',
                	   update: 'hrt110ukrService.updateList01',
                	   destroy: 'hrt110ukrService.deleteList01',
                	   syncAll: 'hrt110ukrService.syncAll'
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('view1').getValues();			
				console.log( param );
				this.load({
					params : param
				});
			}
	});
	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	create: 'hrt110ukrService.insertList02',
 	   		read: 'hrt110ukrService.selectList02',
 	   		update: 'hrt110ukrService.updateList02',
 	   		destroy: 'hrt110ukrService.deleteList02',
 	   		syncAll: 'hrt110ukrService.saveAll02'  
        }
	});
	var directMasterStore2 = Unilite.createStore('hrt110ukrMasterStore2',{
			model: 'Hrt110ukrModel2',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy2
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('baseInfo').getValues();			
				console.log( param );
				this.load({
					params : param
				});
			}
	});
	

	
	var directMasterStore3 = Unilite.createStore('hrt110ukrMasterStore3',{
		model: 'Hrt110ukrModel3',
		uniOpt : {
        	isMaster: false,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable: false,			// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
         	   		read: 'hrt110ukrService.selectList03'
            }
        }
		,loadStoreRecords : function()	{
			var param= Ext.getCmp('tab02searchPanel').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var directProxy4 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read: 'hrt110ukrService.selectList04',
 	   		destroy: 'hrt110ukrService.deleteList04',
 	   		syncAll: 'hrt110ukrService.saveAll04'
        }
	});
	var directMasterStore4 = Unilite.createStore('hrt110ukrMasterStore4',{
		model: 'Hrt110ukrModel4',
		uniOpt : {
        	isMaster: false,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable: false,			// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy4
		,loadStoreRecords : function()	{
			var param= Ext.getCmp('tab02searchPanel').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store) {
				if (store.getCount() > 0) {
					UniAppManager.setToolbarButtons('delete', true);
				}
			}
		}
	});

    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
   var panelSearch = Unilite.createForm('baseInfo',{
   		padding: '0 1 1 1',
   		disabled:false,
   		width:400,
		layout : {type : 'uniTable', columns : 1},
		defaults: {labelWidth: 120},
		items : [{
			fieldLabel: '3개월평균범위',
			name:'AMT_RANGE', 	
			xtype: 'uniCombobox', 
			store: Ext.create('Ext.data.Store', {
                id : 'comboStore1',
				fields : ['name', 'value'],
                data   : [
                    {name : '일자기준', value: 'D'},
                    {name : '전월기준', value: 'B'},
                    {name : '마감기준(월)', value: 'M'},
                    {name : '마감기준(일)', value: 'N'}
                ]
            }),
			queryMode: 'local',
			displayField: 'name',
			valueField: 'value',
			allowBlank: false
		}, {
			fieldLabel: '평균임금계산방식',
			name:'AMT_CALCU', 	
			xtype: 'uniCombobox', 
			store: Ext.create('Ext.data.Store', {
                id : 'comboStore2',
				fields : ['name', 'value'],
                data   : [
                    {name : '일평균임금', value: 'D'},
                    {name : '월평균임금', value: 'M'}
                ]
            }),
			queryMode: 'local',
			displayField: 'name',
			valueField: 'value',
			allowBlank: false
		}, {
			fieldLabel: '근속기간계산방식',
			name:'PERIOD_CALCU', 	
			xtype: 'uniCombobox', 
			store: Ext.create('Ext.data.Store', {
                id : 'comboStore3',
				fields : ['name', 'value'],
                data   : [
                    {name : '근속일수', value: 'D'},
                    {name : '근속월수', value: 'M'},
                    {name : '년월일', value: 'T'}
                ]
            }),
			queryMode: 'local',
			displayField: 'name',
			valueField: 'value',
			allowBlank: false
		}, {
			fieldLabel: '근속기간산정방식',
			name: 'RETR_DUTY_RULE',
			width: 275,
			maxLength:2,
			suffixTpl: '일 이상이면 1개월 간주',
			allowBlank: false
		}, {
			xtype: 'uniNumberfield',
			decimalPrecision:3,
			fieldLabel: '단체퇴직금보험율',
			name: 'TOT_RATE',
			width: 194,
			suffixTpl: '&nbsp;%',
			allowBlank: false
		}, {
			fieldLabel: '누진적용여부',
			name:'ADD_YN', 	
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'H160',
			 allowBlank: false
		}, {
			fieldLabel: '임원누진적용여부',
			name:'PS_ADD_YN', 	
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'H160',
			 allowBlank: false
		}, {
			fieldLabel: '연차수당 코드선택',
			name:'YEAR_CODE', 	
			xtype: 'combobox', 
			store: comboStore01,
            displayField : 'WAGES_NAME',
            valueField : 'WAGES_CODE',
            hiddenName: 'WAGES_CODE',
            hiddenValue: 'WAGES_CODE'
		}, {
// 			fieldLabel: '상여금 코드선택',
// 			name:'BONUS_CODE', 	
// 			xtype: 'uniCombobox', 
// 			comboType:'AU',
// 			comboCode:''			
			xtype:  'displayfield',
            value:'상여금 코드선택&nbsp;:&nbsp;지급/공제코드등록에서 설정'
			
		}, {
			fieldLabel: '퇴직금 코드선택',
			name:'RETR_CODE', 	
			xtype: 'combobox', 
			store: comboStore01,
            displayField : 'WAGES_NAME',
            valueField : 'WAGES_CODE',
            hiddenName: 'WAGES_CODE',
            hiddenValue: 'WAGES_CODE'
		}, {
			fieldLabel: '마지막년차 포함여부',
			name:'LAST_YEAR_YN', 	
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'H160'
		}, {
			fieldLabel: '2011년 퇴직금 계산방식',
			labelWidth: 140,
			width:275,
			name:'PS_2011_CALCU', 	
			xtype: 'uniCombobox', 
			store:Ext.create('Ext.data.Store', {
			    fields: ['value', 'text', 'search'],
			    data : [
			        {"value":"1", "text":"계산식", search:'1계산식'},
			        {"value":"2", "text":"법정기준", search:'2법정기준'}
			    ]
			})
		}],
		trackResetOnLoad: true,
		api: {
    		 load: 'hrt110ukrService.loadFormData',
			 submit: 'hrt110ukrService.submitFormData'				
			}
		, listeners : {
			actioncomplete: function() {
				// dirty change 이벤트
				panelSearch.getForm().on({
					dirtychange: function(form, dirty, eOpts) {
						if (!dirty) {
							UniAppManager.app.setToolbarButtons('save', false);
						}
					}
				});
			},
			uniOnChange:function(form, field, newValue, oldValue) {
				if(!form.uniOpt.inLoading && form.isDirty() && newValue != oldValue)	{
					UniAppManager.app.setToolbarButtons('save', true);
				}
			}
		}
	}); 
    
    
    var masterGrid1 = Unilite.createGrid('hrt110ukrGrid1', {
    	title: '누진적용 기준설정',
    	//height: '70%',
    	uniOpt: {
			expandLastColumn: false,
        	useRowNumberer: false,
            useMultipleSorting: false,
		    state: {
			    useState: false,
			    useStateList: false
		    }
        },
        layout : 'fit',
    	store: directMasterStore1,
        columns:  [{ dataIndex: 'OT_KIND'  		,		    	width: 80, hidden: true  },
       			   { dataIndex: 'DUTY_YYYY'		,		    	width: 150, align: 'center' },
       			   { dataIndex: 'ADD_MONTH'		,		    	flex: 1, align: 'right' }
       			   
        ],
        listeners: {
          	containerclick: function() {
          		selectedGrid = 'masterGrid1';
          	}, select: function() {
          		selectedGrid = 'masterGrid1';
          	}, cellclick: function() {
          		selectedGrid = 'masterGrid1';
          	}, beforeedit: function(editor, e) {
          		
          	}
        }
    });
    
    var masterGrid2 = Unilite.createGrid('hrt110ukrGrid2', {
    	title: '임원누진적용 기준설정',
    	//height: '70%', 
    	uniOpt: {
			expandLastColumn: false,
        	useRowNumberer: false,
            useMultipleSorting: false,
		    state: {
			    useState: false,
			    useStateList: false
		    }
        },
        layout : 'fit',
    	store: directMasterStore2,
        columns:  [{ dataIndex: 'POST_CODE'		,		    	width: 150, align: 'center'},
       			   { dataIndex: 'ADD_MONTH'		,		    	flex: 1, align: 'right' }
        ],
        listeners: {
          	containerclick: function() {
          		selectedGrid = 'masterGrid2';
          	}, select: function() {
          		selectedGrid = 'masterGrid2';
          	}, cellclick: function() {
          		selectedGrid = 'masterGrid2';
          	}
        }
        
    });
    
	var itemView1 = Unilite.createSearchForm('view1',{
		layout: {type: 'uniTable', columns:1},
		defaultType: 'uniTextfield',
		items: [{
			fieldLabel: '계산식분류',
			name:'OT_KIND', 	
			xtype: 'uniCombobox', 
			store: Ext.create('Ext.data.Store', {
                id : 'comboStore1',
				fields : ['name', 'value'],
                data   : [
                    {name : '직원', value: 'ST'}
                ]
            }),
			queryMode: 'local',
			displayField: 'name',
			valueField: 'value',
			allowBlank: false,
			value: 'ST'
		}]
	});
	    
	var itemView2 = Unilite.createSearchForm('view2',{
		layout: {type: 'uniTable', columns:1},
		defaultType: 'uniTextfield',
		items: [{
// 			fieldLabel: '계산식분류1',
// 			name:'', 	
// 			xtype: 'combobox', 
// 			store: comboStore02,
// 			displayField : 'CODE_NAME',
//             valueField : 'SUB_CODE',
//             hiddenName: 'SUB_CODE',
//             hiddenValue: 'SUB_CODE',
// 			allowBlank: false
			fieldLabel: '계산식분류1',
			name:'', 	
			xtype: 'combobox', 
			store: Ext.create('Ext.data.Store', {
                id : 'comboStore1',
				fields : ['name', 'value'],
                data   : [
                    {name : '임원', value: '1'}
                ]
            }),
			queryMode: 'local',
			displayField: 'name',
			valueField: 'value',
			allowBlank: false,
			value: '1',
			readOnly: true
		}]				
	});
    
	var tab = Unilite.createTabPanel('tabPanel1',{
		region: 'center',
		items:[{
			xtype: 'container',
			id: 'hrf110ukrTab01',
			title: '기준설정',	
			style:{'background-color':'#fff'},
			layout:'border',
			items: [{	
			    	width: 400,
			    	region:'center',
			    	xtype:'container',
					layout:{type:'vbox', align:'stretch'},
					items:[
						{xtype: 'container',
						 margin: '0 0 0 5',
						 html: '<div style="margin-left:100px;line-height:30px;"><b>[퇴직정산 기준설정]</b></div>'},
					 panelSearch]
			    }, {	
			    	region:'east',
			    	width: 300,
			    	xtype:'container',
					layout:{type:'vbox', align:'stretch'},
					items:[itemView1, masterGrid1]
			    }, {
			    	width: 300,
			    	region:'east',
			    	xtype:'container',
			    	margin: '0 0 0 5',
					layout:{type:'vbox', align:'stretch'},
					items:[itemView2, masterGrid2]
			    },{
			    	flex: 1,
			    	region:'east',
			    	xtype:'container',
					layout:{type:'vbox', align:'stretch'},
					items:[{
						xtype:'component',
						html:'<div></div>'
					}]
			    }]
		},
		{
			xtype: 'container',
			id: 'hrf110ukrTab02',
			title: '계산식',
			//layout:{type:'vbox', align:'stretch'},
			layout:'border',
			border:0,
			style:{'background-color':'#fff'},
			items: [{	
		    	xtype:'container',
				region:'west',
				flex:.5,
				wieght:100,
				//layout:{type:'uniTable', columns:1},
				layout:'border',
				items:[
					{xtype: 'uniDetailFormSimple',
					 id: 'tab02searchPanel',
					 region:'north',
					 scrollable:false,
					 layout:{type:'uniTable', columns:2},
					 items: [
							{
								fieldLabel: '구분',
								name: 'SUPP_TYPE',
								id: 'SUPP_TYPE', 
								xtype: 'uniCombobox',
								comboType: 'AU',
								comboCode: 'H111',
								allowBlank: false,
								value: 'R'
							},
							{
								fieldLabel: '분류값',
								name: 'OT_KIND_01',
								id: 'OT_KIND_01', 
								xtype: 'uniCombobox',
								comboType: 'AU',
								comboCode: 'H112',
								allowBlank: false,
								value: 'OF'
							}]
					},{
						 xtype: 'uniGridPanel',
						 store: directMasterStore4,
						 flex:1,
						 region:'center',
						 layout:'fit',
						 id: 'masterGrid4',
						 selModel:'rowmodel',
						 uniOpt: {
		                       expandLastColumn: false,
		                       useRowNumberer: false,
		                       useMultipleSorting: false,
		                       userToolbar :false,
		                       state: {
									useState: false,
									useStateList: false
								}
		                  },        
						 columns: [
				                  	{dataIndex: 'SUPP_TYPE', width: 100},
				                  	{dataIndex: 'OT_KIND_01', width: 100},
				                  	{dataIndex: 'SELECT_VALUE', flex: 1}
				                  ]
						}
				 ]
		    },{
		    	xtype:'panel',
		    	region:'north',
		    	//margin: '15 0 0 70',
				weight:-200,
				height:60,
				width:'40%',
				margin:'0 0 2 0',
				border:0,
				layout:{type:'uniTable', columns:1},
				items:[{
					xtype: 'uniTextfield',
					name: 'CALC_TXT',
					id: 'CALC_TXT',
					width:'100%',
					readOnly: true
				}],
				height: 25
				
			},{
			 xtype: 'uniGridPanel',
			 region:'center',
			 flex:.2,
			 store: directMasterStore3,
			 //margin: '0 0 0 55',
			 uniOpt: {
                   expandLastColumn: false,
                   useRowNumberer: false,
                   useMultipleSorting: false,
                   state: {
						useState: false,
						useStateList: false
					}
              },        
			 columns: [
	                  	 {dataIndex: 'SUB_CODE', hidden: true},
	                  	 {dataIndex: 'CODE_NAME', flex: 1}
	                  ],
              listeners: {
		            cellclick: function(table, td, cellIndex, record) {
		            	treatCalcArea(record.data.CODE_NAME);
		            }
	          }
		},{
						xtype: 'container',
						region:'east',
						weight:-300,
						flex:.3,
						layout: {type: 'table', columns: 6},
						defaults: { xtype: 'button',  margin:'5 5 5 5' },		            	
						items:[
						{
							text: '7',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '8',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '9',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '/',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '(',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: ')',
							width: 40,	
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '4',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '5',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '6',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '*',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '취&nbsp;&nbsp;&nbsp;&nbsp;소',
							colspan: 2,
							width: 100,
							handler: function(btn) {
								treatCalcArea('delete');
							}
						},{
							text: '1',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '2',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '3',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '-',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '전체취소',
							colspan: 2,
							width: 100,
							handler: function(btn) {
								treatCalcArea('delete all');
							}
						},{
							text: '0',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '(-)',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '.',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '+',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '저&nbsp;&nbsp;&nbsp;&nbsp;장',
							colspan: 2,
							width: 100,
							handler: function(btn) {
								treatCalcArea('save');
							}
						}]
					}
				   ]
		    }]
		,listeners:{	    			
	    	beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts )	{
	    		if(Ext.isObject(oldCard))	{
	    			 if(UniAppManager.app._needSave())	{
	    				if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
							UniAppManager.app.onSaveDataButtonDown();
							this.setActiveTab(oldCard);									
						} else {
// 							oldCard.down().getStore().rejectChanges();									
							UniAppManager.setToolbarButtons('save',false);
							UniAppManager.app.loadTabData(newCard, newCard.getItemId());									
						}
	    			 }else {
    					 UniAppManager.app.loadTabData(newCard, newCard.getItemId());
	    			 }
	    		}
	    	}
	    }
	
	});

    Unilite.Main( {
		borderItems:[tab],
		id  : 'hrt110ukrApp',
		fnInitBinding: function() {
			var activeTabId = tab.getActiveTab().getId();
			UniAppManager.setToolbarButtons('reset', false);
			if(activeTabId == 'hrf110ukrTab01'){
				panelSearch.setValue('DIV_CODE',UserInfo.divCode);
				UniAppManager.setToolbarButtons('detail', false);
				UniAppManager.setToolbarButtons('newData', true);
				UniAppManager.app.onQueryButtonDown();
				selectedGrid = 'masterGrid1';
			}
		},
		onQueryButtonDown: function()	{			
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'hrf110ukrTab01'){
				// 좌측 폼 로드
				panelSearch.uniOpt.inLoading = true;
				panelSearch.getForm().load({
					params : { S_COMP_CODE : UserInfo.compCode },
				 	success: function(form, action){
				 		console.log(action);
				 		panelSearch.uniOpt.inLoading = false;
				 	},
				 	failure: function(form, action) {
				 		console.log(action);
				 		panelSearch.uniOpt.inLoading = false;
				 	}
				});
				masterGrid1.getStore().loadStoreRecords();
				masterGrid2.getStore().loadStoreRecords();
			} else {
				var searchForm = Ext.getCmp('tab02searchPanel').getForm();
				if (searchForm.isValid()) {
// 					directMasterStore3.loadStoreRecords();
					directMasterStore4.loadStoreRecords();
				} else {
					var invalid = searchForm.getFields().filterBy(function(field) {
						return !field.validate();
					});
					if (invalid.length > 0) {
						r = false;
						var labelText = ''
			
						if (Ext.isDefined(invalid.items[0]['fieldLabel'])) {
							var labelText = invalid.items[0]['fieldLabel'] + '은(는)';
						} else if (Ext.isDefined(invalid.items[0].ownerCt)) {
							var labelText = invalid.items[0].ownerCt['fieldLabel'] + '은(는)';
						}		
						Ext.Msg.alert('확인', labelText + Msg.sMB083);
						invalid.items[0].focus();
					}
				} 
			}
		},
		onNewDataButtonDown: function() {
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'hrf110ukrTab01'){
				if (selectedGrid != '') {
					if (selectedGrid == 'masterGrid1') {
						masterGrid1.createRow( {OT_KIND : 'ST'} );
					} else {
						masterGrid2.createRow();
					}
					UniAppManager.setToolbarButtons('delete', true);
				}	
			}
		},
		loadTabData: function(tab, itemId){
			if (tab.getId() == 'hrf110ukrTab01'){
				UniAppManager.setToolbarButtons('newData', true);
				if (masterGrid1.getStore().getCount() > 0 || masterGrid2.getStore().getCount() > 0 ) {
					UniAppManager.setToolbarButtons('delete', true);
				}
			} else {
				UniAppManager.setToolbarButtons('newData', false);
				UniAppManager.setToolbarButtons('delete', false);
				directMasterStore3.loadStoreRecords();
			}
		},
		onDeleteDataButtonDown: function() {
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'hrf110ukrTab01'){
				var grid = Ext.getCmp('hrt110ukrGrid1');
				if (selectedGrid == 'hrt110ukrGrid2') { 
					grid = Ext.getCmp('hrt110ukrGrid2');
				}
				if (grid.getStore().getCount == 0) return;
				var selRow = grid.getSelectionModel().getSelection()[0];
				if (selRow.phantom === true)	{
					grid.deleteSelectedRow();
				} else {
					Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
						if (btn == 'yes') {
							grid.deleteSelectedRow();
							UniAppManager.app.setToolbarButtons('save', true);
						}
					});
				}	
			} else {
				var grid = Ext.getCmp('masterGrid4');
				var selRow = grid.getSelectionModel().getSelection()[0];
				if (selRow.phantom === true)	{
					grid.deleteSelectedRow();
				} else {
					Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
						if (btn == 'yes') {
							grid.deleteSelectedRow();
							UniAppManager.app.setToolbarButtons('save', true);
						}
					});
				}
			}
		},
		onSaveDataButtonDown: function() {
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'hrf110ukrTab01'){
				if (panelSearch.getForm().isDirty()) {
					panelSearch.getForm().submit({
						success:function(comp, action)	{
							UniAppManager.app.setToolbarButtons('save',false);
							console.log('submit done!');
							//Ext.Msg.alert('확인', '저장하였습니다.');
							UniAppManager.app.setToolbarButtons('save',false);
						},
						failure: function(form, action){
							UniAppManager.app.setToolbarButtons('save', true);
						}
					});
				}
				// syncAll을 한번만 호출하기 위해서
				if (masterGrid1.getStore().isDirty() && masterGrid2.getStore().isDirty()) {
					masterGrid1.getStore().sync();
					masterGrid1.getStore().reload();
					masterGrid2.getStore().syncAllDirect();
					masterGrid2.getStore().reload();
					UniAppManager.app.setToolbarButtons('save',false);
				} else if (!masterGrid1.getStore().isDirty() && masterGrid2.getStore().isDirty()) {
					masterGrid2.getStore().syncAllDirect();
					masterGrid2.getStore().reload();
					UniAppManager.app.setToolbarButtons('save',false);						
				} else if (masterGrid1.getStore().isDirty() && !masterGrid2.getStore().isDirty()) {
					masterGrid1.getStore().syncAllDirect();
					masterGrid1.getStore().reload();
					UniAppManager.app.setToolbarButtons('save',false);
				}	
			} else {
				var grid = Ext.getCmp('masterGrid4');
				if (grid.getStore().isDirty()) {
					grid.getStore().syncAllDirect();
					UniAppManager.app.setToolbarButtons('delete', false);
					UniAppManager.app.setToolbarButtons('save', false);
				}
			}
		}
	});
    
	// 보여지는 계산식
	showSentence = ''
	// 저장되는 계산식
	saveSentence = '';
	
	// 계산식에 항목 추가 /삭제 
	function treatCalcArea(btnText) {			
		showSentence = Ext.getCmp('CALC_TXT').getValue();
    	switch(btnText) {
			case 'delete' :
				if (saveSentence.length > 0) {
					var sentenceArray = saveSentence.split(',');
					if (sentenceArray.length > 1) {
						showSentence = '';
						saveSentence = '';
						for (var i = 0; i < sentenceArray.length - 1; i++) {
							showSentence = showSentence + sentenceArray[i];
							if (i == 0) {
								saveSentence = saveSentence + sentenceArray[i];
							} else {
								saveSentence = saveSentence + ',' + sentenceArray[i];
							} 
						}	
					} else {
						showSentence = saveSentence = '';
					}
				}
				break;
			case 'delete all' : 
				showSentence = saveSentence = '';
				break;
			case 'save' :
				
				if (Ext.getCmp('CALC_TXT').value == '') {
					Ext.Msg.alert('확인', '계산식을 입력하십시오.');
					return;
				}
				if (Ext.getCmp('SUPP_TYPE').getValue() == '') {
					Ext.Msg.alert('확인', '구분을 입력하십시오.');
					return;
				}
				if (Ext.getCmp('OT_KIND_01').getValue() == '') {
					Ext.Msg.alert('확인', '분류값을 입력하십시오.');
					return;
				}
				console.log('do save!');
				
				// 음수 부호를 다시 변경함
				saveSentence = saveSentence.replace('~', '-');
				
				var SUPP_TYPE = Ext.getCmp('SUPP_TYPE').getValue();
				var OT_KIND_01 = Ext.getCmp('OT_KIND_01').getValue();
				var regExp = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/;
				
				var saveSentenceArray = saveSentence.split(',');
				
				// 서버로 전송 할 JSON data
				var param = new Array(saveSentenceArray.length);
				
				for (var i = 0; i < saveSentenceArray.length; i++) {
					
					var SELECT_VALUE = '';
					var SELECT_NAME = '';
					var TABLE_NAME = '';
					var WHERE_COLUMN = '';
					var TYPE = '';
					var SELECT_SYNTAX = '';
					var UNIQUE_CODE = '';
					var CALCU_SEQ = (i + 1);
					
					if (regExp.test(saveSentenceArray[i])) {
						var selectedModel = directMasterStore3.findRecord('CODE_NAME', saveSentenceArray[i]);
						if (selectedModel != null && selectedModel != '') {
							SELECT_VALUE = UNIQUE_CODE = selectedModel.data.SUB_CODE;
							TYPE = '2';
						}				
					} else {
						TYPE = '1';
						SELECT_VALUE = UNIQUE_CODE = saveSentenceArray[i];
					}
					
					data = new Object();
					data['SELECT_VALUE'] = SELECT_VALUE;
					data['TYPE'] = TYPE;
					data['UNIQUE_CODE'] = UNIQUE_CODE;
					data['OT_KIND_01'] = OT_KIND_01;
					data['SUPP_TYPE'] = SUPP_TYPE;
					data['CALCU_SEQ'] = CALCU_SEQ;
					data['S_USER_ID'] = "${loginVO.userID}";
					data['S_COMP_CODE'] = "${loginVO.compCode}";
					
					param[i] = data;				
				}
				console.log(param);
				
				Ext.Ajax.request({
					url     : CPATH+'/human/hrt110ukrInsertCalcSentence.do',
					params: {
						data: JSON.stringify(param)
					},
					success: function(response){
						data = Ext.decode(response.responseText);
						console.log(data);
						if(data && !Ext.isEmpty(data.ErrorMessage))	{
							console.log("Error : ", data.ErrorMessage);
							Ext.MessageBox.show({
				                title: CommonMsg.errorTitle.ERROR,
				                msg: '이미 등록된 계산식이 있습니다.'+'\n'+ '삭제 후 입력해 주세요.',
				                icon: Ext.MessageBox.ERROR,
				                buttons: Ext.Msg.OK,
				                fn: function(btn, text) {
				                	
				                }
				            });			
						}else {
							UniAppManager.app.onQueryButtonDown();
						}
						showSentence = saveSentence = '';
						Ext.getCmp('CALC_TXT').setValue('');
					},
					failure: function(response){
						console.log(response);
					}
				});
				break;
			case '(' : // '+(-*/'
				if (showSentence.length == 0 || (showSentence.length > 0 && (saveSentence.slice(-1) == '+' || saveSentence.slice(-1) == '(' ||
						saveSentence.slice(-1) == '-' || saveSentence.slice(-1) == '*' || saveSentence.slice(-1) == '/'))) {
					showSentence = showSentence + btnText;
					saveSentence = saveSentence + ',' + btnText;
				}
				break;
			case ')' :  // '(.~+-*/'
				if (showSentence.length > 0 && saveSentence.slice(-1) != '(' && saveSentence.slice(-1) != '.' &&
						saveSentence.slice(-1) != '~' && saveSentence.slice(-1) != '+' &&
						saveSentence.slice(-1) != '-' && saveSentence.slice(-1) != '*' &&
						saveSentence.slice(-1) != '/') {
					showSentence = showSentence + btnText;
					saveSentence = saveSentence + ',' + btnText;
				}
				break;
			case '/' :
			case '*' :
			case '-' :
			case '+' : // '(/*-+.'
				if (showSentence.length > 0 && (saveSentence.slice(-1) != '(' &&
						saveSentence.slice(-1) != '/' && saveSentence.slice(-1) != '*' && 
						saveSentence.slice(-1) != '-' && saveSentence.slice(-1) != '+' && 
						saveSentence.slice(-1) != '.' && saveSentence.slice(-1) != '~')) {
					showSentence = showSentence + btnText;
					saveSentence = saveSentence + ',' + btnText;
				}
				break;
			// 마이너스 부호의 경우 편의상 '~'로 처리함
			case '(-)' : // '(/*-+'
				if (showSentence.length == 0) {
					showSentence = showSentence + '~';
					saveSentence = saveSentence + '~';
				} else if (showSentence.length > 0 && (saveSentence.slice(-1) == '(' ||
						saveSentence.slice(-1) == '/' || saveSentence.slice(-1) == '*' || 
						saveSentence.slice(-1) == '-' || saveSentence.slice(-1) == '+')) {
					showSentence = showSentence + '~';
					saveSentence = saveSentence + ',' + '~';
				}
				break;
			case '.' : // '()/*-+.~'
				if (showSentence.length > 0 && (saveSentence.slice(-1) != '(' && saveSentence.slice(-1) != ')' &&
						saveSentence.slice(-1) != '/' && saveSentence.slice(-1) != '*' && 
						saveSentence.slice(-1) != '-' && saveSentence.slice(-1) != '+' && 
						saveSentence.slice(-1) != '.' && saveSentence.slice(-1) != '~')) {
					showSentence = showSentence + btnText;
					saveSentence = saveSentence + btnText;
				}
				break;
			default:
				showSentence = showSentence + btnText;
				if (saveSentence.length > 0 && (saveSentence.slice(-1) == '(' || saveSentence.slice(-1) == '/' || 
												saveSentence.slice(-1) == '*' || saveSentence.slice(-1) == '-' || 
												saveSentence.slice(-1) == '+')) {
					saveSentence = saveSentence + ',' + btnText;
				} else {
					saveSentence = saveSentence + btnText;
				}				
				break;
		}
		
		showSentence = showSentence.replace('~', '-');
		
		Ext.getCmp('CALC_TXT').setValue(showSentence);
	}

};


</script>
