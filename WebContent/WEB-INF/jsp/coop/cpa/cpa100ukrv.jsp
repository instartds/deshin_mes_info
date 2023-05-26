<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="cpa100ukrv"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="cpa100ukrv"/> 			<!-- 사업장 		--> 
	<t:ExtComboStore comboType="AU" comboCode="YP11"/>	<!-- 조합원구분 	-->
	<t:ExtComboStore comboType="AU" comboCode="YP12"/>	<!-- 회원등급		-->
	<t:ExtComboStore comboType="AU" comboCode="YP13"/>	<!-- 구매등급 		-->
	<t:ExtComboStore comboType="AU" comboCode="YP14"/>	<!-- 결제방법 		-->
	<t:ExtComboStore comboType="AU" comboCode="B232"/>	<!-- 주소구분 		-->
</t:appConfig>
<style type= "text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
#search_panel2 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript">
  var protocol =   ("https:" == document.location.protocol)  ? "https" : "http"  ;
  if(protocol == "https")	{
	  document.write( unescape( "%3Cscript src='"+ protocol+ "://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E")  );
  }else {
  	document.write( unescape( "%3Cscript src='"+ protocol+ "://dmaps.daum.net/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E") );
  }
</script><!-- Unilite.popup('ZIP',..) -->
<script type="text/javascript" >
var detailWin;
var excelWindow; // 엑셀참조
var excelGradWindow; // 엑셀참조

