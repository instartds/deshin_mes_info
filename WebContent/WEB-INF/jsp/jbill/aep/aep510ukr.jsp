<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep510ukr"  >



<t:ExtComboStore comboType="AU" comboCode="J627"/>	<!-- 결제은행		-->
<t:ExtComboStore comboType="AU" comboCode="J636"/>	<!-- 카드상태		-->
<t:ExtComboStore comboType="AU" comboCode="J631"/>	<!-- 카드구분코드	-->
<t:ExtComboStore comboType="AU" comboCode="J632"/>	<!-- 카드종류코드	-->
<t:ExtComboStore comboType="AU" comboCode="J637"/>	<!-- 카드사코드		-->
<t:ExtComboStore comboType="AU" comboCode="J641"/>	<!-- 회사코드		-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {
	
	var dateStore = Unilite.createStore('aep510ukrDateStore', {
	    fields: ['text', 'value'],
		data :  [{'text': '1일'	, 'value': '1'},
				 {'text': '2일'	, 'value': '2'},
				 {'text': '3일'	, 'value': '3'},
				 {'text': '4일'	, 'value': '4'},
				 {'text': '5일'	, 'value': '5'},
				 {'text': '6일'	, 'value': '6'},
				 {'text': '7일'	, 'value': '7'},
				 {'text': '8일'	, 'value': '8'},
				 {'text': '9일'	, 'value': '9'},
				 {'text': '10일'	, 'value': '10'},
				 {'text': '11일'	, 'value': '11'},
				 {'text': '12일'	, 'value': '12'},
				 {'text': '13일'	, 'value': '13'},
				 {'text': '14일'	, 'value': '14'},
				 {'text': '15일'	, 'value': '15'},
				 {'text': '16일'	, 'value': '16'},
				 {'text': '17일'	, 'value': '17'},
				 {'text': '18일'	, 'value': '18'},
				 {'text': '19일'	, 'value': '19'},
				 {'text': '20일'	, 'value': '20'},
				 {'text': '21일'	, 'value': '21'},
				 {'text': '22일'	, 'value': '22'},
				 {'text': '23일'	, 'value': '23'},
				 {'text': '24일'	, 'value': '24'},
				 {'text': '25일'	, 'value': '25'},
				 {'text': '26일'	, 'value': '26'},
				 {'text': '27일'	, 'value': '27'},
				 {'text': '28일'	, 'value': '28'},
				 {'text': '29일'	, 'value': '29'},
				 {'text': '30일'	, 'value': '30'}
		]
	});
	
   /**
    *   Model 정의 
    * @type 
    */

	Unilite.defineModel('Aep510ukrModel', {
		fields: [ 
			{name: 'CARD_NO',				text: '카드번호(DB)',		type: 'string'},
			{name: 'CARD_NO_EXPOS',			text: '카드번호',			type: 'string', defaultValue:'***************'},
			{name: 'USE_STATUS',			text: '상태',				type: 'string' ,comboType:'AU', comboCode :'J636'},
			{name: 'CARD_TYPE',				text: '구분',				type: 'string' ,comboType:'AU', comboCode :'J631'},
			{name: 'CARDCO_CD',				text: '카드사명',			type: 'string' ,comboType:'AU', comboCode :'J637'},	
			{name: 'USE_ONELMT',			text: '한도금액',			type: 'uniPrice'},
			{name: 'COMP_CODE',				text: '회사명',			type: 'string' , comboType:'AU', comboCode :'J641'},
			{name: 'CARD_AUTHOR',			text: '소유자',			type: 'string'},
			{name: 'AVAIL_TERM',			text: '유효기간',			type: 'string'},		// uniMonth 필요함
			{name: 'DEPARTMENT_NAME',		text: '부서명',			type: 'string'},
			{name: 'EMP_NM',				text: '사원명',			type: 'string'},
			{name: 'EMP_EN_NM',				text: '카드소유자영문명'	,	type: 'string'},
			{name: 'BIZ_NO',				text: '사업자번호',			type: 'string'},
			{name: 'SOC_NO',				text: '생년월일',			type: 'string'},
			{name: 'UPDATE_DB_TIME',		text: '변경일시',			type: 'uniDate'},
	//		end 그리드col		
			{name: 'POSITION_NAME',			text: '직급명',			type: 'string'},
		//	{name: 'USE_ONELMT',			text: '한도금액',			type: 'uniPrice'},
			{name: 'FIRST_DATE',			text: '발급일자',			type: 'uniDate'},
		//	{name: 'COMP_CODE',				text: '회사코드',			type: 'string' , comboType:'AU', comboCode :'J641'},
		//	{name: 'CARDCO_CD',				text: '카드사코드',			type: 'string' ,comboType:'AU', comboCode :'J637'},
			{name: 'EMP_ID',				text: '사원번호',			type: 'string'},
		//	{name: 'CARD_TYPE',				text: '카드구분코드',		type: 'string' ,comboType:'AU', comboCode :'J631'},
			{name: 'CARD_KIND',				text: '카드종류',			type: 'string' ,comboType:'AU', comboCode :'J632'},
		//	{name: 'USE_STATUS',			text: '카드상태코드',		type: 'string' ,comboType:'AU', comboCode :'J636'},
			{name: 'CANCEL_DATE',			text: '해지일자',			type: 'uniDate'},
			{name: 'EMAIL_ID',				text: '이메일',			type: 'string'},
			{name: 'SETT_BANK',				text: '결제은행코드',		type: 'string'},
			{name: 'SETT_DAY',				text: '결제일',			type: 'string', store: Ext.data.StoreManager.lookup('aep510ukrDateStore')},
			{name: 'SETT_ACCO',				text: '결제계좌(DB)',		type: 'string'},
			{name: 'SETT_ACCO_EXPOS',		text: '결제계좌',			type: 'string', defaultValue:'***************'},
			{name: 'FORE_USELMT',			text: '해외총한도금액',		type: 'uniPrice'},
			{name: 'TEMPLM_YN',				text: '일시한도적용여부',		type: 'string'},
			{name: 'LMST_DATE',				text: '한도변경시작일자',		type: 'uniDate'},
			{name: 'LMED_DATE',				text: '한도변경종료일자',		type: 'uniDate'},
			{name: 'REV_YN',				text: '수령여부',			type: 'string'},
			{name: 'REV_DATE',				text: '수령일자',			type: 'uniDate'},
			{name: 'TEMPLM_AMT',			text: '일시한도적용금액',		type: 'uniPrice'},
			{name: 'VENDOR_ID',				text: '지급처코드',			type: 'string'},
			{name: 'VENDOR_NM',				text: '지급처명칭',			type: 'string'},
			{name: 'VENDOR_SITE_CODE',		text: '사업자등록번호',		type: 'string'},
			
			{name: 'LMST_DATE',				text: '한도변경시작일자',		type: 'uniDate'},
			{name: 'LMED_DATE',				text: '한도변경종료일자',		type: 'uniDate'}
		]
	});
   
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			//create: 'aep510ukrService.insertList',				
			read: 'aep510ukrService.selectList',
			update: 'aep510ukrService.updateList',
			//destroy: 'aep510ukrService.deleteList',
			syncAll: 'aep510ukrService.saveAll'
		}
	});
	
   /**
    * Store 정의(Service 정의)
    * @type 
    */               
   var directMasterStore = Unilite.createStore('aep510ukrMasterStore1',{
         model: 'Aep510ukrModel',
         uniOpt : {
               isMaster: true,         // 상위 버튼 연결 
               editable: true,         // 수정 모드 사용 
               deletable:false,        // 삭제 가능 여부 
               useNavi : false         // prev | newxt 버튼 사용
                  //비고(*) 사용않함
            },
            autoLoad: false,
            proxy: directProxy,
    		listeners : {
    	        load : function(store) {
    	        	
    	        }
    	    },
    	    loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
			},
    	    /*loadStoreRecords : function()   {
	            var param= Ext.getCmp('searchForm').getValues();	
	            if(Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
	            	var divCodes = new Array();
		            aep510ukrService.getDivList(param, function(provider, response)	{	//사업자번호 조회
						if(!Ext.isEmpty(provider)){
							Ext.each(provider, function(record, i){
								divCodes.push(provider[i].DIV_CODE);
							});
							param.DIV_CODE = divCodes;
							directMasterStore.load({
				               params : param
				            });
						}
					});
	            }else{
	            	this.load({
		               params : param
		            });
	            }	            
	        },*/
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
							directMasterStore.loadStoreRecords();	
						 } 
					};					
					this.syncAllDirect(config);
					
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
			listeners:{
				load: function(store, records, successful, eOpts) {
					
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
        collapsed: UserInfo.appOption.collapseLeftSearch,//true,
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
		    items: [
			Unilite.popup('CREDIT_NO',{
				fieldLabel: '카드번호',
			  	valueFieldName:'CREDIT_NO_CODE',
			    textFieldName:'CREDIT_NO_NAME',
				validateBlank:false,
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('CREDIT_NO_CODE', panelSearch.getValue('CREDIT_NO_CODE'));
							panelResult.setValue('CREDIT_NO_NAME', panelSearch.getValue('CREDIT_NO_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('CREDIT_NO_CODE', '');
						panelResult.setValue('CREDIT_NO_NAME', '');
					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('CREDIT_NO_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('CREDIT_NO_NAME', newValue);				
					}
				}
			}),
			Unilite.popup('Employee',{
				fieldLabel: '카드소유자',
			  	valueFieldName:'EMP_ID',
			    textFieldName:'EMP_NM',
				validateBlank:false,
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('EMP_ID', panelSearch.getValue('EMP_ID'));
							panelResult.setValue('EMP_NM', panelSearch.getValue('EMP_NM'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('EMP_ID', '');
						panelResult.setValue('EMP_NM', '');
					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('EMP_ID', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('EMP_NM', newValue);				
					}
				}
			}),{ 
    			fieldLabel: '발급일자',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'FIRST_DATE_FR',
		        endFieldName: 'FIRST_DATE_TO',
				allowBlank: false,		        
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('FIRST_DATE_FR',newValue);
	                	}
				    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('FIRST_DATE_TO',newValue);
			    	}
			    }
	        }, {
				fieldLabel: '카드상태',
				name:'USE_STATUS', 
				xtype: 'uniCombobox',
		        comboType:'AU',
		        comboCode: 'J636',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('USE_STATUS', newValue);
					}
				}
			}, {
				fieldLabel: '카드구분',
				name:'CARD_TYPE', 
				xtype: 'uniCombobox',
		        comboType:'AU',
		        comboCode: 'J631', 
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CARD_TYPE', newValue);
					}
				}
			}, {
				fieldLabel: '카드사',
				name:'CARDCO_CD', 
				xtype: 'uniCombobox',
		        comboType:'AU',
		        comboCode: 'J637',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CARDCO_CD', newValue);
					}
				}
			}]				
		}]		
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		region: 'north',
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [
			Unilite.popup('CREDIT_NO',{
			fieldLabel: '카드번호',
		  	valueFieldName:'CREDIT_NO_CODE',
		    textFieldName:'CREDIT_NO_NAME',
			validateBlank:false,
			autoPopup:true,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('CREDIT_NO_CODE', panelResult.getValue('CREDIT_NO_CODE'));
						panelSearch.setValue('CREDIT_NO_NAME', panelResult.getValue('CREDIT_NO_NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('CREDIT_NO_CODE', '');
					panelSearch.setValue('CREDIT_NO_NAME', '');
				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('CREDIT_NO_CODE', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('CREDIT_NO_NAME', newValue);				
				}
			}
		}),
		Unilite.popup('Employee',{
			fieldLabel: '카드소유자',
		  	valueFieldName:'EMP_ID',
		    textFieldName:'EMP_NM',
			validateBlank:false,
			autoPopup:true,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('EMP_ID', panelResult.getValue('EMP_ID'));
						panelSearch.setValue('EMP_NM', panelResult.getValue('EMP_NM'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('EMP_ID', '');
					panelSearch.setValue('EMP_NM', '');
				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('EMP_ID', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('EMP_NM', newValue);				
				}
			}
		}),{ 
			fieldLabel: '발급일자',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'FIRST_DATE_FR',
	        endFieldName: 'FIRST_DATE_TO',
			allowBlank: false,	
	        onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('FIRST_DATE_FR',newValue);
                	}
			    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('FIRST_DATE_TO',newValue);
		    	}
		    }
        }, {
			fieldLabel: '카드상태',
			name:'USE_STATUS', 
			xtype: 'uniCombobox',
	        comboType:'AU',
	        comboCode: 'J636',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('USE_STATUS', newValue);
				}
			}
		}, {
			fieldLabel: '카드구분',
			name:'CARD_TYPE', 
			xtype: 'uniCombobox',
	        comboType:'AU',
	        comboCode: 'J631',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('CARD_TYPE', newValue);
				}
			}
		}, {
			fieldLabel: '카드사',
			name:'CARDCO_CD', 
			xtype: 'uniCombobox',
	        comboType:'AU',
	        comboCode: 'J637',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('CARDCO_CD', newValue);
				}
			}
		}]
	});
	
	/**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
	var masterGrid = Unilite.createGrid('aep510ukrGrid1', {
       region: 'center',
        layout: 'fit',
    	uniOpt: {
    		expandLastColumn: false,
		 	useRowNumberer: true,
		 	copiedRow: true
//		 	useContextMenu: true,
        },
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false						
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		store: directMasterStore,
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	          	if(record.get('GUBUN') == '2') {	//소계
					cls = 'x-change-cell_light';
				}
				return cls;
	        }
	    },
        columns: [
        	{dataIndex: 'CARD_NO_EXPOS',				width: 140},
        	{dataIndex: 'CARD_NO',						width: 140, hidden: true},
        	{dataIndex: 'USE_STATUS',					width: 66},
        	{dataIndex: 'CARD_TYPE',					width: 66},
        	{dataIndex: 'CARDCO_CD',					width: 120},
        	{dataIndex: 'USE_ONELMT',					width: 120},
        	{dataIndex: 'COMP_CODE',					width: 150},
        	{dataIndex: 'CARD_AUTHOR',					width: 230},
        	{dataIndex: 'AVAIL_TERM',					width: 88},
        	{dataIndex: 'DEPARTMENT_NAME',				width: 150},
        	{dataIndex: 'EMP_NM',						width: 100},
        	{dataIndex: 'EMP_EN_NM',					width: 150},
        	{dataIndex: 'BIZ_NO',						width: 110},
        	{dataIndex: 'SOC_NO',						width: 100},
        	{dataIndex: 'UPDATE_DB_TIME',				minWidth: 100, flex: 1},
        	/* hidden 그리드 필드 저장용*/
        	{dataIndex: 'EMP_ID',					width: 100, hidden: true},
        	{dataIndex: 'CANCEL_DATE',				width: 100, hidden: true},
        	{dataIndex: 'EMAIL_ID',					width: 150, hidden: true},
        	{dataIndex: 'FIRST_DATE',				width: 100, hidden: true},
        	{dataIndex: 'SETT_BANK',				width: 100, hidden: true},
        	{dataIndex: 'SETT_DAY',					width: 100, hidden: true},
        	{dataIndex: 'SETT_ACCO',				width: 100, hidden: true},
        	{dataIndex: 'FORE_USELMT',				width: 120, hidden: true},
        	{dataIndex: 'TEMPLM_YN',				width: 120, hidden: true},
        	{dataIndex: 'REV_YN',					width: 100, hidden: true},
        	{dataIndex: 'REV_DATE',					width: 100, hidden: true},
        	{dataIndex: 'TEMPLM_AMT',				width: 130, hidden: true},
        	{dataIndex: 'VENDOR_ID',				width: 100, hidden: true},
        	{dataIndex: 'VENDOR_NM',				width: 100, hidden: true},
        	{dataIndex: 'LMST_DATE',				width: 100, hidden: true},
        	{dataIndex: 'LMED_DATE',				width: 100, hidden: true}
        ],
        listeners: {
        	selectionchangerecord:function(selected)	{
          		inputForm.setActiveRecord(selected);
          	},
        	beforeedit: function(editor, e){
        		if(!e.record.phantom == true || e.record.phantom == true) { 	// 신규이던 아니던
		        		//if(UniUtils.indexOf(e.field, ['DIV_CODE', 'DEPT_NAME', 'POST_CODE'])) {
							return false;
						//}
		        	}    		
        	}, 
        	edit: function(editor, e) { 
//				
			},
            onGridDblClick:function(grid, record, cellIndex, colName, td)	{
				if(colName =="CARD_NO_EXPOS") {
                    grid.ownerGrid.openCryptCardNoPopup(record);                    
				}
			}			
    	},
		openCryptCardNoPopup:function( record )	{
			if(record)	{
				var params = {'CRDT_FULL_NUM': record.get('CARD_NO'), 'GUBUN_FLAG': '1', 'INPUT_YN': 'Y'}
				Unilite.popupCipherComm('grid', record, 'CARD_NO_EXPOS', 'CARD_NO', params);
			}
				
		}    	
    });
    
    
	var inputForm = Unilite.createSearchForm('inputForm', { //createForm
		layout : {type : 'uniTable', columns : 3},
		disabled: false,
        border:true,
        padding: '1',
        masterGrid: masterGrid,
		region: 'center',
		defaults: {labelWidth: 130},
		items: [{
			xtype: 'uniTextfield',
			fieldLabel: '카드번호',
			name: 'CARD_NO_EXPOS',
			labelWidth: 90,
			readOnly:true,
			allowBlank: false,
			listeners:{
				afterrender:function(field)	{
					field.getEl().on('dblclick', field.onDblclick);
				}
			},
			onDblclick:function(event, elm)	{
				inputForm.openCryptCardNoPopup();
			}			
		}, {
			xtype: 'uniTextfield',
			fieldLabel: '카드번호(DB)',
			name: 'CARD_NO',
			labelWidth: 90,
			readOnly:true,
			allowBlank: false,
			hidden: true
		}, {
			fieldLabel: '카드사',
			name:'CARDCO_CD', 
			xtype: 'uniCombobox',
	        comboType:'AU',
	        comboCode: 'J637',
	        labelWidth: 170,
			allowBlank: false
		},
		Unilite.popup('Employee',{
			fieldLabel: '카드소유자',
		  	valueFieldName:'EMP_ID',
		    textFieldName:'EMP_NM',
			validateBlank:false,
			autoPopup:true,
	        labelWidth: 200,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('EMP_ID', panelResult.getValue('EMP_ID'));
						panelSearch.setValue('EMP_NM', panelResult.getValue('EMP_NM'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('EMP_ID', '');
					panelSearch.setValue('EMP_NM', '');
				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('EMP_ID', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('EMP_NM', newValue);				
				}
			}
		}),{
			xtype: 'radiogroup',		            		
			fieldLabel: '카드구분',
			labelWidth: 90,
			allowBlank: false,
			items : [{
				boxLabel: '개인',
				width:50 ,
				name: 'CARD_TYPE', 
				inputValue: '1'/*,
				checked: true*/
			}, {
				boxLabel: '공통', 
				width:80 ,
				name: 'CARD_TYPE' , 
				inputValue: '2'
			}]
		}, {
			fieldLabel: '카드종류',
			name:'CARD_KIND', 
			xtype: 'uniCombobox',
	        comboType:'AU',
	        comboCode: 'J632',
	        labelWidth: 170
		},{
			xtype: 'uniTextfield',
			fieldLabel: '카드소유자영문명',
			name: 'EMP_EN_NM',
	        labelWidth: 200,
			allowBlank: false
		}, {
			fieldLabel: '카드상태',
			name:'USE_STATUS', 
			xtype: 'uniCombobox',
			labelWidth: 90,
	        comboType:'AU',
	        comboCode: 'J636'
		},{
			fieldLabel: '해지일자',  
			name: 'CANCEL_DATE',
			xtype : 'uniDatefield',
	        labelWidth: 170
		},{
			fieldLabel: 'E-Mail',
			name: 'EMAIL_ID',
			xtype: 'uniTextfield',
	        labelWidth: 200,
			allowBlank: false
		},{
			fieldLabel: '발급일자',  
			name: 'FIRST_DATE',
			xtype : 'uniDatefield',
			labelWidth: 90,
			allowBlank: false
		},{
			fieldLabel: '유효기간',  
			name: 'AVAIL_TERM',
			xtype : 'uniMonthfield',
	        labelWidth: 170
		},{
			xtype: 'container',
			layout: {type: 'uniTable', column: 2},
	        //labelWidth: 170,
			items:[{				
				labelWidth: 200,
				fieldLabel: '결제은행/결제일',
				name:'SETT_BANK', 
				xtype: 'uniCombobox',
		        comboType:'AU',
		        comboCode: 'J627',
		        width: 285
		        
			},{								
				fieldLabel: '',
				name:'SETT_DAY', 
				xtype: 'uniCombobox',
		        store: Ext.data.StoreManager.lookup('aep510ukrDateStore'),
		        width: 80	
			}]
		},{
			xtype: 'uniTextfield',
			fieldLabel: '사업자번호',
			name: 'BIZ_NO',
			labelWidth: 90
		},{
			xtype: 'uniNumberfield',
			fieldLabel: '총한도금액',
			name: 'USE_ONELMT',
			suffixTpl: '원',
	        labelWidth: 170,
			allowBlank: false
		},{
			xtype: 'uniTextfield',
			fieldLabel: '결제계좌',
			name: 'SETT_ACCO_EXPOS',
	        labelWidth: 200,
	        readOnly: true,
			allowBlank: false,
			listeners:{
				afterrender:function(field)	{
					field.getEl().on('dblclick', field.onDblclick);
				}
			},
			onDblclick:function(event, elm)	{
				inputForm.openCryptAcntNumPopup();
			}				
		},{
			xtype: 'uniTextfield',
			fieldLabel: '결제계좌',
			name: 'SETT_ACCO',
	        labelWidth: 200,
			allowBlank: false,
			hidden: true
		},{
			xtype: 'uniTextfield',
			fieldLabel: '생년월일',
			name: 'SOC_NO',
			labelWidth: 90,
			maxLength:6,
			enforceMaxLength: true
		},{
			xtype: 'uniNumberfield',
			fieldLabel: '해외총한도',
			name: 'FORE_USELMT',
			suffixTpl: '원',
	        labelWidth: 170
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 2},
			//margin: '0 0 0 95',
			items :[{
				xtype: 'radiogroup',	
				items: [{		
					xtype: 'radiogroup',		            		
					fieldLabel: '일시한도적용',
			        labelWidth: 200,	    			
					items : [{
						boxLabel: '값이 없을 때',
						width:50 ,
						name: 'TEMPLM_YN', 
						inputValue: '',
						hidden: true
					},{
						boxLabel: '고정',
						width:50 ,
						name: 'TEMPLM_YN', 
						inputValue: 'Y'/*,
						checked: true*/
					}, {
						boxLabel: '일시한도', 
						width:80 ,
						name: 'TEMPLM_YN' , 
						inputValue: 'N'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							if(newValue.TEMPLM_YN == 'Y' || newValue.TEMPLM_YN == ''){
								inputForm.setValue('LMST_DATE', '');
								inputForm.setValue('LMED_DATE', '');	
								Ext.getCmp('templmDate').setVisible(false);
								inputForm.getField('TEMPLM_AMT').setReadOnly(true);	
							}else if(newValue.TEMPLM_YN == 'N'){
								inputForm.setValue('LMST_DATE', UniDate.get('today'));
								inputForm.setValue('LMED_DATE', UniDate.get('today'));
								Ext.getCmp('templmDate').setVisible(true);
								inputForm.getField('TEMPLM_AMT').setReadOnly(false);	
								
							}
						}
					}		
				},{
					xtype: 'container',
					layout: {type : 'uniTable', columns : 2},
					//margin: '0 0 0 95',
					id:'templmDate',
					items :[{ 
			    			fieldLabel: '',
					        xtype: 'uniDateRangefield',
					        startFieldName: 'LMST_DATE',
					        endFieldName: 'LMED_DATE'       
				        }]
				}]
			}]
		},{		
			xtype: 'radiogroup',		            		
			fieldLabel: '수령여부',
			labelWidth: 90,
			allowBlank: false,
			items : [{
				boxLabel: '수령',
				width:50 ,
				name: 'REV_YN', 
				inputValue: 'Y'
			}, {
				boxLabel: '미수령', 
				width:80 ,
				name: 'REV_YN' , 
				inputValue: 'N',
				checked: true
			}]		
		},{
			fieldLabel: '수령일자',  
			name: 'REV_DATE',
			xtype : 'uniDatefield',
	        labelWidth: 170
		},{
			xtype: 'uniNumberfield',
			fieldLabel: '일시한도변경금액',
			name: 'TEMPLM_AMT',
			suffixTpl: '원',
	        labelWidth: 200,
			readOnly:true
		},{
			xtype: 'uniDatefield',
			fieldLabel: '변경일시',
			name: 'UPDATE_DB_TIME',
			labelWidth: 90,
			readOnly:true
		},
		
		Unilite.popup('CUST',{
	    	fieldLabel: '지급처',
			autoPopup   : true ,
			valueFieldName:'VENDOR_ID',
		    textFieldName:'VENDOR_NM',
		    colspan:2,
	        labelWidth: 170,
			listeners: {
				applyextparam: function(popup){
                    popup.setExtParam({'ADD_QUERY': "ISNULL(A.VENDOR_GROUP_CODE,'')!='V090'"});                           
                }
			}
	    })/*,{
			fieldLabel: '카드코드',  
			name: 'REV_DATE',
			xtype : 'uniTextfield',
			labelWidth: 90
		},{
			fieldLabel: '카드명',  
			name: 'REV_DATE',
			xtype : 'uniTextfield'
		}*/],
		loadForm: function(record)	{
			// window 오픈시 form에 Data load
			var count = masterGrid.getStore().getCount();
			if(count > 0) {
				this.reset();
				this.setActiveRecord(record[0] || null);   
				this.resetDirtyStatus();			
			}
		},
		openCryptCardNoPopup:function() {
			var record = this;
			if(this.activeRecord)	{
				
				var params = {'CRDT_FULL_NUM':this.getValue('CARD_NO'), 'GUBUN_FLAG': '1', 'INPUT_YN': 'Y'};
				Unilite.popupCipherComm('form', record, 'CARD_NO_EXPOS', 'CARD_NO', params);
			}	
		},
		openCryptAcntNumPopup:function(  )	{
			var record = this;
			if(this.activeRecord)	{
				var params = {'BANK_ACCOUNT':this.getValue('SETT_ACCO'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'Y'};
				Unilite.popupCipherComm('form', record, 'SETT_ACCO_EXPOS', 'SETT_ACCO', params);
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
					items : [ inputForm ]
				}
			]
		},
			panelSearch	
	], 
      id  : 'aep510ukrApp',
      fnInitBinding : function() {
         panelSearch.setValue('DIV_CODE',UserInfo.divCode);
         UniAppManager.setToolbarButtons('detail',true);
         UniAppManager.setToolbarButtons(['reset', 'detail'], true);
         UniAppManager.setToolbarButtons(['newData','delete'], false);
         Ext.getCmp('templmDate').setVisible(false);
		 inputForm.getField('TEMPLM_AMT').setReadOnly(true);		
		 
		 
		 panelSearch.setValue('FIRST_DATE_FR', UniDate.get('startOfMonth'));
		 panelSearch.setValue('FIRST_DATE_TO', UniDate.get('today'));
		 panelResult.setValue('FIRST_DATE_FR', UniDate.get('startOfMonth'));
		 panelResult.setValue('FIRST_DATE_TO', UniDate.get('today'));
		 
		 
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('CREDIT_NO_CODE');         
        },
		onQueryButtonDown : function()   {
        	masterGrid.getStore().loadStoreRecords();
        },
		onSaveDataButtonDown : function() {
			if (masterGrid.getStore().isDirty()) {
				if(!inputForm.getInvalidMessage()) return; 
				// 입력데이터 validation				
				masterGrid.getStore().saveStore();
			}
		},
		onResetButtonDown : function() {			
			panelSearch.clearForm();
			panelResult.clearForm();
			inputForm.clearForm();
			Ext.getCmp('templmDate').setVisible(false);
			inputForm.getField('TEMPLM_AMT').setReadOnly(true);		
			masterGrid.getStore().loadData({});
			this.fnInitBinding();
		}
   });
   
   Unilite.createValidator('validator01', {
		forms: {'formA:':inputForm},
		validate: function( type, fieldName, newValue, oldValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;	
			switch(fieldName) {	
				case "SOC_NO":
					if(masterGrid.getStore().getCount() > 0 ){   // 데이터가 있으면서 생년월일이 6자리가 안될 때 alert
						if(newValue.length != '6'){
							alert('생년월일은 6자리로 입력하세요.');
							inputForm.getField('SOC_NO').focus();
							return false;
						}
						break;
					}
					break;
			}
			return rv;
		}
	})
};


</script>