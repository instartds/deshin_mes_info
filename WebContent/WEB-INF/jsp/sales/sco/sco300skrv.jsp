<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sco300skrv"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="sco300skrv"/> 			<!-- 사업장 -->	
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!-- 수금담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="S017" /> <!-- 수금유형 -->


</t:appConfig>
<script type="text/javascript" >
	var BsaCodeInfo = {	
		gsPjtCodeYN: '${gsPjtCodeYN}'
	};
function appMain() {
	var isPjtCodeYN = false;
	if(BsaCodeInfo.gsPjtCodeYN=='N')	{
		isPjtCodeYN = true;
	}
	/**
	 *   Model 정의 
	 * @type 
	 */
	
	    			
	Unilite.defineModel('Sco300skrvModel1', {
	    fields: [
	    
	    		 {name: 'COLLECT_DATE'							,text:'<t:message code="system.label.sales.collectiondate" default="수금일"/>'		    ,type:'uniDate'},
	    		 {name: 'DEPT_CODE'								,text:'<t:message code="system.label.sales.department" default="부서"/>'		    ,type:'string'},
	    		 {name: 'DEPT_NAME'								,text:'<t:message code="system.label.sales.departmentname" default="부서명"/>'		    ,type:'string'},
	    		 {name: 'POS_NO'								,text:'<t:message code="system.label.sales.posno" default="POS번호"/>'		,type:'string'},
	    		 {name: 'RECEIPT_NO'							,text:'<t:message code="system.label.sales.receiptdocno" default="영수증번호"/>'		,type:'string'},
	    		 
	    		 {name: 'CUSTOM_CODE'							,text:'<t:message code="system.label.sales.client" default="고객"/>'		,type:'string'},
	    		 {name: 'CUSTOM_NAME'							,text:'<t:message code="system.label.sales.clientname" default="고객명"/>'		    ,type:'string'},
	    		 
	    		 {name: 'COLLECT_TYPE'							,text:'<t:message code="system.label.sales.collectiontype" default="수금유형"/>'		,type:'string'},
	    		 {name: 'MONEY_UNIT'							,text:'<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'		,type:'string'},
	    		 {name: 'COLLECT_AMT'							,text:'<t:message code="system.label.sales.collectionamount" default="수금액"/>'		    ,type:'uniPrice'},
	    		 {name: 'EXCHANGE_RATE'							,text:'<t:message code="system.label.sales.exchangerate" default="환율"/>'			,type:'uniER'},
	    		 {name: 'COLLECT_SUM_AMT'						,text:'<t:message code="system.label.sales.exchangeamount" default="환산액"/>'		    ,type:'uniPrice'},
	    		 {name: 'REPAY_AMT'								,text:'<t:message code="system.label.sales.advancedrefundamount" default="선수반제액"/>'		,type:'uniPrice'},
	    		 {name: 'NOTE_NUM'								,text:'<t:message code="system.label.sales.noteno" default="어음번호"/>'		,type:'string'},
	    		 {name: 'NOTE_TYPE'								,text:'<t:message code="system.label.sales.noteclass" default="어음구분"/>'		,type:'string'},
	    		 {name: 'PUB_CUST_CD'							,text:'<t:message code="system.label.sales.publishoffice" default="발행기관"/>'		,type:'string'},
	    		 {name: 'NOTE_PUB_DATE'							,text:'<t:message code="system.label.sales.publishdate" default="발행일"/>'		,type:'uniDate'},
	    		 {name: 'PUB_PRSN'								,text:'<t:message code="system.label.sales.publisher" default="발행인"/>'		    ,type:'string'},
	    		 {name: 'NOTE_DUE_DATE'							,text:'<t:message code="system.label.sales.duedate" default="만기일"/>'		,type:'uniDate'},
	    		 {name: 'PUB_ENDOSER'							,text:'<t:message code="system.label.sales.endorser" default="배서인"/>'		    ,type:'string'},
	    		 {name: 'SAVE_CODE'	    						,text:'<t:message code="system.label.sales.bankaccountcode" default="통장코드"/>'		,type:'string'},
	    		 {name: 'SAVE_NAME'	    						,text:'<t:message code="system.label.sales.bankaccountname" default="통장명"/>'		    ,type:'string'},
	    		 {name: 'BANK_ACCOUNT'							,text:'<t:message code="system.label.sales.bankaccountnumber" default="계좌번호"/>'		,type:'string'},
	    		 {name: 'COLET_CUST_CD'							,text:'<t:message code="system.label.sales.collectionplace" default="수금처"/>'		    ,type:'string'},
	    		 {name: 'DIV_CODE'								,text:'<t:message code="system.label.sales.division" default="사업장"/>'		    ,type:'string'},
	    		 {name: 'COLLECT_DIV'							,text:'<t:message code="system.label.sales.collectiondivision" default="수금사업장"/>'		,type:'string'},
	    		 {name: 'COLLECT_PRSN'							,text:'<t:message code="system.label.sales.collectioncharge" default="수금담당"/>'		,type:'string'},
	    		 {name: 'MANAGE_CUSTOM'							,text:'<t:message code="system.label.sales.summarycustom" default="집계거래처"/>'		,type:'string'},
	    		 {name: 'AREA_TYPE'								,text:'<t:message code="system.label.sales.area" default="지역"/>'			,type:'string'},
	    		 {name: 'AGENT_TYPE'							,text:'<t:message code="system.label.sales.clienttype" default="고객분류"/>'		,type:'string'},
	    		 {name: 'PROJECT_NO'							,text:'<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'	,type:'string'},
	    		 {name: 'PJT_CODE'								,text:'<t:message code="system.label.sales.projectcode" default="프로젝트코드"/>'	,type:'string'},
	    		 {name: 'PJT_NAME'								,text:'<t:message code="system.label.sales.project" default="프로젝트"/>'		,type:'string'},
	    		 {name: 'COLLECT_NUM'							,text:'<t:message code="system.label.sales.collectionno" default="수금번호"/>'		,type:'string'},
	    		 {name: 'PUB_NUM'								,text:'<t:message code="system.label.sales.billno" default="계산서번호"/>'		,type:'string'},
	    		 {name: 'EX_NUM'								,text:'<t:message code="system.label.sales.slipno" default="전표번호"/>'		,type:'string'},
	    		 {name: 'REMARK'								,text:'<t:message code="system.label.sales.remarks" default="비고"/>'			,type:'string'},
	    		 {name: 'NOTE_CREDIT_RATE'						,text:'<t:message code="system.label.sales.noterate" default="어음인정율"/>'		,type:'string'},
	    		 {name: 'STB_REMARK'							,text:'계산서의비고'	,type:'string'},
	    		 {name: 'CARD_ACC_NUM'     						,text:'<t:message code="system.label.sales.cardapproveno" default="카드승인번호"/>'	,type:'string'},
	    		 {name: 'RECEIPT_NAME'     						,text:'<t:message code="system.label.sales.depositperson" default="입금자"/>'		    ,type:'string'},
	    		 {name: 'SIGN_DATA'     						,text:'Signature'	    ,type:'string'},
	    		 {name: 'SIGN_DIV_CODE'     					,text:'<t:message code="system.label.sales.divisioncode" default="사업장코드"/>'		,type:'string'},
	    		 {name: 'COLLECT_SEQ'     						,text:'<t:message code="system.label.sales.collectionseq" default="수금순번"/>'		,type:'string'}
	    		 
	    		 
			]
	});	
	

	  
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('sco300skrvMasterStore1',{
			model: 'Sco300skrvModel1',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'sco300skrvService.selectList'                	
                }
            }
			,loadStoreRecords : function()	{	
				var param= Ext.getCmp('searchForm').getValues();
				var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
				var deptCode = UserInfo.deptCode;	//부서코드
				if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
					param.DEPT_CODE = deptCode;
				}
				console.log( param );
				this.load({
					params : param
				});
			},
			groupField:'CUSTOM_NAME'
	});
	

	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {          
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',         
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
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',   
			itemId: 'search_panel1',
			layout : {type : 'vbox', align : 'stretch'},
	    	items : [{
	    		xtype:'container',
	    		layout : {type : 'uniTable', columns : 1},
	    		items:[{
					fieldLabel: '<t:message code="system.label.sales.collectioncharge" default="수금담당"/>'	,
					name:'ORDER_PRSN',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'S010',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ORDER_PRSN', newValue);
						}
					}
				},
	    			Unilite.popup('AGENT_CUST',{
	    			fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
	    			
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
								panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('CUSTOM_CODE', '');
							panelResult.setValue('CUSTOM_NAME', '');
						}
					}
				})/*,
					Unilite.popup('',{
					fieldLabel: '<t:message code="system.label.sales.project" default="프로젝트"/>', 
					
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
								panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
						}
					}
				})*/,{
	    			fieldLabel: '<t:message code="system.label.sales.collectiondivision" default="수금사업장"/>',
	    			name:'DIV_CODE',
	    			xtype: 'uniCombobox', 
	    			comboType:'BOR120',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
	    		} , {
					fieldLabel: '<t:message code="system.label.sales.collectiondate" default="수금일"/>',            			 		       
					xtype: 'uniDateRangefield',
					startFieldName: 'FR_DATE',
					endFieldName: 'TO_DATE',
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today'),
					width:315,                	
	                onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('FR_DATE', newValue);						
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('TO_DATE', newValue);				    		
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
				}), {
	    			xtype: 'radiogroup',		            		
	    			fieldLabel: '<t:message code="system.label.sales.collectionslipyn" default="수금기표여부"/>',	    			
	    			items : [{
	    				boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
	    				width:50 ,
	    				name: 'RDO', 
	    				inputValue: 'A',
	    				checked: true
	    			}, {
	    				boxLabel: '<t:message code="system.label.sales.slipposting" default="기표"/>', 
	    				width:50 ,
	    				name: 'RDO' , 
	    				inputValue: 'Y'
	    			}, {
	    				boxLabel: '<t:message code="system.label.sales.notslipposting" default="미기표"/>',
	    				width:70 , 
	    				name: 'RDO' ,
	    				inputValue: 'N'
	    			}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
							panelResult.getField('RDO').setValue(newValue.RDO);
						}
					}
	            }]	
			}]
		}, {
			title:'<t:message code="system.label.sales.additionalinfo" default="추가정보"/>',
			id: 'search_panel2',
			itemId:'search_panel2',
	    	defaultType: 'uniTextfield',
	    	layout: {type: 'uniTable', columns: 1},
			items:[ {
				fieldLabel: '<t:message code="system.label.sales.collectiontype" default="수금유형"/>'	,
				name:'COLLECT_TYPE',
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'S017'
			},
				Unilite.popup('AGENT_CUST',{
				fieldLabel: '<t:message code="system.label.sales.collectionplace" default="수금처"/>',
				 
				validateBlank:false,
				valueFieldName:'COLET_CUST_CD'				
			}), {
				fieldLabel: '<t:message code="system.label.sales.collectionamount" default="수금액"/>',
				name:'COLLECT_AMT_FR' , 
				suffixTpl:'&nbsp;이상'
			}, {
				fieldLabel: '~',
				name:'COLLECT_AMT_TO' ,
				suffixTpl:'&nbsp;이하'
			}, {
				fieldLabel: '<t:message code="system.label.sales.customclass" default="거래처분류"/>',
				name:'AGENT_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B055'
			}, 
				Unilite.popup('AGENT_CUST',{
				fieldLabel: '<t:message code="system.label.sales.summarycustom" default="집계거래처"/>',
				
				validateBlank:false,
				valueFieldName:'MANAGE_CUSTOM'
			}), {
				fieldLabel: '<t:message code="system.label.sales.area" default="지역"/>',
				name:'AREA_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B056'
			}, {
		 	 	xtype: 'container',
    			defaultType: 'uniTextfield',
 				layout: {type: 'uniTable', columns: 1},
 				width:315,
 				items:[{
 					xtype: 'uniTextfield',
 					fieldLabel:'<t:message code="system.label.sales.collectionno" default="수금번호"/>',
 					name: 'COLLECT_NUM_FR'
 				},{
 					xtype: 'uniTextfield',
 					fieldLabel: '~',
 					name: 'COLLECT_TO'
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
   						var labelText = invalid.items[0]['fieldLabel']+' : ';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
   					}

				   	Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
				   	invalid.items[0].focus();
				}
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
			fieldLabel: '<t:message code="system.label.sales.collectioncharge" default="수금담당"/>'	,
			name:'ORDER_PRSN',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'S010',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ORDER_PRSN', newValue);
				}
			}
		},
			Unilite.popup('AGENT_CUST',{
			fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
			
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
						panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('CUSTOM_CODE', '');
					panelSearch.setValue('CUSTOM_NAME', '');
				}
			}
		})/*,
			Unilite.popup('',{
			fieldLabel: '<t:message code="system.label.sales.project" default="프로젝트"/>', 
			
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
						panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('ITEM_CODE', '');
					panelSearch.setValue('ITEM_NAME', '');
				}
			}
		})*/,{
			fieldLabel: '<t:message code="system.label.sales.collectiondivision" default="수금사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox', 
			comboType:'BOR120',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		} , {
			fieldLabel: '<t:message code="system.label.sales.collectiondate" default="수금일"/>',            			 		       
			xtype: 'uniDateRangefield',
			startFieldName: 'FR_DATE',
			endFieldName: 'TO_DATE',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			width:315,                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('FR_DATE', newValue);
					//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();							
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('TO_DATE', newValue);
		    		//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();				    		
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
		}), {
			xtype: 'radiogroup',		            		
			fieldLabel: '<t:message code="system.label.sales.collectionslipyn" default="수금기표여부"/>',	    			
			items : [{
				boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
				width:50 ,
				name: 'RDO', 
				inputValue: 'A',
				checked: true
			}, {
				boxLabel: '<t:message code="system.label.sales.slipposting" default="기표"/>', 
				width:50 ,
				name: 'RDO' , 
				inputValue: 'Y'
			}, {
				boxLabel: '<t:message code="system.label.sales.notslipposting" default="미기표"/>',
				width:70 , 
				name: 'RDO' ,
				inputValue: 'N'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					//panelSearch.getField('SALE_YN').setValue({SALE_YN: newValue});
					panelSearch.getField('RDO').setValue(newValue.RDO);
				}
			}
        }]	
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */

    var masterGrid = Unilite.createGrid('sco300skrvGrid1', {
    	// for tab 
    	region: 'center', 
//        layout: 'fit',        
    	store: directMasterStore1,
    	uniOpt: {useRowNumberer: false},
    	features: [ {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},{id : 'masterGridTotal', 	ftype: 'uniSummary',  showSummaryRow: true} ],    	           	
        columns:  [ { dataIndex: 'COLLECT_DATE'							,		   	width: 80, locked: true	},
        			{ dataIndex: 'DEPT_CODE'							,		   	width: 80, locked: true, hidden:true	},
        			{ dataIndex: 'DEPT_NAME'							,		   	width: 80, locked: true	},
        			{ dataIndex: 'POS_NO'								,		   	width: 80, locked: true	},
        			{ dataIndex: 'RECEIPT_NO'							,		   	width: 80, locked: true	},
        			
        			{ dataIndex: 'CUSTOM_CODE'							, 		   	width: 80, locked: true	},
        			{ dataIndex: 'CUSTOM_NAME'							,		   	width: 120, locked: true,
        			summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					       return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
		            }
        			},
        			
        			
        			
        			
        			
        			{ dataIndex: 'COLLECT_TYPE'							,		   	width: 100	},
        			{ dataIndex: 'MONEY_UNIT'							,		   	width: 66	},
        			{ dataIndex: 'COLLECT_AMT'							,		   	width: 120, summaryType: 'sum'	},
        			{ dataIndex: 'EXCHANGE_RATE'						,		   	width: 100	},
        			{ dataIndex: 'COLLECT_SUM_AMT'						,		   	width: 120, summaryType: 'sum'	},
        			{ dataIndex: 'REPAY_AMT'							,		   	width: 120, summaryType: 'sum'	},
        			{ dataIndex: 'NOTE_NUM'								,		   	width: 80	},
        			{ dataIndex: 'NOTE_TYPE'							,		   	width: 80	},
        			{ dataIndex: 'PUB_CUST_CD'							,		   	width: 120	},
        			{ dataIndex: 'NOTE_PUB_DATE'						,		   	width: 80	},
        			{ dataIndex: 'PUB_PRSN'								,		   	width: 80	},
        			{ dataIndex: 'NOTE_DUE_DATE'						,		   	width: 80	},
        			{ dataIndex: 'PUB_ENDOSER'							,		   	width: 80	},
        			{ dataIndex: 'SAVE_CODE'	    					,		   	width: 66	},
        			{ dataIndex: 'SAVE_NAME'	    					,		   	width: 130	},
        			{ dataIndex: 'BANK_ACCOUNT'							,		   	width: 133	},
        			{ dataIndex: 'COLET_CUST_CD'						,		   	width: 113	},
        			{ dataIndex: 'DIV_CODE'								,		   	width: 80	},
        			{ dataIndex: 'COLLECT_DIV'							,		   	width: 80	},
        			{ dataIndex: 'COLLECT_PRSN'							,		   	width: 80	},
        			{ dataIndex: 'MANAGE_CUSTOM'						,		   	width: 113	},
        			{ dataIndex: 'AREA_TYPE'							,		   	width: 80	},
        			{ dataIndex: 'AGENT_TYPE'							,		   	width: 80	},
        			{ dataIndex: 'PROJECT_NO'							,		   	width: 80,  hidden: !isPjtCodeYN	},
        			{ dataIndex: 'PJT_CODE'								,		   	width: 80,  hidden: isPjtCodeYN	},
        			{ dataIndex: 'PJT_NAME'								,		   	width: 166, hidden: isPjtCodeYN	},
        			{ dataIndex: 'COLLECT_NUM'							,		   	width: 100	},
        			{ dataIndex: 'PUB_NUM'								,		   	width: 100	},
        			{ dataIndex: 'EX_NUM'								,		   	width: 80	},
        			{ dataIndex: 'REMARK'								,		   	width: 133	},
        			{ dataIndex: 'NOTE_CREDIT_RATE'						,		   	width: 80	},
        			{ dataIndex: 'STB_REMARK'							,		   	width: 133	},
        			{ dataIndex: 'CARD_ACC_NUM'     					,		   	width: 120	},
        			{ dataIndex: 'RECEIPT_NAME'     					,		   	width: 100	},
        			{ text: 'Signature',
			          dataIndex: 'SIGN_DATA',
			          align: 'center',
			          xtype: 'actioncolumn',
			          width:70,
			          items: [{
		                  icon: CPATH+'/resources/css/theme_01/barcodetest.png',
		                  handler: function(grid, rowIndex, colIndex, item, e, record) {
		                  	if(record.get('COLLECT_NUM'))	{
								   var signImgWin = Ext.create('Ext.window.Window', {
										    title: 'Signature',
										    height: 200,
										    width: 400,
										    layout: 'fit',
										    items: [{  
										        xtype: 'image',
										        itemId : 'SignImg',
										        src:CPATH+'/resources/images/nameCard.jpg'
										    }],
										    setImg : function()	{
										    	this.down('#SignImg').setSrc("sco300skrvSign.do?DIV_CODE="+record.get('SIGN_DIV_CODE')+"&COLLECT_NUM="+record.get('COLLECT_NUM')+"&COLLECT_SEQ="+record.get('COLLECT_SEQ'));
										    }
										})
								    signImgWin.setImg();
								    signImgWin.show();
		                  		
		                  	}
		                  },
		                  isDisabled: function(view, rowIndex, colIndex, item, record) {
				                // Returns true if 'editable' is false (, null, or undefined)
				                return record.get('SIGN_DATA') == 'N' ;
				            }
        			}]
        			}
       ]
        			
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
		id  : 'sco300skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
//			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
//        	panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
        	panelSearch.setValue('TO_DATE', UniDate.get('today'));
			panelSearch.setValue('FR_DATE', UniDate.get('startOfMonth', panelSearch.getValue('TO_DATE')));
        	
        	
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
//        	panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
//        	panelResult.setValue('DEPT_NAME', UserInfo.deptName);
        	panelSearch.setValue('TO_DATE', UniDate.get('today'));
			panelSearch.setValue('FR_DATE', UniDate.get('startOfMonth', panelSearch.getValue('TO_DATE')));
		},
		onQueryButtonDown : function()	{		
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
			masterGrid.getStore().loadStoreRecords();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();						
//		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);		    
//		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);	
			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);			

		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			this.fnInitBinding();			
		}
	});

};


</script>