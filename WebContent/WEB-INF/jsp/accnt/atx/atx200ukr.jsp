<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx200ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL" storeId="billDivCode" />	<!-- 신고사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A067"  />	<!-- 부가세신고구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {     
	var baseInfo = {
		gsBillDivCode   : '${gsBillDivCode}'
	}
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Atx200ukrModel1', {
	    fields: [
	    	{name: 'TYPE'				, text: '자료구분' 			,type: 'string'},
		    {name: 'COMPANY_NUM'		, text: '보고자등록번호'		,type: 'string'},
		    {name: 'SEQ'				, text: '일련번호' 			,type: 'string'},
		    {name: 'CUSTOM_NUM'			, text: '거래자등록번호' 		,type: 'string'},
		    {name: 'CUSTOM_NAME'		, text: '거래자상호' 		,type: 'string'},
		    {name: 'CUSTOM_TYPE'		, text: '거래자업태'			,type: 'string'},
		    {name: 'CUSTOM_CLASS'		, text: '거래자종목' 		,type: 'string'},
		    {name: 'CNT'				, text: '매수' 			,type: 'uniQty'},
		    {name: 'BLANK_CNT'			, text: '공란수' 			,type: 'uniQty'},
		    {name: 'SUPPLY_AMT'			, text: '공급가액'			,type: 'uniPrice'},
		    {name: 'TAX_AMT'			, text: '세액' 			,type: 'uniPrice'},
		    {name: 'WHOLESALE_CODE'		, text: '주류코드(도매)' 		,type: 'string'},
		    {name: 'RETAIL_CODE'		, text: '주류코드(소매)' 		,type: 'string'},
		    {name: 'BOOK_NO'			, text: '권번호'			,type: 'string'},
		    {name: 'SAFFER_TAX'			, text: '제출서' 			,type: 'string'}
		    
		]
	});
	
	Unilite.defineModel('Atx200ukrModel2', {
	    fields: [  	  
	    	{name: 'TYPE'				, text: '자료구분' 			,type: 'string'},
		    {name: 'COMPANY_NUM'		, text: '사업자등록번호'		,type: 'string'},
		    {name: 'SEQ'				, text: '일련번호' 			,type: 'string'},
		    {name: 'CUSTOM_NUM'			, text: '거래자등록번호' 		,type: 'string'},
		    {name: 'CUSTOM_NAME'		, text: '거래자상호' 		,type: 'string'},
		    {name: 'CUSTOM_TYPE'		, text: '거래자업태'			,type: 'string'},
		    {name: 'CUSTOM_CLASS'		, text: '거래자종목' 		,type: 'string'},
		    {name: 'CNT'				, text: '매수' 			,type: 'uniQty'},
		    {name: 'BLANK_CNT'			, text: '공란수' 			,type: 'uniQty'},
		    {name: 'SUPPLY_AMT'			, text: '공급가액'			,type: 'uniPrice'},
		    {name: 'TAX_AMT'			, text: '세액' 			,type: 'uniPrice'},
		    {name: 'WHOLESALE_CODE'		, text: '주류코드(도매)' 		,type: 'string'},
		    {name: 'RETAIL_CODE'		, text: '주류코드(소매)' 		,type: 'string'},
		    {name: 'BOOK_NO'			, text: '권번호'			,type: 'string'},
		    {name: 'SAFFER_TAX'			, text: '제출서' 			,type: 'string'}
		    
		]          
	});
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	//매입탭 그리드 스토어
	var directGridStore1 = Unilite.createStore('atx200ukrGridStore1',{
		model: 'Atx200ukrModel1',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'atx200ukrService.selectList2'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	//매출탭 그리드	스토어
	var directGridStore2 = Unilite.createStore('atx200ukrGridStore2',{
		model: 'Atx200ukrModel2',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'atx200ukrService.selectList4'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelFileDown = Unilite.createForm('FileDownForm', {
		url: CPATH+'/accnt/fileDown',
		colspan: 2,
		layout: {type: 'uniTable', columns: 1},
		height: 30,
		padding: '0 0 0 195',
		disabled:false,
		autoScroll: false,
		standardSubmit: true,  
		items:[/*{
			xtype: 'uniTextfield',
			name: 'data',
			hidden: true
		},*/{
			xtype: 'container',
			tdAttrs: {align: 'right'},
			layout: {type: 'uniTable', columns: 3},
			items:[{
			   width: 110,
		       xtype: 'button',
			   text: '파일저장',	
			   tdAttrs: {align: 'left', width: 115},
			   handler : function() {					
					var form = panelFileDown;
					form.setValue('BILL_DIV_CODE', panelSearch.getValue('BILL_DIV_CODE'));					
					form.setValue('PUB_DATE_FR', panelSearch.getField('PUB_DATE_FR').getStartDate());
					form.setValue('PUB_DATE_TO', panelSearch.getField('PUB_DATE_TO').getEndDate());
					form.setValue('WRITE_DATE', panelSearch.getValue('WRITE_DATE'));
					form.setValue('FILE_GUBUN', panelSearch.getValue('FILE_GUBUN'));
					
					var param = form.getValues();
					atx200ukrService.fnGetFileCheck(param, function(provider, response)  {
                       if(provider){
                           form.submit({
                            params: param,
                            success:function(comp, action)  {
                                
                            },
                            failure: function(form, action){
                                
                            }                   
                        }); 
                       }
                    });	
				}
			}]
		},{
			fieldLabel: '신고사업장',
			name:'BILL_DIV_CODE',	
			xtype: 'uniCombobox',
			comboType:'BOR120',
			comboCode	: 'BILL',
			hidden: true
		},{
			xtype:'uniTextfield',
			name: 'PUB_DATE_FR'
		},{
			xtype:'uniTextfield',
			name: 'PUB_DATE_TO'
		},{
			xtype: 'radiogroup',		            		
			fieldLabel: '제출구분',	
			colspan:2,
			hidden: true,
			items: [{
				boxLabel: '영리', 
				width: 70, 
				name: 'FILE_GUBUN',
				inputValue: 'Y'
			},{
				boxLabel : '비영리', 
				width: 70,
				name: 'FILE_GUBUN',
				inputValue: 'N',
				checked: true 
			}]
		},{			
			xtype: 'container',
			tdAttrs: {align: 'right'},
			layout: {type: 'uniTable', columns: 1},
			items:[panelFileDown]
		}]
	});
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
		    items: [{ 
				fieldLabel: '신고사업장',
				name:'BILL_DIV_CODE',	
				xtype: 'uniCombobox',
				comboType:'BOR120',
				comboCode	: 'BILL',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('BILL_DIV_CODE', newValue);
					}
				}
			},{ 
	        	fieldLabel: '계산서일',
				xtype: 'uniMonthRangefield',  
				startFieldName: 'PUB_DATE_FR',
				endFieldName: 'PUB_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank:false,
				startDD: 'first',
				endDD: 'last',
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('PUB_DATE_FR',newValue);			
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('PUB_DATE_TO',newValue);			    		
			    	}
			    }
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '제출구분',	
				items: [{
					boxLabel: '영리', 
					width: 70, 
					name: 'FILE_GUBUN',
					inputValue: 'Y'
				},{
					boxLabel : '비영리', 
					width: 70,
					name: 'FILE_GUBUN',
					inputValue: 'N',
					checked: true 
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('FILE_GUBUN').setValue(panelSearch.SALE);
					}
				}
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '구분',	
				items: [{
					boxLabel: '전자신고', 
					width: 70, 
					name: 'ELECTRIC',
					inputValue: '1',
					checked: true 
				}/*,{
					boxLabel : '디스켓신고', 
					width: 80,
					name: 'ELECTRIC',
					inputValue: '2'
				}*/],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('ELECTRIC').setValue(panelSearch.ELECTRIC);
					}
				}
			}/*,{
				fieldLabel: '신고구분',
				name:'ESS_INPUT',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'A067',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ESS_INPUT', newValue);
					}
				}
			},{
		 		fieldLabel: '작성일자',
		 		xtype: 'uniDatefield',
		 		name: 'WRITE_DATE',
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WRITE_DATE', newValue);
					}
				}
			},{
				fieldLabel: '회계담당자',
			 	xtype: 'uniTextfield',
			 	name: 'ACCOUNT_ANT',
			 	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ACCOUNT_ANT', newValue);
					}
				}
			}*/,{
				xtype: 'container',
				tdAttrs: {align: 'center'},
				layout: {type: 'uniTable', columns: 3},
				items:[{
				   width: 110,
			       xtype: 'button',
				   text: '파일저장',	
				   tdAttrs: {align: 'left', width: 115},
				   handler : function() {
					   var form = panelFileDown;
						form.setValue('BILL_DIV_CODE', panelSearch.getValue('BILL_DIV_CODE'));					
						form.setValue('PUB_DATE_FR', panelSearch.getField('PUB_DATE_FR').getStartDate());
						form.setValue('PUB_DATE_TO', panelSearch.getField('PUB_DATE_TO').getEndDate());
						form.setValue('WRITE_DATE', panelSearch.getValue('WRITE_DATE'));
						form.setValue('FILE_GUBUN', panelSearch.getValue('FILE_GUBUN'));
						
						var param = form.getValues();
						form.submit({						
							params: param,
							success:function(comp, action)	{
								
							},
							failure: function(form, action){
								
							}					
						});
				   }
			    }/*,{
				   width: 110,
			       xtype: 'button',
				   text: '공문및라벨',	
				   tdAttrs: {align: 'left', width: 115},
				   handler : function() {
				   
				   }
			    }*/]
			},{
				xtype:'uniTextfield',
				name: 'S_PUB_DATE_FR',
				hidden: true
			},{
				xtype:'uniTextfield',
				name: 'S_PUB_DATE_TO',
				hidden: true
			}]
		}]		
	});	//end panelSearch  
	
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {		
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 5, tableAttrs: {width: '100%'}},
		padding:'1 1 1 1',
		border:true,
    	items: [{
			fieldLabel: '신고사업장',
			name:'BILL_DIV_CODE',	
			xtype: 'uniCombobox',
			comboType:'BOR120',
			comboCode	: 'BILL',
			allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('BILL_DIV_CODE', newValue);
				}
			}
		},{ 
        	fieldLabel: '계산서일',
			xtype: 'uniMonthRangefield',  
			startFieldName: 'PUB_DATE_FR',
			endFieldName: 'PUB_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			startDD: 'first',
			endDD: 'last',
			allowBlank:false,
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('PUB_DATE_FR',newValue);			
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('PUB_DATE_TO',newValue);			    		
		    	}
		    }
		},{
			xtype: 'radiogroup',		            		
			fieldLabel: '제출구분',	
			colspan:2,
			items: [{
				boxLabel: '영리', 
				width: 70, 
				name: 'FILE_GUBUN',
				inputValue: 'Y'
			},{
				boxLabel : '비영리', 
				width: 70,
				name: 'FILE_GUBUN',
				inputValue: 'N',
				checked: true 
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.getField('FILE_GUBUN').setValue(panelSearch.SALE);
				}
			}
		},{			
			xtype: 'container',
			tdAttrs: {align: 'right'},
			layout: {type: 'uniTable', columns: 1},
			items:[panelFileDown]
		},{
			xtype: 'radiogroup',		            		
			fieldLabel: '구분',	
			items: [{
				boxLabel: '전자신고', 
				width: 70, 
				name: 'ELECTRIC',
				inputValue: '1',
				checked: true 
			}/*,{
				boxLabel : '디스켓신고', 
				width: 80,
				name: 'ELECTRIC',
				inputValue: '2'
			}*/],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.getField('ELECTRIC').setValue(panelSearch.ELECTRIC);
				}
			}
		}/*,{
			fieldLabel: '신고구분',
			name:'ESS_INPUT',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'A067',
			allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ESS_INPUT', newValue);
				}
			}
		},{
	 		fieldLabel: '작성일자',
	 		xtype: 'uniDatefield',
	 		name: 'WRITE_DATE',
	 		listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('WRITE_DATE', newValue);
				}
			}
		},{
			fieldLabel: '회계담당자',
		 	xtype: 'uniTextfield',
		 	name: 'ACCOUNT_ANT',
		 	listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ACCOUNT_ANT', newValue);
				}
			}
		}*/]
    });
    
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var detailForm1 = Unilite.createForm('atx200ukrDetail1', {
		title: '표지',	
		disabled :false
        , flex:1        
        , layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}}
        , defaults: {type: 'uniTextfield', labelWidth:140, width:600, readOnly:true}
		, items: [{
		    	fieldLabel: '자료구분',
			 	name: 'TYPE'			
			},{
		    	fieldLabel: '보고자 등록번호',
			 	name: 'COMPANY_NUM'
			},{
		    	fieldLabel: '보고자 상호',
			 	name: 'DIV_NAME'
			},{
		    	fieldLabel: '보고자 성명',
			 	name: 'REPRE_NAME'
			},{
		    	fieldLabel: '보고자사업장소재지',
			 	name: 'ADDR'
			},{
		    	fieldLabel: '보고자업태',
			 	name: 'COMP_TYPE'
			},{
		    	fieldLabel: '보고자업종',
			 	name: 'COMP_CLASS'
			},{
		    	fieldLabel: '거래기간',
			 	name: 'TERM'
			},{
		    	fieldLabel: '작성일자',
			 	name: 'MAKE_DATE'
		    }], 
		   api: {
         		 load: 'atx200ukrService.selectList1'				 				
			}
		});
    
    
    var masterGrid1 = Unilite.createGrid('atx200ukrGrid1', {
    	title: '매출',
    	layout : 'fit',
        store : directGridStore1, 
        uniOpt: {
		   expandLastColumn: false,
		   useRowNumberer: true,
		   useLiveSearch: true,
		      filter: {
		    useFilter: true,
		    autoCreate: true
		   }
		},
    	features: [{
    		id: 'masterGridSubTotal1',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal1', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
        columns: [        
        	{dataIndex: 'TYPE'				, width: 66,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '', '합계');
            	}
            }, 				
			{dataIndex: 'COMPANY_NUM'		, width: 100}, 				
			{dataIndex: 'SEQ'				, width: 66 }, 				
			{dataIndex: 'CUSTOM_NUM'		, width: 100}, 				
			{dataIndex: 'CUSTOM_NAME'		, width: 200}, 				
			{dataIndex: 'CUSTOM_TYPE'		, width: 120}, 				
			{dataIndex: 'CUSTOM_CLASS'		, width: 200}, 				
			{dataIndex: 'CNT'				, width: 66, summaryType: 'sum'}, 				
			{dataIndex: 'BLANK_CNT'			, width: 66},
			{dataIndex: 'SUPPLY_AMT'		, width: 100, summaryType: 'sum'}, 				
			{dataIndex: 'TAX_AMT'			, width: 100, summaryType: 'sum'}, 				
			{dataIndex: 'WHOLESALE_CODE'	, width: 100, align: 'center'}, 				
			{dataIndex: 'RETAIL_CODE'		, width: 100, align: 'center'},		
			{dataIndex: 'BOOK_NO'			, width: 66}, 				
			{dataIndex: 'SAFFER_TAX'		, minWidth: 66, flex: 1}
		]
    });
    
    var detailForm2 = Unilite.createForm('atx200ukrDetail2', {
			title: '매출합계',	
   			disabled :false
	        , flex:1        
	        , layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}}
	        , defaults: {type: 'uniTextfield', labelWidth:140, width:600, readOnly:true}
			,  items: [{
			    	fieldLabel: '자료구분',
				 	name: 'TYPE'
			    },{
			    	fieldLabel: '보고자 등록번호',
				 	name: 'COMPANY_NUM'
				},{
					name:'',	
					xtype: 'component',
					html:'합계분',
					tdAttrs: {style: 'border : 0px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;', align : 'center'}
		    	},{
			    	fieldLabel: '거래처수',
		    		xtype: 'uniNumberfield',
				 	name: 'CUSTOM_CNT'
				},{
			    	fieldLabel: '세금계산서매수',
				 	xtype: 'uniNumberfield',
				 	name: 'COMP_SLIP_CNT1'
				},{
			    	fieldLabel: '공급가액',
				 	xtype: 'uniNumberfield',
				 	name: 'SUPPLY_AMT'
				},{
			    	fieldLabel: '세액',
				 	xtype: 'uniNumberfield',
				 	name: 'TAX_AMT'
			    },{
					name:'',
					padding: '1 1 1 2',
					xtype: 'component',
					html:'사업자번호발행분&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;주민등록번호발행분',
					tdAttrs: {style: 'border : 0px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;', align : 'center'}
		    	},{
			 	 	xtype: 'container',
		   			defaultType: 'uniNumberfield',
					layout: {type: 'hbox', align:'stretch'},
					width:740,
					margin:0,
					items:[{
						fieldLabel:'거래처수', 
						name: 'COMP_CUSTOM_CNT', 
						width:370, 
						labelWidth:140,
						readOnly: true
					}, {
						name: 'PER_CUSTOM_CNT', 
						width:230,
						readOnly: true
					}]
				},{
			 	 	xtype: 'container',
		   			defaultType: 'uniNumberfield',
					layout: {type: 'hbox', align:'stretch'},
					width:740,
					margin:0,
					items:[{
						fieldLabel:'세금계산서매수', 
						name: 'COMP_SLIP_CNT2', 
						width:370, 
						labelWidth:140,
						readOnly: true
					}, {
						name: 'PER_SLIP_CNT', 
						width:230,
						readOnly: true
					}]
				},{
			 	 	xtype: 'container',
		   			defaultType: 'uniNumberfield',
					layout: {type: 'hbox', align:'stretch'},
					width:740,
					margin:0,
					items:[{
						fieldLabel:'공급가액', 
						name: 'COMP_SUPPLY_AMT', 
						width:370,  
						labelWidth:140,
						readOnly: true
					}, {
						name: 'PER_SUPPLY_AMT', 
						width:230,
						readOnly: true
					}]
				},{
			 	 	xtype: 'container',
		   			defaultType: 'uniNumberfield',
					layout: {type: 'hbox', align:'stretch'},
					width:740,
					margin:0,
					items:[{
						fieldLabel:'세액', 
						name: 'COMP_TAX_AMT', 
						width:370, 
						labelWidth:140,
						readOnly: true
					}, {
						name: 'PER_TAX_AMT', 
						width:230,
						readOnly: true
					}]
				}], 
			   api: {
	         		 load: 'atx200ukrService.selectList3'				 				
				}
			});
    
    var masterGrid2 = Unilite.createGrid('atx200ukrGrid2', {
    	title : '매입',
    	layout : 'fit',
        store : directGridStore2, 
        uniOpt: {
		   expandLastColumn: false,
		   useRowNumberer: true,
		   useLiveSearch: true,
		      filter: {
		    useFilter: true,
		    autoCreate: true
		   }
		},
    	features: [{
    		id: 'masterGridSubTotal2',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal2', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
        columns: [        
        	{dataIndex: 'TYPE'				, width: 66,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '', '합계');
            	} 
            }, 				
			{dataIndex: 'COMPANY_NUM'		, width: 100}, 				
			{dataIndex: 'SEQ'				, width: 66 }, 				
			{dataIndex: 'CUSTOM_NUM'		, width: 100}, 				
			{dataIndex: 'CUSTOM_NAME'		, width: 200}, 				
			{dataIndex: 'CUSTOM_TYPE'		, width: 120}, 				
			{dataIndex: 'CUSTOM_CLASS'		, width: 200}, 				
			{dataIndex: 'CNT'				, width: 66, summaryType: 'sum'}, 				
			{dataIndex: 'BLANK_CNT'			, width: 66},
			{dataIndex: 'SUPPLY_AMT'		, width: 100, summaryType: 'sum'}, 				
			{dataIndex: 'TAX_AMT'			, width: 100, summaryType: 'sum'}, 				
			{dataIndex: 'WHOLESALE_CODE'	, width: 100}, 				
			{dataIndex: 'RETAIL_CODE'		, width: 100},		
			{dataIndex: 'BOOK_NO'			, width: 66}, 				
			{dataIndex: 'SAFFER_TAX'		, width: 66}
		]
    });      
    
		
	var detailForm3 = Unilite.createForm('atx200ukrDetail3', {
		title: '매입합계',	
		disabled :false
	    , flex:1        
	    , layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}}
	    , defaults: {type: 'uniTextfield', labelWidth:140, width:600, readOnly:true}
		, items: [{
		    	fieldLabel: '자료구분',
			 	name: 'TYPE'			
			},{
		    	fieldLabel: '보고자 등록번호',
			 	name: 'COMPANY_NUM'
			},{
				xtype: 'uniNumberfield',
		    	fieldLabel: '거래처수',
			 	name: 'CUSTOM_CNT'
			},{
				xtype: 'uniNumberfield',
		    	fieldLabel: '세금계산서매수',
			 	name: 'SLIP_CNT'
			},{
				xtype: 'uniNumberfield',
		    	fieldLabel: '공급가액',
			 	name: 'SUPPLY_AMT'
			},{
				xtype: 'uniNumberfield',
		    	fieldLabel: '세액',
			 	name: 'TAX_AMT'
		    }], 
		   api: {
         		 load: 'atx200ukrService.selectList5'				 				
			}
		});
    
     var tab = Unilite.createTabPanel('tabPanel',{
    	region:'center',
	    items: [
	    	 detailForm1,
	         masterGrid1,
	         detailForm2,
	         masterGrid2,
	         detailForm3
	    ],
		listeners: {
        	tabchange: function( tabPanel, tab ) {
        		UniAppManager.app.onQueryButtonDown();
        	}
		}
    });
    
	Unilite.Main( {
	 	border: false,
		borderItems:[{
			region: 'center',
			layout: 'border',
			border: false,
			items:[
					tab, panelResult
				]
			},
			panelSearch  	
		],
		id : 'atx200ukrApp',
		fnInitBinding : function() {
			panelSearch.setValue('BILL_DIV_CODE',baseInfo.gsBillDivCode);
			panelResult.setValue('BILL_DIV_CODE',baseInfo.gsBillDivCode);
			//첫번째 탭 조회
			var param = panelSearch.getValues();
			param.PUB_DATE_FR = panelSearch.getField('PUB_DATE_FR').getStartDate();
			param.PUB_DATE_TO = panelSearch.getField('PUB_DATE_TO').getEndDate();
			detailForm1.getForm().load({
				params: param,
				success:function()	{
				},
				failure: function(form, action){
				}
			});
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('BILL_DIV_CODE');
		},
		onQueryButtonDown : function()	{		
			var activeTabId = tab.getActiveTab().getId();	
			var param = panelSearch.getValues();
			param.PUB_DATE_FR = panelSearch.getField('PUB_DATE_FR').getStartDate();
			param.PUB_DATE_TO = panelSearch.getField('PUB_DATE_TO').getEndDate();
			if(activeTabId == 'atx200ukrDetail1'){	
				Ext.getBody().mask('로딩중...','loading-indicator');
				detailForm1.getForm().load({
					params: param,
					success:function()	{
						Ext.getBody().unmask();
					},
					failure: function(form, action){
						Ext.getBody().unmask();
					}
				});
				
			}else if(activeTabId == 'atx200ukrGrid1'){				
				directGridStore1.loadStoreRecords();
				var view = masterGrid1.getView();
			    view.getFeature('masterGridSubTotal1').toggleSummaryRow(true);
			    view.getFeature('masterGridTotal1').toggleSummaryRow(true);
				
			}else if(activeTabId == 'atx200ukrDetail2'){	
				Ext.getBody().mask('로딩중...','loading-indicator');
				detailForm2.getForm().load({
					params: param,
					success:function()	{
						Ext.getBody().unmask();
					},
					failure: function(form, action){
						Ext.getBody().unmask();
					}
				});
			}
			else if(activeTabId == 'atx200ukrGrid2'){				
				directGridStore2.loadStoreRecords();
				var view = masterGrid2.getView();
			    view.getFeature('masterGridSubTotal2').toggleSummaryRow(true);
			    view.getFeature('masterGridTotal2').toggleSummaryRow(true);
				
			}else if(activeTabId == 'atx200ukrDetail3'){
				Ext.getBody().mask('로딩중...','loading-indicator');
				detailForm3.getForm().load({
					params: param,
					success:function()	{
						Ext.getBody().unmask();
					},
					failure: function(form, action){
						Ext.getBody().unmask();
					}
				});			
			}
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});
};


</script>
