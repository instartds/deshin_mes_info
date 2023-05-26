<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="had950ukr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="had950ukr"/>
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {  
	
	 Ext.create('Ext.data.Store', {
			storeId:"payApplyCombo",
		    fields: ['text', 'value'],
		    data : [
		        {text:"반영",   value:"Y"},
		        {text:"미반영", 	value:"N"}
		    ]
		});
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'had950ukrService.selectList',
			update: 'had950ukrService.updateList',
			create: 'had950ukrService.insertList',
			destroy: 'had950ukrService.deleteList',
			syncAll: 'had950ukrService.saveAll'
		}
	});	
	//계정	창고	구분	품목	품명	규격	단위	Lot No. 	비고	폐기수량	반품수량	폐기수량-반품수량	단가	금액
	Unilite.defineModel('had950ukrModel', {
	    fields: [  	    
              {name : 'DIV_CODE'        , text : '<t:message code="system.label.human.division" default="사업장"/>'			, type : 'string'     	, allowBlank : false   , editable : false         , comboType : 'BOR120'		}
	    	, {name : 'YEAR_YYYY'       , text : '<t:message code="system.label.human.reportyear" default="신고연도"/>'		, type : 'string'     	, allowBlank : false   , editable : false         								}
	    	, {name : 'PERSON_NUMB'     , text : '<t:message code="system.label.human.employeenumber" default="사원번호"/>'	, type : 'string' 	  	, allowBlank : false   , editable : false         								}
	    	, {name : 'NAME'     		, text : '<t:message code="system.label.human.employeename" default="사원명"/>'		, type : 'string'  		, allowBlank : false   , editable : false         								}
	    	// 연말정산
	    	, {name : 'IN_TAX_I'        , text : '<t:message code="system.label.human.intaxi" default="소득세"/>'			, type : 'uniPrice'    	, editable : false             													}
	    	, {name : 'SP_TAX_I'        , text : '<t:message code="system.label.human.sptaxi" default="농특세"/>'			, type : 'uniPrice'    	, editable : false             													}
	    	, {name : 'LOCAL_TAX_I'     , text : '<t:message code="system.label.human.localtaxi" default="지방소득세"/>'	  	, type : 'uniPrice'   	, editable : false              												}
	    	// 1차분납
	    	, {name : 'PAY_YYYYMM_01'   , text : '<t:message code="system.label.human.payyyyymm1" default="귀속연월"/>'		, type : 'string'   	, editable : false             													}
	    	, {name : 'IN_TAX_I_01'     , text : '<t:message code="system.label.human.intaxi" default="소득세"/>'			, type : 'uniPrice'                  																	}
	    	, {name : 'SP_TAX_I_01'     , text : '<t:message code="system.label.human.sptaxi" default="농특세"/>'			, type : 'uniPrice'                                          											}
	    	, {name : 'LOCAL_TAX_I_01'  , text : '<t:message code="system.label.human.localtaxi" default="지방소득세"/>'	  	, type : 'uniPrice'                                          											}
	    	, {name : 'PAY_APPLY_YN_01' , text : '<t:message code="system.label.human.payapplyyn" default="급여반영여부"/>'	, type : 'string'     	, editable : false     , store : Ext.data.StoreManager.lookup('payApplyCombo')	}
	    	// 2차분납
	    	, {name : 'PAY_YYYYMM_02'   , text : '<t:message code="system.label.human.payyyyymm1" default="귀속연월"/>'		, type : 'string'    	, editable : false              												}
	    	, {name : 'IN_TAX_I_02'     , text : '<t:message code="system.label.human.intaxi" default="소득세"/>'			, type : 'uniPrice'                                         											}
	    	, {name : 'SP_TAX_I_02'     , text : '<t:message code="system.label.human.sptaxi" default="농특세"/>'			, type : 'uniPrice'                                        												}
	    	, {name : 'LOCAL_TAX_I_02'  , text : '<t:message code="system.label.human.localtaxi" default="지방소득세"/>'	  	, type : 'uniPrice'                                         											}
	    	, {name : 'PAY_APPLY_YN_02' , text : '<t:message code="system.label.human.payapplyyn" default="급여반영여부"/>'	, type : 'string'      	, editable : false    , store : Ext.data.StoreManager.lookup('payApplyCombo')	}
	    	// 3차분납
	    	, {name : 'PAY_YYYYMM_03'   , text : '<t:message code="system.label.human.payyyyymm1" default="귀속연월"/>'		, type : 'string'   	, editable : false            													}
	    	, {name : 'IN_TAX_I_03'     , text : '<t:message code="system.label.human.intaxi" default="소득세"/>'			, type : 'uniPrice'                                           											}
	    	, {name : 'SP_TAX_I_03'     , text : '<t:message code="system.label.human.sptaxi" default="농특세"/>'			, type : 'uniPrice'                                            											}
	    	, {name : 'LOCAL_TAX_I_03'  , text : '<t:message code="system.label.human.localtaxi" default="지방소득세"/>'	  	, type : 'uniPrice'                                           											}
	    	, {name : 'PAY_APPLY_YN_03' , text : '<t:message code="system.label.human.payapplyyn" default="급여반영여부"/>'	, type : 'string'      	, editable : false   , store : Ext.data.StoreManager.lookup('payApplyCombo')	}
	    	, {name : 'OPR_FLAG' 			, text : '신규여부'	   																, type : 'string'      	, editable : false              												}
	    	
		         
	    ]
	});
	
	var directMasterStore = Unilite.createStore('had950ukrMasterStore',{
		model: 'had950ukrModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable: true,			// 삭제 가능 여부 
            allDeletable: true,
	        useNavi: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:directProxy,
        loadStoreRecords: function() {
        	this.clearFilter(); 
        	if(panelResult.getInvalidMessage())	{
				var param= Ext.getCmp('resultForm').getValues();			
				this.load({
					params : param,
					callback: function(records, operation, success) {
						if(success){
							Ext.each(records, function(record, idx)	{
								if(record.get("OPR_FLAG") == "N")	{
									record.set("OPR_FLAG", "신규");
								}
							});
						}
					}
				});
        	}
		},
		saveStore : function()	{	
			this.clearFilter();
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				var config = {}
				this.syncAllDirect({});
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load:function(store, records){
				/* if(!records || (records && records.length == 0))	{
					setTimeout(function() {
						var param= Ext.getCmp('resultForm').getValues();	
						//저장된 데이터가 없을 경우 신규데이터 조회
						masterGrid.getEl().mask()
						had950ukrService.selectNewList(param,  function(responseText, response) {
							if(responseText && responseText.length > 0)	{
								Ext.each(responseText, function(record, rowIndex) {
									var newRecord =  Ext.create (store.model);
									if(record)	{
										Ext.each(Object.keys(record), function(key, idx){
											newRecord.set(key, record[key]);
										});
									}
									newRecord.phantom = true;
									//console.log("newRowIndex 1= " ,rowIndex );
									//newRecord = grid.store.insert(rowIndex, newRecord);
									store.insert(rowIndex, newRecord);
								});
								masterGrid.select(0);
								
							}
							masterGrid.getEl().unmask()
						})
					}, 100)
				} */
			}
		}
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 7, tableAttrs:{width : '100%'}},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel		: '<t:message code="system.label.human.division" default="사업장"/>'  ,
			name			: 'DIV_CODE',
			xtype			: 'uniCombobox',
			comboType		: 'BOR120',
			value       	:  UserInfo.divCode, 
			width           :  230,
			allowBlank		: false
		},{
			fieldLabel		: '<t:message code="system.label.human.reportyear" default="신고연도"/>',
			xtype			: 'uniYearField',
			name	        : 'YEAR_YYYY',
			value			: (new Date()).getFullYear(), 
			width           :  210,
			allowBlank		: false
		},{
			fieldLabel		: '<t:message code="system.label.human.installmentStartMonth" default="분납시작연월"/>'  ,
			name			: 'INSTALL_MONTH',
			xtype			: 'uniMonthfield',
			value			: (new Date()).getFullYear() +'.02',
			width           :  210,
			allowBlank		: false
		},{
			fieldLabel		: '<t:message code="system.label.human.installmentCount" default="분납차수"/>'  ,
			name			: 'INSTALL_COUNT',
			xtype			: 'uniNumberfield',
			minValue		: 1,
			maxValue        : 3,
			value           : 3,
			allowBlank		: false,
			width           :  150,
			listeners       : {
				change		:	function(field, newValue, oldValue) {
					if(oldValue != newValue)	{
						if(newValue < 1 || newValue > 3)	{
							Unilite.messageBox('<t:message code="system.message.human.message141" default="분납차수는 1 ~ 3 까지 입력 가능합니다."/>');
							if(!Ext.isEmpty(oldValue))	{
								field.setValue(oldValue);
							} else {
								field.setValue(1);
							}
						}
					}
				}
			}
		},{
			xtype 			:'component',
			html  			: '&nbsp;',
			tdAttrs			: {width : '50%'}
		},{
			xtype 			: 'button',
			text  			: '분납일괄계산',
			width 			: 100,
			tdAttrs         : {width : 140, align :'center'},
			handler 		: function(){
				if(Ext.isEmpty(directMasterStore.getData().items))	{
					Unilite.messageBox("조회 후 이용하세요.");
					return ;
				}
				
				var install_cnt = Unilite.nvl(panelResult.getValue("INSTALL_COUNT"), 1) ;
				
				Ext.each(directMasterStore.getData().items, function(record, idx){
					var rv = true;
					if(install_cnt == 1)	{
						rv = UniAppManager.app.checkAllPayment ( record, record.get("IN_TAX_I_01"), record.get("IN_TAX_I"), "소득세" );
						rv = UniAppManager.app.checkAllPayment ( record, record.get("SP_TAX_I_01"), record.get("SP_TAX_I"), "농특세" );
						rv = UniAppManager.app.checkAllPayment ( record, record.get("LOCAL_TAX_I_01"), record.get("LOCAL_TAX_I"), "지방소득세" );
					} else {
						rv = UniAppManager.app.calculateInstallmentAll(record, "IN_TAX_I", "소득세" );
						rv = UniAppManager.app.calculateInstallmentAll(record, "SP_TAX_I", "농특세" );
						rv = UniAppManager.app.calculateInstallmentAll(record, "LOCAL_TAX_I", "지방소득세" );
					}
					if(!rv)	{
						Unilite.messageBox("분납일괄계산에 오류가 있습니다.")
					}
				})
				
			} 
		},{
			xtype:'component',
			html:'연말정산세액반영',
    		width: 120,	
    		tdAttrs: {align : 'center'},
    		componentCls : 'component-text_first',
			listeners:{
				render: function(component) {
	                component.getEl().on('click', function( event, el ) {
	                	var params = { 
	            				'PGM_ID' : 'had830ukr'
	            			}
	            	  		var rec1 = {data : {prgID : 'had830ukr', 'text':''}};							
	            			parent.openTab(rec1, '/human/had830ukr.do', params);
	                });
	            }
			}
		}]
	});	
	
    var masterGrid = Unilite.createGrid('had950ukrGrid', {
        store: directMasterStore,
    	region: 'center',
    	flex:1,
    	uniOpt : {
    		expandLastColumn: false
    	},
        columns:  [     
        	  {dataIndex : 'DIV_CODE'         	, width : 80   	}
        	, {dataIndex : 'YEAR_YYYY'        	, width : 80   	, align : 'center'}
        	, {dataIndex : 'PERSON_NUMB'     	, width : 100  	}
        	, {dataIndex : 'NAME'        		, width : 100 	}
        	, {
        		text:'<t:message code="system.label.human.yearEndTax" default="연말정산"/>',
        	   	columns :[
        		  {dataIndex : 'IN_TAX_I'    	, width : 80  	}
               	, {dataIndex : 'SP_TAX_I'      	, width : 80   	}
               	, {dataIndex : 'LOCAL_TAX_I'  	, width : 100   }
        	   ]
        	},{
        	   text:'<t:message code="system.label.human.firstInstallmentPayment" default="1차분납"/>',
         	   columns :[
         		  {dataIndex : 'PAY_YYYYMM_01' 	, width : 80   	, align : 'center'}
              	, {dataIndex : 'IN_TAX_I_01'   	, width : 80  	}
              	, {dataIndex : 'SP_TAX_I_01'   	, width : 80  	}
              	, {dataIndex : 'LOCAL_TAX_I_01'	, width : 100  	}
              	, {dataIndex : 'PAY_APPLY_YN_01', width : 100  	}
         	   ]
         	},{
        	   text:'<t:message code="system.label.human.secondInstallmentPayment" default="2차분납"/>',
         	   columns :[
         		  {dataIndex : 'PAY_YYYYMM_02'	, width : 80   	, align : 'center'}
              	, {dataIndex : 'IN_TAX_I_02'  	, width : 80  	}
              	, {dataIndex : 'SP_TAX_I_02'   	, width : 80  	}
              	, {dataIndex : 'LOCAL_TAX_I_02'	, width : 100  	}
              	, {dataIndex : 'PAY_APPLY_YN_02', width : 100  	}
         	   ]
         	},{
        	   text:'<t:message code="system.label.human.thridInstallmentPayment" default="3차분납"/>',
         	   columns :[
         		  {dataIndex : 'PAY_YYYYMM_03' 	, width : 80   	, align : 'center'}
              	, {dataIndex : 'IN_TAX_I_03'  	, width : 80  	}
              	, {dataIndex : 'SP_TAX_I_03'   	, width : 80 	}
              	, {dataIndex : 'LOCAL_TAX_I_03'	, width : 100	}
            	, {dataIndex : 'PAY_APPLY_YN_03', width : 100  	}
         	   ]
         	}
        	, {dataIndex : 'OPR_FLAG'              	, width : 70  	}
	         
		],
		listeners : {
			beforeedit: function( editor, e, eOpts ) {
   				if( UniUtils.indexOf( e.field , ['IN_TAX_I_01','SP_TAX_I_01','LOCAL_TAX_I_01']))	{
	   				if(e.record.get("PAY_APPLY_YN_01") == "Y")	{
						return false;
					}
   				}
   				if( UniUtils.indexOf( e.field , ['IN_TAX_I_02','SP_TAX_I_02','LOCAL_TAX_I_02']))	{
	   				if(e.record.get("PAY_APPLY_YN_02") == "Y")	{
						return false;
					}
   				}
   				if( UniUtils.indexOf( e.field , ['IN_TAX_I_03','SP_TAX_I_03','LOCAL_TAX_I_03']))	{
	   				if(e.record.get("PAY_APPLY_YN_03") == "Y")	{
						return false;
					}
   				}
    			return true;
        	}
		}
    });  
    
	Unilite.Main( {
		borderItems:[
			panelResult,masterGrid,
			{
				xtype 	: 'panel',
				region 	: 'south',
				title  	: '연말정산분납계산 프로세스',
				height	: 60,
				collapsible : true,
				items   : [
					{
						xtype :'component',
						flex  : 1,
						height: 35,
						style : ' margin : 8px 5px 5px 30px;',
						html  : "<span style = 'color : blue ; font-weight :bold;' > '연말정산계산-> 급여계산-> 연말정산세액반영' 이며, 각 분납월에 따라,	'연말정산세액반영'을 실행하셔야 합니다.</span>"
					}
				]
			}
		],
		id: 'had950ukrApp',
		fnInitBinding : function() {
			panelResult.setValue("DIV_CODE", UserInfo.divCode);
			panelResult.setValue("YEAR_YYYY", (new Date()).getFullYear());
			panelResult.setValue("INSTALL_MONTH", (new Date()).getFullYear()+'02');
			panelResult.setValue("INSTALL_MONTH", (new Date()).getFullYear()+'02');
			
			UniAppManager.setToolbarButtons(['reset'],true);
			UniAppManager.setToolbarButtons(['save','newData'],false);
		},
		onQueryButtonDown: function()	{
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {		
			masterGrid.reset();
			panelResult.setValue("DIV_CODE", UserInfo.divCode);
			panelResult.setValue("YEAR_YYYY", (new Date()).getFullYear());
			panelResult.setValue("INSTALL_MONTH", (new Date()).getFullYear()+'02');
			panelResult.setValue("INSTALL_COUNT", 3);
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				if(selRow.get("PAY_APPLY_YN_01") =="Y" || selRow.get("PAY_APPLY_YN_02") =="Y" || selRow.get("PAY_APPLY_YN_03") =="Y" )	{
					Unilite.messageBox('<t:message code="system.message.human.message142" default="급여반영된 차수가 있어 삭제할 수 없습니다."/>');
				} else {
					masterGrid.deleteSelectedRow();
				}
			}
		},
		onDeleteAllButtonDown: function() {
			if(panelResult.getInvalidMessage())	{
				if(confirm('<t:message code="system.message.human.message143" default="저장된 데이터가 삭제됩니다. 전체 삭제 하시겠습니까?"/>'))	{
					var applyChek = false;
					Ext.each(directMasterStore.getData().items, function(record)	{
						if(record.get("PAY_APPLY_YN_01") =="Y" || record.get("PAY_APPLY_YN_02") =="Y" || record.get("PAY_APPLY_YN_03") =="Y" )	{
							applyChek = true;
							return;
						}
					});
					if(applyChek)	{
						Unilite.messageBox('<t:message code="system.message.human.message142" default="급여반영된 차수가 있어 삭제할 수 없습니다."/>');
					} else {
						var param = panelResult.getValues();
						had950ukrService.deleteAll(param, function(responseText, response){
							if(responseText)	{
								UniAppManager.updateStatus('<t:message code="system.message.human.message114" default="전체삭제가 완료되었습니다."/>');
								UniAppManager.app.onResetButtonDown();
							}
					    })
					}
				}
			}
		},
		
		checkAllPayment : function(record, newValue, totalTax,  taxName)	{
			if(newValue != totalTax )	{
				return "총 "+taxName+"와 분납"+taxName+" 합계 값이 다릅니다.";
			} else {
				return true;
			}
		}, 
		/*
		* type : IN_TAX_I - 소득세, SP_TAX_I - 농특세 , LOCAL_TAX_I - 지방소득세
		*/
		calculateInstallment : function(record, type, fieldName, newValue, taxLabel)	{
			var install_cnt = Unilite.nvl(panelResult.getValue("INSTALL_COUNT"), 1) ;
			var totTaxI = record.get(type);
			
			var applyCnt = 0 ;
			var remainCnt = install_cnt ;
			var paidAmt = 0
			
			//1차분납 확인
			if(this.checkApply(record, install_cnt, 1))	{	
				applyCnt++;
				remainCnt--;
			}
			//2차분납 확인
			if(this.checkApply(record, install_cnt, 2))	{
				applyCnt++;
				remainCnt--;
			}
			//3차분납 확인
			if(this.checkApply(record, install_cnt, 3))	{
				applyCnt++;
				remainCnt--;
			}
			
			// 남은 차수가 1이면 총세금과 분납세금의 누적합과  입력금액의 합이 일치하는지 확인한다. 일치할 경우 입력한 금액을 그대로 사용한다.
			if(remainCnt == 1)	{
				
				var sumTaxI = 0
				if (newValue==null)	{
					newValue = totTaxI;
					sumTaxI  = totTaxI;
					record.set(type+"_01", newValue);
				} else {
					sumTaxI = record.get(type+"_01") + record.get(type+"_02") + record.get(type+"_03") + newValue - record.get(fieldName);
				}
				return this.checkAllPayment(record, sumTaxI, totTaxI,  taxName);
			} else if(remainCnt == 2) {
				
				if(install_cnt == 2)	{
					if (newValue==null)	{
						newValue = Math.floor(totTaxI/10/2)*10;
						fieldName = type+"_01";
						record.set(type+"_01", newValue);
					}
					var sumTaxI =  newValue ;
					if(fieldName == (type+"_01"))	{					// 1차분납 값을 입력한 경우 2차분납 계산
						record.set(type+"_02", totTaxI -sumTaxI );
					} else {
						record.set(type+"_01", totTaxI -sumTaxI );
					}
				} else if(this.checkApply(record, install_cnt, 1) )	{	// 1차분납이 급여반영인경우 -  2차, 3차만 남아 있음
					if (newValue==null)	{
						newValue = Math.floor((totTaxI-record.get(type+"_01"))/10/2)*10;
						fieldName = type+"_02";
						record.set(type+"_02", newValue);
					}
					var sumTaxI = record.get(type+"_01") + newValue ;
					if(fieldName == (type+"_02"))	{				    // 2차분납 입력한 경우 2차분납은 입력한 금액 사용,  3차분납 계산
						record.set(type+"_03", totTaxI -sumTaxI );
					} else {
						record.set(type+"_02", totTaxI -sumTaxI );		// 3차분납 입력한 경우 3차분납은 입력한 금액 사용,  2차분납 계산
					}
				} 
			} else if(remainCnt == 3) {	
				var dividedTax = 0 ;
				var lastDivided = 0;
				if (newValue==null)	{
					newValue = Math.floor(totTaxI/10/3)*10;
					fieldName = type+"_01";
					record.set(type+"_01", newValue);
					dividedTax = newValue;
					lastDivided =  totTaxI - newValue - dividedTax ;
				} else {
					remainTax = totTaxI -  newValue;					// 남은 금액을 계산하기 위해 입력한 금액을 납부할 세금에 제외시킴
					dividedTax = Math.floor(remainTax/10 / 2 ) * 10    // 입력한 차수를 제외한 수로 나눔
					lastDivided = dividedTax + (remainTax - (Unilite.multiply(dividedTax , 2)) )  // 끝원처리
				}
				
				if(fieldName == (type+"_01"))	{				    
					record.set(type+"_02", dividedTax );
					record.set(type+"_03", lastDivided );
				} else if(fieldName == (type+"_02"))	{				    
					record.set(type+"_01", dividedTax );
					record.set(type+"_03", lastDivided );
				} else {
					record.set(type+"_01", dividedTax );
					record.set(type+"_02", lastDivided );		
				}
			}
			return true;
		},
		calculateInstallmentAll : function(record, type, taxLabel)	{
			var install_cnt = Unilite.nvl(panelResult.getValue("INSTALL_COUNT"), 1) ;
			var totTaxI = record.get(type);
			var dividedTax;
			
			var applyCnt = 0 ;
			var remainCnt = install_cnt ;
			
			//1차분납 확인
			if(this.checkApply(record, install_cnt, 1))	{	
				applyCnt++;
				remainCnt--;
			}
			//2차분납 확인
			if(this.checkApply(record, install_cnt, 2))	{
				applyCnt++;
				remainCnt--;
			}
			//3차분납 확인
			if(this.checkApply(record, install_cnt, 3))	{
				applyCnt++;
				remainCnt--;
			}
			
			// 남은 차수가 1이면 총세금과 분납세금의 누적합과  입력금액의 합이 일치하는지 확인한다. 일치할 경우 입력한 금액을 그대로 사용한다.
			if(remainCnt == 1)	{
				record.set(type+"_01", totTaxI);
			} else if(remainCnt == 2) {
				if(install_cnt == 2)	{
					dividedTax = Math.floor(totTaxI/10/2)*10;
					record.set(type+"_01", dividedTax);
					record.set(type+"_02", totTaxI - dividedTax );
				} else if(this.checkApply(record, install_cnt, 1) )	{	// 1차분납이 급여반영인경우 -  2차, 3차만 남아 있음
				
					dividedTax = Math.floor((totTaxI-record.get(type+"_01"))/10/2)*10;
					record.set(type+"_02", dividedTax);
					record.set(type+"_03", totTaxI -dividedTax );
					
				} 
			} else if(remainCnt == 3) {	
				dividedTax = Math.floor(totTaxI/10/3)*10;
				var lastDivided =  totTaxI - dividedTax - dividedTax ;
				record.set(type+"_01", dividedTax);
				record.set(type+"_02", dividedTax );
				record.set(type+"_03", lastDivided );
			}
			return true;
		},
		checkApply : function(record, totalCnt, div_order )	{
			return (totalCnt >= div_order && record.get("PAY_APPLY_YN_0"+div_order.toString()) == "Y");
		}
		
	});
	
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function(type, fieldName, newValue, oldValue, record, eopt) {
			var rv = true;	
			if(newValue == oldValue)	{
				return true;
			}
			if( UniUtils.indexOf( fieldName , [ 'IN_TAX_I_01','SP_TAX_I_01','LOCAL_TAX_I_01',
												'IN_TAX_I_02','SP_TAX_I_02','LOCAL_TAX_I_02',
												'IN_TAX_I_03','SP_TAX_I_03','LOCAL_TAX_I_03']))	{
				if(Ext.isEmpty(newValue))	{
					newValue = 0;
				}
			}
			var install_cnt = Unilite.nvl(panelResult.getValue("INSTALL_COUNT"), 1) ;
			switch(fieldName) {	
				case 'IN_TAX_I_01':
					
					if(install_cnt == 1)	{
						rv = UniAppManager.app.checkAllPayment ( record.obj, newValue, record.get("IN_TAX_I"), "소득세" );
					} else {
						rv = UniAppManager.app.calculateInstallment(record.obj, "IN_TAX_I", fieldName, newValue, "소득세" );
					}
					break;
				case 'IN_TAX_I_02':
					if(install_cnt == 1)	{
						rv = UniAppManager.app.checkAllPaymen ( record.obj, newValue, record.get("IN_TAX_I"), "소득세" );
					} else {
						rv =  UniAppManager.app.calculateInstallment(record.obj, "IN_TAX_I", fieldName, newValue, "소득세" );
					}
					break;
				case 'IN_TAX_I_03':
					if(install_cnt == 1)	{
						rv = UniAppManager.app.checkAllPaymen ( record.obj, newValue, record.get("IN_TAX_I"), "소득세" );
					} else {
						rv =  UniAppManager.app.calculateInstallment(record.obj, "IN_TAX_I", fieldName, newValue, "소득세" );
					}
					break;
				case 'SP_TAX_I_01':
					if(install_cnt == 1)	{
						rv =UniAppManager.app.checkAllPaymen ( record.obj, newValue, record.get("SP_TAX_I"), "농특세" );
					} else {
						rv = UniAppManager.app.calculateInstallment(record.obj, "SP_TAX_I", fieldName, newValue, "농특세" );
					}
					break;
				case 'SP_TAX_I_02':
					if(install_cnt == 1)	{
						rv = UniAppManager.app.checkAllPaymen ( record.obj, newValue, record.get("SP_TAX_I"), "농특세" );
					} else {
						rv =  UniAppManager.app.calculateInstallment(record.obj, "SP_TAX_I", fieldName, newValue, "농특세" );
					}
					break;
				case 'SP_TAX_I_03':
					if(install_cnt == 1)	{
						rv = UniAppManager.app.checkAllPaymen ( record.obj, newValue, record.get("SP_TAX_I"), "농특세" );
					} else {
						rv =  UniAppManager.app.calculateInstallment(record.obj, "SP_TAX_I", fieldName, newValue, "농특세" );
					}
					break;
				case 'LOCAL_TAX_I_01':
					if(install_cnt == 1)	{
						rv =UniAppManager.app.checkAllPaymen ( record.obj, newValue, record.get("LOCAL_TAX_I"), "지방소득세" );
					} else {
						rv = UniAppManager.app.calculateInstallment(record.obj, "LOCAL_TAX_I", fieldName, newValue, "지방소득세" );
					}
					break;
				case 'LOCAL_TAX_I_02':
					if(install_cnt == 1)	{
						rv = UniAppManager.app.checkAllPaymen ( record.obj, newValue, record.get("LOCAL_TAX_I"), "지방소득세" );
					} else {
						rv =  UniAppManager.app.calculateInstallment(record.obj, "LOCAL_TAX_I", fieldName, newValue, "지방소득세" );
					}
					break;
				case 'LOCAL_TAX_I_03':
					if(install_cnt == 1)	{
						rv = UniAppManager.app.checkAllPaymen ( record.obj, newValue, record.get("LOCAL_TAX_I"), "지방소득세" );
					} else {
						rv =  UniAppManager.app.calculateInstallment(record.obj, "LOCAL_TAX_I", fieldName, newValue, "지방소득세" );
					}
					break;
				default : break;
			}
			return rv;
		}
	});
	
};


</script>
