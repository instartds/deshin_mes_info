<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="afn100ukr"  >

	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->   
	<t:ExtComboStore comboType="AU" comboCode="A047" /> <!-- 어음구분 -->      
	<t:ExtComboStore comboType="AU" comboCode="A063" /> <!-- 어음상태 -->
	<t:ExtComboStore comboType="AU" comboCode="A057" /> <!-- 보관장소 -->
	<t:ExtComboStore comboType="AU" comboCode="A058" /> <!-- 어음종류 -->
	<t:ExtComboStore comboType="AU" comboCode="B064" /> <!--수취구분-->
	
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >


function appMain() {

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'afn100ukrService.selectList',
			update: 'afn100ukrService.updateDetail',
			syncAll: 'afn100ukrService.saveAll'
		}
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Afn100ukrModel', {		
	    fields: [{name: 'AC_CODE'			 	,text: '어음구분코드' 		,type: 'string'},			 	 	
				 {name: 'AC_CD'		    	 	,text: '어음구분' 			,type: 'string', comboType: 'AU', comboCode: 'A047'},			 	 	
				 {name: 'NOTE_NUM'	    	 	,text: '어음번호' 			,type: 'string'},			 	 	
				 {name: 'PUB_DATE'	    	 	,text: '발행일' 			,type: 'uniDate'},			 	 	
				 {name: 'EXP_DATE'	    	 	,text: '만기일' 			,type: 'uniDate'},			 	 	
				 {name: 'CUSTOM_CODE'		 	,text: '거래처코드' 		,type: 'string'},			 	 	
				 {name: 'CUSTOM_NAME'		 	,text: '거래처명' 			,type: 'string'},			 	 	
				 {name: 'OC_AMT_I'	    	 	,text: '금액' 			,type: 'uniPrice'},			 	 	
				 {name: 'J_AMT_I'			 	,text: '반제금액' 			,type: 'uniPrice'},
				 {name: 'BANK_CODE'	    	 	,text: '은행코드' 			,type: 'string'},			 	 	
				 {name: 'BANK_NAME'	    	 	,text: '은행명' 			,type: 'string'},				 			 	 	
				 {name: 'NOTE_STS'	    	 	,text: '어음상태' 			,type: 'string', comboType: 'AU', comboCode: 'A063'},			 	 	
				 {name: 'UPDATE_DB_USER'	 	,text: '수정자' 			,type: 'string'},			 	 	
				 {name: 'UPDATE_DB_TIME'	 	,text: '수정일' 			,type: 'uniDate'},			 	 	
				 {name: 'COMP_CODE'	    	 	,text: 'COMP_CODE' 		,type: 'string'},			 	 	
				 {name: 'PUB_MAN'	    	 	,text: 'PUB_MAN'	   	,type: 'string'},			 	 	
				 {name: 'ACCNT'	    	 		,text: 'ACCNT'	    	,type: 'string'},			 	 	
				 {name: 'ACCNT_NAME'	    	,text: 'ACCNT_NAME'	 	,type: 'string'},			 	 	
				 {name: 'NOTE_KEEP'	    	 	,text: 'NOTE_KEEP'	   	,type: 'string'},			 	 	
				 {name: 'CHECK1'	    	 	,text: 'CHECK1'	   		,type: 'string'},			 	 	
				 {name: 'CHECK2'	    	 	,text: 'CHECK2'	   		,type: 'string'},			 	 	
				 {name: 'AC_DATE'	    	 	,text: 'AC_DATE'	   	,type: 'uniDate'},			 	 	
				 {name: 'SLIP_NUM'	    	 	,text: 'SLIP_NUM'	   	,type: 'int'},			 	 	
				 {name: 'SLIP_SEQ'	    	 	,text: 'SLIP_SEQ'	   	,type: 'int'},			 	 	
				 {name: 'DC_DIVI'	    	 	,text: 'DC_DIVI'	   	,type: 'string'},			 	 	
				 {name: 'J_DATE'	    	 	,text: 'J_DATE'	   		,type: 'uniDate'},			 	 	
				 {name: 'J_NUM'	    	 		,text: 'J_NUM'	    	,type: 'string'},			 	 	
				 {name: 'J_SEQ'	    	 		,text: 'J_SEQ'	    	,type: 'int'},			 	 	
				 {name: 'RECEIPT_DIVI'	    	,text: 'RECEIPT_DIVI' 	,type: 'string'}
		]
	});		
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('afn100ukrMasterStore1',{
			model: 'Afn100ukrModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:false,		// 삭제 가능 여부 
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
				var toCreate = this.getNewRecords();
            	var toUpdate = this.getUpdatedRecords();
            	console.log("toUpdate",toUpdate);

            	var rv = true;
       	
            	if(inValidRecs.length == 0 )	{										
					config = {
						success: function(batch, option) {								
							panelResult.resetDirtyStatus();
							UniAppManager.setToolbarButtons('save', false);			
						 } 
					};					
					this.syncAllDirect(config);
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
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
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{
					fieldLabel: '어음구분'	,
					name:'AC_CD', 
					xtype: 'uniCombobox', 
					comboType:'AU',
					comboCode:'A047',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('AC_CD', newValue);
						}
					}
		    	},		    
			    	Unilite.popup('BANK',{
			    	fieldLabel: '은행',
//			    	validateBlank:false, 
					autoPopup   : true ,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('BANK_CODE', panelSearch.getValue('BANK_CODE'));
								panelResult.setValue('BANK_NAME', panelSearch.getValue('BANK_NAME'));
		                	},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('BANK_CODE', '');
							panelResult.setValue('BANK_NAME', '');
						}
					}
	//		    	textFieldWidth:170
			    }),{
					fieldLabel: '어음상태'	,
					name:'NOTE_STS', 
					xtype: 'uniCombobox', 
					comboType:'AU',
					comboCode:'A063',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('NOTE_STS', newValue);
						}
					}
		    	}, {
					fieldLabel: '어음번호'	,
					name:'NOTE_NUM', 
					xtype: 'uniTextfield',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('NOTE_NUM', newValue);
						}
					}
		    	},  
			        Unilite.popup('CUST',{
			        fieldLabel: '거래처',
					allowBlank:true,
					autoPopup:false,
					validateBlank:false,
					valueFieldName: 'CUSTOM_CODE1',
					textFieldName: 'CUSTOM_NAME1',
					listeners: {
								onValueFieldChange:function( elm, newValue, oldValue) {						
									panelResult.setValue('CUSTOM_CODE1', newValue);
									
									if(!Ext.isObject(oldValue)) {
										panelResult.setValue('CUSTOM_NAME1', '');
										panelSearch.setValue('CUSTOM_NAME1', '');
									}
								},
								onTextFieldChange:function( elm, newValue, oldValue) {
									panelResult.setValue('CUSTOM_NAME1', newValue);
									
									if(!Ext.isObject(oldValue)) {
										panelResult.setValue('CUSTOM_CODE1', '');
										panelSearch.setValue('CUSTOM_CODE1', '');
									}
								}
					}
				}),{
					fieldLabel: '수취구분'	,
					name:'RECEIPT_GUBUN', 
					xtype: 'uniCombobox', 
					comboType:'AU',
					comboCode:'B064',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('RECEIPT_GUBUN', newValue);
						},
						specialkey: function(elm, e){
		                    if (e.getKey() == e.ENTER) {
								UniAppManager.app.onQueryButtonDown();
		                    }	
		                }
					}
		    	}/*,{
					fieldLabel: '어음구분'	,
					name:'AC_CD2', 
					xtype: 'uniCombobox', 
					comboType:'AU',
					comboCode:'A047',
					readOnly: true
		    	}, 		    
			    	Unilite.popup('BANK',{
			    	fieldLabel: '지급은행',
//			    	validateBlank:false, 
			    	valueFieldName:'PAY_BANK_CODE',
			   	 	textFieldName:'PAY_PROG_WORK_NAME'
			    }),{
					fieldLabel: '수취구분'	,
					name:'RECEIPT_GUBUN2', 
					xtype: 'uniCombobox', 
					comboType:'AU',
					comboCode:'A064'
		    	}, {
		    		fieldLabel: '어음번호',
		    		name: 'NOTE_NUM2',
					readOnly: true		    		
		    	},   
			        Unilite.popup('CUST',{
			        fieldLabel: '거래처',
					readOnly: true,
					valueFieldName: 'CUSTOM_CODE',
					textFieldName: 'CUSTOM_NAME'
				}), {
		    		fieldLabel: '발행인',
		    		name: 'PUB_MAN'
		    	}, {
					fieldLabel: '발행일',
					name: 'PUB_DATE',
					xtype: 'uniDatefield'
				}, 
				Unilite.popup('ACCNT',{ 
					fieldLabel: '계정코드', 
					valueFieldName: 'ACCOUNT_CODE',
					textFieldName: 'ACCOUNT_NAME',
					readOnly: true
				}),{
					fieldLabel: '보관장소'	,
					name:'NOTE_KEEP', 
					xtype: 'uniCombobox', 
					comboType:'AU',
					comboCode:'A057'
		    	}, {
					fieldLabel: '만기일',
					name: 'EXP_DATE',
					xtype: 'uniDatefield'	
				}, {
					fieldLabel: '어음종류'	,
					name:'DC_DIVI', 
					xtype: 'uniCombobox', 
					comboType:'AU',
					comboCode:'A058'
					
		    	}, {
					fieldLabel: '어음상태'	,
					name:'NOTE_STS2', 
					xtype: 'uniCombobox', 
					comboType:'AU',
					comboCode:'A063'
					
		    	}, {
		    		fieldLabel: '배서인1',
		    		name: 'CHECK1'
		    	}, {
		    		fieldLabel: '배서인2',
		    		name: 'CHECK2'
		    	}, {
		    		fieldLabel: '금액',
		    		name: 'OC_AMT_I',
					readOnly: true,
		    		xtype: 'uniNumberfield'
		    	}, {
		    		fieldLabel: '반제금액',
		    		name: 'J_AMT_I',
		    		xtype: 'uniNumberfield',
					readOnly: true	
		    	}, {
		    		fieldLabel: '전표일',
		    		name: 'AC_DATE',
					readOnly: true,
					xtype: 'uniDatefield'    		
		    	}, {
		    		fieldLabel: '전표번호',
		    		name: 'SLIP_NUM',
					readOnly: true	    		
		    	}, {
		    		fieldLabel: '전표순번',
		    		name: 'SLIP_SEQ',
					readOnly: true   		
		    	}, {
		    		fieldLabel: '반제순번',
		    		name: 'J_SEQ',
					readOnly: true	    		
		    	}, {
		    		fieldLabel: '반제일',
		    		name: 'J_DATE',
					readOnly: true,
					xtype: 'uniDatefield'    		
		    	}, {
		    		fieldLabel: '반제번호',
		    		name: 'J_NUM',
					readOnly: true	    		
		    	}*/]		
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
		      		//this.mask();
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
		    	//this.unmask();
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
		}
	});	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '어음구분'	,
			name:'AC_CD', 
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'A047',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('AC_CD', newValue);
				}
			}
    	},		    
	    	Unilite.popup('BANK',{
	    	fieldLabel: '은행',
	    	labelWidth: 250,
			autoPopup   : true ,
//	    	validateBlank:false, 
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('BANK_CODE', panelResult.getValue('BANK_CODE'));
						panelSearch.setValue('BANK_NAME', panelResult.getValue('BANK_NAME'));
                	},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('BANK_CODE', '');
					panelSearch.setValue('BANK_NAME', '');
				}
			}
