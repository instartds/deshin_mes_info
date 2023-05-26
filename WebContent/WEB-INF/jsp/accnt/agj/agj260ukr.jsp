<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agj260ukr"  >
	<t:ExtComboStore comboType="BOR120" /><!-- 사업장    -->
	<t:ExtComboStore comboType="A" comboCode="A011" />   
	<t:ExtComboStore items="${comboInputPath}" storeId="comboInputPath" />
	<t:ExtComboStore comboType="AU" comboCode="A005" />        
	<t:ExtComboStore comboType="AU" comboCode="A022" /><!-- 매입증빙유형-->
	<t:ExtComboStore comboType="AU" comboCode="B004" />     
	<t:ExtComboStore comboType="AU" comboCode="A003" />  
	<t:ExtComboStore comboType="AU" comboCode="A022" />  
	<t:ExtComboStore comboType="AU" comboCode="A014" /><!--승인상태-->   
	<t:ExtComboStore comboType="AU" comboCode="B013" />
	<t:ExtComboStore comboType="AU" comboCode="A058" />
	<t:ExtComboStore comboType="AU" comboCode="A149" />
	<t:ExtComboStore comboType="AU" comboCode="A016" />
	<t:ExtComboStore comboType="AU" comboCode="A012" /> 
	<t:ExtComboStore comboType="AU" comboCode="A070" />
</t:appConfig>
<script type="text/javascript" >
var detailWin;
var csINPUT_DIVI	 = "1";		// 1:결의전표/2:결의전표(전표번호별)
var csSLIP_TYPE      = "2";		// 1:회계전표/2:결의전표
var csSLIP_TYPE_NAME = "결의전표";
var csINPUT_PATH	 = 'Z1';
var gsInputPath, gsInputDivi, gsDraftYN	;
var postitWindow;				// 각주팝업
var creditNoWin;				// 신용카드번호 & 현금영수증 팝업
var comCodeWin ;				// A070 증빙유형팝업
var creditWIn;					// 신용카드팝업
var printWin;					//전표출력팝업
var foreignWindow;				//외화금액입력
var gsBankBookNum ,gsBankName ;
var tab;

