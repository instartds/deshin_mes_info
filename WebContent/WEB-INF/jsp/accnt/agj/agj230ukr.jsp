<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agj230ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 				<!-- 사업장 -->   
	<t:ExtComboStore comboType="AU" comboCode="A009" /> 	<!-- 입력경로 -->
	<t:ExtComboStore comboType="AU" comboCode="A011" /> 	<!-- 입력경로 -->      
	<t:ExtComboStore comboType="AU" comboCode="A014" /> 	<!-- 승인상태 -->       
	<t:ExtComboStore comboType="AU" comboCode="B001" /> 	<!--법인구분-->
	<t:ExtComboStore comboType="AU" comboCode="A023" /> 	<!--결의회계구분-->
	
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var baseInfo = {
		'gsDefaultApsts':'${gsDefaultApsts}',
		'gsAutoReQuery' : '${gsAutoReQuery}',
		'gsAutoSLipNum'	: '${gsAutoSLipNum}',
		
		'gsChargeCode'	: '${chargeCode}',
		'gsChargePNumb'	: '${chargePNumb}',
		'gsChargeName'	: '${chargeName}',
		'gsChargeDivi'  : '${chargeDivi}'=='1' ? false:true		//1:회계부서:2:현업부서

	}
	
	var exSlipPgmId = '${exSlipPgmID}';
	var exSlipPgmLink = '/accnt/' + exSlipPgmId + '.do';
	var gbShowCompNum = ('${showCompNum}' == 'Y' ? false : true);	//	공통코드 A165 서브코드 81의 참조1 값 가져옴. Y:사업자등록번호 표시, 기타:미표시
	
	if(Ext.isEmpty(exSlipPgmId)) {
		exSlipPgmId = 'agj105ukr';
		exSlipPgmLink = '/accnt/agj105ukr.do';
	}
	
	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agj230ukrModel1', {
	    fields: [{name: 'CHK'						,text: '선택' 		,type: 'boolean'},	    		  
				 {name: 'AP_STS'					,text: '구분' 		,type: 'string'		, editable:false, comboType:'AU', comboCode:'A014'},	    		  
				 {name: 'EX_DATE'					,text: '결의일' 		,type: 'uniDate'	, editable:false},	    		  
				 {name: 'EX_NUM'					,text: '결의번호' 		,type: 'int'		, editable:false},	    		  
				 {name: 'AC_DATE'					,text: '회계일' 		,type: 'uniDate'	, editable:true},	    		  
				 {name: 'SLIP_NUM'					,text: '회계번호' 		,type: 'int'		, editable:true},	    		  
				 {name: 'DR_AMT_I'					,text: '차변금액' 		,type: 'uniPrice'	, editable:false},	    		  
				 {name: 'CR_AMT_I'					,text: '대변금액' 		,type: 'uniPrice'	, editable:false},	 
				 {name: 'REMARK'                    ,text: '적요'        ,type: 'string'     , editable:false},
				 {name: 'INPUT_PATH'				,text: '입력경로' 		,type: 'string'		, editable:false, comboType:'AU', comboCode:'A011'},	    		  
				 {name: 'CHARGE_CODE'				,text: '입력자' 		,type: 'string'		, editable:false},	    		  
				 {name: 'CHARGE_NAME'				,text: '입력자' 		,type: 'string'		, editable:false},	    		  
				 {name: 'INPUT_DATE'				,text: '입력일' 		,type: 'uniDate'	, editable:false},	    		  
				 {name: 'AP_CHARGE_NAME'			,text: '승인자' 		,type: 'string'		, editable:false},	    		  
				 {name: 'AP_DATE'					,text: '승인일' 		,type: 'uniDate'	, editable:false},
				 
	    		 {name: 'INPUT_DIVI'				,text: 'INPUT_DIVI' ,type: 'string'},
	    		 {name: 'DIV_CODE'				,text: 'DIV_CODE' ,type: 'string'},
	    		 {name: 'DEPT_CODE'				,text: 'DEPT_CODE' ,type: 'string'},
	    		 {name: 'DEPT_NAME'				,text: 'DEPT_NAME' ,type: 'string'}
				 
		]
	});
	
	Unilite.defineModel('Agj230ukrModel2', {
	    fields: [{name: 'EX_SEQ'					,text: '순번' 		,type: 'int'},	    		  
				 {name: 'SLIP_DIVI_NM'				,text: '구분' 		,type: 'string'},	    		  
				 {name: 'ACCNT'						,text: '계정코드' 		,type: 'string'},	    		  
				 {name: 'ACCNT_NAME'				,text: '계정과목명' 		,type: 'string'},	    		  
				 {name: 'CUSTOM_CODE'				,text: '거래처' 		,type: 'string'},	    		  
				 {name: 'CUSTOM_NAME'				,text: '거래처명' 		,type: 'string'},
				 {name: 'COMPANY_NUM'				,text: '사업자등록번호'	,type: 'string'},
				 {name: 'AMT_I'						,text: '금액' 		,type: 'uniPrice'},	    		  
				 {name: 'MONEY_UNIT'				,text: '화폐' 		,type: 'string'},	    		  
				 {name: 'EXCHG_RATE_O'				,text: '환율' 		,type: 'uniER'},	    		  
				 {name: 'FOR_AMT_I'					,text: '외화금액' 		,type: 'uniFC'},	    		  
				 {name: 'REMARK'					,text: '적요' 		,type: 'string'},	    		  
				 {name: 'DEPT_NAME'					,text: '귀속부서' 		,type: 'string'},	    		  
				 {name: 'DIV_NAME'					,text: '귀속사업장' 		,type: 'string'},	    		  
				 {name: 'PROOF_KIND_NM'				,text: '증빙유형' 		,type: 'string'},	    
				 {name: 'CREDIT_NUM'                , text: '카드번호/현금영수증(DB)'  ,type: 'string'},
                 {name: 'CREDIT_NUM_EXPOS'          , text: '카드번호/현금영수증'  ,type: 'string', defaultValue:'***************'},
				 {name: 'CREDIT_NUM_MASK'          , text: '카드번호/현금영수증'  ,type: 'string', defaultValue:'***************'},
				 
				 {name: 'REASON_CODE'				,text: '불공제사유' 		,type: 'string'},
				 {name: 'POSTIT_YN'					,text: '각주여부' 		,type: 'string'},				 
				 
				 {name: 'AC_CODE1'    				,text:'관리항목코드1'		,type : 'string'} 
				,{name: 'AC_CODE2'    				,text:'관리항목코드2'		,type : 'string'} 
				,{name: 'AC_CODE3'    				,text:'관리항목코드3'		,type : 'string'} 
				,{name: 'AC_CODE4'    				,text:'관리항목코드4'		,type : 'string'} 
				,{name: 'AC_CODE5'    				,text:'관리항목코드5'		,type : 'string'} 
				,{name: 'AC_CODE6'    				,text:'관리항목코드6'		,type : 'string'}
				
				,{name: 'AC_NAME1'    				,text:'관리항목명1'			,type : 'string'} 
				,{name: 'AC_NAME2'    				,text:'관리항목명2'			,type : 'string'} 
				,{name: 'AC_NAME3'    				,text:'관리항목명3'			,type : 'string'} 
				,{name: 'AC_NAME4'    				,text:'관리항목명4'			,type : 'string'} 
				,{name: 'AC_NAME5'    				,text:'관리항목명5'			,type : 'string'} 
				,{name: 'AC_NAME6'    				,text:'관리항목명6'			,type : 'string'}
				
				,{name: 'AC_DATA1'    				,text:'관리항목데이터1'		,type : 'string'} 
				,{name: 'AC_DATA2'    				,text:'관리항목데이터2'		,type : 'string'} 
				,{name: 'AC_DATA3'    				,text:'관리항목데이터3'		,type : 'string'} 
				,{name: 'AC_DATA4'    				,text:'관리항목데이터4'		,type : 'string'} 
				,{name: 'AC_DATA5'    				,text:'관리항목데이터5'		,type : 'string'} 
				,{name: 'AC_DATA6'    				,text:'관리항목데이터6'		,type : 'string'}
				
				,{name: 'AC_DATA_NAME1'    			,text:'관리항목데이터명1'	,type : 'string'} 
				,{name: 'AC_DATA_NAME2'    			,text:'관리항목데이터명2'	,type : 'string'} 
				,{name: 'AC_DATA_NAME3'    			,text:'관리항목데이터명3'	,type : 'string'} 
				,{name: 'AC_DATA_NAME4'    			,text:'관리항목데이터명4'	,type : 'string'} 
				,{name: 'AC_DATA_NAME5'    			,text:'관리항목데이터명5'	,type : 'string'} 
				,{name: 'AC_DATA_NAME6'    			,text:'관리항목데이터명6'	,type : 'string'}
				,{name: 'AC_CTL1'   				,text:'관리항목필수1'		,type : 'string'} 
				,{name: 'AC_CTL2'   				,text:'관리항목필수2'		,type : 'string'} 
				,{name: 'AC_CTL3'   				,text:'관리항목필수3'		,type : 'string'} 
				,{name: 'AC_CTL4'   				,text:'관리항목필수4'		,type : 'string'} 
				,{name: 'AC_CTL5'    				,text:'관리항목필수5'		,type : 'string'} 
				,{name: 'AC_CTL6'    				,text:'관리항목필수6'		,type : 'string'} 
				
				,{name: 'AC_TYPE1'   				,text:'관리항목1유형'		,type : 'string'} 
				,{name: 'AC_TYPE2'   				,text:'관리항목2유형'		,type : 'string'} 
				,{name: 'AC_TYPE3'   				,text:'관리항목3유형'		,type : 'string'} 
				,{name: 'AC_TYPE4'   				,text:'관리항목4유형'		,type : 'string'} 
				,{name: 'AC_TYPE5'   				,text:'관리항목5유형'		,type : 'string'} 
				,{name: 'AC_TYPE6'   				,text:'관리항목6유형'		,type : 'string'} 
				
				,{name: 'AC_LEN1'    				,text:'관리항목1길이'		,type : 'string'} 
				,{name: 'AC_LEN2'   				,text:'관리항목2길이'		,type : 'string'} 
				,{name: 'AC_LEN3'   				,text:'관리항목3길이'		,type : 'string'} 
				,{name: 'AC_LEN4'   				,text:'관리항목4길이'		,type : 'string'} 
				,{name: 'AC_LEN5'   				,text:'관리항목5길이'		,type : 'string'} 
				,{name: 'AC_LEN6'   				,text:'관리항목6길이'		,type : 'string'} 
				
				,{name: 'AC_POPUP1' 				,text:'관리항목1팝업여부'	,type : 'string'} 
				,{name: 'AC_POPUP2'   				,text:'관리항목2팝업여부'	,type : 'string'} 
				,{name: 'AC_POPUP3'   				,text:'관리항목3팝업여부'	,type : 'string'} 
				,{name: 'AC_POPUP4'   				,text:'관리항목4팝업여부'	,type : 'string'} 
				,{name: 'AC_POPUP5'   				,text:'관리항목5팝업여부'	,type : 'string'} 
				,{name: 'AC_POPUP6'   				,text:'관리항목6팝업여부'	,type : 'string'} 
				
				,{name: 'AC_FORMAT1'  				,text:'관리항목1포멧'		,type : 'string'} 
				,{name: 'AC_FORMAT2'   				,text:'관리항목2포멧'		,type : 'string'} 
				,{name: 'AC_FORMAT3'   				,text:'관리항목3포멧'		,type : 'string'} 
				,{name: 'AC_FORMAT4'   				,text:'관리항목4포멧'		,type : 'string'} 
				,{name: 'AC_FORMAT5'   				,text:'관리항목5포멧'		,type : 'string'} 
				,{name: 'AC_FORMAT6'   				,text:'관리항목6포멧'		,type : 'string'} 
		]
	});	

	/* Store 정의(Service 정의)
	 * @type 
	 */				
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read : 'agj230ukrService.selectList'
		 ,update : 'agj230ukrService.update'
		// ,create : 'agj230ukrService.insert'
		// ,destroy:'agj230ukrService.delete'
		 ,syncAll:'agj230ukrService.saveAll'
		}
	});
	var masterStore = Unilite.createStore('agj230ukrMasterStore',{
			model: 'Agj230ukrModel1',
			uniOpt : {
            	isMaster: 	true,			// 상위 버튼 연결 
            	editable: 	true,			// 수정 모드 사용 
            	deletable:	false,			// 삭제 가능 여부 
	            useNavi : 	false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy,
            loadStoreRecords : function()	{
				var form = Ext.getCmp('searchForm');
				var param= form.getValues();			
				console.log( param );
				if(form.isValid())	{
					detailForm.down('#formFieldArea1').removeAll();
					masterGrid2.reset();
					this.load({
						params : param
					});
				}
			},
			saveStore:function()	{
				var me = this
				var updateRecords = me.getModifiedRecords();
				Ext.each(updateRecords, function(item, idx){
					if(item.get('AP_STS') == '1' && Ext.isEmpty(item.get('AC_DATE')))	{
						alert(Msg.sMA0041);
						return;
					}
					if(baseInfo.gsAutoSLipNum == '2' &&  Ext.isEmpty(item.get('SLIP_NUM')))	{
						alert(Msg.sMA0042);
						return;
					}
				})
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				
				var config = {
					params:[Ext.getCmp('searchForm').getValues()],
					delayMaskTime : 2000,
					success:function()	{
						if(baseInfo.gsAutoReQuery == "Y") 	{
							masterStore.loadStoreRecords();
						}
						try {
							parent.getAlertCount();
						}catch(e){
							console.log("getAlertCount : ", e);
						}
					}
				}
				if(inValidRecs.length == 0 )	{
					
					this.syncAllDirect(config);
				}else {
					alert(Msg.sMB083);
				}
			},
			listeners:{
				load:function( store, records, successful, operation, eOpts ){
					panelSearch.setValue("DR_AMT_I", 0);
					panelSearch.setValue("CR_AMT_I", 0);
						
					panelResult.setValue("DR_AMT_I", 0);
					panelResult.setValue("CR_AMT_I", 0);
					if(records)	{
						panelResult.setValue("EX_NUM_FR", '');
						panelResult.setValue("EX_NUM_TO", '');
						
						panelSearch.setValue("EX_NUM_FR", '');
						panelSearch.setValue("EX_NUM_TO", '');
					}
					//조회된 데이터가 있을 때, 합계 보이게 설정 변경
					var viewNormal = masterGrid.getView();
					if(store.getCount() > 0){
			    		viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
					}else{
			    		viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);	
					}
				},
				update:function(store, record, operation, modifiedFieldNames, details, eOpts )	{
					if(!masterGrid.checkInloading && operation != "commit")	{
						if(modifiedFieldNames && UniUtils.indexOf("CHK",modifiedFieldNames))	{
							store.updateAmtSum(record);
						}
					}
				}
			},
			updateAmtSum:function(record)	{
				var store = this;
				var cr_sum = 0, dr_sum = 0;
				var updateRecords = store.getModifiedRecords();
				
				var scDate = panelSearch.getValue('DETAIL_AC_DATE');
				
				Ext.each(updateRecords, function(item, idx){
					if(item.get('CHK'))	{
						cr_sum += item.get("CR_AMT_I");
						dr_sum += item.get("DR_AMT_I");
					}
				})
				if(!Ext.isEmpty(record))	{
					store.getAcDate(record)
				}else {
					store.suspendEvents();
					Ext.each(updateRecords, function(item, idx){
						store.getAcDate(item);
					})
					store.resumeEvents();
				}
				panelSearch.setValue("DR_AMT_I", dr_sum);
				panelSearch.setValue("CR_AMT_I", cr_sum);
				
				panelResult.setValue("DR_AMT_I", dr_sum);
				panelResult.setValue("CR_AMT_I", cr_sum);
			},
			getAcDate:function(record)	{
				var scDate = panelSearch.getValue('DETAIL_AC_DATE');
				var rdoDate =panelSearch.getValues()['rdoSelect'];//panelSearch.getValue('rdoDate').rdoSelect;
				if(record.get('AP_STS') != '2')	{
					if(record.get('CHK'))	{
						if(rdoDate == '0')	{			// 회계일자 결의일							
							record.set('AC_DATE', record.get('EX_DATE'));
						} else {
							record.set('AC_DATE',scDate);
						}
					}else {
						record.set('AC_DATE','');
					}
				}
			}
	});
	
	var masterStore2 = Unilite.createStore('agj230ukrMasterStore1',{
			model: 'Agj230ukrModel2',
			uniOpt : {
            	isMaster: 	false,			// 상위 버튼 연결 
            	editable: 	false,			// 수정 모드 사용 
            	deletable:	false,			// 삭제 가능 여부 
	            useNavi : 	false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'agj230ukrService.selectExList'                	
                }
            },
            loadStoreRecords : function(param)	{
				if(param)	{
					console.log( param );
					this.load({
						params : param
					});
				}
			},
			listeners:{
				beforeload:function(store, operation, eOpts)	{
					if (masterGrid.getSelectedRecords() == 0)	{
						return false;
					}
				},
				load: function(store, records, successful, eOpts) {
					if(!Ext.isEmpty(masterGrid2.getSelectionModel())) {
						masterGrid2.getSelectionModel().select(0);	
					}
					masterGrid.focus();
	          	}
			}
			
	});	
	
	/* 검색조건 (Search Panel)
	 * @type 
	 */
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
		    items : [{ 
    			fieldLabel: '결의일',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'EX_DATE_FR',
		        endFieldName: 'EX_DATE_TO',
				allowBlank: false,
		        width: 470,
		        startDate: UniDate.get('today'),
		        endDate: UniDate.get('today'),
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('EX_DATE_FR',newValue);
	                	}
				    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('EX_DATE_TO',newValue);
			    	}
			    }
	        }, { 
    			fieldLabel: '입력일',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'INPUT_DATE_FR',
		        endFieldName: 'INPUT_DATE_TO',
		        width: 470,
		        startDate: UniDate.get(''),
		        endDate: UniDate.get(''),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('INPUT_DATE_FR',newValue);
	                	}
				    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('INPUT_DATE_TO',newValue);
			    	}
			    }

	        },{
				fieldLabel: '사업장',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
//				allowBlank:false,
				multiSelect: true, 
				typeAhead: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},   
		        Unilite.popup('DEPT',{
		        fieldLabel: '입력부서',
		        validateBlank:true,
		        autoPopup:true,
		    	valueFieldName:'IN_DEPT_CODE',
		    	textFieldName:'IN_DEPT_NAME',
	        	listeners: {
					applyextparam: function(popup){							
						popup.setExtParam({'ACCNT_DIV_CODE': panelSearch.getValue('DIV_CODE')});
					},
					onValueFieldChange:function( elm, newValue) {
						panelResult.setValue('IN_DEPT_CODE', newValue);
                	},
                	onTextFieldChange:function( elm, newValue) {
						panelResult.setValue('IN_DEPT_NAME', newValue);
                	}
				}
		    }), 	
		    	Unilite.popup('ACCNT_PRSN',{
			  	valueFieldName:'CHARGE_CODE',
			    textFieldName:'CHARGE_NAME',
		    	fieldLabel: '입력자',
		    	autoPopup:true,
		    	readOnly : baseInfo.gsChargeDivi,
		    	validateBlank:true,
	        	listeners: {
					onValueFieldChange:function( elm, newValue) {
						panelResult.setValue('CHARGE_CODE', newValue);
                	},
                	onTextFieldChange:function( elm, newValue) {
						panelResult.setValue('CHARGE_NAME', newValue);
                	}
				}		
		    }), {
    			fieldLabel: '입력경로'	,
    			name:'INPUT_PATH', 
    			xtype: 'uniCombobox', 
    			comboType:'AU',
    			comboCode:'A011',
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelResult.setValue('INPUT_PATH', newValue);
					}
				}
    		}, {
				fieldLabel: '승인여부',
				xtype: 'uniCombobox',
				name: 'AP_STS',
				comboType: 'AU',
				comboCode:'A014',
				value:baseInfo.gsDefaultApsts,
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelResult.setValue('AP_STS', newValue);
					}
				}
			},
	        	Unilite.popup('CUST',{
		        fieldLabel: '거래처',
		        allowBlank:true,
				autoPopup:false,
				validateBlank:false,
			    valueFieldName:'CUSTOM_CODE',
			    textFieldName:'CUSTOM_NAME',
	        	listeners: {
					onValueFieldChange:function( elm, newValue, oldValue) {
						panelResult.setValue('CUSTOM_CODE', newValue);
						
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('CUSTOM_NAME', '');
							panelSearch.setValue('CUSTOM_NAME', '');
						}
                	},
                	onTextFieldChange:function( elm, newValue, oldValue) {
						panelResult.setValue('CUSTOM_NAME', newValue);
						
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('CUSTOM_CODE', '');
							panelSearch.setValue('CUSTOM_CODE', '');
						}
                	},
					applyextparam: function(popup){							
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}		        
		    }),{
	    		layout: {type: 'hbox', align:'stretch'},		            		
	    		xtype: 'container',
	    		id: 'AP_DATE',
	    		width:325,
	    		items: [{
	    			flex: 0.7,
	    			xtype: 'radiogroup',
	    			name : 'rdoDate',
	    			fieldLabel: '회계전표일',
	    			items: [{
	    				boxLabel: '결의일' , width: 60, name: 'rdoSelect', inputValue: '0', checked: true
	    			}, {
	    				boxLabel: '회계일' , width: 70, name: 'rdoSelect', inputValue: '1'
	    			}],
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.getField('rdoSelect').setValue(newValue.rdoSelect);
							if(newValue.rdoSelect == "1")	{
								panelSearch.getField('DETAIL_AC_DATE').setReadOnly(false);
								panelResult.getField('DETAIL_AC_DATE').setReadOnly(false);
							}else {
								panelSearch.getField('DETAIL_AC_DATE').setReadOnly(true);
								panelResult.getField('DETAIL_AC_DATE').setReadOnly(true);
							}
						}
					}
	    		}, {
	    			flex: 0.3,
					hideLable:true,
					name: 'DETAIL_AC_DATE',
					xtype: 'uniDatefield',
					value: UniDate.get('today'),
					readOnly:true,
					listeners: {
					change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DETAIL_AC_DATE',newValue);
						}
					}
				}]
	        },{
		 	 	xtype: 'container',
	   			defaultType: 'uniNumberfield',
				layout: {type: 'hbox', align:'stretch'},
				width:325,
				margin:0,
				items:[{
					fieldLabel:'결의번호', 
					name: 'EX_NUM_FR', 
					width:194,
					listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('EX_NUM_FR', newValue);
						}
					}
				},{
					xtype:'component',
					width:10,
					html:'<div style="line-height:19px;font-size:11px;text-align:center;color:#333;">~</div>'
				}, {
					name: 'EX_NUM_TO', width:110,
					listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('EX_NUM_TO', newValue);
						}
					}
				}] 
			}, {
				xtype: 'uniNumberfield',
				fieldLabel: '차변합계',
				editable: false,
				name: 'CR_AMT_I',
				value: '0',
				readOnly: 'true'
			}, {
				xtype: 'uniNumberfield',
				fieldLabel: '대변합계',
				editable: false,
				name: 'DR_AMT_I',
				value: '0',
				readOnly: 'true'
			}]
		}, {	
			title: '추가정보', 	
   			itemId: 'search_panel2',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [
			    { 
	    			fieldLabel: '회계일',
			        xtype: 'uniDateRangefield',
			        startFieldName: 'AC_DATE_FR',
			        endFieldName: 'AC_DATE_TO',
			        width: 470,
			        startDate: UniDate.get(''),
			        endDate: UniDate.get('')
		        },{
			 	 	xtype: 'container',
		   			defaultType: 'uniNumberfield',
					layout: {type: 'hbox', align:'stretch'},
					width:325,
					margin:0,
					items:[{
						fieldLabel:'회계번호', name: 'SLIP_NUM_FR', width:194
					},{
						xtype:'component',
						width:10,
						html:'<div style="line-height:19px;font-size:11px;text-align:center;color:#333;">~</div>'
					}, {
						name: 'SLIP_NUM_TO', width:110
					}] 
				},
			    	Unilite.popup('ACCNT_PRSN',{
			    	fieldLabel: '승인자',
			    	valueFieldName:'AP_CHARGE_CODE',
			    	textFieldName:'AP_CHARGE_NAME',
			    	validateBlank:false 
			    }),{
			 	 	xtype: 'container',
		   			defaultType: 'uniNumberfield',
					layout: {type: 'hbox', align:'stretch'},
					width:325,
					margin:0,
					items:[{
						fieldLabel:'금액', 
						name: 'AMT_I_FR', 
						width:194
					},{
						xtype:'component',
						width:10,
						html:'<div style="line-height:19px;font-size:11px;text-align:center;color:#333;">~</div>'
					}, {
						name: 'AMT_I_TO', 
						width:110,
						listeners: {
							specialkey: function(elm, e){
								lastFieldSpacialKey(elm, e)
							}
						}
					}] 
				},
                Unilite.popup('Employee',{
                    fieldLabel: '사번', 
                    valueFieldWidth: 90,
                    textFieldWidth: 140,
                    valueFieldName:'PERSON_NUMB',
                    textFieldName:'NAME',
                    autoPopup:true
                }),
                Unilite.popup('DEPT',{ 
                    fieldLabel: '귀속부서',
                    valueFieldName: 'DEPT_CODE',
                    textFieldName: 'DEPT_NAME',
                    autoPopup:true
                })
		    ]		
		}]
	});
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {		
		region: 'north',
		layout : {type : 'uniTable', columns : 3
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '결의일',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'EX_DATE_FR',
	        endFieldName: 'EX_DATE_TO',
			allowBlank: false,
	        //width: 470,
	        startDate: UniDate.get('today'),
	        endDate: UniDate.get('today'),
	        tdAttrs: {width: 380},  
	        onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('EX_DATE_FR',newValue);
                	}
			    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('EX_DATE_TO',newValue);
		    	}
		    }
		},   
        	Unilite.popup('DEPT',{
	        fieldLabel: '입력부서',
	        validateBlank:true,
	        autoPopup:true,
		    valueFieldName:'IN_DEPT_CODE',
		    textFieldName:'IN_DEPT_NAME',
	        tdAttrs: {width: 380},  
        	listeners: {
				applyextparam: function(popup){							
					popup.setExtParam({'ACCNT_DIV_CODE': panelResult.getValue('DIV_CODE')});
				},
				onValueFieldChange:function( elm, newValue) {
					panelSearch.setValue('IN_DEPT_CODE', newValue);
				},
				onTextFieldChange:function( elm, newValue) {
					panelSearch.setValue('IN_DEPT_NAME', newValue);
				}
			}
	    }),{
			fieldLabel: '사업장',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
//			allowBlank:false,
			multiSelect: true, 
			typeAhead: false,
			value: UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		}, { 
			fieldLabel: '입력일',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'INPUT_DATE_FR',
	        endFieldName: 'INPUT_DATE_TO',
	        //width: 470,
	        startDate: UniDate.get(''),
	        endDate: UniDate.get(''),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('INPUT_DATE_FR',newValue);
                	}
			    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('INPUT_DATE_TO',newValue);
		    	}
		    }
		}, 		
	       	//입력자 팝업 없음, 임시로 품목 팝업
	    	Unilite.popup('ACCNT_PRSN',{
		    	fieldLabel: '입력자',
		    	valueFieldName:'CHARGE_CODE',
		    	textFieldName:'CHARGE_NAME',
		    	readOnly : baseInfo.gsChargeDivi,
    			validateBlank:true,
    			autoPopup:true,
	        	listeners: {
					onValueFieldChange:function( elm, newValue) {
						panelSearch.setValue('CHARGE_CODE', newValue);
                	},
                	onTextFieldChange:function( elm, newValue) {
						panelSearch.setValue('CHARGE_NAME', newValue);
                	}
				}		
	    }), {
			fieldLabel: '승인여부',
			xtype: 'uniCombobox',
			name: 'AP_STS',
			comboType: 'AU',
			comboCode:'A014',
			value:baseInfo.gsDefaultApsts,
			listeners: {
			change: function(field, newValue, oldValue, eOpts) {						
				panelSearch.setValue('AP_STS', newValue);
				}
			}
		}, {
			fieldLabel: '입력경로'	,
			name:'INPUT_PATH', 
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'A011',
			width: 313,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('INPUT_PATH', newValue);
				}
			}
		},
        	Unilite.popup('CUST',{
	        fieldLabel: '거래처',
	        allowBlank:true,
			autoPopup:false,
			validateBlank:false,
		    valueFieldName:'CUSTOM_CODE',
		    textFieldName:'CUSTOM_NAME',
        	listeners: {
				applyextparam: function(popup){							
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				},
				onValueFieldChange:function( elm, newValue, oldValue) {
					panelSearch.setValue('CUSTOM_CODE', newValue);
					
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('CUSTOM_NAME', '');
						panelSearch.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange:function( elm, newValue, oldValue) {
					panelSearch.setValue('CUSTOM_NAME', newValue);
					
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('CUSTOM_CODE', '');
						panelSearch.setValue('CUSTOM_CODE', '');
					}
				}
			}		        
	    }),{
    		layout: {type: 'hbox', align:'stretch'},		            		
    		xtype: 'container',
    		id: 'AP_DATE1',
    		width:325,
    		items: [{
    			flex: 0.7,
    			xtype: 'radiogroup',
    			fieldLabel: '회계전표일',
    			name : 'rdoDate',
    			items: [{
    				boxLabel: '결의일' , width: 60, name: 'rdoSelect', inputValue: '0', checked: true
    			}, {
    				boxLabel: '회계일' , width: 70, name: 'rdoSelect', inputValue: '1'
    			}],
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.getField('rdoSelect').setValue(newValue.rdoSelect);
							
							if(newValue.rdoSelect == "1")	{
								panelSearch.getField('DETAIL_AC_DATE').setReadOnly(false);
								panelResult.getField('DETAIL_AC_DATE').setReadOnly(false);
							}else {
								panelSearch.getField('DETAIL_AC_DATE').setReadOnly(true);
								panelResult.getField('DETAIL_AC_DATE').setReadOnly(true);
							}
							
						}
					}
    		}, {
    			flex: 0.3,
				fieldLabel: '',
				name: 'DETAIL_AC_DATE',
				xtype: 'uniDatefield',
				value: UniDate.get('today'),
				readOnly:true,
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DETAIL_AC_DATE',newValue);
					}
				}
			}]
        },{
	 	 	xtype: 'container',
   			defaultType: 'uniNumberfield',
			layout: {type: 'hbox', align:'stretch'},
			width:325,
			margin:0,
			items:[{
				fieldLabel:'결의번호',  name: 'EX_NUM_FR', width:194,
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('EX_NUM_FR', newValue);
					}
				}
			},{
				xtype:'component',
				width:10,
				html:'<div style="line-height:19px;font-size:11px;text-align:center;color:#333;">~</div>'
			}, {
				name: 'EX_NUM_TO', 
				width:110,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('EX_NUM_TO', newValue);
					},
					specialkey: function(elm, e){
						lastFieldSpacialKey(elm, e)
					}
				}
			}]
		}, {
			xtype: 'uniNumberfield',
			fieldLabel: '차변합계',
			editable: false,
			name: 'CR_AMT_I',
			value: '0',
			readOnly: 'true'
		}, {
			xtype: 'uniNumberfield',
			fieldLabel: '대변합계',
			editable: false,
			name: 'DR_AMT_I',
			value: '0',
			readOnly: 'true'
		}]
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
						UniAppManager.app.onQueryButtonDown();

				}
			}
		
	}
   
	/* Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('agj230ukrGrid1', {
    	// for tab    	
        layout : 'fit',
        region:'center',
        flex: 3,
        minHeight :100,
    	store: masterStore,
    	checkInloading : false, // 전체승인 체크 표시 중 
    	uniOpt:{						
			useMultipleSorting	: true,			
		    useLiveSearch		: false,			
		    onLoadSelectFirst	: true,				
		    dblClickToEdit		: false,			
		    useGroupSummary		: false,			
			useContextMenu		: false,		
			useRowNumberer		: true,		
			expandLastColumn	: true,			
			useRowContext		: false,		
		    filter: {					
				useFilter		: false,	
				autoCreate		: false	
			}/*,
                    selectAll:{
                    	useCheckIcon:true,
                    	useCustomHandler:false
                    }*/
        },
       /* selModel : Ext.create("Ext.selection.CheckboxModel", { 
        	checkOnly : true,
        	showHeaderCheckbox :true,
        	onHeaderClick: function (headerCt, header, e) {
		        if (header.isCheckerHd) {
		            e.stopEvent();
		            var isChecked = header.el.hasCls(Ext.baseCSSPrefix + 'grid-hd-checker-on');
		            masterStore.rejectChanges( );
	        		Ext.getBody().mask();
	        		masterStore.suspendEvents();
	        		masterGrid.suspendEvents();
		            if (isChecked) {                
		                this.deselectAll(true);
		                Ext.each(masterStore.data.items, function(item, idx){
		        			if(item.get('AP_STS') == '2')	{
		        				item.set('CHK', true);
		        			}else {
		        				item.set('CHK', false);
		        			}
		        		})
		            } else {                
		                this.selectAll(true);
		                Ext.each(masterStore.data.items, function(item, idx){
		        			if(item.get('AP_STS') == '1')	{
		        				item.set('CHK', true);
		        			}else {
		        				item.set('CHK', false);
		        			}
		        		})
		                console.log('all checked');
		            }
		            masterStore.updateAmtSum();
	        		masterStore.resumeEvents();
	        		masterGrid.resumeEvents();
	        		masterGrid.getView().refresh();
	        		Ext.getBody().unmask()
		        }
		    }
        
        }), */
        tbar: [{
        	text:'전체승인',
        	handler: function() {
        		if(masterGrid.checkInloading)	{
        			alert('이전 작업을 처리하고 있습니다.')
        			return;	
        		}
        		
        		masterStore.rejectChanges( );
        		masterGrid.checkInloading = true; 
        		Ext.getBody().mask();
        		masterStore.suspendEvents();
        		Ext.each(masterStore.data.items, function(item, idx){
        			if(item.get('AP_STS') == '1')	{
        				item.set('CHK', true);
        			}else {
        				item.set('CHK', false);
        			}
        			
        		})
        		masterStore.updateAmtSum();
        		masterStore.resumeEvents();
        		masterGrid.getView().refresh();
        		Ext.getBody().unmask();
        		if(masterStore.isDirty())	{
        			UniAppManager.setToolbarButtons('save',true);
        		}else {
        			UniAppManager.setToolbarButtons('save',false);
        		}
        		masterGrid.checkInloading = false;
        	}
        },{
        	text:'전체취소',
        	handler: function() {
        		if(masterGrid.checkInloading)	{
        			alert('이전 작업을 처리하고 있습니다.')
        			return;	
        		}
        		masterStore.rejectChanges( );
        		masterGrid.checkInloading = true; 
        		Ext.getBody().mask();
        		masterStore.suspendEvents();
        		
        		Ext.each(masterStore.data.items, function(item, idx){
        			if(item.get('AP_STS') == '2')	{
        				item.set('CHK', true);
        			}else {
        				item.set('CHK', false);
        			}
        		})
        		
        		masterStore.updateAmtSum();
        		masterStore.resumeEvents();
        		masterGrid.getView().refresh();
				masterGrid.checkInloading = false; 
        		Ext.getBody().unmask();
        		if(masterStore.isDirty())	{
        			UniAppManager.setToolbarButtons('save',true);
        		}else {
        			UniAppManager.setToolbarButtons('save',false);
        		}
        	}
        }],
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [
        	{ dataIndex: 'CHK'	, xtype : 'checkcolumn', width: 50 , sortable:false, hidden:false,
				listeners:{
					checkchange: function( column, rowIndex, checked, eOpts )	{
						if(checked && !masterGrid.checkInloading)	{
							masterGrid.select(rowIndex);
						}
					}
				}
        	},
        	{ dataIndex: 'AP_STS'		 		, width: 66,	align:'center',
				summaryRenderer:function(value, summaryData,	dataIndex, metaData ) {
				       return Unilite.renderSummaryRow(summaryData, metaData, '합계', '합계');
		    	}
		    },
            { dataIndex: 'EX_DATE'		 		, width: 80},
		   	{ dataIndex: 'EX_NUM'		 		, width: 80, 	align: 'center' },
		   	{ dataIndex: 'AC_DATE'		 		, width: 110 },
		  	{ dataIndex: 'SLIP_NUM'		 		, width: 80, 	align: 'center'},
		   	{ dataIndex: 'DR_AMT_I'		 		, width: 120,	summaryType: 'sum' },
		   	{ dataIndex: 'CR_AMT_I'		 		, width: 120,	summaryType: 'sum' },
		   	{ dataIndex: 'REMARK'               , width:333},
		   	{ dataIndex: 'INPUT_PATH'	 		, width: 140 },
		   	{ dataIndex: 'CHARGE_NAME'	 		, width: 80 },
		   	{ dataIndex: 'INPUT_DATE'	 		, width: 80 },
		   	{ dataIndex: 'AP_CHARGE_NAME' 		, width: 80 },
		   	{ dataIndex: 'AP_DATE'		 		, width: 80 },
		   	{ dataIndex: 'INPUT_DIVI'	 		, width: 80 	, hidden: true}
		   	
//		   	{ dataIndex: 'DIV_CODE'		 		, width: 80 },
//		   	{ dataIndex: 'DEPT_CODE'		 		, width: 80 },
//		   	{ dataIndex: 'DEPT_NAME'		 		, width: 80 }
		   	
		   	
		   	/*,
		   	{ dataIndex: 'INPUT_DIVI'		 	, width: 80 }		//테스트용 컬럼,*/
/*		   	{ dataIndex: 'DIV_CODE'		 		, width: 80 ,hidden:true},
		   	{ dataIndex: 'REMARK'		 		, flex:1, minWidth:80}*/
        ] ,
        listeners:{
        	/*select:function( model , record , index , eOpts)	{
        		 record.set('CHK', true);
        	},
        	deselect:function( model , record , index , eOpts)	{
        		 record.set('CHK', false);
        	},*/
        	selectionchange:function( grid, selected, eOpts)	{
        		if(selected && selected.length == 1)	{
	        		var param = {
	        			'EX_DATE':UniDate.getDateStr(selected[selected.length-1].get('EX_DATE')),
	        			'EX_NUM':selected[selected.length-1].get('EX_NUM'),
	        			'AP_STS':selected[selected.length-1].get('AP_STS'),
	        			'INPUT_PATH':selected[selected.length-1].get('INPUT_PATH')
	        		}
	        		masterStore2.loadStoreRecords(param);
        		}
        	},
        	beforeedit:function( editor, context, eOpts )	{        		
        		if(context.field == 'CHK')	{
        			return false;
        		}
        		if(!context.record.get('CHK'))	{
        			return false;
        		}
        	},
        	edit:function()	{
        		console.log("### select end : ", new Date())
        	},
        	onGridDblClick :function( grid, record, cellIndex, colName ) {
            	var apSts       = record.data['AP_STS'];
                var inputDivi   = record.data['INPUT_DIVI'];
                var inputPath   = record.data['INPUT_PATH'];
    
        		//결의전표일때
				if(apSts == '2'){		//  승인
					if(inputDivi == '2' ){			//번호별 회계전표 화면 관련
						masterGrid.gotoAgj205ukr();
					} else if (inputDivi == '3'){	//INPUT_DIVI가 '3'일 경우 결의미결반제입력으로 이동
        				masterGrid.gotoAgj110ukr();
					} else {						//일반 회계전표 화면 관련
						masterGrid.gotoAgj200ukr();
					}
				} else {			//	미승인
					if(inputDivi == '2' ){			//번호별 결의전표 화면 관련
						masterGrid.gotoAgj105ukr();
					} else if (inputDivi == '3'){	//INPUT_DIVI가 '3'일 경우 결의미결반제입력으로 이동
        				masterGrid.gotoAgj110ukr();
					} else {						//일반 결의전표 화면 관련
						masterGrid.gotoAgj100ukr();
					}
				}
            }
        },
		gotoAgj100ukr:function()	{
    		var record = masterGrid.getSelectedRecord();
    		var param = {
    			'PGM_ID'			: 'agj230ukr',
				'AC_DATE_FR'		: record.data['EX_DATE'],
				'AC_DATE_TO'		: record.data['EX_DATE'],
				'EX_NUM'			: record.data['EX_NUM'],
				'INPUT_PATH'		: record.data['INPUT_PATH'],
				'AP_STS'			: record.data['AP_STS'],
				'CHARGE_CODE'		: record.data['CHARGE_CODE'],
				'CHARGE_NAME'		: record.data['CHARGE_NAME'],
				'DEPT_CODE'			: record.data['DEPT_CODE'],
				'DEPT_NAME'			: record.data['DEPT_NAME'],
				'DIV_CODE'			: record.data['DIV_CODE']
    		};
	  		var rec1 = {data : {prgID : 'agj100ukr', 'text':''}};							
			parent.openTab(rec1, '/accnt/agj100ukr.do', param);
    	},
		gotoAgj105ukr:function()	{
    		var record = masterGrid.getSelectedRecord();
    		var param = {
    			'PGM_ID'			: 'agj230ukr',
				'AC_DATE'		: record.data['EX_DATE'],
				'EX_NUM'			: record.data['EX_NUM'],
				'INPUT_PATH'		: record.data['INPUT_PATH'],
				'AP_STS'			: record.data['AP_STS'],
				'CHARGE_CODE'		: record.data['CHARGE_CODE']
    		};
    		
	  		var rec1 = {data : {prgID : exSlipPgmId, 'text':''}};
			parent.openTab(rec1, exSlipPgmLink, param);
//	  		var rec1 = {data : {prgID : 'agj105ukr', 'text':''}};							
//			parent.openTab(rec1, '/accnt/agj105ukr.do', param);
    	},
		gotoAgj110ukr:function()	{
    		var record = masterGrid.getSelectedRecord();
    		var param = {
    			'PGM_ID'			: 'agj230ukr',
				'AC_DATE_FR'		: record.data['AC_DATE'],
				'AC_DATE_TO'		: record.data['AC_DATE'],
				'EX_DATE_FR'		: record.data['EX_DATE'],
				'EX_DATE_TO'		: record.data['EX_DATE'],
				'INPUT_PATH'		: record.data['INPUT_PATH'],
				'SLIP_NUM'			: record.data['SLIP_NUM'],
				'EX_NUM'			: record.data['EX_NUM'],
				'AP_STS'			: record.data['AP_STS'],
				'CHARGE_CODE'		: record.data['CHARGE_CODE'],
				'CHARGE_NAME'		: record.data['CHARGE_NAME'],
				'DEPT_CODE'			: record.data['DEPT_CODE'],
				'DEPT_NAME'			: record.data['DEPT_NAME'],
				'DIV_CODE'			: record.data['DIV_CODE'],
				'SLIP_DIVI'			: record.data['DIV_CODE']
    		};
	  		var rec1 = {data : {prgID : 'agj110ukr', 'text':''}};							
			parent.openTab(rec1, '/accnt/agj110ukr.do', param);
    	},    	
		gotoAgj200ukr:function()	{
    		var record = masterGrid.getSelectedRecord();
    		
    		var param = {
    			'PGM_ID'			: 'agj230ukr',
				'AC_DATE_FR'		: record.data['AC_DATE'],
				'AC_DATE_TO'		: record.data['AC_DATE'],
				'INPUT_PATH'		: record.data['INPUT_PATH'],
				'SLIP_NUM'			: record.data['SLIP_NUM'],
				
				'CHARGE_CODE'		: record.data['CHARGE_CODE'],
				'CHARGE_NAME'		: record.data['CHARGE_NAME']
    		};
	  		var rec1 = {data : {prgID : 'agj200ukr', 'text':''}};							
			parent.openTab(rec1, '/accnt/agj200ukr.do', param);
    	},
		gotoAgj205ukr:function()	{
    		var record = masterGrid.getSelectedRecord();
    		
    		var param = {
    			'PGM_ID'			: 'agj230ukr',
				'AC_DATE'		: record.data['AC_DATE'],
				'SLIP_NUM'			: record.data['SLIP_NUM'],
				'INPUT_PATH'		: record.data['INPUT_PATH'],
				'AP_STS'			: record.data['AP_STS'],
				'CHARGE_CODE'		: record.data['CHARGE_CODE']
    		};
	  		var rec1 = {data : {prgID : 'agj205ukr', 'text':''}};							
			parent.openTab(rec1, '/accnt/agj205ukr.do', param);
    	},
    	itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
