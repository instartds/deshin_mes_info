<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 거래처팝업
request.setAttribute("PKGNAME","Unilite.app.popup.CustPopup");
%>
/**
 *   Model 정의 
 * @type 
 */
Unilite.defineModel('${PKGNAME}CustPopupModel', {
    fields: [ 	 {name: 'CUSTOM_CODE' 		,text:'<t:message code="system.label.common.customcode" default="거래처코드"/>' 	,type:'string'	}
				,{name: 'CUSTOM_NAME' 			,text:'<t:message code="system.label.common.customname" default="거래처명"/>' 	,type:'string'	, allowBlank:false}
				,{name: 'COMPANY_NUM' 			,text:'<t:message code="system.label.common.businessnumber" default="사업자번호"/>' 	,type:'string'	}
				,{name: 'TOP_NAME' 					,text:'<t:message code="system.label.common.representativename" default="대표자명"/>' 		,type:'string'}
				,{name: 'BUSINESS_TYPE' 				,text:'<t:message code="system.label.common.businessdivisiontype" default="사업자구분"/>' 	,type:'string'	}
				,{name: 'COMP_CLASS' 		,text:'<t:message code="system.label.common.businesstype" default="업종"/>' 		,type:'string'	}
				,{name: 'COMP_TYPE' 			,text:'<t:message code="system.label.common.businessconditions" default="업태"/>' 		,type:'string'	}
				,{name: 'ADDR1' 					,text:'<t:message code="system.label.common.address1" default="주소1"/>' 		,type:'string'	}
				,{name: 'ADDR2' 					,text:'<t:message code="system.label.common.address2" default="주소2"/>' 		,type:'string'	}
				,{name: 'ZIP_CODE' 				,text:'<t:message code="system.label.common.zipcode" default="우편번호"/>' 	,type:'string'	}
				,{name: 'TELEPHON' 				,text:'<t:message code="system.label.common.telephone" default="전화번호"/>' 	,type:'string'	}
				,{name: 'FAX_NUM' 				,text:'<t:message code="system.label.common.faxno" default="팩스번호"/>' 	,type:'string'	}
				,{name: 'MAIL_ID' 					,text:'E_mail' 		,type:'string'	}
				,{name: 'WON_CALC_BAS' 	,text:'<t:message code="system.label.common.decimalcalculation" default="원미만계산"/>' 	,type:'string'	}
				,{name: 'TO_ADDRESS' 			,text:'<t:message code="system.label.common.sendaddress" default="송신주소"/>' 	,type:'string'	}
				,{name: 'TAX_CALC_TYPE' 	,text:'<t:message code="system.label.common.taxcalculationmethod" default="세액계산법"/>' 	,type:'string'	}
				,{name: 'TRANS_CLOSE_DAY'	,text:'<t:message code="system.label.common.customclosingdate" default="거래처마감일"/>',type:'string'	}
				,{name: 'RECEIPT_DAY' 				,text:'<t:message code="system.label.common.apprperiod" default="결재기간"/>' 	,type:'string'	}
				,{name: 'TAX_TYPE' 					,text:'<t:message code="system.label.common.taxincludedflag" default="세액포함여부"/>',type:'string'	}
				,{name: 'VAT_RATE' 					,text:'<t:message code="system.label.common.taxrate" default="세율"/>' 		,type:'string'	}
				,{name: 'MONEY_UNIT' 			,text:'<t:message code="system.label.common.currency" default="화폐 "/>' 		,type:'string'	}
				,{name: 'BILL_TYPE' 					,text:'<t:message code="system.label.common.billtype" default="계산서유형"/>' 	,type:'string'	}
				,{name: 'SET_METH' 					,text:'<t:message code="system.label.common.payingterm" default="결제방법"/>' 	,type:'string'	}
				,{name: 'CUSTOM_FULL_NAME' 	,text:'<t:message code="system.label.common.customfullname" default="거래처전명"/>' 	,type:'string'	}
				,{name: 'TOP_NUM' 					,text:'<t:message code="system.label.common.reprenum" default="주민등록번호"/>',type:'string'	}
				,{name: 'BANK_CODE' 				,text:'<t:message code="system.label.common.financialinstitution" default="금융기관"/>' 	,type:'string'	}
				,{name: 'BANK_NAME' 				,text:'<t:message code="system.label.common.financialinstitutionname" default="금융기관명"/>' 	,type:'string'	}
				,{name: 'REMARK' 						,text:'<t:message code="system.label.common.remarks" default="비고"/>' 		,type:'string'	}
				,{name: 'BANKBOOK_NUM' 		,text:'<t:message code="system.label.common.custombankaccount" default="거래처계좌번호"/>' 	,type:'string'}
				,{name: 'NATION_CODE' 			,text:'<t:message code="system.label.common.countrycode" default="국가코드"/>' 	,type:'string'}
				,{name: 'CUSTOM_TYPE' 			,text:'<t:message code="system.label.common.classfication" default="구분"/>' 	,type:'string', allowBlank:false}				
				,{name: 'COMP_CODE' 				,text:'<t:message code="system.label.common.companycode" default="법인코드"/>' 	,type:'string' , defaultValue:UserInfo.compCode}
				,{name: 'RETURN_CODE' 			,text:'<t:message code="system.label.common.returncode" default="반품처"/>' 	,type:'string'	}				
				,{name: 'AGENT_TYPE'      			,text:'<t:message code="system.label.common.customclass" default="거래처분류"/>'     ,type:'string'  }
				,{name: 'BOOK_CODE' 				,text:'<t:message code="system.label.common.bankaccountcode" default="계좌코드"/>' 	,type:'string'	}				
				,{name: 'BOOK_NAME'      		 ,text:'<t:message code="system.label.common.bankaccountname" default="계좌명"/>'     ,type:'string'  }
				,{name: 'BOOK_BANK_CODE' 	,text:'<t:message code="system.label.common.bookbankcode" default="계좌은행코드"/>' 	,type:'string'	}				
				,{name: 'BOOK_BANK_NAME' ,text:'<t:message code="system.label.common.bookbank" default="계좌은행"/>'     ,type:'string'  }
				
				,{name: 'PRSN_NAME' 				,text:'<t:message code="system.label.common.receivingperson" default="받는 담당자"/>' 	,type:'string'	}
				,{name: 'PRSN_EMAIL' 				,text:'<t:message code="system.label.common.receivingemail" default="받는 이메일"/>' 	,type:'string'	}
				,{name: 'PRSN_HANDPHONE'	,text:'<t:message code="system.label.common.receivingehandphone" default="받는 핸드폰"/>' 	,type:'string'	}
				,{name: 'PRSN_PHONE' 			,text:'<t:message code="system.label.common.receivingphone" default="받는 연락처"/>' 	,type:'string'	}
		]
});


