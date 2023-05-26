<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ham801ukr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="ham801ukr"/> 						<!-- 사업장 -->
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL"/> 						<!-- 신고 사업장 -->  	
	<t:ExtComboStore comboType="AU"  comboCode="H023"/> 							<!-- 퇴사사유 -->  	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {
    var dateFlag = true;
	
   /**
    *   Model 정의 
    * @type 
    */

	Unilite.defineModel('Ham801ukrModel', {
		fields: [ 
			{name: 'COMP_CODE'       	, text: '법인코드'				, type: 'string'},
			{name: 'DEPT_NAME'       	, text: '부서'				, type: 'string'},
			{name: 'DEPT_CODE'       	, text: '부서코드'				, type: 'string'},
			{name: 'DIV_CODE'           , text: '사업장'              , type: 'string' , comboType: 'BOR120', maxLength:18},
			{name: 'PERSON_NUMB'     	, text: '사번'				, type: 'string' , maxLength:10, allowBlank: false},
			{name: 'NAME'            	, text: '성명'				, type: 'string' , maxLength:40, allowBlank: false},
			{name: 'REPRE_NUM'		 	, text: '주민등록번호'			, type: 'string'},			
			{name: 'REPRE_NUM_EXPOS' 	, text: '주민등록번호'			, type: 'string', defaultValue:'*************'},			
			{name: 'BANK_CODE'		 	, text: '은행코드'				, type: 'string'},
			{name: 'BANK_NAME1'		 	, text: '은행명'				, type: 'string'},
			{name: 'BANK_ACCOUNT1'		, text: '계좌번호'				, type: 'string'},
			{name: 'BANK_ACCOUNT1_EXPOS', text: '계좌번호'				, type: 'string', defaultValue:'*************'},
			{name: 'JOIN_DATE'		 	, text: '입사일'				, type: 'uniDate'},
			{name: 'RETR_DATE'		 	, text: '퇴사일'				, type: 'uniDate'},
			{name: 'PAY_YYYYMM'      	, text: '귀속년월'				, type: 'string' , maxLength:7, allowBlank: false},
			{name: 'SUPP_TYPE'		 	, text: '지급구분'				, type: 'string' , defaultValue: '1'},			
			{name: 'SUPP_DATE'       	, text: '지급일자'				, type: 'uniDate', allowBlank: false},
			{name: 'WORK_DAY'		 	, text: '근무일수'				, type: 'uniNumber' , maxLength:18},
			{name: 'SUPP_TOTAL_I'		, text: '지급액'				, type: 'uniPrice' , maxLength:18},
			{name: 'IN_TAX_I'		 	, text: '소득세'				, type: 'uniPrice' , maxLength:18},
			{name: 'LOCAL_TAX_I'		, text: '주민세'				, type: 'uniPrice' , maxLength:18},
			{name: 'ANU_INSUR_I'       , text: '국민연금'            , type: 'uniPrice' , maxLength:18},
            {name: 'MED_INSUR_I'       , text: '건강보험'            , type: 'uniPrice' , maxLength:18},
            {name: 'HIR_INSUR_I'        , text: '고용보험'            , type: 'uniPrice' , maxLength:18},
            
				
			
			
//			{name: 'REAL_AMOUNT_I'		, text: '실지급액'				, type: 'uniPrice'},
//			{name: 'TAX_EXEMPTION_I'	, text: '비과세금액'			, type: 'uniPrice' , maxLength:18},
//			{name: 'ANU_INSUR_I'		, text: '국민연금'				, type: 'uniPrice' , maxLength:18},
//			{name: 'MED_INSUR_I'		, text: '건강보험'				, type: 'uniPrice' , maxLength:18},
//			{name: 'HIR_INSUR_I'		, text: '고용보험'				, type: 'uniPrice' , maxLength:18},
//			{name: 'BUSI_SHARE_I'		, text: '사업주사회보험금'		, type: 'uniPrice' , maxLength:18},
//			{name: 'WORKER_COMPEN_I'	, text: '산재보험금'			, type: 'uniPrice' , maxLength:18},
//			{name: 'HIRE_INSUR_TYPE'	, text: '고용보험여부'			, type: 'string'},
//			{name: 'WORK_COMPEN_YN'		, text: '산재보험대상'			, type: 'string'}		
		]
	});
   
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create: 'ham801ukrService.insertList',				
			read: 'ham801ukrService.selectList',
			update: 'ham801ukrService.updateList',
			destroy: 'ham801ukrService.deleteList',
			syncAll: 'ham801ukrService.saveAll'
		}
	});
	
   /**
    * Store 정의(Service 정의)
    * @type 
    */               
   var directMasterStore = Unilite.createStore('ham801ukrMasterStore',{
         model: 'Ham801ukrModel',
         uniOpt : {
               isMaster: true,         // 상위 버튼 연결 
               editable: true,         // 수정 모드 사용 
               deletable:true,         // 삭제 가능 여부 
               useNavi : false         // prev | newxt 버튼 사용
                  //비고(*) 사용않함
            },
            autoLoad: false,
            proxy: directProxy,
    		listeners : {
    	        load : function(store) {
    	            /*if (store.getCount() > 0) {
    	            	setGridSummary(Ext.getCmp('CHKCNT').checked);
    	            }*/
    	            /*var newValue = panelSearch.getValue('ORI_JOIN_DATE'); 
    	            checkVisibleOriJoinDate(newValue);*/
    	        }
    	    },
    	    loadStoreRecords : function()   {
	            var param= Ext.getCmp('searchForm').getValues();	
	            if(Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
	            	var divCodes = new Array();
		            ham801ukrService.getDivList(param, function(provider, response)	{	//사업자번호 조회
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
	        },
	        saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();
				
				if(inValidRecs.length == 0 )	{
					config = {
	//					params: [paramMaster],
						success: function(batch, option) {
							
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
			items: [{ 
				fieldLabel: '급여년월',
	 		    xtype: 'uniMonthRangefield',
	            startFieldName: 'PAY_YYYYMM_FR',
	            endFieldName: 'PAY_YYYYMM_TO',
	            allowBlank: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelResult.setValue('PAY_YYYYMM_FR',newValue);
						panelResult.setValue('PAY_YYYYMM_TO',newValue);
	            	}
	            	if(panelSearch) {
						panelSearch.setValue('PAY_YYYYMM_TO',newValue);
			    	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('PAY_YYYYMM_TO',newValue);
			    	}
			    }
			},
			Unilite.treePopup('DEPTTREE',{
				fieldLabel: '부서',
				valueFieldName:'DEPT',
				textFieldName:'DEPT_NAME' ,
				valuesName:'DEPTS' ,
				DBvalueFieldName:'TREE_CODE',
				DBtextFieldName:'TREE_NAME',
				selectChildren:true,
				textFieldWidth:89,
				validateBlank:true,
				width:300,
				autoPopup:true,
				useLike:true,
				listeners: {
	                'onValueFieldChange': function(field, newValue, oldValue  ){
	                    	panelResult.setValue('DEPT',newValue);
	                },
	                'onTextFieldChange':  function( field, newValue, oldValue  ){
	                    	panelResult.setValue('DEPT_NAME',newValue);
	                },
	                'onValuesChange':  function( field, records){
	                    	var tagfield = panelResult.getField('DEPTS') ;
	                    	tagfield.setStoreData(records)
	                }
				}
			}),
				Unilite.popup('Employee',{
				fieldLabel: '사원',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				validateBlank:false,
				autoPopup:true,
				listeners: {
					/*onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
							panelResult.setValue('NAME', panelSearch.getValue('NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('PERSON_NUMB', '');
						panelResult.setValue('NAME', '');
					}*/
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);				
					},
					applyextparam: function(popup){	
						popup.setExtParam({'PAY_GUBUN' : '2'});
					}
				}
			}),{ 
				fieldLabel: '지급일자',
	 		    xtype: 'uniDateRangefield',
	            startFieldName: 'SUPP_DATE_FR',
	            endFieldName: 'SUPP_DATE_TO',
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelResult.setValue('SUPP_DATE_FR',newValue);
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('SUPP_DATE_TO',newValue);
			    	}
			    }
			},{
				fieldLabel: '지급차수',
				name: 'PAY_PROV_FLAG', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H031',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_PROV_FLAG', newValue);
					}
				}
			}]}, {               
                //복호화 플래그(복호화 버튼 누를시 플래그 'Y')
                name:'DEC_FLAG', 
                xtype: 'uniTextfield',
                hidden: true
            }
		]     	
	});
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
    	items: [{ 
			fieldLabel: '급여년월',
 		    xtype: 'uniMonthRangefield',
            startFieldName: 'PAY_YYYYMM_FR',
            endFieldName: 'PAY_YYYYMM_TO',
            allowBlank: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('PAY_YYYYMM_FR',newValue);
					panelSearch.setValue('PAY_YYYYMM_TO',newValue);
            	}
            	if(panelResult) {
					panelResult.setValue('PAY_YYYYMM_TO',newValue);
		    	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('PAY_YYYYMM_TO',newValue);
		    	}
		    }
		},
		Unilite.treePopup('DEPTTREE',{
			fieldLabel: '부서',
			valueFieldName:'DEPT',
			textFieldName:'DEPT_NAME' ,
			valuesName:'DEPTS' ,
			DBvalueFieldName:'TREE_CODE',
			DBtextFieldName:'TREE_NAME',
			selectChildren:true,
			textFieldWidth:89,
			validateBlank:true,
			width:300,
			autoPopup:true,
			useLike:true,
			listeners: {
                'onValueFieldChange': function(field, newValue, oldValue  ){
                    	panelSearch.setValue('DEPT',newValue);
                },
                'onTextFieldChange':  function( field, newValue, oldValue  ){
                    	panelSearch.setValue('DEPT_NAME',newValue);
                },
                'onValuesChange':  function( field, records){
                    	var tagfield = panelSearch.getField('DEPTS') ;
                    	tagfield.setStoreData(records)
                }
			}
		}),
			Unilite.popup('Employee',{
			fieldLabel: '사원',
		  	valueFieldName:'PERSON_NUMB',
		    textFieldName:'NAME',
			validateBlank:false,
			autoPopup:true,
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PERSON_NUMB', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('NAME', newValue);				
				},
				applyextparam: function(popup){	
					popup.setExtParam({'PAY_GUBUN' : '2'});
				}
			}
		}),{ 
			fieldLabel: '지급일자',
 		    xtype: 'uniDateRangefield',
            startFieldName: 'SUPP_DATE_FR',
            endFieldName: 'SUPP_DATE_TO',
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('SUPP_DATE_FR',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('SUPP_DATE_TO',newValue);
		    	}
		    }
		},{
			fieldLabel: '지급차수',
			name: 'PAY_PROV_FLAG', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H031',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAY_PROV_FLAG', newValue);
				}
			}
		}]
    });
   
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
	var masterGrid = Unilite.createGrid('ham801ukrGrid1', {
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
        	{dataIndex: 'DEPT_NAME'      			, width: 120},  
        	{dataIndex: 'DIV_CODE'                   , width: 90 },
			{dataIndex: 'PERSON_NUMB'       	  	, width: 90,
				'editor' : Unilite.popup('Employee_G',{
					validateBlank : true,
					autoPopup:true,
	  				listeners: {
	  					'onSelected': {
							fn: function(records, type) {
								UniAppManager.app.setHumInfo(records);	
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('PERSON_NUMB','');
							grdRecord.set('NAME','');
							grdRecord.set('DEPT_CODE','');
							grdRecord.set('DEPT_NAME','');
							grdRecord.set('BANK_CODE','');
							grdRecord.set('BANK_NAME1','');
							grdRecord.set('BANK_ACCOUNT1','');		
							grdRecord.set('JOIN_DATE','');		
							grdRecord.set('RETR_DATE','');		
						},
						applyextparam: function(popup){	
							popup.setExtParam({'PAY_GUBUN' : '2'});
						}
	 				}
				})
			},
			{dataIndex: 'NAME'              	  	, width: 100,
			'editor' : Unilite.popup('Employee_G',{
					validateBlank : true,
					autoPopup:true,
	  				listeners: {
	  					'onSelected': {
							fn: function(records, type) {
								UniAppManager.app.setHumInfo(records);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('PERSON_NUMB','');
							grdRecord.set('NAME','');
							grdRecord.set('DEPT_CODE','');
							grdRecord.set('DEPT_NAME','');
							grdRecord.set('BANK_CODE','');
							grdRecord.set('BANK_NAME1','');
							grdRecord.set('BANK_ACCOUNT1','');		
							grdRecord.set('JOIN_DATE','');		
							grdRecord.set('RETR_DATE','');		
						},
						applyextparam: function(popup){	
							popup.setExtParam({'PAY_GUBUN' : '2'});
						}	
	 				}
				})
			},
			{dataIndex: 'REPRE_NUM'					, width: 133		, hidden: true},
			{dataIndex: 'REPRE_NUM_EXPOS'			, width: 133},			
			{dataIndex: 'BANK_NAME1'				, width: 110}, 
			{dataIndex: 'BANK_ACCOUNT1'				, width: 125		, hidden: true}, 
			{dataIndex: 'BANK_ACCOUNT1_EXPOS'		, width: 125}, 		
			{dataIndex: 'JOIN_DATE'					, width: 100}, 				
			{dataIndex: 'RETR_DATE'					, width: 100}, 	
			{dataIndex: 'PAY_YYYYMM'     			, width: 100, align: 'center'
//				,renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
//					if(!Ext.isEmpty(val)){
//						return  val.substring(0,4) + '.' + val.substring(4,6);
//					}            		
//                }
            },
			{dataIndex: 'SUPP_DATE'      			, width: 100}, 				
			{dataIndex: 'WORK_DAY'					, width: 80 }, 				
			{dataIndex: 'SUPP_TOTAL_I'				, width: 110 , summaryType:'sum'}, 				
			{dataIndex: 'IN_TAX_I'					, width: 110 , summaryType:'sum'}, 				
			{dataIndex: 'LOCAL_TAX_I'				, width: 110 , summaryType:'sum'},
			{dataIndex: 'ANU_INSUR_I'               , width: 110 , summaryType:'sum'},              
            {dataIndex: 'MED_INSUR_I'               , width: 110 , summaryType:'sum'},              
            {dataIndex: 'HIR_INSUR_I'               , width: 110 , summaryType:'sum'}             
            
			
			
			
//			{dataIndex: 'SUPP_TYPE'     			, width: 80}, 		
//			{dataIndex: 'REAL_AMOUNT_I'				, width: 110 , summaryType:'sum'}, 				
//			{dataIndex: 'TAX_EXEMPTION_I'			, width: 110 , summaryType:'sum'}, 				
//			{dataIndex: 'ANU_INSUR_I'				, width: 110 , summaryType:'sum'}, 				
//			{dataIndex: 'MED_INSUR_I'				, width: 110 , summaryType:'sum'}, 				
//			{dataIndex: 'HIR_INSUR_I'				, width: 110 , summaryType:'sum'}, 				
//			{dataIndex: 'BUSI_SHARE_I'				, width: 120}, 				
//			{dataIndex: 'WORKER_COMPEN_I'			, width: 110}, 				
//			{dataIndex: 'HIRE_INSUR_TYPE'			, width: 100/*, hidden: true*/}, 				
//			{dataIndex: 'WORK_COMPEN_YN'			, width: 100/*, hidden: true*/}
        ],
        listeners: {
        	beforeedit: function(editor, e){	
          		if(UniUtils.indexOf(e.field, ['PERSON_NUMB', 'NAME' ,'SUPP_TYPE' ,'PAY_YYYYMM'])) {
					if(e.record.phantom == true) {
	        			return true;
	        		}else{
	        			return false;
	        		}
				} 
				if(UniUtils.indexOf(e.field, ['WORK_DAY', 'SUPP_TOTAL_I', 'IN_TAX_I', 'LOCAL_TAX_I','SUPP_DATE', 'ANU_INSUR_I', 'MED_INSUR_I', 'HIR_INSUR_I'])) {
					return true;
				}
				else {
					return false;
	        	}                                                                                          
	        },                                                                                             
        	edit: function(editor, e) { console.log(e);                                                    
				var fieldName = e.field;
        		if(fieldName == 'PAY_YYYYMM'){
        			var inputDate = e.value;
        			inputDate = inputDate.replace('.', '');
        			
        			if(inputDate.length != 6 || isNaN(inputDate)){
        				if(dateFlag){
            				Ext.Msg.alert('확인', '날짜형식이 잘못되었습니다.');
                            e.record.set(fieldName, e.originalValue);
                            dateFlag = true;
                            return false;
                        }
                        dateFlag = true;
                        
        			}else{
                        var inputDate = e.value;
                        inputDate = inputDate.replace('.', '');
        			    e.record.set(fieldName, inputDate.substring(0,4) + '.' + inputDate.substring(4,6));
        			    dateFlag = false;
        			}
        		}
			},
			onGridDblClick:function(grid, record, cellIndex, colName, td)	{
				if(colName =="BANK_ACCOUNT1_EXPOS") {
					grid.ownerGrid.openCryptBankPopup(record);
					
				} else if (colName =="REPRE_NUM_EXPOS") {
					grid.ownerGrid.openRepreNumPopup(record);
				}	
			}
			/*itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
        	}
        },
        onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
      		//menu.showAt(event.getXY());
        	if(record.get("GUBUN") == '1'){
      			return true;
        	}
      	},
      	uniRowContextMenu:{
			items: [
	            {	text	: '인사기본자료등록 보기',   
	            	handler	: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoHam801ukr(param.record);
	            	}
	        	}
	        ]
	    },
	    gotoHam801ukr:function(record)	{
			if(record)	{
		    	var params = {
		    		action:'select',
			    	'PGM_ID' 			: 'ham801ukr',
			    	'PERSON_NUMB' 		:  record.data['PERSON_NUMB'],					 gsParam(0) 
			    	'NAME' 				:  record.data['NAME'],							 gsParam(1) 
			    	'COMP_CODE' 		:  UserInfo.compCode,							 gsParam(2) 
			    	'DOC_ID'			:  record.data['DOC_ID']  						 gsParam(3) 
			    	
		    	}
		    	var rec1 = {data : {prgID : 'hum100ukr', 'text':''}};							
				parent.openTab(rec1, '/human/hum100ukr.do', params);	    	
			}*/
    	},
		openCryptBankPopup:function( record )	{
			if(record)	{
				var params = {'BANK_ACCOUNT': record.get('BANK_ACCOUNT1'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'N'}
				Unilite.popupCipherComm('grid', record, 'BANK_ACCOUNT1_EXPOS', 'BANK_ACCOUNT1', params);
			}
				
		},   
		openRepreNumPopup:function( record )	{
			if(record)	{
				var params = {'REPRE_NO': record.get('REPRE_NUM'), 'GUBUN_FLAG': '3', 'INPUT_YN': 'N'}
				Unilite.popupCipherComm('grid', record, 'REPRE_NUM_EXPOS', 'REPRE_NUM', params);
			}
				
		}
    });
    var decrypBtn = Ext.create('Ext.Button',{
        text:'복호화',
        width: 80,
        handler: function() {
            var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
            if(needSave){
               alert(Msg.sMB154); //먼저 저장하십시오.
               return false;
            }
            panelSearch.setValue('DEC_FLAG', 'Y');
            UniAppManager.app.onQueryButtonDown();
            panelSearch.setValue('DEC_FLAG', '');
        }
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
      id  : 'ham801ukrApp',
      fnInitBinding : function() {
		panelSearch.setValue('PAY_YYYYMM_FR',UniDate.get('today'));
		panelResult.setValue('PAY_YYYYMM_FR',UniDate.get('today'));
		
		panelSearch.setValue('PAY_YYYYMM_TO',UniDate.get('today'));
		panelResult.setValue('PAY_YYYYMM_TO',UniDate.get('today'));         
        UniAppManager.setToolbarButtons('detail',true);
        UniAppManager.setToolbarButtons(['reset','newData'], true);
        //복호화 버튼 툴바에 추가
        var tbar = masterGrid._getToolBar();
        tbar[0].insert(tbar.length + 2, decrypBtn);
		var activeSForm ;
		if(!UserInfo.appOption.collapseLeftSearch)	{
			activeSForm = panelSearch;
		}else {
			activeSForm = panelResult;
		}
		activeSForm.onLoadSelectText('PAY_YYYYMM_FR');         
      },
      onQueryButtonDown : function()   {
         masterGrid.getStore().loadStoreRecords();
      },
		onNewDataButtonDown : function() {		
			var pay_yyyymm = UniDate.getDbDateStr(UniDate.get('today')).substring(0, 6)
			var r = {
				PAY_YYYYMM: pay_yyyymm.substring(0, 4) + ('.') + pay_yyyymm.substring(4, 6),
				SUPP_DATE: UniDate.get('today')
			};
			masterGrid.createRow(r, 'PERSON_NUMB');
		},
		onSaveDataButtonDown : function() {
			if (masterGrid.getStore().isDirty()) {
                var saveFlag        = true;
                var insertRecords   = directMasterStore.getNewRecords( );
                var updateRecords   = directMasterStore.getUpdatedRecords( );
                var changedRec      = [].concat(insertRecords).concat(updateRecords)
                Ext.each(changedRec, function(cRec, index){
                    if(Ext.isEmpty(cRec.get('WORK_DAY'))) {
                        saveFlag = false;
                        alert(index+1 + "행의 근무일수는 필수 입력 항목 입니다.");
                        return false;
                    }
                    if(Ext.isEmpty(cRec.get('SUPP_TOTAL_I'))) {
                        saveFlag = false;
                        alert(index+1 + "행의 지급액은 필수 입력 항목 입니다.");
                        return false;
                    }
                    if(Ext.isEmpty(cRec.get('IN_TAX_I'))) {
                        saveFlag = false;
                        alert(index+1 + "행의 소득세는 필수 입력 항목 입니다.");
                        return false;
                    }
                    if(Ext.isEmpty(cRec.get('LOCAL_TAX_I'))) {
                        saveFlag = false;
                        alert(index+1 + "행의 주민세는 필수 입력 항목 입니다.");
                        return false;
                    }
                })
                if (saveFlag) {		
    				masterGrid.getStore().saveStore();
                }
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
		onResetButtonDown : function() {			
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();;
		},
        setHumInfo: function(records) {
			grdRecord = masterGrid.getSelectedRecord();
			record = records[0];
			
			grdRecord.set('PERSON_NUMB', record.PERSON_NUMB);
			grdRecord.set('NAME', record.NAME);
			grdRecord.set('DIV_CODE', record.DIV_CODE); 
			grdRecord.set('DEPT_CODE', record.DEPT_CODE); 
			grdRecord.set('DEPT_NAME', record.DEPT_NAME);
			grdRecord.set('REPRE_NUM', record.REPRE_NUM);
			grdRecord.set('BANK_CODE', record.BANK_CODE1);
			grdRecord.set('BANK_NAME1', record.BANK_NAME1);
			grdRecord.set('BANK_ACCOUNT1', record.BANK_ACCOUNT1);
			grdRecord.set('JOIN_DATE', record.JOIN_DATE);
			grdRecord.set('RETR_DATE', record.RETR_DATE);
		}
   });
	/**
	 * Validation
	 */
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			var rv = true;
			switch(fieldName) {
				case "WORK_DAY" :	//근무일수
					if(newValue == 0 || record.get('SUPP_TOTAL_I') == 0 || record.get('SUPP_TOTAL_I') / newValue <= 100000){
						if(record.get('SUPP_TOTAL_I') / newValue <= 100000){
							record.set('IN_TAX_I', 0);
							record.set('LOCAL_TAX_I', 0);
						}
						break;
					}
					var inTaxI = (record.get('SUPP_TOTAL_I') / newValue - 100000) * (6/100) * (45/100);		//소득세			  
					inTaxI = Math.floor(inTaxI / 10) * 10 		//10원 미만 절사
					record.set('IN_TAX_I', inTaxI);
					var locTaxI = record.get('IN_TAX_I') * (10/100);	//주민세
					locTaxI = Math.floor(locTaxI / 10) * 10 	//10원 미만 절사
					record.set('LOCAL_TAX_I', locTaxI);
				break;
				case "SUPP_TOTAL_I" :	//지급액
					if(record.get('WORK_DAY') == 0 || newValue == 0 || newValue / record.get('WORK_DAY') <= 100000){
						if(record.get('SUPP_TOTAL_I') / newValue <= 100000){
							record.set('IN_TAX_I', 0);
							record.set('LOCAL_TAX_I', 0);
						}
						break;
					}
					var inTaxI = ( newValue / record.get('WORK_DAY') - 100000) * (6/100) * (45/100);		//소득세			  
					inTaxI = Math.floor(inTaxI / 10) * 10 		//10원 미만 절사
					record.set('IN_TAX_I', inTaxI);
					var locTaxI = record.get('IN_TAX_I') * (10/100);	//주민세
					locTaxI = Math.floor(locTaxI / 10) * 10 	//10원 미만 절사
					record.set('LOCAL_TAX_I', locTaxI);
				break;					
			}
			
			return rv;
		}
	}); // validator
   

};


</script>