<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agj206ukr"  >
	<t:ExtComboStore comboType="BOR120" /><!-- 사업장    -->  
	<t:ExtComboStore comboType="AU" comboCode="A011" />   
	<t:ExtComboStore comboType="AU" comboCode="A002" />        
	<t:ExtComboStore comboType="AU" comboCode="A022" /><!-- 매입증빙유형-->
	<t:ExtComboStore comboType="AU" comboCode="B004" />     
	<t:ExtComboStore comboType="AU" comboCode="A003" />  
	<t:ExtComboStore comboType="AU" comboCode="A002" />  
	<t:ExtComboStore comboType="AU" comboCode="A014" /><!--승인상태-->
	<t:ExtComboStore comboType="AU" comboCode="A149" />
	<t:ExtComboStore comboType="AU" comboCode="A070" />
</t:appConfig>
<script type="text/javascript" >

var csINPUT_DIVI	 = "2";	//1:결의전표/2:결의전표(전표번호별)
var csSLIP_TYPE      = "1";	//1:회계전표/2:결의전표
var csSLIP_TYPE_NAME = "회계전표";
var csINPUT_PATH	 = 'Z0';
var csCLOSING_INPUT_PATH  = "Z4";
var tab;
var postitWindow;		// 각주팝업
var creditNoWin;			// 신용카드번호 & 현금영수증 팝업
var comCodeWin ;		// A070 증빙유형팝업
var creditWIn;			// 신용카드팝업
var printWin;					//전표출력팝업
var foreignWindow;				//외화금액입력

