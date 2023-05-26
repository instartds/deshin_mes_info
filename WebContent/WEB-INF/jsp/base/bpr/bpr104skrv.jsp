<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr104skrv"  >	
<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->	
<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="bpr104skrvLevel1Store" />
<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="bpr104skrvLevel2Store" />
<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="bpr104skrvLevel3Store" />
<t:ExtComboStore comboType="AU" comboCode="B013" /><!-- 단위 -->
<t:ExtComboStore comboType="AU" comboCode="B059" /><!-- 세구분 -->
<t:ExtComboStore comboType="AU" comboCode="B010" /><!-- 단위 -->
<t:ExtComboStore comboType="AU" comboCode="B020" /><!-- 품목계정 -->
<t:ExtComboStore comboType="AU" comboCode="B014" /><!-- 조달구분 -->
<t:ExtComboStore comboType="AU" comboCode="B061" /><!-- 발주방침 -->
<t:ExtComboStore comboType="AU" comboCode="A003" /><!-- 매입매출 구분 -->
<t:ExtComboStore comboType="AU" comboCode="YP02" /><!-- 서가 -->
</t:appConfig>
<script type="text/javascript" > 

var BookLocationWindow; // 도서위치 안내도

function appMain() {     
	/**
	 *   Model 정의 
	 * @type  
	 */
	Unilite.defineModel('bpr104skrvModel', {
	    fields: [	 //BPR100T필수
			 { name: 'STOCK_UNIT',  			text: '<t:message code="system.label.base.inventoryunit" default="재고단위"/>', 		type : 'string', allowBlank: false, comboType:'AU', comboCode:'B013', displayField: 'value', defaultValue: 'EA' }      
	  		,{ name: 'TAX_TYPE',  				text: '<t:message code="system.label.base.taxtype" default="세구분"/>', 		type : 'string', allowBlank: false, comboType:'AU', comboCode:'B059' , defaultValue:'1'}
 	 		,{ name: 'ITEM_CODE',  				text: '도서코드', 		type : 'string', allowBlank:false, isPk:true, pkGen:'user',maxLength: 20}      
	  		,{ name: 'ITEM_NAME',  				text: '도서명', 		type : 'string', allowBlank: false, maxLength: 40}        
	  		,{ name: 'SPEC',  					text: '<t:message code="system.label.base.spec" default="규격"/>', 		type : 'string', maxLength: 160}
		    ,{ name: 'ITEM_LEVEL1',  			text: '<t:message code="system.label.base.majorgroup" default="대분류"/>', 		type : 'string', store: Ext.data.StoreManager.lookup('bpr104skrvLevel1Store'), child:'ITEM_LEVEL2'}        					       
		    ,{ name: 'ITEM_LEVEL2',  			text: '<t:message code="system.label.base.middlegroup" default="중분류"/>', 		type : 'string', store: Ext.data.StoreManager.lookup('bpr104skrvLevel2Store'), child:'ITEM_LEVEL3'}        
		    ,{ name: 'ITEM_LEVEL3',  			text: '<t:message code="system.label.base.minorgroup" default="소분류"/>', 		type : 'string', store: Ext.data.StoreManager.lookup('bpr104skrvLevel3Store')}
	  		,{ name: 'SALE_UNIT',  				text: '<t:message code="system.label.base.salesunit" default="판매단위"/>', 		type : 'string', comboType:'AU', comboCode:'B013', displayField: 'value', allowBlank: false, defaultValue: 'EA'}      
	  		,{ name: 'TRNS_RATE',  				text: '<t:message code="system.label.base.salespackednumber" default="판매입수"/>', 		type : 'uniUnitPrice', defaultValue:1.00, maxLength: 12}           
	  		,{ name: 'SALE_BASIS_P',  	 		text: '<t:message code="system.label.base.sellingprice" default="판매단가"/>', 		type : 'uniUnitPrice', maxLength: 18}
	  		,{ name: 'BF_SALE_BASIS_P',  		text: '이전단가', 		type : 'uniUnitPrice', maxLength: 18}			  		
	  		//BPR200T 필수                                 
	  		,{ name: 'DIV_CODE',  				text: '<t:message code="system.label.base.division" default="사업장"/>', 		type : 'string', maxLength: 80, allowBlank: false, comboType: 'BOR120'/*, multiSelect: true, typeAhead: false*/}
	  		,{ name: 'ITEM_ACCOUNT',  			text: '<t:message code="system.label.base.itemaccount" default="품목계정"/>', 		type : 'string', comboType:'AU', comboCode:'B020', maxLength: 80, allowBlank: false, defaultValue: '00'}
	  		,{ name: 'SUPPLY_TYPE',  			text: '<t:message code="system.label.base.procurementclassification" default="조달구분"/>', 		type : 'string', comboType:'AU', comboCode:'B014', maxLength: 80, allowBlank: false, defaultValue: '1' }			  		
	  		,{ name: 'ORDER_UNIT',  			text: '<t:message code="system.label.base.purchaseunit" default="구매단위"/>', 		type : 'string', comboType:'AU', comboCode:'B013', displayField: 'value', allowBlank: false, defaultValue: 'EA' }
	  		,{ name: 'WH_CODE',  				text: '기준창고', 		type : 'string', maxLength: 80, allowBlank: false, store: Ext.data.StoreManager.lookup('whList')}
	  		,{ name: 'ORDER_PLAN',  			text: '<t:message code="system.label.base.popolicy" default="발주방침"/>', 		type : 'string', comboType:'AU', comboCode:'B061', maxLength: 80, allowBlank: false, defaultValue:1}
	  		//BPR200T 일반                                 
	  		,{ name: 'BUY_RATE',  				text: '<t:message code="system.label.base.purchasereceiptcount" default="구매입수"/>', 		type : 'int', maxLength: 12, defaultValue:1}
	  		,{ name: 'LOCATION',  				text: 'Location', 	type : 'string', maxLength: 8}
	  		,{ name: 'MATRL_PRESENT_DAY',  		text: '올림기간', 		type : 'int', maxLength: 10} //자재올림
	  		,{ name: 'PURCHASE_BASE_P',  		text: '공통구매단가', 	type : 'uniUnitPrice', maxLength: 18}
	  		,{ name: 'CUSTOM_CODE',  			text: '기준거래처', 	type : 'string', maxLength: 8}
	  		,{ name: 'CUSTOM_NAME',  			text: '기준거래처명', 	type : 'string', maxLength: 20}
	  		//hidden                                     
	  		,{ name: 'ITEM_NAME1',  			text: '<t:message code="system.label.base.itemname" default="품목명"/>1', 		type : 'string', maxLength: 40}       
	  		,{ name: 'ITEM_NAME2',  			text: '<t:message code="system.label.base.itemname" default="품목명"/>2', 		type : 'string', maxLength: 40}
		    ,{ name: 'ITEM_GROUP',  			text: '<t:message code="system.label.base.repmodelcode" default="대표모델코드"/>',	type : 'string', maxLength: 20 }  
		    ,{ name: 'ITEM_GROUP_NAME',  		text: '<t:message code="system.label.base.repmodelname" default="대표모델명"/>', 	type : 'string', maxLength: 40}    
	  		,{ name: 'STOCK_CARE_YN',  			text: '<t:message code="system.label.base.inventorymanageobject" default="재고관리대상"/>', 	type : 'string', comboType:'AU', comboCode:'B010', defaultValue:'Y'}   
	  		,{ name: 'START_DATE',  			text: '<t:message code="system.label.base.usestartdate" default="사용시작일"/>', 	type : 'uniDate', defaultValue:new Date(),  maxLength: 10}    
	  		,{ name: 'STOP_DATE',  				text: '<t:message code="system.label.base.usestopdate" default="사용중단일"/>', 	type : 'uniDate', maxLength: 10}    
	  		,{ name: 'USE_YN',  				text: '<t:message code="system.label.base.photoflag" default="사진유무"/>', 		type : 'string', allowBlank: false, comboType:'AU', comboCode:'B010',defaultValue:'Y'}				    
		    ,{ name: 'SALE_COMMON_P',  			text: '시중가', 		type : 'uniUnitPrice', maxLength: 18, allowBlank: false}
		    ,{ name: 'AUTO_DISCOUNT',  			text: '자동할인여부', 	type : 'string', maxLength: 80, comboType:'AU', comboCode:'B010',defaultValue:'Y', allowBlank: false}
		    ,{ name: 'SPEC_CONTROL',  			text: '특정여부', 		type : 'string', maxLength: 80, comboType:'AU', comboCode:'B010',defaultValue:'N', allowBlank: false}
		    ,{ name: 'SPEC_CONTROL_CODE',	  	text: '특정코드', 		type : 'string', maxLength: 3}				    
	  		,{ name: 'EXCESS_RATE',  			text: '과출고허용률 ',	type : 'uniPercent', defaultValue:0.00,maxLength: 3}	
	  		,{ name: 'BOOK_LINK',  				text: '책소개링크 ',	type : 'string'}
	  		,{ name: 'ISBN_CODE',  				text: 'ISBN코드', 	type : 'string', maxLength: 20}
	  		,{ name: 'PUBLISHER_CODE',  		text: '출판사코드', 	type : 'string', maxLength: 8}
	  		,{ name: 'PUBLISHER',  				text: '출판사', 		type : 'string', maxLength: 50}
	  		,{ name: 'AUTHOR1',  				text: '저자1', 		type : 'string', maxLength: 30}
	  		,{ name: 'AUTHOR2',  				text: '저자2', 		type : 'string', maxLength: 30}
	  		,{ name: 'TRANSRATOR',  			text: '역자', 		type : 'string', maxLength: 30}
	  		,{ name: 'PUB_DATE',  				text: '초판발행일', 	type : 'uniDate', maxLength: 8}
	  		,{ name: 'BIN_NUM',  				text: '서가진열대번호', type : 'string', maxLength: 10}	
	  		,{ name: 'PROD_TYPE',  				text: '교재구분', 		type : 'string', maxLength: 80,defaultValue:'Y'}
	  		,{ name: 'FIRST_PURCHASE_DATE',   	text: '최초매입일 ', 	type : 'uniDate', maxLength: 10}
	  		,{ name: 'LAST_PURCHASE_DATE',    	text: '최종매입일 ', 	type : 'uniDate', maxLength: 10}
	  		,{ name: 'FIRST_SALES_DATE',      	text: '최초판매일 ', 	type : 'uniDate', maxLength: 10}
	  		,{ name: 'LAST_SALES_DATE',       	text: '최종판매일 ', 	type : 'uniDate', maxLength: 10}
	  		,{ name: 'LAST_RETURN_DATE',      	text: '최종반품일 ', 	type : 'uniDate', maxLength: 10}
	  		,{ name: 'LAST_DELIVERY_DATE',    	text: '최종납품일 ', 	type : 'uniDate', maxLength: 10}
	  		,{ name: 'LAST_DELIVERY_CUSTOM',  	text: '최종납품처 ', 	type : 'string' , maxLength: 10}
	  		,{ name: 'REMARK1',  				text: '비고1', 		type : 'string', maxLength: 300}
	  		,{ name: 'REMARK2',  				text: '비고2', 		type : 'string', maxLength: 300}
	  		,{ name: 'REMARK3',  				text: '비고3', 		type : 'string', maxLength: 300}
	  		,{ name: 'MONEY_UNIT',  			text: 'MONEY_UNIT', type : 'string', maxLength: 80}
	  		,{ name: 'SALE_DATE',  				text: 'SALE_DATE',  type : 'uniDate', maxLength: 10}
	  		,{ name: 'IMAGE_FID',  			text: '사진FID', 		type : 'string' } 		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('bpr104skrvMasterStore',{
		model: 'bpr104skrvModel',
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable:false,			// 삭제 가능 여부 
			useNavi : false			// prev | next 버튼 사용
	            	//비고(*) 사용않함
		},
        autoLoad: false,
        proxy: {
        	type: 'direct',
        	api: {			
            	read: 'bpr104skrvService.selectDetailList'                	
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
	var panelSearch = Unilite.createSearchPanel('searchForm',{          
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',         
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
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',   
			itemId: 'search_panel1',
			layout: {type: 'vbox', align: 'stretch'},
            items: [{
        		xtype: 'container',
        		layout: {type: 'uniTable', columns: 1},
        		items: [{
        			xtype: 'uniTextfield',
		            name: 'ITEM_CODE',  		
	    			fieldLabel: '도서코드',
	    			hidden: true
	    		},{ 
	    			xtype: 'uniTextfield',
	            	name: 'ITEM_NAME',  		
	            	fieldLabel: '도서명',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ITEM_NAME', newValue);
						}
					},
	    			hidden: true
	            },{ 
					fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
					name: 'DIV_CODE',
					xtype: 'uniCombobox',
					comboType: 'BOR120',
					allowBlank: false,
					readOnly: false
				},{
		        	fieldLabel: '<t:message code="system.label.base.searchitem" default="검색항목"/>' ,
		        	name:'TXTFIND_TYPE',
		        	xtype: 'uniCombobox',
		        	comboType:'AU',
		        	comboCode:'B052',
		        	value:'01'
		        },{
	            	fieldLabel: '<t:message code="system.label.base.searchword" default="검색어"/>',
	            	name: 'TXT_SEARCH' ,
	            	xtype: 'uniTextfield' 
	            }]
			}]			
    	},{
		 	title:'<t:message code="system.label.base.additionalinfo" default="추가정보"/>',
   			id: 'search_panel2',
			itemId:'search_panel2',
        	defaultType: 'uniTextfield',
        	layout: {type: 'uniTable', columns: 1},
		 	items: [{
		    	name: 'ITEM_LEVEL1',
    			fieldLabel: '<t:message code="system.label.base.majorgroup" default="대분류"/>',
    			xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('bpr104skrvLevel1Store'),
                child: 'ITEM_LEVEL2'
              },{
              	name: 'ITEM_LEVEL2',
              	fieldLabel: '<t:message code="system.label.base.middlegroup" default="중분류"/>',
              	xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('bpr104skrvLevel2Store'),
                child: 'ITEM_LEVEL3'
                
             },{
             	name: 'ITEM_LEVEL3',
             	fieldLabel: '<t:message code="system.label.base.minorgroup" default="소분류"/>',
             	xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('bpr104skrvLevel3Store')
            },{
	    		xtype: 'button',
	    		text: '도서위치 안내도',
	    		margin: '40 0 0 50',
	    		width: 200,
	    		scale: 'large',
	    		handler : function(records) {
	    			openBookLocationWindow();
	    		}
	    	}]
		}],
		listeners: {
		    afterrender: function( panel, eOpts ) {
		    	panel.expand();
		    }
		},
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

				   	Unilite.messageBox(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				}
	  		}
			return r;
  		}
	});		// end of var panelSearch = Unilite.createSearchPanel('bpr104skrvpanelSearch',{		// 메인
	
	var panelResult = Unilite.createSearchForm('resultForm',{
	    	region: 'north',
		    items: [{	
		    	xtype:'container',
		        defaultType: 'uniTextfield',
		        layout: {type: 'uniTable', columns : 2},
		        items: [{ 
					fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
					name: 'DIV_CODE',
					xtype: 'uniCombobox',
					comboType: 'BOR120',
					hidden: true
				},{ 
	    			xtype: 'uniTextfield',
	            	fieldLabel: '도서검색',
	            	name: 'ITEM_NAME',
	            	width: 400,
	            	margin: '25 0 20 350',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('ITEM_NAME', newValue);
						}
					}
	            },{ 
	    			xtype: 'button',
		    		text: '찾기',	
		    		margin: '21 0 20 350',
		    		width: 60,
		    		handler : function(records) {
		    			directMasterStore.loadStoreRecords();
		    		}
	            }]
		    }]
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
    
    var bookSearch = Unilite.createSimpleForm('bookSearchForm',{
    	
    });

    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
 	var masterGrid = Unilite.createGrid('bpr104skrvGrid1.RowExpander', {
			region: 'center' ,
		    layout : 'fit',
		    extend: 'Ext.grid.Panel',
		    xtype: 'row-expander-grid',
		    store : directMasterStore, 
		    uniOpt:{	
		    	expandLastColumn: true,
		    	useRowNumberer: false,
		        useMultipleSorting: false
		    },
		    columns:  [ 
		    	{ dataIndex: 'ITEM_CODE',  			  	width: 105},
        		{ dataIndex: 'ITEM_NAME',  			  	width: 200},
        		{ dataIndex: 'SALE_BASIS_P',  	 	  	width: 100},
        		{ dataIndex: 'ITEM_ACCOUNT',  		  	width: 145},
        		{ dataIndex: 'PUBLISHER',  				width: 80},
        		{ dataIndex: 'PUB_DATE',  	  			width: 80},
        		{ dataIndex: 'BIN_NUM',  	  			width: 100},
        		//hidden 
        		{ dataIndex: 'AUTHOR1',  	  			width: 80, hidden: true},
        		{ dataIndex: 'AUTHOR2',  	  			width: 80, hidden: true},
        		{ dataIndex: 'TRANSRATOR',    			width: 80, hidden: true},
        		{ dataIndex: 'SUPPLY_TYPE',  		  	width: 110, hidden: true},
        		{ dataIndex: 'ORDER_UNIT',  		  	width: 90, hidden: true},
        		{ dataIndex: 'WH_CODE',  			  	width: 160, hidden: true},
        		{ dataIndex: 'ORDER_PLAN',  		  	width: 100, hidden: true},
        		{ dataIndex: 'TAX_TYPE',  			  	width: 80, align: 'center', hidden: true},
        		{ dataIndex: 'SPEC',  				  	width: 90, hidden: true},
        		{ dataIndex: 'STOCK_UNIT',  		  	width: 90, hidden: true},
        		{ dataIndex: 'ITEM_LEVEL1',  		  	width: 120, hidden: true},
        		{ dataIndex: 'ITEM_LEVEL2',  		  	width: 120, hidden: true},
        		{ dataIndex: 'ITEM_LEVEL3',  		  	width: 120, hidden: true},
        		{ dataIndex: 'DIV_CODE',  			  	width: 130, hidden: true},
        		{ dataIndex: 'SALE_UNIT',  			  	width: 90, hidden: true},
        		{ dataIndex: 'TRNS_RATE',  			  	width: 80, hidden: true},         
        		{ dataIndex: 'ITEM_NAME1',  		    width: 140, hidden: true},
        		{ dataIndex: 'ITEM_NAME2',  		    width: 140, hidden: true},
        		{ dataIndex: 'ITEM_GROUP',  		  	width: 80, hidden: true},
				{ dataIndex: 'ITEM_GROUP_NAME',  	  	width: 80, hidden: true},	
        		{ dataIndex: 'STOCK_CARE_YN',  		  	width: 80, hidden: true},
        		{ dataIndex: 'START_DATE',  		  	width: 80, hidden: true},
        		{ dataIndex: 'STOP_DATE',  			  	width: 80, hidden: true},
        		{ dataIndex: 'USE_YN',  			  	width: 80, hidden: true},
        		{ dataIndex: 'SALE_COMMON_P',		  	width: 80, hidden: true},
        		{ dataIndex: 'AUTO_DISCOUNT',  		  	width: 80, hidden: true},
        		{ dataIndex: 'SPEC_CONTROL',  		  	width: 80, hidden: true},
        		{ dataIndex: 'SPEC_CONTROL_CODE',	  	width: 80, hidden: true},
        		{ dataIndex: 'EXCESS_RATE',  		  	width: 80, hidden: true},
        		{ dataIndex: 'BOOK_LINK',  		  		width: 80, hidden: true},
        		{ dataIndex: 'ISBN_CODE',  			  	width: 80, hidden: true},
        		{ dataIndex: 'PUBLISHER_CODE',  		width: 80, hidden: true},
        		{ dataIndex: 'PROD_TYPE',  	  			width: 80, hidden: true},
        		{ dataIndex: 'FIRST_PURCHASE_DATE',   	width: 80, hidden: true},
        		{ dataIndex: 'LAST_PURCHASE_DATE',    	width: 80, hidden: true},
        		{ dataIndex: 'FIRST_SALES_DATE',      	width: 80, hidden: true},
        		{ dataIndex: 'LAST_SALES_DATE',       	width: 80, hidden: true},
        		{ dataIndex: 'LAST_RETURN_DATE',      	width: 80, hidden: true},
        		{ dataIndex: 'LAST_DELIVERY_DATE',    	width: 80, hidden: true},
        		{ dataIndex: 'LAST_DELIVERY_CUSTOM',  	width: 80, hidden: true},
        		{ dataIndex: 'BUY_RATE',  			  	width: 80, hidden: true},
        		{ dataIndex: 'LOCATION',  			  	width: 80, hidden: true},
				{ dataIndex: 'MATRL_PRESENT_DAY',  	  	width: 80, hidden: true},
				{ dataIndex: 'PURCHASE_BASE_P',  	  	width: 80, hidden: true},
				{ dataIndex: 'CUSTOM_CODE',  		  	width: 80, hidden: true},
				{ dataIndex: 'CUSTOM_NAME',  		  	width: 80, hidden: true},
				{ dataIndex: 'REMARK1',  			  	width: 80, hidden: true},
				{ dataIndex: 'REMARK2',  			  	width: 80, hidden: true},
				{ dataIndex: 'REMARK3',  			  	width: 80, hidden: true},
				{ dataIndex: 'BF_SALE_BASIS_P',  		width: 80, hidden: true},
				{ dataIndex: 'MONEY_UNIT',		  		width: 80, hidden: true},
				{ dataIndex: 'SALE_DATE',		  		width: 80, hidden: true}         
          ],
          plugins: [{
	        ptype: 'rowexpander',
	        xtype: 'layout-column',
	        layout: 'column',
	        rowBodyTpl : new Ext.XTemplate(
	        	'<p><b>책사진: </b> <image src="'+CPATH+'/fileman/view/{IMAGE_FID}" > <b>, 책이름: </b> {ITEM_NAME} <b>, 출판사: </b> {PUBLISHER} <b>, 책소개링크: </b> {BOOK_LINK}</p>',
	            '<p><b>서가진열대번호: </b> {BIN_NUM} <b>, ISBN코드: </b> {TRANSRATOR} <b>, 품명1: </b> {ITEM_NAME1} <b>, 품명2: </b> {ITEM_NAME2}</p>',
	            '<p><b>역자: </b> {TRANSRATOR} <b>, 저자1: </b> {AUTHOR1} <b>, 저자2: </b> {AUTHOR2}</p>',
	            '<p><b>판매단가: </b> {SALE_BASIS_P} <b>, 시중가: </b> {SALE_COMMON_P}</p>', 
	            '<p><b>규격: </b> {SPEC} <b>, 대분류: </b> {ITEM_LEVEL1} <b>, 중분류: </b> {ITEM_LEVEL2} <b>, 소분류: </b> {ITEM_LEVEL3}</p>'
//	        	{
//	            	formatChange: function(v) {
//	             	   var color = v >= 0 ? 'green' : 'red';
//	              	  return '<span style="color: ' + color + ';">' + '<t:message code="system.label.base.photo" default="사진"/>' + '</span>';
//	            	}
//	        	}
	        )
	    }],
	    title: '도서정보 목록',
	    iconCls: 'icon-grid'
	});
	
	function openBookLocationWindow() {
		if(!BookLocationWindow) {
			BookLocationWindow = Ext.create('widget.uniDetailWindow', {
				title: '도서위치 안내도',
                width: 830,				                
                height: 580,
                tbar:  [
                	{
                		text: '닫기',
						handler: function() {
							BookLocationWindow.hide();
						},
						disabled: false
					}
                ]
			});
		}
	}
    
    /**
     * Master Grid2 정의(Grid Panel)
     * @type 
     */
    
	Unilite.Main ({
		borderItems: [{
	        region: 'center',
	        layout: 'border',
	        border: false,
	        items:[
	          	panelResult, masterGrid
	        ]
      	},
      	panelSearch  
      	],
      	fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			//UniAppManager.setToolbarButtons(['reset', 'deleteAll', 'prev', 'next'], true);
		}
  });
};
</script>
