<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
{
    xtype: 'container',
    title: 'Home',
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
                'background-color': '#a4a4a4'
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
		        'background-color': '#a4a4a4',
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
		                'margin-left': 'auto', 
		                'margin-right': 'auto'		               
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
			    }
		    ]			
		} // modules
    ]
}