function appMain() {
	var outDivCode = UserInfo.divCode;
	
	var memberStore = Unilite.createStore('cpa100ukrvMemberStore', {  // 조합원 여부
	    fields: ['text', 'value'],
		data :  [
			        {'text':'예'		, 'value':'Y'},
			        {'text':'아니오'	, 'value':'N'}
	    		]
	});
	
	var cooptorStore = Unilite.createStore('cpa100ukrvGraduateStore', {  // 졸업여부
	    fields: ['text', 'value'],
		data :  [
			        {'text':'재학'		, 'value':'N'},
			        {'text':'졸업'		, 'value':'Y'}
	    		]
	});
	
	var cooptorStore = Unilite.createStore('cpa100ukrvRepaymentStore', {  //반환여부
	    fields: ['text', 'value'],
		data :  [
			        {'text':'반환'		, 'value':'Y'},
			        {'text':'미반환'		, 'value':'N'}
	    		]
	});

	var genderStore = Unilite.createStore('cpa100ukrvGenderStore', {  // 성별
	    fields: ['text', 'value'],
		data :  [
			        {'text':'남자'		, 'value':'1'},
			        {'text':'여자'		, 'value':'2'}
	    		]
	});
	/**
	 * Model 정의 
	 * @type 
	 */
	
	Unilite.defineModel('cpa100ukrvModel', {
		// pkGen : user, system(default)
	    fields: [
				 {name: 'COMP_CODE' 		   ,text:'법인코드' 		,type:'string'	},
				 {name: 'COOPTOR_ID' 		   ,text:'조합원ID' 		,type:'string'	, isPk:true, pkGen:'user' ,allowBlank:false},
				 {name: 'COOPTOR_NAME' 		   ,text:'조합원명' 		,type:'string'	,allowBlank:false},
				 {name: 'INVEST_CNT' 		   ,text:'출자구좌수' 		,type:'int'	,allowBlank:false},
				 {name: 'DIVID_CNT' 		   ,text:'배당회수' 		,type:'uniQty'	},
				 {name: 'COOPTOR_TYPE' 		   ,text:'조합원구분' 		,type:'string'	,allowBlank:false, comboType:'AU',comboCode:'YP11'},
				 {name: 'START_DATE'		   ,text:'가입일자' 		,type:'uniDate'	,allowBlank:false},
				 {name: 'BANK_CODE'			   ,text:'은행코드' 		,type:'string'	},
				 {name: 'BANK_NAME'			   ,text:'은행명' 		,type:'string'	},
				 {name: 'BANKBOOK_NUM' 		   ,text:'계좌번호' 		,type:'string'	},
				 {name: 'GRADUATE_YN'		   ,text:'졸업여부' 		,type:'string'	,store: Ext.data.StoreManager.lookup('cpa100ukrvGraduateStore') , defaultValue:'N'},
				 {name: 'GRADUATE_DATE'		   ,text:'졸업일자' 		,type:'uniDate'	},
				 {name: 'REPAYMENT_YN'		   ,text:'반환여부' 		,type:'string'	,store: Ext.data.StoreManager.lookup('cpa100ukrvRepaymentStore')},
				 {name: 'REPAYMENT_DATE'	   ,text:'반환일자' 		,type:'uniDate'	},	 
				 {name: 'REMARK'			   ,text:'비고'			,type:'string'  },
				 {name: 'PASSWORD'			   ,text:'비밀번호'		,type:'string'  ,defaultValue : 1},
				 /* MasterGrid Hidden:true*/
				 {name: 'UNIV_NUMB' 		   ,text:'학번/사번' 		,type:'string'	},
				 {name: 'CELL_PHONE' 		   ,text:'핸드폰번호' 		,type:'string'	},	
				 {name: 'DEPT_NAME1' 		   ,text:'소속1' 			,type:'string'	},
				 {name: 'DEPT_NAME2'		   ,text:'소속2' 			,type:'string'	},
				 {name: 'GENDER'			   ,text:'성별' 			,type:'string'	,store: Ext.data.StoreManager.lookup('cpa100ukrvGenderStore')},
				 {name: 'ADDRESS_TYPE'		   ,text:'주소구분' 		,type:'string'	, comboType:'AU',comboCode:'B232'},
				 {name: 'ZIP_CODE'			   ,text:'우편번호' 		,type:'string'	},
				 {name: 'ADDR1'				   ,text:'주소1' 			,type:'string'	},
				 {name: 'ADDR2'				   ,text:'주소2' 			,type:'string'	},	 
				 {name: 'CASH_RECEIPT_AUTO_YN' ,text:'현금영수증 자동발급 여부' 	,type:'string'	, defaultValue:'N'},
				 {name: 'CASH_MEMBER_NO'	   ,text:'현금영수증 거래시 발행번호' ,type:'string'	},
				 {name: 'MEMBER_YN'			   ,text:'조합원여부' 		,type:'string'	, defaultValue:'Y' ,store: Ext.data.StoreManager.lookup('cpa100ukrvMemberStore')},
				 {name: 'INVEST_AMT' 		   ,text:'출자금액' 		,type:'uniPrice'},
				 {name: 'REPAYMENT_AMT' 	   ,text:'반환금액' 		,type:'uniPrice'},
				 {name: 'TOT_POINT'			   ,text:'총포인트' 		,type:'uniPrice'},
				 {name: 'INVEST_POINT'		   ,text:'출자포인트' 		,type:'uniPrice'},
				 {name: 'ADD_POINT'			   ,text:'누적포인트' 		,type:'uniPrice'},
				 {name: 'USE_POINT'			   ,text:'사용포인트' 		,type:'uniPrice'},
				 {name: 'MEMBER_LEVEL'		   ,text:'회원등급' 		,type:'string'	, comboType:'AU',comboCode:'YP12'},
				 {name: 'PURCHASE_LEVEL'	   ,text:'구매등급' 		,type:'string'	, comboType:'AU',comboCode:'YP13'},
				 {name: 'OPR_FLAG'	   		   ,text:'구분' 			,type:'string'}
			]
	});
	
	Unilite.Excel.defineModel('excel.cpa100.sheet01', {
	    fields: [
	    	{name: '_EXCEL_JOBID' 		 	 ,text:'EXCEL_JOBID',type: 'string'},
	    	{name: 'COMP_CODE' 		   		   ,text:'법인코드' 		,type:'string'	},
				 {name: 'COOPTOR_ID' 		   ,text:'조합원ID' 		,type:'string'	, isPk:true, pkGen:'user' ,allowBlank:false},
				 {name: 'COOPTOR_NAME' 		   ,text:'조합원명' 		,type:'string'	,allowBlank:false},
				 {name: 'INVEST_CNT' 		   ,text:'출자구좌수' 		,type:'uniQty'	,allowBlank:false},
				 {name: 'COOPTOR_TYPE' 		   ,text:'조합원구분' 		,type:'string'	,allowBlank:false, comboType:'AU',comboCode:'YP11'},
				 {name: 'START_DATE'		   ,text:'가입일자' 		,type:'uniDate'	,allowBlank:false},
				 {name: 'BANK_CODE'			   ,text:'은행코드' 		,type:'string'	,allowBlank:false},
				 {name: 'BANK_NAME'			   ,text:'은행명' 		,type:'string'	},
				 {name: 'BANKBOOK_NUM' 		   ,text:'계좌번호' 		,type:'string'	},
				 {name: 'GRADUATE_YN'		   ,text:'졸업여부' 		,type:'string'	,store: Ext.data.StoreManager.lookup('cpa100ukrvGraduateStore') , defaultValue:'N'},
				 {name: 'GRADUATE_DATE'		   ,text:'졸업일자' 		,type:'uniDate'	},
				 {name: 'REPAYMENT_YN'		   ,text:'반환여부' 		,type:'string'	,store: Ext.data.StoreManager.lookup('cpa100ukrvRepaymentStore')},
				 {name: 'REPAYMENT_DATE'	   ,text:'반환일자' 		,type:'uniDate'	},	 
				 {name: 'REMARK'			   ,text:'비고'			,type:'string'  },
				 {name: 'PASSWORD'			   ,text:'비밀번호'		,type:'string'  ,defaultValue : 1},
				 /* MasterGrid Hidden:true*/
				 {name: 'UNIV_NUMB' 		   ,text:'학번/사번' 		,type:'string'	},
				 {name: 'CELL_PHONE' 		   ,text:'핸드폰번호' 		,type:'string'	},	
				 {name: 'DEPT_NAME1' 		   ,text:'소속1' 			,type:'string'	},
				 {name: 'DEPT_NAME2'		   ,text:'소속2' 			,type:'string'	},
				 {name: 'GENDER'			   ,text:'성별' 			,type:'string'	,store: Ext.data.StoreManager.lookup('cpa100ukrvGenderStore')},
				 {name: 'ADDRESS_TYPE'		   ,text:'주소구분' 		,type:'string'	, comboType:'AU',comboCode:'B232'},
				 {name: 'ZIP_CODE'			   ,text:'우편번호' 		,type:'string'	},
				 {name: 'ADDR1'				   ,text:'주소1' 			,type:'string'	},
				 {name: 'ADDR2'				   ,text:'주소2' 			,type:'string'	},	 
				 {name: 'CASH_RECEIPT_AUTO_YN' ,text:'현금영수증 자동발급 여부' 	,type:'string'	, defaultValue:'N'},
				 {name: 'CASH_MEMBER_NO'	   ,text:'현금영수증 거래시 발행번호' ,type:'string'	},
				 {name: 'MEMBER_YN'			   ,text:'조합원여부' 		,type:'string'	, defaultValue:'Y' ,store: Ext.data.StoreManager.lookup('cpa100ukrvMemberStore')},
				 {name: 'INVEST_AMT' 		   ,text:'출자금액' 		,type:'uniPrice'},
				 {name: 'REPAYMENT_AMT' 	   ,text:'반환금액' 		,type:'uniPrice'},
				 {name: 'TOT_POINT'			   ,text:'총포인트' 		,type:'uniPrice'},
				 {name: 'INVEST_POINT'		   ,text:'출자포인트' 		,type:'uniPrice'},
				 {name: 'ADD_POINT'			   ,text:'누적포인트' 		,type:'uniPrice'},
				 {name: 'USE_POINT'			   ,text:'사용포인트' 		,type:'uniPrice'},
				 {name: 'UPDATE_DB_TIME'	   ,text:'엑셀업로드시간' 	,type:'uniDate'},
				 {name: 'MEMBER_LEVEL'		   ,text:'회원등급' 		,type:'string'	, comboType:'AU',comboCode:'YP12'},
				 {name: 'PURCHASE_LEVEL'	   ,text:'구매등급' 		,type:'string'	, comboType:'AU',comboCode:'YP13'}
		]
	});
	
	Unilite.Excel.defineModel('excel.cpa100.sheet02', {
	    fields: [
	    	{name: '_EXCEL_JOBID' 		 	 ,text:'EXCEL_JOBID',type: 'string'},
	    	{name: 'COMP_CODE' 		   		   ,text:'법인코드' 		,type:'string'	},
				 {name: 'COOPTOR_ID' 		   ,text:'조합원ID' 		,type:'string'	, isPk:true, pkGen:'user' ,allowBlank:false},
				 {name: 'COOPTOR_NAME' 		   ,text:'조합원명' 		,type:'string'	,allowBlank:false},
				 {name: 'INVEST_CNT' 		   ,text:'출자구좌수' 		,type:'uniQty'	,allowBlank:false},
				 {name: 'COOPTOR_TYPE' 		   ,text:'조합원구분' 		,type:'string'	,allowBlank:false, comboType:'AU',comboCode:'YP11'},
				 {name: 'START_DATE'		   ,text:'가입일자' 		,type:'uniDate'	,allowBlank:false},
				 {name: 'BANK_CODE'			   ,text:'은행코드' 		,type:'string'	,allowBlank:false},
				 {name: 'BANK_NAME'			   ,text:'은행명' 		,type:'string'	,allowBlank:false},
				 {name: 'BANKBOOK_NUM' 		   ,text:'계좌번호' 		,type:'string'	,allowBlank:false},
				 {name: 'GRADUATE_YN'		   ,text:'졸업여부' 		,type:'string'	,store: Ext.data.StoreManager.lookup('cpa100ukrvGraduateStore') , defaultValue:'N'},
				 {name: 'GRADUATE_DATE'		   ,text:'졸업일자' 		,type:'uniDate'	},
				 {name: 'REPAYMENT_YN'		   ,text:'반환여부' 		,type:'string'	,store: Ext.data.StoreManager.lookup('cpa100ukrvRepaymentStore')},
				 {name: 'REPAYMENT_DATE'	   ,text:'반환일자' 		,type:'uniDate'	},	 
				 {name: 'REMARK'			   ,text:'비고'			,type:'string'  },
				 {name: 'PASSWORD'			   ,text:'비밀번호'		,type:'string'  ,defaultValue : 1},
				 /* MasterGrid Hidden:true*/
				 {name: 'UNIV_NUMB' 		   ,text:'학번/사번' 		,type:'string'	},
				 {name: 'CELL_PHONE' 		   ,text:'핸드폰번호' 		,type:'string'	},	
				 {name: 'DEPT_NAME1' 		   ,text:'소속1' 			,type:'string'	},
				 {name: 'DEPT_NAME2'		   ,text:'소속2' 			,type:'string'	},
				 {name: 'GENDER'			   ,text:'성별' 			,type:'string'	,store: Ext.data.StoreManager.lookup('cpa100ukrvGenderStore')},
				 {name: 'ADDRESS_TYPE'		   ,text:'주소구분' 		,type:'string'	, comboType:'AU',comboCode:'B232'},
				 {name: 'ZIP_CODE'			   ,text:'우편번호' 		,type:'string'	},
				 {name: 'ADDR1'				   ,text:'주소1' 			,type:'string'	},
				 {name: 'ADDR2'				   ,text:'주소2' 			,type:'string'	},	 
				 {name: 'CASH_RECEIPT_AUTO_YN' ,text:'현금영수증 자동발급 여부' 	,type:'string'	, defaultValue:'N'},
				 {name: 'CASH_MEMBER_NO'	   ,text:'현금영수증 거래시 발행번호' ,type:'string'	},
				 {name: 'MEMBER_YN'			   ,text:'조합원여부' 		,type:'string'	, defaultValue:'Y' ,store: Ext.data.StoreManager.lookup('cpa100ukrvMemberStore')},
				 {name: 'INVEST_AMT' 		   ,text:'출자금액' 		,type:'uniPrice'},
				 {name: 'REPAYMENT_AMT' 	   ,text:'반환금액' 		,type:'uniPrice'},
				 {name: 'TOT_POINT'			   ,text:'총포인트' 		,type:'uniPrice'},
				 {name: 'INVEST_POINT'		   ,text:'출자포인트' 		,type:'uniPrice'},
				 {name: 'ADD_POINT'			   ,text:'누적포인트' 		,type:'uniPrice'},
				 {name: 'USE_POINT'			   ,text:'사용포인트' 		,type:'uniPrice'},
				 {name: 'UPDATE_DB_TIME'	   ,text:'엑셀업로드시간' 	,type:'uniDate'},
				 {name: 'MEMBER_LEVEL'		   ,text:'회원등급' 		,type:'string'	, comboType:'AU',comboCode:'YP12'},
				 {name: 'PURCHASE_LEVEL'	   ,text:'구매등급' 		,type:'string'	, comboType:'AU',comboCode:'YP13'},
				 {name: 'OPR_FLAG'	   		   ,text:'구분' 			,type:'string'}
		]
	});
	
	function openExcelWindow() {
		
			var me = this;
	        var vParam = {};
	        var appName = 'Unilite.com.excel.ExcelUploadWin';
/*			if(!directMasterStore.isDirty())	{
				//directMasterStore.loadData({});
	        }else {
	        	if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
	        		UniAppManager.app.onSaveDataButtonDown();
	        		return;
	        	}else {
	        		//directMasterStore.loadData({});
	        	}
	        }*/
            
            if(!excelWindow) {
            	excelWindow =  Ext.WindowMgr.get(appName);
                excelWindow = Ext.create( appName, {
                		modal: false,
                		excelConfigName: 'cpa100',
                		extParam: { 
                		},
                        grids: [{
                        		itemId: 'grid01',
                        		title: '조합원정보',                        		
                        		useCheckbox: false,
                        		model : 'excel.cpa100.sheet01',
                        		readApi: 'cpa100ukrvService.selectExcelUploadSheet1',
                        		columns:[{dataIndex:'_EXCEL_JOBID' 		,width:80, hidden: true	},
                        				 {dataIndex:'COOPTOR_ID' 		,width:150  ,allowBlank:false},
										 {dataIndex:'COOPTOR_NAME' 		,width:100	,allowBlank:false},
										 {dataIndex:'UNIV_NUMB' 		,width:100	,allowBlank:false},
										 {dataIndex:'COOPTOR_TYPE' 		,width:80	,allowBlank:false},
										 {dataIndex:'INVEST_CNT' 		,width:80	,allowBlank:false},
										 {dataIndex:'INVEST_AMT' 		,width:80	},
										 {dataIndex:'START_DATE' 		,width:100	,allowBlank:false},
										 {dataIndex:'BANK_NAME' 		,width:100	,allowBlank:false,
										 editor: Unilite.popup('BANK_G', {
										 		  				extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
																listeners: {'onSelected': {
																					fn: function(records, type) {
																		                    console.log('records : ', records);
																		                    Ext.each(records, function(record,i) {													                   
																							        			if(i==0) {
																															masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
																									        			} else {
																									        				UniAppManager.app.onNewDataButtonDown();
																									        				masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
																									        			}
																							}); 
																					},
																					scope: this
																			},
																			'onClear': function(type) {
																				masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
																			}
																	}
												})
										  },
										 {dataIndex:'BANK_CODE' 		,width:100	,hidden:true},
										 {dataIndex:'BANKBOOK_NUM' 		,width:100	,allowBlank:false},
										 {dataIndex:'UPDATE_DB_TIME' 	,width:100	,hidden:true}
								]
                        }],
                        listeners: {
                            close: function() {
                                this.hide();
                            }
/*                            ,show:function()	{
                            	var grid = this.down('#grid01');
                            	grid.getStore().loadData({});
                            	if(Ext.isDefined(grid.getEl()))	{
                            		grid.getEl().mask();
                            	}
                            }*/
                        },
                        onApply:function()	{
                        	/*var grid = this.down('#grid01');
                			var records = grid.getSelectionModel().getSelection();       		
							Ext.each(records, function(record,i){	
						        	UniAppManager.app.onNewDataButtonDown();
						        	masterGrid.setExcelData(record.data);					///				        
						    }); 
							grid.getStore().remove(records);*/
                        	excelWindow.getEl().mask('로딩중...','loading-indicator');
                        	var me = this;
                        	var grid = this.down('#grid01');
                			var records = grid.getStore().getAt(0);	
				        	var param = {"_EXCEL_JOBID": records.get('_EXCEL_JOBID')};
				        	//if(Ext.isEmpty(records.data._EXCEL_HAS_ERROR)) {
							cpa100ukrvService.selectExcelUploadSheet1(param, function(provider, response){
						    	var store = masterGrid.getStore();
						    	var records = response.result;
						    	store.insert(0, records);
						    	console.log("response",response)
								excelWindow.getEl().unmask();
								grid.getStore().removeAll();
								me.hide();
						    });
                		}
                 });
            }
            excelWindow.center();
            excelWindow.show();
	}
	
	
	
	function openExcelGradWindow() {   // 졸업일자 및 반환일자 정보
		
			var me = this;
	        var vParam = {};
	        var appName = 'Unilite.com.excel.ExcelUploadWin';
/*	        if(!directMasterStore.isDirty())	{
				directMasterStore.loadData({});
	        }else {
	        	if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
	        		UniAppManager.app.onSaveDataButtonDown();
	        		return;
	        	}else {
	        		directMasterStore.loadData({});
	        	}
	        }
*/
            
            if(!excelGradWindow) {
            	excelGradWindow =  Ext.WindowMgr.get(appName);
                excelGradWindow = Ext.create( appName, {
                		modal: false,
                		excelConfigName: 'cpa101',
                		extParam: { 
                		},
                        grids: [{
                        		itemId: 'grid02',
                        		title: '졸업일자 및 반환일자 정보',                        		
                        		useCheckbox: false,
                        		model : 'excel.cpa100.sheet02',
                        		readApi: 'cpa100ukrvService.selectExcelUploadSheet2',
                        		columns:[{dataIndex:'_EXCEL_JOBID' 		,width:80, hidden: true	},
                        				 {dataIndex:'COOPTOR_ID' 		,width:150  ,allowBlank:false},
										 {dataIndex:'UNIV_NUMB' 		,width:100	,allowBlank:false},
										 {dataIndex:'GRADUATE_YN' 		,width:80	,allowBlank:false},
										 {dataIndex:'GRADUATE_DATE' 	,width:80	,allowBlank:false},
										 {dataIndex:'REPAYMENT_YN' 		,width:80	,allowBlank:false},
										 {dataIndex:'REPAYMENT_DATE' 	,width:80	,allowBlank:false},
										 {dataIndex:'BANK_CODE' 		,width:100	,hidden:true},
										 {dataIndex:'BANK_NAME' 		,width:100	},
										 {dataIndex:'BANKBOOK_NUM' 		,width:150	},
										 {dataIndex:'MEMBER_YN' 		,width:80	,allowBlank:false},
										 {dataIndex:'UPDATE_DB_TIME' 	,width:100	,hidden:true},
										 {dataIndex:'OPR_FLAG' 			,width:100	,hidden:true}
								]
                        }],
                        listeners: {
                            close: function() {
                                this.hide();
                            }
                           /* ,show:function()	{
                            	var grid = this.down('#grid02');
                            	grid.getStore().loadData({});
                            	if(Ext.isDefined(grid.getEl()))	{
                            		grid.getEl().mask();
                            	}
                            }*/
                        },
                        onApply:function()	{
                        	/*var grid = this.down('#grid02');
                			var records = grid.getSelectionModel().getSelection();       		
							Ext.each(records, function(record,i){
									UniAppManager.app.onNewDataButtonDown();
						        	masterGrid.setExcelData2(record.data);	
						    }); 
							grid.getStore().remove(records);*/
                        	excelGradWindow.getEl().mask('로딩중...','loading-indicator');
                        	var me = this;
                        	var grid = this.down('#grid02');
                			var records = grid.getStore().getAt(0);	
				        	var param = {"_EXCEL_JOBID": records.get('_EXCEL_JOBID')/*,
				        				 "BANK_NAME" : records.get('BANK_NAME'),
				        				 "BANKBOOK_NUM" : records.get('BANKBOOK_NUM')*/
				        	};
				        	//if(Ext.isEmpty(records.data._EXCEL_HAS_ERROR)) {
							cpa100ukrvService.selectExcelUpload2(param, function(provider, response){
						    	var store = masterGrid.getStore();
						    	var records = response.result;
						    	var update = 'U'
						    	for(var i=0; i<records.length; i++) {
									records[i].OPR_FLAG = update;
								}
						    	store.insert(0, records);
						    	console.log("response",response)
								excelGradWindow.getEl().unmask();
								grid.getStore().removeAll();
								me.hide();
						    });
                		}
                 });
            }
            excelGradWindow.center();
            excelGradWindow.show();
	}
	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'cpa100ukrvService.selectList',
			update: 'cpa100ukrvService.updateDetail',
			create: 'cpa100ukrvService.insertDetail',
			destroy: 'cpa100ukrvService.deleteDetail',
			syncAll: 'cpa100ukrvService.saveAll'
		}
	});	  
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('cpa100ukrvMasterStore',{
			model: 'cpa100ukrvModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
            	allDeleteable :false,
	            useNavi : true			// prev | next 버튼 사용
            },
            
            proxy: directProxy
            
            
			// Store 관련 BL 로직
            // 검색 조건을 통해 DB에서 데이타 읽어 오기 
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('cpa100ukrvSearchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
			}
			// 수정/추가/삭제된 내용 DB에 적용 하기 
			,saveStore : function(config)	{
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					
					this.syncAllDirect(config);
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
			listeners:{
				update:function( store, record, operation, modifiedFieldNames, eOpts )	{
					if(masterGrid.isVisible())	{
						detailForm.setActiveRecord(record);
            		}
				}	
			}
		});

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('cpa100ukrvSearchForm',{
		title: '검색조건',
		defaultType: 'uniSearchSubPanel',
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		defaults: {
			autoScroll:true
	  	},
		items:[{
			title: '기본정보', 	
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',   			
	    	items:[{	    
				fieldLabel: '조합원 ID',
				name: 'COOPTOR_ID',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('COOPTOR_ID', newValue);
					}
				}
			},{
			    fieldLabel: '조합원명',
				name: 'COOPTOR_NAME',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('COOPTOR_NAME', newValue);
					}
				}
			},{
				fieldLabel: '구분',
				name: 'COOPTOR_TYPE' ,
				xtype: 'uniCombobox' ,
				comboType: 'AU',
				comboCode: 'YP11',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('COOPTOR_TYPE', newValue);
					}
				}
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '졸업여부',						            		
				items: [{
					boxLabel : '전체', 
					width: 60,
					name: 'GRADUATE_YN',
					inputValue: '',
					checked: true 
				},{
					boxLabel: '재학', 
					width: 60, 
					name: 'GRADUATE_YN',
					inputValue: 'N'
				},{
					boxLabel : '졸업', 
					width: 60,
					name: 'GRADUATE_YN',
					inputValue: 'Y'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('GRADUATE_YN').setValue(newValue.GRADUATE_YN);
					}
				}	
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '반환여부',						            		
				items: [{
					boxLabel: '전체', 
					width: 60, 
					name: 'REPAYMENT_YN',
					inputValue: '',
					checked: true 
				},{
					boxLabel: '미반환', 
					width: 60, 
					name: 'REPAYMENT_YN',
					inputValue: 'N'
				},{
					boxLabel : '반환', 
					width: 60,
					name: 'REPAYMENT_YN',
					inputValue: 'Y'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('REPAYMENT_YN').setValue(newValue.REPAYMENT_YN);
					}
				}
			}]            			 
		}]
	});	//end panelSearch    
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		weight:-100,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{	    
			fieldLabel: '조합원ID',
			name: 'COOPTOR_ID',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('COOPTOR_ID', newValue);
				}
			}
		},{
		    fieldLabel: '조합원명',
			name: 'COOPTOR_NAME',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('COOPTOR_NAME', newValue);
				}
			}
		},{
			fieldLabel: '구분',
			name: 'COOPTOR_TYPE' ,
			xtype: 'uniCombobox' ,
			comboType: 'AU',
			comboCode: 'YP11',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('COOPTOR_TYPE', newValue);
				}
			}
		},{
			xtype: 'radiogroup',		            		
			fieldLabel: '졸업여부',						            		
			items: [{
				boxLabel : '전체', 
				width: 60,
				name: 'GRADUATE_YN',
				inputValue: '',
				checked: true 
			},{
				boxLabel: '재학', 
				width: 60, 
				name: 'GRADUATE_YN',
				inputValue: 'N'
			},{
				boxLabel : '졸업', 
				width: 60,
				name: 'GRADUATE_YN',
				inputValue: 'Y'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.getField('GRADUATE_YN').setValue(newValue.GRADUATE_YN);
				}
			}
		},{
			xtype: 'radiogroup',		            		
			fieldLabel: '반환여부',						            		
			items: [{
				boxLabel: '전체', 
				width: 50, 
				name: 'REPAYMENT_YN',
				inputValue: '',
				checked: true 
			},{
				boxLabel: '미반환', 
				width: 60, 
				name: 'REPAYMENT_YN',
				inputValue: 'N'
			},{
				boxLabel : '반환', 
				width: 60,
				name: 'REPAYMENT_YN',
				inputValue: 'Y'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.getField('REPAYMENT_YN').setValue(newValue.REPAYMENT_YN);
				}
			}
		}]	
    });
	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('cpa100ukrvGrid', {
    	region:'center',
    	store: directMasterStore,
        layout : 'fit',
        tbar: [{
			xtype: 'splitbutton',
           	itemId:'refTool',
			text: '참조...',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'excelMemberBtn',
					text: '조합원 등록 엑셀참조',
		        	handler: function() {
			        	openExcelWindow();
			        }
				},{
					itemId: 'excelGradBtn',
					text: '졸업일자 및 반환일자 엑셀참조',
		        	handler: function() {
			        	openExcelGradWindow();
			        }
				}]
			})
		}],
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: true,
            useMultipleSorting: false,
            useToggleSummary: false,
            excel: {
				useExcel: true,			
				exportGroup : true
			}
        },
        border:true,
		columns:[
				 {dataIndex:'COOPTOR_ID' 		,width:150   , isLink:true},
				 {dataIndex:'UNIV_NUMB'			,width:130  },
				 {dataIndex:'COOPTOR_NAME' 		,width:80	},
				 {dataIndex:'INVEST_CNT' 		,width:100	},
				 {dataIndex:'COOPTOR_TYPE' 		,width:100	},
				 {dataIndex:'START_DATE' 		,width:80	},
				 {dataIndex:'PASSWORD' 		,width:80	    ,hidden:true},
				 {dataIndex:'BANK_CODE'		,width:110 
					 ,'editor' : Unilite.popup('BANK_G',	{			            
					 					textFieldName: 'BANK_CODE',
					 					DBtextFieldName: 'BANK_CODE',
				    					listeners: {
							                'onSelected': function(records, type  ){
							                    	var grdRecord = masterGrid.uniOpt.currentRecord;
							                    	grdRecord.set('BANK_CODE',records[0]['BANK_CODE']);
							                    	grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
							                },
							                'onClear':  function( type  ){
							                    	var grdRecord = masterGrid.uniOpt.currentRecord;
							                    	grdRecord.set('BANK_NAME','');
							                    	grdRecord.set('BANK_CODE','');
							                }
						            	} // listeners
								}) 		
					}, 
				 {dataIndex:'BANK_NAME' 			,width:110
					,'editor' : Unilite.popup('BANK_G',	{			            
										textFieldName:'BANK_NAME',
										DBtextFieldName:'BANK_NAME',
				    					listeners: {
							                'onSelected': function(records, type  ){
							                    	var grdRecord = masterGrid.uniOpt.currentRecord;
							                    	grdRecord.set('BANK_CODE',records[0]['BANK_CODE']);
							                    	grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
							                },
							                'onClear':  function( type  ){
							                    	var grdRecord = masterGrid.uniOpt.currentRecord;
							                    	grdRecord.set('BANK_NAME','');
							                    	grdRecord.set('BANK_CODE','');
							                }
						            	} // listeners
								}) 		
					}, 
				 {dataIndex:'BANKBOOK_NUM' 		,width:140	},
				 {dataIndex:'GRADUATE_YN' 		,width:80	},
				 {dataIndex:'GRADUATE_DATE' 	,width:120	},
				 {dataIndex:'REPAYMENT_YN' 		,width:80	},
				 {dataIndex:'REPAYMENT_DATE' 	,width:130	},
				 {dataIndex:'REMARK' 			,width:180	},
				 
				 {dataIndex:'COMP_CODE'			,width:50 ,hidden:true	},
				 {dataIndex:'DEPT_NAME2'		,width:0 ,hidden:true	},
				 {dataIndex:'GENDER'			,width:0 ,hidden:true	},
				 {dataIndex:'ADDRESS_TYPE'		,width:0 ,hidden:true	},
				 {dataIndex:'ZIP_CODE'			,width:0 ,hidden:true	
				 ,'editor' : Unilite.popup('ZIP_G',{listeners: {
						                'onSelected': {
						                    fn: function(records, type  ){
						                    	var me = this;
						                    	var grdRecord = Ext.getCmp('cpa100ukrvGrid').uniOpt.currentRecord;
						                    	grdRecord.set('ADDR1',records[0]['ZIP_NAME']);
						                    	grdRecord.set('ADDR2',records[0]['ADDR2']);
						                    },
						                    scope: this
						                },
						                'onClear' : function(type){
						                		var me = this;
						                    	var grdRecord = Ext.getCmp('cpa100ukrvGrid').uniOpt.currentRecord;
						                    	grdRecord.set('ADDR1','');
						                    	grdRecord.set('ADDR2','');
						                }
						            }
								})},
		
				 {dataIndex:'INVEST_AMT'		,width:100 ,hidden:true	},
				 {dataIndex:'DIVID_CNT'		,width:100 ,hidden:true	},
				 {dataIndex:'ADDR1'				,width:100 ,hidden:true	},
				 {dataIndex:'ADDR2'				,width:100 ,hidden:true	},
				 {dataIndex:'MEMBER_YN'			,width:100 ,hidden:true },
				 {dataIndex:'REPAYMENT_YN'		,width:100 ,hidden:true	},
				 {dataIndex:'REPAYMENT_DATE'	,width:100 ,hidden:true	},
				 {dataIndex:'MEMBER_LEVEL'		,width:100 ,hidden:true	},
				 {dataIndex:'PURCHASE_LEVEL'	,width:100 ,hidden:true	},
				 {dataIndex:'INVEST_POINT'		,width:100 ,hidden:true	},
				 {dataIndex:'ADD_POINT'			,width:100 ,hidden:true	},
				 {dataIndex:'USE_POINT'			,width:100 ,hidden:true	},
				 {dataIndex:'OPR_FLAG' 			,width:100	,hidden:true}
        ], 
         listeners: {
          	selectionchangerecord:function(selected)	{
          		detailForm.setActiveRecord(selected)
          	},
          	
          	onGridDblClick:function(grid, record, cellIndex, colName) {
          		if(!record.phantom) {
	      			switch(colName)	{
					case 'COOPTOR_ID' :
							masterGrid.hide();
							break;		
					default:
							break;
	      			}
	      			if(detailForm.getValue("COOPTOR_ID") != ''){
			        	UniAppManager.setToolbarButtons(['print'],true);
			        }
          		}
          	},
			hide:function()	{
				detailForm.show();
			},
			select: function(grid, record, index, eOpts ){	
	        			UniAppManager.setToolbarButtons('print',true);
	        			//UniAppManager.app.grid1Select();
		    },
			deselect:  function(grid, record, index, eOpts ){
						//UniAppManager.setToolbarButtons('print',false);
	        }, 
    		beforeedit: function( editor, e, eOpts ) {
	        	if(e.record.phantom == false) {
	        		if(UniUtils.indexOf(e.field, ['INVEST_CNT'])) {
						return false;
					}
	        	}
       		} 	
        },
          setExcelData: function(record) {
				var grdRecord =  this.getSelectedRecord();
				grdRecord.set('COOPTOR_ID' 	 			, record['COOPTOR_ID']);
				grdRecord.set('COOPTOR_NAME' 	 		, record['COOPTOR_NAME']);
				grdRecord.set('UNIV_NUMB'		    	, record['UNIV_NUMB']);
				grdRecord.set('COOPTOR_TYPE' 			, record['COOPTOR_TYPE']);
				grdRecord.set('INVEST_CNT'   			, record['INVEST_CNT']);
				grdRecord.set('INVEST_AMT'   			, record['INVEST_AMT']);
				grdRecord.set('START_DATE' 				, record['START_DATE']);
				grdRecord.set('BANK_NAME' 				, record['BANK_NAME']);
				grdRecord.set('BANK_CODE' 				, record['BANK_CODE']);
				grdRecord.set('BANKBOOK_NUM'			, record['BANKBOOK_NUM']);
          	},
          	setExcelData2: function(record) {
				var grdRecord =  this.getSelectedRecord();
				grdRecord.set('COOPTOR_ID' 	 			, record['COOPTOR_ID']);
				grdRecord.set('UNIV_NUMB'		    	, record['UNIV_NUMB']);
				grdRecord.set('GRADUATE_YN' 			, record['GRADUATE_YN']);
				grdRecord.set('GRADUATE_DATE'   		, record['GRADUATE_DATE']);
				grdRecord.set('REPAYMENT_YN'   			, record['REPAYMENT_YN']);
				grdRecord.set('REPAYMENT_DATE' 			, record['REPAYMENT_DATE']);
				grdRecord.set('MEMBER_YN' 				, record['MEMBER_YN']);
          	}
    });
    
    /**
     * 상세 조회(Detail Form Panel)
     * @type 
     */
    var detailForm = Unilite.createForm('detailForm', {
//      region:'south',
//    	weight:-100,
//    	height:400,
//    	split:true,
    	hidden: true,
    	masterGrid: masterGrid,
        autoScroll:true,
        border: false,
        padding: '0 0 0 1',       
        uniOpt:{
        	store : directMasterStore
        },
	    //for Form      
	    layout: {
	    	type: 'uniTable',
	    	columns: 3,
	    	tableAttrs:{cellpadding:5},
	    	tdAttrs: {valign:'top'}
	    },
	    defaultType: 'uniFieldset',
	    masterGrid: masterGrid,
	    defineEvent: function(){
	    	var me = this;	        
	        me.getField('COOPTOR_ID').on ('blur', function( field, blurEvent, eOpts )	{
				//var frm = Ext.getCmp('detailForm');
				/*if(me.getValue('CUSTOM_FULL_NAME') == "")	
					me.setValue('CUSTOM_FULL_NAME',this.getValue());*/
			} );
		},
	    items : [{
    		xtype: 'container',
    		colspan: 3,
    		layout: {type: 'vbox', align: 'stretch'},
    		items: [{
    			xtype: 'container',
    			layout: { type: 'uniTable', columns: 3},
    			defaultType: 'uniTextfield',
    			defaults : {enforceMaxLength: true},
    			items:[{
					fieldLabel: '조합원ID',
					name: 'COOPTOR_ID' ,
					allowBlank: false
				},{
					fieldLabel: '조합원명',
					name: 'COOPTOR_NAME',
					allowBlank: false 
				},{
					fieldLabel: '조합원구분',
					name: 'COOPTOR_TYPE' ,
					xtype: 'uniCombobox' ,
					comboType: 'AU',
					comboCode: 'YP11',
					allowBlank: false
				}]
    		}]
	    },{
	    	title: '기본정보',
        	defaultType: 'uniTextfield',
        	columns: 1,
        	height: 400,
			layout: {
	            type: 'uniTable',
	            tableAttrs: { style: { width: '100%' } }, 
	            columns: 1
			}, 
			items :[{
				fieldLabel: '학번/사번',
				name: 'UNIV_NUMB',
				allowBlank: false
			},{
				fieldLabel: '핸드폰번호', 
				name: 'CELL_PHONE'
			},{
				xtype: 'component',
				height: 15
			},{
				fieldLabel: '소속1',
				name: 'DEPT_NAME1'
			},{
				fieldLabel: '소속2',
				name: 'DEPT_NAME2'
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '성별',						            		
				name:'GENDER',
				items: [{
					boxLabel: '남자', 
					width: 70, 
					name: 'GENDER',
					inputValue: '1',
					checked: true 
				},{
					boxLabel : '여자', 
					width: 70,
					name: 'GENDER',
					inputValue: '2'
				}]
			},{
				xtype: 'component',
				height: 15
			},
				Unilite.popup('BANK',{
					fieldLabel: '은행',
					valueFieldName:'BANK_CODE',
					textFieldName:'BANK_NAME' ,
					DBvalueFieldName:'BANK_CODE',
					DBtextFieldName:'BANK_NAME',
					allowBlank: false
					//,verticalMode:true
					
			}),{
				fieldLabel: '계좌번호', 
				name: 'BANKBOOK_NUM',
				allowBlank: false 
			},{
				xtype: 'component',
				height: 15
			},{
				xtype: 'uniRadiogroup',		            		
				fieldLabel: '주소구분',
				/*comboType: 'AU',
				comboCode: 'B232',*/
				items: [{
					boxLabel : '구주소', 
					width: 70,
					name: 'ADDRESS_TYPE',
					inputValue: 'A'
				},{
					boxLabel: '신주소', 
					width: 70, 
					name: 'ADDRESS_TYPE',
					inputValue: 'B',
					checked: true 
				}]
			},
				Unilite.popup('ZIP',{
					showValue:false,
					textFieldName:'ZIP_CODE',
					DBtextFieldName:'ZIP_CODE',
					//extParam:{'ADDR_TYPE': 'B'}, 
					listeners: { 'onSelected': {
					                    fn: function(records, type  ){
					                    	var frm = Ext.getCmp('detailForm');
					                    	frm.setValue('ADDR1', records[0]['ZIP_NAME']);
					                    	frm.setValue('ADDR2', records[0]['ADDR2']);
					                    	//console.log("(records[0]['ZIP_CODE1_NAME'] : ", records[0]['ZIP_CODE1_NAME']);
					                    	//Ext.getCmp('ADDR2_F').setValue(records[0]['ADDR2']);
					                    },
					                    scope: this
					                  },
					                  'onClear' : function(type)	{
					                  		var frm = Ext.getCmp('detailForm');
					                    	frm.setValue('ADDR1', '');
					                    	frm.setValue('ADDR2', '');
					                  },
										applyextparam: function(popup){							
											var addrType = detailForm.getValue('ADDRESS_TYPE');	
											if(addrType == true){
												popup.setExtParam({'ADDR_TYPE': 'A'});
											}else{
												popup.setExtParam({'ADDR_TYPE': 'B'});
											}
										}
									}
			}),{
				fieldLabel: '기본주소',
				name: 'ADDR1' 
			},{
				fieldLabel: '상세주소',
				name: 'ADDR2'
			}]
	    },{   
	    	title: '가입정보',
        	//,collapsible: true
        	defaultType: 'uniTextfield',
        	height: 400,
			layout: {
	            type: 'uniTable',
	            tableAttrs: { style: { width: '100%' } }, 
	            columns: 1
			}, 
			 
			items :[{
				xtype: 'radiogroup',		            		
				fieldLabel: '조합원여부',						            		
				name:'MEMBER_YN',
				items: [{
					boxLabel: '예', 
					width: 70, 
					name: 'MEMBER_YN',
					inputValue: 'Y',
					checked: true 
				},{
					boxLabel : '아니오', 
					width: 70,
					name: 'MEMBER_YN',
					inputValue: 'N'
				}]
			},{
				xtype: 'component',
				height: 10
			},{
				fieldLabel: '가입일자',  
				name: 'START_DATE',
				xtype : 'uniDatefield',
				allowBlank: false
			},{
				xtype: 'component',
				height: 15
			},{
				fieldLabel: '출자구좌수',  
				name: 'INVEST_CNT',
				readOnly:true,
				xtype: 'uniNumberfield'
			},{
				xtype: 'component',
				height: 10
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '졸업여부',			
				items: [{
					boxLabel: '예', 
					width: 70, 
					name: 'GRADUATE_YN',
					inputValue: 'Y'
				},{
					boxLabel : '아니오', 
					width: 70,
					name: 'GRADUATE_YN',
					inputValue: 'N',
					checked: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							detailForm.setValue('GRADUATE_DATE', '');
						}
					}
				}]
			},{
				fieldLabel: '졸업일자',  
				name: 'GRADUATE_DATE',
				xtype : 'uniDatefield'
			},{
				xtype: 'component',
				height: 10
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '반환여부',						            		
				items: [{
					boxLabel: '예', 
					width: 70, 
					name: 'REPAYMENT_YN',
					inputValue: 'Y'
				},{
					boxLabel : '아니오', 
					width: 70,
					name: 'REPAYMENT_YN',
					inputValue: 'N',
					checked: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							detailForm.setValue('REPAYMENT_DATE', '');
						}
					}
				}]
			},{
				fieldLabel: '반환일자',  
				name: 'REPAYMENT_DATE',
				xtype : 'uniDatefield'
			},{
				xtype: 'component',
				height: 15
			},{
				fieldLabel: '출자금액',  
				name: 'INVEST_AMT',
				xtype: 'uniNumberfield'
			},{
				fieldLabel: '반환금액',  
				name: 'REPAYMENT_AMT',
				xtype: 'uniNumberfield'
			},
			{
				fieldLabel: '배당회수',  
				name: 'DIVID_CNT',
				xtype: 'uniNumberfield'
			}]
		},{  
			title: '결제정보',
			flex : 1,
			height: 400,
			defaultType: 'uniNumberfield',
			layout: {
			            type: 'uniTable',
			            tableAttrs: { style: { width: '100%' } },
			            tdAttrs:{valign:'top'},
			            columns: 1
			},
			items :[{
				fieldLabel: '총포인트',
				name: 'TOT_POINT',
				readOnly:true
			},{
				fieldLabel: '출자포인트',
				name: 'INVEST_POINT',
				readOnly:true
			},{
				fieldLabel: '누적포인트',
				name: 'ADD_POINT',
				readOnly:true
			},{
				fieldLabel: '사용포인트',
				name: 'USE_POINT',
				readOnly:true,
				rowspan:2
			},{
				xtype: 'component',
				height: 15
			},{
				fieldLabel: '회원등급',
				name: 'MEMBER_LEVEL',
				xtype : 'uniCombobox',
				comboType:'AU',
				comboCode:'YP12' 
			},{
				fieldLabel: '구매등급',
				name: 'PURCHASE_LEVEL',
				xtype : 'uniCombobox',
				comboType:'AU',
				comboCode:'YP13' 
			},{
				xtype: 'component',
				height: 15
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '현금영수증<br>자동발급 여부',						            		
				items: [{
					boxLabel: '예', 
					width: 70, 
					name: 'CASH_RECEIPT_AUTO_YN',
					inputValue: 'Y'
				},{
					boxLabel : '아니오', 
					width: 70,
					name: 'CASH_RECEIPT_AUTO_YN',
					inputValue: 'N',
					checked: true
					/*,listeners: {			/* 발급 안 할 겨우, 영수증 번호 초기화 시 사용함
						change: function(field, newValue, oldValue, eOpts) {						
							detailForm.setValue('CASH_MEMBER_NO', '');
						}
					}*/
				}]
			},{
				fieldLabel: '현금영수증<br>발행번호',
				name: 'CASH_MEMBER_NO',
				xtype: 'uniTextfield'
				
			}]
	    },{  
			title: '비고',
			flex : 1,
			colspan:3,
			height: 88, 
			weight: 700,
			defaultType: 'uniTextfield',
			layout: {
		            type: 'uniTable',
		            tableAttrs: { style: { width: '100%' } },
		            tdAttrs:{valign:'top'},
		            columns: 1
			},
			items :[{
				fieldLabel: '비고',
				name: 'REMARK',
				height: 50,
				width: 830,
				colspan:3,
				xtype : 'textareafield',
				maxLength: 300
			}]
	    }
	    		
	],
		loadForm: function(record)	{
   				// window 오픈시 form에 Data load
				this.reset();
				this.setActiveRecord(record || null);   
				this.resetDirtyStatus();				
				
				/*var win = this.up('uniDetailFormWindow');
                if(win) {       // 처음 윈도열때는 윈독 존재 하지 않음.
   				     win.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
                     win.setToolbarButtons(['prev','next'],true);
                }*/
   			},
   			listeners:{
//				beforehide: function(grid, eOpts )	{
//					if(directMasterStore.isDirty() )	{
//						var config={
//							success:function()	{
//								detailForm.hide();
//							}
//						};
//						UniAppManager.app.confirmSaveData(config);
//						return false;
//					}
//				},
				hide:function()	{
					masterGrid.show();
					if(panelSearch.getCollapsed()){		//panelSearch가 닫혀 있으면..
						panelResult.show();
					}
				},
				beforeaction:function(basicForm, action, eOpts)	{
					console.log("action : ",action);
					console.log("action.type : ",action.type);
					if(action.type =='directsubmit')	{
						var invalid = this.getForm().getFields().filterBy(function(field) {
						            return !field.validate();
						    });
				        	
			         	if(invalid.length > 0)	{
				        	r=false;
				        	var labelText = ''
				        	
				        	if(Ext.isDefined(invalid.items[0]['fieldLabel']))	{
				        		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
				        	}else if(Ext.isDefined(invalid.items[0].ownerCt))	{
				        		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
				        	}
				        	alert(labelText+Msg.sMB083);
				        	invalid.items[0].focus();
				        }																									
					}
				}

   			}
	});

    	
    Unilite.Main({
    	id  : 'cpa100ukrvApp',
		borderItems : [
			panelSearch,
			panelResult,
			{	region:'center',
				//layout : 'border',
				title:'조합원정보',
				layout : {type:'vbox', align:'stretch'},
				flex:1,
				autoScroll:true,
				tools: [
					{
						type: 'hum-grid',					            
			            handler: function () {
			            	detailForm.hide();
			                //masterGrid.show();
			            	//panelResult.show();
			            }
					},{
			
						type: 'hum-photo',					            
			            handler: function () {
			            	/*
			            	var edit = masterGrid.findPlugin('cellediting');
							if(edit && edit.editing)	{
								setTimeout("edit.completeEdit()", 1000);
							}
							*/
			                masterGrid.hide();
			                panelResult.hide();
			                //detailForm.show();
			                if(detailForm.getValue("COOPTOR_ID") != ''){
			                	UniAppManager.setToolbarButtons(['print'],true);
			                }
			                if(Ext.isEmpty(masterGrid.getSelectedRecord())){
			                	detailForm.setDisabled(true);
			                }
			               /* cpa100ukrvService.selectList(param, function(provider, response)	{
								if(!Ext.isEmpty(provider)){
									detailForm.getField("COOPTOR_ID").setReadOnly(true);
									detailForm.getField("COOPTOR_NAME").setReadOnly(true);
									detailForm.getField("COOPTOR_TYPE").setReadOnly(true);
									
								}
								if(Ext.isEmpty(provider)){
									detailForm.getField("COOPTOR_ID").setReadOnly(false);
									detailForm.getField("COOPTOR_NAME").setReadOnly(false);
									detailForm.getField("COOPTOR_TYPE").setReadOnly(false);
								}
							})*/
			            }
					}
				],
				items:[					
					masterGrid, 
					detailForm					
				]
			}
		],		
		autoButtonControl : false,
		onUpdataSetting : function(config) {
			directMasterStore.saveStore(config);	
		},
		fnInitBinding : function(params) {
			if(params && params.CUSTOM_CODE ) {
				panelSearch.setValue('CUSTOM_CODE',params.CUSTOM_CODE);
				panelSearch.setValue('COMP_CODE',params.COMP_CODE);
				masterGrid.getStore().loadStoreRecords();
			}
			UniAppManager.setToolbarButtons(['reset','newData','detail'],true);			
		}
		,onSaveAsExcelButtonDown: function() {
			var masterGrid = Ext.getCmp('cpa100ukrvGrid');
			 masterGrid.downloadExcelXml();
		},
		
		onQueryButtonDown : function()	{
			detailForm.clearForm ();
			detailForm.resetDirtyStatus();
			
			directMasterStore.loadStoreRecords();
		},
		onNewDataButtonDown : function()	{
			var graduateYn = 'N';
			var repaymentYn = 'N';
			var passWord  = '1';
			
			var r = {
				GRADUATE_YN : graduateYn,
				REPAYMENT_YN : repaymentYn,
				PASSWORD     : passWord
			}
			
			masterGrid.createRow(r);
		},
		onPrevDataButtonDown:  function()	{
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function()	{
			masterGrid.selectNextRow();
		},		
		onSaveDataButtonDown: function (config) {
			
			if(detailForm.getValue('GRADUATE_YN') == true && detailForm.getValue('GRADUATE_DATE') == null ){
				alert('졸업일자를 지정 해야 합니다.');
			}
			else if (detailForm.getValue('REPAYMENT_YN') == true && detailForm.getValue('REPAYMENT_DATE') == null ){
				alert('반환일자를 지정 해야 합니다.');
			}	
			else {
				directMasterStore.saveStore(config);
			}
		},
		onDeleteDataButtonDown : function()	{
			
			var selRow = masterGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{

				masterGrid.deleteSelectedRow();
				
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					masterGrid.deleteSelectedRow();
			}
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			masterGrid.reset();
			detailForm.hide();
			UniAppManager.setToolbarButtons(['print'], false);
			
//			UniAppManager.setToolbarButtons(['save','prev', 'next'],false);
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		onPrintButtonDown: function() {
			//var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
			var param= Ext.getCmp('detailForm').getValues();
			
			var win = Ext.create('widget.PDFPrintWindow', {
				url: CPATH+'/cpa/cpa100rkrPrint.do',
				prgID: 'cpa100rkr',
					extParam: {
						COOPTOR_ID : param.COOPTOR_ID
					
					}
				});
				win.center();
				win.show();
   				
		},
		rejectSave: function()	{
			directMasterStore.rejectChanges();
			UniAppManager.setToolbarButtons('save',false);
		} 	
		, confirmSaveData: function()	{
            	if(directMasterStore.isDirty())	{
					if(confirm(Msg.sMB061))	{
						this.onSaveDataButtonDown();
					} else {
						this.rejectSave();
					}
				}
            }
	});	// Main
	
	Unilite.createValidator('formValidator', {
		store : directMasterStore,
		grid: masterGrid,
		forms: {'formA:':detailForm},		
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
//			if(newValue == oldValue){
//				return false;
//			}
			var rv = true;
			
			switch(fieldName) {	
				case "COOPTOR_ID" :	 //미반환으로 변경시 반환일자 삭제
					if(newValue){
						record.set('UNIV_NUMB',newValue);
						break;
					}
				break;
				
				
				case "REPAYMENT_YN" :	 //미반환으로 변경시 반환일자 삭제
					if(newValue == 'N'){
						record.set('REPAYMENT_DATE','');
						break;
					}
				break;
				
				case "GRADUATE_YN" :	 //재학으로 변경시 졸업일자 삭제
					if(newValue == 'N'){
						record.set('GRADUATE_DATE','');
						break;
					}
				break;
				
				case "REPAYMENT_DATE" :	 //재학일자가 있을경우 졸업, 없을 경우 재학
					if(newValue){
						record.set('REPAYMENT_YN','Y');
						break;
					}else if(newValue == null){
						record.set('REPAYMENT_YN','N');
						break;
					}
				break;
				
				case "GRADUATE_DATE" :	//반환일자가 있을경우 반환, 없을 경우 미반환
					if(newValue){
						record.set('GRADUATE_YN','Y');
						break;
					}else if(newValue == null){
						record.set('GRADUATE_YN','N');
						break;
					}
				break;
				
			}
			return rv;
		}
	});
}; // Validator

</script>
