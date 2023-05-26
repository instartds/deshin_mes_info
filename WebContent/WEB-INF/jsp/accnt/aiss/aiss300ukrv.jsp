<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="aiss300ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="B013" /> <!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="A038" /> <!-- 상각상태 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="A035" /> <!-- 완료여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A036" /> <!-- 상각방법 -->
	<t:ExtComboStore comboType="AU" comboCode="A033" /> <!-- 정액상각 -->
	<t:ExtComboStore comboType="AU" comboCode="A034" /> <!-- 정율상각 -->
	<t:ExtComboStore comboType="AU" comboCode="A140" /> <!-- 결제유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A022" /> <!-- 증빙유형(매입) -->
	<t:ExtComboStore comboType="AU" comboCode="A070" /> <!-- 불공제사유 -->
	<t:ExtComboStore comboType="AU" comboCode="A149" /> <!-- 전자발행여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A042" /> <!-- 자산구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A044" /> <!-- 자산상태 -->
	<t:ExtComboStore comboType="AU" comboCode="A" 	 /> <!-- Cost Pool -->
	<t:ExtComboStore items="${costPoolCombo}" storeId="costPoolCombo"/>		   <!--  Cost Pool		-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" /><!--대분류-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" /><!--중분류-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" /><!--소분류-->

<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
</t:appConfig>
<script type="text/javascript" >
//var validateFlag = '2';	//업데이트시 validate를 타서 임시로 사용. 
var BsaCodeInfo = {
//	gsAutocd: '${gsAutocd}',	
	gsAccntBasicInfo : ${getAccntBasicInfo},
	gsAutocd: '${gsAutocd}',
	gsMoneyUnit : '${gsMoneyUnit}',
	gsGovGrandCont : '${gsGovGrandCont}'
};
var gsChargeCode = '${getChargeCode}';
function appMain() {
	isAutoAssetNum = false;
	if(BsaCodeInfo.gsAutocd == "Y"){
		isAutoAssetNum = true;
	}
	//국고보조금사용여부
	useGovGrantCont = false;
	if(BsaCodeInfo.gsGovGrandCont == "1"){
		useGovGrantCont = true;
	}
	Unilite.defineModel('aiss300ukrModel', {		
	    fields: [{name: '' 		,text: ''	,type: ''}		  
				 
		]
	});
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
//	var MasterStore = Unilite.createStore('aiss300ukrMasterStore',{
//			model: 'aiss300ukrModel',
//			uniOpt : {
//            	isMaster: false,			// 상위 버튼 연결 
//            	editable: false,			// 수정 모드 사용 
//            	deletable:false,			// 삭제 가능 여부 
//	            useNavi : false			// prev | newxt 버튼 사용
//            },
//            autoLoad: false,
//            proxy: {
//                type: 'direct',
//                api: {			
//                	   read: 'aiss300ukrService.selectList'                	
//                }
//            }
//			,loadStoreRecords : function()	{
//				var param= Ext.getCmp('searchForm').getValues();			
//				console.log( param );
//				this.load({
//					params : param
//				});
//			},
//			groupField: 'CUSTOM_NAME'
//			
//	}); 
	
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
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
		    items :[
		    	Unilite.popup('ASSET',{
			    fieldLabel: '자산코드', 
			    autoPopup: true,
//			    validateBlank: false,
			    allowBlank:false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ASSET_CODE', panelSearch.getValue('ASSET_CODE'));
							panelResult.setValue('ASSET_NAME', panelSearch.getValue('ASSET_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ASSET_CODE', '');
						panelResult.setValue('ASSET_NAME', '');
					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ASSET_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ASSET_NAME', newValue);				
					}
				}
		   	})]
		}]
	});
		
	var panelResult = Unilite.createSearchForm('panelResultForm', {		
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3, tableAttrs:{width :1200}},
		padding:'1 1 1 1',
		border:true,
	    items :[
	    	Unilite.popup('ASSET',{
		    fieldLabel: '자산코드',  
//		    validateBlank: false, 
		    allowBlank:false,
		    labelWidth: 160,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('ASSET_CODE', panelResult.getValue('ASSET_CODE'));
						panelSearch.setValue('ASSET_NAME', panelResult.getValue('ASSET_NAME'));
                	},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('ASSET_CODE', '');
					panelSearch.setValue('ASSET_NAME', '');
				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ASSET_CODE', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ASSET_NAME', newValue);				
				}
			}
	   	}),{
	    	xtype :'component',
	    	flex : 1,
	    	html : "&nbsp;"
	    }, {
	    	xtype :'button',
	    	text : '국고보조금 정보 저장',
	    	width : '150',
	    	hidden : !useGovGrantCont,
	    	tdAttrs : {width:'180' , style : 'padding-bottom : 3px;'},
	    	handler : function()	{
	    		if(detailForm.getValue("EXIST_GOV_YN")=="Y")	{
	    			Unilite.messageBox("국고보조금 상각내역이 등록되어 수정 할 수 없습니다.")
	    			return;
	    		}	    			
	    		var params = {
	    				ASST                 : detailForm.getValue("ASST"),
	    				GOV_GRANT_ACCNT      : detailForm.getValue("GOV_GRANT_ACCNT"),
	    				GOV_GRANT_AMT_I      : detailForm.getValue("GOV_GRANT_AMT_I"),
	    				GOV_GRANT_DPR_TOT_I  : detailForm.getValue("GOV_GRANT_DPR_TOT_I"),
	    				GOV_GRANT_BALN_I     : detailForm.getValue("GOV_GRANT_BALN_I")
	    		}
	    		aiss300ukrService.updateGovInfo(params, function(responseText) {
	    			if(responseText) {
	    				UniAppManager.updateStatus("국고보조금 정보가 저장되었습니다.");
	    				detailForm.resetDirtyStatus()
						UniAppManager.setToolbarButtons('save', false);
	    				UniAppManager.app.onQueryButtonDown()
	    			}
	    		})
	    	}
	    }]
	});

	/**
	 *  Master Form
	 * 
	 * @type
	 */     
	var detailForm = Unilite.createForm('aiss300ukrDetail', {
    	disabled :false,
    	border: true,
    	region:'center',
    	padding: '0 1 0 1'
//    	margin: '10 0 0 0'
//        , flex:1        
        , layout: {type: 'uniTable', columns: 2,tdAttrs: {valign:'top'}}
	    , items :[{
	    	xtype: 'container',
	    	layout: {type: 'uniTable', columns: 1,tdAttrs: {valign:'top'}},
	    	items: [{
			 	fieldLabel: '자산코드',
			 	xtype: 'uniTextfield',
			 	name: 'ASST',	
			 	allowBlank:isAutoAssetNum,    
			    labelWidth: 160,
			    width:375,
			    margin: '10 0 0 0',
			    readOnly: isAutoAssetNum     
			},{
			 	fieldLabel: '자산명',
			 	xtype: 'uniTextfield',
			 	name: 'ASST_NAME',	
			 	allowBlank:false,
			    labelWidth: 160,
			    width:375
			},{
			 	fieldLabel: '규격',
			 	xtype: 'uniTextfield',
			 	name: 'SPEC',
			    labelWidth: 160,
			    width:375	
			},{
				fieldLabel: '일련번호',			 	
			 	xtype: 'uniTextfield',
			 	name: 'SERIAL_NO',
			    labelWidth: 160,
			    width:375	
			},{
				fieldLabel: '자산구분',
				name: 'ASST_DIVI',
		    	labelWidth: 160,
				xtype: 'uniCombobox',	            		
				comboType:'AU',
				comboCode:'A042',
				allowBlank:false,
				width:375
			},
				Unilite.popup('ACCNT',{
				autoPopup: true,
			    fieldLabel: '계정과목',
			    allowBlank:false,
				valueFieldName: 'ACCNT', 
				textFieldName: 'ACCNT_NAME', 
		    	labelWidth: 160,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {			/* 상각 정보 조회*/
							var param = {ACCNT: detailForm.getValue('ACCNT')}
							Ext.getBody().mask();
							accntCommonService.fnGetDprInfoByAccnt(param, function(provider1, response)	{
								Ext.getBody().unmask();
								if(!Ext.isEmpty(provider1.GAAP_DRB_YEAR) && provider1.GAAP_DRB_YEAR != 0){
									var drbYear = '000' + provider1.GAAP_DRB_YEAR;
									drbYear = drbYear.substring(drbYear.length-3);
									var param = {DRB_YEAR: drbYear, ACCNT: detailForm.getValue('ACCNT')}
									Ext.getBody().mask();
									accntCommonService.fnGetDprRate(param, function(provider2, response)	{
										Ext.getBody().unmask();
										if(Ext.isEmpty(provider2.DPR_RATE)){
											Unilite.messageBox(detailForm.getValue('ACCNT_NAME') + '에 해당하는 상각방법이 등록되어 있지 않습니다.' + '\n' + '상각방법을 등록하셔야 저장할 수 있습니다.');
										}else{
											detailForm.setValue('DEP_CTL', provider1.DEP_CTL);
											detailForm.setValue('DRB_YEAR', provider1.GAAP_DRB_YEAR);
											detailForm.setValue('DPR_RATE', provider2.DPR_RATE / 1000);
										}
									});
								} else {
									Unilite.messageBox(detailForm.getValue('ACCNT_NAME') + '에 해당하는 상각방법이 등록되어 있지 않습니다.' + '\n' + '상각방법을 등록하셔야 저장할 수 있습니다.');
								}
							});	
							 
                     	},
						scope: this
					},
					onClear: function(type)	{
						detailForm.setValue('DEP_CTL', "");
						detailForm.setValue('DRB_YEAR', "");
						detailForm.setValue('DPR_RATE', "");
					},
					applyextparam: function(popup){
						popup.setExtParam({'ADD_QUERY': "SPEC_DIVI = 'K'"});			//WHERE절 추카 쿼리
						popup.setExtParam({'CHARGE_CODE': gsChargeCode});			//bParam(3)			
					}
				}
			}),
			Unilite.popup('ACCNT',{
			autoPopup: true,
		    fieldLabel: '국고보조금 계정과목',
			valueFieldName: 'GOV_GRANT_ACCNT', 
			textFieldName: 'GOV_GRANT_ACCNT_NAME', 
	    	labelWidth: 160,	    
	    	hidden : !useGovGrantCont,
			listeners: {
				applyextparam: function(popup){
					popup.setExtParam({'CHARGE_CODE': gsChargeCode});			//bParam(3)			
				}
			}
		}),
			{ 
	        	fieldLabel: '사업장',
	        	name: 'DIV_CODE', 
	        	xtype: 'uniCombobox', 
	        	comboType:'BOR120',
	        	allowBlank:false,
			    labelWidth: 160,
			    width:375
        	},
				Unilite.popup('DEPT',{ 
				    fieldLabel: '사용부서', 
//				    validateBlank: false,
				    allowBlank:false,
			   		labelWidth: 160,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								detailForm.setValue('PURCHASE_DEPT_CODE', detailForm.getValue('DEPT_CODE'));
								detailForm.setValue('PURCHASE_DEPT_NAME', detailForm.getValue('DEPT_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
							detailForm.setValue('PURCHASE_DEPT_CODE', '');
							detailForm.setValue('PURCHASE_DEPT_NAME', '');
						}
					}
			}),
				Unilite.popup('DEPT',{
					autoPopup: true,
					valueFieldName:'PURCHASE_DEPT_CODE',
				    textFieldName:'PURCHASE_DEPT_NAME',
				    fieldLabel: '구입부서',
			   		labelWidth: 160
			}),
				Unilite.popup('AC_PROJECT',{
					autoPopup: true,
				    fieldLabel: '사업코드', 
				    valueFieldName:'PJT_CODE',
					textFieldName:'PJT_NAME',
//				    textFieldOnly: false,
//				    validateBlank: false,
			    	labelWidth: 160
			}),{
				fieldLabel: '상각방법',
				name:'DEP_CTL',	
				xtype: 'uniCombobox',
				allowBlank:false,
				comboType:'AU',
				comboCode:'A036',				
			    labelWidth: 160,
			    width:375,
			    listeners:{
			    	change:function(field, newValue, oldValue)	{
			    		if(!Ext.isEmpty(detailForm.getValue('DRB_YEAR')))	{
				    		var drbYear = '000' + detailForm.getValue('DRB_YEAR') ;
							drbYear = drbYear.substring(drbYear.length-3);
							var dprStore ;
							if(newValue == "1")	{ // 정액상각
								dprStore = Ext.StoreManager.lookup("CBS_AU_A033");
							} else {							 // 정율상각
								dprStore = Ext.StoreManager.lookup("CBS_AU_A034")
							}
							if(dprStore )	{
								var	dprRecordIdx = dprStore.find("value", drbYear);
								if(dprRecordIdx > -1 ) {
									var dprRecord = dprStore.getAt(dprRecordIdx);
									detailForm.setValue("DPR_RATE", parseInt(dprRecord.get("text"))/1000);
								} else {
									Unilite.messageBox("상각방법의  상각율이 등록 되지 않았습니다.")
								}
							}
			    		}
			    	}
			    }
			},{
				layout: {type:'uniTable', column:2},
				xtype: 'container',
				items: [{
					fieldLabel: '내용년수',
					name: 'DRB_YEAR',
			    	labelWidth: 160,
					xtype: 'uniNumberfield',
					allowBlank:false,
					width:258
				},{
					//상각율
				 	xtype: 'uniTextfield',	
				 	name: 'DPR_RATE',
					width:117,
					readOnly: true,
					fieldStyle: "text-align:right;"
				}]
			},{
				layout: {type:'uniTable', column:2},
				xtype: 'container',
				items: [{
					fieldLabel: '화폐단위-환율',
					name: 'MONEY_UNIT',
			    	labelWidth: 160,
			    	allowBlank:false,
					xtype: 'uniCombobox',	            		
					comboType:'AU',
					comboCode:'B004',
		 			displayField: 'value',
					value: BsaCodeInfo.gsMoneyUnit,
					width:258,
					listeners: {
						change: function(combo, newValue, oldValue, eOpts) {
//							if(oldValue){
								var param = {MONEY_UNIT: newValue, AC_DATE: UniDate.get('today')}
								accntCommonService.fnExchgRateO(param, function(provider, response)	{
									if(!Ext.isEmpty(provider)){
										detailForm.setValue('EXCHG_RATE_O', provider.BASE_EXCHG)
									}
								});
//							}							
						}
					}
				},{
				 	xtype: 'uniNumberfield',
				 	name: 'EXCHG_RATE_O',
					width:117,
					fieldStyle: "text-align:right;"
				}]
			},{
			 	fieldLabel: '외화취득가액',			 	
			 	xtype: 'uniNumberfield',
			 	name: 'FOR_ACQ_AMT_I',
			    labelWidth: 160,
			    width:375
			},{
			 	fieldLabel: '취득가액',			 	
			 	xtype: 'uniNumberfield',
			 	name: 'ACQ_AMT_I',
			    labelWidth: 160,
			    width:375,
				allowBlank:false
			},{
			 	fieldLabel: '국고보조금',			 	
			 	xtype: 'uniNumberfield',
			 	name: 'GOV_GRANT_AMT_I',	    
		    	hidden : !useGovGrantCont,
			    labelWidth: 160,
			    width:375
			},{
			 	fieldLabel: 'H_ACQ_AMT_I',			 	
			 	xtype: 'uniNumberfield',
			 	name: 'H_ACQ_AMT_I',
			    labelWidth: 160,
			    width:375,
			    hidden: true
			},{
				layout: {type:'uniTable', column:3},
				xtype: 'container',
				items: [{
					name: 'ACQ_Q',
					labelWidth: 160,
					fieldLabel: '취득수량/재고수량/단위',
					xtype: 'uniNumberfield',
					allowBlank:false,
					width:208
				},{
					xtype: 'uniNumberfield',	            		
					name:'STOCK_Q',
					width:69,
					allowBlank:false					
				},{				 	
				 	xtype: 'uniCombobox',
				 	comboType:'AU',
					comboCode:'B013',
					displayField: 'value',
				 	name: 'QTY_UNIT',
					width:98
				}]
			},{
				layout: {type:'uniTable', column:2},
				xtype: 'container',
				items: [{
					fieldLabel: '취득일/사용일',
					labelWidth: 160,
					xtype: 'uniDatefield',
					name: 'ACQ_DATE',	
					allowBlank:false,
					flex:2,
					width:266,
					listeners: {
						change: function(combo, newValue, oldValue, eOpts) {
							if(!detailForm.uniOpt.inLoading) {
								detailForm.setValue('USE_DATE', newValue);
							}
						}
					}
				},{
					xtype: 'uniDatefield',
					name: 'USE_DATE',	
					allowBlank:false,
					flex:1,
					width:110
				}]
			},
				Unilite.popup('Employee',{
					autoPopup: true,
				    fieldLabel: '사용자', 
				    extParam:{useBasicInfo:true},
//				    textFieldWidth: 170, 
//				    validateBlank: false,				    
			    	labelWidth: 160
			}),{
				fieldLabel: '위치정보',			 	
			 	xtype: 'uniTextfield',
			 	name: 'PLACE_INFO',
			    labelWidth: 160,
			    width:500
			},
				Unilite.popup('CUST',{
					autoPopup: true,
				    fieldLabel: '구입처', 
//				    textFieldWidth: 170, 
//				    validateBlank: false,
			    	labelWidth: 160,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								UniAppManager.app.fnSetAcCustom();	
		                	},
							scope: this
						},
						onClear: function(type)	{
							
						}
					}
			}),{
				fieldLabel: '제조사',
				name: 'MAKER_NAME',
		    	labelWidth: 160,
				xtype: 'uniTextfield',
				width:375
			},{
				fieldLabel: '비고',			 	
			 	xtype: 'textareafield',
			 	name: 'REMARK',
			    labelWidth: 160,
			    width:500,	
			    height:85
			},{
				layout: {type:'hbox', align:'stretch'},
				xtype: 'container',
				border:false,
				items: [{
					fieldLabel: 'Cost Pool',
			    	labelWidth: 160,
				 	xtype: 'uniCombobox',
				 	name: 'COST_POOL_CODE',
				 	store : Ext.StoreManager.lookup('costPoolCombo'),
			    	width:260
				},{
					labelWidth: 10,
					fieldLabel:' ',
				 	xtype: 'checkbox',
				 	boxLabel: 'Cost Pool 직과',
				 	name: 'COST_DIRECT'
				}]
			},{
				layout: {type:'uniTable', column:3},
				xtype: 'container',
				items: [{
					fieldLabel: '품목대/중/소분류(직과)',
			   		labelWidth: 160,				 	
				 	xtype: 'uniCombobox',
				 	name: 'ITEM_LEVEL1',
				 	store: Ext.data.StoreManager.lookup('itemLeve1Store'),
				 	child: 'ITEM_LEVEL2'
				},{
				 	xtype: 'uniCombobox',
				 	name: 'ITEM_LEVEL2',
				 	store: Ext.data.StoreManager.lookup('itemLeve2Store'),
				 	child: 'ITEM_LEVEL3'
				},{
				 	xtype: 'uniCombobox',
				 	name: 'ITEM_LEVEL3',
				 	store: Ext.data.StoreManager.lookup('itemLeve3Store')
				}]
			},{
				fieldLabel: 'Bar Code',			 	
			 	xtype: 'uniTextfield',
			 	name: 'BAR_CODE',
			    labelWidth: 160,
			    hidden: true,
			    width:375	
			}]
		},{
	    	xtype: 'container',
	    	layout: {type: 'uniTable', columns: 2,tdAttrs: {valign:'top'}},
	    	items: [{
				fieldLabel: '상각상태',
				name:'DPR_STS',	
				xtype: 'uniCombobox',
				allowBlank:false,
				comboType:'AU',
				comboCode:'A038',				
			    labelWidth: 160,
			    width:375,
			    colspan:2,
			    margin: '10 0 0 0'
			},{
				fieldLabel: '자산상태',
				name:'ASST_STS',	
				xtype: 'uniCombobox',
				allowBlank:false,
				comboType:'AU',
				comboCode:'A044',			
			    colspan:2,	
			    labelWidth: 160,
			    width:375                                                
			},{
				fieldLabel: '변경내역/상각내역 존재여부',
				name: 'EXIST_YN',
				xtype: 'uniTextfield',
				hidden: true
			},{
				fieldLabel: '국가보조금 상각내역 존재여부',
				name: 'EXIST_GOV_YN',
				xtype: 'uniTextfield',
				hidden: true
			},{
				xtype:'container',
				colspan:2,
				layout:{type: 'uniTable', columns: 2,tdAttrs: {valign:'top'}},
				items:[
					{
						
	                    fieldLabel: '배부:판관',
	                    xtype: 'uniNumberfield',
	                    name: 'SALE_MANAGE_COST',   
//	                    allowBlank:false,
	                    suffixTpl: '&nbsp;%&nbsp;',
	                    type: 'uniFC',
	                    labelWidth: 160,
	                    value: 0,
	                    width:240
	                },Unilite.popup('DEPT',{ 
					    fieldLabel: '귀속부서', 
					    valueFieldName:'SALE_MANAGE_DEPT_CODE',
					    textFieldName:'SALE_MANAGE_DEPT_NAME',
//					    validateBlank: false,
				   		labelWidth: 60,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									detailForm.setValue('SALE_MANAGE_DEPT_CODE', records[0]['TREE_CODE']);
									detailForm.setValue('SALE_MANAGE_DEPT_NAME', records[0]['TREE_NAME']);
		                    	},
								scope: this
							},
							onClear: function(type)	{
								detailForm.setValue('SALE_MANAGE_DEPT_CODE', '');
								detailForm.setValue('SALE_MANAGE_DEPT_NAME', '');
							}
						}
					})		
				]
			},{
				xtype:'container',
				layout:{type: 'uniTable', columns: 2,tdAttrs: {valign:'top'}},
				colspan:2,
				items:[
					{
	                	fieldLabel: '배부:제조',
					 	name: 'PRODUCE_COST',
						xtype: 'uniNumberfield',	            		
						suffixTpl: '&nbsp;%&nbsp;',
	                    type: 'uniFC',
//						allowBlank:false,	
	                    value: 0,	
	                    labelWidth: 160,			
						width:240
					},Unilite.popup('DEPT',{ 
					    fieldLabel: '귀속부서', 
					    valueFieldName:'PRODUCE_DEPT_CODE',
					    textFieldName:'PRODUCE_DEPT_NAME',
				   		labelWidth: 60,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									detailForm.setValue('PRODUCE_DEPT_CODE', records[0]['TREE_CODE']);
									detailForm.setValue('PRODUCE_DEPT_NAME', records[0]['TREE_NAME']);
		                    	},
								scope: this
							},
							onClear: function(type)	{
								detailForm.setValue('PRODUCE_DEPT_CODE', '');
								detailForm.setValue('PRODUCE_DEPT_NAME', '');
							}
						}
					})
				]
			},{
				xtype:'container',
				layout:{type: 'uniTable', columns: 2,tdAttrs: {valign:'top'}},
				colspan:2,
				items:[
					{
						fieldLabel: '배부:경상',
					 	xtype: 'uniNumberfield',
					 	name: 'SALE_COST',
					 	suffixTpl: '&nbsp;%&nbsp;',
	                    type: 'uniFC',
		                labelWidth: 160,
					 	width:240,
	                    value: 0									
					 },Unilite.popup('DEPT',{ 
						    fieldLabel: '귀속부서', 
						    valueFieldName:'SALE_DEPT_CODE',
						    textFieldName:'SALE_DEPT_NAME',
					   		labelWidth: 60,
							listeners: {
								onSelected: {
									fn: function(records, type) {
										detailForm.setValue('SALE_DEPT_CODE', records[0]['TREE_CODE']);
										detailForm.setValue('SALE_DEPT_NAME', records[0]['TREE_NAME']);
			                    	},
									scope: this
								},
								onClear: function(type)	{
									detailForm.setValue('SALE_DEPT_CODE', '');
									detailForm.setValue('SALE_DEPT_NAME', '');
								}
							}
					})		
				]
			},{
					xtype:'container',
					layout:{type: 'uniTable', columns: 2,tdAttrs: {valign:'top'}},
					colspan:2,
					items:[
						{
							 fieldLabel: '배부:도급',
						 	xtype: 'uniNumberfield',
						 	name: 'SUBCONTRACT_COST',
						 	suffixTpl: '&nbsp;%&nbsp;',
	                    	type: 'uniFC',
						 	width:240,
		                    labelWidth: 160,
		                    value: 0,
						 	readOnly: true										
						   
					    },Unilite.popup('DEPT',{ 
						    fieldLabel: '귀속부서', 
						    valueFieldName:'SUBCONTRACT_DEPT_CODE',
						    textFieldName:'SUBCONTRACT_DEPT_NAME',
					   		labelWidth: 60,
							listeners: {
								onSelected: {
									fn: function(records, type) {
										detailForm.setValue('SUBCONTRACT_DEPT_CODE', records[0]['TREE_CODE']);
										detailForm.setValue('SUBCONTRACT_DEPT_NAME', records[0]['TREE_NAME']);
			                    	},
									scope: this
								},
								onClear: function(type)	{
									detailForm.setValue('SUBCONTRACT_DEPT_CODE', '');
									detailForm.setValue('SUBCONTRACT_DEPT_NAME', '');
								}
							}
						})
					]
				},
			    	//2019.11.05 상각비 계정 팝업 : 자산부채특성 - Q4(상각비누계액)  계정만 표시 , 현재 이용하지 않으므로 hidden 처리
                    Unilite.popup('ACCNT',{
                    autoPopup: true,
                    hidden : true,
                    fieldLabel: '상각비계정',
                    valueFieldName: 'DEP_ACCNT', 
                    textFieldName: 'DEP_ACCNT_NAME', 
                    labelWidth: 160,           			
    			    colspan:2,	         
                    listeners: {
                        onSelected: {
                        
                        },
                        onClear: function(type) {
                            
                        },
                        applyextparam: function(popup){
                            popup.setExtParam({'ADD_QUERY': "SPEC_DIVI = 'Q4'"});            //WHERE절 추카 쿼리
    //                        popup.setExtParam({'CHARGE_CODE': gsChargeCode});           //bParam(3)         
                        }
                    }
                }), {
    			xtype: 'radiogroup',		            		
    			fieldLabel: '분할여부',	  
    			labelWidth: 160,			
			    colspan:2,	
    			items : [{
    				boxLabel: '예',
    				width:60 ,
    				name: 'PAT_YN', 
    				inputValue: 'Y'
    			}, {
    				boxLabel: '아니오', 
    				width:70 ,
    				name: 'PAT_YN' , 
    				inputValue: 'N',
                    checked: true
    			}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
//						panelResult.getField('RDO').setValue(newValue.RDO);
					}
				}
            }, {
    			xtype: 'radiogroup',		            		
    			fieldLabel: '손상처리대상여부',	   
    			labelWidth: 160,			
			    colspan:2,	
    			items : [{
    				boxLabel: '예',
    				width:60 ,
    				name: 'DMG_OJ_YN', 
    				inputValue: 'Y'
    			}, {
    				boxLabel: '아니오', 
    				width:70 ,
    				name: 'DMG_OJ_YN' , 
    				inputValue: 'N',
                    checked: true
    			}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
//						panelResult.getField('RDO').setValue(newValue.RDO);
					}
				}
            }, {
    			xtype: 'radiogroup',		            		
    			fieldLabel: '회수가능액측정방법',	
    			hidden: true,
    			labelWidth: 160,			
			    colspan:2,	
    			items : [{
    				boxLabel: '자산별',
    				width:60 ,
    				name: 'WDAMT_MTD', 
    				inputValue: '1',
    				checked: true
    			}, {
    				boxLabel: 'CGU별(현금창출단위)', 
    				width:150 ,
    				name: 'WDAMT_MTD' , 
    				inputValue: '2'
    			}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
//						panelResult.getField('RDO').setValue(newValue.RDO);
					}
				}
            },{
				xtype:'container',
				padding: '5 0 0 50',
				html: '<b>[상각누적정보]</b>',			
			    colspan:2,	
				style: {
					color: 'blue'				
				}
			},{
			 	fieldLabel: '자본적지출',
			 	xtype: 'uniNumberfield',
			 	name: 'FI_CAPI_TOT_I',
			    labelWidth: 160,
			    width:305
			},{
			 	fieldLabel: '상각누계액',
			 	xtype: 'uniNumberfield',
			 	name: 'FI_DPR_TOT_I',
			    labelWidth: 90,
			    width:235
			},{
			 	fieldLabel: '매각폐기전 미상각잔액',
			 	xtype: 'uniNumberfield',
			 	name: 'FI_SALE_TOT_I',
			    labelWidth: 160,
			    width:305
			},{
			 	fieldLabel: '손상차손누계액',
			 	xtype: 'uniNumberfield',
			 	name: 'FI_DMGLOS_TOT_I',                                                                                                                                                                                                                                                                               
			    labelWidth: 90,
			    width:235
			},{
			 	fieldLabel: '매각폐기전 상각누계액',
			 	xtype: 'uniNumberfield',
			 	name: 'FI_SALE_DPR_TOT_I',
			    labelWidth: 160,
			    width:305
			},{
			 	fieldLabel: '미상각잔액',
			 	xtype: 'uniNumberfield',
			 	name: 'FL_BALN_I',
			 	//allowBlank:false,
			    labelWidth: 90,
			    width:235
			},{
			 	fieldLabel: '국고보조금 누적차감액',
			 	xtype: 'uniNumberfield',
			 	name: 'GOV_GRANT_DPR_TOT_I',	    
		    	hidden : !useGovGrantCont,
		    	labelWidth: 160,
		    	readOnly : true,
			    width:305
			},{
			 	fieldLabel: '국고보조금 미차감잔액',
			 	xtype: 'uniNumberfield',
			 	name: 'GOV_GRANT_BALN_I',	    
		    	hidden : !useGovGrantCont,
			 	//allowBlank:false,
			    labelWidth: 130,
		    	readOnly : true,
			    width:235
			},{
			 	fieldLabel: '재평가액',
			 	xtype: 'uniNumberfield',
			 	name: 'FI_REVAL_TOT_I',
			    labelWidth: 160,			
			    colspan:2,	
			    width:375
			},{
			 	fieldLabel: '재평가상각감소액',
			 	xtype: 'uniNumberfield',
			 	name: 'FI_REVAL_DPR_TOT_I',
			    labelWidth: 160,			
			    colspan:2,	
			    width:375
			},{
				layout: {type:'uniTable', column:2},
				xtype: 'container',			
			    colspan:2,	
				items: [{
					fieldLabel: '매각/폐기년월-여부',
			    	labelWidth: 160,
					xtype: 'uniMonthfield',
					name: 'WASTE_YYYYMM',
					flex:2,
			    	width:260
				},{				 	
				 	xtype: 'uniCombobox',
				 	comboType:'AU',
					comboCode:'A035',					
				 	name: 'WASTE_SW',
				 	flex:1,
			    	width:115
				}]
			},{
				layout: {type:'uniTable', column:2},
				xtype: 'container',			
			    colspan:2,	
				items: [{
					fieldLabel: '상각완료년월-여부',
					name: 'DPR_YYYYMM',
			    	labelWidth: 160,
					xtype: 'uniMonthfield',
					flex:2,
			    	width:260
				},{				 	
				 	xtype: 'uniCombobox',
				 	comboType:'AU',
					comboCode:'A035',					
				 	name: 'DPR_STS2',
				 	flex:1,
			    	width:115
				}]
			},{
				xtype:'container',
				padding: '5 0 0 50',
				html: '<b>[취득전표정보]</b>',			
			    colspan:2,	
				style: {
					color: 'blue'				
				}
			},{
				fieldLabel: '결제유형',
			 	xtype: 'uniCombobox',
			 	comboType:'AU',
				comboCode:'A140',
			 	name: 'SET_TYPE',
		    	labelWidth: 160,			
			    colspan:2,	
			    width:375,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
//						if(oldValue){
							UniAppManager.app.fnSetPropertiesbySetType(newValue);	//선택된 결제유형에 따라 입력란 속성 설정
//						}							
					}
				}
			},{
				fieldLabel: '증빙유형',
			 	xtype: 'uniCombobox',
			 	comboType:'AU',
				comboCode:'A022',
			 	name: 'PROOF_KIND',			
			    colspan:2,	
		    	labelWidth: 160,
			    width:375,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
//						if(oldValue){
							UniAppManager.app.fnSetPropertiesbyProofKind();	//선택된 증빙유형에 따라 불공제사유 입력란 속성 설정
							UniAppManager.app.fnSetTaxAmt();
//						}							
					}
				}
			},{
				layout: {type:'uniTable', column:2},
				xtype: 'container',			
			    colspan:2,	
				items: [{
					fieldLabel: '공급가액/세액',
			    	labelWidth: 160,				 	
				 	xtype: 'uniNumberfield',
				 	name: 'SUPPLY_AMT_I',
				 	flex:2,
			   		width:260
				},{
				 	xtype: 'uniNumberfield',
				 	name: 'TAX_AMT_I',
				 	flex:1,
			    	width:115
				}]
			},
				Unilite.popup('CUST',{
					autoPopup: true,			
				    colspan:2,	
				    fieldLabel: '전표 거래처',
				    valueFieldName:'AC_CUSTOM_CODE',
				    textFieldName:'AC_CUSTOM_NAME',
//				    DBvalueFieldName: 'AC_CUSTOM_CODE',
//				    DBtextFieldName: 'AC_CUSTOM_NAME',
//				    textFieldWidth: 170, 
//				    validateBlank: false,
			    	labelWidth: 160
			}),
				Unilite.popup('BANK_BOOK',{
					autoPopup: true,
				    fieldLabel: '통장번호', 
				    valueFieldName:'BANK_BOOK_CODE',
				    textFieldName:'BANK_BOOK_NAME',			
				    colspan:2,	
//				    textFieldWidth: 170, 
//				    validateBlank: false,
			    	labelWidth: 160
			}),
				Unilite.popup('CREDIT_NO',{
					autoPopup: true,
				    fieldLabel: '신용카드번호', 
				    valueFieldName:'CRDT_NUM',
				    textFieldName:'CRDT_NAME',			
				    colspan:2,	
//				    DBvalueFieldName: 'CRDT_NUM',
//				    DBtextFieldName: 'CRDT_NAME',
//				    textFieldWidth: 170, 
//				    validateBlank: false,
			    	labelWidth: 160
			}),{
				fieldLabel: '불공제사유',
				name: 'REASON_CODE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'A070',			
			    colspan:2,	
				
			    labelWidth: 160,
			    width:375
			},{
				layout: {type:'uniTable', column:2},
				xtype: 'container',			
			    colspan:2,	
				items: [{
					fieldLabel: '지급예정일/전자발행여부',
			    	labelWidth: 160,				 	
				 	xtype: 'uniDatefield',
				 	name: 'PAY_DATE',
				 	flex:2,
			    	width:260
				},{				 	
				 	xtype: 'uniCombobox',
				 	name: 'EB_YN',
				 	comboType:'AU',
					comboCode:'A149',
					flex:1,
			    	width:115	
				}]
			},{
				layout: {type:'uniTable', column:2},
				xtype: 'container',							
			    colspan:2,	
				items: [{
					fieldLabel: '결의일자/번호',
			    	labelWidth: 160,				 	
				 	xtype: 'uniTextfield',
				 	name: 'EX_DATE',
				 	flex:2,
			    	width:260,
			    	readOnly: true
				},{				 	
				 	xtype: 'uniTextfield',
				 	name: 'EX_NUM',
				 	flex:1,
			    	width:115,
			    	readOnly: true
				}]
			},{
				xtype: 'uniTextfield',
				name: 'SAVE_FLAG',			
			    colspan:2,	
				hidden: true
			},{
				xtype: 'uniTextfield',
				name: 'AUTO_TYPE',			
			    colspan:2,	
				value: BsaCodeInfo.gsAutocd,
				hidden: true
			}]
		}],
			api: {
     		 load: 'aiss300ukrService.selectMaster',
			 submit: 'aiss300ukrService.syncMaster'				
			},
		listeners : {
			uniOnChange:function( basicForm, field, newValue, oldValue ) {
				console.log("onDirtyChange");
				if(basicForm.isDirty()/* && validateFlag == "1"*/ && newValue != oldValue && !detailForm.uniOpt.inLoading)	{
					UniAppManager.setToolbarButtons('save', true);
					/* var rv = true;
					switch(field.name) {
						case "DRB_YEAR" :		//내용년수
							if(Ext.isEmpty(newValue)) {
								detailForm.setValue('DPR_RATE', '');
								break;
							}
							if(isNaN(newValue)){
								Unilite.messageBox( Msg.sMB074);
								rv = false;
								break;
							}
							if(newValue < 0 && !Ext.isEmpty(newValue))	{
								Unilite.messageBox( Msg.sMB076);
								rv = false;
								break;
							}
							if(newValue < 2 || newValue > 60){
								Unilite.messageBox('내용년수는 2~60 사이의 정수만 입력 가능합니다.');
								rv = false;
								break;
							}
							var drbYear = '000' + detailForm.getValue('DRB_YEAR') 
							drbYear = drbYear.substring(drbYear.length-3)
							var param = {DRB_YEAR: drbYear, ACCNT: detailForm.getValue('ACCNT')}
							accntCommonService.fnGetDprRate(param, function(provider, response)	{
								if(Ext.isEmpty(provider.DPR_RATE)){
									alert(detailForm.getValue('ACCNT_NAME') + '에 해당하는 상각방법이 등록되어 있지 않습니다.' + '\n' + '상각방법을 등록하셔야 저장할 수 있습니다.');
								}else{
									detailForm.setValue('DPR_RATE', provider.DPR_RATE / 1000);
								}
							});
						break;
						
						case "EXCHG_RATE_O" :	//환율
							if(isNaN(newValue)){
								Unilite.messageBox( Msg.sMB074);
								rv = false;
								break;
							}
							if(newValue < 0 && !Ext.isEmpty(newValue))	{
								Unilite.messageBox( Msg.sMB076);
								rv = false;
								break;
							}
							UniAppManager.app.fnCalAcqAmtI();		//취득가액계산
							UniAppManager.app.fnComputeFiBaln();	//미상각잔액 반영
							detailForm.setValue('H_ACQ_AMT_I', newValue);
						break;
						
						case "FOR_ACQ_AMT_I" :		//외화취득가액
							if(isNaN(newValue)){
								Unilite.messageBox( Msg.sMB074);
								rv = false;
								break;
							}
							if(newValue < 0 && !Ext.isEmpty(newValue))	{
								Unilite.messageBox( Msg.sMB076);
								rv = false;
								break;
							}
							UniAppManager.app.fnCalAcqAmtI();		//취득가액계산
							UniAppManager.app.fnComputeFiBaln();	//미상각잔액 반영
							if(!Ext.isEmpty(detailForm.getValue('SET_TYPE'))){
								UniAppManager.app.fnSetPropertiesbySetType();	//선택된 결제유형에 따라 입력란 속성 설정
								UniAppManager.app.fnSetTaxAmt();
							}
							
						break;	
						
						case "ACQ_AMT_I" :		//취득가액
							if(isNaN(newValue)){
								Unilite.messageBox( Msg.sMB074);
								rv = false;
								break;
							}
							if(newValue < 0 && !Ext.isEmpty(newValue))	{
								Unilite.messageBox( Msg.sMB076);
								rv = false;
								break;
							}
							UniAppManager.app.fnComputeFiBaln();	//미상각잔액 반영
							if(!Ext.isEmpty(detailForm.getValue('SET_TYPE'))){
								UniAppManager.app.fnSetPropertiesbySetType();	//선택된 결제유형에 따라 입력란 속성 설정
								UniAppManager.app.fnSetTaxAmt();
							}
						break;
						
						case "ACQ_Q" :	//취득수량
							detailForm.setValue('STOCK_Q', newValue);
						break;
						
						case "SALE_MANAGE_COST" :	//배부
							if(!UniAppManager.app.fnGetSaleCost()){
								Unilite.messageBox( '경비비율의 합은 100을 초과할 수 없습니다.');
								rv = false;
							}				
						break;
						
						case "PRODUCE_COST" :	//제조원가
							if(!UniAppManager.app.fnGetSaleCost()){
								Unilite.messageBox('경비비율의 합은 100을 초과할 수 없습니다.');
								rv = false;
							}
						break;
						
						case "FI_CAPI_TOT_I" :	//자본적지출
							UniAppManager.app.fnComputeFiBaln();	//미상각잔액 반영
						break;
						
						case "FI_SALE_TOT_I" :	//매각폐기전 미상각잔액
							UniAppManager.app.fnComputeFiBaln();	//미상각잔액 반영
						break;
						
						case "FI_SALE_DPR_TOT_I" :	//매각폐기전 상각누계액
							UniAppManager.app.fnComputeFiBaln();	//미상각잔액 반영
						break;
						
						case "FI_DPR_TOT_I" :	//상각누계액
							UniAppManager.app.fnComputeFiBaln();	//미상각잔액 반영
						break;
						case "FI_REVAL_TOT_I" :	//재평가액
							UniAppManager.app.fnComputeFiBaln();	//미상각잔액 반영
						break;
						case "FI_DMGLOS_TOT_I" :	//손상차손누계액
							UniAppManager.app.fnComputeFiBaln();	//미상각잔액 반영
						break;
						case "SUPPLY_AMT_I" :	//공급가액/세액
							UniAppManager.app.fnSetTaxAmt();
						break;	
						default:
						break;
					}
				
					if(!rv)	{
						field.setValue(oldValue);
					}
					return rv; */
					
				}else {
					//UniAppManager.setToolbarButtons('save', false);
				}
//				validateFlag = '1';
			},
			beforeaction:function(basicForm, action, eOpts)	{
				
//				if(action.type =='directsubmit')	{
//					var invalid = this.getForm().getFields().filterBy(function(field) {
//					            return !field.validate();
//					    });
//		         	if(invalid.length > 0)	{
//			        	r=false;
//			        	var labelText = ''
//			        	
//			        	if(Ext.isDefined(invalid.items[0]['fieldLabel']))	{
//			        		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
//			        	}else if(Ext.isDefined(invalid.items[0].ownerCt))	{
//			        		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
//			        	}
//			        	alert(labelText+Msg.sMB083);
//			        	invalid.items[0].focus();
//			        }																									
//				}
			}
		},		
	    setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