//	        	view.ownerGrid.setCellPointer(view, item);							//마우스 오른 쪽 링크 삭제(20170110)
    		}/*,
			onSelectAll:function(grid, icon)	{
				var idx = masterStore.find('CHK',true);
				if(idx > -1)	{
					Ext.each(masterStore.data.items, function(item, idx){
	        			item.set('CHK', false);
	        		})
	        		icon.setIcon(false);
					return;
				}
				Ext.each(masterStore.data.items, function(item, idx){
        			if(item.get('AP_STS') == '1')	{
        				item.set('CHK', true);
        			}else {
        				item.set('CHK', false);
        			}
        		})
			},
			onDeselectAll:function(grid, icon)	{
				var idx = masterStore.find('CHK',true);
				if(idx > -1)	{
					Ext.each(masterStore.data.items, function(item, idx){
	        			item.set('CHK', false);
	        		})
	        		icon.setIcon(false);
					return;
				}
				Ext.each(masterStore.data.items, function(item, idx){
        			if(item.get('AP_STS') == '2')	{
        				item.set('CHK', true);
        			}else {
        				item.set('CHK', false);
        				
        			}
        			
        		})
			}*/
        }
/*		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{	//마우스 오른 쪽 링크 삭제(20170110)
			var apSts		= record.data['AP_STS'];
			var inputDivi	= record.data['INPUT_DIVI'];

			if (apSts == '1'){							//구분이 "미승인"일 때,
				if (inputDivi == '2'){
		      		menu.down('#linkAgj100ukr').hide();
		      		menu.down('#linkAgj110ukr').hide();
		      		menu.down('#linkAgj200ukr').hide();
		      		menu.down('#linkAgj205ukr').hide();
		      		
					menu.down('#linkAgj105ukr').show();
				
				} else if (inputDivi == '3') {
		      		menu.down('#linkAgj100ukr').hide();
		      		menu.down('#linkAgj105ukr').hide();
		      		menu.down('#linkAgj200ukr').hide();
		      		menu.down('#linkAgj205ukr').hide();
		      		
					menu.down('#linkAgj110ukr').show();
					
				} else {
		      		menu.down('#linkAgj105ukr').hide();
		      		menu.down('#linkAgj200ukr').hide();
		      		menu.down('#linkAgj205ukr').hide();
		      		menu.down('#linkAgj110ukr').hide();
		      		
					menu.down('#linkAgj100ukr').show();
					
				}
				
			} else if (apSts != '1'){
				if (inputDivi == '2'){
		      		menu.down('#linkAgj100ukr').hide();
		      		menu.down('#linkAgj105ukr').hide();
		      		menu.down('#linkAgj110ukr').hide();
		      		menu.down('#linkAgj200ukr').hide();
		      		
					menu.down('#linkAgj205ukr').show();
	
				} else {
		      		menu.down('#linkAgj100ukr').hide();
		      		menu.down('#linkAgj105ukr').hide();
		      		menu.down('#linkAgj110ukr').hide();
		      		menu.down('#linkAgj205ukr').hide();
		      		
					menu.down('#linkAgj200ukr').show();
					
				}
			}
  		//menu.showAt(event.getXY());
  		return true;
  		},*/
