<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
    request.setAttribute("ext_url", "/extjs5/ext-all-debug_5.1.0.js");
	
	//request.setAttribute("css_url", "/extjs/resources/ext-theme-classic/ext-theme-classic-all-debug.css"); // 4.2.2
    request.setAttribute("css_url", "/extjs5/resources/ext-theme-classic-omega/ext-overrides.css"); // 5.1.0    
    request.setAttribute("ext_root", "extjs5"); // 5.1.0
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Edit Grid Sample</title>

	<link rel="stylesheet" type="text/css" href='<c:url value="${css_url}" />' />
	<link rel="stylesheet" type="text/css" href='<c:url value="/resources/css/ux-overrides.css" />' />
	<link rel="stylesheet" type="text/css" href='<c:url value="/resources/css/unilite_5.1.0.css" />' />
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="${ext_url }" />'></script>

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
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/UniUtils.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/UniTypes.js"/>' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/Unilite.js"/>' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/UniDate.js"/>' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/UniAppManager.js" />' ></script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/UniAbstractStore.js" />' ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/UniStore.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/UniModel.js" />' ></script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/button/BaseButton.js" />' ></script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniBaseField.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniClearButton.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniComboBox.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniTextField.js" />' ></script>
	

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/UniFields.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/column/UniDateColumn.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/column/UniTimeColumn.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/column/UniPriceColumn.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/column/UniNumberColumn.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/UniAbstractGridPanel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/UniGridPanel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/excel/Excel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/feature/UniGroupingSummary.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/feature/UniSummary.js" />' ></script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/locale/Message-ko.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/locale/unilite-lang-ko.js" />'> </script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/locale/ext-lang-ko.js" />' ></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/api.js" />'></script>
	
    <script type="text/javascript">
        

		
		Ext.require([
		    'Ext.data.*',
		    'Ext.tip.QuickTipManager',
		    'Ext.window.MessageBox'
		]);
		Ext.define("UniFormat", {
	    		singleton: true,
			 	Qty: 			'0,000', //						// 수량
			    UnitPrice: 		'0,000.00',		// "${loginVO.userID}",		// 단가
			    Price: 			'0,000',		// "${loginVO.userName}",		// 금액
			    FC: 			'0,000.00',  	// "${loginVO.personNumb}",	// 외화
			    ER: 			'0,000.00',  	//  ${loginVO.personNumb}",	// 환율
			    Percent: 		'0,000.00',		// "${loginVO.userID}",		// 확률
	 			FDATE:			'Y-m-d', 		//  "${loginVO.fDate}",			// 날자
			    FYM: 			'Y-m' //"${loginVO.fYM}"			// 연월
			 }
		);
        Ext.onReady(function(){
        	Ext.tip.QuickTipManager.init();
        	Ext.direct.Manager.addProvider(Ext.app.REMOTING_API);
        	
        	Ext.define('menuItemModel', {
				//extend:'Ext.data.Model',		//4.2.2
				extend:'Ext.data.TreeModel',	//5.0.0
				// pkGen : user, system(default)
				idProperty: 'prgID',
			    fields: [ 	{name: 'prgID' 		 	}
			    			,{name: 'text' 			}
			    			,{name: 'text_en' 		}
			    			,{name: 'text_cn' 		}
			    			,{name: 'text_jp' 		}
			    			,{name: 'url' 			}
			    			,{name: 'viewYN'		}
			    			,{name: 'qtip'}
			    			,{name: 'index'}
					]
			});
			
			var treeSystemMenuStore = Ext.create('Ext.data.TreeStore',{
				model: 'menuItemModel',
				storeId: 'treeSystemMenuStore',
		        autoLoad: true,
		        folderSort: true,
		        proxy: {
		            type: 'direct',
		            api: {
		                read : 'mainMenuService.getMenuList'
		            }
		        },
		        listeners: {
		        		//load: function(store, node, records, successful, eOpts) { //4.2.2
		        		load: function(store, records, successful, operation, node, eOpts) { //5.0.0	
		        			console.log("root System Menu load!");
		        			
		        		}
		        	
		        }
			});
			
			var treeStoreProc = Ext.create('Ext.data.TreeStore',{
				model: 'menuItemModel',
				storeId: 'treeProcMenuStore',
		        autoLoad: true,
		        folderSort: true,
		        proxy: {
		            type: 'direct',
		            api: {
		                read : 'mainMenuService.getProcessMenu'
		            }
		        },
		        listeners: {
		        		load: function(store, node, eOpts) {
		        			console.log("root Process Menu load!");
		        		}
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
		        	
		        ]
		    });
        });
    </script>
    <!-- </x-compile> -->
</head>
<body>
</body>
</html>