//				validateFlag = '2';
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
				}
	  		}
//	  		validateFlag = '1';
			return r;
  		}
	});

         
    
	

    /**
	 * main app
	 */
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				detailForm, panelResult
			]	
		}		
		,panelSearch
		],
		id: 'aiss300ukrApp',
		fnInitBinding : function(params) {
			detailForm.getField("ASST").setReadOnly(isAutoAssetNum);
			this.setDefault();

			detailForm.setValue("MONEY_UNIT",BsaCodeInfo.gsMoneyUnit);
			UniAppManager.app.fnSetPropertiesbySetType();	//선택된 결제유형에 따라 입력란 속성 설정
//			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('save', false);
			UniAppManager.setToolbarButtons('delete',false);
			UniAppManager.setToolbarButtons('reset', true);
			this.processParams(params);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('ASSET_CODE');
		},
		processParams: function(params) {
//			this.uniOpt.appParams = params;			
			if(params && params.ASST && params.ASST_NAME) {
				if(params.PGM_ID == 'agd320ukr' || params.PGM_ID == 'ass500ukr' || params.PGM_ID == 'ass600skr'|| params.PGM_ID == 'aiss300skrv'){//고정자산변동내역조회, 고정자산취득자동기표, 고정자산대장조회
					panelSearch.setValue('ASSET_CODE', params.ASST);
					panelSearch.setValue('ASSET_NAME', params.ASST_NAME);
					panelResult.setValue('ASSET_CODE', params.ASST);
					panelResult.setValue('ASSET_NAME', params.ASST_NAME);
				}
				UniAppManager.app.onQueryButtonDown(params);
			}
		},
		onQueryButtonDown:function (params) {
			if(!this.isValidSearchForm()){
				return false;
			}
			var param= panelSearch.getValues();
			if(Ext.isEmpty(params)){
				detailForm.reset();
				detailForm.getEl().mask('로딩중...','loading-indicator');
			}
			detailForm.clearForm();
			detailForm.uniOpt.inLoading=true; 
			detailForm.getForm().load({ 
				params: param,
				success:function()	{					
					detailForm.getEl().unmask();
					UniAppManager.setToolbarButtons('delete',true);					
					detailForm.getField("ASST").setReadOnly(true);
					detailForm.setValue('SAVE_FLAG','U');
					detailForm.setDisabled(false);
					UniAppManager.app.fnLockInputFields(false);
					setTimeout(function(){detailForm.uniOpt.inLoading=false},500);
					UniAppManager.setToolbarButtons('save',false);
					
//					detailForm.getForm().load({ 
//                        params: param,
//                        success:function()  {                   
//                            detailForm.getEl().unmask();
//                            UniAppManager.setToolbarButtons('delete',true);                 
//                            detailForm.getField("ASST").setReadOnly(true);
//                            detailForm.setValue('SAVE_FLAG','U');
//                            detailForm.setDisabled(false);
//                            UniAppManager.setToolbarButtons('save',false);
//                            UniAppManager.app.fnLockInputFields(false);
//                            detailForm.uniOpt.inLoading=false;
//                        },
//                        failure: function(form, action) {
//                            detailForm.getEl().unmask();
//                            UniAppManager.app.onResetButtonDown();
//                            UniAppManager.setToolbarButtons('save',false);
//                        }
//                    });
				},
				failure: function(form, action) {
                    detailForm.getEl().unmask();
					UniAppManager.app.onResetButtonDown();
					UniAppManager.setToolbarButtons('save',false);
                }
			});
			UniAppManager.app.fnSetPropertiesbySetType();
			
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			detailForm.clearForm();
			this.fnInitBinding();
			detailForm.setDisabled(false);
			
			UniAppManager.app.fnLockInputFields(false);
		},
		onDeleteDataButtonDown: function() {
			if(!Ext.isEmpty(detailForm.getValue('EX_DATE'))){
				alert('고정자산취득자동기표에서 기표취소 후 작업이 가능합니다.');
				return false;
			}
			
			var param= detailForm.getValues();
			aiss300ukrService.selecChktDep(param, function(responseText, provider ) {
				if(!Ext.isEmpty(detailForm.getValue("ASST")) && responseText && responseText.CNT > 0) {
					Unilite.messageBox("이미 감가상각 계산이 완료되어 삭제 할 수 없습니다.")
					UniAppManager.app.onQueryButtonDown();
					return;
				}
				if(confirm('현재 데이터를 삭제 합니다.\n 삭제 하시겠습니까?')) {
					detailForm.setValue('SAVE_FLAG','D');
					var param = detailForm.getValues();
					detailForm.getEl().mask('로딩중...','loading-indicator');				
					detailForm.submit({
						params: param,
						success:function(comp, action)	{
							UniAppManager.setToolbarButtons('save', false);
							UniAppManager.updateStatus(Msg.sMB011);
							detailForm.getEl().unmask();
							UniAppManager.app.onResetButtonDown();
						},
						failure: function(form, action){
							detailForm.getEl().unmask();
						}
					});	
				}
			})
		},
		onSaveDataButtonDown: function (config) {
			if(!detailForm.setAllFieldsReadOnly(true)){
				return false;
			}
			var param= detailForm.getValues();
			param.SAVE_CODE = param.BANK_BOOK_CODE;
			if(Ext.isEmpty(detailForm.getValue('PRODUCE_COST')) && Ext.isEmpty(detailForm.getValue('SALE_MANAGE_COST'))){
				alert('배부:판매/제조/사업은(는)필수입력 항목입니다.');
				detailForm.getField('PRODUCE_COST').focus();
				return false;
			}
			
			var blnI	= detailForm.getValue('FL_BALN_I');
			var wasteYM	= detailForm.getValue('WASTE_YYYYMM');
			var wasteSW	= detailForm.getValue('WASTE_SW');
			var asstSts	= detailForm.getValue('ASST_STS');
			
			if(!(!Ext.isEmpty(wasteYM) || wasteSW == 'Y' || asstSts == '3')) {
				if(Ext.isEmpty(blnI)) {
					alert('미상각잔액은 필수입력 항목입니다.');
					return;
				}
			}
			
			detailForm.getEl().mask('로딩중...','loading-indicator');	
//			aiss300ukrService.selecChktDep(param, function(responseText, provider ) {
//				if(!Ext.isEmpty(detailForm.getValue("ASST")) && responseText && responseText.CNT > 0) {
//					Unilite.messageBox("이미 감가상각 계산이 완료되어 수정 할 수 없습니다.")
//					UniAppManager.app.onQueryButtonDown();
//					return;
//				}
				detailForm.submit({
					 params : param,
					 success : function(form, action) {
		 					detailForm.getForm().wasDirty = false;
							detailForm.resetDirtyStatus();
							UniAppManager.setToolbarButtons('save', false);	
							UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.
							detailForm.getEl().unmask();
							detailForm.setValue('SAVE_FLAG', 'U');
							detailForm.getField("ASST").setReadOnly(true);
							if(detailForm.getValue('AUTO_TYPE') == "Y"){
								if(Ext.isEmpty(action.result.AUTO_ASST)){
									panelSearch.setValue('ASSET_CODE', detailForm.getValue("ASST"));
									panelResult.setValue('ASSET_CODE', detailForm.getValue("ASST"));
								}else{
									panelSearch.setValue('ASSET_CODE', action.result.AUTO_ASST);
									panelResult.setValue('ASSET_CODE', action.result.AUTO_ASST);
								}
							}else{
								panelSearch.setValue('ASSET_CODE', detailForm.getValue("ASST"));
								panelResult.setValue('ASSET_CODE', detailForm.getValue("ASST"));
							} 
							panelSearch.setValue('ASSET_NAME', detailForm.getValue("ASST_NAME"));
							panelResult.setValue('ASSET_NAME', detailForm.getValue("ASST_NAME"));
							UniAppManager.app.onQueryButtonDown();
					},
					failure: function(form, action) {
						detailForm.getEl().unmask();
					}
				});
//			});
		},
		setDefault: function() {
			detailForm.setValue('SAVE_FLAG', 'N');					//자산구분
			detailForm.setValue('ASST_DIVI', '1');					//자산구분
			detailForm.setValue('DIV_CODE', UserInfo.divCode);		//사업장
//			detailForm.setValue('MONEY_UNIT', BsaCodeInfo.gsMoneyUnit);	//화폐단위
			detailForm.setValue('EXCHG_RATE_O', '1');				//환율:1
			detailForm.setValue('DPR_STS', '1');					//상각상태:정상상각
			detailForm.setValue('WASTE_SW', 'N');					//매각/폐기여부:미완료
			detailForm.setValue('DPR_STS2', 'N');					//상각완료여부:미완료
			detailForm.setValue('ACQ_DATE', UniDate.get('today'));					//상각완료여부:미완료
			detailForm.setValue('USE_DATE', UniDate.get('today'));					//상각완료여부:미완료
			detailForm.setValue('AUTO_TYPE', BsaCodeInfo.gsAutocd);				//자동채번 여부
			detailForm.setValue('SALE_COST', 0);            
			detailForm.setValue('SUBCONTRACT_COST', 0); 
			detailForm.setValue('PRODUCE_COST', 0);             
			detailForm.setValue('SALE_MANAGE_COST', 100);
			detailForm.setValue('ASST_STS', '1');
		},
		fnCalAcqAmtI: function(){
			var exchgRateO = detailForm.getValue('EXCHG_RATE_O');
			var forAcqAmtI = detailForm.getValue('FOR_ACQ_AMT_I');
			
			if( Ext.isEmpty(exchgRateO) || Ext.isEmpty(forAcqAmtI) || forAcqAmtI == 0) {
				return;
			}
			
			detailForm.setValue('ACQ_AMT_I', exchgRateO * forAcqAmtI);
		},
		fnComputeFiBaln: function(){	 		 
			var sAcqAmtI 		= Unilite.nvl(detailForm.getValue('ACQ_AMT_I'),0);        	//	취득가액
			var sFiCapiTotI 	= Unilite.nvl(detailForm.getValue('FI_CAPI_TOT_I'),0);    	//자본적지출
			var sFiSaleTotI		= Unilite.nvl(detailForm.getValue('FI_SALE_TOT_I'),0);    	//매각폐기전 미상각잔액
			var sFiDprTotI 		= Unilite.nvl(detailForm.getValue('FI_DPR_TOT_I'),0);     	//상각누계액
			var sFiSaleDprTotI 	= Unilite.nvl(detailForm.getValue('FI_SALE_DPR_TOT_I'),0);	//매각폐기전 상각누계액
			var sFiDmglosTotI 	= Unilite.nvl(detailForm.getValue('FI_DMGLOS_TOT_I'),0); 	//손상차손누계액
			
			if(Ext.isEmpty(detailForm.getValue('FI_REVAL_TOT_I')) || detailForm.getValue('FI_REVAL_TOT_I') == 0)	{
				detailForm.setValue('FL_BALN_I', sAcqAmtI + sFiCapiTotI - sFiSaleTotI - sFiDprTotI - sFiSaleDprTotI - sFiSaleDprTotI);
			} else {
				detailForm.setValue('FL_BALN_I', detailForm.getValue('FI_REVAL_TOT_I') - sFiDmglosTotI);
			}
			
		},
		fnLockInputFields: function(b){
			if(detailForm.getValue('SAVE_FLAG') == "U" || BsaCodeInfo.gsAutocd == "Y"){
				detailForm.getField('ASST').setReadOnly(true);				
			}else{
				detailForm.getField('ASST').setReadOnly(b);
			}
			
			detailForm.getField('ASST_NAME').setReadOnly(b);
			detailForm.getField('SPEC').setReadOnly(b);
			detailForm.getField('SERIAL_NO').setReadOnly(b);			
			
			if(detailForm.getValue('EXIST_YN') == "Y"){
				detailForm.getField('ACCNT').setReadOnly(true);
				detailForm.getField('ACCNT_NAME').setReadOnly(true);
				detailForm.getField('ASST_DIVI').setReadOnly(true);
				detailForm.getField('DEP_CTL').setReadOnly(true);
				
			}else{
				detailForm.getField('ACCNT').setReadOnly(b);
				detailForm.getField('ACCNT_NAME').setReadOnly(b);
				detailForm.getField('ASST_DIVI').setReadOnly(b);
				detailForm.getField('DEP_CTL').setReadOnly(b);
			}
			detailForm.getField('DIV_CODE').setReadOnly(b);
			detailForm.getField('DEPT_CODE').setReadOnly(b);
			detailForm.getField('DEPT_NAME').setReadOnly(b);
			detailForm.getField('PURCHASE_DEPT_CODE').setReadOnly(b);
			detailForm.getField('PURCHASE_DEPT_NAME').setReadOnly(b);
			detailForm.getField('PJT_CODE').setReadOnly(b);
			detailForm.getField('PJT_NAME').setReadOnly(b);
//			detailForm.getField('DPR_RATE').setReadOnly(b);
			
			if(detailForm.getValue('EXIST_YN') == "Y"){
				detailForm.getField('MONEY_UNIT').setReadOnly(true);
				detailForm.getField('EXCHG_RATE_O').setReadOnly(true);
				detailForm.getField('FOR_ACQ_AMT_I').setReadOnly(true);
				detailForm.getField('ACQ_AMT_I').setReadOnly(true);
				detailForm.getField('ACQ_Q').setReadOnly(true);
				detailForm.getField('STOCK_Q').setReadOnly(true);
				detailForm.getField('ACQ_DATE').setReadOnly(true);
				detailForm.getField('USE_DATE').setReadOnly(true);
				detailForm.getField('DRB_YEAR').setReadOnly(true);
			}else{
				detailForm.getField('MONEY_UNIT').setReadOnly(b);
				detailForm.getField('EXCHG_RATE_O').setReadOnly(b);
				detailForm.getField('FOR_ACQ_AMT_I').setReadOnly(b);
				detailForm.getField('ACQ_AMT_I').setReadOnly(b);
				detailForm.getField('ACQ_Q').setReadOnly(b);
				detailForm.getField('STOCK_Q').setReadOnly(b);
				detailForm.getField('ACQ_DATE').setReadOnly(b);
				detailForm.getField('USE_DATE').setReadOnly(b);
				detailForm.getField('DRB_YEAR').setReadOnly(b);
			}
			detailForm.getField('QTY_UNIT').setReadOnly(b);
			detailForm.getField('PERSON_NUMB').setReadOnly(b);
			detailForm.getField('NAME').setReadOnly(b);
			detailForm.getField('PLACE_INFO').setReadOnly(b);
			detailForm.getField('CUSTOM_CODE').setReadOnly(b);
			detailForm.getField('CUSTOM_NAME').setReadOnly(b);
			detailForm.getField('MAKER_NAME').setReadOnly(b);
			detailForm.getField('BAR_CODE').setReadOnly(b);
			detailForm.getField('REMARK').setReadOnly(b);
			detailForm.getField('DPR_STS').setReadOnly(b);
			detailForm.getField('SALE_MANAGE_COST').setReadOnly(b);
			detailForm.getField('PRODUCE_COST').setReadOnly(b);
			//detailForm.getField('SALE_COST').setReadOnly(b);
			detailForm.getField('ASST_STS').setReadOnly(b);
			detailForm.getField('PAT_YN').setReadOnly(b);
			detailForm.getField('DMG_OJ_YN').setReadOnly(b);
			detailForm.getField('WDAMT_MTD').setReadOnly(b);
			
			if(detailForm.getValue('EXIST_YN') == "Y"){
				detailForm.getField('FI_CAPI_TOT_I').setReadOnly(true);
				detailForm.getField('FI_SALE_TOT_I').setReadOnly(true);
				detailForm.getField('FI_SALE_DPR_TOT_I').setReadOnly(true);
				detailForm.getField('FI_DPR_TOT_I').setReadOnly(true);
				detailForm.getField('FL_BALN_I').setReadOnly(true);
				detailForm.getField('WASTE_YYYYMM').setReadOnly(true);
				detailForm.getField('WASTE_SW').setReadOnly(true);
				detailForm.getField('DPR_YYYYMM').setReadOnly(true);
				detailForm.getField('DPR_STS2').setReadOnly(true);
				
				detailForm.getField('FI_REVAL_TOT_I').setReadOnly(true);
				detailForm.getField('FI_REVAL_DPR_TOT_I').setReadOnly(true);
				detailForm.getField('FI_DMGLOS_TOT_I').setReadOnly(true);
			}else{
				detailForm.getField('FI_CAPI_TOT_I').setReadOnly(b);
				detailForm.getField('FI_SALE_TOT_I').setReadOnly(b);
				detailForm.getField('FI_SALE_DPR_TOT_I').setReadOnly(b);
				detailForm.getField('FI_DPR_TOT_I').setReadOnly(b);
				detailForm.getField('FL_BALN_I').setReadOnly(b);
				detailForm.getField('WASTE_YYYYMM').setReadOnly(b);
				detailForm.getField('WASTE_SW').setReadOnly(b);
				detailForm.getField('DPR_YYYYMM').setReadOnly(b);
				detailForm.getField('DPR_STS2').setReadOnly(b);
				
				detailForm.getField('FI_REVAL_TOT_I').setReadOnly(b);
				detailForm.getField('FI_REVAL_DPR_TOT_I').setReadOnly(b);
				detailForm.getField('FI_DMGLOS_TOT_I').setReadOnly(b);
			}
			detailForm.getField('SET_TYPE').setReadOnly(b);
			//국가보조금
			if( !b &&  detailForm.getValue('EXIST_GOV_YN') == "Y"){
				detailForm.getField('GOV_GRANT_ACCNT').setReadOnly(true);
				detailForm.getField('GOV_GRANT_ACCNT_NAME').setReadOnly(true);
				detailForm.getField('GOV_GRANT_AMT_I').setReadOnly(true);
				detailForm.getField('GOV_GRANT_DPR_TOT_I').setReadOnly(true);
				detailForm.getField('GOV_GRANT_BALN_I').setReadOnly(true);
			} else {
				detailForm.getField('GOV_GRANT_ACCNT').setReadOnly(false);
				detailForm.getField('GOV_GRANT_ACCNT_NAME').setReadOnly(false);
				detailForm.getField('GOV_GRANT_AMT_I').setReadOnly(false);
				detailForm.getField('GOV_GRANT_DPR_TOT_I').setReadOnly(false);
				detailForm.getField('GOV_GRANT_BALN_I').setReadOnly(false);
			}
			
			
		},
		fnSetPropertiesbySetType: function(setType){
			var cboSetType = detailForm.getField('SET_TYPE');					//결제유형
			var cboProofKind = detailForm.getField('PROOF_KIND');				//증빙유형
			var txtSupplyAmt = detailForm.getField('SUPPLY_AMT_I');				//공급가액
			var txtTaxAmt = detailForm.getField('TAX_AMT_I');					//세액
			var txtAcCustomCode = detailForm.getField('AC_CUSTOM_CODE');		//전표 거래처코드
			var txtAcCustomName = detailForm.getField('AC_CUSTOM_NAME');		//전표 거래처명
			var CboEbYn = detailForm.getField('EB_YN');							//전자발행여부
			
			var txtSaveCode = detailForm.getField('BANK_BOOK_CODE');			//통장번호
			var txtSaveName = detailForm.getField('BANK_BOOK_NAME');			//통장명
			var txtCrdtNum = detailForm.getField('CRDT_NUM');					//신용카드번호
			var txtCrdtName = detailForm.getField('CRDT_NAME');					//신용카드명
			
			var cboReasonCode = detailForm.getField('REASON_CODE');				//불공제사유
			
			if(Ext.isEmpty(detailForm.getValue('SET_TYPE'))){				   
				cboProofKind.setReadOnly(true);   
				txtSupplyAmt.setReadOnly(true);   
				txtTaxAmt.setReadOnly(true);      
				txtAcCustomCode.setReadOnly(true);
				txtAcCustomName.setReadOnly(true);
				CboEbYn.setReadOnly(true);	
				txtSaveCode.setReadOnly(true);
				txtSaveName.setReadOnly(true);
				txtCrdtNum.setReadOnly(true);
				txtCrdtName.setReadOnly(true);
				cboReasonCode.setReadOnly(true);
			}
			if(Ext.isEmpty(setType))	{
				setType = detailForm.getValue("SET_TYPE");
			}
			var param = {
					'MAIN_CODE':'A140',
	   				'SUB_CODE':setType,
		   			'field':'refCode1'
			}
			var gsSetTypeRef1= UniAccnt.fnGetRefCode(param);

			if(!Ext.isEmpty(setType)){
							
				cboSetType.setReadOnly(false);     
				cboProofKind.setReadOnly(false);   
				txtSupplyAmt.setReadOnly(false);   
				txtTaxAmt.setReadOnly(false);      
				txtAcCustomCode.setReadOnly(false);
				txtAcCustomName.setReadOnly(false);
				CboEbYn.setReadOnly(false);
				
				if(gsSetTypeRef1 == "20"){	//예금
					txtSaveCode.setReadOnly(false);
					txtSaveName.setReadOnly(false);
					txtCrdtNum.setReadOnly(true);
					txtCrdtName.setReadOnly(true);
				}else if(gsSetTypeRef1 == "30"){	//카드
					txtSaveCode.setReadOnly(true);
					txtSaveName.setReadOnly(true);
					txtCrdtNum.setReadOnly(false);
					txtCrdtName.setReadOnly(false);
				}else{
					txtSaveCode.setReadOnly(true);
					txtSaveName.setReadOnly(true);
					txtCrdtNum.setReadOnly(true);
					txtCrdtName.setReadOnly(true);
				}
				
				if(detailForm.getValue('PROOF_KIND') == "54" || detailForm.getValue('PROOF_KIND') == "61"){
					cboReasonCode.setReadOnly(false);
				}else{
					cboReasonCode.setReadOnly(true);
				}
			}
		},
		fnSetTaxAmt: function(){
			var dTaxRate = 0;
			var dTax_Amt = 0;
			
			var proofkind = detailForm.getValue('PROOF_KIND');
			var dSupply_amt = detailForm.getValue('SUPPLY_AMT_I');			
			var amtPoint = BsaCodeInfo.gsAccntBasicInfo;
			
			if(Ext.isEmpty(proofkind)){
				dSupply_amt = 0;
				dTax_Amt    = 0;
				detailForm.setValue('TAX_AMT_I', 0);
			}else{
				var param = {COMP_CODE: UserInfo.compCode, PROOF_KIND: proofkind};
				accntCommonService.fnGetTaxRate(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
						dTaxRate = provider.TAX_RATE;
						dTax_Amt = dSupply_amt * (dTaxRate / 100);
						if(amtPoint == "1"){	//버림
							dTax_Amt = Math.floor(dTax_Amt);
						}else if(amtPoint == "2"){	//올림
							dTax_Amt = Math.ceil (dTax_Amt); 
						}else{		//반올림
							dTax_Amt = Math.round(dTax_Amt);
						}
						detailForm.setValue('TAX_AMT_I', dTax_Amt);
					}
				});
				
				 
			}
		},
		fnSetAcCustom: function(){
			if(!Ext.isEmpty(detailForm.getValue('SET_TYPE')) && !Ext.isEmpty(detailForm.getValue('CUSTOM_CODE'))){
				detailForm.setValue('AC_CUSTOM_CODE', detailForm.getValue('CUSTOM_CODE'));
				detailForm.setValue('AC_CUSTOM_NAME', detailForm.getValue('CUSTOM_NAME'));
			}
		},
		fnGetSaleCost: function(fieldName, newValue, oldValue){
			var costSaleManage = 0;
			var costProduce = 0;
			var costSale = 0;
			var costSubContract = 0;
			var isSucess = false;
			costSaleManage = Number(Ext.isEmpty(detailForm.getValue('SALE_MANAGE_COST')) ? "0" : detailForm.getValue('SALE_MANAGE_COST'));			
			costProduce = Number(Ext.isEmpty(detailForm.getValue('PRODUCE_COST')) ? "0" : detailForm.getValue('PRODUCE_COST'));
			costSale = Number(Ext.isEmpty(detailForm.getValue('SALE_COST')) ? "0" : detailForm.getValue('SALE_COST'));
			if((costSaleManage + costProduce + costSale ) > 100.00){
				isSucess = false;
				if(Ext.isEmpty(oldValue))	{
					oldValue = 0;
				}
				if(fieldName == 'SALE_MANAGE_COST')	{
					detailForm.setValue('SUBCONTRACT_COST', ( 100.00 - costProduce - costSale - oldValue));
				} else if(fieldName == 'PRODUCE_COST')	{
					detailForm.setValue('SUBCONTRACT_COST', ( 100.00 - costSaleManage - costSale - oldValue));
				} else if(fieldName == 'SALE_COST')	{
					detailForm.setValue('SUBCONTRACT_COST', ( 100.00 - costSaleManage - costProduce - oldValue));
				}
				
			}else{
				costSubContract = 100.00 - costSaleManage - costProduce - costSale;
				detailForm.setValue('SUBCONTRACT_COST', costSubContract);
				isSucess = true;
			}
			return isSucess;
		},
		fnSetPropertiesbyProofKind: function(){			
			var cboProofKind = detailForm.getValue('PROOF_KIND');				//증빙유형
			var cboReasonCode = detailForm.getField('REASON_CODE');				//불공제사유
			var proofKindRef1 = '';
			var proofKindRef2 = '';
			if(Ext.isEmpty(detailForm.getValue('SET_TYPE'))) return false;
			
			var param = {
				ADD_QUERY1: "ISNULL(REF_CODE1,'') REF_CODE1, ISNULL(REF_CODE2,'') REF_CODE2",
				ADD_QUERY2: '',
				MAIN_CODE: 'A022',
				SUB_CODE: cboProofKind
				
			}
			accntCommonService.fnGetRefCodes(param, function(provider, response)	{
				if(cboProofKind == "54" || cboProofKind == "61"){
					cboReasonCode.setReadOnly(false);
					if(Ext.isEmpty(detailForm.getValue('REASON_CODE'))){
						alert('불공제사유를 입력하십시오.');
						cboReasonCode.focus();
						return false;
					}
				}else{
					cboReasonCode.setReadOnly(true);
				}
				if(Ext.isEmpty(detailForm.getValue('PROOF_KIND'))){
					detailForm.setValue('SUPPLY_AMT_I', 0);
					detailForm.setValue('TAX_AMT_I', 0);					
				}else{
					proofKindRef1 = provider.REF_CODE1;
					proofKindRef2 = provider.REF_CODE2;
				}
				
				if(proofKindRef1 == "A" || proofKindRef1 == "C"){
					detailForm.setValue('EB_YN', 'Y');
				}else{
					detailForm.setValue('EB_YN', 'N');
				}
				
			});			
		}
	});

	Unilite.createValidator('validator01', {
		forms: {'formA:':detailForm},
		//forms: {'formA:':''},//detailForm},
		validate: function( type, fieldName, newValue, oldValue, record, form, field, eOpts ) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			if(newValue != oldValue && !form.uniOpt.inLoading)	{
				switch(fieldName) {
					case "DRB_YEAR" :		//내용년수
						if(Ext.isEmpty(newValue)) {
							detailForm.setValue('DPR_RATE', '');
							break;
						}
						if(isNaN(newValue)){
							rv = Msg.sMB074;	//숫자만 입력가능합니다.
							break;
						}
						if(newValue < 0 && !Ext.isEmpty(newValue))	{
							rv=Msg.sMB076;	//양수만 입력 가능합니다.
							break;
						}
						if(newValue < 2 || newValue > 60){
							rv= '내용년수는 2~60 사이의 정수만 입력 가능합니다.';
							break;
						}
						var drbYear = '000' + newValue;
						drbYear = drbYear.substring(drbYear.length-3);
						var dprStore ;
						if(detailForm.getValue("DEP_CTL") == "1")	{ // 정액상각
							dprStore = Ext.StoreManager.lookup("CBS_AU_A033");
						} else {							 // 정율상각
							dprStore = Ext.StoreManager.lookup("CBS_AU_A034");
						}
						if(dprStore)	{
							var	dprRecordIdx = dprStore.find("value", drbYear);
							if(dprRecordIdx > -1 ) {
								var dprRecord = dprStore.getAt(dprRecordIdx);
								detailForm.setValue("DPR_RATE", parseInt(dprRecord.get("text"))/1000);
							} else {
								Unilite.messageBox("상각방법의  상각율이 등록 되지 않았습니다.");
							}
						}
					break;
					case "DEP_CTL" :		//상각방법
							var drbYear = '000' + detailForm.getValue('DRB_YEAR') ;
							drbYear = drbYear.substring(drbYear.length-3);
							var dprStore ;
							if(newValue == "1")	{ // 정액상각
								dprStore = Ext.StoreManager.lookup("CBS_AU_A033");
							} else {							 // 정율상각
								dprStore = Ext.StoreManager.lookup("CBS_AU_A034")
							}
							if(dprStore)	{
								var	dprRecordIdx = dprStore.find("value", drbYear);
								if(dprRecordIdx > -1 ) {
									var dprRecord = dprStore.getAt(dprRecordIdx);
									detailForm.setValue("DPR_RATE", parseInt(dprRecord.get("text"))/1000);
								} else {
									Unilite.messageBox("상각방법의  상각율이 등록 되지 않았습니다.")
								}
							}
					break;
					case "EXCHG_RATE_O" :	//환율
						if(isNaN(newValue)){
							rv = Msg.sMB074;	//숫자만 입력가능합니다.
							break;
						}
						if(newValue < 0 && !Ext.isEmpty(newValue))	{
							rv=Msg.sMB076;	//양수만 입력 가능합니다.
							break;
						}
						UniAppManager.app.fnCalAcqAmtI();		//취득가액계산
						UniAppManager.app.fnComputeFiBaln();	//미상각잔액 반영
						detailForm.setValue('H_ACQ_AMT_I', newValue);
					break;
					
					case "FOR_ACQ_AMT_I" :		//외화취득가액
						if(isNaN(newValue)){
							rv = Msg.sMB074;	//숫자만 입력가능합니다.
							break;
						}
						if(newValue < 0 && !Ext.isEmpty(newValue))	{
							rv=Msg.sMB076;	//양수만 입력 가능합니다.
							break;
						}
						UniAppManager.app.fnCalAcqAmtI();		//취득가액계산
						UniAppManager.app.fnComputeFiBaln();	//미상각잔액 반영
						if(!Ext.isEmpty(detailForm.getValue('SET_TYPE'))){
							UniAppManager.app.fnSetPropertiesbySetType();	//선택된 결제유형에 따라 입력란 속성 설정
							UniAppManager.app.fnSetTaxAmt();
						}
						
					break;	
					
					case "ACQ_AMT_I" :		//취득가액
						if(isNaN(newValue)){
							rv = Msg.sMB074;	//숫자만 입력가능합니다.
							break;
						}
						if(newValue < 0 && !Ext.isEmpty(newValue))	{
							rv=Msg.sMB076;	//양수만 입력 가능합니다.
							break;
						}
						UniAppManager.app.fnComputeFiBaln();	//미상각잔액 반영
						if(!Ext.isEmpty(detailForm.getValue('SET_TYPE'))){
							UniAppManager.app.fnSetPropertiesbySetType();	//선택된 결제유형에 따라 입력란 속성 설정
							UniAppManager.app.fnSetTaxAmt();
						}
					break;
					
					case "ACQ_Q" :	//취득수량
						detailForm.setValue('STOCK_Q', newValue);
					break;
					
					case "SALE_MANAGE_COST" :	//판관(배부)
						if(!UniAppManager.app.fnGetSaleCost(fieldName, newValue, oldValue)){
							rv = '경비비율의 합은 100을 초과할 수 없습니다.';
						}				
					break;
					
					case "PRODUCE_COST" :	//제조원가
						if(!UniAppManager.app.fnGetSaleCost(fieldName, newValue, oldValue)){
							rv = '경비비율의 합은 100을 초과할 수 없습니다.';
						}
					break;
					case "SALE_COST" :	//경상
						if(!UniAppManager.app.fnGetSaleCost(fieldName, newValue, oldValue)){
							rv = '경비비율의 합은 100을 초과할 수 없습니다.';
						}
					break;
					case "FI_CAPI_TOT_I" :	//자본적지출
						UniAppManager.app.fnComputeFiBaln();	//미상각잔액 반영
					break;
					
					case "FI_SALE_TOT_I" :	//매각폐기전 미상각잔액
						UniAppManager.app.fnComputeFiBaln();	//미상각잔액 반영
					break;
					
					case "FI_SALE_DPR_TOT_I" :	//매각폐기전 상각누계액
						UniAppManager.app.fnComputeFiBaln();	//미상각잔액 반영
					break;
					
					case "FI_DPR_TOT_I" :	//상각누계액
						UniAppManager.app.fnComputeFiBaln();	//미상각잔액 반영
					break;
					case "FI_REVAL_TOT_I" :	//재평가액
						UniAppManager.app.fnComputeFiBaln();	//미상각잔액 반영
					break;
					case "FI_DMGLOS_TOT_I" :	//손상차손누계액
						UniAppManager.app.fnComputeFiBaln();	//미상각잔액 반영
					break;
					case "SUPPLY_AMT_I" :	//공급가액/세액
						UniAppManager.app.fnSetTaxAmt();
					break;	
					default:
					break;
					
	//				case "SAVE_FLAG" :	
	//					alert('sdfsdf');
	//				break;
				}
			}
			return rv;
		} // validator
	});
};

</script>