function appMain() {
	
	var gsSlipNum 		=""; // 링크로 넘어오는 Slip_NUM
	var gsProcessPgmId	=""; // Store 에서 링크로 넘어온 Data 값 체크 하기 위해 전역변수 사용
	
	var baseInfo = {
		gsLocalMoney    : '${gsLocalMoney}',
		gsBillDivCode   : '${gsBillDivCode}',
		gsPendYn        : '${gsPendYn}',
		gsChargePNumb	: '${gsChargePNumb}',
		gsChargePName	: '${gsChargePName}',
		gbAutoMappingA6  : '${gbAutoMappingA6}',	// '결의전표 관리항목 사번에 로그인정보 자동매핑함
		gsDivChangeYN    : '${gsDivChangeYN}',		// '귀속부서 입력시 사업장 자동 변경 사용여부
		gsRemarkCopy     : '${gsRemarkCopy}',		// '전표_적요 copy방식_적요 빈 값 상태에서
													// Enter칠 때 copy
		gsAmtEnter       : '${gsAmtEnter}',			// '전표_금액이 0이면 마지막 행에서
													// Enter안넘어감(부가세 제외)
		gsAmtPoint		 : ${gsAmtPoint}			// 외화금액 format
	}

	
	/**
	 * 일반전표 Store 정의(Service 정의)
	 * 
	 * @type
	 */
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		  read : 'agj260ukrService.selectList'
		 ,update : 'agj260ukrService.update'
		 ,syncAll:'agj260ukrService.saveAll'
		}
	});
	<%@include file="./accntGridConfig_agj260ukr.jsp" %> 
	var directMasterStore1 = Unilite.createStore('agj260ukrMasterStore1',getStoreConfig());
	
	/**
	 * 검색조건 (Search Panel)
	 * 
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
					xtype: 'uniDateRangefield',
		            startFieldName: 'AC_DATE_FR',
		            endFieldName: 'AC_DATE_TO',
		            startDate:UniDate.get('today'),// '20130801', //
		            endDate: UniDate.get('today'),// '20130808', //
				 	allowBlank:false,                	
	                onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelSearch) {
		            		panelSearch.setValue('AC_DATE_TO', newValue);
		            	}
	                	if(panelResult) {
							panelResult.setValue('AC_DATE_FR', newValue);
							panelResult.setValue('AC_DATE_TO', newValue);
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelSearch && Ext.isDate(newValue))	{
					    	if(UniDate.extFormatMonth(panelSearch.getValue('AC_DATE_FR')) != UniDate.extFormatMonth(newValue))	{
					    		alert('동일한 월만 조회가 가능합니다.');
					    		field.setValue(oldValue)
					    		return ;
					    	}
				    	}
				    	if(panelResult) {
				    		panelResult.setValue('AC_DATE_TO', newValue);				    		
				    	}
				    }
				},{
				    fieldLabel: '입력경로',
					name: 'INPUT_PATH',          
					xtype: 'uniCombobox' ,
					allowBlank: false,
					store: Ext.data.StoreManager.lookup('comboInputPath'),
					value:'Z1',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('INPUT_PATH', newValue);
							if(newValue != csINPUT_PATH)	{
								UniAppManager.setToolbarButtons('newData',false);
							}else {
								UniAppManager.setToolbarButtons('newData',true);
							}
						}
					}
				},Unilite.popup('ACCNT_PRSN', {
	    	  	 	fieldLabel: '입력자ID',
	    	  	 	valueFieldName:'CHARGE_CODE',
	    	  	 	textFieldName:'CHARGE_NAME',
	    	  	 	textFieldWidth:150,
				 	readOnly: true,
				 	showValue:false
				}),{
					fieldLabel: 'KEY_VALUE',
					name: 'KEY_VALUE',
					hidden:true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('KEY_VALUE', newValue);
						}
					}
			    },{
					fieldLabel: 'SAVE_YN',
					name: 'SAVE_YN',
					hidden:true,
					value:'N',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('SAVE_YN', newValue);
						}
					}
			    }]
		}]
	});	// end panelSearch
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
    	items: [{	    
			fieldLabel: '전표일',
			xtype: 'uniDateRangefield',
            startFieldName: 'AC_DATE_FR',
            endFieldName: 'AC_DATE_TO',
            startDate:  UniDate.get('today'),//'20130801', //
            endDate:  UniDate.get('today'),//'20130831', //
            width: 350,
		 	allowBlank:false,                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {            	
            	if(panelSearch) {
            		panelSearch.setValue('AC_DATE_FR', newValue);	
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelResult && Ext.isDate(newValue))	{
			    	if(UniDate.extFormatMonth(panelResult.getValue('AC_DATE_FR')) != UniDate.extFormatMonth(newValue))	{
			    		alert(Msg.sMA0131);
			    		field.setValue(oldValue)
			    		return ;
			    	}
		    	}
		    	if(panelSearch) {
		    		panelSearch.setValue('AC_DATE_TO', newValue);				    		
		    	}
		    	
		    }
		},{
		    fieldLabel: '입력경로',
			name: 'INPUT_PATH',          
			xtype: 'uniCombobox' ,
			allowBlank: false,
			store: Ext.data.StoreManager.lookup('comboInputPath'),
			value:'Z1',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('INPUT_PATH', newValue);
					if(newValue != csINPUT_PATH)	{
						UniAppManager.setToolbarButtons('newData',false);
					}else {
						UniAppManager.setToolbarButtons('newData',false);
					}
				}
			}
		},Unilite.popup('ACCNT_PRSN', {
	    	  	 	fieldLabel: '입력자',
	    	  	 	valueFieldName:'CHARGE_CODE',
	    	  	 	textFieldName:'CHARGE_NAME',
	    	  	 	textFieldWidth:150,
				 	readOnly: true,
				 	showValue:false
		}),{
			fieldLabel: 'KEY_VALUE',
			name: 'KEY_VALUE',
			hidden:true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('KEY_VALUE', newValue);
				}
			}
	    },{
					fieldLabel: 'SAVE_YN',
					name: 'SAVE_YN',
					hidden:true,
					value:'N',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('SAVE_YN', newValue);
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
						grid.editingPlugin.startEdit(record,grid.getColumn('AC_DAY'))
					}else {
						UniAppManager.app.onNewDataButtonDown();
					}
				}
			}
		
	}
    /**
	 * 일발전표 Master Grid 정의(Grid Panel)
	 * 
	 * @type
	 */

    var masterGrid1 = Unilite.createGrid('agj260ukrGrid1', getGridConfig(directMasterStore1,'agj260ukrGrid1','agj260ukrDetailForm1', 0.65, true,'1'));
    
    var detailForm1 = Unilite.createForm('agj260ukrDetailForm1',  getAcFormConfig('agj260ukrDetailForm1',masterGrid1 ));
	
	// 차대변 구분 전표
	<%@include file="./agjSlip_agj260ukr.jsp" %> 
	

    tab = Unilite.createTabPanel('agj260ukrvTab',{    	
		region:'center',
    	activeTab: 0,
    	border: false,
    	items:[
    		{
    			title: '일반전표',
				xtype: 'panel',
				itemId: 'agjTab1',
				layout:{type:'vbox', align:'stretch'},
				
				items:[
					masterGrid1,
		  			detailForm1,
		  			slipContainer
				]
			}
    	]
    })

    Unilite.Main({
		borderItems: [{
         	region:'center',
         	layout: 'border',
         	border: false,
         	items:[
           		tab, panelResult
         	]	
      	},
      	panelSearch     
      	],
      	panelSearch : panelSearch,
      	panelResult : panelResult,
		id  : 'agj260ukrApp',
		autoButtonControl : false,
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons([ 'query','newData','reset','delete','deleteAll'],false);
			UniAppManager.setToolbarButtons([ 'save'],true);
			panelSearch.setValue('CHARGE_CODE','${chargeCode}');
			panelSearch.setValue('CHARGE_NAME','${chargeName}');	
			panelResult.setValue('CHARGE_CODE','${chargeCode}');
			panelResult.setValue('CHARGE_NAME','${chargeName}');
			this.processParams(params);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('AC_DATE_FR');
		},
		onQueryButtonDown : function()	{},
		onSaveDataButtonDown: function (config) {
			var activeTab = tab.getActiveTab();
			var activeTabId = activeTab.getItemId();
			if(activeTabId == 'agjTab1' )	{
				directMasterStore1.saveStore(config);
			}
		},
		onResetButtonDown:function() {
			gsSlipNum = "";
			gsProcessPgmId ="";
			
			var masterGrid1 = Ext.getCmp('agj260ukrGrid1');
			// panelSearch.reset();
			masterGrid1.getStore().uniOpt.isMaster=true;
			masterGrid1.getStore().uniOpt.editable=true;
			masterGrid1.reset();
			masterGrid1.getStore().commitChanges();
			detailForm1.clearForm();
			detailForm1.down('#formFieldArea1').removeAll();
			

			slipGrid1.reset();
			slipGrid2.reset();
			this.setSearchReadOnly(false);
			
			panelSearch.getField('INPUT_PATH').setValue('Z1');
			panelResult.getField('INPUT_PATH').setValue('Z1');
			
			panelSearch.setValue('CHARGE_CODE','${chargeCode}');
			panelSearch.setValue('CHARGE_NAME','${chargeName}');	
			panelResult.setValue('CHARGE_CODE','${chargeCode}');
			panelResult.setValue('CHARGE_NAME','${chargeName}');
			UniAppManager.setToolbarButtons(['newData','reset','deleteAll'],true);
			UniAppManager.setToolbarButtons(['save','prev', 'next'],false);
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		rejectSave: function()	{
			directMasterStore1.rejectChanges();
//			directMasterStore2.rejectChanges();
//			salesStore.rejectChanges();
			UniAppManager.setToolbarButtons('save',false);
		}, 
		confirmSaveData: function()	{
			var activeTab = tab.getActiveTab();
			var activeTabId = activeTab.getItemId();
			if(activeTabId == 'agjTab1' )	{
				if(directMasterStore1.isDirty())	{
					if(confirm(Msg.sMB061))	{
						this.onSaveDataButtonDown();
					} else {
						this.rejectSave();
					}
				}
			}
			
        },
        setSearchReadOnly:function(b)	{
        	panelSearch.getField('AC_DATE_FR').setReadOnly(b);
			panelSearch.getField('AC_DATE_TO').setReadOnly(b);
			panelSearch.getField('INPUT_PATH').setReadOnly(b);
			
			panelResult.getField('AC_DATE_FR').setReadOnly(b);
			panelResult.getField('AC_DATE_TO').setReadOnly(b);
			panelResult.getField('INPUT_PATH').setReadOnly(b);
        },
        // 링크로 넘어오는 params 받는 부분 (Agj240skr)
        processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 'map100ukrv') {
				var sGubun       = params.sGubun;
				UniAppManager.app.fnGetAutoSlip(sGubun, params);
			}else if(params.PGM_ID == 'ssa100ukrv') {
				var sGubun       = params.sGubun;
				UniAppManager.app.fnGetAutoSlip(sGubun, params);
			}else if(params.PGM_ID == 'sco110ukrv') {
				var sGubun       = params.sGubun;
				UniAppManager.app.fnGetAutoSlip(sGubun, params);
			}else if(params.PGM_ID == 'ssa560ukrv') {
				var sGubun       = params.sGubun;
				UniAppManager.app.fnGetAutoSlip(sGubun, params);
			}else if(params.PGM_ID == 'agc310ukr') {
				var sGubun       = params.sGubun;
				UniAppManager.app.fnGetAutoSlip(sGubun, params);
			}else if(params.PGM_ID == 'tes100ukrv') {
				var sGubun       = params.sGubun;
				UniAppManager.app.fnGetAutoSlip(sGubun, params);
			}else if(params.PGM_ID == 'tis100ukrv') {
				var sGubun       = params.sGubun;
				UniAppManager.app.fnGetAutoSlip(sGubun, params);
			}else if(params.PGM_ID == 'tix100ukrv' || params.PGM_ID == 'tix101ukrv') {
				var sGubun       = params.sGubun;
				UniAppManager.app.fnGetAutoSlip(sGubun, params);
			}else if(params.PGM_ID == 'tex200ukrv' || params.PGM_ID == 'tex201ukrv') {
				var sGubun       = params.sGubun;
				UniAppManager.app.fnGetAutoSlip(sGubun, params);
			}else if(params.PGM_ID == 'atx110ukr') {
				var sGubun       = params.sGubun;
				UniAppManager.app.fnGetAutoSlip(sGubun, params);
			}else if(params.PGM_ID == 'agd151ukr') {
				var sGubun       = params.sGubun;
				UniAppManager.app.fnGetAutoSlip(sGubun, params);
			}else if(params.PGM_ID == 'agd500ukr') {
				var sGubun       = params.sGubun;
				UniAppManager.app.fnGetAutoSlip(sGubun, params);
			}else if(params.PGM_ID == 'agd250ukr') {
				var sGubun       = params.sGubun;
				UniAppManager.app.fnGetAutoSlip(sGubun, params);
			}else if(params.PGM_ID == 'agc360ukr') {
				var sGubun       = params.sGubun;
				UniAppManager.app.fnGetAutoSlip(sGubun, params);
			}else if(params.PGM_ID == 'agd250ukr') {
				var sGubun       = params.sGubun;
				UniAppManager.app.fnGetAutoSlip(sGubun, params);
			}else if(params.PGM_ID == 'agc360ukr') {
				var sGubun       = params.sGubun;
				UniAppManager.app.fnGetAutoSlip(sGubun, params);
			}else if(params.PGM_ID == 'agc400ukr') {
				var sGubun       = params.sGubun;
				UniAppManager.app.fnGetAutoSlip(sGubun, params);
			}
		},
		fnGetAutoSlip : function(sGubun, params) {
			if(sGubun == "30"){
				Ext.getBody().mask('Loading..');
				gsInputPath	 = sGubun;	
				gsDivCode    = params.DIV_CODE;
				gsFrAcDate   = params.BILL_DATE;
				gsToAcDate   = params.BILL_DATE;
				gsBillNum    = '';
				gsCustomCode = params.CUSTOM_CODE;
					
				agj260ukrService.savedTempAutoSlip30(params, function(responseText, response){
					Ext.getBody().unmask();
					
					panelSearch.setValue('AC_DATE_FR',params.BILL_DATE);
					panelSearch.setValue('AC_DATE_TO',params.BILL_DATE);
					panelResult.setValue('AC_DATE_FR',params.BILL_DATE);
					panelResult.setValue('AC_DATE_TO',params.BILL_DATE);
					
					panelResult.setValue('INPUT_PATH',params.sGubun);
					panelResult.setValue('INPUT_PATH',params.sGubun);
					
					panelSearch.setValue('INPUT_PATH', sGubun);
					panelResult.setValue('INPUT_PATH', sGubun);
						
					if(responseText && responseText.SLIP_KEY_VALUE)	{
						panelSearch.setValue('KEY_VALUE',responseText.SLIP_KEY_VALUE);
						panelResult.setValue('KEY_VALUE',responseText.SLIP_KEY_VALUE);
						console.log("responseText",responseText);
						console.log("SLIP_KEY_VALUE",responseText.SLIP_KEY_VALUE);
						directMasterStore1.loadStoreRecords();
					}
					
				})
			}else if(sGubun == "31"){
				// 계산서별 수금등록
				Ext.getBody().mask('Loading..');
				gsInputPath	 = sGubun;	
				gsDivCode    = params.DIV_CODE;
				gsFrAcDate   = params.COLL_DATE;
				gsToAcDate   = params.COLL_DATE;
				gsBillNum    = '';
				gsCustomCode = params.CUSTOM_CODE;
				
					
				agj260ukrService.savedTempAutoSlip31(params, function(responseText, response){
					Ext.getBody().unmask();
					
					panelSearch.setValue('AC_DATE_FR',params.COLL_DATE);
					panelSearch.setValue('AC_DATE_TO',params.COLL_DATE);
					panelResult.setValue('AC_DATE_FR',params.COLL_DATE);
					panelResult.setValue('AC_DATE_TO',params.COLL_DATE);
					
					panelResult.setValue('INPUT_PATH',params.sGubun);
					panelResult.setValue('INPUT_PATH',params.sGubun);
					
					panelSearch.setValue('INPUT_PATH', sGubun);
					panelResult.setValue('INPUT_PATH', sGubun);
					
					if(responseText && responseText.SLIP_KEY_VALUE)	{
						panelSearch.setValue('KEY_VALUE',responseText.SLIP_KEY_VALUE);
						panelResult.setValue('KEY_VALUE',responseText.SLIP_KEY_VALUE);
						console.log("responseText",responseText);
						console.log("SLIP_KEY_VALUE",responseText.SLIP_KEY_VALUE);
						
						directMasterStore1.loadStoreRecords();
					}
				})
			}else if(sGubun == "32"){
				// 수금등록
			}else if(sGubun == "33"){
				// 개별/일괄세금계산서등록
			}else if(sGubun == "34"){
				// 회계매출자동기표
				Ext.getBody().mask('Loading..');
				gsInputPath	 = sGubun;	
				gsDivCode    = params.DIV_CODE;
				gsFrAcDate   = params.PUB_DATE;
				gsToAcDate   = params.PUB_DATE;
				gsBillNum    = params.BILL_PUB_NUM;
					
				agj260ukrService.autoSlip34(params, function(responseText, response){
					Ext.getBody().unmask();
					
					panelSearch.setValue('AC_DATE_FR',params.PUB_DATE);
					panelSearch.setValue('AC_DATE_TO',params.PUB_DATE);
					panelResult.setValue('AC_DATE_FR',params.PUB_DATE);
					panelResult.setValue('AC_DATE_TO',params.PUB_DATE);
					
					panelResult.setValue('INPUT_PATH',params.sGubun);
					panelResult.setValue('INPUT_PATH',params.sGubun);
					
					panelSearch.setValue('INPUT_PATH', sGubun);
					panelResult.setValue('INPUT_PATH', sGubun);
						
					if(responseText && responseText.SLIP_KEY_VALUE)	{
						panelSearch.setValue('KEY_VALUE',responseText.SLIP_KEY_VALUE);
						panelResult.setValue('KEY_VALUE',responseText.SLIP_KEY_VALUE);
						console.log("responseText",responseText);
						console.log("SLIP_KEY_VALUE",responseText.SLIP_KEY_VALUE);
						directMasterStore1.loadStoreRecords();
					}
					
				})
			}else if(sGubun == "40"){ // 매입기표
				console.log("매입기표 param : ", param);
				Ext.getBody().mask('Loading..');
				gsInputPath	 = sGubun;	
				gsDivCode    = params.DIV_CODE;
				gsFrAcDate   = params.BILL_DATE;
				gsToAcDate   = params.BILL_DATE;
				gsBillNum    = '';
				gsCustomCode = params.CUSTOM_CODE;
				panelSearch.setValue('AC_DATE_FR',params.PROC_DATE);
				panelSearch.setValue('AC_DATE_TO',params.PROC_DATE);
				panelResult.setValue('AC_DATE_FR',params.PROC_DATE);
				panelResult.setValue('AC_DATE_TO',params.PROC_DATE);
					
				agj260ukrService.savedTempDataList(params, function(responseText, response){
					Ext.getBody().unmask();
					
					panelSearch.setValue('AC_DATE_FR',params.PROC_DATE);
					panelSearch.setValue('AC_DATE_TO',params.PROC_DATE);
					panelResult.setValue('AC_DATE_FR',params.PROC_DATE);
					panelResult.setValue('AC_DATE_TO',params.PROC_DATE);
					
					panelResult.setValue('INPUT_PATH',params.sGubun);
					panelResult.setValue('INPUT_PATH',params.sGubun);
					panelSearch.setValue('INPUT_PATH', sGubun);
					panelResult.setValue('INPUT_PATH', sGubun);
					
					if(responseText && responseText.SLIP_KEY_VALUE)	{
						panelSearch.setValue('KEY_VALUE',responseText.SLIP_KEY_VALUE);
						panelResult.setValue('KEY_VALUE',responseText.SLIP_KEY_VALUE);
						console.log("responseText",responseText);
						console.log("SLIP_KEY_VALUE",responseText.SLIP_KEY_VALUE);
						directMasterStore1.loadStoreRecords();
					}
					
					
				})
					
			}else if(sGubun == "55"){
				// 감가상각
			}else if(sGubun == "50"){
				// 용역원가대체입력2
			}else if(sGubun == "52"){
				// 원가대체입력
				Ext.getBody().mask('Loading..');
				gsInputPath	 = sGubun;	
				gsDivCode    = params.DIV_CODE;
				gsFrAcDate   = params.COST_DATE;
				gsToAcDate   = params.COST_DATE;
				
				agj260ukrService.spAutoSlip52(params, function(responseText, response){
					Ext.getBody().unmask();
					
									
					panelSearch.setValue('AC_DATE_FR',params.COST_DATE);
					panelSearch.setValue('AC_DATE_TO',params.COST_DATE);
					panelResult.setValue('AC_DATE_FR',params.COST_DATE);
					panelResult.setValue('AC_DATE_TO',params.COST_DATE);
					
					panelSearch.setValue('INPUT_PATH', sGubun);
					panelResult.setValue('INPUT_PATH', sGubun);
						
					if(responseText && responseText.SLIP_KEY_VALUE)	{
						panelSearch.setValue('KEY_VALUE',responseText.SLIP_KEY_VALUE);
						panelResult.setValue('KEY_VALUE',responseText.SLIP_KEY_VALUE);
						console.log("responseText",responseText);
						console.log("SLIP_KEY_VALUE",responseText.SLIP_KEY_VALUE);
						directMasterStore1.loadStoreRecords();
					}
					
				})
			}else if(sGubun == "54"){
				// 원가대체입력
				Ext.getBody().mask('Loading..');
				gsInputPath	 = sGubun;	
				gsDivCode    = params.DIV_CODE;
				gsFrAcDate   = params.PROC_DATE;
				gsToAcDate   = params.PROC_DATE;
				
				agj260ukrService.spAutoSlip54(params, function(responseText, response){
					Ext.getBody().unmask();
					
					panelSearch.setValue('AC_DATE_FR',params.PROC_DATE);
					panelSearch.setValue('AC_DATE_TO',params.PROC_DATE);
					panelResult.setValue('AC_DATE_FR',params.PROC_DATE);
					panelResult.setValue('AC_DATE_TO',params.PROC_DATE);
					
					panelSearch.setValue('INPUT_PATH', sGubun);
					panelResult.setValue('INPUT_PATH', sGubun);
						
					if(responseText && responseText.SLIP_KEY_VALUE)	{
						panelSearch.setValue('KEY_VALUE',responseText.SLIP_KEY_VALUE);
						panelResult.setValue('KEY_VALUE',responseText.SLIP_KEY_VALUE);
						console.log("responseText",responseText);
						console.log("SLIP_KEY_VALUE",responseText.SLIP_KEY_VALUE);
						directMasterStore1.loadStoreRecords();
					}
					
				})
			}else if(sGubun == "58"){
				// 용역원가대체입력
				var param =  {"aParam0": "REF_CODE1",
							  "aParam1": "A165",
							  "aParam2": "20",
							  "aParam3": "",
							  "aParam4": UserInfo.compCode
				};
				/*agj260ukrService.fnGetCommon(param, function(provider, response){
					if(provider){
						if(provider.EXCEPTION_JUMP == 'Y'){
							agj260ukrService.SetAgd316(param2, function(provider, response)	{							
								if(provider){	
									
								}
							});		
						}else{
							agj260ukrService.Setagd058(param1, function(provider, response)	{							
								if(provider){	
									
								}
							});
						}
					}
				});*/
				
			}else if(sGubun == "60"){
				// (수출) 선적등록
				Ext.getBody().mask('Loading..');
				gsInputPath	 = sGubun;	
				gsDivCode    = params.DIV_CODE;
				gsFrAcDate   = params.DATE_SHIPPING;
				gsToAcDate   = params.DATE_SHIPPING;
				
				agj260ukrService.spAutoSlip60(params, function(responseText, response){
					Ext.getBody().unmask();
					
					panelSearch.setValue('AC_DATE_FR',params.DATE_SHIPPING);
					panelSearch.setValue('AC_DATE_TO',params.DATE_SHIPPING);
					panelResult.setValue('AC_DATE_FR',params.DATE_SHIPPING);
					panelResult.setValue('AC_DATE_TO',params.DATE_SHIPPING);
					
					panelSearch.setValue('INPUT_PATH', sGubun);
					panelResult.setValue('INPUT_PATH', sGubun);
						
					if(responseText && responseText.SLIP_KEY_VALUE)	{
						panelSearch.setValue('KEY_VALUE',responseText.SLIP_KEY_VALUE);
						panelResult.setValue('KEY_VALUE',responseText.SLIP_KEY_VALUE);
						console.log("responseText",responseText);
						console.log("SLIP_KEY_VALUE",responseText.SLIP_KEY_VALUE);
						directMasterStore1.loadStoreRecords();
					}
					
				})
				
			}else if(sGubun == "61"){
				// (수출) Local 매출등록
			}else if(sGubun == "62"){
				// (수출) 수금등록
			}else if(sGubun == "63"){
				// (무역,수입) 경비등록
				// (수출) 선적등록
				Ext.getBody().mask('Loading..');
				gsInputPath	 = sGubun;	
				gsDivCode    = params.DIV_CODE;
				gsFrAcDate   = params.FR_ORDER_DATE;
				gsToAcDate   = params.TO_ORDER_DATE;
				
				agj260ukrService.spAutoSlip63(params, function(responseText, response){
					Ext.getBody().unmask();
					
					panelSearch.setValue('AC_DATE_FR',params.OCCURDATE);
					panelSearch.setValue('AC_DATE_TO',params.OCCURDATE);
					panelResult.setValue('AC_DATE_FR',params.OCCURDATE);
					panelResult.setValue('AC_DATE_TO',params.OCCURDATE);
					
					panelSearch.setValue('INPUT_PATH', sGubun);
					panelResult.setValue('INPUT_PATH', sGubun);
						
					if(responseText && responseText.SLIP_KEY_VALUE)	{
						panelSearch.setValue('KEY_VALUE',responseText.SLIP_KEY_VALUE);
						panelResult.setValue('KEY_VALUE',responseText.SLIP_KEY_VALUE);
						console.log("responseText",responseText);
						console.log("SLIP_KEY_VALUE",responseText.SLIP_KEY_VALUE);
						directMasterStore1.loadStoreRecords();
					}
					
				})
			}else if(sGubun == "64"){
				// 미착자동기표
				Ext.getBody().mask('Loading..');
				gsInputPath	 = sGubun;	
				gsDivCode    = params.DIV_CODE;
				gsFrAcDate   = params.DATE_SHIPPING;
				gsToAcDate   = params.DATE_SHIPPING;
				
				agj260ukrService.spAutoSlip64(params, function(responseText, response){
					Ext.getBody().unmask();
					
					panelSearch.setValue('AC_DATE_FR',params.DATE_SHIPPING);
					panelSearch.setValue('AC_DATE_TO',params.DATE_SHIPPING);
					panelResult.setValue('AC_DATE_FR',params.DATE_SHIPPING);
					panelResult.setValue('AC_DATE_TO',params.DATE_SHIPPING);
					
					panelSearch.setValue('INPUT_PATH', sGubun);
					panelResult.setValue('INPUT_PATH', sGubun);
						
					if(responseText && responseText.SLIP_KEY_VALUE)	{
						panelSearch.setValue('KEY_VALUE',responseText.SLIP_KEY_VALUE);
						panelResult.setValue('KEY_VALUE',responseText.SLIP_KEY_VALUE);
						console.log("responseText",responseText);
						console.log("SLIP_KEY_VALUE",responseText.SLIP_KEY_VALUE);
						directMasterStore1.loadStoreRecords();
					}
					
				})
			}else if(sGubun == "66"){
				// 미착대체자동기표
				Ext.getBody().mask('Loading..');
				gsInputPath	 = sGubun;	
				gsFrAcDate   = params.SLIP_DATE;
				gsToAcDate   = params.SLIP_DATE;
				
				agj260ukrService.spAutoSlip66(params, function(responseText, response){
					Ext.getBody().unmask();
					
					panelSearch.setValue('AC_DATE_FR',params.SLIP_DATE);
					panelSearch.setValue('AC_DATE_TO',params.SLIP_DATE);
					panelResult.setValue('AC_DATE_FR',params.SLIP_DATE);
					panelResult.setValue('AC_DATE_TO',params.SLIP_DATE);
					
					panelSearch.setValue('INPUT_PATH', sGubun);
					panelResult.setValue('INPUT_PATH', sGubun);
						
					if(responseText && responseText.SLIP_KEY_VALUE)	{
						panelSearch.setValue('KEY_VALUE',responseText.SLIP_KEY_VALUE);
						panelResult.setValue('KEY_VALUE',responseText.SLIP_KEY_VALUE);
						console.log("responseText",responseText);
						console.log("SLIP_KEY_VALUE",responseText.SLIP_KEY_VALUE);
						directMasterStore1.loadStoreRecords();
					}
					
				});
			}else if(sGubun == "67"){
				// 원가차감자동기표
				Ext.getBody().mask('Loading..');
				gsInputPath	 = sGubun;	
				gsDivCode    = params.DIV_CODE;
				gsFrAcDate   = params.EX_DATE;
				gsToAcDate   = params.EX_DATE;
				
				agj260ukrService.spdAutoSlip67(params, function(responseText, response){
					Ext.getBody().unmask();
					
									
					panelSearch.setValue('AC_DATE_FR',params.FR_AC_DATE);
					panelSearch.setValue('AC_DATE_TO',params.TO_AC_DATE);
					panelResult.setValue('AC_DATE_FR',params.FR_AC_DATE);
					panelResult.setValue('AC_DATE_TO',params.TO_AC_DATE);
					
					panelSearch.setValue('INPUT_PATH', sGubun);
					panelResult.setValue('INPUT_PATH', sGubun);
						
					if(responseText && responseText.SLIP_KEY_VALUE)	{
						panelSearch.setValue('KEY_VALUE',responseText.SLIP_KEY_VALUE);
						panelResult.setValue('KEY_VALUE',responseText.SLIP_KEY_VALUE);
						console.log("responseText",responseText);
						console.log("SLIP_KEY_VALUE",responseText.SLIP_KEY_VALUE);
						directMasterStore1.loadStoreRecords();
					}
					
				})
			}else if(sGubun == "68"){
				// 법인카드사용내역
				Ext.getBody().mask('Loading..');
				gsInputPath	 = sGubun;	
				gsDivCode    = params.DIV_CODE;
				gsFrAcDate   = params.PROC_DATE;
				gsToAcDate   = params.PROC_DATE;
				
				agj260ukrService.spAutoSlip68(params, function(responseText, response){
					Ext.getBody().unmask();
					
									
					panelSearch.setValue('AC_DATE_FR',params.PROC_DATE);
					panelSearch.setValue('AC_DATE_TO',params.PROC_DATE);
					panelResult.setValue('AC_DATE_FR',params.PROC_DATE);
					panelResult.setValue('AC_DATE_TO',params.PROC_DATE);
					
					panelSearch.setValue('INPUT_PATH', sGubun);
					panelResult.setValue('INPUT_PATH', sGubun);
						
					if(responseText && responseText.SLIP_KEY_VALUE)	{
						panelSearch.setValue('KEY_VALUE',responseText.SLIP_KEY_VALUE);
						panelResult.setValue('KEY_VALUE',responseText.SLIP_KEY_VALUE);
						console.log("responseText",responseText);
						console.log("SLIP_KEY_VALUE",responseText.SLIP_KEY_VALUE);
						directMasterStore1.loadStoreRecords();
					}
					
				})
			} else if(sGubun == "76"){
				//도급원가대체
				Ext.getBody().mask('Loading..');
				gsInputPath	 = sGubun;	
				gsDivCode    = params.DIV_CODE;
				gsFrAcDate   = params.COST_DATE;
				gsToAcDate   = params.COST_DATE;
				
				agj260ukrService.spAutoSlip76(params, function(responseText, response){
					Ext.getBody().unmask();
					
									
					panelSearch.setValue('AC_DATE_FR',params.COST_DATE);
					panelSearch.setValue('AC_DATE_TO',params.COST_DATE);
					panelResult.setValue('AC_DATE_FR',params.COST_DATE);
					panelResult.setValue('AC_DATE_TO',params.COST_DATE);
					
					panelSearch.setValue('INPUT_PATH', sGubun);
					panelResult.setValue('INPUT_PATH', sGubun);
						
					if(responseText && responseText.SLIP_KEY_VALUE)	{
						panelSearch.setValue('KEY_VALUE',responseText.SLIP_KEY_VALUE);
						panelResult.setValue('KEY_VALUE',responseText.SLIP_KEY_VALUE);
						console.log("responseText",responseText);
						console.log("SLIP_KEY_VALUE",responseText.SLIP_KEY_VALUE);
						directMasterStore1.loadStoreRecords();
					}
					
				})
			}else if(sGubun == "77"){
				// 도급원가차감자동기표
				Ext.getBody().mask('Loading..');
				gsInputPath	 = sGubun;	
				gsDivCode    = params.DIV_CODE;
				gsFrAcDate   = params.EX_DATE;
				gsToAcDate   = params.EX_DATE;
				
				agj260ukrService.spdAutoSlip77(params, function(responseText, response){
					Ext.getBody().unmask();
					
									
					panelSearch.setValue('AC_DATE_FR',params.FR_AC_DATE);
					panelSearch.setValue('AC_DATE_TO',params.TO_AC_DATE);
					panelResult.setValue('AC_DATE_FR',params.FR_AC_DATE);
					panelResult.setValue('AC_DATE_TO',params.TO_AC_DATE);
					
					panelSearch.setValue('INPUT_PATH', sGubun);
					panelResult.setValue('INPUT_PATH', sGubun);
						
					if(responseText && responseText.SLIP_KEY_VALUE)	{
						panelSearch.setValue('KEY_VALUE',responseText.SLIP_KEY_VALUE);
						panelResult.setValue('KEY_VALUE',responseText.SLIP_KEY_VALUE);
						console.log("responseText",responseText);
						console.log("SLIP_KEY_VALUE",responseText.SLIP_KEY_VALUE);
						directMasterStore1.loadStoreRecords();
					}
					
				})
			}else if(sGubun == "92"){
				// 외환평가
				Ext.getBody().mask('Loading..');
				gsInputPath	 = sGubun;	
				gsDivCode    = params.DIV_CODE;
				gsFrAcDate   = params.AC_DATE;
				gsToAcDate   = params.AC_DATE;
				
				agj260ukrService.spAutoSlip92(params, function(responseText, response){
					Ext.getBody().unmask();
					
									
					panelSearch.setValue('AC_DATE_FR',params.AC_DATE);
					panelSearch.setValue('AC_DATE_TO',params.AC_DATE);
					panelResult.setValue('AC_DATE_FR',params.AC_DATE);
					panelResult.setValue('AC_DATE_TO',params.AC_DATE);
					
					panelSearch.setValue('INPUT_PATH', sGubun);
					panelResult.setValue('INPUT_PATH', sGubun);
						
					if(responseText && responseText.SLIP_KEY_VALUE)	{
						panelSearch.setValue('KEY_VALUE',responseText.SLIP_KEY_VALUE);
						panelResult.setValue('KEY_VALUE',responseText.SLIP_KEY_VALUE);
						console.log("responseText",responseText);
						console.log("SLIP_KEY_VALUE",responseText.SLIP_KEY_VALUE);
						directMasterStore1.loadStoreRecords();
					}
					
				})
			}else if(sGubun == "93"){
				// 외환평가차감자동기표
				Ext.getBody().mask('Loading..');
				gsInputPath	 = sGubun;	
				gsDivCode    = params.DIV_CODE;
				gsFrAcDate   = params.EX_DATE;
				gsToAcDate   = params.EX_DATE;
				
				agj260ukrService.spdAutoSlip93(params, function(responseText, response){
					Ext.getBody().unmask();
					
									
					panelSearch.setValue('AC_DATE_FR',params.AC_DATE);
					panelSearch.setValue('AC_DATE_TO',params.AC_DATE);
					panelResult.setValue('AC_DATE_FR',params.AC_DATE);
					panelResult.setValue('AC_DATE_TO',params.AC_DATE);
					
					panelSearch.setValue('INPUT_PATH', sGubun);
					panelResult.setValue('INPUT_PATH', sGubun);
						
					if(responseText && responseText.SLIP_KEY_VALUE)	{
						panelSearch.setValue('KEY_VALUE',responseText.SLIP_KEY_VALUE);
						panelResult.setValue('KEY_VALUE',responseText.SLIP_KEY_VALUE);
						console.log("responseText",responseText);
						console.log("SLIP_KEY_VALUE",responseText.SLIP_KEY_VALUE);
						directMasterStore1.loadStoreRecords();
					}
					
				})
			}
			
		},
		
    	setAccntInfo:function(record, detailForm)	{
    		Ext.getBody().mask();
    		var accnt = record.get('ACCNT');
    		//UniAccnt.fnIsCostAccnt(accnt, true);
    		if(accnt)	{
    			accntCommonService.fnGetAccntInfo({'ACCNT_CD':accnt}, function(provider, response){
    				var rtnRecord = record;
    				if(provider){
    					UniAppManager.app.loadDataAccntInfo(rtnRecord, detailForm, provider)
    				}else {
    					var slipDivi = rtnRecord.get('SLIP_DIVI');
    					if(slipDivi == '1' || slipDivi == '2')	{
    						if(rtnRecord.get('SPEC_DIVI') == 'A')	{
    							alert(Msg.sMA0040);
    							this.clearAccntInfo(rtnRecord, detailForm);
    						}
    					}
    					/*alert(Msg.sMA0006);
    					if(fieldName)	{
    						record.set(fieldName, '');
    					}*/
    				}
    				Ext.getBody().unmask();
    				
    			})
    		}
    	},
    	loadDataAccntInfo:function(rtnRecord, detailForm, provider)	{
    		
			rtnRecord.set("ACCNT", provider.ACCNT);
			rtnRecord.set("ACCNT_NAME", provider.ACCNT_NAME);
			rtnRecord.set("CUSTOM_CODE", "");
			rtnRecord.set("CUSTOM_NAME", "");
			
			rtnRecord.set("AC_CODE1", provider.AC_CODE1);
			rtnRecord.set("AC_CODE2", provider.AC_CODE2);
			rtnRecord.set("AC_CODE3", provider.AC_CODE3);
			rtnRecord.set("AC_CODE4", provider.AC_CODE4);
			rtnRecord.set("AC_CODE5", provider.AC_CODE5);
			rtnRecord.set("AC_CODE6", provider.AC_CODE6);
			
			rtnRecord.set("AC_NAME1", provider.AC_NAME1);
			rtnRecord.set("AC_NAME2", provider.AC_NAME2);
			rtnRecord.set("AC_NAME3", provider.AC_NAME3);
			rtnRecord.set("AC_NAME4", provider.AC_NAME4);
			rtnRecord.set("AC_NAME5", provider.AC_NAME5);
			rtnRecord.set("AC_NAME6", provider.AC_NAME6);
			
			rtnRecord.set("AC_DATA1", "");
			rtnRecord.set("AC_DATA2", "");
			rtnRecord.set("AC_DATA3", "");
			rtnRecord.set("AC_DATA4", "");
			rtnRecord.set("AC_DATA5", "");
			rtnRecord.set("AC_DATA6", "");
				
			rtnRecord.set("AC_DATA_NAME1", "");
			rtnRecord.set("AC_DATA_NAME2", "");
			rtnRecord.set("AC_DATA_NAME3", "");
			rtnRecord.set("AC_DATA_NAME4", "");
			rtnRecord.set("AC_DATA_NAME5", "");
			rtnRecord.set("AC_DATA_NAME6", "");
				
			rtnRecord.set("BOOK_CODE1", provider.BOOK_CODE1);
			rtnRecord.set("BOOK_CODE2", provider.BOOK_CODE2);
			rtnRecord.set("BOOK_DATA1", "");
			rtnRecord.set("BOOK_DATA2", "");
			rtnRecord.set("BOOK_DATA_NAME1", "");
			rtnRecord.set("BOOK_DATA_NAME2", "");
			
			if(rtnRecord.get("DR_CR") == "1") {
				
				rtnRecord.set("AC_CTL1", provider.DR_CTL1);
				rtnRecord.set("AC_CTL2", provider.DR_CTL2);
				rtnRecord.set("AC_CTL3", provider.DR_CTL3);
				rtnRecord.set("AC_CTL4", provider.DR_CTL4);
				rtnRecord.set("AC_CTL5", provider.DR_CTL5);
				rtnRecord.set("AC_CTL6", provider.DR_CTL6);
				
			}else if(rtnRecord.get("DR_CR") == "2")	{ 
				
				rtnRecord.set("AC_CTL1", provider.CR_CTL1);
				rtnRecord.set("AC_CTL2", provider.CR_CTL2);
				rtnRecord.set("AC_CTL3", provider.CR_CTL3);
				rtnRecord.set("AC_CTL4", provider.CR_CTL4);
				rtnRecord.set("AC_CTL5", provider.CR_CTL5);
				rtnRecord.set("AC_CTL6", provider.CR_CTL6);
				
			}
			
			rtnRecord.set("AC_TYPE1", provider.AC_TYPE1);
			rtnRecord.set("AC_TYPE2", provider.AC_TYPE2);
			rtnRecord.set("AC_TYPE3", provider.AC_TYPE3);
			rtnRecord.set("AC_TYPE4", provider.AC_TYPE4);
			rtnRecord.set("AC_TYPE5", provider.AC_TYPE5);
			rtnRecord.set("AC_TYPE6", provider.AC_TYPE6);
				
			rtnRecord.set("AC_LEN1", provider.AC_LEN1);
			rtnRecord.set("AC_LEN2", provider.AC_LEN2);
			rtnRecord.set("AC_LEN3", provider.AC_LEN3);
			rtnRecord.set("AC_LEN4", provider.AC_LEN4);
			rtnRecord.set("AC_LEN5", provider.AC_LEN5);
			rtnRecord.set("AC_LEN6", provider.AC_LEN6);
			
			rtnRecord.set("AC_POPUP1", provider.AC_POPUP1);
			rtnRecord.set("AC_POPUP2", provider.AC_POPUP2);
			rtnRecord.set("AC_POPUP3", provider.AC_POPUP3);
			rtnRecord.set("AC_POPUP4", provider.AC_POPUP4);
			rtnRecord.set("AC_POPUP5", provider.AC_POPUP5);
			rtnRecord.set("AC_POPUP6", provider.AC_POPUP6);		
	
			rtnRecord.set("AC_FORMAT1", provider.AC_FORMAT1);
			rtnRecord.set("AC_FORMAT2", provider.AC_FORMAT2);
			rtnRecord.set("AC_FORMAT3", provider.AC_FORMAT3);
			rtnRecord.set("AC_FORMAT4", provider.AC_FORMAT4);
			rtnRecord.set("AC_FORMAT5", provider.AC_FORMAT5);
			rtnRecord.set("AC_FORMAT6", provider.AC_FORMAT6);
	
			//rtnRecord.set("MONEY_UNIT", "");
			
			rtnRecord.set("ACCNT_SPEC", provider.ACCNT_SPEC);
			rtnRecord.set("SPEC_DIVI", provider.SPEC_DIVI);
			rtnRecord.set("PROFIT_DIVI", provider.PROFIT_DIVI);
			rtnRecord.set("JAN_DIVI", provider.JAN_DIVI);
				
			rtnRecord.set("PEND_YN", provider.PEND_YN);
			rtnRecord.set("PEND_CODE", provider.PEND_CODE);
			rtnRecord.set("BUDG_YN", provider.BUDG_YN);
			rtnRecord.set("BUDGCTL_YN", provider.BUDGCTL_YN);
			rtnRecord.set("FOR_YN", provider.FOR_YN);
			
			UniAppManager.app.fnGetProofKind(rtnRecord, provider.ACCNT_CODE);
			
			rtnRecord.set("CREDIT_CODE", "");
			rtnRecord.set("REASON_CODE", "");
			
			var dataMap = rtnRecord.data;
			
			var prevRecord, grid = this.getActiveGrid();
			var store = grid.getStore();
			selectedIdx = store.indexOf(rtnRecord)
			if(selectedIdx >0) prevRecord = store.getAt(selectedIdx-1);
			
			UniAccnt.addMadeFields(detailForm, dataMap, detailForm, '', rtnRecord, prevRecord);
			detailForm.setActiveRecord(rtnRecord||null);
			UniAppManager.app.fnCheckPendYN(rtnRecord, detailForm);
			UniAppManager.app.fnSetBillDate(rtnRecord)
			UniAppManager.app.fnSetDefaultAcCodeI7(rtnRecord);
			UniAppManager.app.fnSetDefaultAcCodeA6(rtnRecord);
			
    	},
    	clearAccntInfo:function(record, detailForm){
    		Ext.getBody().mask();
    		record.set("ACCNT", "");
			record.set("ACCNT_NAME", "");
			record.set("CUSTOM_CODE", "");
			record.set("CUSTOM_NAME", "");
			
			record.set("AC_CODE1", "");
			record.set("AC_CODE2", "");
			record.set("AC_CODE3", "");
			record.set("AC_CODE4", "");
			record.set("AC_CODE5", "");
			record.set("AC_CODE6", "");
			
			record.set("AC_NAME1", "");
			record.set("AC_NAME2", "");
			record.set("AC_NAME3", "");
			record.set("AC_NAME4", "");
			record.set("AC_NAME5", "");
			record.set("AC_NAME6", "");
			
			record.set("AC_DATA1", "");
			record.set("AC_DATA2", "");
			record.set("AC_DATA3", "");
			record.set("AC_DATA4", "");
			record.set("AC_DATA5", "");
			record.set("AC_DATA6", "");
			
			record.set("AC_DATA_NAME1", "");
			record.set("AC_DATA_NAME2", "");
			record.set("AC_DATA_NAME3", "");
			record.set("AC_DATA_NAME4", "");
			record.set("AC_DATA_NAME5", "");
			record.set("AC_DATA_NAME6", "");
			
			record.set("BOOK_CODE1", "");
			record.set("BOOK_CODE2", "");
			record.set("BOOK_DATA1", "");
			record.set("BOOK_DATA2", "");
			record.set("BOOK_DATA_NAME1", "");
			record.set("BOOK_DATA_NAME2", "");
			
			record.set("AC_CTL1", "");
			record.set("AC_CTL2", "");
			record.set("AC_CTL3", "");
			record.set("AC_CTL4", "");
			record.set("AC_CTL5", "");
			record.set("AC_CTL6", "");
			
			record.set("AC_TYPE1", "");
			record.set("AC_TYPE2", "");
			record.set("AC_TYPE3", "");
			record.set("AC_TYPE4", "");
			record.set("AC_TYPE5", "");
			record.set("AC_TYPE6", "");
			
			record.set("AC_LEN1", "");
			record.set("AC_LEN2", "");
			record.set("AC_LEN3", "");
			record.set("AC_LEN4", "");
			record.set("AC_LEN5", "");
			record.set("AC_LEN6", "");
			
			record.set("AC_POPUP1", "");
			record.set("AC_POPUP2", "");
			record.set("AC_POPUP3", "");
			record.set("AC_POPUP4", "");
			record.set("AC_POPUP5", "");
			record.set("AC_POPUP6", "");
			
			record.set("AC_FORMAT1", "");
			record.set("AC_FORMAT2", "");
			record.set("AC_FORMAT3", "");
			record.set("AC_FORMAT4", "");
			record.set("AC_FORMAT5", "");
			record.set("AC_FORMAT6", "");
		
			record.set("MONEY_UNIT", "");
			
			record.set("EXCHG_RATE_O", 0);
			record.set("FOR_AMT_I", 0);
			
			record.set("ACCNT_SPEC", "");
			record.set("SPEC_DIVI", "");
			record.set("PROFIT_DIVI", "");
			record.set("JAN_DIVI", "");
			
			record.set("PEND_YN", "");
			record.set("PEND_CODE", "");
			record.set("BUDG_YN", "");
			record.set("BUDGCTL_YN", "");
			record.set("FOR_YN", "");
			
			record.set("PROOF_KIND", "");
			record.set("PROOF_KIND_NM", "");
			
			record.set("CREDIT_CODE", "");
			record.set("REASON_CODE", "");
			detailForm.down('#formFieldArea1').removeAll();
    		Ext.getBody().unmask();
    	},
    	getActiveForm:function()	{
    		var form;
    		if(tab)	{
	    		var activeTab = tab.getActiveTab();
	    		var activeTabId = activeTab.getItemId();
				
				if(activeTabId == 'agjTab1' )	{
					form = detailForm1;
				}/*else {
					form = saleDetailForm;
				}*/
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
				}/*else {
					grid = masterGrid2;
				}*/
			}else {
				grid = masterGrid1;
			}
			
			return grid
    	},
		fnSetBillDate: function(record)	{
			
			var sExDate   = UniDate.getDbDateStr(record.get('AC_DATE'));
			var sSpecDivi =  record.get('SPEC_DIVI');
			
			if( sSpecDivi == "F1" || sSpecDivi == "F2" )	{
				this.fnSetAcCode(record, "I3", sExDate)
			}
	
		},
		fnSetAcCode:function(record, acCode, acValue, acNameValue)	{
			var sValue =  !Ext.isEmpty(acValue)  ? acValue.toString(): "";
			var sNameValue = !Ext.isEmpty(acNameValue)  ? acNameValue.toString():"";
			if(isNaN(sValue)) sValue = 0;
			var form = this.getActiveForm();
			for(var i=1 ; i <= 6; i++)	{
				if( record.get('AC_CODE'+i.toString()) == acCode)	{ 
					record.set('AC_DATA'+i.toString(), sValue);
					record.set('AC_DATA_NAME'+i.toString(), sNameValue);
					form.setValue('AC_DATA'+i.toString(), sValue);
					var dataField = form.getField('AC_DATA'+i.toString());
					if(dataField) dataField.fireEvent('change', dataField, sValue)
					form.setValue('AC_DATA_NAME'+i.toString(), sNameValue);
					var dataNameField = form.getField('AC_DATA_NAME'+i.toString());
					if(dataNameField) dataNameField.fireEvent('change', dataNameField, sNameValue)
				}
			}
		},
		fnFindInputDivi:function(record)	{
			var grid = this.getActiveGrid()
			var fRecord = grid.getStore().getAt(grid.getStore().findBy(function(rec){
																				return (rec.get('AC_DATE') == record.get('AC_DATE') 
																						&& rec.get('SLIP_NUM') == record.get('SLIP_NUM') 
																						&& rec.get('SLIP_SEQ') != record.get('SLIP_SEQ')) ;
																			})
												  );
			if(fRecord)	{
				gsInputDivi = fRecord.get('INPUT_DIVI');
			}
		},
		fnGetProofKind:function(record, billType)	{
			var sSaleDivi, sProofKindSet, sBillType = billType;
			
			if(record.get("DR_CR") == "1" && record.get("SPEC_DIVI") == "F1") {			
				sSaleDivi = "1"	;	// 매입
				if(sBillType == "")  sBillType = "51";
					
			}else if(record.get("DR_CR") == "2" && record.get("SPEC_DIVI") == "F2") {			
				sSaleDivi = "2"		// 매출
				if(sBillType == "" ) sBillType == "11";
					
			}else {
				record.set("PROOF_KIND", "");
				record.set("PROOF_KIND_NM", "");
				return;
			}		
			sProofKindSet = this.fnGetProofKindName(sBillType, sSaleDivi)
		
			record.set('PROOF_KIND', sProofKindSet.sBillType);
			record.set('PROOF_KIND_NM', sProofKindSet.sProofKindNm);
		},
		fnGetProofKindName:function(sBillType, sSaleDivi)	{
			var sProofKindNm;
			var store = Ext.StoreManager.lookup("CBS_AU_A022");
			var selRecordIdx = store.findBy(function(record){return (record.get("value") == sBillType && record.get("refCode3")==sSaleDivi)});
			var selRecord = store.getAt(selRecordIdx);
			if(selRecord) sProofKindNm = 	selRecord.get("text");
			
			if(!sProofKindNm || sProofKindNm == "") {
				if(sSaleDivi == "2") {
					sBillType = "11"
				}else {
					sBillType = "51"
				}
				selRecordIdx = store.findBy(function(record){return (record.get("value") == sBillType && record.get("refCode3")==sSaleDivi)});
				selRecord = store.getAt(selRecordIdx);
				if(selRecord) sProofKindNm = selRecord.get("text");
			}
			
			return {"sBillType":sBillType, "sProofKindNm":sProofKindNm};
			
		},
		fnCheckPendYN: function(record, form)	{
			if(baseInfo.gsPendYn == "1") {
				if(record.get('PEND_YN') == 'Y')	{
					if(record.get('DR_CR') != record.get('JAN_DIVI') )	{
						alert(Msg.sMA0278);
						this.clearAccntInfo(record, form);
					}
				}
			}
		},
		fnChangeAcEssInput:function(record)	{
			Ext.getBody().mask();
    		var accnt = record.get('ACCNT');
    		UniAccnt.fnIsCostAccnt(accnt, true);
    		if(accnt)	{
    			accntCommonService.fnGetAccntInfo({'ACCNT_CD':accnt}, function(provider, response){
    				var rtnRecord = record;
    				if(provider ){
    					
						
						if(rtnRecord.get("DR_CR") == "1") {
							
							rtnRecord.set("AC_CTL1", provider.DR_CTL1);
							rtnRecord.set("AC_CTL2", provider.DR_CTL2);
							rtnRecord.set("AC_CTL3", provider.DR_CTL3);
							rtnRecord.set("AC_CTL4", provider.DR_CTL4);
							rtnRecord.set("AC_CTL5", provider.DR_CTL5);
							rtnRecord.set("AC_CTL6", provider.DR_CTL6);
							
						}else if(rtnRecord.get("DR_CR") == "2")	{ 
							
							rtnRecord.set("AC_CTL1", provider.CR_CTL1);
							rtnRecord.set("AC_CTL2", provider.CR_CTL2);
							rtnRecord.set("AC_CTL3", provider.CR_CTL3);
							rtnRecord.set("AC_CTL4", provider.CR_CTL4);
							rtnRecord.set("AC_CTL5", provider.CR_CTL5);
							rtnRecord.set("AC_CTL6", provider.CR_CTL6);
							
						}
						
    				}else {
    					alert(Msg.sMA0006);
    				}
    				Ext.getBody().unmask();
    				
    			})
    		}
		},
		fnSetDefaultAcCodeI7:function(record, newValue)	{
			var specDivi = record.get("SPEC_DIVI");
			if(specDivi != "F1" && specDivi != "F2" )	{
				return;
			}
			
			// 증빙유형의 참조코드1 설정값 가져오기
			if(record.get('PROOF_KIND') != "")	{
				var defaultValue, defaultValueName;
				var param = {
					'MAIN_CODE':'A022',
					'SUB_CODE' : Ext.isEmpty(newValue) ? record.get('PROOF_KIND'):newValue,
					'field' : 'refCode1'
				};
				
				defaultValue = UniAccnt.fnGetRefCode(param);
				if(defaultValue == 'A' ||  defaultValue == 'C' || defaultValue == 'D' || defaultValue == 'B' )	{
						defaultValue = "Y"
				} else {
						defaultValue = "N"
				}
				
				var param2 = {
					'MAIN_CODE':'A149',
					'SUB_CODE' : defaultValue,
					'field' : 'text'
				};
				defaultValueName = UniAccnt.fnGetRefCode(param2);
				var form = this.getActiveForm();
				// 전자발행여부 default 설정
				for(var i =1 ; i <= 6; i++)	{
					if(record.get('AC_CODE'+i.toString()) == "I7" ) {
						record.set('AC_DATA'+i.toString(), defaultValue);
						record.set('AC_DATA_NAME'+i.toString(), defaultValueName);
						form.setValue('AC_DATA'+i.toString(), defaultValue);
						form.setValue('AC_DATA_NAME'+i.toString(), defaultValueName);
					}
				};
				
			}
		},
		fnSetDefaultAcCodeA6:function(record)	{
			if(baseInfo.gbAutoMappingA6 != "Y" )	{
				return;
			}
			var form = this.getActiveForm();
			for(var i =1 ; i <= 6; i++)	{
				if(record.get('AC_CODE'+i.toString()) == "A6" ) {
					record.set('AC_DATA'+i.toString(), baseInfo.gsChargePNumb);
					record.set('AC_DATA_NAME'+i.toString(), baseInfo.gsChargePName);
					form.setValue('AC_DATA'+i.toString(), baseInfo.gsChargePNumb);
					form.setValue('AC_DATA_NAME'+i.toString(), baseInfo.gsChargePName);
				}
			}
		},
	
		fnCheckNoteAmt:function(grid, record, damt, dOldAmt)	{
			var lAcDataCol;
			var sSpecDivi, sDrCr;
			var isNew = false;
			var activeTab = tab.getActiveTab();
			var activeTabId = activeTab.getItemId();
			
			if(activeTabId == 'agjTab1' )	{
				for(var i =1 ; i <= 6 ; i++)	{
					if('C2' == record.get('AC_CODE'+i.toString()))	{
						lAcDataCol = "AC_DATA"+i.toString()
					}
				}
				// 부도어음일 때 어음번호를 관리하지 않을 수 있다.
				if(Ext.isEmpty(lAcDataCol))	{
					isNew = true;
					this.fnSetTaxAmt(record);
					return
				}
				
			}
			
			if(Ext.isEmpty(record.get(lAcDataCol)))	{
				isNew = true;
				this.fnSetTaxAmt(record);
				return;
			}
			
			sSpecDivi = record.get('SPEC_DIVI'); 
			sDrCr =  record.get('DR_CR');  
		
			UniAccnt.fnGetNoteAmt(UniAppManager.app.cbCheckNoteAmt,noteNum, 0,0, record.get('PROOF_KIND'), damt, dOldAmt, record )
			
		},
		fnSetTaxAmt:function(record, taxRate, proofKind, amt_i)	{
			var dSupplyAmt, sProofKind, dTaxRate, dTaxAmt=0;
			if(record.get('SPEC_DIVI') != 'F1' && record.get('SPEC_DIVI') != 'F2')	{
				return;
			}
			
			if(amt_i)	{
				dTaxAmt = amt_i;
			}else if(record.get("DR_CR")== "1")	{
				dTaxAmt = record.get("DR_AMT_I");
			}else {
				dTaxAmt = record.get("CR_AMT_I");
			}
			
			if(taxRate)	{
				dTaxRate = taxRate
			}else {
				var param={
					'MAIN_CODE':'A022',
					'SUB_CODE':proofKind ? proofKind:record.get('PROOF_KIND'),
					'field':'refCode2'
				}
				dTaxRate = UniAccnt.fnGetRefCode(param);
			}
			if(dTaxRate != 0){
				dSupplyAmt = dTaxAmt * parseInt(dTaxRate);
				
				this.fnSetAcCode(record, "I1", dSupplyAmt)	// 공급가액
				this.fnSetAcCode(record, "I6", dTaxAmt)		// 세액'
			}
			
		},
		fnCalTaxAmt:function(record)	{
			UniAccnt.fnGetTaxRate(UniAppManager.app.cbGetTaxAmtForSales, record)			
		},
		fnProofKindPopUp:function(record, newValue)	{
			var proofKind = newValue ? newValue : record.get("PROOF_KIND");
			
			// 증빙유형 - 증빙사유 코드 팝업
			//comCodeWin = UniAccnt.comCodePopup(comCodeWin, record, 'REASON_CODE', '', '매입불공제사유', 'AU', 'A070', 'VALUE');
			//creditWIn = creditPopup (creditWIn, record, record.get('CREDIT_CODE'), "CREDIT_CODE", null, null, null, null,  'VALUE')	
			//openCrediNotWin(record);
			
			//매입세액불공제/고정자산매입(불공)
			if(proofKind == "54" || proofKind == "61" )	{
				comCodeWin = UniAccnt.comCodePopup(comCodeWin, record, 'REASON_CODE', '', '매입세불공제사유', 'AU', 'A070', 'VALUE');
				record.set('CREDIT_NUM', '');				
				
			//신용카드매입/신용카드매입(고정자산)/신용카드(의제매입)/신용카드(불공제)
			}else if(proofKind == "53" || proofKind == "68" || proofKind == "64")	{				
				creditWIn = creditPopup (creditWIn, record, record.get('CREDIT_NUM_EXPOS'), "CREDIT_CODE", null, "CREDIT_NUM",null, null, null,  'VALUE');			
				record.set("REASON_CODE",  "");
		
			//현금영수증매입/현금영수증(고정자산)/현금영수증(불공제)
			}else if (proofKind == '62' ||proofKind == '69' )	{				
				openCrediNotWin(record);				
				record.set("REASON_CODE", '');
		
			//신용카드매입(불공제)
			}else if (proofKind == "70" )	{			
				//openCrediNotWin(record);		
				creditWIn = creditPopup (creditWIn, record, record.get('CREDIT_NUM_EXPOS'), "CREDIT_CODE", null, "CREDIT_NUM",null, null, null,  'VALUE');			
				comCodeWin = UniAccnt.comCodePopup(comCodeWin, record, 'REASON_CODE', '', '매입세불공제사유', 'AU', 'A070', 'VALUE');
				
			//현금영수증(불공제)
			} else if(proofKind == "71" )	{			
				openCrediNotWin(record);	
				comCodeWin = UniAccnt.comCodePopup(comCodeWin, record, 'REASON_CODE', '', '매입세불공제사유', 'AU', 'A070', 'VALUE');
				
				//creditWIn = creditPopup (creditWIn, record, record.get('CREDIT_NUM'), "CREDIT_NUM", null, null, null, null,  'VALUE');			
		
			//카드과세/면세/영세
			} else if( proofKind >= "13" && proofKind <= "17")	{				
				creditWIn = creditPopup (creditWIn, record, record.get('CREDIT_NUM_EXPOS'), "CREDIT_CODE", null, "CREDIT_NUM",null, null, null,  'VALUE');				
				record.set("REASON_CODE", '');
			
			}else {	
				record.set("REASON_CODE", '');
				record.set("CREDIT_NUM", '');
			}
		},
		cbGetTaxAmt:function(taxRate,  record)	{
			
			if(taxRate != 0){
				var dTaxAmt=0;
				if(record.get("DR_CR")== "1")	{
					dTaxAmt = record.get("DR_AMT_I");
				}else {
					dTaxAmt = record.get("CR_AMT_I");
				}
				dSupplyAmt = dTaxAmt * dTaxRate;
				
				this.fnSetAcCode(record, "I1", dSupplyAmt)	// 공급가액
				this.fnSetAcCode(record, "I6", dTaxAmt)		// 세액'
			}
		},
		
		cbGetTaxAmtForSales:function(taxRate,  record)	{
			var dSupplyAmt=record.get("SUPPLY_AMT_I"), sProofKind=record.get("PROOF_KIND");
			var dTmpSupplyAmt, dTaxAmt;
			
			if(sProofKind == "24" || sProofKind == "13" || sProofKind == "14" ) {
				dTmpSupplyAmt = dSupplyAmt / ((100 + taxRate) * 0.01)
				dTaxAmt = Math.floor(dTmpSupplyAmt * taxRate * 0.01);
				dSupplyAmt = dSupplyAmt - dTaxAmt;
				record.set("SUPPLY_AMT_I",dSupplyAmt);
				record.set("TAX_AMT_I",dTaxAmt);
			}else {
				dTaxAmt = Math.floor(dSupplyAmt * taxRate * 0.01);
				record.set("TAX_AMT_I",dTaxAmt);
			}	
		},
		cbGetExistsSlipNum:function(provider, fieldName, newValue, oldValue, record)	{
			if(provider.CNT != 0)	{
				alert(Msg.sMA0306);
				record.set('SLIP_NUM', oldValue);
				UniAppManager.app.fnFindInputDivi(record);
			}
		}, 
		cbCheckNoteAmt: function (rtn, newAmt,  oldAmt, record, fidleName)	{
			var sSpecDivi = record.get("SPEC_DIVI");
			var DrCr = record.get("DR_CR");
			var isNew = false;
			
			if(rtm)	{
				if(rtm.NOTE_AMT == 0 ) {
					if( !( (sSpecDivi == "D1" && sDrCr == "1") 
						    || (sSpecDivi == "D3" && sDrCr == "2") 
						 )
					){
						record.set(fidleName, oldAmt);
					}else {
						isNew = true;	
					}
				}else {
					// 받을어음이 대변에 오고 결제금액을 입력하지 않았을때
					// 선택한 어음의 발행금액을 금액에 넣어준다.'
					if(Ext.isEmpty(newAmt))	{
						newAmt = 0;
					}
					if( (sSpecDivi == "D1" &&  sDrCr == "2") && newAmt ==0 )	{
						record.set("AMT_I", rtn.OC_AMT_I);
						isNew = true;
					}
					// 지급어음 or 부도어음이 차변에 오고 결제금액을 입력하지 않았을때
					// 선택한 어음의 발행금액을 금액에 넣어준다.
					else if( ((sSpecDivi == "D3" || sSpecDivi == "D4") && sDrCr == "1") && newAmt == 0 ) {
						record.set("AMT_I", rtn.OC_AMT_I);
						isNew = true;
					}
					// 받을어음, 부도어음이 차변에 오면 금액은 발행금액만 비교한다
					else if( (sSpecDivi == "D1" || sSpecDivi == "D4") && sDrCr == "1" )	{
						if(  rtn.OC_AMT_I != newAmt) {
							alert(Msg.sMA0330);
							record.set(fidleName, oldAmt);
						}else {
							isNew = true;
						}
					}else {
					
						// 어음 미결제 잔액 계산 (발행금액 - 반제금액)
						var dNoteAmtI = rtn.OC_AMT_I - rtn.J_AMT_I;
						// 반결제여부 확인
						if((dNoteAmtI - newAmt) > 0) {	 
							if(confirm(Msg.sMA0330+'\n'+Msg.sMA0333))	{
								record.set(fidleName, oldAmt);
							}else {
								isNew = true;
							}
						}else if ((dNoteAmtI - newAmt)  < 0 ) {	
							alert(Msg.sMA0332);
							frecord.set(fidleName, oldAmt);
						}else {
							isNew = true;
						}
					}
				}
				if(isNew){
					this.fnSetTaxAmt(record, rtn.TAX_RATE);
				}
			}
		},
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
				case 'AC_DAY':
				
					if(Ext.isNumber(newValue))	{
						rv = Msg.sMA0076;
						return rv;
					}
					
					var sDate = newValue.length == 1 ? '0'+newValue : newValue;
					var acDate = UniDate.getMonthStr(panelSearch.getValue('AC_DATE_TO'))+sDate;
					if(acDate.length == 8 && Ext.Date.isValid(parseInt(acDate.substring(0,4)), parseInt(acDate.substring(4,6)),parseInt(acDate.substring(6,8))))	{
						if(newValue != sDate) record.set(fieldName, sDate);
						record.set('AC_DATE', UniDate.extParseDate(acDate));
						
						//var isNew=false;
						//if(directMasterStore1.getCount() == 1 && record.obj.phantom)	{
						//	isNew=true;
						//}
						//if(UniAppManager.app.needNewSlipNum(this.grid, isNew) )	{
							Ext.getBody().mask();
							agj260ukrService.getSlipNum({'EX_DATE':acDate}, function(provider, result) {
								var rec = record;
								var tAcDate = acDate;
								var tSDate = sDate;
								if(provider.SLIP_NUM)	{
									rec.set('SLIP_NUM', provider.SLIP_NUM);
									// 수정된 데이타의 경우 이전 전표번호가 같은 데이타인 경우 변견된 전표일자와
									// 전표번호로 변경해 준다.
									Ext.each(directMasterStore1.data.items, function(item, idx)	{
										if(!Ext.isEmpty(rec.get('OLD_SLIP_NUM')) && UniDate.getDateStr( rec.get('OLD_AC_DATE')) == UniDate.getDateStr(item.get('OLD_AC_DATE')) && rec.get('OLD_SLIP_NUM') == item.get('OLD_SLIP_NUM'))	{
											item.set('AC_DATE',tAcDate);
											item.set('AC_DAY',tSDate);
											item.set('SLIP_NUM',provider.SLIP_NUM);
											
											if(item.phantom)	{
												item.set('OLD_AC_DATE',tAcDate);
												item.set('OLD_AC_DATE',tAcDate);
											}
										}
									})
								}
								if(record.obj.phantom) {
									record.set('OLD_AC_DATE', record.get('AC_DATE'));
								}
								UniAppManager.app.fnSetBillDate(record);
								UniAppManager.app.fnFindInputDivi(record);
								record.set('INPUT_DIVI',gsInputDivi);
								Ext.getBody().unmask();
							});	
						/*}else {
							
							// 수정된 데이타의 경우 이전 전표번호가 같은 데이타인 경우 변견된 전표일자와 전표번호로
							// 변경해 준다.
							Ext.each(directMasterStore1.data.items, function(item, idx)	{
								if(Ext.isEmpty(record.get('OLD_SLIP_NUM')) && record.get('OLD_SLIP_NUM') == item.get('OLD_SLIP_NUM'))	{
									item.set('AC_DATE',acDate);
									item.set('AC_DAY',sDate);
									item.set('SLIP_NUM',record.get('SLIP_NUM'));
									
									if(item.phantom)	{
										item.set('OLD_AC_DATE',tAcDate);
										item.set('OLD_AC_DATE',tAcDate);
									}
								}
							})
							
							if(record.obj.phantom) {
								record.set('OLD_AC_DATE', record.get('AC_DATE'));
							}
							UniAppManager.app.fnSetBillDate(record);
							UniAppManager.app.fnFindInputDivi(record);
							record.set('INPUT_DIVI', gsInputDivi);
						}*/							
					} else {
						rv =Msg.sMA0076 ;
					}
					
				break;
				case 'SLIP_NUM' :
					if(oldValue != newValue)	{
						if(!record.obj.phantom )	{
							UniAccnt.fnGetExistSlipNum(UniAppManager.app.cbGetExistsSlipNum, record, csSLIP_TYPE, record.get('AC_DATE'), newValue, oldValue);
						}else {
							record.set('OLD_SLIP_NUM', newValue);
						}
					}
					break;
				case 'SLIP_SEQ' :
					if(record.obj.phantom)	{
						record.set('OLD_SLIP_SEQ', newValue);
					}
					break;
				case 'SLIP_DIVI':
					if(oldValue == newValue)	{
						return rv;
					}
					if(newValue == "" ) {
						rv = false;
						return rv;
					}
					
					if (newValue == '2' || newValue == '3')	{
						record.set('DR_CR','1');				
						record.set('DR_AMT_I',record.get('CR_AMT_I'));
						record.set('CR_AMT_I',0);
						record.set('AMT_I',record.get('DR_AMT_I'));
					}else{
						
						record.set('DR_CR','2');						
						record.set('CR_AMT_I',record.get('DR_AMT_I'));
						record.set('DR_AMT_I',0);
						record.set('AMT_I',record.get('CR_AMT_I'));
						sAccnt = record.get('ACCNT');
						UniAccnt.fnIsCostAccnt(sAccnt, false);
					}
					
					console.log("SLIP_DIVI change :", record)
						
					UniAppManager.app.fnCheckPendYN(record, detailForm1);
					
					record.set('PROOF_KIND','');
					record.set('PROOF_KIND_NM','');
		
					UniAppManager.app.fnChangeAcEssInput(record)
					
					if (oldValue == "3" || oldValue == "4" ) {
						if (newValue == "1" || newValue == "2")	{
							record.set('ACCNT', '');
							record.set('ACCNT_NAME', '');
						}
					}
					if(newValue =="1")	{
						
					} else if(newValue =="2")	{
						
					}
					
					UniAppManager.app.fnSetBillDate(record);
					// 증빙유형의 참조코드1에 따라 전자발행여부 기본값 설정
					 UniAppManager.app.fnSetDefaultAcCodeI7(record)

					// 입력자의 사번을 이용해 관리항목(사번) 기본값 설정
					UniAppManager.app.fnSetDefaultAcCodeA6(record)	
					break;
				case 'DR_AMT_I' :
					
					if(record.get('SLIP_DIVI') == '1' || record.get('SLIP_DIVI') == '4' )	{
						rv =false;
						return rv;
					}
					var specDivi = record.get("SPEC_DIVI");
					if(specDivi && specDivi.substring(0,1) == "D" )	{
						UniAppManager.app.fnCheckNoteAmt(this.grid, record, newValue, oldValue)
					}
					
					
					if(record.get('DR_CR') == '1') {
						record.set('AMT_I', newValue);
					}
					if(record.get("FOR_YN") =="Y")	{
						UniAppManager.app.fnForeignPopUp(record);
					}
					UniAppManager.app.fnSetTaxAmt(record, null, null, newValue)
					break;
				case 'CR_AMT_I' :
					if(record.get('SLIP_DIVI') == '2' || record.get('SLIP_DIVI') == '3' )	{
						rv =false;
						return rv;
					}
					var specDivi = record.get("SPEC_DIVI");
					if(specDivi && specDivi.substring(0,1) == "D" )	{
						UniAppManager.app.fnCheckNoteAmt(this.grid, record, newValue, oldValue)
					}
					if(record.get('DR_CR') == '2') {
						record.set('AMT_I', newValue);
					}
					UniAppManager.app.fnSetTaxAmt(record, null, null, newValue)
					break;
				case 'PROOF_KIND':
					record.set('CREDIT_NUM', '');	
					record.set('CREDIT_NUM_EXPOS', '');
					record.set("REASON_CODE", '');
					UniAppManager.app.fnProofKindPopUp(record, newValue);
					UniAppManager.app.fnSetTaxAmt(record, null, newValue);
					// 증빙유형의 참조코드1에 따라 전자발행여부 기본값 설정
					UniAppManager.app.fnSetDefaultAcCodeI7(record, newValue)
					break;
				case 'DIV_CODE':
					UniAccnt.fnGetBillDivCode(UniAppManager.app.cbGetBillDivCode, record, newValue);
					break;
				
				default:
					break;
			}
			return rv;
			
		}
	}); // validator01
};


</script>


