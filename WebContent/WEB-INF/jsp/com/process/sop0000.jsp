<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	
    request.setAttribute("ext_version", extjsVersion);   
%>
<script type="text/javascript" >
	Ext.define('Unilite.TButton', {
		extend: 'Ext.container.Container',
		//extend: 'Ext.panel.Panel',
	    alias: 'widget.tbutton',
	    clickEvent: 'click',
	    onClick: function() {
	    	console.log('click')
	    },
	    btn:null,
	    baseCls: 'none',
		 
		constructor: function(config){    
	        var me = this;
	       		
	        if (config) {
	            Ext.apply(me, config);
	        }
	        this.callParent([config]);
		},
	    initComponent: function() {
	        var me = this;
	        me.callParent(arguments);
	        <c:if test="${ext_version == '4.2.2'}">
	        me.addEvents('click');
	        </c:if>
	     },
	     style: {
	     	'background-color':'transparent !important',
	     	'border-style':'none',
	     	'color': 'transparent',
	     	'vertical-align':'middle',
	     	'cursor':'pointer'
	     },
	     onClick: function(e) {
	     	console.log('onClick');
	     },
	     onMouseOver: function(e) {
	     	//this.btn.setStyle({'color': '#f00'});
	     	
			if(this.utype == 'next') {
				this.setStyle({
					'background-image':'url(' + CPATH+'/resources/images/next_image.png' +')',
					'background-repeat':'no-repeat'
				});
			} else {
				this.setStyle({
					'background-image':'url(' + CPATH+'/resources/images/prev_image.png' +')',
					'background-repeat':'no-repeat'
				});
			}
	     },
	     onMouseOut: function(e) {
	     	//this.setStyle({'color': 'transparent'});
	     	
			if(this.utype == 'next') {
				this.setStyle({'background-image':'none'});
			} else {
				this.setStyle({'background-image':'none'});
			}
	     },
	     setStyle: function(style) {
	     	this.btn.setStyle(style);
	     },
	     // @private
	    onRender: function() {
	        var me = this,
	            addOnclick,
	            btnListeners;
			this.btn = me.el;
			
	        me.callParent(arguments);
	        btnListeners = {
	                scope: me,
	                click: me.onClick,
	                mouseover: me.onMouseOver,
	                mouseout: me.onMouseOut
	         };
	         me.mon(this.btn, btnListeners);
	         me.mon(me,
	         	{
	         		'resize': function(pnl, width, height, oldWidth, oldHeight, eOpts) {
			         	//console.log('resize');
			         	var sHeight = (height / 2 - 5) +'px';
						//pnl.setStyle({'padding-top':sHeight});
			         }
	         	}
	         );
	         
	    }
	});
Ext.onReady(function() {
	
	var imgStore = Ext.create('Ext.data.Store', {
				fields:['imgFile', 'name'],
				data: [
					{imgFile:'page01.png', name:'표지'},
					{imgFile:'page02.png', name:'Ext JS를 이용한 Spring기반의 ERP Web Application'},
					{imgFile:'page03.png', name:'시스템구조'},
					{imgFile:'page04.png', name:'작동환경'},
					{imgFile:'page05.png', name:'메인 메뉴'},
					{imgFile:'page06.png', name:'표준운영절차(SOP)'},
					{imgFile:'page07.png', name:'즐겨찾기'},
					{imgFile:'page08.png', name:'화면 조정 방법'},
					{imgFile:'page09.png', name:'자료분석 편의성 제공'},
					{imgFile:'page10.png', name:'멀티플 소팅 기능'},
					{imgFile:'page11.png', name:'자료 내 검색 기능'},
					{imgFile:'page12.png', name:'프로그램 연결 기능'},
					{imgFile:'page13.png', name:'프로그램 전환 기능'},
					{imgFile:'page14.png', name:'그리드 설정 기능'},
					{imgFile:'page15.png', name:'리스트 형식의 인적 자원 관리'},
					{imgFile:'page16.png', name:'Form형식의 인적 자원 관리'},
					{imgFile:'page17.png', name:'그룹탭 형식의 인적 정보 관리'},
					{imgFile:'page18.png', name:'모듈별 설정 기능 제공'},
					{imgFile:'page19.png', name:'카렌다 형식의 자료 관리 및 파일 관리'},
					{imgFile:'page20.png', name:'개발요소기술'}
				]});
				
	var imageList = Ext.create('Ext.view.View', {
			itemId:'imageList',
			store: imgStore,   
			tpl: [
	            '<tpl for=".">',
	                '<div class="thumb-landscape-wrap">',
	                    '<div class="thumb-landscape"><img src="'+CPATH+'/resources/process/sop00/{imgFile}" title="{name:htmlEncode}" width="50"></div>',
	                '</div>',
	            '</tpl>',
	            '<div class="x-clear"></div>'
	        ],              
	        trackOver: true,
	        overItemCls: 'presentaion-item-over',
	        selectedItemCls: 'presentaion-item-selected',
	        itemSelector: 'div.thumb-landscape-wrap',
	        emptyText: 'No images to display',
	        listeners: {
	            selectionchange: function(dv, nodes ){  
	            	var data = nodes[0].data;
	            	//this.up().down('#procImg').getEl().dom.src=CPATH+'/resources/process/sop00/'+data['imgFile'];
	            	//this.up().down('#procImg').getEl().dom.title=data['name'];
	            	
	            	this.up().down('#imgPanel').setBodyStyle('background-image','url('+CPATH+'/resources/process/sop00/'+data['imgFile']+')');
	
	            }
	        },
	        prev: function() {
	    		var idx = this.getCurrentIndex();
	    		if(idx == 0 ) {
	    			idx = this.store.count() -1;
	    		} else {
	    			idx = idx - 1;
	    		}
	    		this.getSelectionModel().select(idx);
	        	console.log('prev');
	        },
	        next: function() {
	    		var idx = this.getCurrentIndex();
	    		if(idx == (this.store.count() -1) ) {
	    			idx = 0;
	    		} else {
	    			idx = idx + 1;
	    		}
	    		this.getSelectionModel().select(idx);
	        	console.log('next');
	        },
	        getCurrentIndex: function() {
	        	var idx = 0;
	        	var curRec = this.getSelectionModel( ).getSelection()[0];
	        	if(curRec) {
	        		idx = this.store.indexOf(curRec);
	        	}
	        	return idx;
	        }
	        
		});
		
	var imgPanel = Ext.create('Ext.panel.Panel', {
		itemId: 'imgPanel',
		flex:1,
		bodyStyle: {
			'background-image':'url(' + CPATH+'/resources/process/sop00/page01.png)',
			'background-size':'100%',
			'background-repeat':'no-repeat'
		},
		layout: 'border',
		items: [
			Ext.create('Unilite.TButton', {//xtype:'tbutton',  
				width: 300, region: 'west', utype:'prev', onClick:function() {imageList.prev();}}),
			Ext.create('Unilite.TButton', {//xtype:'tbutton',  
				width: 300, region: 'east', utype:'next', onClick:function() {imageList.next();}})
		]
	});
	
	Ext.create('Ext.container.Viewport', {
		layout:  {	type: 'vbox', pack: 'start', align: 'stretch' },
		 items:[
		 	imgPanel ,
		 	imageList
		 ]
	})
	
});	// Ext.onReady();
</script>
