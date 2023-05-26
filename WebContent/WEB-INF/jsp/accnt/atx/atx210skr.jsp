<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx210skr">
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {   
	var activeSForm; 
	
	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Atx210Model', {
	   fields: [
			{name: 'DIVI'				, text: '자료구분'					, type: 'string'},
			{name: 'COMPANY_NUM'		, text: '사업자등록번호'				, type: 'string'},
			{name: 'COMPANY_NAME'		, text: '상호'					, type: 'string'},
			{name: 'REPRE_NAME'			, text: '성명'					, type: 'string'},
			{name: 'ADDR'				, text: '사업장소재지'				, type: 'string'},
			{name: 'COMP_CLASS'			, text: '업태'					, type: 'string'},
			{name: 'COMP_TYPE'			, text: '종목'					, type: 'string'},
			{name: 'TERM'				, text: '거래기간'					, type: 'string'},
			{name: 'MAKE_DATE'			, text: '작성일자'					, type: 'string'},
			{name: 'SEQ'				, text: '일련번호'					, type: 'string'},
			{name: 'CUSTOM_REG_NUM'		, text: '거래자등록번호'				, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '거래자상호'					, type: 'string'},
			{name: 'CUSTOM_CLASS'		, text: '거래자업태'					, type: 'string'},
			{name: 'CUSTOM_TYPE'		, text: '거래자종목'					, type: 'string'},
			{name: 'CNT'				, text: '매수'					, type: 'string'},
			{name: 'BLANK_CNT'			, text: '공란수'					, type: 'string'},
			{name: 'SUPPLY_AMT_I'		, text: '공급가액'					, type: 'string'},
			{name: 'TAX_AMT_I'			, text: '세액'					, type: 'string'},
			{name: 'D_DRINK_CODE'		, text: '주류코드(도매)'				, type: 'string'},
			{name: 'S_DRINK_CODE'		, text: '주류코드(소매)'				, type: 'string'},
			{name: 'BOOK_NUM'			, text: '권번호'					, type: 'string'},
			{name: 'SUBMIT'				, text: '제출서'					, type: 'string'},
			{name: 'S_CUSTOM_CNT'		, text: '거래처수</br>(합계분)'		, type: 'string'},
			{name: 'S_CNT'				, text: '매수</br>(합계분)'			, type: 'string'},
			{name: 'S_SUPPLY_AMT_I'		, text: '공급가액</br>(합계분)'		, type: 'string'},
			{name: 'S_TAX_AMT_I'		, text: '세액</br>(합계분)'			, type: 'string'},
			{name: 'C_CUSTOM_CNT'		, text: '거래처수</br>(사업자번호)'		, type: 'string'},
			{name: 'C_CNT'				, text: '매수</br>(사업자번호)'		, type: 'string'},
			{name: 'C_SUPPLY_AMT_I'		, text: '공급가액</br>(사업자번호)'		, type: 'string'},
			{name: 'C_TAX_AMT_I'		, text: '세액</br>(사업자번호)'		, type: 'string'},
			{name: 'J_CUSTOM_CNT'		, text: '거래처수</br>(주민등록번호)'	, type: 'string'},
			{name: 'J_CNT'				, text: '매수</br>(주민등록번호)'		, type: 'string'},
			{name: 'J_SUPPLY_AMT_I'		, text: '공급가액</br>(주민등록번호)'	, type: 'string'},
			{name: 'J_TAX_AMT_I'		, text: '세액</br>(주민등록번호)'		, type: 'string'},
			{name: 'CUSTOM_CNT'			, text: '거래처수'					, type: 'string'}
	    ]
	});		// End of Ext.define('Atx210skrModel', {
	

	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('atx210MasterStore',{
		model: 'Atx210Model',
		uniOpt: {
            isMaster	: false,		// 상위 버튼 연결 
            editable	: false,		// 수정 모드 사용 
            deletable	: false,		// 삭제 가능 여부 
	        useNavi		: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'atx210skrService.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param		= activeSForm.getValues();
			param.filePath	= activeSForm.getValue('filePath');
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
          	load: function(store, records, successful, eOpts) {
				//조회된 데이터가 있을 때, 자료구분 값에 따라 그리드 세팅
				if(store.getCount() > 0){
					Ext.each(records, function(record, rowIndex){
						var rowData	= record.data;
						var lByte	= 0;
						
						if (rowData.substring(0, 1) == 7){														//표지
							//컬럼에 들어갈 데이터 변수 선언
							var DIVI = '', COMPANY_NUM = '', COMPANY_NAME = '', REPRE_NAME = '', ADDR = '', COMP_CLASS = '', COMP_TYPE = '', TERM = '', MAKE_DATE = '';

							for (j = 0; j < rowData.length; j++) {

								var sChr = Mid(rowData, j, 1);

								if (sChr >= ' ' && sChr <= '~') {
									lByte = lByte + 1;
								} else {
									lByte = lByte + 2;
								}
								
								if (lByte == 1) {
									DIVI = sChr;
									
								} else if (lByte >= 2 && lByte <= 11) {
									COMPANY_NUM = COMPANY_NUM + sChr;
									
								} else if (lByte >= 12 && lByte <= 41) {
									COMPANY_NAME = COMPANY_NAME + sChr;
									
								} else if (lByte >= 42 && lByte <= 56) {
									REPRE_NAME = REPRE_NAME + sChr;
									
								} else if (lByte >= 57 && lByte <= 101) {
									ADDR = ADDR + sChr;
									
								} else if (lByte >= 102 && lByte <= 118) {
									COMP_CLASS = COMP_CLASS + sChr;
									
								} else if (lByte >= 119 && lByte <= 143) {
									COMP_TYPE = COMP_TYPE + sChr;
									
								} else if (lByte >= 144 && lByte <= 155) {
									TERM = TERM + sChr;
									
								} else if (lByte >= 156 && lByte <= 161) {
									MAKE_DATE = MAKE_DATE + sChr;
									
								}
							}
				            var r = {
				            	DIVI		: DIVI,
				        	 	COMPANY_NUM : COMPANY_NUM,
				        	 	COMPANY_NAME: COMPANY_NAME,
				        	 	REPRE_NAME	: REPRE_NAME,
				        	 	ADDR		: ADDR,
				        	 	COMPANY_NUM	: COMPANY_NUM,
				        	 	COMP_CLASS	: COMP_CLASS,
				        	 	COMP_TYPE	: COMP_TYPE,
				        	 	TERM		: TERM,
				        	 	MAKE_DATE	: MAKE_DATE
				        	 	
					        };
							masterGrid.createRow(r);
							
						} else if (rowData.substring(0, 1) == 1) {														//매출
							//컬럼에 들어갈 데이터 변수 선언
							var DIVI = '', COMPANY_NUM = '', SEQ = '', CUSTOM_REG_NUM = '', CUSTOM_NAME = '', COMP_CLASS = '', COMP_TYPE = '', CNT = '', BLANK_CNT = '',
								SUPPLY_AMT_I = '', TAX_AMT_I = '', D_DRINK_CODE = '', S_DRINK_CODE = '', BOOK_NUM = '', SUBMIT = '';

							for (j = 0; j < rowData.length; j++) {

								var sChr = Mid(rowData, j, 1);

								if (sChr >= ' ' && sChr <= '~') {
									lByte = lByte + 1;
								} else {
									lByte = lByte + 2;
								}
								
								if (lByte == 1) {
									DIVI = sChr;
									
								} else if (lByte >= 2 && lByte <= 11) {
									COMPANY_NUM = COMPANY_NUM + sChr;
									
								} else if (lByte >= 12 && lByte <= 15) {
									SEQ = SEQ + sChr;
									
								} else if (lByte >= 16 && lByte <= 25) {
									CUSTOM_REG_NUM = CUSTOM_REG_NUM + sChr;
									
								} else if (lByte >= 26 && lByte <= 55) {
									CUSTOM_NAME = CUSTOM_NAME + sChr;
									
								} else if (lByte >= 56 && lByte <= 72) {
									COMP_CLASS = COMP_CLASS + sChr;
									
								} else if (lByte >= 73 && lByte <= 97) {
									COMP_TYPE = COMP_TYPE + sChr;
									
								} else if (lByte >= 98 && lByte <= 104) {
									CNT = CNT + sChr;
									
								} else if (lByte >= 105 && lByte <= 106) {
									BLANK_CNT = BLANK_CNT + sChr;
									
								} else if (lByte >= 107 && lByte <= 120) {
									SUPPLY_AMT_I = SUPPLY_AMT_I + sChr;
									
								} else if (lByte >= 121 && lByte <= 133) {
									TAX_AMT_I = TAX_AMT_I + sChr;
									
								} else if (lByte >= 134 && lByte <= 134) {
									D_DRINK_CODE = D_DRINK_CODE + sChr;
									
								} else if (lByte >= 135 && lByte <= 135) {
									S_DRINK_CODE = S_DRINK_CODE + sChr;
									
								} else if (lByte >= 136 && lByte <= 139) {
									BOOK_NUM = BOOK_NUM + sChr;
									
								} else if (lByte >= 140 && lByte <= 142) {
									SUBMIT = SUBMIT + sChr;
									
								}
							}
				            var r = {
								DIVI			: DIVI,
								COMPANY_NUM		: COMPANY_NUM,		
								SEQ				: SEQ,	
								CUSTOM_REG_NUM	: CUSTOM_REG_NUM,	
								CUSTOM_NAME		: CUSTOM_NAME,	
								COMP_CLASS		: COMP_CLASS,	
								COMP_TYPE		: COMP_TYPE,	
								CNT				: CNT,		
								BLANK_CNT		: BLANK_CNT,		
								SUPPLY_AMT_I	: SUPPLY_AMT_I,	
								TAX_AMT_I		: TAX_AMT_I,
								D_DRINK_CODE	: D_DRINK_CODE,
								S_DRINK_CODE	: S_DRINK_CODE,
								BOOK_NUM		: BOOK_NUM,
								SUBMIT			: SUBMIT
					        };
							masterGrid2.createRow(r);
							
						} else if (rowData.substring(0, 1) == 2) {														//매입
							//컬럼에 들어갈 데이터 변수 선언
							var DIVI = '', COMPANY_NUM = '', SEQ = '', CUSTOM_REG_NUM = '', CUSTOM_NAME = '', COMP_CLASS = '', COMP_TYPE = '', CNT = '', BLANK_CNT = '',
								SUPPLY_AMT_I = '', TAX_AMT_I = '', D_DRINK_CODE = '', S_DRINK_CODE = '', BOOK_NUM = '', SUBMIT = '';

							for (j = 0; j < rowData.length; j++) {

								var sChr = Mid(rowData, j, 1);

								if (sChr >= ' ' && sChr <= '~') {
									lByte = lByte + 1;
								} else {
									lByte = lByte + 2;
								}
								
								if (lByte == 1) {
									DIVI = sChr;
									
								} else if (lByte >= 2 && lByte <= 11) {
									COMPANY_NUM = COMPANY_NUM + sChr;
									
								} else if (lByte >= 12 && lByte <= 15) {
									SEQ = SEQ + sChr;
									
								} else if (lByte >= 16 && lByte <= 25) {
									CUSTOM_REG_NUM = CUSTOM_REG_NUM + sChr;
									
								} else if (lByte >= 26 && lByte <= 55) {
									CUSTOM_NAME = CUSTOM_NAME + sChr;
									
								} else if (lByte >= 56 && lByte <= 72) {
									COMP_CLASS = COMP_CLASS + sChr;
									
								} else if (lByte >= 73 && lByte <= 97) {
									COMP_TYPE = COMP_TYPE + sChr;
									
								} else if (lByte >= 98 && lByte <= 104) {
									CNT = CNT + sChr;
									
								} else if (lByte >= 105 && lByte <= 106) {
									BLANK_CNT = BLANK_CNT + sChr;
									
								} else if (lByte >= 107 && lByte <= 120) {
									SUPPLY_AMT_I = SUPPLY_AMT_I + sChr;
									
								} else if (lByte >= 121 && lByte <= 133) {
									TAX_AMT_I = TAX_AMT_I + sChr;
									
								} else if (lByte >= 134 && lByte <= 134) {
									D_DRINK_CODE = D_DRINK_CODE + sChr;
									
								} else if (lByte >= 135 && lByte <= 135) {
									S_DRINK_CODE = S_DRINK_CODE + sChr;
									
								} else if (lByte >= 136 && lByte <= 139) {
									BOOK_NUM = BOOK_NUM + sChr;
									
								} else if (lByte >= 140 && lByte <= 142) {
									SUBMIT = SUBMIT + sChr;
									
								}
							}
				            var r = {
								DIVI			: DIVI,
								COMPANY_NUM		: COMPANY_NUM,		
								SEQ				: SEQ,	
								CUSTOM_REG_NUM	: CUSTOM_REG_NUM,	
								CUSTOM_NAME		: CUSTOM_NAME,	
								COMP_CLASS		: COMP_CLASS,	
								COMP_TYPE		: COMP_TYPE,	
								CNT				: CNT,		
								BLANK_CNT		: BLANK_CNT,		
								SUPPLY_AMT_I	: SUPPLY_AMT_I,	
								TAX_AMT_I		: TAX_AMT_I,
								D_DRINK_CODE	: D_DRINK_CODE,
								S_DRINK_CODE	: S_DRINK_CODE,
								BOOK_NUM		: BOOK_NUM,
								SUBMIT			: SUBMIT
					        };
							masterGrid4.createRow(r);
							
						} else if (rowData.substring(0, 1) == 3) {														//매출합계
							//컬럼에 들어갈 데이터 변수 선언
							var DIVI = '', COMPANY_NUM = '', S_CUSTOM_CNT = '', S_CNT = '', SUPPLY_AMT_I = '', TAX_AMT_I = '', C_CUSTOM_CNT = '', C_CNT = '', C_SUPPLY_AMT_I = '',
								C_TAX_AMT_I = '', J_CUSTOM_CNT = '', J_CNT = '', J_SUPPLY_AMT_I = '', J_TAX_AMT_I = '';

							for (j = 0; j < rowData.length; j++) {

								var sChr = Mid(rowData, j, 1);

								if (sChr >= ' ' && sChr <= '~') {
									lByte = lByte + 1;
								} else {
									lByte = lByte + 2;
								}
								
								if (lByte == 1) {
									DIVI = sChr;
									
								} else if (lByte >= 2 && lByte <= 11) {
									COMPANY_NUM = COMPANY_NUM + sChr;
									
								} else if (lByte >= 12 && lByte <= 18) {
									S_CUSTOM_CNT = S_CUSTOM_CNT + sChr;
									
								} else if (lByte >= 19 && lByte <= 25) {
									S_CNT = S_CNT + sChr;
									
								} else if (lByte >= 26 && lByte <= 40) {
									SUPPLY_AMT_I = SUPPLY_AMT_I + sChr;
									
								} else if (lByte >= 41 && lByte <= 54) {
									TAX_AMT_I = TAX_AMT_I + sChr;
									
								} else if (lByte >= 55 && lByte <= 61) {
									C_CUSTOM_CNT = C_CUSTOM_CNT + sChr;
									
								} else if (lByte >= 62 && lByte <= 68) {
									C_CNT = C_CNT + sChr;
									
								} else if (lByte >= 69 && lByte <= 83) {
									C_SUPPLY_AMT_I = C_SUPPLY_AMT_I + sChr;
									
								} else if (lByte >= 84 && lByte <= 97) {
									C_TAX_AMT_I = C_TAX_AMT_I + sChr;
									
								} else if (lByte >= 98 && lByte <= 104) {
									J_CUSTOM_CNT = J_CUSTOM_CNT + sChr;
									
								} else if (lByte >= 105 && lByte <= 111) {
									J_CNT = J_CNT + sChr;
									
								} else if (lByte >= 112 && lByte <= 126) {
									J_SUPPLY_AMT_I = J_SUPPLY_AMT_I + sChr;
									
								} else if (lByte >= 127 && lByte <= 140) {
									J_TAX_AMT_I = J_TAX_AMT_I + sChr;
									
								}
							}
				            var r = {
								DIVI			: DIVI,
								COMPANY_NUM		: COMPANY_NUM,	
								S_CUSTOM_CNT	: S_CUSTOM_CNT,
								S_CNT			: S_CNT,
								SUPPLY_AMT_I	: SUPPLY_AMT_I,
								TAX_AMT_I		: TAX_AMT_I,
								C_CUSTOM_CNT	: C_CUSTOM_CNT,
								C_CNT			: C_CNT,
								C_SUPPLY_AMT_I	: C_SUPPLY_AMT_I,	
								C_TAX_AMT_I		: C_TAX_AMT_I,	
								J_CUSTOM_CNT	: J_CUSTOM_CNT,
								J_CNT			: J_CNT,
								J_SUPPLY_AMT_I	: J_SUPPLY_AMT_I,	
								J_TAX_AMT_I		: J_TAX_AMT_I
					        };
							masterGrid3.createRow(r);
							
						} else if (rowData.substring(0, 1) == 4) {														//매입합계
							//컬럼에 들어갈 데이터 변수 선언
							var DIVI = '', COMPANY_NUM = '', CUSTOM_CNT = '', CNT = '', SUPPLY_AMT_I = '', TAX_AMT_I = '';

							for (j = 0; j < rowData.length; j++) {

								var sChr = Mid(rowData, j, 1);

								if (sChr >= ' ' && sChr <= '~') {
									lByte = lByte + 1;
								} else {
									lByte = lByte + 2;
								}
								
								if (lByte == 1) {
									DIVI = sChr;
									
								} else if (lByte >= 2 && lByte <= 11) {
									COMPANY_NUM = COMPANY_NUM + sChr;
									
								} else if (lByte >= 12 && lByte <= 18) {
									CUSTOM_CNT = CUSTOM_CNT + sChr;
									
								} else if (lByte >= 19 && lByte <= 25) {
									CNT = CNT + sChr;
									
								} else if (lByte >= 26 && lByte <= 40) {
									SUPPLY_AMT_I = SUPPLY_AMT_I + sChr;
									
								} else if (lByte >= 41 && lByte <= 54) {
									TAX_AMT_I = TAX_AMT_I + sChr;
									
								} 
							}
				            var r = {
								DIVI			: DIVI,
								COMPANY_NUM		: COMPANY_NUM,	
								CUSTOM_CNT		: CUSTOM_CNT,
								CNT				: CNT,
								SUPPLY_AMT_I	: SUPPLY_AMT_I,
								TAX_AMT_I		: TAX_AMT_I
					        };
							masterGrid5.createRow(r);
						} 
					});
					masterStore1.commitChanges();
					masterStore2.commitChanges();
					masterStore3.commitChanges();
					masterStore4.commitChanges();
					masterStore5.commitChanges();
				}
			}          		
      	}/*,
		groupField: 'ITEM_NAME'*/
	});

	var masterStore1 = Unilite.createStore('atx210MasterStore1',{
		model: 'Atx210Model',
		uniOpt: {
            isMaster	: false,		// 상위 버튼 연결 
            editable	: false,		// 수정 모드 사용 
            deletable	: false,		// 삭제 가능 여부 
	        useNavi		: false			// prev | newxt 버튼 사용
        },
        autoLoad: false
	});
	
	var masterStore2 = Unilite.createStore('atx210MasterStore2',{
		model: 'Atx210Model',
		uniOpt: {
            isMaster	: false,		// 상위 버튼 연결 
            editable	: false,		// 수정 모드 사용 
            deletable	: false,		// 삭제 가능 여부 
	        useNavi		: false			// prev | newxt 버튼 사용
        },
        autoLoad: false
	});
	
	var masterStore3 = Unilite.createStore('atx210MasterStore3',{
		model: 'Atx210Model',
		uniOpt: {
            isMaster	: false,		// 상위 버튼 연결 
            editable	: false,		// 수정 모드 사용 
            deletable	: false,		// 삭제 가능 여부 
	        useNavi		: false			// prev | newxt 버튼 사용
        },
        autoLoad: false
	});
	
	var masterStore4 = Unilite.createStore('atx210MasterStore4',{
		model: 'Atx210Model',
		uniOpt: {
            isMaster	: false,		// 상위 버튼 연결 
            editable	: false,		// 수정 모드 사용 
            deletable	: false,		// 삭제 가능 여부 
	        useNavi		: false			// prev | newxt 버튼 사용
        },
        autoLoad: false
	});
	
	var masterStore5 = Unilite.createStore('atx210MasterStore5',{
		model: 'Atx210Model',
		uniOpt: {
            isMaster	: false,		// 상위 버튼 연결 
            editable	: false,		// 수정 모드 사용 
            deletable	: false,		// 삭제 가능 여부 
	        useNavi		: false			// prev | newxt 버튼 사용
        },
        autoLoad: false
	});
	
	/* 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        	activeSForm = panelResult;
	        },
	        expand: function() {
	        	panelResult.hide();
	        	activeSForm = panelSearch;
	        }
	    },
		items: [{	
			title	: '기본정보', 	
	   		itemId	: 'search_panel1',
	        layout	: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items	: [{
				fieldLabel	: '파일경로',
				name		: 'filePath',
	    		xtype		: 'filefield',
	    		width		: 300,
				allowBlank	: false,
			    listeners: {
					change : function( filefield, value, eOpts )	{
						if( value != '' )	{
							UniAppManager.setToolbarButtons('query', true);
						}
					}
			    }
			}]
		}]/*,
		setAllFieldsReadOnly: function(b) { 
		    var r= true
		    if(b) {
		    	var invalid = this.getForm().getFields().filterBy(function(field) {
		        	return !field.validate();
		        });                      
		        if(invalid.length > 0) {
		     		r=false;
		         	var labelText = ''
		     		if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
		          		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
		        	}
					alert(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}*/
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
    	items: [{
			fieldLabel	: '파일경로',
    		xtype		: 'filefield',
			name		: 'filePath',
    		width		: 400,
			allowBlank	: false,
		    listeners: {
				change : function( filefield, value, eOpts )	{
					if( value != '' )	{
						UniAppManager.setToolbarButtons('query',true);
					}
				}
		    }
		}]/*,
		setAllFieldsReadOnly: function(b) { 
		    var r= true
		    if(b) {
		    	var invalid = this.getForm().getFields().filterBy(function(field) {
		        	return !field.validate();
		        });                      
		        if(invalid.length > 0) {
		     		r=false;
		         	var labelText = ''
		     		if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
		          		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
		        	}
					alert(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}*/
	});
	
    /* Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('atx210Grid1', {
    	layout : 'fit',
        region : 'center',
        title: '표지',
		store: masterStore1,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
    	selModel:'rowmodel',						
		uniOpt : {						
			useMultipleSorting	: true,			
		    useLiveSearch		: true,			
		    onLoadSelectFirst	: true,				
		    dblClickToEdit		: false,			
		    useGroupSummary		: false,			
			useContextMenu		: false,		
			useRowNumberer		: true,		
			expandLastColumn	: true,			
			useRowContext		: false,		
		    filter: {					
				useFilter		: true,	
				autoCreate		: true	
			}				
		},					
        columns: [        
        	{dataIndex: 'DIVI'							, width: 66}, 
        	{dataIndex: 'COMPANY_NUM'					, width: 100}, 
        	{dataIndex: 'COMPANY_NAME'					, width: 133}, 
        	{dataIndex: 'REPRE_NAME'					, width: 100}, 
        	{dataIndex: 'ADDR'							, width: 266}, 
        	{dataIndex: 'COMP_CLASS'					, width: 120}, 
        	{dataIndex: 'COMP_TYPE'						, width: 120}, 
        	{dataIndex: 'TERM'							, width: 100}, 
        	{dataIndex: 'MAKE_DATE'						, width: 66}
		] 
    });    
    
    var masterGrid2 = Unilite.createGrid('atx210Grid2', {
    	layout : 'fit',
        region : 'center',
        title: '매출',
		store: masterStore2,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
    	selModel:'rowmodel',						
        columns: [        
        	{dataIndex: 'DIVI'						, width: 66}, 
        	{dataIndex: 'COMPANY_NUM'				, width: 100}, 
        	{dataIndex: 'SEQ'						, width: 66}, 
        	{dataIndex: 'CUSTOM_REG_NUM'			, width: 100}, 
        	{dataIndex: 'CUSTOM_NAME'				, width: 200}, 
        	{dataIndex: 'CUSTOM_CLASS'				, width: 120}, 
        	{dataIndex: 'CUSTOM_TYPE'				, width: 120}, 
        	{dataIndex: 'CNT'						, width: 66}, 
        	{dataIndex: 'BLANK_CNT'					, width: 66}, 
        	{dataIndex: 'SUPPLY_AMT_I'				, width: 100}, 
        	{dataIndex: 'TAX_AMT_I'					, width: 100}, 
        	{dataIndex: 'D_DRINK_CODE'				, width: 100}, 
        	{dataIndex: 'S_DRINK_CODE'				, width: 100}, 
        	{dataIndex: 'BOOK_NUM'					, width: 66}, 
        	{dataIndex: 'SUBMIT'					, width: 66}
		] 
    });    
    
    var masterGrid3 = Unilite.createGrid('atx210Grid3', {
    	layout : 'fit',
        region : 'center',
        title: '매출합계',
		store: masterStore3,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
    	selModel:'rowmodel',						
        columns: [        
        	{dataIndex: 'DIVI'							, width: 66},
        	{dataIndex: 'COMPANY_NUM'					, width: 100}, 
        	{dataIndex: 'S_CUSTOM_CNT'					, width: 100}, 
        	{dataIndex: 'S_CNT'							, width: 100}, 
        	{dataIndex: 'S_SUPPLY_AMT_I'				, width: 100}, 
        	{dataIndex: 'S_TAX_AMT_I'					, width: 100}, 
        	{dataIndex: 'C_CUSTOM_CNT'					, width: 100}, 
        	{dataIndex: 'C_CNT'							, width: 100}, 
        	{dataIndex: 'C_SUPPLY_AMT_I'				, width: 100}, 
        	{dataIndex: 'C_TAX_AMT_I'					, width: 100}, 
        	{dataIndex: 'J_CUSTOM_CNT'					, width: 100}, 
        	{dataIndex: 'J_CNT'							, width: 100}, 
        	{dataIndex: 'J_SUPPLY_AMT_I'				, width: 100}, 
        	{dataIndex: 'J_TAX_AMT_I'					, width: 100}
		] 
    });    
    
    var masterGrid4 = Unilite.createGrid('atx210Grid4', {
    	layout : 'fit',
        region : 'center',
        title: '매입',
		store: masterStore4,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
    	selModel:'rowmodel',						
        columns: [        
        	{dataIndex: 'DIVI'					, width: 66}, 
        	{dataIndex: 'COMPANY_NUM'			, width: 100}, 
        	{dataIndex: 'SEQ'					, width: 66}, 
        	{dataIndex: 'CUSTOM_REG_NUM'		, width: 100}, 
        	{dataIndex: 'CUSTOM_NAME'			, width: 200}, 
        	{dataIndex: 'CUSTOM_CLASS'			, width: 120}, 
        	{dataIndex: 'CUSTOM_TYPE'			, width: 120}, 
        	{dataIndex: 'CNT'					, width: 66}, 
        	{dataIndex: 'BLANK_CNT'				, width: 66}, 
        	{dataIndex: 'SUPPLY_AMT_I'			, width: 100}, 
        	{dataIndex: 'TAX_AMT_I'				, width: 100}, 
        	{dataIndex: 'D_DRINK_CODE'			, width: 100}, 
        	{dataIndex: 'S_DRINK_CODE'			, width: 100}, 
        	{dataIndex: 'BOOK_NUM'				, width: 66}, 
        	{dataIndex: 'SUBMIT'				, width: 66}
		] 
    });   
    
    var masterGrid5 = Unilite.createGrid('atx210Grid5', {
    	layout : 'fit',
        region : 'center',
        title: '매입합계',
		store: masterStore5,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
    	selModel:'rowmodel',						
        columns: [        
        	{dataIndex: 'DIVI'						, width: 66}, 
        	{dataIndex: 'COMPANY_NUM'				, width: 100}, 
        	{dataIndex: 'CUSTOM_CNT'				, width: 133}, 
        	{dataIndex: 'CNT'						, width: 133}, 
        	{dataIndex: 'SUPPLY_AMT_I'				, width: 150}, 
        	{dataIndex: 'TAX_AMT_I'					, width: 150}
		] 
    });   
    
    var tab = Unilite.createTabPanel('tabPanel',{
	    activeTab:  0,
	    region: 'center',
	    items:  [
	         masterGrid,
	         masterGrid2,
	         masterGrid3,
	         masterGrid4,
	         masterGrid5
	    ]
    });
    
	Unilite.Main( {
		borderItems	:[{
			region	:'center',
			layout	: 'border',
			border	: false,
			items	:[
					tab, panelResult
				]
			},
			panelSearch  	
		], 
		id : 'atx210skrApp',
		
		fnInitBinding : function() {
			//버튼 초기화
			UniAppManager.setToolbarButtons('query',	false);
			UniAppManager.setToolbarButtons('detail',	false);
			UniAppManager.setToolbarButtons('reset',	false);
			
			//최초 활성화 된 폼 확인
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
		},
		
		onQueryButtonDown : function()	{	
			masterGrid.reset();
			masterGrid2.reset();
			masterGrid3.reset();
			masterGrid4.reset();
			masterGrid5.reset();

			masterStore.loadStoreRecords();				
		}
	});
	
	function Mid(str, start, len) {																				//Mid 함수 구현
		// Make sure start and len are within proper bounds
	    if (start < 0 || len < 0) return "";
	    
	    var iEnd, iLen = String(str).length;
	    if (start + len > iLen) {
	          iEnd = iLen;
	    } else {
	          iEnd = start + len;
	    }
	    return String(str).substring(start, iEnd);
	};
};

</script>