/**
 * 검색조건 (Search Panel)
 * @type 
 */
Ext.define('${PKGNAME}', {
    extend: 'Unilite.com.BaseJSPopupApp',    
    //param: this.param,
    constructor : function(config) {
        var me = this;
        if (config) {
            Ext.apply(me, config);
        }
	    /**
	     * 검색조건 (Search Panel)
	     * @type 
	     */
//	    var wParam = this.param;
//	    var t1= false, t2 = false;
//	    if( Ext.isDefined(wParam)) {
//	        if(wParam['TYPE'] == 'VALUE') {
//	            t1 = true;
//	            t2 = false;
//	            
//	        } else {
//	            t1 = false;
//	            t2 = true;
//	            
//	        }
//	    }
		me.panelSearch = Unilite.createSearchForm('',{
		    layout : {type : 'uniTable', columns : 3, tableAttrs: {
		        style: {
		            width: '100%'
		        }
		    }},
		    items: [  { fieldLabel: '<t:message code="system.label.common.classfication" default="구분"/>', 	name:'CUSTOM_TYPE',  xtype: 'uniCombobox', comboType:'AU',comboCode:'B015'
		    			,onStoreLoad: function(combo, store, records, successful, eOpts) {
		    				var pCustomType = me.param['CUSTOM_TYPE'];
		    				
		    				if(me.param['CUSTOM_TYPE'] != '5'){
		    					if(!Ext.isArray(pCustomType)){
		    						combo.setValue(me.param['CUSTOM_TYPE']);
		    					}
		    				}

							if(!Ext.isEmpty(pCustomType)){
							 	store.filterBy(function(record) {  // foreach 문  return ture 만 빼냄
								if(Ext.isArray(pCustomType)) {
									return  pCustomType.indexOf(record.get('value')) > -1  // -1 은 없는 값 
								}else {
									return pCustomType == record.get('value')
								}
							});
						}
		    			}
		    		},{ fieldLabel: '<t:message code="system.label.common.businessnumber" default="사업자번호"/>', 	name:'COMPANY_NUM',  xtype: 'uniTextfield' ,colspan:2}
					 
					 ,{ fieldLabel: '<t:message code="system.label.common.customclass" default="거래처분류"/>',    name:'AGENT_TYPE',  xtype: 'uniCombobox', comboType:'AU',comboCode:'B055', multiSelect:true, typeAhead:false }
					 
					 ,{ fieldLabel: '<t:message code="system.label.common.inquirycondition" default="조회조건"/>', 	name:'TXT_SEARCH', colspan:2,focusable:true,
					 	listeners:{
							specialkey: function(field, e){
			                    if (e.getKey() == e.ENTER) {
			                       me.onQueryButtonDown();
			                    }
			                }
						}	
					 }
					 ,{ fieldLabel: '<t:message code="system.label.common.useflag" default="사용유무"/>',		name:'USE_YN', hidden:true}
					 ,{ xtype: 'component'}
//					 ,{ fieldLabel: '사업자구분', 
//					 	xtype: 'radiogroup', width: 230,
//					 	items:[	{inputValue: '1', boxLabel:'코드순', name: 'RDO', checked: t1},
//					 			{inputValue: '2', boxLabel:'이름순',  name: 'RDO', checked: t2} ]
//					 }
			        ,{ xtype:'button', text:'<t:message code="system.label.common.quickregist" default="빠른등록"/>', margin: '0 0 5 95', width: 110
			        ,handler:function()	{
			          		me.openRegWindow();
			           }
			         }
			         ,{ fieldLabel: '<t:message code="system.label.common.addquery" default="추가쿼리관련"/>',     name:'ADD_QUERY',   xtype: 'uniTextfield', hidden: true}
			]
		});  
		
		
		/**
		 * Master Grid 정의(Grid Panel)
		 * @type 
		 */
		 me.masterGrid = Unilite.createGrid('', {
			store: Unilite.createStoreSimple('${PKGNAME}custPopupMasterStore',{
							model: '${PKGNAME}CustPopupModel',
					        autoLoad: false,
					        proxy: Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
								api: {
						        	read: 'popupService.custPopup'
					            	,create : 'bcm100ukrvService.insertSimple'
									,syncAll:'bcm100ukrvService.saveAll'
						        }
						    }),
					        saveStore : function(config)	{				
									var inValidRecs = this.getInvalidRecords();
									if(inValidRecs.length == 0 )	{
										//this.syncAll(config);
										this.syncAllDirect(config);
									}else {
										alert(Msg.sMB083);
									}
							}
					}),
			uniOpt: {
				state: {
					useState: false,
					useStateList: false	
                },
				pivot : {
					use : false
				}
	        },
			selModel:'rowmodel',
		    columns:  [        
		           		 { dataIndex: 'CUSTOM_CODE'		,width: 80  , locked:false}  
						,{ dataIndex: 'CUSTOM_NAME'		,width: 200 , locked:false} 
						,{ dataIndex: 'COMPANY_NUM'		,width: 120 } 
						,{ dataIndex: 'TOP_NAME'		,width: 80 }
						,{ dataIndex: 'BUSINESS_TYPE'	,width: 100 , hidden: true} 
						,{ dataIndex: 'COMP_CLASS'		,width: 100 , hidden: true} 
						,{ dataIndex: 'COMP_TYPE'		,width: 100 , hidden: true} 
						,{ dataIndex: 'ADDR1'			,width: 100 , hidden: true} 
						,{ dataIndex: 'ADDR2'			,width: 100 , hidden: true}
						,{ dataIndex: 'ZIP_CODE'		,width: 100 , hidden: true} 
						,{ dataIndex: 'TELEPHON'		,width: 100 , hidden: true} 
						,{ dataIndex: 'FAX_NUM'			,width: 100 , hidden: true} 
						,{ dataIndex: 'MAIL_ID'			,width: 100 , hidden: true} 
						,{ dataIndex: 'WON_CALC_BAS'	,width: 100 , hidden: true} 
						,{ dataIndex: 'TO_ADDRESS'		,width: 100 , hidden: true} 
						,{ dataIndex: 'TAX_CALC_TYPE'	,width: 100 , hidden: true} 
						,{ dataIndex: 'TRANS_CLOSE_DAY'	,width: 100 , hidden: true} 
						,{ dataIndex: 'RECEIPT_DAY'		,width: 100 , hidden: true} 
						,{ dataIndex: 'TAX_TYPE'		,width: 100 , hidden: true} 
						,{ dataIndex: 'VAT_RATE'		,width: 100 , hidden: true} 
						,{ dataIndex: 'MONEY_UNIT'		,width: 100 , hidden: true} 
						,{ dataIndex: 'BILL_TYPE'		,width: 100 , hidden: true} 
						,{ dataIndex: 'SET_METH'		,width: 100 , hidden: true} 
						,{ dataIndex: 'CUSTOM_FULL_NAME',width: 100 , hidden: true} 
						,{ dataIndex: 'TOP_NUM'			,width: 100 , hidden: true} 
						,{ dataIndex: 'BANK_CODE'		,width: 100 , hidden: true}
						,{ dataIndex: 'BANK_NAME'		,width: 100 , hidden: true}  
						,{ dataIndex: 'BANKBOOK_NUM'	,width: 100 , hidden: true} 
						,{ dataIndex: 'REMARK'			,width: 100 , flex:1 }
						,{ dataIndex: 'RETURN_CODE'		,width: 100 , hidden: true} 
						,{ dataIndex: 'PRSN_NAME'		,width: 100 , hidden: true} 
						,{ dataIndex: 'PRSN_EMAIL'		,width: 100 , hidden: true}
						,{ dataIndex: 'PRSN_PHONE'		,width: 100 , hidden: true}
						,{ dataIndex: 'PRSN_HANDPHONE'	,width: 100 , hidden: true}
		      ] ,
			listeners: {
				onGridDblClick:function(grid, record, cellIndex, colName) {
		          	var rv = {
						status : "OK",
						data:[record.data]
					};
					me.returnData(rv);
		        },
				onGridKeyDown: function(grid, keyCode, e) {
					if(e.getKey() == Ext.EventObject.ENTER) {
			        	var selectRecord = grid.getSelectedRecord();
					 	var rv = {
							status : "OK",
							data:[selectRecord.data]
						};
						me.returnData(rv);
		        	}
				}
			}
		})
		config.items = [me.panelSearch,	me.masterGrid];
		me.callParent(arguments);
		
		me.regCustForm = Unilite.createForm('',{
			
		    layout : {type : 'uniTable', columns : 1},
		 	masterGrid: me.masterGrid,
		 	
		    disabled:false,
		    buttonAlign :'center',
		    fbar: [
			        {  xtype: 'button', text: '<t:message code="system.label.common.save" default="저장"/>' ,
			           handler: function()	{
			           	    if(!me.regCustForm.getInvalidMessage()) return;
			           	    var r = {
			           	    	COMPANY_NUM: me.regCustForm.getValue('COMPANY_NUM').replace(/-/gi, ''),
			           	    	CUSTOM_CODE: me.regCustForm.getValue('CUSTOM_CODE'),
                                CUSTOM_NAME: me.regCustForm.getValue('CUSTOM_NAME'),
                                CUSTOM_TYPE: me.regCustForm.getValue('CUSTOM_TYPE'),
                                AGENT_TYPE: me.regCustForm.getValue('AGENT_TYPE'),
                                TOP_NAME: me.regCustForm.getValue('TOP_NAME')
			           	    }
			           	    
			           	    var checkParam = {
			           	    	COMPANY_NUM: me.regCustForm.getValue('COMPANY_NUM').replace(/-/gi, '')
			           	    };
			           	    bcm100ukrvService.selectList(checkParam, function(provider, response){
			           	    	var result = false;
			           	    	if(provider) {
			           	    		result = confirm('<t:message code="unilite.msg.sMB177" default="해당 사업자번호의 거래처코드가 이미 존재합니다. 계속 진행하시겠습니까?"/>');
			           	    	}
			           	    	
			           	    	if(!result) {
			           	    		me.regWindow.hide();
			           	    		return;
			           	    	}
			           	    	
				           	    me.masterGrid.createRow(r);
				           	    var record = me.masterGrid.getSelectedRecord();
				        		me.masterGrid.getStore().saveStore({					        		
				        			success: function(batch, option){
										console.log("option : ",option);
										if(option.params && option.params[0] && option.params[0].message)	{
											//alert(option.params[0].message);
											me.masterGrid.deleteSelectedRow();
											me.close();
											return;
										}
				        				me.panelSearch.setValue("COMPANY_NUM",r.COMPANY_NUM);
				        				me.panelSearch.setValue("TXT_SEARCH",r.CUSTOM_CODE);
				        				me.panelSearch.setValue("CUSTOM_TYPE",r.CUSTOM_TYPE);
				        				me.panelSearch.setValue("AGENT_TYPE",r.AGENT_TYPE);
				        				me._dataLoad();
						 				/*var rv = {
											status : "OK",
											data:[record.data]
										};*/
										//me.returnData(rv);
									 },
									 failure: function(batch, option){
										//alert(option.params[0].message);
										me.masterGrid.deleteSelectedRow();
										me.close();
									 }
				        		})
				        		//me.returnData({});
				        		me.regWindow.hide();
				        	});
			        	}
			        },
			        {  xtype: 'button', text: '<t:message code="system.label.common.close" default="닫기"/>' ,
			        	handler:function()	{
//			        		me.masterGrid.getStore().rejectChanges();
			        		me.regWindow.hide();
			        	}
			        }
				   ],
		    items: [  { fieldLabel: '<t:message code="system.label.common.businessnumber" default="사업자번호"/>',    name:'COMPANY_NUM', allowBlank: false, enforceMaxLength: true, maxLength: 12,
		                   listeners : {                                       
                                blur: function(field, The, eOpts)   {
                                    var newValue = field.getValue();
                                    newValue = newValue.replace(/-/gi, "");
                                    if(Ext.isEmpty(newValue))   return;
                                    if(Ext.isNumeric(newValue) != true) {
                                        alert(Msg.sMB074);
                                        field.setValue('');
                                        return;
                                    }else if(Unilite.validate('bizno', newValue) != true)   {
                                        if(!Ext.isEmpty(newValue) && newValue.length != 10 ){
                                            alert('자릿수를 확인하십시오.');
                                            field.setValue('');
                                            return;
                                        }else if(!confirm(Msg.sMB173+"\n"+Msg.sMB175))  {                                        	
                                            field.setValue('');
                                            return;
                                        }
                                    }
                                    if(Ext.isNumeric(newValue) == true) {
                                        var a = newValue;
                                        var i = (a.substring(0,3)+ "-"+ a.substring(3,5)+"-" + a.substring(5,10));                                        
                                        field.setValue(i);                                
                                    }                                    
                                },
                                change: function(field, newValue) {
                                	newValue = newValue.replace(/-/gi, "");
                                	
                                	if(newValue.length <= 3) {
                                		newValue = newValue;
                                	}
                                	else if(newValue.length <= 5) {
                                		newValue = newValue.substring(0, 3) + '-' + newValue.substring(3, 5);
                                	}
                                	else {
                                		newValue = newValue.substring(0, 3) + '-' + newValue.substring(3, 5) + '-' + newValue.substring(5, 10);
                                	}
                                	
                                	field.setValue(newValue);
                                }
                            }
		              } 
					 ,{ fieldLabel: '<t:message code="system.label.common.customcode" default="거래처코드"/>',    	name:'CUSTOM_CODE', enforceMaxLength: true, maxLength: 8}
					 ,{ fieldLabel: '<t:message code="system.label.common.customname" default="거래처명"/>', 	  	name:'CUSTOM_NAME', allowBlank: false, enforceMaxLength: true, maxLength: 50}
					 ,{ fieldLabel: '<t:message code="system.label.common.classfication" default="구분"/>',        	name:'CUSTOM_TYPE',  xtype: 'uniCombobox', comboType:'AU',comboCode:'B015', allowBlank: false, value: '1'}
					 ,{ fieldLabel: '<t:message code="system.label.common.customclass" default="거래처분류"/>',    	name:'AGENT_TYPE',  xtype: 'uniCombobox', comboType:'AU',comboCode:'B055', allowBlank: false, value: '1'}
					 ,{ fieldLabel: '<t:message code="system.label.base.representative" default="대표자"/>',    	name:'TOP_NAME'}
					 
			]
//			,
//			listeners: {
//				onShow: function() {
//					alert('hello1');
//				},
//				beforeShow: function() {
//					alert('hello2');
//				},
//				beforeshow: function() {
//					alert('hello3');
//				},
//				show: function() {
//					alert('hello4');
//				}
//			}
		});  
		
		me.regWindow = Ext.create('Ext.window.Window', {
                title: '<t:message code="system.label.common.customfasterinput" default="거래처 빠른 입력"/>',
                modal: true,
                closable: false,
                width: 300,				                
                height: 230,
                alwaysOnTop:89000,
                items: [me.regCustForm],
                hidden:true,
                listeners : {
                			 show:function( window, eOpts)	{
                			 	me.regCustForm.reset();
                			 	me.regCustForm.body.el.scrollTo('top',0);
                			 	me.regCustForm.setValue('CUSTOM_NAME', me.panelSearch.getValue('TXT_SEARCH'));
                			 }
            
                		}
		});
    },
    initComponent : function(){    
    	var me  = this;
        
        me.masterGrid.focus();

    	this.callParent();    	
    },
	fnInitBinding : function(param) {
		var me = this;
		me.param = param;
		me.panelSearch.onLoadSelectText('TXT_SEARCH');
		var frm= me.panelSearch.getForm();
		
//		var rdo = frm.findField('RDO');
		var fieldTxt = frm.findField('TXT_SEARCH');
		var customType = frm.findField('CUSTOM_TYPE');
		var companyNum = frm.findField('COMPANY_NUM');
		frm.setValues(param);
		if( Ext.isDefined(param)) {
//			if(Ext.isDefined(fieldTxt) && fieldTxt.isFormField) {
//				if(param['TYPE'] == 'VALUE') {
//					fieldTxt.setValue(param['CUSTOM_CODE']);
//					rdo.setValue('1');
//				} else {
//					fieldTxt.setValue(param['CUSTOM_NAME']);
//					rdo.setValue('2');
//				}
//			}
			//customType.setValue(param['CUSTOM_TYPE']);  //combo store 의 load 와 비동기로 값 설정이 안되어 setCustomTypeCombo 사용으로 변경
			if(param['TYPE'] == 'VALUE') {
	        	if(!Ext.isEmpty(param['CUSTOM_CODE'])){
	        		fieldTxt.setValue(param['CUSTOM_CODE']);        	
	        	}
	        }else{
	        	if(!Ext.isEmpty(param['CUSTOM_CODE'])){
	        		fieldTxt.setValue(param['CUSTOM_CODE']);        	
	        	}
	        	if(!Ext.isEmpty(param['CUSTOM_NAME'])){
	        		fieldTxt.setValue(param['CUSTOM_NAME']);
	        	}
	        }
			companyNum.setValue(param['COMPANY_NUM']);	
		}

		if(param.CUSTOM_TYPE == '5'){
			customType.setValue(param['CUSTOM_TYPE']);
			var customTypeField = frm.getField("CUSTOM_TYPE");
			if(customTypeField) customTypeField.setReadOnly(true);
		}
		
		
		if(frm.isValid())	{
		 	this._dataLoad();
		}		 
	},
	 onQueryButtonDown : function()	{
		this._dataLoad();
	},
	onSubmitButtonDown : function()	{
        var me = this;
		var selectRecord = me.masterGrid.getSelectedRecord();
	 	var rv ;
		if(selectRecord)	{
		 	rv = {
				status : "OK",
				data:[selectRecord.data]
			};
		}
		me.returnData(rv);
		me.close();
	},
	openRegWindow:function()	{
		var me = this;
		console.log("openRegWindow:me", me);
		me.regWindow.show();
//		var selRecord = me.masterGrid.createRow();	
//		me.regCustForm.setActiveRecord(selRecord||null);
		
	},	
	_dataLoad : function() {
			var me = this;
			var param= me.panelSearch.getValues();
			if(Ext.isEmpty(param.CUSTOM_TYPE) && !Ext.isEmpty(me.param.CUSTOM_TYPE))	{
				param.CUSTOM_TYPE =me.param.CUSTOM_TYPE
			}
			console.log( "_dataLoad: ", param );
			if(me.panelSearch.isValid())	{
				me.isLoading = true;
				me.masterGrid.getStore().load({
					params : param,
					callback:function()	{
						me.isLoading = false;
					}
				});
			}
	}
});


