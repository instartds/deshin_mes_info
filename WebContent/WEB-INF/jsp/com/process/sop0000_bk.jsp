<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<script type="text/javascript" >
Ext.define('Unilite.TButton', {
	extend: 'Ext.panel.Panel',
    alias: 'widget.tbutton',
    listeners: {
          click: function() {
           	console.log('click')
          },
          element: 'el'
      }
});
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
		region:'center',
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
        itemSelector: 'div.thumb-landscape-wrap',
        emptyText: 'No images to display',
        listeners: {
            selectionchange: function(dv, nodes ){  
            	var data = nodes[0].data;
            	//this.up().down('#procImg').getEl().dom.src=CPATH+'/resources/process/sop00/'+data['imgFile'];
            	//this.up().down('#procImg').getEl().dom.title=data['name'];
            	
            	this.up().down('#imgPanel').setBodyStyle('background-image','url('+CPATH+'/resources/process/sop00/'+data['imgFile']+')');

            }
        }
        
	});
var image = Ext.create('Ext.Img', {
	 		xtype:image,
    		src: CPATH+'/resources/process/sop00/page01.png',
    		title:'표지',
    		width:1175,
    		itemId:'procImg',
    		border: 1,
			style: {
			    borderColor: '#aaaaaa',
			    borderStyle: 'solid'
			},
            listeners: {
	            el: {
		            click: function() {
		                console.log('mouse click');
		            },
		            mousemove: function() {
		            	console.log('mouse move');
		            }
		        }
            }
});
var imgPanel = Ext.create('Ext.panel.Panel', {
	itemId: 'imgPanel',
	width: 1600,
	height: 900,
	bodyStyle: {
		'background-image':'url(' + CPATH+'/resources/process/sop00/page01.png)',
		'background-repeat':'no-repeat'
	},
	layout: 'border',
	items: [
		{xtype:'tbutton', html:'이전',  width: '100', region: 'west'},
		{xtype:'tbutton', html:'다음',  width: '100', region: 'east'}
	]
});

Ext.create('Ext.container.Viewport', {
	 items:[
	 	imgPanel ,
	 	imageList
	 ]
})
</script>