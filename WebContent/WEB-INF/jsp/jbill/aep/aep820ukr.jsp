<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep820ukr"  >
    <t:ExtComboStore comboType="AU" comboCode="J647" />         <!-- 유형 -->

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

	var directProxyReceipt = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create: 'aep820ukrService.insertReceiptDetail',
            syncAll: 'aep820ukrService.saveReceiptAll'
        }
    }); 

    
	
   /**
    *   Model 정의 
    * @type 
    */
	Unilite.defineModel('aep820ukrModel', {
		fields: [ 
		    {name: 'RNUM'                   , text: '순번'       		, type: 'string'},
		    {name: 'APPR_MANAGE_NO'         , text: '결재번호'    		, type: 'string'},
			{name: 'SLIP_NO'			    , text: '전표번호'			, type: 'string'},
			{name: 'EVIDENCE_DATE'			, text: '회계일자'			, type: 'uniDate'},
			{name: 'DOC_TYPE'			    , text: '문서유형'			, type: 'string'	,comboType:'AU',comboCode:'J647'},
            {name: 'DOC_SUBJECT'            , text: '문서제목'     	, type: 'string'},
            {name: 'DOC_WRITE_DATE'         , text: 'DOC_WRITE_DATE', type: 'uniDate'},
			{name: 'DOC_DESCRIPTION'		, text: '문서내용'			, type: 'string'},
			{name: 'TOTAL_AMOUNT'			, text: '금액'			, type: 'uniPrice'},
			{name: 'USER_ID_NAME'			, text: '작성자'			, type: 'string'},
			{name: 'APPR_DOC_STATUS'		, text: '처리상태'			, type: 'string'},
			{name: 'ELEC_SLIP_NO'			, text: 'ELEC_SLIP_NO'	, type: 'string'}
			
		]
	});

    Unilite.defineModel('tModel2', {
        fields: [
             {name: 'html_document'             ,text:'html'        ,type : 'string'} 
                    
        ]
    });

    Unilite.defineModel('aep820ukrSubModel1', {
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

    
	
   /**
    * Store 정의(Service 정의)
    * @type 
    */               
    var directDetailStore = Unilite.createStore('aep820ukrDetailStore',{
        model: 'aep820ukrModel',
        uniOpt : {
            isMaster: true,         // 상위 버튼 연결 
            editable: false,         // 수정 모드 사용 
            deletable:false,         // 삭제 가능 여부 
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {          
                read: 'aep820ukrService.selectList'                  
            }
        },
        loadStoreRecords : function()	{
        	var param= Ext.getCmp('searchForm').getValues();			
        	console.log( param );
        	this.load({
        		params : param
        	});
        }
   });
   
    var receiptButtonStore = Unilite.createStore('ButtonStore',{     
        uniOpt: {
            isMaster: false,            // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            useNavi : false         // prev | newxt 버튼 사용
        },
        proxy: directProxyReceipt,
        saveStore: function() {             
            var inValidRecs = this.getInvalidRecords();
            var paramMaster = panelResult.getValues();  //syncAll 수정
//          param.FR_INPUT_DATE = UniDate.getDbDateStr(panelSearch.getValue('FR_INPUT_DATE'));
            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        var master = batch.operations[0].getResultSet();
                        
                        UniAppManager.app.onQueryButtonDown();
                     },
                     failure: function(batch, option) {
                     
                        
                     }
                };
                this.syncAllDirect(config);
            } else {
                var grid = Ext.getCmp('aep820ukrGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
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

    var directSubStore1 = Unilite.createStore('aep820ukrSubStore1', {
        model: 'aep820ukrSubModel1',
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
    			fieldLabel: '요청일자',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'DOC_WRITE_DATE_FR',
		        endFieldName: 'DOC_WRITE_DATE_TO',
		        startDate: UniDate.get('startOfMonth'),
        		endDate: UniDate.get('today'),
				allowBlank: false,		        
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
				fieldLabel: '전기월',  
				name: 'EVIDENCE_DATE',
				xtype : 'uniMonthfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('EVIDENCE_DATE', newValue);
					}
				}
			},
			Unilite.popup('DEPT',{
				fieldLabel: '작성비용부서',
			  	valueFieldName:'COST_CENTER',
			    textFieldName:'COST_CENTER_NAME',
				validateBlank:false,
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {	 																							
						},
						scope: this
					},
					onClear: function(type)	{
					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('COST_CENTER', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('COST_CENTER_NAME', newValue);				
					}
				}
			}),{
				fieldLabel: '유형',
				name:'DOC_TYPE', 
				xtype: 'uniCombobox',
		        comboType:'AU',
		        comboCode: 'J647',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DOC_TYPE', newValue);
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
						},
						scope: this
					},
					onClear: function(type)	{
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
				fieldLabel: ' ',
            	boxLabel: '자기부서만조회',
            	margin: '0 0 0 0',
            	labelWidth: 75,
            	name: 'DEPT_EMP_FLAG',
				uncheckedValue: 'N',
        		inputValue: 'Y',
				xtype: 'checkbox',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelResult.setValue('DEPT_EMP_FLAG', newValue);
					}
				}
			}
		]}]     	
	});
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
    	items: [{ 
			fieldLabel: '요청일자',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'DOC_WRITE_DATE_FR',
	        endFieldName: 'DOC_WRITE_DATE_TO',
	        startDate: UniDate.get('startOfMonth'),
    		endDate: UniDate.get('today'),
			allowBlank: false,		        
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
			fieldLabel: '전기월',  
			name: 'EVIDENCE_DATE',
			xtype : 'uniMonthfield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('EVIDENCE_DATE', newValue);
				}
			}
		},
		Unilite.popup('DEPT',{
			fieldLabel: '작성비용부서',
		  	valueFieldName:'COST_CENTER',
		    textFieldName:'COST_CENTER_NAME',
			validateBlank:false,
			autoPopup:true,
			colspan:2,
			listeners: {
				onSelected: {
					fn: function(records, type) {			 																							
					},
					scope: this
				},
				onClear: function(type)	{
				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('COST_CENTER', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('COST_CENTER_NAME', newValue);				
				}
			}
		}),{
			fieldLabel: '유형',
			name:'DOC_TYPE', 
			xtype: 'uniCombobox',
	        comboType:'AU',
	        comboCode: 'J647',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DOC_TYPE', newValue);
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
					},
					scope: this
				},
				onClear: function(type)	{
				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PERSON_NUMB', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('NAME', newValue);				
				}
			}
		}),
        {
		  xtype:'component',
		  colspan:2
			
			
		},{
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
			fieldLabel: ' ',
        	boxLabel: '자기부서만조회',
        	margin: '0 0 0 0',
//        	labelWidth: 100,
        	name: 'DEPT_EMP_FLAG',
			uncheckedValue: 'N',
    		inputValue: 'Y',
			xtype: 'checkbox',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {      
					panelSearch.setValue('DEPT_EMP_FLAG', newValue);
				}
			}
		}
	]
    });

    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var detailGrid = Unilite.createGrid('aep820ukrGrid', {
        region: 'center',
        layout: 'fit',
    	uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			onLoadSelectFirst: false,
			useRowNumberer: false,
			expandLastColumn: false,
			useRowContext: true,
    		state: {
				useState: true,			
				useStateList: true		
			}
        },
		features: [{
			id: 'detailGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false						
		},{
			id: 'detailGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		tbar: [{
			id: 'receiptBtn',
			text: '접수',
        	handler: function() {
                var selectedRecords = detailGrid.getSelectedRecords();
                if(selectedRecords.length > 0){
                
                    receiptButtonStore.clearData();
                    Ext.each(selectedRecords, function(record,i){
                        record.phantom = true;
                        receiptButtonStore.insert(i, record);
                    });
                    receiptButtonStore.saveStore();
                    
//                    alert(receiptButtonStore.count());  //임시로 카운트 뽑아 놓음 로그테이블 완성되면 saveStore 호출
                    
                }else{
                    Ext.Msg.alert('확인','접수 할 데이터를 선택해 주세요.'); 
                }
	        }
		}],
		store: directDetailStore,
		selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true,
			listeners: {  
				select: function(grid, selectRecord, index, rowIndex, eOpts ){	

				},
				deselect:  function(grid, selectRecord, index, eOpts ){
				}
        	}
        }),
        columns: [
        	{dataIndex: 'RNUM'             ,            width: 50,align:'center'},
        	{dataIndex: 'APPR_MANAGE_NO'   ,            width: 140},
        	{dataIndex: 'SLIP_NO'		   ,			width: 120},
        	{dataIndex: 'EVIDENCE_DATE'	   ,			width: 88},
        	{dataIndex: 'DOC_TYPE'		   ,			width: 130},
            {dataIndex: 'DOC_SUBJECT'      ,            width: 200},
        	{dataIndex: 'DOC_DESCRIPTION'  ,			width: 400},
        	{dataIndex: 'TOTAL_AMOUNT'	   ,			width: 100},
        	{dataIndex: 'USER_ID_NAME'	   ,			width: 120,align:'center'},
        	{dataIndex: 'APPR_DOC_STATUS'  ,			width: 100}
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
                subViewForm2.setValue('WRITE_DATE'		, record.get('DOC_WRITE_DATE'));		//작성일	-> 작성일자
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
             load: 'aep820ukrService.getFileList',   //조회 api
             submit: 'aep820ukrService.saveFile'      //저장 api
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
     
    
    
    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                detailGrid, panelResult
	     	]
        },
            panelSearch
        ], 
    id  : 'aep820ukrApp',
    fnInitBinding : function() {
        UniAppManager.setToolbarButtons('reset',true);
        UniAppManager.setToolbarButtons(['newData', 'save', 'delete'], false);
            var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DOC_WRITE_DATE_FR');         

            panelSearch.setValue('DOC_WRITE_DATE_FR',UniDate.get('startOfMonth'));
            panelSearch.setValue('DOC_WRITE_DATE_TO',UniDate.get('today'));
            panelResult.setValue('DOC_WRITE_DATE_FR',UniDate.get('startOfMonth'));
            panelResult.setValue('DOC_WRITE_DATE_TO',UniDate.get('today'));
        },
        onQueryButtonDown : function()   {
        	if(!panelResult.getInvalidMessage()) return;   //필수체크
        	
        	directDetailStore.loadStoreRecords();
        },
		/*onNewDataButtonDown : function() {			
			var r = {
				JOIN_DATE: UniDate.get('today')	
			};
			detailGrid.createRow(r, '');
		},*/
		onSaveDataButtonDown : function() {
//			directDetailStore.saveStore();
		},
		/*onDeleteDataButtonDown : function()	{
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				detailGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				detailGrid.deleteSelectedRow();
			}
		},*/
		onResetButtonDown : function() {			
			panelSearch.clearForm();
			panelResult.clearForm();
			detailGrid.reset();
			directDetailStore.clearData();
			this.fnInitBinding();
		}
   });
};
</script>