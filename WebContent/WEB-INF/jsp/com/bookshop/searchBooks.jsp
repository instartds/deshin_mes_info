<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "5.1.0");

	boolean isDevelopServer = ConfigUtil.getBooleanValue("system.isDevelopServer", true);
	request.setAttribute("isDevelopServer", isDevelopServer);
    if(isDevelopServer) {
    	if(extjsVersion.equals("4.2.2")) {
    		request.setAttribute("ext_url", "/extjs_"+extjsVersion+"/ext-all-dev.js");
    	}else{
    		request.setAttribute("ext_url", "/extjs_"+extjsVersion+"/ext-all-debug.js");
    	}
    } else {
    	request.setAttribute("ext_url", "/extjs_"+extjsVersion+"/ext-all.js");
    }

    request.setAttribute("css_url", "/extjs_"+extjsVersion+"/resources/ext-theme-classic-omega/ext-overrides.css");
    request.setAttribute("ext_root", "extjs_"+extjsVersion);
    request.setAttribute("ext_version", extjsVersion);

    request.setAttribute("mainPortal", ConfigUtil.getString("common.main.mainPortal", "MainPortalPanel")); //사이트 별 포털 뷰 클래스명
%>

<t:ExtComboStore items="${BOR120}" storeId="BOR120" /><!-- 사업장 -->

<style type="text/css">
	td.bookDetail {
		padding-right:10px;
		line-height:25px;
		background:#eff5fb;
		text-align:right;
	}
.x-change-cell {
background-color: #fed9fe;
}
</style>
<script type="text/javascript">
function windowMaximize() {
	if (screenfull.enabled) {
	    screenfull.toggle();//request();
	} else {
		alert("현재 사용 하시는 브라우져는 Full Screen 모드를 자동으로 지원할수 없습니다. F11 키나 브라우져 메뉴 상에서 전체화면 기능을 이용해 주시기 바랍니다.");
	}
}

