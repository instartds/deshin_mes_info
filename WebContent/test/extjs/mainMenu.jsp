<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<%@ page import="java.util.*" %>
<%@ page import="foren.unilite.com.service.*"%>
<%@ page import="foren.framework.lib.tree.*" %>
<%@ page import="foren.unilite.com.menu.*" %>
<%@ page import="foren.framework.utils.*" %>
<%
/*
	TlabMenuService menuService = (TlabMenuService) ObjUtils.getBean(TlabMenuService.MENU_SERVICE_BEAN_ID);
	MenuTree mTree = menuService.getMenuTree("MASTER");
	MenuNode mNode = mTree.getNodeByMenuID("11");
*/
%>
<script type="text/javascript" >

function appMain() {
	

		Unilite.defineModel('menuItemModel', {
			// pkGen : user, system(default)
			idProperty: 'prgID',
		    fields: [ 	{name: 'prgID' 		,text:'Menu ID' 	}
		    			,{name: 'text' 		,text:'프로그램명'	}
		    			,{name: 'text_en' 		,text:'프로그램명'	}
		    			,{name: 'text_cn' 		,text:'프로그램명'	}
		    			,{name: 'text_jp' 		,text:'프로그램명'	}
		    			,{name: 'url' 		,text:'프로그램명'	}
		    			
				]
		});
	
		var directMasterStore = Unilite.createTreeStore('directMasterStore',{
			model: menuItemModel,
	        autoLoad: false,
	        folderSort: true,
	        uniOpt : {
	        	isMaster: true,			// 상위 버튼 연결 
	        	editable: false,			// 수정 모드 사용 
	        	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
	        },
	        
	        proxy: {
	            type: 'direct',
	            api: {
	                read : 'mainMenuService.getMenuList'
	            	
	            }
	        }
		});
		var leftSystemMenuB = Ext.create('Unilite.main.MainTree', {
			title : '시스템',
			width : 200,
			height : 600,
			store :	directMasterStore, // treeStore,
			margins: '0 0 0 5',
			activeItem : '11',
			listeners : {
				urlclick : function(rec, url, item) {
					if(url) {
						
							alert(url);
					}
					
				}
			}
		});
		
	Unilite.Main({
		items : [leftSystemMenuB]
	});  // Unilite.Main
} // appMain

</script>