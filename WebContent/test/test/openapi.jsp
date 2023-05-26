<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
    request.setAttribute("ext_url", "/extjs/ext-all-dev.js");
	
	//request.setAttribute("css_url", "/extjs/resources/ext-theme-classic/ext-theme-classic-all-debug.css"); // 4.2.2
    request.setAttribute("css_url", "/extjs/resources/ext-theme-classic-omega/ext-overrides.css"); // 4.2.2    
    request.setAttribute("ext_root", ""); // 4.2.2
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Edit Grid Sample</title>

	<link rel="stylesheet" type="text/css" href='<c:url value="${css_url}" />' />
	<script type="text/javascript" charset="UTF-8" src='<c:url value="${ext_url }" />'></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/openapi/UniNaverSearch.js" />'></script>
    <script type="text/javascript">
    	var CPATH ='<%=request.getContextPath()%>';
        Ext.Loader.setConfig({
		enabled : true,
		scriptCharset : 'UTF-8',
		paths: {
                "Ext": '${CPATH }/${ext_root}/src',
            	"Ext.ux": '${CPATH }/${ext_root}/app/Ext/ux',
            	"Unilite": '${CPATH }/${ext_root}/app/Unilite',
            	"Extensible": '${CPATH }/${ext_root}/app/Extensible'
        }
	});
	Ext.require('*');	
    </script>
	
    <script type="text/javascript">
        
		Ext.define('OpenApi.book.BookSearchForm', {
		    extend: 'Unilite.com.form.UniAbstractForm',//'Ext.form.Panel',
		    alias : 'widget.booksearchform',
		    width: 500,
		    frame: true,
		    title: 'OpenAPI Book Example',
		    bodyPadding: '10 10 0',
		 
		    defaults: {
		        anchor: '100%',
		        allowBlank: false,
		        msgTarget: 'side',
		        labelWidth: 75
		    },
		 
		    items: [{
		        xtype: 'textfield',
		        name: 'title',
		        fieldLabel: 'Title'
		    },{
		        xtype: 'textfield',
		        name: 'author',
		        fieldLabel: 'Author'
		    },{
		        xtype: 'textfield',
		        name: 'isbn',
		        fieldLabel: 'ISBN'
		    },{
		        xtype: 'textfield',
		        name: 'description',
		        fieldLabel: 'Description'
		    }]
		 
		    
		});

		
		
		Ext.require([
		    'Ext.data.*',
		    'Ext.tip.QuickTipManager',
		    'Ext.window.MessageBox'
		]);
        Ext.onReady(function(){
        	Ext.tip.QuickTipManager.init();
	        
	        var searchForm = Ext.create('OpenApi.book.BookSearchForm', {
		        	buttons: [{
				        text: 'Search',
				        handler: function() {
				        	
				        	var params = {
				        		query: '9780495384724',
				        		d_isbn: '9780495384724',
				        		//d_titl: '삼국지',
				        		//display: '10',
				        		display: '1'	//검색결과 출력건수
				        		//start: '1'
				        	};

				        	/*
				        	 * 네이버 검색API 책 상세검색 예
				        	 * 
				        	 * params 	: request parameters
				        	 * function : callback 함수
				        	 *    naver : UniNaverSearch 객체 자신
				        	 *    item  : 검색결과 item (array 가 될 수 있으며 params 의 display:1 로 단일건만 받을 수 있다.)
				        	 *    result: 응답 정보
				        	 */
							UniNaverSearch.searchBookAdv(params, function(naver, item, result) {
								
								if(Ext.isArray(item)) {
							    	item = item[0];
					    		}
					    		
								searchForm.setBookInfo(item);

								var bookLink = searchForm.down('#bookLink');
								bookLink.setValue('<a href="javascript:void(0);" onclick="javascript:'+naver.getLinkScript(item.link)+';">link</a>')
								

							});
				        }
				    },
//				    {
//				        xtype: 'button',
//				        itemId: 'bookLinkBtn',
//				        text: 'link',
//				        href: 'http://www.sencha.com"'
//				    },
				    {
						xtype: 'displayfield',
						itemId: 'bookLink',
					    fieldLabel: '',
					    value: '<a href="javascript:void(0);">link</a>'
				    },
				    {
				        text: 'Reset Form',
				        handler: function() {
				            this.up('form').getForm().reset();
				        }
				    }],
				    setBookInfo: function(item) {			    		
			    		this.setValue('title', item.title);
				    	this.setValue('author', item.author);
				    	this.setValue('isbn', item.isbn);
				    	this.setValue('description', item.description);
				    }
	        });
		
		    var main = Ext.create('Ext.container.Container', {
		        padding: '0 0 0 20',
		        width: 1000,
		        height: Ext.themeName === 'neptune' ? 500 : 450,
		        renderTo: document.body,
		        layout: {
		            type: 'vbox',
		            align: 'stretch'
		        },
		        items: [
		        	searchForm
		        ]
		    });
        });
    </script>
    
</head>
<body>
</body>
</html>