//		    	textFieldWidth:170
	    }),{
			fieldLabel: '어음상태'	,
			name:'NOTE_STS', 
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'A063',
	    	labelWidth: 285,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('NOTE_STS', newValue);
				}
			}
    	}, {
			fieldLabel: '어음번호'	,
			name:'NOTE_NUM', 
			xtype: 'uniTextfield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('NOTE_NUM', newValue);
				}
			}
    	},  
	        Unilite.popup('CUST',{
	        fieldLabel: '거래처',
	    	labelWidth: 250,
			allowBlank:true,
			autoPopup:false,
			validateBlank:false, 
			valueFieldName: 'CUSTOM_CODE1',
			textFieldName: 'CUSTOM_NAME1',
			listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {						
							panelSearch.setValue('CUSTOM_CODE1', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('CUSTOM_NAME1', '');
								panelSearch.setValue('CUSTOM_NAME1', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {
							panelSearch.setValue('CUSTOM_NAME1', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('CUSTOM_CODE1', '');
								panelSearch.setValue('CUSTOM_CODE1', '');
							}
						}
			}
		}),{
			fieldLabel: '수취구분'	,
			name:'RECEIPT_GUBUN', 
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'B064',
	    	labelWidth: 285,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('RECEIPT_GUBUN', newValue);
				},
				specialkey: function(elm, e){
                    if (e.getKey() == e.ENTER) {
						UniAppManager.app.onQueryButtonDown();
                    }
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
		          		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
		        	}
					alert(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		//this.mask();
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
		    	//this.unmask();
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
		}
	}); 
	
	var inputTable = Unilite.createForm('detailForm', { //createForm
		layout : {type : 'uniTable', columns : 3},
		disabled: false,
        border:true,
        padding:'1 1 1 1',
        masterGrid: masterGrid,
		region: 'center',
		items: [{
				fieldLabel: '어음구분'	,
				name:'AC_CD', 
				allowBlank: false,
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'A047',
				readOnly: true	
	    	}, 		    
		    Unilite.popup('BANK',{
		    	fieldLabel: '지급은행',
				autoPopup   : true ,
	//	    	validateBlank:false, 
		    	labelWidth: 250,
		    	valueFieldName:'BANK_CODE',
		   	 	textFieldName:'BANK_NAME'
		    }),{
				fieldLabel: '수취구분'	,
				name:'RECEIPT_DIVI', 
		    	labelWidth: 250,
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'B064'
	    	}, {
	    		fieldLabel: '어음번호',
	    		name: 'NOTE_NUM',
				allowBlank: false,
				readOnly: true	    		
	    	},   
		    Unilite.popup('CUST',{
		        fieldLabel: '거래처',
		    	labelWidth: 250,
				autoPopup   : true ,
				readOnly: true,
				valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME'
			}), {
	    		fieldLabel: '발행인',
		    	labelWidth: 250,
	    		name: 'PUB_MAN'	
	    	}, {
				fieldLabel: '발행일',
				name: 'PUB_DATE',
				xtype: 'uniDatefield'
			}, 
			Unilite.popup('ACCNT',{ 
				fieldLabel: '계정코드', 
				autoPopup   : true ,
		    	labelWidth: 250,
				readOnly: true,
				valueFieldName: 'ACCNT',
				textFieldName: 'ACCNT_NAME'
			}),{
				fieldLabel: '보관장소'	,
				name:'NOTE_KEEP',
		    	labelWidth: 250,
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'A057'
	    	}, {
				fieldLabel: '만기일',
				name: 'EXP_DATE',
				xtype: 'uniDatefield'
			}, {
				xtype: 'container',
				layout : {type : 'uniTable'},
				items: [{
					fieldLabel: '어음종류'	,
					name:'DC_DIVI', 
					xtype: 'uniCombobox', 
					comboType:'AU',
					width: 350,
		    		labelWidth: 250,
					comboCode:'A058'
		    	}, {
					fieldLabel: '어음상태'	,
					name:'NOTE_STS', 
					width: 170,
					allowBlank: false,
		    		labelWidth: 70,
					xtype: 'uniCombobox', 
					comboType:'AU',
					comboCode:'A063'
		    	}]
		    }, {
	    		fieldLabel: '배서인1',
		    	labelWidth: 250,
	    		name: 'CHECK1'
	    	}, {
	    		fieldLabel: '금액',
	    		name: 'OC_AMT_I',
				readOnly: true,
	    		xtype: 'uniNumberfield'
	    	}, {
	    		fieldLabel: '반제금액',
	    		name: 'J_AMT_I',
		    	labelWidth: 250,
				readOnly: true,
				xtype: 'uniNumberfield'
	    	},{
	    		fieldLabel: '배서인2',
		    	labelWidth: 250,
	    		name: 'CHECK2'
	    	}, {
	    		fieldLabel: '전표일',
	    		name: 'AC_DATE',
				readOnly: true,
				xtype: 'uniDatefield'
	    	}, {
	    		fieldLabel: '전표번호',
	    		name: 'SLIP_NUM',
		    	labelWidth: 250,
				readOnly: true
	    	}, {
	    		fieldLabel: '전표순번',
	    		name: 'SLIP_SEQ',
		    	labelWidth: 250,
				readOnly: true
	    	}, {
	    		fieldLabel: '반제일',
	    		name: 'J_DATE',
				xtype: 'uniDatefield',
				readOnly: true
	    	}, {
	    		fieldLabel: '반제번호',
	    		name: 'J_NUM',
		    	labelWidth: 250,
				readOnly: true
	    	}, {
	    		fieldLabel: '반제순번',
	    		name: 'J_SEQ',
		    	labelWidth: 250,
				readOnly: true
	    	}
	    ],
		loadForm: function(record)	{
			// window 오픈시 form에 Data load
			var count = masterGrid.getStore().getCount();
			if(count > 0) {
				this.reset();
				this.setActiveRecord(record[0] || null);   
				this.resetDirtyStatus();			
			}
		}
	});
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('afn100ukrGrid1', {
    	// for tab    	
        layout : 'fit',
        region:'center',
    	store: directMasterStore1,
    	uniOpt : {
			useMultipleSorting	: true,			 
		    useLiveSearch		: false,			
		    onLoadSelectFirst	: false,		
		    dblClickToEdit		: false,		
		    useGroupSummary		: true,			
			useContextMenu		: false,		
			useRowNumberer		: true,			
			expandLastColumn	: true,		
			useRowContext		: false,	// rink 항목이 있을경우만 true			
		    filter: {
				useFilter	: false,		
				autoCreate	: true		
			}
		},
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [{ dataIndex: 'AC_CODE'			 	,	width:86, hidden: true },
        		   { dataIndex: 'AC_CD'		    	 	,	width:70 },
        		   { dataIndex: 'NOTE_NUM'	    	 	,	width:100 },
        		   { dataIndex: 'PUB_DATE'	    	 	,	width:80 },
        		   { dataIndex: 'EXP_DATE'	    	 	,	width:80 },
        		   { dataIndex: 'CUSTOM_CODE'		 	,	width:100 },
        		   { dataIndex: 'CUSTOM_NAME'		 	,	width:140 },
        		   { dataIndex: 'OC_AMT_I'	    	 	,	width:110 },
        		   { dataIndex: 'J_AMT_I'			 	,	width:110 },
        		   { dataIndex: 'BANK_CODE'	    	 	,	width:100 },
        		   { dataIndex: 'BANK_NAME'	    	 	,	width:120 },
        		   { dataIndex: 'NOTE_STS'	    	 	,	width:80 },
        		   { dataIndex: 'UPDATE_DB_USER'	 	,	width:133, hidden: true },
        		   { dataIndex: 'UPDATE_DB_TIME'	 	,	width:66, hidden: true },
        		   { dataIndex: 'COMP_CODE'	    	 	,	width:66, hidden: true },
        		   { dataIndex: 'PUB_MAN'	    	 	,	width:66, hidden: true },
        		   { dataIndex: 'ACCNT'	    	  		,	width:66, hidden: true },
        		   { dataIndex: 'ACCNT_NAME'	  		,	width:66, hidden: true },
        		   { dataIndex: 'NOTE_KEEP'	    	 	,	width:66, hidden: true },
        		   { dataIndex: 'CHECK1'	    	 	,	width:66, hidden: true },
        		   { dataIndex: 'CHECK2'	    	 	,	width:66, hidden: true },
        		   { dataIndex: 'AC_DATE'	    	 	,	width:66, hidden: true },
        		   { dataIndex: 'SLIP_NUM'	    	 	,	width:66, hidden: true },
        		   { dataIndex: 'SLIP_SEQ'	    	 	,	width:66, hidden: true },
        		   { dataIndex: 'DC_DIVI'	    	 	,	width:66, hidden: true },
        		   { dataIndex: 'J_DATE'	    	 	,	width:66, hidden: true },
        		   { dataIndex: 'J_NUM'	    	  		,	width:66, hidden: true },
        		   { dataIndex: 'J_SEQ'	    	  		,	width:66, hidden: true },
        		   { dataIndex: 'RECEIPT_DIVI'	  		,	width:66, hidden: true }
        		   
        ],
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {	// 
	        	if(!e.record.phantom) {                     // 
	        		if(UniUtils.indexOf(e.field))           // 
					{                                       // 
						return false;                       // 
      				} else {                                // 
      					return false;                       // 
      				}                                       // 
	        	} else {                                    // 
	        		if(UniUtils.indexOf(e.field))           // 
					{                                       // 
						return false;                       // 
      				} else {                                // 
      					return false;                       // 
      				}                                       // 
	        	}                                           // 
	        },												// 나중에 지울거~~
        	selectionchange:function( model1, selected, eOpts ){
        		var record = masterGrid.getSelectedRecord();
        		var count = masterGrid.getStore().getCount();
        		inputTable.loadForm(selected);
          	}
        }
    });   		
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				{
					region : 'center',
					xtype : 'container',
					layout : 'fit',
					items : [ masterGrid ]
				},
				panelResult,
				{
					region : 'north',
					xtype : 'container',
					highth: 20,
					layout : 'fit',
					items : [ inputTable ]
				}
			]
		},
			panelSearch	
		],
		id  : 'afn100ukrApp',
		fnInitBinding : function() {
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('AC_CD');
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons(['detail','reset'],false);
			UniAppManager.setToolbarButtons(['reset'],true);   
			//UniAppManager.setToolbarButtons('save',false);
		},
		onResetButtonDown: function() {		// 초기화
			//this.suspendEvents();
			panelSearch.clearForm();
			inputTable.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
			this.fnInitBinding();
			directMasterStore1.clearData();
			UniAppManager.setToolbarButtons('save',false);
		},
		onQueryButtonDown : function()	{			
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}	
			directMasterStore1.loadStoreRecords();
			UniAppManager.setToolbarButtons('reset',true);	
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			directMasterStore1.saveStore();
		}
	});
	
	Unilite.createValidator('validator01', {
		store : directMasterStore1,
		grid: masterGrid,
		//forms: {'formA:':Table},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			return rv;
		}
	});
};


</script>
