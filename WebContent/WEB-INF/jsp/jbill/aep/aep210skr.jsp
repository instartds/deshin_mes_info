<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep210skr"  >

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {  
	
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('aep210skrModel', {
	    fields: [
			{name: 'ICON'				, text: '출력'		, type: 'string'},
			{name: 'ORA_SLIP_NO'		, text: 'SAP전표번호'	, type: 'string'},
			{name: 'SLIP_STAT_NM'		, text: '진행상태'		, type: 'string'},
			{name: 'ELEC_SLIP_TYPE_NM'	, text: '전표유형'		, type: 'string'},
			{name: 'INVOICE_DATE'		, text: '증빙일자'		, type: 'uniDate'},
			{name: 'GL_DATE'			, text: '회계일자'		, type: 'uniDate'},
			{name: 'INVOICE_AMT'		, text: '총금액'		, type: 'uniPrice'},
			{name: 'SUPPLY_AMT'			, text: '공급가'		, type: 'uniPrice'},
			{name: 'TAX_AMT'			, text: '부가세'		, type: 'uniPrice'},
			{name: 'TAX_CD'				, text: '세금코드'		, type: 'string'},
			{name: 'TAX_NM'				, text: '세금코드명'	, type: 'string'},
			{name: 'EVDE_TYPE_NM'		, text: '증빙유형'		, type: 'string'},
			{name: 'VENDOR_NM'			, text: '거래처'		, type: 'string'},
			{name: 'SLIP_DESC'			, text: '사용내역'		, type: 'string'},
			{name: 'REG_DEPT_NM'		, text: '작성부서'		, type: 'string'},
			{name: 'REG_NM'				, text: '작성자'		, type: 'string'},
			{name: 'REG_DT'				, text: '작성일자'		, type: 'uniDate'},
			{name: 'CURR_APD_APPP_ID'	, text: '현결재자'		, type: 'string'},
			{name: 'ELEC_SLIP_NO'		, text: '전표번호'		, type: 'string'},
			{name: 'APPR_DATE'			, text: '승인일자'		, type: 'uniDate'},
			{name: 'MCC_NM'				, text: '가맹점업종'	, type: 'string'},
			{name: 'MERC_ADDR'			, text: '가맹점주소'	, type: 'string'}
	    ] 
	});
	
	  
	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('aep210skrMasterStore1',{
		model	: 'aep210skrModel',
		uniOpt	: {
            isMaster	: true,			// 상위 버튼 연결 
            editable	: false,		// 수정 모드 사용 
            deletable	: false,		// 삭제 가능 여부 
	        useNavi		: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy	: {
           type: 'direct',
            api: {			
                read: 'aep210skrService.selectList'                	
            }
        },
        loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		}
	});
	
	
	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title		: '검색조건',
        defaultType	: 'uniSearchSubPanel',
        collapsed	: UserInfo.appOption.collapseLeftSearch,//true,
        listeners	: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items		: [{	
			title	: '기본정보', 	
   			itemId	: 'search_panel1',
           	layout	: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
	            fieldLabel	: '전표유형',
	            name		: 'ELEC_SLIP_TYPE_CD',  
	            xtype		: 'uniCombobox',
	            comboType	: 'AU',
	            comboCode	: 'J647',
        		listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ELEC_SLIP_TYPE_CD', newValue);
					}
				}
        	},{
            	fieldLabel	: '진행상태',
	            name		: 'SLIP_STAT_CD',  
	            xtype		: 'uniCombobox',
	            comboType	: 'AU',
	            comboCode	: 'J682',
        		listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SLIP_STAT_CD', newValue);
					}
				}
        	},{ 
	            fieldLabel	: '증빙일자',
	            xtype		: 'uniDateRangefield',
	            startFieldName: 'INVOICE_DATE_FR',
	            endFieldName: 'INVOICE_DATE_TO',
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelResult.setValue('INVOICE_DATE_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelResult.setValue('INVOICE_DATE_TO', newValue);				    		
			    	}
			    }
			},
			Unilite.popup('Employee',{
                fieldLabel		: '전표작성자', 
                valueFieldWidth	: 90,
                textFieldWidth	: 140,
                valueFieldName	: 'PERSON_NUMB',
                textFieldName	: 'NAME',
				autoPopup		: true,
				listeners		: {
					onSelected: {
						fn: function(records, type) {
                            panelSearch.setValue('PERSON_DEPT_NAME', records[0].DEPT_NAME);
                            
							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
							panelResult.setValue('NAME', panelSearch.getValue('NAME'));				 																							
                            panelResult.setValue('PERSON_DEPT_NAME', records[0].DEPT_NAME);
						},
						scope: this
					},
					onClear: function(type)	{
                        panelSearch.setValue('PERSON_DEPT_NAME', '');

                        panelResult.setValue('PERSON_NUMB', '');
						panelResult.setValue('NAME', '');
                        panelResult.setValue('PERSON_DEPT_NAME', '');
					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);				
					}
				}
			}),{
                fieldLabel	: ' ',
                xtype		: 'uniTextfield',
                name		: 'PERSON_DEPT_NAME',
                width		: 200,
                readOnly	: true
            },{ 
	    		fieldLabel	: '회계일자',
			    xtype		: 'uniDateRangefield',
	            startFieldName: 'GL_DATE_FR',
	            endFieldName: 'GL_DATE_TO',
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelResult.setValue('GL_DATE_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelResult.setValue('GL_DATE_TO', newValue);				    		
			    	}
			    }
			},
			Unilite.popup('DEPT', {
				fieldLabel		: '작성부서',
			  	valueFieldName	: 'DEPT_CODE',
			    textFieldName	: 'DEPT_NAME',
				validateBlank	: false,
				autoPopup		: true,
				listeners		: {
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
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('DEPT_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('DEPT_NAME', newValue);				
					}
				}
			}),{ 
	    		fieldLabel	: '작성일자',
			    xtype		: 'uniDateRangefield',
			    startFieldName: 'INSERT_DB_TIME_FR',
			    endFieldName: 'INSERT_DB_TIME_TO',
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelResult.setValue('INSERT_DB_TIME_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelResult.setValue('INSERT_DB_TIME_TO', newValue);				    		
			    	}
			    }
			},{
	            fieldLabel	: '거래처',
	            name		: 'VENDOR_NM',
	            xtype		: 'uniTextfield',
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('VENDOR_NM', newValue);
					}
				}
	        },{
		        fieldLabel	: '전표번호',
		        name		: 'ORA_SLIP_NO',
		        xtype		: 'uniTextfield',
		        listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ORA_SLIP_NO', newValue);
					}
				}
		    },{
		        fieldLabel	: '관리번호',
		        name		: 'ELEC_SLIP_NO',
		        xtype		: 'uniTextfield',
		        listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ELEC_SLIP_NO', newValue);
					}
				}
		    }]				
		}]		
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region	: 'north',
		layout	: {type : 'uniTable', columns : 2},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
	            fieldLabel	: '전표유형',
	            name		: 'ELEC_SLIP_TYPE_CD',  
	            xtype		: 'uniCombobox',
	            comboType	: 'AU',
	            comboCode	: 'J647',
	        	tdAttrs		: {width: 380}, 
        		listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ELEC_SLIP_TYPE_CD', newValue);
					}
				}
        	},{
            	fieldLabel	: '진행상태',
	            name		: 'SLIP_STAT_CD',  
	            xtype		: 'uniCombobox',
	            comboType	: 'AU',
	            comboCode	: 'J682',
        		listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('SLIP_STAT_CD', newValue);
					}
				}
        	},{ 
	            fieldLabel	: '증빙일자',
	            xtype		: 'uniDateRangefield',
	            startFieldName: 'INVOICE_DATE_FR',
	            endFieldName: 'INVOICE_DATE_TO',
	        	tdAttrs		: {width: 380},
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelSearch.setValue('INVOICE_DATE_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('INVOICE_DATE_TO', newValue);				    		
			    	}
			    }
			},{ 
	            xtype: 'container',
	            layout: {type : 'uniTable', columns : 2},
//            	padding:'10 10 0 10',
	            items :[
	            Unilite.popup('Employee',{
	                fieldLabel		: '전표작성자', 
	                valueFieldWidth	: 90,
	                textFieldWidth	: 140,
	                valueFieldName	: 'PERSON_NUMB',
	                textFieldName	: 'NAME',
	                listeners		: {
						onSelected: {
							fn: function(records, type) {
	                            panelResult.setValue('PERSON_DEPT_NAME', records[0].DEPT_NAME);
	                            
								panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
								panelSearch.setValue('NAME', panelResult.getValue('NAME'));				 																							
	                            panelSearch.setValue('PERSON_DEPT_NAME', records[0].DEPT_NAME);
							},
							scope: this
						},
						onClear: function(type)	{
	                        panelResult.setValue('PERSON_DEPT_NAME', '');
	
	                        panelSearch.setValue('PERSON_NUMB', '');
							panelSearch.setValue('NAME', '');
	                        panelSearch.setValue('PERSON_DEPT_NAME', '');
						},
						onValueFieldChange: function(field, newValue){
							panelSearch.setValue('PERSON_NUMB', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelSearch.setValue('NAME', newValue);				
						}
					}
	            }),{
	                xtype: 'uniTextfield',
	                fieldLabel:'',
	                name: 'PERSON_DEPT_NAME',
	                width:140,
	                readOnly:true
	            }]
	        },{ 
	    		fieldLabel	: '회계일자',
			    xtype		: 'uniDateRangefield',
	            startFieldName: 'GL_DATE_FR',
	            endFieldName: 'GL_DATE_TO',
	        	tdAttrs		: {width: 380},
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelSearch.setValue('GL_DATE_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('GL_DATE_TO', newValue);				    		
			    	}
			    }
			},
			Unilite.popup('DEPT',{
				fieldLabel		: '작성부서',
			  	valueFieldName	: 'DEPT_CODE',
			    textFieldName	: 'DEPT_NAME',
			    validateBlank	: false,
				autoPopup		: true,
				listeners		: {
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
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('DEPT_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('DEPT_NAME', newValue);				
					}
				}
			}),{ 
	    		fieldLabel	: '작성일자',
			    xtype		: 'uniDateRangefield',
			    startFieldName: 'INSERT_DB_TIME_FR',
			    endFieldName: 'INSERT_DB_TIME_TO',
	        	tdAttrs		: {width: 380},
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelSearch.setValue('INSERT_DB_TIME_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelSearch.setValue('INSERT_DB_TIME_TO', newValue);				    		
			    	}
			    }
			},{
	            fieldLabel	: '거래처',
	            name		: 'VENDOR_NM',
	            xtype		: 'uniTextfield',
		        listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('VENDOR_NM', newValue);
					}
				}
	        },{
		        fieldLabel	: '전표번호',
		        name		: 'ORA_SLIP_NO',
		        xtype		: 'uniTextfield',
	        	tdAttrs		: {width: 380},
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ORA_SLIP_NO', newValue);
					}
				}
		    },{
		        fieldLabel	: '관리번호',
		        name		: 'ELEC_SLIP_NO',
		        xtype		: 'uniTextfield',
		        listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ELEC_SLIP_NO', newValue);
					}
				}
		    }
		]	
    });

    
    /** Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('aep210skrGrid1', {
		store	: directMasterStore,
    	layout	: 'fit',
        region	: 'center',
    	uniOpt	: {					
			useMultipleSorting	: true,		
		    useLiveSearch		: true,		
		    onLoadSelectFirst	: false,			
		    dblClickToEdit		: false,		
		    useGroupSummary		: true,		
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: false,		
			useRowContext		: true,	
		    filter: {				
				useFilter		: true,
				autoCreate		: true
			}			
		},				
        features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
           			{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false} ],
		selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true,
			listeners: {  
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
				}
			}
        }),
        columns: [
        	{
			    xtype	: 'rownumberer',        
			    sortable: false,         
			    width	: 35, 
			    align	: 'center  !important',       
			    resizable: true
			},
        	{dataIndex: 'ICON'					, width: 100		, hidden: true},
        	{dataIndex: 'ORA_SLIP_NO'			, width: 100},
        	{dataIndex: 'ELEC_SLIP_NO'			, width: 100},
        	{dataIndex: 'SLIP_STAT_NM'			, width: 100},
        	{dataIndex: 'ELEC_SLIP_TYPE_NM'		, width: 100},
        	{dataIndex: 'INVOICE_DATE'			, width: 100},
        	{dataIndex: 'GL_DATE'				, width: 100},
        	{dataIndex: 'INVOICE_AMT'			, width: 100},
        	{dataIndex: 'SUPPLY_AMT'			, width: 100},
        	{dataIndex: 'TAX_AMT'				, width: 100},
        	{dataIndex: 'TAX_NM'				, width: 100},
        	{dataIndex: 'EVDE_TYPE_NM'			, width: 100},
        	{dataIndex: 'VENDOR_NM'				, width: 100},
        	{dataIndex: 'SLIP_DESC'				, width: 100},
        	{dataIndex: 'REG_DEPT_NM'			, width: 100},
        	{dataIndex: 'REG_NM'				, width: 100},
        	{dataIndex: 'REG_DT'				, width: 100},
        	{dataIndex: 'CURR_APD_APPP_ID'		, width: 100},
        	{dataIndex: 'APPR_DATE'				, width: 100},
        	{dataIndex: 'MCC_NM'				, width: 100},
        	{dataIndex: 'MERC_ADDR'				, width: 100}
		]    
    });                          
    
    
	Unilite.Main({
		id 			: 'aep210skrApp',
	 	border		: false,
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		},
		panelSearch  	
		], 
		
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('reset',true);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('ELEC_SLIP_TYPE_CD');
			
			UniAppManager.app.fnInitInputFields();  
		},
		
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			directMasterStore.loadStoreRecords();
		},
		
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			directMasterStore.clearData();

			this.fnInitBinding();		
		},
		
        fnInitInputFields: function(){
        	panelSearch.setValue('INVOICE_DATE_FR'	, UniDate.get('twoMonthsAgo'));
            panelSearch.setValue('INVOICE_DATE_TO'	, UniDate.get('twoWeeksLater'));
            panelSearch.setValue('GL_DATE_FR'		, UniDate.get('twoMonthsAgo'));
            panelSearch.setValue('GL_DATE_TO'		, UniDate.get('twoWeeksLater'));
            panelSearch.setValue('INSERT_DB_TIME_FR', UniDate.get('twoMonthsAgo'));
            panelSearch.setValue('INSERT_DB_TIME_TO', UniDate.get('twoWeeksLater'));

            panelResult.setValue('INVOICE_DATE_FR'	, UniDate.get('twoMonthsAgo'));
            panelResult.setValue('INVOICE_DATE_TO'	, UniDate.get('twoWeeksLater'));
            panelResult.setValue('GL_DATE_FR'		, UniDate.get('twoMonthsAgo'));
            panelResult.setValue('GL_DATE_TO'		, UniDate.get('twoWeeksLater'));
            panelResult.setValue('INSERT_DB_TIME_FR', UniDate.get('twoMonthsAgo'));
            panelResult.setValue('INSERT_DB_TIME_TO', UniDate.get('twoWeeksLater'));
        }
	});
};
</script>
