<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
{
    xtype: 'container',
    title: '<t:message code="system.label.common.home" default="Home"/>',
    itemId: 'home',
    uniOpt: {
       'prgID': 'home',
       'title': 'Home'
    },
    closable: false,
    layout: {
        type: 'vbox',
        align: 'stretch'
    },
    items: [
        {
	        xtype: 'container',
            contentEl: 'home_notice',
            style: {
                'background-color': '#0d385d'
            }
	    },	   	   
	    {			
		    xtype: 'container',
			bodyPadding: 10,
			flex:1,
			defaults: {
		    	//bodyStyle: 'padding: 30px;',
		        frame: true,
		        boder: true
		    },
		    style: {
		    	'overflow': 'auto',
		        'background-image': 'url(' + CPATH + '/resources/css/theme_01/bg.png )',
		        'background-color': '#0d385d',
		        'background-position': 'fixed',		        
                'background-repeat': 'no-repeat',
                '-webkit-background-size': 'cover',	 //For WebKit
                '-moz-background-size': 'cover',		 //Mozilla
                '-o-background-size': 'cover',			 //Opera
                'background-size': 'cover'				 //Generic
		    },
			layout: {
				type:'table', 
				//columns:5,
				columns:1,
				border: 40,
				tableAttrs: {
		            style: {
//		                'margin-left': 'auto', 
//		                'margin-right': 'auto'	
		                'position': 'absolute',
                        'top': '25%',
                        'left': '50%',
                        'transform': 'translate(-50%, -25%)'
		            }
		        },
		        tdAttrs: {
		            style: {
		                //width: '200',
		                width: '780px',
		                'vertical-align': 'top'
//		                'padding': '40 20 0 20'
		            }
		        }
		    },
			//items: modules
		    items: [
			    {
			    	xtype: 'container',
			    	layout: 'auto',	    	
			    	defaults: {
			            style: {
			                float: 'left',
			                width: 130
			            }
			        },
			        items: modules
			    },{
				    text: '생산공정불량 등록',
				    itemId:'btnFinish',
				    margin: '120 0 0 18',
				   	width: 120,
				   	height: 50,
				   	//20200407 임시로 히든 처리 -> 20200409 모두 사용가능하도록 주석 해제
//				   	hidden: UserInfo.userID == 'unilite5' ? false: true,
				    xtype: 'button',
				    handler: function(){
				    	window.open('z_in/s_pmr101ukrv_in.do','_blank','width='+(screen.availWidth-10)+',height='+(screen.availHeight)+'menubar=no,location=no,scrollbars=yes,resizable=no,top=0,left=0');
					}
				} /*,{
				    text: '실사등록(모바일)',
				    itemId:'btnBiv120ukrvMobile',
				    margin: '20 150 0 18',
				   	width: 120,
				   	height: 50,
				   	hidden: false,
				    xtype: 'button',
				    handler: function(){
				    	window.open('z_in/Biv120ukrv_mobile.do','_blank','width='+(screen.availWidth-10)+',height='+(screen.availHeight)+'menubar=no,location=no,scrollbars=yes,resizable=no,top=0,left=0');
					}
				} */
		    ]			
		} // modules
    ]
}