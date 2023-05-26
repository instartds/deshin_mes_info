<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep850skr"  >
	<t:ExtComboStore comboType="AU" comboCode="J610" /> 			<!-- 전자결재처리상태코드 -->
	<t:ExtComboStore comboType="AU" comboCode="J647" /> 			<!-- 화폐단위 -->
	<t:ExtComboStore comboType="BOR120" pgmId="aep850skr"/> 		<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>

<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' >
//  ↑ 파일uplod용 plupload.full.js파일 include
</script>
<script type="text/javascript" >



var htmlViewWindow;


function appMain() {
	 
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read	: 'aep850skrService.selectList'/*,
        	update	: 'aep850skrService.updateDetail',
			create	: 'aep850skrService.insertDetail',
			destroy	: 'aep850skrService.deleteDetail',
			syncAll	: 'aep850skrService.saveAll'*/
        }
	});

	
	
   /** Model 정의 
    * @type 
    */
	Unilite.defineModel('aep850skrModel', {
		fields: [ 
			{name: 'GL_DATE'			, text: '회계일자'			, type: 'uniDate'},
			{name: 'INVOICE_DATE'		, text: '증빙일자'			, type: 'uniDate'},
			{name: 'SLIP_NO'			, text: '전표번호'			, type: 'string'},
			{name: 'DEPT_CODE'			, text: '작성부서코드'		, type: 'string'},
			{name: 'DEPT_NAME'			, text: '작성부서'			, type: 'string'},
			{name: 'USER_ID_NAME'		, text: '작성자'			, type: 'string'},
			{name: 'CARD_OWNER_NAME'	, text: '카드소유자'		, type: 'string'},
			{name: 'DOC_TYPE'			, text: '문서유형코드'		, type: 'string'},
			{name: 'ELEC_SLIP_TYPE_NM'	, text: '문서유형'			, type: 'string'},
			{name: 'VENDOR_CODE'		, text: '거래처코드'		, type: 'string'},
			{name: 'VENDOR_NAME'		, text: '거래처'			, type: 'string'},
			{name: 'CATEGORY_CODE'		, text: '업종코드'			, type: 'string'},
			{name: 'CATEGORY_NAME'		, text: '업종'			, type: 'string'},
			{name: 'ACCOUNT_CODE'		, text: '계정과목코드'		, type: 'string'},
			{name: 'ACCOUNT_NAME'		, text: '계정과목'			, type: 'string'},
			{name: 'SUPPLY_AMOUNT'		, text: '공급가액'			, type: 'uniPrice'},
			{name: 'TAX_AMOUNT'			, text: '부가세액'			, type: 'uniPrice'},
			{name: 'TOTAL_AMOUNT'		, text: '총금액'			, type: 'uniPrice'},
			{name: 'DOC_DESCRIPTION'	, text: '사용내역'			, type: 'string'},
			{name: 'TAX_TYPE'			, text: '세무'			, type: 'string'},
			{name: 'TEST16'				, text: '법인카드과세유형'	, type: 'string'},
			{name: 'TEST17'				, text: '카드상태'			, type: 'string'},
			{name: 'TEST18'				, text: '처리상태'			, type: 'string'},
			{name: 'APPR_MANAGE_NO'		, text: 'APPR_MANAGE_NO', type: 'string'},
			{name: 'WRITE_DATE'			, text: '작성일'			, type: 'string'},
			{name: 'DOC_SUBJECT'		, text: '문서제목'			, type: 'string'},
			{name: 'ELEC_SLIP_NO'		, text: '전표번호'			, type: 'string'}
			
		]
	});
	
    Unilite.defineModel('tModel2', {
        fields: [
             {name: 'html_document'             ,text:'html'        ,type : 'string'} 
        ]
    });

    Unilite.defineModel('aep850skrSubModel1', {
        fields: [
            {name: 'RNUM'       		,text: 'No.'		,type: 'string'},
            {name: 'APD_APP_TYPE_NM'	,text: '구분'			,type: 'string'},
            {name: 'APD_APP_ID_NAME'    ,text: '결재자'		,type: 'string'},
            {name: 'APD_APP_DEPT' 		,text: '부서'			,type: 'string'},
            {name: 'APD_APP_ST_NM'		,text: '결재여부'		,type: 'string'},
            {name: 'APD_APP_DT' 		,text: '결재일시'		,type: 'string'},
            {name: 'APD_APP_COMMENT'	,text: '의견'			,type: 'string'}
        ]
    });

    
	
   /** Store 정의(Service 정의)
    * @type 
    */               
   var masterStore = Unilite.createStore('aep850skrMasterStore1',{
		model	: 'aep850skrModel',
        proxy	: directProxy,
		uniOpt	: {
           isMaster	: true,         // 상위 버튼 연결 
           editable	: false,        // 수정 모드 사용 
           deletable: false,        // 삭제 가능 여부 
           useNavi	: false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		
		saveStore : function(config)	{	
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
        	var toUpdate = this.getUpdatedRecords();

        	var rv = true;
   	
        	if(inValidRecs.length == 0 )	{										
				config = {
					success: function(batch, option) {								
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);			
					 } 
				};					
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
   
    var htmlStore =  Unilite.createStore('tStore',{
        model: 'tModel2',
        autoLoad: true ,
        uniOpt : {
            isMaster: false,            // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable:false,            // 삭제 가능 여부 
            useNavi : false         // prev | next 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
                read: 'jbillCommonService.getHtml'                 
            }
        },
        loadStoreRecords: function(record)    {
        	var param= {'APPR_MANAGE_NO': record.get('APPR_MANAGE_NO')};
            this.load({params: param});
        }
    });

    var directSubStore1 = Unilite.createStore('aep850skrSubStore1', {
        model: 'aep850skrSubModel1',
        uniOpt: {
            isMaster: false,         // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            allDeletable:false,
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
                read: 'jbillCommonService.selectSubList1'                 
            }
        },
        
        loadStoreRecords: function(record){
            var param= {'APPR_MANAGE_NO': record.get('APPR_MANAGE_NO')};
            console.log( param );
            this.load({
                params: param
            });
        },
        
        listeners: {
            load: function(store, records, successful, eOpts) {
            },
            add: function(store, records, index, eOpts) {
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {
            },
            remove: function(store, record, index, isMove, eOpts) {
            }
        }
    }); 

    
    
   /** 검색조건 (Search Panel)
    * @type 
    */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title		: '검색조건',		
        defaultType	: 'uniSearchSubPanel',
        collapsed	: UserInfo.appOption.collapseLeftSearch,
        listeners	: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items		: [{	
			title		: '기본정보', 	
   			itemId		: 'search_panel1',
           	layout		: {type: 'uniTable', columns: 1},
           	defaultType	: 'uniTextfield',           	
			items		: [{ 
    			fieldLabel		: '요청일자',
		        xtype			: 'uniDateRangefield',
		        startFieldName	: 'DOC_WRITE_DATE_FR',
		        endFieldName	: 'DOC_WRITE_DATE_TO',
		        startDate		: UniDate.get('aMonthAgo'),
        		endDate			: UniDate.get('today'),
				allowBlank		: false,		        
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('DOC_WRITE_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('DOC_WRITE_DATE_TO',newValue);
			    	}
			    }
	        },{ 
    			fieldLabel: '전기일자',
		        xtype: 'uniDateRangefield',
		        startFieldName: '',
		        endFieldName: '',
		        startDate: UniDate.get('today'),
        		endDate: UniDate.get('today'),
				allowBlank: false,		        
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('',newValue);
			    	}
			    }
	        },
	        Unilite.popup('DEPT',{
				fieldLabel: '작성부서',
			  	valueFieldName:'DEPT_CODE',
			    textFieldName:'DEPT_NAME',
				validateBlank:false,
				autoPopup:true,
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
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('DEPT_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('DEPT_NAME', newValue);				
					}
				}
			}),{
				fieldLabel: '유형',
				name:'DOC_TYPE', 
				xtype: 'uniCombobox',
		        comboType:'AU',
		        comboCode: '',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DOC_TYPE', newValue);
					}
				}
			},{
				fieldLabel: ' ',
				name:'TEST2', 
				xtype: 'uniCombobox',
		        comboType:'AU',
		        comboCode: '',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('TEST2', newValue);
					}
				}
			},
			Unilite.popup('Employee',{
				fieldLabel: '작성자',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				validateBlank:false,
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
							panelResult.setValue('NAME', panelSearch.getValue('NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('PERSON_NUMB', '');
						panelResult.setValue('NAME', '');
					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);				
					}
				}
			}),{
				fieldLabel: '전표번호',
				name:'ELEC_SLIP_NO', 
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ELEC_SLIP_NO', newValue);
					}
				}
			},{
				fieldLabel: '결재번호',
				name:'APPR_MANAGE_NO', 
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('APPR_MANAGE_NO', newValue);
					}
				}
			},{
				fieldLabel: '제목',
				name:'DOC_SUBJECT', 
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DOC_SUBJECT', newValue);
					}
				}
			},{
				fieldLabel: '카드상태',
				name:'TEST9', 
				xtype: 'uniCombobox',
		        comboType:'AU',
		        comboCode: '',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('TEST9', newValue);
					}
				}
			},{ 
    			fieldLabel: '청구일자',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'DOC_WRITE_DATE_FR',
		        endFieldName: 'DOC_WRITE_DATE_TO',
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('DOC_WRITE_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('DOC_WRITE_DATE_TO',newValue);
			    	}
			    }
	        },{
				xtype:'component', 
				html:'&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp카드청구일 데이타가 있는 경우만 조회합니다.',
				style: {
					marginTop: '3px !important',
					font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
	        }
		]}]     	
	});
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
    	items: [{ 
			fieldLabel		: '요청일자',
	        xtype			: 'uniDateRangefield',
	        startFieldName	: 'DOC_WRITE_DATE_FR',
	        endFieldName	: 'DOC_WRITE_DATE_TO',
	        startDate		: UniDate.get('aMonthAgo'),
    		endDate			: UniDate.get('today'),
			allowBlank		: false,		        
	        onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('DOC_WRITE_DATE_FR',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('DOC_WRITE_DATE_TO',newValue);
		    	}
		    }
        },{ 
			fieldLabel: '전기일자',
	        xtype: 'uniDateRangefield',
	        startFieldName: '',
	        endFieldName: '',
	        startDate: UniDate.get('today'),
    		endDate: UniDate.get('today'),
			allowBlank: false,		        
	        onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('',newValue);
		    	}
		    }
        },
        Unilite.popup('DEPT',{
			fieldLabel: '작성부서',
		  	valueFieldName:'DEPT_CODE',
		    textFieldName:'DEPT_NAME',
			validateBlank:false,
			autoPopup:true,
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
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('DEPT_CODE', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('DEPT_NAME', newValue);				
				}
			}
		}),{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 2},
			items :[{
				fieldLabel: '유형',
				name:'DOC_TYPE', 
				xtype: 'uniCombobox',
		        comboType:'AU',
		        comboCode: '',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DOC_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '',
				name:'TEST2', 
				xtype: 'uniCombobox',
		        comboType:'AU',
		        comboCode: '',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('TEST2', newValue);
					}
				}
			}
		]},
		Unilite.popup('Employee',{
			fieldLabel: '작성자',
		  	valueFieldName:'PERSON_NUMB',
		    textFieldName:'NAME',
			validateBlank:false,
			autoPopup:true,
			colspan:2,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
						panelSearch.setValue('NAME', panelResult.getValue('NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('PERSON_NUMB', '');
					panelSearch.setValue('NAME', '');
				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PERSON_NUMB', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('NAME', newValue);				
				}
			}
		}),{
			fieldLabel: '전표번호',
			name:'ELEC_SLIP_NO', 
			xtype: 'uniTextfield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ELEC_SLIP_NO', newValue);
				}
			}
		},{
			fieldLabel: '결재번호',
			name:'APPR_MANAGE_NO', 
			xtype: 'uniTextfield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('APPR_MANAGE_NO', newValue);
				}
			}
		},{
			fieldLabel: '제목',
			name:'DOC_SUBJECT', 
			xtype: 'uniTextfield',
			width: 325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DOC_SUBJECT', newValue);
				}
			}
		},{
			fieldLabel: '카드유형',
			name:'TEST9', 
			xtype: 'uniCombobox',
	        comboType:'AU',
	        comboCode: '',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('TEST9', newValue);
				}
			}
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 2},
			colspan:2,
			items :[{
				fieldLabel: '청구일자',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'DOC_WRITE_DATE_FR',
		        endFieldName: 'DOC_WRITE_DATE_TO',		        
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelSearch.setValue('DOC_WRITE_DATE_FR',newValue);
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('DOC_WRITE_DATE_TO',newValue);
			    	}
			    }
	        },{
				xtype:'component', 
				html:'&nbsp&nbsp카드청구일 데이타가 있는 경우만 조회합니다.',
				style: {
					marginTop: '3px !important',
					font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
	        }]
		}
	]
    });
   
    
    
    /** Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('aep850skrGrid1', {
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
		store: masterStore,
        columns: [
        	{dataIndex: 'GL_DATE'				, width: 120},
        	{dataIndex: 'INVOICE_DATE'			, width: 120},
        	{dataIndex: 'SLIP_NO'				, width: 140},
        	{dataIndex: 'DEPT_CODE'				, width: 140		, hidden: true},
        	{dataIndex: 'DEPT_NAME'				, width: 140},
        	{dataIndex: 'USER_ID_NAME'			, width: 160},
        	{dataIndex: 'CARD_OWNER_NAME'		, width: 120},
        	{dataIndex: 'DOC_TYPE'				, width: 140},
        	{dataIndex: 'ELEC_SLIP_TYPE_NM'		, width: 140},
        	{dataIndex: 'VENDOR_CODE'			, width: 180		, hidden: true},
        	{dataIndex: 'VENDOR_NAME'			, width: 180},
        	{dataIndex: 'CATEGORY_CODE'			, width: 120		, hidden: true},
        	{dataIndex: 'CATEGORY_NAME'			, width: 120},
        	{dataIndex: 'ACCOUNT_CODE'			, width: 120		, hidden: true},
        	{dataIndex: 'ACCOUNT_NAME'			, width: 140},
        	{dataIndex: 'SUPPLY_AMOUNT'			, width: 140},
        	{dataIndex: 'TAX_AMOUNT'			, width: 140},
        	{dataIndex: 'TOTAL_AMOUNT'			, width: 140},
        	{dataIndex: 'DOC_DESCRIPTION'		, width: 180},
        	{dataIndex: 'TAX_TYPE'				, width: 100},
        	{dataIndex: 'TEST16'				, width: 100},
        	{dataIndex: 'TEST17'				, width: 100},
        	{dataIndex: 'TEST18'				, width: 100}
        ],
        listeners: {
        	beforeedit: function(editor, e){      		
        	} ,
            onGridDblClick: function(grid, record, cellIndex, colName) {
            	directSubStore1.loadStoreRecords(record);
//            	directSubStore2.loadStoreRecords();
                htmlStore.loadStoreRecords(record);

                Ext.getCmp('subTitleNo').update('No. '	+ record.get('APPR_MANAGE_NO'));
                subViewForm2.setValue('DOC_TYPE'		, record.get('DOC_TYPE'));				//문서유형	-> 문서유형
                subViewForm2.setValue('USER_ID_NAME'	, record.get('USER_ID_NAME'));			//작성자	-> 작성자
                subViewForm2.setValue('WRITE_DATE'		, record.get('WRITE_DATE'));			//작성일	-> 작성일자
                subViewForm2.setValue('DOC_SUBJECT'		, record.get('DOC_SUBJECT'));			//문서제목	-> 제목
                subViewForm2.setValue('ELEC_SLIP_NO'	, record.get('ELEC_SLIP_NO'));			//전표번호	-> SAP전표
                
//                buttonStore.clearData();
//                record.phantom = true;
//                buttonStore.insert(i, record);

                openHtmlViewWindow();
                
            }
    	}
    });
    
    
    
    var subViewForm1 = Unilite.createSimpleForm('subViewForm1',{
        region: 'north',
        layout : {type : 'uniTable', columns : 2,
//        tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'},
         tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/width: '100%'/*,align : 'left'*/}
        },
        border:false,
        items: [{
            xtype		: 'component',
            margin		: '0 0 0 10',
            html		: '결재문서내역',
            componentCls: 'component-text_title_first',
            tdAttrs		: {align : 'left'}
        },{
            xtype		: 'component',
            id			: 'subTitleNo',
            padding		: '5 5 0 5',
            html		: null,
            componentCls: 'component-text_title_second',
            tdAttrs		: {align : 'right'},
            width		: 200
        }]
        
    }); 
    
    var subViewForm2 = Unilite.createSimpleForm('subViewForm2',{
        region	: 'center',
        padding	: '0 0 0 0',
        margin	: '0 0 0 0',
        layout	: {type : 'uniTable', columns : 1
//        tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'},
//         tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/width: '100%'/*,align : 'left'*/}
        },
        border	: false,
//        height:300,
//      split:true,
        items	: [{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            border:true,
            padding:'0 1 1 1',
            items:[{
                title: '',
                xtype: 'fieldset',
                id: 'fieldset1',
                padding: '10 5 5 5',
                margin: '0 0 0 0',
                width: 705,  
                defaults: {readOnly: true, xtype: 'uniTextfield'},
                layout: {type: 'uniTable' , columns: 2},
                items: [{
                    fieldLabel	: '시스템구분',
                    name		: 'SYS_GUBUN',
                    value		: '전자전표',
                    width		: 320
    //                readOnly:true
                   /* style: {
                        borderColor: 'red',
                        borderStyle: 'solid'
                    }*/
                },{
                    fieldLabel	: '문서유형',
		            xtype		: 'uniCombobox',
		            comboType	: 'AU',
		            comboCode	: 'J647',
                    name		: 'DOC_TYPE',
                    width		: 320
                },{
                    fieldLabel	: '작성자',
                    name		: 'USER_ID_NAME',
//                    value		: '김종욱',
                    width:320
                },{
                    fieldLabel	: '작성일자',
                	xtype		: 'uniDatefield',
                    name		: 'WRITE_DATE',
                    width		: 320
                },{
                    fieldLabel	: '제목',
                    name		: 'DOC_SUBJECT',
//                    value		: '09월_재무팀_여비교통비_시내교통비1111111',
                    width		: 320
                },{
                    fieldLabel	: '전표번호',
                    name		: 'ELEC_SLIP_NO',
//                    value		: '8000117883',
                    width		: 320
                },{
                    xtype	: 'container',
                    layout	: {type : 'uniTable', columns : 1},
                    colspan	: 2,
                    items	: [{
                        xtype	: 'grid',
                        id		: 'subGrid1',
                        store	: directSubStore1,
                        width	: 693,
                        columns: [
                            { dataIndex: 'RNUM'					,text: 'No.'		,type: 'string'		,width:40		,align:'center'},
                            { dataIndex: 'APD_APP_TYPE_NM'		,text: '구분'			,type: 'string'		,width:60		,align:'center'},
                            { dataIndex: 'APD_APP_ID_NAME'		,text: '결재자'		,type: 'string'		,width:100		,align:'center'},
                            { dataIndex: 'APD_APP_DEPT'			,text: '부서'			,type: 'string'		,width:120		,align:'left'		,style: 'text-align:center'},
                            { dataIndex: 'APD_APP_ST_NM'		,text: '결재여부'		,type: 'string'		,width:100		,align:'center'},
                            { dataIndex: 'APD_APP_DT'			,text: '결재일시'		,type: 'string'		,width:140		,align:'center'},
                            { dataIndex: 'APD_APP_COMMENT'		,text: '의견'			,type: 'string'		,width:160		,align:'center'}
                        ]
                    }]
                }/*,{
                    xtype	: 'container',
                    layout	: {type : 'uniTable', columns : 1},
                    colspan	: 2,
                    items	: [{
                        xtype	: 'grid',
                        id		: 'subGrid2',
                        store	: directSubStore2,
                        width	: 693,
                        columns	: [
                            { dataIndex: 't11'		,text: 'No.'		,type: 'string'		,width:40		,align:'center'},    
                            { dataIndex: 't22'		,text: '구분'			,type: 'string'		,width:60		,align:'center'},     
                            { dataIndex: 't33'		,text: '결재자'		,type: 'string'		,width:100		,align:'center'},    
                            { dataIndex: 't44'		,text: '부서'			,type: 'string'		,width:120		,align:'left'		,style: 'text-align:center'},      
                            { dataIndex: 't55'		,text: '결재여부'		,type: 'string'		,width:100		,align:'center'},    
                            { dataIndex: 't66'		,text: '결재일시'		,type: 'string'		,width:110		,align:'center'},    
                            { dataIndex: 't77'		,text: '의견'			,type: 'string'		,width:160		,align:'center'}     
                        ]     
                    }]
                }*/]
            }]
        }]
        
    }); 
    
    var htmlView = Ext.create('Ext.view.View', {
        store	: htmlStore,
        region	: 'south',
        width	: 705,
		tpl		: '<tpl for=".">'+
             		'<span class="data-source" ><div class="x-view-item-focused x-item-selected">' +                        
            		'{html_document}</div></span>'+
             	  '</tpl>',
        itemSelector: 'div.data-source '
    });
    
    var fileForm = Unilite.createSimpleForm('fileForm',{
        region: 'south',
        disabled:false,
//      split:true,
        items: [{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            width:705,
            id:'uploadDisabled',
            disabled:true,
            tdAttrs: {align : 'center'},
            items :[{
                xtype: 'xuploadpanel',
                width:705,
                bbar: ['->',{
//                    id: 'aaaaaa',
                    text: '조회',
                    handler: function() {
                        
                        UniAppManager.app.fileUploadLoad();
                        
                   /*   var fp = fileForm.down('xuploadpanel');                 //mask on
                        fp.getEl().mask('로딩중...','loading-indicator');
                        var fileNO = fileForm.getValue('FILE_NO');
                        aep100ukrService.getFileList({DOC_NO : fileNO},              //파일조회 메서드  호출(param - 파일번호) 
                            function(provider, response) {                          
                                fp.loadData(response.result);                       //업로드 파일 load해서 보여주기
                                fp.getEl().unmask();                                //mask off
//                                UniAppManager.setToolbarButtons('save',false);      //저장버튼 비활성화
                            }
                         )*/
                    }
                },{
//                    id: 'bbbb',
                    text: '저장',
                    handler: function() {
                        var fp = fileForm.down('xuploadpanel'); 
                        var addFiles = fp.getAddFiles();                
                        var removeFiles = fp.getRemoveFiles();
                        fileForm.setValue('ADD_FID', addFiles);                  //추가 파일 담기
                        fileForm.setValue('DEL_FID', removeFiles);               //삭제 파일 담기
                        var param= fileForm.getValues();
                        fileForm.getEl().mask('로딩중...','loading-indicator'); //mask on
                        fileForm.getForm().submit({                              //폼 submit 함수 호출
                             params : param,
                             success : function(form, action) {
                                UniAppManager.updateStatus(Msg.sMB011);             //저장되었습니다.(message) 
//                                UniAppManager.setToolbarButtons('save',false);      //저장버튼 비활성화
                                fileForm.getEl().unmask();                       //mask off
                             }
                        });
                    }
                }],
                height: 150,
                flex: 0,
                padding: '0 0 0 0',
                listeners : {
                    change: function() {
//                        UniAppManager.app.setToolbarButtons('save', true);  //파일 추가or삭제시 저장버튼 on
                    }
                }
            },{
                xtype:'uniTextfield',
                fieldLabel: 'FILE_NO',          
                name:'FILE_NO',
                value: '',                //임시 파일 번호
                readOnly:true,
                hidden:true
            } ,{
                xtype:'uniTextfield',
                fieldLabel: '삭제파일FID'   ,       //삭제 파일번호를 set하기 위한 hidden 필드
                name:'DEL_FID',
                readOnly:true,
                hidden:true
            },{
                xtype:'uniTextfield',
                fieldLabel: '등록파일FID'   ,       //등록 파일번호를 set하기 위한 hidden 필드
                name:'ADD_FID',
                readOnly:true,
                hidden:true
            }]
        }],
        api: {
             load: 'aep830skrService.getFileList',   //조회 api
             submit: 'aep830skrService.saveFile'      //저장 api
        }
    });  
    
    function openHtmlViewWindow() {          
        if(!htmlViewWindow) {
            htmlViewWindow = Ext.create('widget.uniDetailWindow', {
                title		: '전자결재 - 결재 문서 VIEW',
                width		: 730,  
                minWidth	: 730,
                maxWidth	: 730,
                height		: '100%',
                autoScroll	: true,
                padding		: '1 1 1 1',
                layout		: {type:'vbox', align:'stretch'},
//                layout : {type : 'uniTable', columns : 1
//                    tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'},
//         tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/width: '100%'/*,align : 'left'*/}
                
//                },
                items		: [subViewForm1,subViewForm2,fileForm,htmlView],
                tbar		: [
                    '->',{
                        itemId : 'closeBtn',
                        text: '닫기',
                        handler: function() {
                            htmlViewWindow.hide();
//                          draftNoGrid.reset();
//                          draftNoSearch.clearForm();
                        },
                        disabled: false
                    }
                ],
                listeners : {
                    beforeshow: function ( panel, eOpts ) {
                    },
                    show: function ( panel, eOpts ) {
                    },
                    beforehide: function(me, eOpt)  {
                    },
                    beforeclose: function( panel, eOpts )   {
                    }
                }
            })
        }
        htmlViewWindow.center();
        htmlViewWindow.show();
    }
     

    
    Unilite.Main({
		id			: 'aep850skrApp',
		borderItems	: [{
         region		: 'center',
         layout		: 'border',
         border		: false,
         items		: [
            	masterGrid, panelResult
	     	]
	    },
		panelSearch
	    ], 
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('reset',true);
			UniAppManager.setToolbarButtons(['newData', 'save', 'delete'], false);
			
			//panelSearch 값 setting
			panelSearch.setValue('WRITE_DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('WRITE_DATE_TO', UniDate.get('today'));
			panelSearch.setValue('DOC_WRITE_DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('DOC_WRITE_DATE_TO', UniDate.get('today'));
			
			//panelResult 값 setting
			panelResult.setValue('WRITE_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('WRITE_DATE_TO', UniDate.get('today'));
			panelResult.setValue('DOC_WRITE_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('DOC_WRITE_DATE_TO', UniDate.get('today'));

			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DOC_WRITE_DATE_FR');         
        },
        
        onQueryButtonDown : function()   {
			if(!this.isValidSearchForm()){
				return false;
			}
        	masterGrid.getStore().loadStoreRecords();
        },
        
		onResetButtonDown : function() {			
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();;
		}
   });
};
</script>