//var gsUserDiv = '${gsUserDiv}';
function appMain() {

	var isViewImage = false;	//이미지 보임 여부..
	Unilite.defineModel('searchBookmodel', {
	    fields: [	 //BPR100T필수
					 { name: 'ITEM_CODE',  				text: '도서코드', 		type : 'string', allowBlank:false}
			  		,{ name: 'ITEM_NAME',  				text: '도서명', 		type : 'string', allowBlank: false}
			  		,{ name: 'DIV_CODE',  				text: '사업장', 		type : 'string', allowBlank: false, xtype: 'uniCombobox', store: Ext.StoreManager.lookup('BOR120')}
			  		,{ name: 'SALE_BASIS_P',  	 		text: '판매가', 		type : 'uniUnitPrice'}
			  		,{ name: 'SALE_COMMON_P',  			text: '시중가', 		type : 'uniUnitPrice', allowBlank: false}
				    ,{ name: 'AUTO_DISCOUNT',  			text: '자동할인여부', 	type : 'string', comboType:'AU', comboCode:'B010',defaultValue:'Y', allowBlank: false}

			  		,{ name: 'ISBN_CODE',  				text: 'ISBN코드', 	type : 'string'}
			  		,{ name: 'PUBLISHER_CODE',  		text: '출판사코드', 	type : 'string'}
			  		,{ name: 'ITEM_LEVEL1',  			text: '대분류', 		type : 'string'}
				    ,{ name: 'ITEM_LEVEL2',  			text: '구분', 		type : 'string'}
				    ,{ name: 'ITEM_LEVEL3',  			text: '출판분야', 		type : 'string'}
			  		,{ name: 'ITEM_LEVEL_NAME1',  		text: '대분류', 		type : 'string'}
				    ,{ name: 'ITEM_LEVEL_NAME2',  		text: '구분', 		type : 'string'}
				    ,{ name: 'ITEM_LEVEL_NAME3',  		text: '출판분야', 		type : 'string'}
			  		,{ name: 'CUSTOM_NAME',  			text: '매입처', 		type : 'string'}
			  		,{ name: 'ISSUE_PLAN_Q',  			text: '납품예정', 		type : 'string'}
			  		,{ name: 'RTN_REMAIN_Q',  			text: '반품예정', 		type : 'string'}
				    ,{ name: 'LAST_PURCHASE_DATE',  	text: '입고일', 		type : 'uniDate', convert:function(v) {return UniDate.safeFormat(v)}}

			  		,{ name: 'PUBLISHER',  				text: '출판사', 		type : 'string'}
			  		,{ name: 'AUTHOR',  				text: '저자', 		type : 'string'}
			  		,{ name: 'TRANSRATOR',  			text: '역자', 		type : 'string'}
			  		,{ name: 'PUB_DATE',  				text: '초판발행일', 	type : 'uniDate', convert:function(v) {return UniDate.safeFormat(v)}}
			  		,{ name: 'BIN_NUM',  				text: '진열번호', 		type : 'string'}
			  		,{ name: 'BIN_FLOOR',  				text: '진열대', 		type : 'string'}
			  		,{ name: 'STOCK_Q',  				text: '보유수량', 		type : 'uniQty'}

			  		/*교재*/
			  		,{ name: 'MAJOR_NAME',  			text: '학과', 		type : 'string'}
			  		,{ name: 'SUBJECT_NAME',  			text: '교과목명', 		type : 'string'}
			  		,{ name: 'TXT_YYYY',  				text: '학년도', 		type : 'string'}
			  		,{ name: 'TXT_SEQ',  				text: '학기', 		type : 'string'}
			  		,{ name: 'PROFESSOR_NAME',  		text: '담당교수', 		type : 'string'}
			  		,{ name: 'COLLEGE_TYPE',  			text: '개설구분', 		type : 'string'}
			  		,{ name: 'REFERENCE_YN',  			text: '교재여부', 		type : 'string'}


		]
	});

	var masterStore =  Unilite.createStore('searchBookstore',{
        model: 'searchBookmodel',
         autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable:false,			// 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
            },
            pageSize :0,
            proxy: {
            	type: 'ajax',
				actionMethods : {
		            read   : 'POST'
		         },
		         url: CPATH+'/bookshop/search.do',
		         reader: {
		             type: 'json'
		         }
            } ,
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('searchBooksearchForm');
				var bookForm = panelSearch.down('#BOOK_SEARCH');
				bookForm.reset();
				var refForm = panelSearch.down('#REF_SEARCH');

				// 필수 검색어
				if(Ext.isEmpty(searchForm.getValue("ITEM_NAME")) && searchForm.getValue("BOOK_GUBUN") == 'R' )	{
						searchForm.setValue("ITEM_NAME", refForm.getValue("SEARCH_TXT"))
				}

				var param= searchForm.getValues();
				Ext.applyIf(param, refForm.getValues());

				if(searchForm.isValid())	{
					this.clearFilter();
					this.load({params: param});
				}
			},
			searchFilter: function(fields, value)		{
				if(fields)	{
					this.addFilter(new Ext.util.Filter({
								filterFn: function(record) {
								      return ((fields.indexOf("ITEM_NAME") > -1 && record.get("ITEM_NAME").indexOf(value) > -1) 	||
								      		 (fields.indexOf("AUTHOR") > -1 && record.get("AUTHOR").indexOf(value) > -1) 		||
								      		 (fields.indexOf("PUBLISHER") > -1 && record.get("PUBLISHER").indexOf(value) > -1) 		||
								      		 (fields.indexOf("ISBN_CODE") > -1 && record.get("ISBN_CODE").indexOf(value) > -1) 	)
								}
						 })
					);
				}
			}
		});

		var detailStore =  Unilite.createStore('searchBookstore',{
        	model: 'searchBookmodel',
         	autoLoad: false

		});

    var detailViewTplTemplate = new Ext.XTemplate(
	    '<table cellspacing="1" cellpadding="2" style="border: #99bce8 solid 0px;border-bottom: #99bce8 solid 2px;" width="900">' ,
		 '<tpl for=".">' ,
				'<tr>',
				 '	<td colspan="4" height="40" style="border-bottom: #99bce8 solid 2px;line-height:40px;"><strong><font style="font-size:16pt;">{ITEM_NAME}</font></strong></td>' ,
				 '</tr>',
				 '<tr>',
				 '	<td width="100" class="bookDetail">저자 </td>' ,
	             '	<td width="350">{AUTHOR}</td>',
	             '	<td width="100" class="bookDetail">역자 </td>' ,
	             '	<td width="350">{TRANSRATOR}</td>',
//	             '	<td width="100" class="bookDetail"> </td>' ,
//	             '	<td width="350", hight="100">{bookImage}</td>',
	             '</tr>',
				 '<tr>',
	             '	<td width="100" class="bookDetail">출판분야 </td>' ,
	             '	<td>{ITEM_LEVEL_NAME2}/{ITEM_LEVEL_NAME3} </td>',
	             '	<td width="100" class="bookDetail">매입처</td>' ,
	             '	<td>{CUSTOM_NAME}</td>',
	             '</tr>',
	              '<tr>',
				 '	<td width="100"  class="bookDetail">출판사 </td>' ,
	             '	<td>{PUBLISHER}</td>',
				 '	<td width="100" class="bookDetail">초판발행일</td>' ,
	             '	<td>{PUB_DATE}</td>',
	             '</tr>',
	             '<tr>',
	              '	<td class="bookDetail">ISBN </td>' ,
	             '	<td>{ITEM_CODE}</td>',
	             '	<td class="bookDetail">입고일 </td>' ,
	             '	<td>{LAST_PURCHASE_DATE}</td>',
	             '</tr>',
				 '<tr>',
				  '	<td class="bookDetail">가격 </td>' ,
				 '	<td>{SALE_BASIS_P:number(UniFormat.Price)}</td>',
				 '	<td class="bookDetail"><strong>보유수량<storng></td>' ,
				 '	<td><strong>{STOCK_Q}<storng></td>',
				 '</tr>',
				 '<tr>',
				 '	<td class="bookDetail">서가위치 </td>' ,
				 '	<td >{BIN_NUM}</td>',
				 '	<td class="bookDetail">진열대 </td>' ,
				 '	<td >{BIN_FLOOR}</td>',
				 '</tr>',
				 '<tr>',
				 '	<td class="bookDetail">납품예정 </td>' ,
				 '	<td >{ISSUE_PLAN_Q}</td>',
				 '	<td class="bookDetail">반품예정 </td>' ,
				 '	<td >{RTN_REMAIN_Q}</td>',
				 '</tr>',
        '</tpl>' ,
        '</table>'
	);

	var detailView = Ext.create('Ext.view.View', {	//UniDropView
    	region:'west',
    	autoScroll: true,
//    	weight:-100,
    	flex: 2,
		tpl: detailViewTplTemplate,
        store: detailStore,
        style:'background-color: #fff',
        singleSelect: true,
        height:250,
        itemSelector: 'div.data-source',
	    overItemCls: 'data-over',//'data-over',
	    selectedItemClass: 'data-selected'
	});

	var imagePanel = Unilite.createSearchForm('searchBooksearchForm2',{
		flex: 1,
//		weight:-100,
    	region: 'center',
    	height: 50,
		layout : {type : 'uniTable', columns : 1},
		padding:0,
		border:false,
		items: [
			{xtype: 'image',  src: '', itemId: 'bookImage', width:130, height: 170, margin: '50 0 0 50'}
		]
    });


	 var masterGrid = Unilite.createGrid('bpr102ukrvGrid', {
    	region:'center',
    	flex: 1,
    	store : masterStore,
    	sortableColumns : false,
    	uniOpt:{
			//column option--------------------------------------------------
			expandLastColumn: false,
			useRowNumberer: false,		//번호 컬럼 사용 여부
			onLoadSelectFirst: false,
			state: {
				useState: false,			//그리드 설정 버튼 사용 여부
				useStateList: false		//그리드 설정 목록 사용 여부
			},
			excel: {
				useExcel: false			//엑셀 다운로드 사용 여부
			}
		},
        fnGetbookImage: function(isbn){
        	 params: {
        	 	var params = {
	        		query: isbn,
	        		d_isbn: isbn,
	        		display: '1'
	        	};
				UniNaverSearch.searchBookAdv(params, function(naver, item, result) {
					if(Ext.isArray(item)) {
				    	item = item[0];
		    		}
					//masterGrid.fnSetBookInfo(item);	//책정보 set

					var bookImage = imagePanel.down('#bookImage');
					if(result) {
						bookImage.setSrc(item.image);
						isViewImage = true
					} else {
						bookImage.setSrc('');
					}
					//isViewImage = trueetValue('<a href="javascript:void(0);" onclick="javascript:'+naver.getLinkScript(item.link)+';"><u>책소개</u></a>')
				});
        	 }
        },
    	border:false,
        columns:  [ { dataIndex: 'ITEM_CODE',  			width: 100, hidden:true},
        			{ dataIndex: 'DIV_CODE',  			width : 100},
        			{ dataIndex: 'ITEM_NAME',  			flex: 1, minWidth :180},
        			{ dataIndex: 'MAJOR_NAME',  		width: 100, hidden:true},
			  		{ dataIndex: 'SUBJECT_NAME',  		width: 100, hidden:true},
			  		{ dataIndex: 'TXT_YYYY',  			width: 60, hidden:true},
			  		{ dataIndex: 'TXT_SEQ',  			width: 60, hidden:true},
			  		{ dataIndex: 'PROFESSOR_NAME',  	width: 80, hidden:true},
			  		{ dataIndex: 'COLLEGE_TYPE',  		width: 80, hidden:true},
			  		//{ dataIndex: 'TEXTBOOK_TYPE',  		width: 80, hidden:true},
			  		{ dataIndex: 'ISSUE_PLAN_Q',  		width: 80, hidden:true},
			  		{ dataIndex: 'RTN_REMAIN_Q',  		width: 80, hidden:true},
        			{ dataIndex: 'PUBLISHER',  		  	width: 120},
        			{ dataIndex: 'AUTHOR',  			width: 180},
        			{ dataIndex: 'TRANSRATOR',  		width: 90},
        			{ dataIndex: 'CUSTOM_NAME',  		width: 180, hidden:true},
        			{ dataIndex: 'PUB_DATE',  		  	width: 80},
        			{ dataIndex: 'SALE_BASIS_P',  		width: 90},
        			{ dataIndex: 'STOCK_Q',  		  	width: 80, tdCls:'x-change-cell' },
        			{ dataIndex: 'ITEM_LEVEL_NAME2',  	width: 90},
        			{ dataIndex: 'ITEM_LEVEL_NAME3',  	width: 90},
        			{ dataIndex: 'LAST_PURCHASE_DATE',  width: 60, hidden: true},
        			{ dataIndex: 'BIN_NUM',  	 	  	width: 80},
        			{ dataIndex: 'BIN_FLOOR',  		  	width: 80}
          ] ,
	    listeners:{
	    	select:function( view, record, eOpts )	{
	    		console.log(" detailStore record :",record);
	    		detailStore.loadData([record.data]);
	    		//UniAppManager.app.fnGetbookImage(masterGrid.get('ITEM_CODE'));
	    		var record = masterGrid.getSelectedRecord();
				masterGrid.fnGetbookImage(record.get('ITEM_CODE'));
				//var bookImage = imagePanel.down('#bookImage');
				//panelResult.setValue('ITEM_CODE', record.get('ITEM_CODE'));
	    	}
	    }
    });

	Ext.create('Ext.data.Store', {
		storeId:'BOOK_GUBUN',
	    fields: ['text', 'value'],
	    data : [
	        {text:"도서검색",   value:"G"},
	        {text:"교재검색", 	value:"R"}
	    ]
	});

	Ext.define("Docs.view.search.Container", {
		extend: "Ext.container.Container",
		alias: "widget.searchcontainer",
		initComponent: function() {
			var me = this;
	    	var searchStore  = Ext.create('Ext.data.Store',{
	            fields: [
		            {name:'ITEM_NAME', type:'string'}
	            ],
	            storeId: 'SearchMenuStore',
	            autoLoad: false,
	            pageSize: 50,
	            proxy: {
            		type: 'ajax',
					actionMethods : {
			            read   : 'POST'
			         },
			         url: CPATH+'/bookshop/searchMenu.do',
			         reader: {
			             type: 'json',
			             <c:choose>
				        	<c:when test="${ext_version == '4.2.2'}">
				        		root: 'records'	//4.2.2
				        	</c:when>
				        	<c:otherwise>
				        		rootProperty: 'records'	//5.1.0
				        	</c:otherwise>
				        </c:choose>
			         },
			         setExtParams:function(params) {
			         	this.extraParams = params;
			         }
	            }
	        });
			this.items = [{
				hideLabel:true,
		        xtype: 'combobox',
	  	        store: searchStore,
		        queryMode: 'remote',
		        displayField: 'ITEM_NAME',
		        name: 'ITEM_NAME',
		        minChars: 1,
		        queryParam: 'searchStr',
		        hideTrigger: true,
		        autoSelect:false,
				width:310,
			    margin: '0 0 2 -65',
				//allowBlank:false,
				listeners:{
					specialkey:function(field, e){
	                    if (e.getKey() == e.ENTER) {
	                        masterStore.loadStoreRecords();
	                    }


	                }
				}
			}];
			searchStore.on('beforeload', function(store, operation) {
		    var proxy = store.getProxy();
		    proxy.setExtraParam('S_DIV_CODE', panelResult.getValue("DIV_CODE"));
			});
			this.callParent()
		}
	});

	var panelResult = Unilite.createSearchForm('searchBooksearchForm',{
    	region: 'north',
    	height: 55,
		layout : {type : 'uniTable', columns : 4, tableAttrs:{ height:50, valign:'middle', align:'center'}},
		padding:0,
		border:false,
		items: [{
    		fieldLabel: '캠퍼스',
    		name: 'DIV_CODE',
//			value: gsUserDiv,
    		xtype: 'uniCombobox',
			//width:190,
    		store: Ext.StoreManager.lookup('BOR120'),
    		allowBlank:false,
    		listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(newValue == '01'){
						Ext.getCmp('bookP1').setHidden(false);
						Ext.getCmp('bookP2').setHidden(true);
						Ext.getCmp('bookP3').setHidden(true);
					}else if(newValue == '02'){
						Ext.getCmp('bookP2').setHidden(false);
						Ext.getCmp('bookP1').setHidden(true);
						Ext.getCmp('bookP3').setHidden(true);
					}else if(newValue == '03'){
						Ext.getCmp('bookP3').setHidden(false);
						Ext.getCmp('bookP1').setHidden(true);
						Ext.getCmp('bookP2').setHidden(true);
					}else{
						Ext.getCmp('bookP1').setHidden(true);
						Ext.getCmp('bookP2').setHidden(true);
						Ext.getCmp('bookP3').setHidden(true);
					}
				}
			}
    	}/*,{
    		fieldLabel: '도서코드',
    		name: 'ITEM_CODE',
    		xtype: 'uniTextfield',
			hidden: true
    	}*/,{
			//hideLabel:true,
			fieldLabel: '책이름',
			//labelWidth: 40,
			name: 'BOOK_GUBUN',
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('BOOK_GUBUN'),
			//allowBlank: false,
			width:180,
			value:'G',
			listeners:{
				change:function(field, newValue, oldValue, eOpts)	{
					if(newValue == "R")	{
						panelSearch.down('#BOOK_SEARCH').reset();
						panelSearch.down('#BOOK_SEARCH').hide();
						panelSearch.down('#REF_SEARCH').show();

						masterGrid.getColumn('MAJOR_NAME').show();
						masterGrid.getColumn('SUBJECT_NAME').show();
						masterGrid.getColumn('TXT_YYYY').show();
						masterGrid.getColumn('TXT_SEQ').show();
						masterGrid.getColumn('PROFESSOR_NAME').show();
						masterGrid.getColumn('COLLEGE_TYPE').show();
						//masterGrid.getColumn('TEXTBOOK_TYPE').show();
					}else {
						panelSearch.down('#REF_SEARCH').reset();
						panelSearch.down('#REF_SEARCH').hide();
						panelSearch.down('#BOOK_SEARCH').show();

						masterGrid.getColumn('MAJOR_NAME').hide();
						masterGrid.getColumn('SUBJECT_NAME').hide();
						masterGrid.getColumn('TXT_YYYY').hide();
						masterGrid.getColumn('TXT_SEQ').hide();
						masterGrid.getColumn('PROFESSOR_NAME').hide();
						masterGrid.getColumn('COLLEGE_TYPE').hide();
						//masterGrid.getColumn('TEXTBOOK_TYPE').hide();
					}
				}
			}
		},{
			xtype: 'searchcontainer'

		},{
			xtype:'button',
			text:'검색',
			handler:function()	{
				masterStore.loadStoreRecords();
			}
		},{
			fieldLabel: '출판사',
			//labelWidth: 40,
		    name: 'PUBLISHER',
			xtype: 'uniTextfield',
			listeners:{
				specialkey:function(field, e){
                    if (e.getKey() == e.ENTER) {
                        masterStore.loadStoreRecords();
                    }
                }
			}

		},{
			fieldLabel: '저자',
			//labelWidth: 28,
		    name: 'AUTHOR',
			xtype: 'uniTextfield',
			listeners:{
				specialkey:function(field, e){
                    if (e.getKey() == e.ENTER) {
                        masterStore.loadStoreRecords();
                    }
                }
			}

		},{
			fieldLabel: 'ISBN',
			//labelWidth: 32,
		    name: 'ISBN_CODE',
			//width:200,
			xtype: 'uniTextfield',
			listeners:{
				specialkey:function(field, e){
                    if (e.getKey() == e.ENTER) {
                        masterStore.loadStoreRecords();
                    }
                }
			}

		}],
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
		}
    });

    //var panelSearch = Unilite.createSearchForm('searchBooksearchForm1',{
    var panelSearch = Ext.create('Ext.panel.Panel',{
    	region: 'west',
    	width: 250,
		layout : {type : 'vbox', columns : 1},
		padding:'0 0 0 0',
		margin:'0 0 0 0',
		border:true,
		items: [{
				xtype:'uniSearchForm',
				margin:'0 0 0 0',
				padding:'0 0 0 0',
				itemId:'BOOK_SEARCH',
				border:false,
				defaultType:'uniTextfield',
				layout : {type : 'uniTable', columns : 2, tableAttrs:{align:'center',valign:'top',height:215}},
				title:'결과내 검색',
				items:[
					{
						hideLabel:true,
						name: 'SEARCH_TXT'
					},{
						xtype:'button',
						text:'검색',
						handler:function()	{
							masterStore.clearFilter();
							var form = panelSearch.down('#BOOK_SEARCH');
							var searchStr = form.getValue('SEARCH_TXT');
							var checkedFields = form.getValue('BOOK_SEARCH');
							masterStore.searchFilter(checkedFields.BOOK_SEARCH, searchStr)

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
				                    inputValue: 'ITEM_NAME',
				                    checked	  :true
				                },{
				                    boxLabel  : '저자',
				                    name      : 'BOOK_SEARCH',
				                    inputValue: 'AUTHOR',
				                    checked	  :true
				                },{
				                    boxLabel  : '출판사',
				                    name      : 'BOOK_SEARCH',
				                    inputValue: 'PUBLISHER',
				                    checked	  :true
				                },{
				                    boxLabel  : 'ISBN',
				                    name      : 'BOOK_SEARCH',
				                    inputValue: 'ISBN_CODE',
				                    checked	  :true
				                }
							]

						}]

				},{
					xtype:'component',
					html:'&nbsp;',
					tdAttrs:{height:'50%'}
				}]
    	},{
	  			xtype:'uniSearchForm',
				margin:'0 0 0 0',
				padding:'0 0 0 0',
				border:false,
				itemId : 'REF_SEARCH',
				hidden:true,
				defaultType:'uniTextfield',
				defaults:{labelWidth:60},
				layout : {type : 'uniTable', columns : 1, tableAttrs:{align:'center',valign:'middle'}},
				title:'교재검색',
				items:[
					{
						xtype:'uniTextfield',
						fieldLabel:'교재명',
						name : 'SEARCH_TXT'
					},{
						fieldLabel:'학과명',
						name : 'MAJOR_NAME'
					},{
						fieldLabel:'과목명',
						name : 'SUBJECT_NAME'
					},{
						fieldLabel:'개설구분',
						name : 'COLLEGE_TYPE'
					},{
						fieldLabel:'학년',
						name : 'TXT_YYYY'
					},{
						fieldLabel:'학기',
						name : 'TXT_SEQ'
					},{
						fieldLabel:'교수명',
						name : 'PROFESSOR_NAME'
					},{
						xtype:'button',
						text:'  검색  ',
		        		tdAttrs:{'align':'right'},
						handler:function()	{
							masterStore.loadStoreRecords();
						}
					}
				]



    	},{
			xtype:'component',
			id:'bookP1',
			margin:'10 0 0 20',
			tdAttrs:{'align':'center'},
			html: '<img src="'+CPATH+'/resources/images/booksearch/book_position.png" width="200"">'
		},{
			xtype:'component',
			id:'bookP2',
			margin:'10 0 0 20',
			tdAttrs:{'align':'center'},
			html: '<img src="'+CPATH+'/resources/images/booksearch/book_position2.png" width="200"">',
			hidden:true
		},{
			xtype:'component',
			id:'bookP3',
			margin:'10 0 0 20',
			tdAttrs:{'align':'center'},
			html: '<img src="'+CPATH+'/resources/images/booksearch/book_position_Wonju.png" width="200"">',
			hidden:true
		}
	]});

	var panelNorth = {
			xtype:'container',
            region: 'north',
            split:false,
            layout: {
		        type: 'hbox',
		        align: 'stretch'
		    },
            defaults: {
                xtype: "uniTransparentContainer",
                padding: "0",
                style: {'vertical-align': 'middle'}
            },
            cls: 'uni-doc-header',
            height: 44,
            items: [
                {
                    xtype:"uniActionContainer",
                    html: '<img src="' + CPATH + '/resources/css/theme_01/logo_ysu.png" />',
                    margin: "8 0 0 35",
                    onClick:function() {
                        window.location.reload();
                    }
                },
                {
                  flex: 1
                },
                {
                    xtype:"uniActionContainer",
                    html: '<img src="' + CPATH + '/resources/css/theme_01/fullscreen.png" title="Maximize" />',
                    padding: "13 10 0 0",
                    onClick:function() {
                        windowMaximize();
                    }
                }

             ] // items

        };

      Ext.create('Ext.Viewport',{
      	layout:'border',
      	defaults:{
      		split:true
      	},
		items:[
			panelNorth,
			panelResult,
			panelSearch,
			masterGrid,
			{
			region: 'south',
			layout: 'border',
			weight: -100,
			height: 300,
			border: false,
			items:[detailView, imagePanel]
			}
		],
		id  : 'searchBookukrApp',
		listeners:{
			afterrender:function( view, eOpts ){
				windowMaximize();
				//panelResult.setValue('DIV_CODE',gsUserDiv);
			}
		}

	});

}; // main

</script>