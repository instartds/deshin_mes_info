<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite_app_bok100skrv");
%>
<t:appConfig pgmId="bok100skrv"  >
</t:appConfig>
<script type="text/javascript">
function appMain() {

	Unilite.defineModel('${PKGNAME}model', {
	    fields: [	 //BPR100T필수
					 { name: 'STOCK_UNIT',  			text: '재고단위', 		type : 'string', allowBlank: false, comboType:'AU', comboCode:'B013', displayField: 'value', defaultValue: 'EA' }      
			  		,{ name: 'TAX_TYPE',  				text: '세구분', 		type : 'string', allowBlank: false, comboType:'AU', comboCode:'B059' , defaultValue:'1'}
    	 	 		,{ name: 'ITEM_CODE',  				text: '품목코드', 		type : 'string', allowBlank:false, isPk:true, pkGen:'user',maxLength: 20}      
			  		,{ name: 'ITEM_NAME',  				text: '품목명', 		type : 'string', allowBlank: false, maxLength: 40}        
			  		
			  		,{ name: 'SPEC',  					text: '규격', 		type : 'string', maxLength: 160}
				    ,{ name: 'ITEM_LEVEL1',  			text: '대분류', 		type : 'string', store: Ext.data.StoreManager.lookup('bpr102ukrvLevel1Store'), child:'ITEM_LEVEL2'}        					       
				    ,{ name: 'ITEM_LEVEL2',  			text: '중분류', 		type : 'string', store: Ext.data.StoreManager.lookup('bpr102ukrvLevel2Store'), child:'ITEM_LEVEL3'}        
				    ,{ name: 'ITEM_LEVEL3',  			text: '소분류', 		type : 'string', store: Ext.data.StoreManager.lookup('bpr102ukrvLevel3Store')}
			  		,{ name: 'SALE_UNIT',  				text: '판매단위', 		type : 'string', comboType:'AU', comboCode:'B013', displayField: 'value', allowBlank: false, defaultValue: 'EA'}      
			  		,{ name: 'TRNS_RATE',  				text: '판매입수', 		type : 'uniUnitPrice', defaultValue:1.00, maxLength: 12}           
			  		,{ name: 'SALE_BASIS_P',  	 		text: '판매단가', 		type : 'string', maxLength: 18, convert:function(v) {return UniDate.safeFormat(v)}}
			  		,{ name: 'BF_SALE_BASIS_P',  		text: '이전단가', 		type : 'uniPrice', maxLength: 18}			  		
			  		
			  		//BPR200T 필수
			  		,{ name: 'DIV_CODE',  				text: '사업장', 		type : 'string', maxLength: 80, allowBlank: false, comboType: 'BOR120'/*, multiSelect: true, typeAhead: false*/}
			  		,{ name: 'ITEM_ACCOUNT',  			text: '품목계정', 		type : 'string', comboType:'AU', comboCode:'B020', maxLength: 80, allowBlank: false, defaultValue: '00'}
			  		,{ name: 'SUPPLY_TYPE',  			text: '조달구분', 		type : 'string', comboType:'AU', comboCode:'B014', maxLength: 80, allowBlank: false, defaultValue: '1' }			  		
			  		,{ name: 'ORDER_UNIT',  			text: '구매단위', 		type : 'string', comboType:'AU', comboCode:'B013', displayField: 'value', allowBlank: false, defaultValue: 'EA' }
			  		,{ name: 'WH_CODE',  				text: '기준창고', 		type : 'string', maxLength: 80, allowBlank: false, store: Ext.data.StoreManager.lookup('whList')}
			  		,{ name: 'ORDER_PLAN',  			text: '발주방침', 		type : 'string', comboType:'AU', comboCode:'B061', maxLength: 80, allowBlank: false, defaultValue:1}
			  		
			  		//BPR200T 일반
			  		,{ name: 'BUY_RATE',  				text: '구매입수', 		type : 'int', maxLength: 12, defaultValue:1}
			  		,{ name: 'LOCATION',  				text: 'Location', 	type : 'string', maxLength: 8}
			  		,{ name: 'MATRL_PRESENT_DAY',  		text: '올림기간', 		type : 'int', maxLength: 10} //자재올림
			  		,{ name: 'PURCHASE_BASE_P',  		text: '공통구매단가', 	type : 'uniPrice', maxLength: 18}
			  		,{ name: 'CUSTOM_CODE',  			text: '기준거래처', 	type : 'string', maxLength: 8}
			  		,{ name: 'CUSTOM_NAME',  			text: '기준거래처명', 	type : 'string', maxLength: 20}
			  		
			  		
			  		
			  		
			  		//hidden
			  		,{ name: 'ITEM_NAME1',  			text: '품목명1', 		type : 'string', maxLength: 40}       
			  		,{ name: 'ITEM_NAME2',  			text: '품목명2', 		type : 'string', maxLength: 40}
				    ,{ name: 'ITEM_GROUP',  			text: '대표모델코드',	type : 'string', maxLength: 20 }  
				    ,{ name: 'ITEM_GROUP_NAME',  		text: '대표모델명', 	type : 'string', maxLength: 40}    
			  		,{ name: 'STOCK_CARE_YN',  			text: '재고관리대상', 	type : 'string', comboType:'AU', comboCode:'B010', defaultValue:'Y'}   
			  		,{ name: 'START_DATE',  			text: '사용시작일', 	type : 'uniDate', defaultValue:new Date(),  maxLength: 10}    
			  		,{ name: 'STOP_DATE',  				text: '사용중단일', 	type : 'uniDate', maxLength: 10}    
			  		,{ name: 'USE_YN',  				text: '사용유무', 		type : 'string', allowBlank: false, comboType:'AU', comboCode:'B010',defaultValue:'Y'}				    
				    ,{ name: 'SALE_COMMON_P',  			text: '시중가', 		type : 'uniPrice', maxLength: 18, allowBlank: false}
				    ,{ name: 'AUTO_DISCOUNT',  			text: '자동할인여부', 	type : 'string', maxLength: 80, comboType:'AU', comboCode:'B010',defaultValue:'Y', allowBlank: false}
				    ,{ name: 'SPEC_CONTROL',  			text: '특정여부', 		type : 'string', maxLength: 80, comboType:'AU', comboCode:'B010',defaultValue:'N', allowBlank: false}
				    ,{ name: 'SPEC_CONTROL_CODE',	  	text: '특정코드', 		type : 'string', maxLength: 3}				    
			  		,{ name: 'EXCESS_RATE',  			text: '과출고허용률 ',	type : 'uniPercent', defaultValue:0.00,maxLength: 3}	
			  		,{ name: 'BOOK_LINK',  				text: '책소개링크 ',	type : 'string'}
			  		
			  		,{ name: 'ISBN_CODE',  				text: 'ISBN코드', 	type : 'string', maxLength: 20}
			  		,{ name: 'PUBLISHER_CODE',  		text: '출판사코드', 	type : 'string', maxLength: 8}
			  		,{ name: 'PUBLISHER',  				text: '출판사', 		ype : 'string', maxLength: 50}
			  		,{ name: 'AUTHOR1',  				text: '저자1', 		type : 'string', maxLength: 30}
			  		,{ name: 'AUTHOR2',  				text: '저자2', 		type : 'string', maxLength: 30}
			  		,{ name: 'TRANSRATOR',  			text: '역자', 		type : 'string', maxLength: 30}
			  		,{ name: 'PUB_DATE',  				text: '초판발행일', 	type : 'string', convert:function(v) {return UniDate.safeFormat(v)}}
			  		,{ name: 'BIN_NUM',  				text: '서가진열대번호', type : 'string', maxLength: 10}
			  		,{ name: 'BIN_FLOOR',  				text: '진열대', 		type : 'string', maxLength: 2 }//bpr100t 추가
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
		]
	});
	
	var masterStore =  Unilite.createStore('${PKGNAME}store',{
        model: '${PKGNAME}model',
         autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                	   read : 'bpr102ukrvService.selectDetailList'
                }
            } ,
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}searchForm');
				var param= searchForm.getValues();
				
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			}
		});
	
		var detailStore =  Unilite.createStore('${PKGNAME}store',{
        	model: '${PKGNAME}model',
         	autoLoad: false
         	
		});
    var detailViewTplTemplate = new Ext.XTemplate(
	    '<table cellspacing="0" cellpadding="2" style="border: #99bce8 solid 1px;" class="noselect"  width="900">' ,
		 '<tpl for=".">' ,
				'<tr>',
				'	<td width="100">제목 </td>' ,
				 '	<td>{ITEM_NAME} </td>' ,
				 '</tr>',
				 '<tr>',
				 '	<td>저자/출판 </td>' ,
	             '	<td>{AUTHOR1} {AUTHOR2} {TRANSRATOR} | {PUBLISHER} | {PUB_DATE}</td>',
	             '</tr>',
	             '<tr>',
	              '	<td>ISBN </td>' ,
	             '	<td>{ISBN_CODE}</td>',
	             '</tr>',
				 '<tr>',
				  '	<td>가격 </td>' ,
				 '	<td>{SALE_COMMON_P} -> {SALE_BASIS_P}</td>',
				 '</tr>',
				 '<tr>',
				  '	<td>서가위치 </td>' ,
				 '	<td>{BIN_NUM} / {BIN_FLOOR}</td>',
				 '</tr>',
        '</tpl>' ,
        '</table>'
	);
	var detailView = Ext.create('Ext.view.View', {	//UniDropView
    	region:'north',
    	autoScroll: true,
    	weight:-100,
		tpl: detailViewTplTemplate,
        store: detailStore,
        style:'background-color: #fff',
        singleSelect: true,
        height:150,
        itemSelector: 'div.data-source',
	    overItemCls: 'data-over',//'data-over',
	    selectedItemClass: 'data-selected'
	})
	
	 var masterViewTplTemplate = new Ext.XTemplate(
	 	'<table cellspacing="0" cellpadding="0" width="900" border="0">',
	 	'<tr>',
	 	'	<td><img src="'+CPATH+'/resources/images/prev_image.png"  width="50" height="100"/><td>',
	 	'	<td height="200"><div style="width:1000px;overflow-x:auto;">',
	 	'<table cellspacing="2" cellpadding="0" width="800" border="0">',
	 	'<tr>',
	 	'<tpl for=".">' ,
		'	<td valign="top">',
	 	 '	<div class="data-source" style="width:200;padding: 0 !important;border:solid 0px #bbbbbb;overflow:auto;float: left;">',
	            '<table cellspacing="0" cellpadding="10" width="200" border="0">',
				'<tr>',
				 '	<td ><strong>{ITEM_NAME}</strong></td>' ,
				 '</tr>',
				 '<tr>',
	             '	<td >{AUTHOR1} {AUTHOR2} {TRANSRATOR} | {PUBLISHER} | {PUB_DATE}</td>',
	             '</tr>',
	             
				 '<tr>',
				 '	<td >{SALE_COMMON_P} -> {SALE_BASIS_P}</td>',
				 '</tr>',
				 '<tr>',
				 '	<td >{BIN_NUM} / {BIN_FLOOR}</td>',
				 '</tr>',
				 '</table>',
		'</div>',
		'	</td>',
        '</tpl>' ,
        '</tr>',
		'</table>',
        '</div></td>',
        '	<td><img src="'+CPATH+'/resources/images/next_image.png" width="50" height="100"/><td>',
        '</tr></table>',
        {
        	showArrow: function(show)	{
        		
        	}
        }
	);
	var masterView = Ext.create('Ext.view.View', {	//UniDropView
    	region:'center',
    	flex: 1,
    	autoScroll: true,
		tpl: masterViewTplTemplate,
        store: masterStore,
        style:'background-color: #fff',
        itemSelector: 'div.data-source',
	    overItemCls: 'data-over',
	    selectedItemClass: 'data-selected',
	    border:true,
	    listeners:{
	    	select:function( view, record, eOpts )	{
	    		console.log(" detailStore record :",record);
	    		detailStore.loadData([record.data]);
	    	}
	    }
	})
	
	Ext.create('Ext.data.Store', {
		storeId:'BOOK_GUBUN',
	    fields: ['text', 'value'],
	    data : [
	        {text:"도서검색",   value:"G"},
	        {text:"교재검색", 	value:"R"}
	    ]
	});
	
	var panelResult = Unilite.createSearchForm('${PKGNAME}searchForm',{
    	region: 'north',
    	height: 50,
		layout : {type : 'uniTable', columns : 3, tableAttrs:{ height:50, valign:'middle'}},
		padding:0,
		border:false,
		items: [{
			xtype:'component',
			html:'&nbsp;',
			width:600
		},{ 
			hideLabel:true,
			name: 'BOOK_GUBUN',
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('BOOK_GUBUN'),
			allowBlank: false,
			width:100,
			value:'G',
			listeners:{
				change:function(field, newValue, oldValue, eOpts)	{
					if(newValue == "R")	{
						panelSearch.getField('BOOK_SEARCH').hide();
						panelSearch.getField('REF_SEARCH').show();
					}else {
						panelSearch.getField('REF_SEARCH').hide();
						panelSearch.getField('BOOK_SEARCH').show();
					}
				}
			}
		},{ 
			hideLabel:true,
			name: 'ITEM_NAME',
			width:300,
			triggers:{
				popup:{
					cls :'x-form-search-trigger',
					handler:function()	{
						UniAppManager.app.onQueryButtonDown();
					}
				}
			}
		},{
			name:'DIV_CODE',
			value: UserInfo.divCode,
			hidden:true
		}/*,{
			xtype:'button',
			text:'검색',
			handler:function()	{
				UniAppManager.app.onQueryButtonDown();
			}
		}*/]	
    });
    
    var panelSearch = Unilite.createSearchForm('${PKGNAME}searchForm1',{
    	region: 'west',
    	width: 250,
		layout : {type : 'vbox', columns : 1},
		padding:'0 0 0 0',
		border:false,
		items: [{
				xtype:'fieldset',
				margin:'10 0 0 10',
				defaultType:'uniTextfield',
				layout : {type : 'uniTable', columns : 2, tableAttrs:{align:'center',valign:'middle'}},
				items:[{
						xtype:'component',
						html:'<strong>결과내 검색</strong>',
						colspan:2
				},{ 
					hideLabel:true,
					name: 'ITEM_NAME'
				},{
					name:'DIV_CODE',
					value: UserInfo.divCode,
					hidden:true
				},{
					xtype:'button',
					text:'검색',
					
					handler:function()	{
						UniAppManager.app.onQueryButtonDown();
					}
				},{
					xtype:'container',
					itemId : 'BOOK_SEARCH',
					colspan:2,
					items:[{
						xtype:'uniCheckboxgroup',
						name : 'BOOK_SEARCH',
						layout:{type : 'uniTable', columns : 1},
						items:[
							{
			                    boxLabel  : '제목',
			                    name      : 'BOOK_SEARCH',
			                    inputValue: 'ITEM_NAME'
			                },{
			                    boxLabel  : '저자',
			                    name      : 'BOOK_SEARCH',
			                    inputValue: 'AUTHOR'
			                },{
			                    boxLabel  : '출판사',
			                    name      : 'BOOK_SEARCH',
			                    inputValue: 'PUBLISHER'
			                },{
			                    boxLabel  : 'ISBN',
			                    name      : 'BOOK_SEARCH',
			                    inputValue: 'ISBN'
			                }
						]
						
					}]
					
				},{
					xtype:'container',
					itemId : 'REF_SEARCH',
					colspan:2,
					
					items:[{
						xtype:'uniCheckboxgroup',
						layout:{type : 'uniTable', columns : 1},
						name : 'REF_SEARCH',
						hidden: true,
						items:[
							{
			                    boxLabel  : '제목',
			                    name      : 'REF_SEARCH',
			                    inputValue: 'ITEM_NAME'
			                },{
			                    boxLabel  : '학과',
			                    name      : 'REF_SEARCH',
			                    inputValue: 'MAJOR'
			                },{
			                    boxLabel  : '담당교수',
			                    name      : 'REF_SEARCH',
			                    inputValue: 'MAJOR'
			                },{
			                    boxLabel  : '저자',
			                    name      : 'REF_SEARCH',
			                    inputValue: 'AUTHOR'
			                },{
			                    boxLabel  : '출판사',
			                    name      : 'REF_SEARCH',
			                    inputValue: 'PUBLISHER'
			                },{
			                    boxLabel  : 'ISBN',
			                    name      : 'REF_SEARCH',
			                    inputValue: 'ISBN'
			                }
						]
					}]
				}
			]	
    	}]
    });
					
      Unilite.Main({
		borderItems:[
			panelResult,
			panelSearch,
			detailView, 
			masterView
			 
		],
		id  : '${PKGNAME}ukrApp',
		autoButtonControl : false,
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons(['print', 'newData','excel'], false);
			UniAppManager.setToolbarButtons(['reset'], true);
		},
		
		onQueryButtonDown : function()	{
			masterStore.loadStoreRecords();
		},
		onPrevDataButtonDown:  function()	{
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function()	{
			masterGrid.selectNextRow();
		},	
		onNewDataButtonDown:  function()	{
			masterGrid.createRow();
		},	
		
		onSaveDataButtonDown: function (config) {
			masterStore.saveStore();
					
		},
		onDeleteDataButtonDown : function()	{
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();				
			}
		},
		onResetButtonDown:function() {
			var me = this;
			panelSearch.reset();
			masterGrid.reset();
			UniAppManager.setToolbarButtons('save',false);
		},
		onSaveAsExcelButtonDown: function() {
			 masterGrid.downloadExcelXml();
		}
	});
	
}; // main
  
</script>