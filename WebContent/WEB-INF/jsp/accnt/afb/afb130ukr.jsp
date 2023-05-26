<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="afb130ukr"  >

	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->	
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!--화폐단위-->
	
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

var otherWindow; // 예산 참조

function appMain() {
	var getStDt 		= ${getStDt};
	var getToDt 		= ${getToDt};
	var chargeInfoList 	= ${chargeInfoList};
	
	function monthFormat(value){
			if(value)	{
				var strTmp = value.replace('.','');
				var arrTmp = new Array();
				arrTmp[0] = strTmp.substring(0,4);
				arrTmp[1] = strTmp.substring(4,strTmp.length);
				if(parseInt(arrTmp[1]) < 1 || parseInt(arrTmp[1]) > 12 )	{
					return '';
				} else if(arrTmp[1].length == 1)	{
					arrTmp[1] ='0'+arrTmp[1];
				} else if(arrTmp[1].length == 3)	{
					arrTmp[1] =arrTmp[1].substring(0,2);
				}
				return Ext.util.Format.format('{0}.{1}', arrTmp[0],arrTmp[1]);
			}
			return value;
		
	}
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'afb130ukrService.selectList',
			update: 'afb130ukrService.updateDetail',
			create: 'afb130ukrService.insertDetail',
			destroy: 'afb130ukrService.deleteDetail',
			syncAll: 'afb130ukrService.saveAll'
		}
	});
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Afb130ukrModel1', {
		
	    fields: [{name: 'ACCNT'				,text: '코드' 		,type: 'string'},
				 {name: 'ACCNT_NAME'		,text: '계정과목' 		,type: 'string'},
				 {name: 'IWALL_YYYYMM'		,text: '이월년월' 		,type: 'string', convert:monthFormat },
				 {name: 'IWALL_AMT_I'		,text: '이월예산금액' 	,type: 'uniPrice'},
				 {name: 'IWALL_DATE'		,text: '이월일자' 		,type: 'uniDate'},
				 {name: 'USER_NAME'			,text: '이월담당자' 	,type: 'string'},
				 {name: 'USER_CODE'			,text: 'USER_CODE'	,type: 'string'},
				 {name: 'COMP_CODE'			,text: '법인코드'		,type: 'string'},
				 {name: 'BUDG_YYYYMM'		,text: '예산년월'		,type: 'string'}
		]
	});
	
	Unilite.defineModel('Afb130ukrModel2', {
		
	    fields: [{name: 'CHOICE'			,text: '선택' 		,type: 'string'},
				 {name: 'ACCNT'				,text: '코드' 		,type: 'string'},
				 {name: 'ACCNT_NAME'		,text: '계정과목' 		,type: 'string'},
				 {name: 'BUDG_TOT_I'		,text: '이월가능예산' 	,type: 'uniPrice'},
				 {name: 'IWALL_YYYYMM'		,text: '이월년월' 		,type: 'string', allowBlank: false, convert:monthFormat},
				 {name: 'BUDG_AMT_I'		,text: '이월예산' 		,type: 'uniPrice', allowBlank: false}
				 
		]
	});		
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('afb130ukrdirectMasterStore1',{
			model: 'Afb130ukrModel1',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,		// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy,
            loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			},
			saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
	
				var toCreate = this.getNewRecords();
	       		var toUpdate = this.getUpdatedRecords();        		
	       		var toDelete = this.getRemovedRecords();
	       		var list = [].concat(toUpdate, toCreate);
	       		console.log("inValidRecords : ", inValidRecs);
				console.log("list:", list);
				console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
				
				//1. 마스터 정보 파라미터 구성
				var paramMaster= panelSearch.getValues();	//syncAll 수정
				
				if(inValidRecs.length == 0) {
					config = {
						params: [paramMaster],
						
						success: function(batch, option) {
							//2.마스터 정보(Server 측 처리 시 가공)
							/*var master = batch.operations[0].getResultSet();
							panelSearch.setValue("ORDER_NUM", master.ORDER_NUM);*/
							//3.기타 처리
							panelSearch.getForm().wasDirty = false;
							panelSearch.resetDirtyStatus();
							console.log("set was dirty to false");
							UniAppManager.setToolbarButtons('save', false);		
						} 
					};
					this.syncAllDirect(config);
				} else {
	                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
	});
	
	var directMasterStore2 = Unilite.createStore('afb130ukrdirectMasterStore2',{
			model: 'Afb130ukrModel2',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'afb130ukrService.selectList2'                	
                }
            },
            loadStoreRecords : function()	{
				var param= otherSearch.getValues();
				var BUDG_YYYYMM_PLUS = UniDate.add(panelSearch.getValue('BUDG_YYYYMM'), {months:+1}) 
				BUDG_YYYYMM_PLUS = UniDate.getDbDateStr(BUDG_YYYYMM_PLUS)										//날짜형식 YYYYMMDD로 변환
				BUDG_YYYYMM_PLUS = BUDG_YYYYMM_PLUS.substring(0,6)												//날짜형식 YYYYMM으로 자르기
				param.BUDG_YYYYMM_PLUS = BUDG_YYYYMM_PLUS
				console.log( param );
				this.load({
					params : param
				});
			}
	});	

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
    var panelSearch = Unilite.createSearchPanel('searchForm', {          
		title: '검색조건',         
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
			title: '기본정보',   
			itemId: 'search_panel1',
			layout : {type : 'vbox', align : 'stretch'},
	    	items : [{
	    		xtype:'container',
	    		layout : {type : 'uniTable', columns : 1},
	    		items:[{ 
	    			fieldLabel: '예산년월',
			        xtype: 'uniMonthfield',	
			        value: new Date().getFullYear(),
			        name: 'BUDG_YYYYMM',
			        allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('BUDG_YYYYMM', newValue);
							UniAppManager.app.fnSetStDate(newValue);
							UniAppManager.app.fnSetToDate(newValue);
						}
					}
		        },
				Unilite.popup('DEPT',{
				        fieldLabel: '부서',
			        	allowBlank: false,
					    valueFieldName:'DEPT_CODE',
					    textFieldName:'DEPT_NAME',
				        //validateBlank:false,
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
								panelResult.setValue('DEPT_CODE', '');
								panelSearch.setValue('DEPT_NAME', '');
								panelSearch.setValue('DEPT_NAME', '');
							},
							specialKey: function(elm, e){
			                    if (e.getKey() == e.ENTER) {
			                    	UniAppManager.app.onQueryButtonDown();  
			                	}
			                }
						}
			    }),{ 
	    			fieldLabel: '당기시작년월',
	    			name:'ST_DATE',
					xtype: 'uniTextfield',
					holdable:'hold',
					hidden: true,
					width: 200
				},{ 
	    			fieldLabel: '당기종료년월',
	    			name:'TO_DATE',
					xtype: 'uniMonthfield',
					holdable:'hold',
					hidden: true,
					width: 200
				}]	
			}]
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
		          		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
		        	}
					alert(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
			fieldLabel: '예산년월',
	        xtype: 'uniMonthfield',	
	        value: new Date().getFullYear(),
	        name: 'BUDG_YYYYMM',
	        allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('BUDG_YYYYMM', newValue);
				}
			}
        },
		Unilite.popup('DEPT',{
		        fieldLabel: '부서',
		        allowBlank: false,
			    valueFieldName:'DEPT_CODE',
			    textFieldName:'DEPT_NAME',
		        //validateBlank:false,
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
						panelSearch.setValue('DEPT_CODE', '');
						panelResult.setValue('DEPT_NAME', '');
						panelResult.setValue('DEPT_NAME', '');
					},
					specialKey: function(elm, e){
	                    if (e.getKey() == e.ENTER) {
	                    	UniAppManager.app.onQueryButtonDown();  
	                	}
	                }
				}
	    })],	
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
		          		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
		        	}
					alert(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});
    
    var otherSearch = Unilite.createSearchForm('otherorderForm', {		// 예산 참조
    	layout : {type : 'uniTable', columns : 2},
        items:[{ 
			fieldLabel: '예산년월',
	        xtype: 'uniMonthfield',	
	        id: 'BUDG_YYYYMM_ID',
	        value: new Date().getFullYear(),
	        name: 'BUDG_YYYYMM',
	        allowBlank: false
        },
		Unilite.popup('DEPT', { 
			fieldLabel: '부서',
	        id: 'DEPT_CODE_ID',
		    valueFieldName:'DEPT_CODE',
		    textFieldName:'DEPT_NAME',
	        allowBlank: false
		}),
		Unilite.popup('ACCNT',{ 
		    	fieldLabel: '계정과목', 
		    	valueFieldName: 'ACCOUNT_CODE_FR',
				textFieldName: 'ACCOUNT_NAME_FR',
			    extParam: {'ADD_QUERY': "SLIP_SW = 'Y' AND BUDG_YN = 'Y' AND GROUP_YN = 'N'"}
		}),   	
		Unilite.popup('ACCNT',{ 
				fieldLabel: '~', 
				padding: '1 1 1 -75',
				valueFieldName: 'ACCOUNT_CODE_TO',
				textFieldName: 'ACCOUNT_NAME_TO',
			    extParam: {'ADD_QUERY': "SLIP_SW = 'Y' AND BUDG_YN = 'Y' AND GROUP_YN = 'N'"}
		}),{ 
			fieldLabel: '당기시작년월',
			name:'ST_DATE',
			xtype: 'uniTextfield',
			holdable:'hold',
			hidden: true,
			width: 200
		},{ 
			fieldLabel: '당기종료년월',
			name:'TO_DATE',
			xtype: 'uniMonthfield',
			holdable:'hold',
			hidden: true,
			width: 200
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
		          		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
		        	}
					alert(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});
   
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('afb130ukrGrid1', {
    	// for tab 
    	region: 'center',
//    	title: '예산이월',
        layout : 'fit',
    	store: directMasterStore,
    	uniOpt:{
			useMultipleSorting	: true,			 
    		useLiveSearch		: false,			
    		onLoadSelectFirst	: false,		
    		dblClickToEdit		: false,		
    		useGroupSummary		: true,			
			useContextMenu		: false,		
			useRowNumberer		: true,			
			expandLastColumn	: false,		
			useRowContext		: false,	// rink 항목이 있을경우만 true			
			filter: {
				useFilter	: true,		
				autoCreate	: true		
			}
		},
        tbar: [{
			xtype: 'splitbutton',
           	itemId:'orderTool',
			text: '참조...',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'MoveReleaseBtn',
					text: '예산 참조',
					handler: function() {
						openotherWindow();
					}
				}]
			})
		}],	
    	features: [{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           {id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [{ dataIndex: 'ACCNT'				 	,		width: 133, align: 'center' },       			
        		   { dataIndex: 'ACCNT_NAME'		 	,		width: 266},       			
        		   { dataIndex: 'IWALL_YYYYMM'		 	,		width: 153, align: 'center'},       			
        		   { dataIndex: 'IWALL_AMT_I'		 	,		width: 133},       			
        		   { dataIndex: 'IWALL_DATE'		 	,		width: 153},       			
        		   { dataIndex: 'USER_CODE'			 	,		width: 100, hidden: true},       			
        		   { dataIndex: 'USER_NAME'			 	,		width: 100}        		          			
        ],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {	
	        	if(!e.record.phantom) {                     
	        		return false;                                               
	        	} else {                                   
	        		return false;                                               
	        	}                                          
	        }
		},
		setEstiData: function(record) {						// 이동출고참조 셋팅
	   		var grdRecord = this.getSelectedRecord();
			grdRecord.set('ACCNT'			, record['ACCNT']);
			grdRecord.set('ACCNT_NAME'		, record['ACCNT_NAME']);
			grdRecord.set('DEPT_CODE'		, panelSearch.getValue('DEPT_CODE'));
			grdRecord.set('DEPT_NAME'		, panelSearch.getValue('DEPT_NAME'));
			grdRecord.set('IWALL_YYYYMM'	, record['IWALL_YYYYMM']);
			grdRecord.set('BUDG_YYYYMM'		, UniDate.getDbDateStr(panelSearch.getValue('BUDG_YYYYMM')));
			grdRecord.set('IWALL_AMT_I'		, record['BUDG_AMT_I']);
			grdRecord.set('IWALL_DATE'		, UniDate.get('today'));
			grdRecord.set('USER_CODE'		, chargeInfoList[0].CHARGE_CODE);
			grdRecord.set('USER_NAME'		, chargeInfoList[0].CHARGE_NAME);
		}
    });
    
    function openotherWindow() {    	//편성예산 참조	
  		if(!UniAppManager.app.checkForNewDetail()) return false;
  		otherSearch.setValue('BUDG_YYYYMM', panelSearch.getValue('BUDG_YYYYMM'));
  		otherSearch.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
  		otherSearch.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME')); 	
  		Ext.getCmp('BUDG_YYYYMM_ID').setReadOnly(true);
  		Ext.getCmp('DEPT_CODE_ID').setReadOnly(true);
  		directMasterStore2.loadStoreRecords();
  		
		if(!otherWindow) {
			otherWindow = Ext.create('widget.uniDetailWindow', {
                title: '예산참조',
                width: 1000,				                
                height: 650,
                layout:{type:'vbox', align:'stretch'},
                
                items: [otherSearch, otherGrid],
                tbar:  ['->',
					{	itemId : 'saveBtn',
						text: '조회',
						handler: function() {
							directMasterStore2.loadStoreRecords();
						},
						disabled: false
					},{	itemId : 'confirmBtn',
						text: '적용',
						handler: function() {
							otherGrid.returnData();
						},
						disabled: false
					},{	itemId : 'confirmCloseBtn',
						text: '적용 후 닫기',
						handler: function() {
							var isClose = otherGrid.returnData();
							if(isClose) { 
								otherWindow.hide();
								UniAppManager.setToolbarButtons('reset', true)
							}
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							otherWindow.hide();
							UniAppManager.setToolbarButtons('reset', true)
						},
						disabled: false
					}
				],
                listeners : {
                	beforehide: function(me, eOpt)	{
                		otherSearch.clearForm();
                		otherGrid.reset();
                	},
                	beforeclose: function(panel, eOpts) {
						otherSearch.clearForm();
                		otherGrid.reset();
                	},
                	beforeshow: function (me, eOpts)	{
				  		otherSearch.setValue('BUDG_YYYYMM', panelSearch.getValue('BUDG_YYYYMM'));
				  		otherSearch.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
				  		otherSearch.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME')); 
				  		Ext.getCmp('BUDG_YYYYMM_ID').setReadOnly(true);
				  		Ext.getCmp('DEPT_CODE_ID').setReadOnly(true);	
				  		directMasterStore2.loadStoreRecords();
        			}
                }
			})
		}
		otherWindow.show();
		otherWindow.center();
    }
    
    var otherGrid = Unilite.createGrid('afb130ukrGrid2', {
    	// for tab 
    	title: '예산참조',
    	layout : 'fit',
    	selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }), 
    	store: directMasterStore2,
    	uniOpt:{						
			useMultipleSorting	: true,			
		    useLiveSearch		: false,			
		    onLoadSelectFirst	: false,				
		    dblClickToEdit		: true,			
		    useGroupSummary		: false,			
			useContextMenu		: false,		
			useRowNumberer		: true,		
			expandLastColumn	: false,			
			useRowContext		: false,		
		    filter: {					
				useFilter		: false,	
				autoCreate		: false	
			}
        },
    	features: [{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           {id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [//{ dataIndex: 'CHOICE'				, 		width: 33 },       			
        		   { dataIndex: 'ACCNT'					, 		width: 146, align: 'center', editable: false},       			
        		   { dataIndex: 'ACCNT_NAME'			, 		width: 266, editable: false},       			
        		   { dataIndex: 'BUDG_TOT_I'			, 		width: 186, editable: false},       			
        		   { dataIndex: 'IWALL_YYYYMM'			, 		width: 166, align: 'center'},       			
        		   { dataIndex: 'BUDG_AMT_I'			, 		width: 186}   
        ],
       	returnData: function()	{
			//masterGrid.reset();
       		var rv = true;
       		var inValidRecs = this.getStore().getInvalidRecords();
       		if(inValidRecs.length == 0) {
	       		var records = this.getSelectedRecords();
	       		Ext.each(records, function(record,i) {	
	       			if(Ext.isEmpty(record.get("IWALL_YYYYMM")))	{
	       				Unilite.messageBox("이월년월을 입력하세요.");
	       				inValidRecs.push(record);
	       			} 
					if(Ext.isEmpty(record.get("BUDG_AMT_I")))	{
						Unilite.messageBox("이월예싼을 입력하세요.");
	       				inValidRecs.push(record);
	       			} 
			    }); 
			    if(inValidRecs.length == 0) {
		       		Ext.each(records, function(record,i) {	
		       			
			       		UniAppManager.app.onNewDataButtonDown();
			       		masterGrid.setEstiData(record.data);		
	       			
				    }); 
					this.getStore().remove(records);
			    }
       		} 
			if(inValidRecs.length > 0) {
				rv = false;
                //this.uniSelectInvalidColumnAndAlert(inValidRecs);  // 팝업이 닫힘
			}
			return rv;
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
		id  : 'afb130ukrApp',
		fnInitBinding : function() {
			var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('BUDG_YYYYMM');
			panelSearch.setValue('BUDG_YYYYMM', UniDate.get('today'));
			panelResult.setValue('BUDG_YYYYMM', UniDate.get('today'));
			panelSearch.setValue('ST_DATE',getStDt[0].STDT.substring(0, 4));
			panelSearch.setValue('TO_DATE',getToDt[0].STDT.substring(0, 6));
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
		},
		onQueryButtonDown : function()	{			
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}	
			directMasterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons(['reset', 'delete'], true);
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			directMasterStore.saveStore();
		},
		onResetButtonDown: function() {
			masterGrid.reset();
			directMasterStore.clearData();
			Ext.getCmp('searchForm').clearForm();
			Ext.getCmp('resultForm').clearForm();
			this.fnInitBinding();
		},
		onNewDataButtonDown: function()	{		// 행추가 
			var r = {
				'BUDG_YYYYMM' 	: '',
				'DEPT_CODE' 	: '',
				'DEPT_NAME' 	: '',
				'BUDG_CODE' 	: '',
				'BUDG_NAME' 	: '',
				'IWALL_AMT_I' 	: '',
				'IWALL_YYYYMM' 	: '',
				'IWALL_DATE' 	: UniDate.get('today')
			}
			masterGrid.createRow(r);
		},
		onDeleteDataButtonDown: function() {	// 행삭제 버튼
			 if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
        checkForNewDetail: function() { 
        	if(panelSearch.setAllFieldsReadOnly(true) == false) {
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false) {
				return false;
			}	
			return panelSearch.setAllFieldsReadOnly(true);
			return panelResult.setAllFieldsReadOnly(true);
        },
        fnSetStDate:function(newValue) {
        	if(newValue == null){
				return false;
			}else{
		    	if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6))){
					panelSearch.setValue('ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1);
					otherSearch.setValue('ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1);
				}else{
					panelSearch.setValue('ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4));
					otherSearch.setValue('ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4));
				}
			}
        },
        fnSetToDate:function(newValue) {
        	if(newValue == null){
				return false;
			}else{
	    		panelSearch.setValue('TO_DATE', getToDt[0].STDT.substring(0, 6));
	    		otherSearch.setValue('TO_DATE', getToDt[0].STDT.substring(0, 6));
			}
        }
	});
	
	Unilite.createValidator('validator01', {
		store: directMasterStore2,
		grid: otherGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "IWALL_YYYYMM" :		// 이월년월
					
					if(newValue.length < 5 && newValue.length > 7 )	{
						rv = 'YYYY.MM(년.월) 형식으로 입력해 주세요.';	
					}
					var checkValue = monthFormat(newValue).replace(".","");
					if(record.get('BUDG_YYYYMM').substring(0, 4) > checkValue.substring(0, 4) || record.get('BUDG_YYYYMM').substring(0, 4) < checkValue.substring(0, 4)) {
						Unilite.messageBox( "이월년월은 예산년도의 예산년월 사이에서 입력하십시오.")
						rv = false;
					} 
					if(record.get('BUDG_YYYYMM').substring(4, 6) >= checkValue.substring(4,6) ) {
						Unilite.messageBox( "이월년월이 예산년월과 같거나 또는 예산년월보다 이전일 수 없습니다.")
						rv = false;
					} 
				break;
				
				case "BUDG_AMT_I" :			// 이월예산
					if(record.get('BUDG_TOT_I') < newValue) {
						Unilite.messageBox( "이월예산금액이 이월가능금액보다 클 수 없습니다.");
						rv = false;
						break;
					}
				break;
			}
			return rv;
		}
	})
};


</script>