/*        uniRowContextMenu:{
			items: [{
	            	text: '결의전표입력  보기',   
	            	itemId	: 'linkAgj100ukr',
	            	handler: function(menuItem, event) {
	            		var record = masterGrid.getSelectedRecord();
	            		var param = {
	            			'PGM_ID'			: 'agj230ukr',
							'AC_DATE_FR'		: record.data['AC_DATE'],
							'AC_DATE_TO'		: record.data['AC_DATE'],
							'EX_DATE_FR'		: record.data['EX_DATE'],
							'EX_DATE_TO'		: record.data['EX_DATE'],
							'INPUT_PATH'		: record.data['INPUT_PATH'],
							'SLIP_NUM'			: record.data['SLIP_NUM'],
							'EX_NUM'			: record.data['EX_NUM'],
							'SLIP_SEQ'			: '',
							'AP_STS'			: panelSearch.getValue('AP_STS'),
							'DIV_CODE'			: panelSearch.getValue('DIV_CODE')
	            		};
	            		masterGrid.gotoAgj100ukr(param);
	            	}
	        	},{
	        		text: '결의전표입력(전표번호별) 보기',   
	            	itemId	: 'linkAgj105ukr',
	            	handler: function(menuItem, event) {
	            		var record = masterGrid.getSelectedRecord();
	            		var param = {
	            			'PGM_ID'			: 'agj230ukr',
							'AC_DATE_FR'		: record.data['AC_DATE'],
							'AC_DATE_TO'		: record.data['AC_DATE'],
							'EX_DATE_FR'		: record.data['EX_DATE'],
							'EX_DATE_TO'		: record.data['EX_DATE'],
							'INPUT_PATH'		: record.data['INPUT_PATH'],
							'SLIP_NUM'			: record.data['SLIP_NUM'],
							'EX_NUM'			: record.data['EX_NUM'],
							'SLIP_SEQ'			: '',
							'AP_STS'			: panelSearch.getValue('AP_STS'),
							'DIV_CODE'			: panelSearch.getValue('DIV_CODE')
	            		};
	            		masterGrid.gotoAgj105ukr(param);
	            	}
	        	},{
	            	text: '결의미결반제입력  보기',   
	            	itemId	: 'linkAgj110ukr',
	            	handler: function(menuItem, event) {
	            		var record = masterGrid.getSelectedRecord();
	            		var param = {
	            			'PGM_ID'			: 'agj230ukr',
							'AC_DATE_FR'		: record.data['AC_DATE'],
							'AC_DATE_TO'		: record.data['AC_DATE'],
							'EX_DATE_FR'		: record.data['EX_DATE'],
							'EX_DATE_TO'		: record.data['EX_DATE'],
							'INPUT_PATH'		: record.data['INPUT_PATH'],
							'SLIP_NUM'			: record.data['SLIP_NUM'],
							'EX_NUM'			: record.data['EX_NUM'],
							'SLIP_SEQ'			: '',
							'AP_STS'			: panelSearch.getValue('AP_STS'),
							'DIV_CODE'			: panelSearch.getValue('DIV_CODE')
	            		};
	            		masterGrid.gotoAgj110ukr(param);
	            	}
	        	},{
	        		text: '회계전표입력 보기',   
	            	itemId	: 'linkAgj200ukr',
	            	handler: function(menuItem, event) {
	            		var record = masterGrid.getSelectedRecord();
	            		var param = {
	            			'PGM_ID'			: 'agj230ukr',
							'AC_DATE_FR'		: record.data['AC_DATE'],
							'AC_DATE_TO'		: record.data['AC_DATE'],
							'EX_DATE_FR'		: record.data['EX_DATE'],
							'EX_DATE_TO'		: record.data['EX_DATE'],
							'INPUT_PATH'		: record.data['INPUT_PATH'],
							'SLIP_NUM'			: record.data['SLIP_NUM'],
							'EX_NUM'			: record.data['EX_NUM'],
							'SLIP_SEQ'			: '',
							'AP_STS'			: '',
							'DIV_CODE'			: panelSearch.getValue('DIV_CODE')
	            		};
	            		masterGrid.gotoAgj200ukr(param);
	            	}
	        	},{
	        		text: '회계전표입력(전표번호별) 보기',   
	            	itemId	: 'linkAgj205ukr',
	            	handler: function(menuItem, event) {
	            		var record = masterGrid.getSelectedRecord();
	            		var param = {
	            			'PGM_ID'			: 'agj230ukr',
							'AC_DATE_FR'		: record.data['AC_DATE'],
							'AC_DATE_TO'		: record.data['AC_DATE'],
							'EX_DATE_FR'		: record.data['EX_DATE'],
							'EX_DATE_TO'		: record.data['EX_DATE'],
							'INPUT_PATH'		: record.data['INPUT_PATH'],
							'SLIP_NUM'			: record.data['SLIP_NUM'],
							'EX_NUM'			: record.data['EX_NUM'],
							'SLIP_SEQ'			: '',
							'AP_STS'			: '',
							'DIV_CODE'			: panelSearch.getValue('DIV_CODE')
	            		};
	            		masterGrid.gotoAgj205ukr(param);
	            	}
	        	}
	        ]
	    },*/
        
    );
    
    var masterGrid2 = Unilite.createGrid('agj230ukrGrid2', {
    	uniOpt:{
			useMultipleSorting	: true,			 
	    	useLiveSearch		: false,			
	    	onLoadSelectFirst	: false,		
	    	dblClickToEdit		: false,		
	    	useGroupSummary		: false,			
			useContextMenu		: false,		
			useRowNumberer		: false,			
			expandLastColumn	: false,		
			useRowContext		: false,			
            userToolbar			: false,
	    	filter: {
				useFilter	: false,		
				autoCreate	: false		
			}
		},
        selModel:'rowmodel',
        flex: 2,
        minHeight :85,
    	store: masterStore2,
        columns:  [{ dataIndex: 'EX_SEQ'		 		, width: 50,	align: 'center' },
        		   { dataIndex: 'SLIP_DIVI_NM'	 		, width: 50, 	align: 'center' },
        		   { dataIndex: 'ACCNT'			 		, width: 100 },
        		   { dataIndex: 'ACCNT_NAME'	 		, width: 140 },
/*        		   { dataIndex: 'CUSTOM_CODE'	 		, width: 66, hidden: true },*/
        		   { dataIndex: 'CUSTOM_NAME'	 		, width: 180 },
        		   { dataIndex: 'COMPANY_NUM'	 		, width: 100,	align: 'center',	hidden: gbShowCompNum },
        		   { dataIndex: 'AMT_I'			 		, width: 86 },
        		   { dataIndex: 'MONEY_UNIT'	 		, width: 53 },
        		   { dataIndex: 'EXCHG_RATE_O'	 		, width: 60 },
        		   { dataIndex: 'FOR_AMT_I'		 		, width: 80 },
        		   { dataIndex: 'REMARK'		 		, width: 333 ,
        		   	renderer:function(value, metaData, record)	{
						var r = value;
						if(record.get('POSTIT_YN') == 'Y') r ='<img src="'+CPATH+'/resources/images/PostIt.gif"/>'+value
						return r;
					}
        		   },
        		   { dataIndex: 'DEPT_NAME'		 		, width: 80 },
        		   { dataIndex: 'DIV_NAME'		 		, width: 130 },
        		   { dataIndex: 'PROOF_KIND_NM'	 		, width: 126 },
        		   { dataIndex: 'CREDIT_NUM'            , width: 140,hidden:true},
                   { dataIndex: 'CREDIT_NUM_EXPOS'      , width: 140},
        		   
        		   { dataIndex: 'REASON_CODE'	 		, flex: 1	, minWidth:100}
        ] ,
        listeners:{
        	selectionchange:function(grid, selected, eOpt)	{
        		if(selected && selected.length > 0)	{
	        		var dataMap = selected[selected.length-1].data;
		    		UniAccnt.addMadeFields(detailForm, dataMap, detailForm, '', Ext.isEmpty(selected)?null:selected[selected.length-1]);
		    		detailForm.setActiveRecord(selected[selected.length-1]);
	    		}
        	},
        	onGridDblClick:function(grid, record, cellIndex, colName) {
                if(colName =="CREDIT_NUM_EXPOS") {
                    grid.ownerGrid.openCryptCardNoPopup(record);
                }
        	}
        },
        openCryptCardNoPopup:function( record )    {
            if(record)  {
                var params = {'CRDT_FULL_NUM': record.get('CREDIT_NUM'), 'GUBUN_FLAG': '1', 'INPUT_YN': 'N'}
                Unilite.popupCipherComm('grid', record, 'CREDIT_NUM_EXPOS', 'CREDIT_NUM', params);
            }
                
        }
        
    });
    var detailForm = Unilite.createForm('agj230ukrDetailForm',  {	
        itemId: 'agj230ukrDetailForm',
		masterGrid: masterGrid2,
		minHeight :85,
		height: 85,
		disabled: false,
		border: true,
		padding: '1',
		layout : 'hbox',
		items:[{
			xtype: 'container',
			itemId: 'formFieldArea1',
			layout: {
				type: 'uniTable', 
				columns:3
			},
			defaults:{
				width:365,
				labelWidth: 130,
				readOnly: 'true',
				editable: false
			}
		}]
    });
    
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
			 	panelResult,
				masterGrid, 
				{
					region:'south',
					xtype:'container',
					minHeight :220,
					flex:0.35,
					layout:{type:'vbox', align:'stretch'},
					items:[
						masterGrid2, detailForm
					]
				}
			]	
		}		
		,panelSearch
		],
		id  : 'agj230ukrApp',
		fnInitBinding : function(param) {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			if(baseInfo.gsChargeDivi)	{
				panelSearch.setValue('CHARGE_CODE',baseInfo.gsChargeCode);
				panelSearch.setValue('CHARGE_NAME',baseInfo.gsChargeName);
				panelResult.setValue('CHARGE_CODE',baseInfo.gsChargeCode);
				panelResult.setValue('CHARGE_NAME',baseInfo.gsChargeName);
			}
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('EX_DATE_FR');
			if(param.AC_DATE)	{
				panelResult.setValue("EX_DATE_FR", param.AC_DATE);
				panelResult.setValue("EX_DATE_TO", param.AC_DATE);
				panelResult.setValue('DIV_CODE',param.DIV_CODE);
				panelResult.setValue("EX_NUM_FR", param.SLIP_NUM);
				panelResult.setValue("EX_NUM_TO", param.SLIP_NUM);
				
				
				panelSearch.setValue("EX_DATE_FR", param.AC_DATE);
				panelSearch.setValue("EX_DATE_TO", param.AC_DATE);
				panelSearch.setValue('DIV_CODE',param.DIV_CODE);
				panelSearch.setValue("EX_NUM_FR", param.SLIP_NUM);
				panelSearch.setValue("EX_NUM_TO", param.SLIP_NUM);
				this.onQueryButtonDown();
			}
			if(param.EX_DATE)	{
				panelResult.setValue("EX_DATE_FR", param.EX_DATE);
				panelResult.setValue("EX_DATE_TO", param.EX_DATE);
				panelResult.setValue('DIV_CODE',param.DIV_CODE);
				panelResult.setValue("EX_NUM_FR", param.EX_NUM);
				panelResult.setValue("EX_NUM_TO", param.EX_NUM);
				
				panelSearch.setValue("EX_DATE_FR", param.EX_DATE);
				panelSearch.setValue("EX_DATE_TO", param.EX_DATE);
				panelSearch.setValue('DIV_CODE',param.DIV_CODE);
				panelSearch.setValue("EX_NUM_FR", param.EX_NUM);
				panelSearch.setValue("EX_NUM_TO", param.EX_NUM);
				this.onQueryButtonDown();
			}
		},
		onQueryButtonDown : function()	{			
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.reset();
			masterGrid2.reset();
			detailForm.clearForm();			
			var viewNormal = masterGrid.getView();
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);

			masterGrid.getStore().loadStoreRecords();	
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},	
		onSaveDataButtonDown: function (config) {
			
			masterStore.saveStore(config);
			
		}
		
	});
	Unilite.createValidator('validator01', {
		forms: {'formA:':panelSearch,
				'formB:':panelResult},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			switch(fieldName) {	
				case "rdoSelect":
				
				
					break;
			}
			return rv;
		}
	});

};


</script>
