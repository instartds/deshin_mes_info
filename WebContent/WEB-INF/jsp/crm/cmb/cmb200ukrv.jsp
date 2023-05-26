<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="cmb200ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="B012" />
	<t:ExtComboStore comboType="AU" comboCode="CB20" />
	<t:ExtComboStore comboType="AU" comboCode="CB21" />
	<t:ExtComboStore comboType="AU" comboCode="CB22" />
	<t:ExtComboStore comboType="AU" comboCode="CB23" />
	<t:ExtComboStore comboType="AU" comboCode="CB24" />
	<t:ExtComboStore comboType="AU" comboCode="CB46" />
	<t:ExtComboStore comboType="AU" comboCode="CB48" /><!-- 영업담당자 -->
	<t:ExtComboStore comboType="AU" comboCode="CB49" /><!-- 개발담당자 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var detailWin;

function appMain() {	
	Unilite.defineModel('Cmb200ukrvModel', {
    	fields: [{
    		name: 'COMP_CODE'  			, text: '법인코드'  	, type: 'string', editable: false, allowBlank: false, isPk:true, defaultValue: UserInfo.compCode
		},{
			name: 'PROJECT_NO'  		, text: '영업기회 번호'	, type: 'string', editable: false, isPk: true
		},{
			name: 'PROJECT_NAME'  		, text: '영업기회명'  	, type: 'string', allowBlank: false
		},{
			name: 'PROJECT_OPT'  		, text: '영업기회구분'	, type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'CB24'
		},{
			name: 'START_DATE'  		, text: '시작일'  	, type: 'uniDate', allowBlank: false
		},{
			name: 'TARGET_DATE'  		, text: '완료 목표일'  	, type: 'uniDate', allowBlank: false
		},{
			name: 'PROJECT_TYPE'  		, text: '구분'  		, type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'CB20'
		},{
			name: 'CLASS_LEVEL1'  		, text: '유형분류(중)' , type: 'string', comboType: 'AU', comboCode: 'CB21'
		},{
			name: 'CLASS_LEVEL2'  		, text: '유형분류(소)' , type: 'string', comboType: 'AU', comboCode: 'CB22'
		},{
			name: 'SALE_EMP'  			, text: '영업담당자'  	, type: 'string', comboType: 'AU', comboCode:'CB48'
		},{
			name: 'DEVELOP_EMP'  		, text: '개발담당자'  	, type: 'string', comboType: 'AU', comboCode:'CB49'
    	},{ //(BCM100T-NATION_CODE)
			name: 'NATION_CODE'  		, text: '거래처국가'  	, type: 'string', editable: false, comboType: 'AU', comboCode: 'B012'
    	},{ //(BCM100T_CUSTOM_CODE)
			name: 'CUSTOM_CODE'  		, text: '거래처코드' 	, type: 'string', allowBlank: false
		},{
			name: 'CUSTOM_NAME'  		, text: '업체'  		, type: 'string', allowBlank: false
		},{ //(SCM100T_DVRY_CUST_SEQ)
			name: 'DVRY_CUST_SEQ'  		, text: '배송처코드'  	, type: 'int', allowBlank:true
		},{
			name: 'DVRY_CUST_NM'  		, text: '배송처'  	, type: 'string'
		},{
			name: 'SALE_STATUS'			, text: '상태'  		, type: 'string', comboType:'AU', comboCode: 'CB46', editable: false
		},{
			name: 'IMPORTANCE_STATUS'  	, text: '중요도'  	, type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'CB23'
		},{
			name: 'PAD_STR'  			, text: '경로'  		, type: 'string'
		},{
			name: 'SLURRY_STR'  		, text: '경쟁사'  	, type: 'string'
		},{
			name: 'MONTH_QUANTITY' 		, text: '예상규모'  	, type: 'uniPrice', allowBlank: false
		},{
			name: 'CURRENT_DD'  		, text: '제품'  		, type: 'string'
		},{
			name: 'EFFECT_STR'  		, text: '효과'  		, type: 'string'
		},{
			name: 'KEYWORD'  			, text: '키워드'  	, type: 'string'
		},{
			name: 'REMARK'  			, text: '비고'  		, type: 'string'
		},{
			name: 'PURCHASE_AMT'		, text: '매입액'		, type: 'uniPrice'
		},{
        	name: 'MARGIN_AMT'			, text: '마진액'		, type: 'uniPrice', editable: false
		},{
        	name: 'MARGIN_RATE'			, text: '마진율'		, type: 'uniPercent', editable: false
		},{
        	name: 'EXPECTED_ORDER'		, text: '수주예정'		, type: 'uniDate'
		}]
	});
	
	var directMasterStore = Unilite.createStore('cmb200ukrvMasterStore',{
		model: 'Cmb200ukrvModel',
        autoLoad: false,
     	uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable:true,			// 삭제 가능 여부 
			useNavi : true			// prev | newxt 버튼 사용
        },
		proxy: {
        	type: 'direct',
			api: {
				read:    'cmb200ukrvService.selectList',
				update:  'cmb200ukrvService.updateMulti',
				create:  'cmb200ukrvService.insertMulti',
				destroy: 'cmb200ukrvService.deleteMulti',
				syncAll: 'cmb200ukrvService.syncAll'
			}
		},
		listeners: {
			load:function(store, records, successful, eOpts)	{
					var params = Unilite.getParams();
					console.log("after Load - var params = Unilite.getParams(); " , records.length)
					if(!Ext.isEmpty(params.projectNo) && records.length == 1)	{
						openDetailWindow(records[0], false);
					}
			}
		},
		loadStoreRecords: function(config) {
			var param = Ext.getCmp('searchForm').getValues();			
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function(config) {		
			var app = Ext.getCmp('cmb200ukrvApp');
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			console.log("toUpdate",toUpdate);
         	var rv = true;
    	
			if(inValidRecs.length == 0) {
				for(var i=0; i < toCreate.length; i++) {
					if(toCreate[i].data['PROJECT_OPT']=='2') {
						if(toCreate[i].data['SALE_EMP'] == '' || toCreate[i].data['DEVELOP_EMP'] == '')	{
							alert(Msg.sMB083);
							rv = false;
						}
					}

					if(toCreate[i].data['START_DATE'] != '' && toCreate[i].data['TARGET_DATE'] != '') {
						if(toCreate[i].data['START_DATE'] > toCreate[i].data['TARGET_DATE']) {
							alert(Msg.sMB084);
							rv = false;
						}
					}
				}

				for(var i=0; i < toUpdate.length; i++) {
					if(toUpdate[i].data['PROJECT_OPT']=='2') {
						if(toUpdate[i].data['SALE_EMP'] == '' || toUpdate[i].data['DEVELOP_EMP'] == '')	{
							alert(Msg.sMB083);
							rv = false;
						}
					}

					if(toUpdate[i].data['START_DATE'] != '' && toUpdate[i].data['TARGET_DATE'] != '') {
						if(toUpdate[i].data['START_DATE'] > toUpdate[i].data['TARGET_DATE']) {
							alert(Msg.sMB084);
							rv = false;
						}
					}
				}
	
				if(rv) {
					if(config == null) {
						config = {success: function() {
									var selected = Ext.getCmp('cmb200ukrvGrid').getSelectedRecord();
									if(clientListStore.isDirty()) {
										clientListStore.saveStore();
									}
					 			}};
					}
					this.syncAll(config);
				}

			} else {
				alert(Msg.sMB083);
			}
		},
		insertRecord: function(index) {
         	var r = Ext.create('Cmb200ukrvModel', {
            	COMP_CODE: UserInfo.compCode,  	// 법인코드    
				MONTH_QUANTITY: "0",			// 월사용량					
				PROJECT_OPT: "2"  				// 외부 
       		});
       		this.insert(index, r);
			return r;
		}
	});
	

	Unilite.defineModel('Cmb200ukrvClientModel', {
    	fields: [{
    		name: 'PROJECT_NO'  	, text: '프로젝트번호' 		, type: 'string', editable: false, isPk:true
		},{
			name: 'CLIENT_ID'  		, text: '고객ID'  		, type: 'string', editable: false, isPk:true
		},{
			name: 'CLIENT_NAME'  	, text: '고객명' 			, type: 'string', allowBlank: false
		},{
			name: 'COMP_CODE'  		, text: '법인코드'			, type: 'string', allowBlank: false
		},{
			name: 'ORG_CLIENT_ID'	, text: '고객ID(수정전)'	, type: 'string'
		}]
	});
	
	var clientListStore = Unilite.createStore('clientListStore', {
		model: 'Cmb200ukrvClientModel',
        autoLoad: false,
     	uniOpt: {
			isMaster: false,		// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable:true,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
        },
		batchUpdateMode: 'operation',
        proxy: {
			type: 'direct',
			api: {
				read:    'cmb200ukrvService.selectClientList',
				update:  'cmb200ukrvService.updateClients',
				create:  'cmb200ukrvService.insertClients',
				destroy: 'cmb200ukrvService.deleteClients',
				syncAll: 'cmb200ukrvService.syncAll'
			}
		},
		saveStore: function(config)	{				
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0) {
				if(config==null) {
					config = {success: function() {
											//UniAppManager.setToolbarButtons('save',false);
											//var win = this.up('uniDetailFormWindow');
											detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
										}
							  }
				}
				this.syncAll(config);
			} else {
				alert(Msg.sMB083);
			}
		}
	});						

	var panelSearch = Unilite.createSearchForm('searchForm',{
		region:'west',	
		title: '검색조건',
		split:true,
        width:337,
        margin: '0 0 0 0',
	    border: true,
		collapsible: false,	
		autoScroll:true,
		collapseDirection: 'left',
		tools: [{
			region:'west',
			type: 'left', 	
			itemId:'left',
			tooltip: 'Hide',
			handler: function(event, toolEl, panelHeader) {
						panelSearch.collapse(); 
				    }
			}
		],
		items:[{
		xtype:'container',
		defaults:{
			collapsible:true,
			titleCollapse:true,
			hideCollapseTool : true,
			bodyStyle:{'border-width': '0px',
						'spacing-bottom':'3px'
			},
			header:{ xtype:'header',
					 style:{
								'background-color': '#D9E7F8',
								'background-image':'none',
								'color': '#333333',
								'font-weight': 'normal',
								'border-width': '0px',
								'spacing':'5px'
							}
					}
		},		
		layout: {type: 'vbox', align:'stretch'},
	    defaultType: 'panel',
		items: [{	
			title: '기본정보', 	
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	items: [{
        	xtype: 'container',
           	flex: 1,
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '영업기회명',
				type: 'uniTextfield',
				name: 'PROJECT_NAME',
				tooltip: '영업기회명을 입력하세요'
			},
	        	Unilite.popup('CUST', {
	        		fieldLabel: '거래처',
	        		colspan:2,
	        		textFieldWidth:170,
	        		//validateBlank: false,
	        		tooltip:'거래처를 선택하세요. \n - 더블클릭(줄바꿈 시험용) : popup',
					valueFieldName: 'CUSTOM_CODE',
					textFieldName: 'CUSTOM_NAME',
					DBvalueFieldName: 'CUSTOM_CODE',
					DBtextFieldName: 'CUSTOM_NAME'
				}),			
			{
				fieldLabel: '구분',
				name: 'GUBUN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'CB20',
				tooltip: '엽업기회 구분을 선택해 주세요'
			},{
				fieldLabel: '유형분류(중)',
				name: 'LEVEL2',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'CB21'
			},{
				fieldLabel: '유형분류(소)',
				name: 'LEVEL3',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'CB22'
			}]
        	}]		
		}]
		}]
	});	//end panelSearch

	var masterGrid = Unilite.createGrid('cmb200ukrvGrid', {   
		store: directMasterStore,
		region: 'center',
		uniOpt:{	
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
		tbar: [{
			text:'상세보기',
			handler: function() {
				var record = masterGrid.getSelectedRecord();
				if(record) {
					openDetailWindow(record);
				}
			}
        }],
        columns: [{
			dataIndex: 'COMP_CODE',  	width: 80, hidden: true
        },{ // 영업기회 번호
			dataIndex: 'PROJECT_NO',  	width: 100, isLink:true
        },{ // 영업기회명
			dataIndex: 'PROJECT_NAME', 	width: 150
        },{ // 영업기회구분
			dataIndex: 'PROJECT_OPT',  	width: 80, align: 'center'
        },{ // 시작일
			dataIndex: 'START_DATE',  	width: 90
        },{ // 
			dataIndex: 'TARGET_DATE',  	width: 90, text: '완료 목표일'
        },{ // 
			dataIndex: 'PROJECT_TYPE', 	width: 140
        },{ // 유형분류(중) 
			dataIndex: 'CLASS_LEVEL1', 	width: 100
        },{ // 유형분류(소)
			dataIndex: 'CLASS_LEVEL2',  width: 140
        },{ // 영업담당자
			dataIndex: 'SALE_EMP',  	width: 90, align: 'center'
        },{ // 개발담당자
			dataIndex: 'DEVELOP_EMP',  	width: 90, align: 'center' 
        }, {
        	dataIndex: 'EXPECTED_ORDER', width: 100
        } ,{ // 거래처국가
			dataIndex: 'NATION_CODE',  	width: 100
        },{ // 거래처코드
			dataIndex: 'CUSTOM_CODE',  	width: 100, hidden: true 
        },{ // 
			dataIndex: 'CUSTOM_NAME',
			width: 100,  
			editor: Unilite.popup('CUST_G', {
				listeners: {
					onSelected: {
						fn: function(records, type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
							grdRecord.set('NATION_CODE',records[0]['NATION_CODE']);
						},
	                    scope: this
					},
					onClear: function(type) {
						var grdRecord = masterGrid.uniOpt.currentRecord;
						grdRecord.set('CUSTOM_CODE','');
						grdRecord.set('CUSTOM_NAME','');
						grdRecord.set('NATION_CODE','');
	                }
				}
			}) 	 
/*
		},{ // 배송처코드
			dataIndex: 'DVRY_CUST_SEQ',	width: 80, hidden: true
		},{ // 배송처
			dataIndex: 'DVRY_CUST_NM',	width: 80, hidden: true
*/
		},{ // 영업상태
			dataIndex: 'SALE_STATUS',		width: 110, tooltip: true 
        },{ // 중요도
			dataIndex: 'IMPORTANCE_STATUS',	width: 50, align: 'center'
        },{ // 경로
			dataIndex: 'PAD_STR',			width: 120
        },{ // 경쟁사
			dataIndex: 'SLURRY_STR',  		width: 120
        },{ // 예상규모
			dataIndex: 'MONTH_QUANTITY', 	width: 100
        },{ // 
			dataIndex: 'PURCHASE_AMT',		width: 100
        },{ // 
			dataIndex: 'MARGIN_AMT',		width: 100
        },{ // 
        	dataIndex: 'MARGIN_RATE',		width: 100
        },{ // 제품
			dataIndex: 'CURRENT_DD',  		width: 120
        },{ // 효과
			dataIndex: 'EFFECT_STR',  		width: 120
        },{ // 키워드
			dataIndex: 'KEYWORD',  			width: 120
        },{ // 비고
			dataIndex: 'REMARK',  			width: 120
        }] ,
		listeners: { 
	          onGridDblClick:function(grid, record, cellIndex, colName) {
					if(colName == 'PROJECT_NO') {
						
						openDetailWindow(record);
					} 
	          } //onGridDblClick
		 }
    });
	
    var cmb200ukrvClientGrid = Unilite.createGrid('cmb200ukrvClientGrid', {   
    	store : clientListStore,
		editable: true,
		width: '100%',
		height: 180,
		flex: 1,
		scroll: true,
		uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
		},
        columns:  [   {dataIndex: 'COMP_CODE',hidden:true} 
        			 ,{dataIndex: 'PROJECT_NO',hidden:true} 
        			 ,{dataIndex: 'CLIENT_ID'	,hidden:false}
        			 ,{dataIndex: 'CLIENT_NAME',  width: 205 , flex:1,
        			 		'editor': Unilite.popup('CUSTOMER_G',{ listeners: {
						                'onSelected': {
						                    fn: function(records, type) {
												var me = this;
						                    	var grdRecord = Ext.getCmp('cmb200ukrvClientGrid').uniOpt.currentRecord;
						                    	grdRecord.set('CLIENT_ID',records[0]['CLIENT_ID']);	
						                    	grdRecord.set('CLIENT_NAME',records[0]['CLIENT_NAME']);	
						                    	if(clientListStore.isDirty())	{
						                    		//var win = this.up().up('uniDetailFormWindow');
													detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],true);
						                    	}
						                    },
						                    scope: this
						                },
						                'onClear' : function(type)	{
						                	var grdRecord = Ext.getCmp('cmb200ukrvClientGrid').uniOpt.currentRecord;
						                    grdRecord.set('CLIENT_ID','');
						                    grdRecord.set('CLIENT_NAME','');
						                    //var win = this.up().up('uniDetailFormWindow');
						                    if(clientListStore.isDirty())	{						                    		
												detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],true);
						                    }else {
						                    	if(!directMasterStore.isDirty())	{
						                    		detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
						                    	}
						                    }
						                }
						            }
								})
        				}
        			  
        			
		          ]
		
		,tbar: [ {
			itemId : 'addClient',
			text: '+',
			handler: function() {
				if(detailForm.getValue('PROJECT_NO') != null && detailForm.getValue('PROJECT_NO') != '')	{
					var r = Ext.create('Cmb200ukrvClientModel', {
						COMP_CODE: detailForm.getValue('COMP_CODE'),
						PROJECT_NO: detailForm.getValue('PROJECT_NO')
					});
					clientListStore.insert(0, r);
					//var win = this.up('uniDetailFormWindow');
					detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],true);
				}else {
					alert('영업기회내역 기본저장후 진행하십시오.');
				}
			},
			disabled: false
		}, {
			itemId : 'removeClient',
			text: '-',
			handler: function() {
				var sm = cmb200ukrvClientGrid.getSelectionModel();
				
				clientListStore.remove(sm.getSelection());
				if (clientListStore.getCount() > 0) {
					sm.select(0);
				}
				//var win = this.up('uniDetailFormWindow');
				if(clientListStore.isDirty())	{
					detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],true);
				}else {
					if(!directMasterStore.isDirty())	{
						detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
					}
				}
				
			},
			disabled: false
		} ],
		listeners: {
			'selectionchange': function(view, records) {
				cmb200ukrvClientGrid.down('#removeClient').setDisabled(!records.length);
			}
		}
    });
    
    var detailForm = Unilite.createForm('detailForm', {
	    layout: {type: 'uniTable', columns: 2, tdAttrs: {valign:'top'}},
	    defaultType: 'uniFieldset',
	    masterGrid: masterGrid,
	    //disabled:false,
	    items : [{ 
        			  title: '기본정보'
        			, colspan : 2
        			, defaultType: 'uniTextfield'
        			, layout: { type: 'uniTable', columns: 3}
        			,id : 'basic1'
	    			//, defaults : { margin: '5 5 5 5',anchor: '100%'}
        			, items :[	  {fieldLabel: '법인코드',  name: 'COMP_CODE',  hidden:true}
        						 ,{fieldLabel: '영업기회번호',  name: 'PROJECT_NO',  readOnly :true, tooltip:'시스템에의해 자동생성됩니다.'}
        						 ,{fieldLabel: '영업기회명',  	name: 'PROJECT_NAME', allowBlank: false}
        						 ,{fieldLabel: '영업기회유형',  name: 'PROJECT_OPT', allowBlank: false, xtype: 'uniRadiogroup', comboType:'AU', comboCode:'CB24' ,width:200, value:'2'
        						   , listeners: {
							 			'change' : function(field, newValue, oldValue, eOpts) {
							 						var frm = Ext.getCmp('detailForm');
							 						var saleEmp = frm.getField('SALE_EMP')
							 						var developEmp = frm.getField('DEVELOP_EMP')
							 						if(newValue['PROJECT_OPT']=='2')	{  
							 							if(saleEmp.inputEl)	{
	    						 							saleEmp.inputEl.addCls('x-form-field x-form-required-field x-form-text'); 	        						 							
							 							} else {
							 								saleEmp.fieldCls = 'x-form-field x-form-required-field x-form-text';
							 							}
							 							if(developEmp.inputEl)	{
	    						 							developEmp.inputEl.addCls('x-form-field x-form-required-field x-form-text'); 
							 							}  else {
							 								developEmp.fieldCls = 'x-form-field x-form-required-field x-form-text';
							 							}
							 						} else {
							 							if(saleEmp.inputEl)	{
	    						 							saleEmp.inputEl.removeCls('x-form-required-field'); 
							 							} 
							 							if(developEmp.inputEl)	{
	    						 							developEmp.inputEl.removeCls('x-form-required-field'); 
							 							}  	
							 						}
							 					}
							 		}
        						 }
        						 ,{fieldLabel: '구분',  		name: 'PROJECT_TYPE',  	xtype: 'uniCombobox', comboType:'AU', comboCode:'CB20' , allowBlank: false} 
        						 ,{fieldLabel: '유형분류(중)',  name: 'CLASS_LEVEL1', 	xtype: 'uniCombobox', comboType:'AU', comboCode:'CB21' }
        						 ,{fieldLabel: '유형분류(소)',  name: 'CLASS_LEVEL2', 	xtype: 'uniCombobox', comboType:'AU', comboCode:'CB22' }
        						 ,{fieldLabel: '시작일',  		name: 'START_DATE', 	xtype: 'uniDatefield', allowBlank: false}
        						 ,{fieldLabel: '완료 목표일',  	name: 'TARGET_DATE',	xtype: 'uniDatefield', allowBlank: false}
        						 ,{fieldLabel: '영업담당자',  	name: 'SALE_EMP',	 	xtype: 'uniCombobox', 	comboType:'AU',comboCode:'CB48', allowBlank: false}
        						 ,{fieldLabel: '개발담당자',  	name: 'DEVELOP_EMP', 	xtype: 'uniCombobox', 	comboType:'AU',comboCode:'CB49', allowBlank: false} 
        						 ,{fieldLabel: '수주예정',  	name: 'EXPECTED_ORDER',	xtype: 'uniDatefield'} 
					         ]
	    		}
	    	   ,{   title: '공정정보'
        			//,collapsible: true
        			, colspan : 2
        			, layout: {
					            type: 'uniTable',
					            columns: 3
					        }
        			,defaultType: 'uniTextfield'
        			, items :[	 {fieldLabel: '국가',  name: 'NATION_CODE', xtype: 'uniCombobox', comboType:'AU', comboCode:'B012', readOnly: true}
        						 ,Unilite.popup('CUST',{fieldLabel: '거래처', allowBlank: false , colspan:2, textFieldWidth:140,  valueFieldName:'CUSTOM_CODE', textFieldName:'CUSTOM_NAME' ,DBvalueFieldName:'CUSTOM_CODE', DBtextFieldName:'CUSTOM_NAME',
        						 listeners: {
						                'onSelected': {
						                    fn: function(records, type) {
						                         var frm = Ext.getCmp('detailForm');
						                         frm.setValue('NATION_CODE', records[0]['NATION_CODE']);
						                    },
						                    scope: this
						                },
						                'onClear' : function(type)	{
						                		  var frm = Ext.getCmp('detailForm');
						                         frm.setValue('NATION_CODE', '');
						                }   	
						            }
						            })
        						 //,{fieldLabel: '배송처',  name: 'DVRY_CUST_NM',id:'DVRY_CUST_NM', hidden:true}//, allowBlank: false}
        						 //,{fieldLabel: '배송처코드',  name: 'DVRY_CUST_SEQ', hidden:true}
        						 ,{fieldLabel: '상태'	,  name: 'SALE_STATUS',  xtype: 'uniCombobox', comboType:'AU', comboCode:'CB46'  , readOnly:true}
        						 ,{fieldLabel: '중요도'	,  name: 'IMPORTANCE_STATUS', xtype: 'uniCombobox',allowBlank: false, comboType:'AU', comboCode:'CB23'  }
        						 ,{fieldLabel: '경로'	,  name: 'PAD_STR'}
        						 ,{fieldLabel: '경쟁사'	,  name: 'SLURRY_STR'}
        						 ,{fieldLabel: '예상규모',  name: 'MONTH_QUANTITY', xtype:'uniNumberfield'}
        						 ,{fieldLabel: '제품',  name: 'CURRENT_DD'}
        						 ,{fieldLabel: '매입액',  name: 'PURCHASE_AMT', xtype: 'uniNumberfield'}
        						 ,{fieldLabel: '마진액',  name: 'MARGIN_AMT', xtype: 'uniNumberfield',  decimalPrecision:0, readOnly:true}
        						 ,{fieldLabel: '마진율',  name: 'MARGIN_RATE', xtype: 'uniNumberfield',  decimalPrecision:2, readOnly:true, suffixTpl:'&nbsp;%'}
        						 		
        					]
	    		}
	    	   
	    		,{  title: '기타'
	    			,width : 363
        			,items :[	  {fieldLabel: '효과'	,  name: 'EFFECT_STR', width : 340, xtype: 'textarea', height:140}
        					     ,{fieldLabel: 'Keyword',  name: 'KEYWORD' , xtype:'uniTextfield', width : 340} 
        					 ]
        			, height: 200
	    		}
	    		,{  title: '관련고객'
	    			,width : 360
        			, items :[ cmb200ukrvClientGrid] //목록 추가 콘트롤
        			, height: 200
	    		}
	    		
	    		]

				,loadForm: function(record)	{
       				// window 오픈시 form에 Data load
					this.reset();
					clientListStore.removeAll();
					this.setActiveRecord(record || null);   
					this.resetDirtyStatus();
					
					if(record && record.data)	{
						clientListStore.load({
							params : {PROJECT_NO : record.data['PROJECT_NO'],
									  COMP_CODE	 : record.data['COMP_CODE']}
						});	
					}
					var win = this.up('uniDetailFormWindow');
                    if(win) {       // 처음 윈도열때는 윈독 존재 하지 않음.
       				     win.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
                         win.setToolbarButtons(['prev','next'],true);
                    }
       			}
       			, listeners : {
       				uniOnChange : function( form, field, newValue, oldValue )	{
       					var b = form.isValid();
       					form.getForm().clearInvalid();	//오류 표시 제거
                        this.up('uniDetailFormWindow').setToolbarButtons(['saveBtn','saveCloseBtn'],b);
                        this.up('uniDetailFormWindow').setToolbarButtons(['prev','next'],!b);   // 저장이 필요할경우 이전 다음 disable
       				}
       				
       			}
	    

	});
    
	function openDetailWindow(selRecord, isNew) {
    		// 그리드 저장 여부 확인
    		var edit = masterGrid.findPlugin('cellediting');
			if(edit && edit.editing)	{
				setTimeout("edit.completeEdit()", 1000);
			}
			//UniAppManager.app.confirmSaveData();
    		
			// 추가 Record 인지 확인			
			if(isNew)	{		
				var r = masterGrid.createRow();
				selRecord = r[0];
				if(!selRecord)  selRecord = masterGrid.getSelectedRecord();
			}
			// form에 data load
			detailForm.loadForm(selRecord);
			
			if(!detailWin) {
				detailWin = Ext.create('widget.uniDetailFormWindow', {
	                title: '상세정보',
	                width: 780,				                
	                height: 500,
	                isNew: false,
	                x:0,
	                y:0,
	                items: [detailForm],
	                listeners : {
	                			 show:function( window, eOpts)	{
	                			 	detailForm.setDisabled(false);
	                			 	detailForm.getField('PROJECT_NAME').focus();
	                			 }
	                },
                    onCloseButtonDown: function() {
                        this.hide();
                    },
                    onDeleteDataButtonDown: function() {
                        var record = masterGrid.getSelectedRecord();
                        var phantom = record.phantom;
                        UniAppManager.app.onDeleteDataButtonDown();
                        var config = {success : 
                                    function()  {
                                        detailWin.hide();
                                    }
                            }
                        if(!phantom)    {
                            
                                UniAppManager.app.onSaveDataButtonDown(config);
                            
                        } else {
                            detailWin.hide();
                        }
                    },
                    onSaveDataButtonDown: function() {
                        var config = {success : function()	{
                        						var selRecord = masterGrid.getSelectedRecord();
                        						detailForm.loadForm(selRecord);
                    						 	detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
                    						 	detailWin.setToolbarButtons(['prev','next'],true);
                    					}
                    	}
                        UniAppManager.app.onSaveDataButtonDown(config);
                    },
                    onSaveAndCloseButtonDown: function() {
                        if(!detailForm.isDirty() && !clientListStore.isDirty())   {
                            detailWin.hide();
                        }else {
                            var config = {success : 
                                        function()  {
                                            detailWin.hide();
                                        }
                                }
                            UniAppManager.app.onSaveDataButtonDown(config);
                        }
                    },
			        onPrevDataButtonDown:  function()   {
			            if(masterGrid.selectPriorRow()) {
	                        var record = masterGrid.getSelectedRecord();
	                        if(record) {
                                detailForm.loadForm(record);
	                        }
                        }
			        },
			        onNextDataButtonDown:  function()   {
			            if(masterGrid.selectNextRow()) {
                            var record = masterGrid.getSelectedRecord();
                            if(record) {
                                detailForm.loadForm(record);
                                
                            }
                        }
			        }
				})
    		}
    		
			detailWin.show();
				
    }
    
     Unilite.Main({
      	id  : 'cmb200ukrvApp',
		items:[ {
				  layout:'fit',
				  flex:1,
				  border:false,
				  items:[{
				  		layout:'border',
				  		defaults:{style:{padding: '5 5 5 5'}},
				  		border:false,
				  		items:[
				 		 masterGrid
						,panelSearch
						]}
					]
				}
		],
		fnInitBinding : function(params) {
		    /**
			* 기본값 셋업 
			*/
//			if(params ) {
//				console.log('params(byParam) : ', params) ;
//			} else {
////				var getParams = document.URL.split("?");
////				params = Ext.urlDecode(getParams[getParams.length - 1]);
//				params = Unilite.getParams();
//				console.log('params(newWin) : ', params) ;
//			}
			
			if(params.projectNo ) {
				var sfrm = Ext.getCmp('searchForm');
				sfrm.setValue('PROJECT_NAME',params.projectNo);
				var param = Ext.getCmp('searchForm').getValues();
				console.log(param);
				masterGrid.getStore().loadStoreRecords();				 
			}
			UniAppManager.setToolbarButtons(['reset','newData','excel'],true);
	    },
	    onQueryButtonDown: function () {
			masterGrid.getStore().loadStoreRecords();
		},
		onNewDataButtonDown : function()	{
			openDetailWindow(null, true);	       		
		},
		onPrevDataButtonDown:  function()	{
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function()	{
			masterGrid.selectNextRow();	
		},
		onSaveAsExcelButtonDown: function() {
			masterGrid.downloadExcelXml();
		},
		/**
		 *  삭제
		 *	@param 
		 *	@return
		 */
		 onDeleteDataButtonDown: function() {
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				
				cmb200ukrvClientGrid.reset();
				masterGrid.deleteSelectedRow();
				detailForm.clearForm();
				
			}
		},
		/**
		 *  저장
		 *	@param 
		 *	@return
		 */
		onSaveDataButtonDown: function (config) {
			console.log('Save');
			var masterStore = masterGrid.getStore();
			if(!masterStore.isDirty())	{
				clientListStore.saveStore(config);		
			} else {
				masterStore.saveStore(config);
			}
				
		}
		,onResetButtonDown:function() {
			var frm = Ext.getCmp('searchForm');
			var detailFrm = Ext.getCmp('detailForm');			
			var grid = masterGrid;
			var clientsGrid = cmb200ukrvClientGrid;
			
			frm.getForm().reset();
			detailFrm.clearForm();
			grid.reset();
			clientsGrid.reset();
		},
		rejectSave: function()	{
			directMasterStore.rejectChanges();
			clientListStore.rejectChanges();
			UniAppManager.setToolbarButtons('save',false);
		} // end rejectSave()
		, confirmSaveData: function()	{
            	if(directMasterStore.isDirty() || clientListStore.isDirty())	{
					if(confirm(Msg.sMB061))	{
						this.onSaveDataButtonDown();
					} else {
						this.rejectSave();
					}
				}
				
            }
	});
	
	Unilite.createValidator('validator01', {
		store : directMasterStore,
		grid: masterGrid,
		forms: {'formA:':detailForm},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			if (fieldName == "START_DATE" ) {	
						if(record.get('TARGET_DATE') != null && 
							(newValue > record.get('TARGET_DATE') ) ) {
							 rv=Msg.sMB084;
							 record.set('START_DATE',oldValue);
						}
					
			} else if(fieldName ==  "TARGET_DATE") {		
						if(record.get('START_DATE') != null && 
							(newValue < record.get('START_DATE') ) ) {
							 rv=Msg.sMB084;
							 record.set('TARGET_DATE',oldValue);
						}
			}else if(fieldName == "PURCHASE_AMT") {
					if(newValue != null )	{
						var expAmt = record.get('MONTH_QUANTITY');
						record.set('MARGIN_AMT', expAmt-newValue ) ;
						if(expAmt != 0)	{
							record.set('MARGIN_RATE', (expAmt-newValue)/expAmt *100 ) ;
						}else {
							record.set('MARGIN_RATE', 0 ) ;
						}
					} 
				
			}else if(fieldName == "MONTH_QUANTITY") {
					var pAmt = record.get('PURCHASE_AMT');
					record.set('MARGIN_AMT', newValue-pAmt ) ;
					if(newValue != 0)	{
						record.set('MARGIN_RATE', (newValue-pAmt)/newValue *100 ) ;
					} else {
						record.set('MARGIN_RATE',0);
					}
			}
			return rv;
		}
	}); // validator

};


</script>