function appMain() {
	var gsSlipNum 		=""; // 링크로 넘어오는 Slip_NUM
	var gsProcessPgmId	=""; // Store 에서 링크로 넘어온 Data 값 체크 하기 위해 전역변수 사용
	
var baseInfo = {
	gsBillDivCode   : '${gsBillDivCode}',
	gsLocalMoney    : '${gsLocalMoney}',
	gsAmtPoint		 : ${gsAmtPoint},			// 외화금액 format
	inDeptCodeBlankYN   : '${inDeptCodeBlankYN}'  // 귀속부서 팝업창 오픈시 검색어 공백 처리(A165, 75)
}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read : 'agj200ukrService.selectList'
		 ,update : 'agj200ukrService.update'
		 ,create : 'agj200ukrService.insert'
		 ,destroy:'agj200ukrService.delete'
		 ,syncAll:'agj206ukrService.saveAll'
		}
	});
	<%@include file="./accntGridConfig.jsp" %> 
	/**
	 * 일반전표 Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('agj206ukrMasterStore1',getStoreConfig());
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
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
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',   			
	    	items:[
	    		{	    
					fieldLabel: '전표일',
					xtype: 'uniDatefield',
		            name: 'AC_DATE',
		            value: UniDate.get('today'),
				 	allowBlank:false,
				 	listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('AC_DATE', newValue);
						}
					}
				},{	    
					fieldLabel: '전표번호',
					xtype: 'uniNumberfield',
		            name: 'SLIP_NUM',		           
				 	allowBlank:false,
				 	value:1,
				 	listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('SLIP_NUM', newValue);
						}
					}
				},{
				    fieldLabel: '입력경로',
					name: 'INPUT_PATH',          
					xtype: 'uniCombobox' ,
					comboType: 'AU',
					comboCode: 'A011',
					readOnly:true,
					value:csINPUT_PATH,
				 	listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('INPUT_PATH', newValue);
						}
					}
				},{
					fieldLabel: '승인여부',
					name: 'AP_STS' ,          
					xtype: 'uniCombobox' ,
					comboType: 'AU',
					comboCode: 'A014' ,
					hidden:true,
					readOnly:true,
				 	listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('AP_STS', newValue);
						}
					}
				}
			]
		}]
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 5},
		padding:0,
		defaults:{labelWidth:98},
		border:true,
		items: [{	xtype:'displayfield',
					hideLabel:true,
					value:'<div style="color:blue;font-weight:bold;padding-left:5px;">[조회]</div>',
					width:50
				},
	    		
	    		{	    
					fieldLabel: '전표일',
					xtype: 'uniDatefield',
		            name: 'AC_DATE',
		            value: UniDate.get('today'),
				 	allowBlank:false,
				 	labelWidth:60,
				 	width:250,
				 	listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('AC_DATE', newValue);
						}
					}
				},{	    
					fieldLabel: '전표번호',
					xtype: 'uniNumberfield',
		            name: 'SLIP_NUM',		           
				 	allowBlank:false,
				 	value:1,
				 	listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('SLIP_NUM', newValue);
						}
					}
				},{
				    fieldLabel: '입력경로',
					name: 'INPUT_PATH',          
					xtype: 'uniCombobox' ,
					comboType: 'AU',
					comboCode: 'A011',
					readOnly:true,
					value:csINPUT_PATH,
				 	listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('INPUT_PATH', newValue);
						}
					}
				},{
					fieldLabel: '승인여부',
					name: 'AP_STS' ,          
					xtype: 'uniCombobox' ,
					comboType: 'AU',
					comboCode: 'A014' ,
					hidden:true,
					readOnly:true,
				 	listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('AP_STS', newValue);
						}
					}
				}
		]
	});
	//createSearchForm
	var slipForm =  Unilite.createSearchForm('agj206ukrSlipForm',  {		
        itemId: 'agj206ukrSlipForm',
		masterGrid: masterGrid1,
		height: 60,
		disabled: false,
		trackResetOnLoad:false,
		border: true,
		padding: 0,
		layout: {
			type: 'uniTable', 
			columns:4
		},
		defaults:{
			width: 250,
			labelWidth: 100
		},
		items:[ {	xtype:'displayfield',
					hideLable:true,
					value:'<div style="color:blue;font-weight:bold;padding-left:5px;">[입력]</div>',
					width:50,
					tdAttrs:{width:50}
				},
	    		{
					fieldLabel: '사업장',
					name: 'DIV_CODE',       
					xtype: 'uniCombobox' ,
					comboType: 'BOR120',
					labelWidth:60,
					value:UserInfo.divCode
			    },{
			    	xtype:'container',
			    	defaultType:'uniTextfield',
			    	layout:{type:'hbox', align:'stretch'},
			    	items:[
			    		{
			    	  	 	fieldLabel:'결의부서',
						 	name : 'DEPT_CODE',
						 	readOnly:true,
							value:UserInfo.deptCode,
							width:160,
							labelWidth: 100
					    },{
							fieldLabel: '결의부서명',
						    name:'DEPT_NAME',
						 	value: UserInfo.deptName,
						 	readOnly: true,
						 	hideLabel:true,
						 	width:90
						}
					]
			    },Unilite.popup('ACCNT_PRSN', {
	    	  	 	fieldLabel: '입력자ID',
	    	  	 	valueFieldName:'CHARGE_CODE',
	    	  	 	textFieldName:'CHARGE_NAME',
				 	allowBlank:false,
	    	  	 	textFieldWidth:150,
				 	readOnly: true
				}),{	
					xtype:'displayfield',
					hideLable:true,
					value:'<div style="color:blue;font-weight:bold;padding-left:5px;">&nbsp;</div>',
					width:50,
					tdAttrs:{width:50}
				},{	    
					fieldLabel: '전표일',
					xtype: 'uniDatefield',
		            name: 'AC_DATE',
		            value: UniDate.get('today'),
				 	allowBlank:false,
				 	labelWidth:60,
				 	listeners:{
				 		change:function(field, newValue, oldValue, eOpt)	{
							if(!Ext.isEmpty(newValue) && Ext.isDate(newValue))	{
					 			Ext.getBody().mask();
					 			var sDate = UniDate.getDbDateStr(newValue);
					 			agj200ukrService.getSlipNum({'AC_DATE':UniDate.getDbDateStr(newValue)}, function(provider, result ) {
					 				Ext.getBody().unmask();
					 				slipForm.setValue('SLIP_NUM', provider.SLIP_NUM);
							 			var data = directMasterStore1.getData();
							 			Ext.each(data.items, function(item, idx){
							 				item.set("AC_DATE", sDate)
							 				item.set("SLIP_NUM", provider.SLIP_NUM)
							 				if(item.phantom ) {
							 					item.set('OLD_SLIP_NUM', provider.SLIP_NUM);
							 				}
							 			});
					 			})
							}
				 			
				 		}
				 	}
				},{	    
					fieldLabel: '전표번호',
					xtype: 'uniNumberfield',
		            name: 'SLIP_NUM',		           
				 	allowBlank:false,
				 	value:'1',
					listeners:{
						change:function(field, newValue, oldValue, eOpts)	{
				 			
				 			var value = newValue;
				 			var sDate = UniDate.getDbDateStr(slipForm.getValue("AC_DATE"));
				 			if(!Ext.isEmpty(value) && Ext.isDate(slipForm.getValue("AC_DATE")))	{
					 			var param = {
									'GUBUN': csSLIP_TYPE,
									'SDATE': sDate,
									'SNUM':value
								}
								Ext.getBody().mask();
								accntCommonService.fnGetExistSlipNum(param, function(provider, response) {	
									var chk =false;
									if(provider.CNT != 0)	{
										chk = true;
										//alert(Msg.sMA0306);
									}
									agj100ukrService.getSlipNum({'AC_DATE':sDate}, function(provider, result ) {
										var bChange = chk;
										if(!bChange && value != provider.SLIP_NUM)  {
											//if(confirm("당일 최종 전표번호는 "+(provider.SLIP_NUM-1)+"입니다. "+(provider.SLIP_NUM)+"번으로 바꾸시겠습니까?")) {
												bChange = true;
											//} else {
											//	Ext.getBody().unmask();
											//	return;
											//}
										}
										if(bChange)	{
											slipForm.setValue("SLIP_NUM", provider.SLIP_NUM);	
									 		var data = directMasterStore1.getData();
								 			Ext.each(data.items, function(item, idx){
								 				
								 				item.set("SLIP_NUM", provider.SLIP_NUM)
								 				if(item.phantom ) {
								 					item.set('OLD_SLIP_NUM', provider.SLIP_NUM);
								 				}
								 			});
										}
							 			Ext.getBody().unmask();
					 				});
									
									
						 		});
				 			}
				 		}
					}
				},{
					fieldLabel: '전표구분',
					name: 'SLIP_DIVI' ,          
					xtype: 'uniCombobox' ,
					comboType: 'AU',
					comboCode: 'A002' ,
					allowBlank: false,
					value :'3',
					listeners:{
						change:function(field, newValue, oldValue)	{
							if(cashInfo && !Ext.isDefined(cashInfo.ACCNT) && (newValue == "1" || newValue =="2"))	{
								alert("현금계정이 없어 입금, 출금을 선택 할 수 없습니다.");
								field.setValue(oldValue);
								return false;
							}
							return true;
						}
					
					}
				},{
				    fieldLabel: '입력경로',
					name: 'INPUT_PATH',          
					xtype: 'uniCombobox' ,
					comboType: 'AU',
					comboCode: 'A011',
					readOnly:true,
					hidden:true,
					value:csINPUT_PATH,
					listeners:{
						specialkey: function(elm, e){
							lastFieldSpacialKey(elm, e)
						}
					}
				}
		]
	});
	
	function lastFieldSpacialKey(elm, e)	{
		if( e.getKey() == Ext.event.Event.ENTER)	{
			if(elm.isExpanded)	{
    			var picker = elm.getPicker();
    			if(picker)	{
    				var view = picker.selectionModel.view;
    				if(view && view.highlightItem)	{
    					picker.select(view.highlightItem);
    				}
    			}
			}else {
				var grid = UniAppManager.app.getActiveGrid();
				var record = grid.getStore().getAt(0);
				if(record)	{
					e.stopEvent();
					grid.editingPlugin.startEdit(record,grid.getColumn('SLIP_NUM'))
				}else {
					UniAppManager.app.onNewDataButtonDown();
				}
			}
		}
		
	}
    /**
     * 일발전표 Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid1 = Unilite.createGrid('agj206ukrGrid1', getGridConfig(directMasterStore1,'agj206ukrGrid1','agj206ukrDetailForm1', 0.65, false, '4'));
    
    var detailForm1 = Unilite.createForm('agj206ukrDetailForm1',  getAcFormConfig('agj206ukrDetailForm1',masterGrid1 ));
	
	//차대변 구분 전표
<%@include file="./agjSlip.jsp" %> 
	
	var centerContainer = {
		region:'center',
		xtype:'container',
		layout:{type:'vbox', align:'stretch'},
		items:[
			slipForm,
			masterGrid1,
			detailForm1,
			slipContainer
		]
	}


    Unilite.Main({
		borderItems:[ 
			panelSearch,
			{
	         	region:'center',
	         	layout: 'border',
	         	border: false,
	         	
				defaults:{
					style:{left:'1px'}
				},
	         	items:[
	           		centerContainer, panelResult
	         	]	
	      	}
	  	],
		id  : 'agj206ukrApp',
		autoButtonControl : false,
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons([ 'newData', 'reset','prev', 'next', 'deleteAll'],true);
			
			slipForm.setValue('CHARGE_CODE','${chargeCode}');
			slipForm.setValue('CHARGE_NAME','${chargeName}');	
			
			slipForm.setValue('AC_DATE','${initAcDate}');
			slipForm.setValue('SLIP_NUM','${initSlipNum}');
			if(Ext.isEmpty('${chargeCode}'))	{
            	alert('회계담당자정보가 없습니다');
            }
            
            UniAppManager.setToolbarButtons([ 'newData','deleteAll'],false);
			directMasterStore1.uniOpt.deletable =  false;
			detailForm1.setReadOnly(true);
			this.processParams(params);
		},
		onQueryButtonDown : function()	{
			directMasterStore1.loadStoreRecords(null, function(provider, response){
					if(!Ext.isEmpty(provider) && provider.length > 0)	{
						
						slipForm.getForm().setValues(provider[0].getData());
						panelSearch.setValue("INPUT_PATH", provider[0].get("INPUT_PATH"));
						panelResult.setValue("INPUT_PATH", provider[0].get("INPUT_PATH"));
					}
			});
			slipForm.setValue("AC_DATE", panelSearch.getValue("AC_DATE"))
			slipForm.setValue("SLIP_NUM", panelSearch.getValue("SLIP_NUM"))
			
		},
		onNewDataButtonDown : function()	{
			if(!this.toolbar.down("#newData").isDisabled())	{
				this.fnAddSlipRecord();
				UniAppManager.app.setSearchReadOnly(true);
			}
		},	
		onSaveDataButtonDown: function (config) {
			
			directMasterStore1.saveStore(config);
			
			
		},
		onDeleteDataButtonDown : function()	{
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid1.deleteSelectedRow();
			}
		},
		onDeleteAllButtonDown : function()	{
			if(slipForm.getValue("AP_STS") != "2")	{
				if(confirm('전체 삭제 하시겠습니까?')) {
					var cnt = directMasterStore1.count();
					for(var i=0 ; i < cnt ; i++)	{
						directMasterStore1.removeAt(0);
					}
					detailForm1.down('#formFieldArea1').removeAll();
				}
			}else {
				alert("승인된 전표입니다.");
			}
		},
		onResetButtonDown:function() {
			gsSlipNum = "";
			gsProcessPgmId ="";
			
			panelSearch.reset();						
			masterGrid1.reset();
			masterGrid1.getStore().commitChanges();
			slipForm.unmask();
			slipForm.getForm().reset();	
			
			tempEditMode = true;
			detailForm1.down('#formFieldArea1').removeAll();	
			slipGrid1.reset();
	 		slipGrid2.reset();
	 		
	 		UniAppManager.app.setSearchReadOnly(false);
	 		slipForm.setValue('CHARGE_CODE','${chargeCode}');
			slipForm.setValue('CHARGE_NAME','${chargeName}');	
			
			slipForm.setValue('AC_DATE','${initAcDate}');
			slipForm.setValue('SLIP_NUM','${initSlipNum}');
			UniAppManager.setToolbarButtons(['prev', 'next'],true);
			UniAppManager.setToolbarButtons('save',false);
			
			
		},
		onDetailButtonDown:function() {
			
		},
		onPrevDataButtonDown:  function()	{
			if(directMasterStore1.isDirty())	{
					if(confirm(Msg.sMB061))	{
						this.onSaveDataButtonDown();
					} else {
						this.rejectSave();
					}
				return;
			}
			if(slipForm.isValid() )	{
				Ext.getBody().mask();
				var param = slipForm.getValues();
				param.INPUT_PATH = panelSearch.getValue('INPUT_PATH');
				
				agj205ukrService.getPrevSlipNum(param, function(provider, response){
					Ext.getBody().unmask();
					if(provider)	{
						panelSearch.setValue('AC_DATE', provider.AC_DATE);
						panelSearch.setValue('SLIP_NUM', provider.SLIP_NUM);
						panelSearch.setValue('INPUT_PATH', "");
						
						panelResult.setValue('AC_DATE', provider.AC_DATE);
						panelResult.setValue('SLIP_NUM', provider.SLIP_NUM);
						panelResult.setValue('INPUT_PATH', "");
						
						UniAppManager.app.onQueryButtonDown()
					}
				})
			}
		},
		onNextDataButtonDown:  function()	{
			if(directMasterStore1.isDirty())	{
					if(confirm(Msg.sMB061))	{
						this.onSaveDataButtonDown();
					} else {
						this.rejectSave();
					}
				return;
			}
			if(slipForm.isValid())	{
				Ext.getBody().mask();
				var param = slipForm.getValues();
				param.INPUT_PATH = panelSearch.getValue('INPUT_PATH');
				
				agj205ukrService.getNextSlipNum(param, function(provider, response){
					Ext.getBody().unmask();
					if(provider)	{
						panelSearch.setValue('AC_DATE', provider.AC_DATE);
						panelSearch.setValue('SLIP_NUM', provider.SLIP_NUM);
						panelSearch.setValue('INPUT_PATH', "");
						
						panelResult.setValue('AC_DATE', provider.AC_DATE);
						panelResult.setValue('SLIP_NUM', provider.SLIP_NUM);
						panelResult.setValue('INPUT_PATH', "");
						UniAppManager.app.onQueryButtonDown()
					}
				})
			}
		},
		rejectSave: function()	{
			directMasterStore1.rejectChanges();
			UniAppManager.setToolbarButtons('save',false);
		}, 
		confirmSaveData: function()	{
			if(directMasterStore1.isDirty())	{
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown();
				} else {
					this.rejectSave();
				}
			}
        },
        setEditableGrid:function(sInputPath, btnReset )	{
			UniAppManager.setToolbarButtons([ 'newData','deleteAll'],false);
			directMasterStore1.uniOpt.deletable =  false;
			detailForm1.setReadOnly(true);
			  
        },
        isEditField:function(fieldName)	{
        	var r = false;
        	if(UniUtils.indexOf(fieldName, ['REMARK', 'DEPT_NAME', 'DIV_CODE']))	{
        		r = true;
        	}
        	return r;
        },
        //링크로 넘어오는 params 받는 부분 (Agj240skr)
        processParams: function(params) {},
        setSearchReadOnly:function(b, isOldData)	{
        	if(!isOldData)	{
        		slipForm.getField('AC_DATE').setReadOnly(b);
				slipForm.getField('SLIP_NUM').setReadOnly(b);
        	}
			slipForm.getField('DIV_CODE').setReadOnly(b);		
			slipForm.getField('SLIP_DIVI').setReadOnly(b);
			
        },
    	
    	setAccntInfo:function(record, detailForm)	{},
    	loadDataAccntInfo:function(rtnRecord, detailForm, provider)	{},
    	clearAccntInfo:function(record, detailForm){},
    	getActiveForm:function()	{
    		var form;
    		if(tab)	{
	    		var activeTab = tab.getActiveTab();
	    		var activeTabId = activeTab.getItemId();
				
				if(activeTabId == 'agjTab1' )	{
					form = detailForm1;
				}else {
					form = saleDetailForm;
				}
    		}else {
    			form = detailForm1
    		}
			return form
    	},
    	getActiveGrid:function()	{
    		var grid;
    		if(tab)	{
	    		var activeTab = tab.getActiveTab();
	    		var activeTabId = activeTab.getItemId();
				
				if(activeTabId == 'agjTab1' )	{
					grid = masterGrid1;
				}else {
					grid = masterGrid2;
				}
			}else {
				grid = masterGrid1;
			}
			
			return grid
    	},
		needNewSlipNum:function(grid, isAddRow)	{},
		fnAddSlipRecord:function(){},
		fnCopySlip: function()	{}
		,fnSetBillDate: function(record)	{},
		fnSetAcCode:function(record, acCode, acValue, acNameValue)	{},
		fnFindInputDivi:function(record)	{},
		fnGetProofKind:function(record, billType)	{},
		fnGetProofKindName:function(sBillType, sSaleDivi)	{},
		fnCheckPendYN: function(record, form)	{},
		fnChangeAcEssInput:function(record)	{},
		fnSetDefaultAcCodeI7:function(record, newValue)	{},

		fnCheckNoteAmt:function(grid, record, damt, dOldAmt)	{},
		fnSetTaxAmt:function(record, taxRate, proofKind, amt_i)	{},
		fnCalTaxAmt:function(record)	{},
		fnProofKindPopUp:function(record, newValue)	{},
		cbGetTaxAmt:function(taxRate,  record)	{},
		
		cbGetTaxAmtForSales:function(taxRate,  record)	{},
		cbGetExistsSlipNum:function(provider, fieldName, newValue, oldValue, record)	{}, 
		cbCheckNoteAmt: function (rtn, newAmt,  oldAmt, record, fidleName)	{},
		cbGetBillDivCode:function(billDivCode, record)	{
			record.set('BILL_DIV_CODE', billDivCode)
		}
	
	});	// Main
	
		Unilite.createValidator('validator01', {
		store : directMasterStore1,
		grid: masterGrid1,
		forms: {'formA:':detailForm1},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			if(oldValue == newValue)	{
				return true;
			}
			var rv = true;
			switch(fieldName)	{
				case 'DIV_CODE':
					UniAccnt.fnGetBillDivCode(UniAppManager.app.cbGetBillDivCode, record, newValue);
					break;
				
				default:
					break;
			}
			return rv;
			
		}
	}); // validator01
}; // main


</script>


