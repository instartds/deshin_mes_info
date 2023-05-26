// @charset UTF-8
/**
 * @class Unilite.main.portal.MainPortalPanel
 * @extends Unilite.com.panel.portal.UniPortalPanel
 * Portal tab of Main view.
 */
Ext.define('Unilite.main.portal.MainPortalJoins', {
    extend: 'Unilite.com.panel.portal.UniPortalPanel',
    title: 'Portal',
    itemId: 'portal',
    id:"wrap",
    uniOpt: {
       'prgID': 'portal',
       'title': 'Portal'
    },
    //requires: ['Unilite.com.panel.portal.UniPortalPanel'],
    closable: false,
	scrollable:true,
    width:1200,
    //abstract 
    getPortalItems: function() {
    	Unilite.defineModel('aprvModel', {
    	    fields: [ {name: 'ESP_MAKE'			, text:'전표처리-작성진행'	,type: 'int', defaultValue:0}, 
    				  {name: 'ESP_APPROVE'		, text:'전표처리-결재진행'	,type: 'int', defaultValue:0}, 
    				  {name: 'ESP_VOTE'			, text:'전표처리-전표부결'	,type: 'int', defaultValue:0}, 
    				  {name: 'ESP_CANCLE'		, text:'전표처리-전표취소'	,type: 'int', defaultValue:0}, 
    				  {name: 'PD_MAKE'			, text:'품의서-작성진행'	,type: 'int', defaultValue:0}, 
    				  {name: 'PD_APPROVE'		, text:'품의서-결재진행'	,type: 'int', defaultValue:0}, 
    				  {name: 'PD_VOTE'			, text:'품의서-품의부결'	,type: 'int', defaultValue:0},
    				  {name: 'CC_MAKE'			, text:'법인카드-작성진행'	,type: 'int', defaultValue:0}, 
    				  {name: 'CC_APPROVE'		, text:'법인카드-결재진행'	,type: 'int', defaultValue:0}, 
    				  {name: 'CC_VOTE'			, text:'법인카드-품의부결'	,type: 'int', defaultValue:0}, 
    				  {name: 'APRV_SLIP_CNT'	, text:'전자결재-전표대기'	,type: 'int', defaultValue:0}, 
    				  {name: 'APRV_DOC_CNT'		, text:'전자결재-문서대기'	,type: 'int', defaultValue:0}]
    	});
    	
		
    	var store1 = new Ext.data.Store({
        	storeId: 'aprv',
      		model:'aprvModel',
			autoLoad:true,
			data:[{}],
      		proxy: {
                type: 'direct',
                api: {
                	read: 'mainPortalJoinsService.selectAprv'                	
                }
            },
            listeners:{
            	load:function(store, records, successful, operation, eOpt)  {
            		if(records == null || records.length == 0){
            			store.add({});
            		}
            	}
            }
    	});
    	
    	Unilite.defineModel('linkModel', {
    	    fields: [ 	 {name: 'menuID' 	 	}
		    			,{name: 'menuName' 		}
		    			,{name: 'cpath' 		}
		    			,{name: 'domain' 		}
		    			,{name: 'url' 			}
			]
    	});
    	var store2 = new Ext.data.Store({
        	storeId: 'aprv2',
      		model:'linkModel',
			autoLoad:true,
			data:[{}],
      		proxy: {
                type: 'direct',
                api: {
                	read: 'mainPortalJoinsService.selectLink'                	
                },
                extraParams:{'PGM_ID':'aep200skr,aep800ukr,aep805ukr,aep610skr,aep620skr,aep080skr,aep090skr' }
            },
            listeners:{
            	load:function(store, records, successful, operation, eOpt)  {
            		if(records != null && records.length == 0){
            			store.add({});
            		}
            	}
            }
    	});
    	
		Unilite.defineModel('boardModel', {
    	    fields: [ 	 {name: 'BULLETIN_ID'		, type: 'string' 	 	}
		    			,{name: 'TITLE'				, type: 'string'  		}
		    			,{name: 'UPDATE_DB_TIME'	, type: 'string'  		}
		    			,{name: 'TYPE_FLAG' 		, type: 'string' 		}
			]
    	});
    	
    	var store3 = new Ext.data.Store({
        	storeId: 'board',
      		model:'boardModel',
			autoLoad:true,
			data:[
				 {'TITLE':'&nbsp;', 'UPDATE_DB_TIME':' ', 'TYPE_FLAG':'1'}
				,{'TITLE':'&nbsp;', 'UPDATE_DB_TIME':' ', 'TYPE_FLAG':'1'}
				,{'TITLE':'&nbsp;', 'UPDATE_DB_TIME':' ', 'TYPE_FLAG':'1'}
				,{'TITLE':'&nbsp;', 'UPDATE_DB_TIME':' ', 'TYPE_FLAG':'1'}
				,{'TITLE':'&nbsp;', 'UPDATE_DB_TIME':' ', 'TYPE_FLAG':'1'}
				,{'TITLE':'&nbsp;', 'UPDATE_DB_TIME':' ', 'TYPE_FLAG':'2'}
				,{'TITLE':'&nbsp;', 'UPDATE_DB_TIME':' ', 'TYPE_FLAG':'2'}
				,{'TITLE':'&nbsp;', 'UPDATE_DB_TIME':' ', 'TYPE_FLAG':'2'}
				,{'TITLE':'&nbsp;', 'UPDATE_DB_TIME':' ', 'TYPE_FLAG':'2'}
				,{'TITLE':'&nbsp;', 'UPDATE_DB_TIME':' ', 'TYPE_FLAG':'2'}],
      		proxy: {
                type: 'direct',
                api: {
                	read: 'mainPortalJoinsService.selectBoard'
                }
            },
            listeners:{
            	load:function(store, records, successful, operation, eOpt)  {
            		if(records == null || records.length != 10){
            			var i=0, j=0;
            			Ext.each(records,function(record, idx){
            				if(record.get("TYPE_FLAG")=="1")	i++;
            				else j++;
            			})
            			for(var k=0 ; k < (5-i); k++)	{
            				store.add({'TITLE':'&nbsp;', 'UPDATE_DB_TIME':' ', 'TYPE_FLAG':'1'});
            			}
            			for(var k=0 ; k < (5-j); k++)	{
            				store.add({'TITLE':'&nbsp;', 'UPDATE_DB_TIME':' ', 'TYPE_FLAG':'2'});
            			}
            			portlet3.refresh();
            			
            		}
            	}
            }
            
    	});
    	var portlet1 = Ext.create('Ext.view.View', {
			tpl: [
				'<tpl for=".">' +
				'<div class="box01">'+
				'	<div class="cnt01">'+
				'		<h1 class="portal">전표처리</h1>'+ 
				'		<table class="basicTable01" cellspacing="0" cellpadding="0" width="100%">'+
				'			<tr>'+
				'				<th scope="row"  style="cursor: pointer;"  onclick="onlink(\'aep200skr\',\'\',\'\',\'\',\'\', \'aprv2\', {\'GW_STATUS\':[\'0\',\'1\']});">작성진행</th>'+
				'				<td><span class="orange"  style="cursor: pointer;" onclick="onlink(\'aep200skr\',\'\',\'\',\'\',\'\', \'aprv2\', {\'GW_STATUS\':[\'0\',\'1\']});">{ESP_MAKE}</span>건</td>'+
				'			</tr>'+
				'			<tr>'+
				'				<th scope="row"  style="cursor: pointer;" onclick="onlink(\'aep200skr\',\'\',\'\',\'\',\'\', \'aprv2\', {\'GW_STATUS\':[\'D\',\'A\']});">결재진행</th>'+
				'				<td><span class="orange"  style="cursor: pointer;" onclick="onlink(\'aep200skr\',\'\',\'\',\'\',\'\', \'aprv2\', {\'GW_STATUS\':[\'D\',\'A\']});">{ESP_APPROVE}</span>건</td>'+
				'			</tr>'+
				'			<tr>'+
				'				<th scope="row" style="cursor: pointer;" onclick="onlink(\'aep200skr\',\'\',\'\',\'\',\'\', \'aprv2\', {\'GW_STATUS\':[\'R\']});">전표부결</th>'+
				'				<td><span class="orange" style="cursor: pointer;" onclick="onlink(\'aep200skr\',\'\',\'\',\'\',\'\', \'aprv2\', {\'GW_STATUS\':[\'R\']});">{ESP_VOTE}</span>건</td>'+
				'			</tr>'+
				'			<tr>'+
				'				<th scope="row" style="cursor: pointer;" onclick="onlink(\'aep200skr\',\'\',\'\',\'\',\'\', \'aprv2\', {\'GW_STATUS\':[\'W\',\'X\']});">전표취소</th>'+
				'				<td><span class="orange" style="cursor: pointer;" onclick="onlink(\'aep200skr\',\'\',\'\',\'\',\'\', \'aprv2\', {\'GW_STATUS\':[\'W\',\'X\']});">{ESP_CANCLE}</span>건</td>'+
				'			</tr>'+
				'		</table>				'+
				'	</div>	'+
				'	<div class="cnt01">'+
				'		<h1 class="portal">품의서</h1>'+
				'		<table class="basicTable01" cellspacing="0" cellpadding="0">'+
				'			<tr>'+
				'				<th scope="row">작성진행</th>'+
				'				<td><span class="orange">{PD_MAKE}</span>건</td>'+
				'			</tr>'+
				'			<tr>'+
				'				<th scope="row">결재진행</th>'+
				'				<td><span class="orange">{PD_APPROVE}</span>건</td>'+
				'			</tr>'+
				'			<tr>'+
				'				<th scope="row">품의부결</th>'+
				'				<td><span class="orange">{PD_VOTE}</span>건</td>'+
				'			</tr>'+
				'		</table>				'+
				'	</div>'+
				'	<div class="cnt01">'+
				'		<h1 class="portal">법인카드</h1>'+
				'		<table class="basicTable01" cellspacing="0" cellpadding="0">'+
				'			<tr>'+
				'				<th scope="row">작성진행</th>'+
				'				<td><span class="orange">{CC_MAKE}</span>건</td>'+
				'			</tr>'+
				'			<tr>'+
				'				<th scope="row">결재진행</th>'+
				'				<td><span class="orange">{CC_APPROVE}</span>건</td>'+
				'			</tr>'+
				'			<tr>'+
				'				<th scope="row">품의부결</th>'+
				'				<td><span class="orange">{CC_VOTE}</span>건</td>'+
				'			</tr>					'+
				'		</table>				'+
				'	</div>	'+
				'	<div class="cnt02">'+
				'		<h1 class="portal">전자결재</h1>'+
				'		<table class="basicTable01" cellspacing="0" cellpadding="0">'+
				'			<tr>'+
				'				<th scope="row" style="cursor: pointer;" onclick="onlink(\'aep805ukr\',\'\',\'\',\'\',\'\', \'aprv2\');">문서대기</th>'+
				'				<td><span class="orange" style="cursor: pointer;" onclick="onlink(\'aep805ukr\',\'\',\'\',\'\',\'\', \'aprv2\');">{APRV_SLIP_CNT}</span>건</td>'+
				'			</tr>'+
				'			<tr>'+
				'				<th scope="row" style="cursor: pointer;" onclick="onlink(\'aep800ukr\',\'\',\'\',\'\',\'\', \'aprv2\');">전표대기</th>'+
				'				<td><span class="orange" style="cursor: pointer;" onclick="onlink(\'aep800ukr\',\'\',\'\',\'\',\'\', \'aprv2\');">{APRV_DOC_CNT}</span>건</td>'+
				'			</tr>'+
				'		</table>				'+
				'	</div>'+
				'	<p class="exa"><span class="orange">전표취소</span>는 <span class="str">경비재처리대상</span>입니다. 확인하시기 바랍니다. <span class="orange">결재진행건수</span>는 <span class="str">결재요청/결재진행중인 문서</span>를 포함합니다.<br><span class="orange">부결/취소</span>는 <span class="str">최근 한 달</span> 동안의 처리결과 입니다.</p>					'+					
				'</div>'+
				'</tpl>'
			],
			border:true,
			autoScroll:false,
			itemSelector: 'div.box01',
			overItemCls: 'selectedBox',
			selectedItemCls : 'selectedBox',
	        margin:'5 5 5 0',
	        loadMask:false,
	        store: Ext.data.StoreManager.lookup("aprv")//store1
		});

		var portlet2 = Ext.create('Ext.view.View', {
			tpl: [
				'<div class="box02">'+
				'	<h1 class="portal">카드이용내역</h1>'+
				'<div class="cardHistory">한달동안 사용한 카드내역을 확인하세요.</div>'+
				'<button class="btn01"  style="cursor: pointer;" onclick="onlink(\'aep610skr\',\'\',\'\',\'\',\'\', \'aprv2\');">상세보기</button>'+
				'</div>'
			],
			border:true,
			autoScroll:false,
			itemSelector: 'div.box02',
			overItemCls: 'selectedBox',
			selectedItemCls : 'selectedBox',
			loadMask:false,
	        margin:'5 5 5 0'
		});
		
		var portlet3 = Ext.create('Ext.view.View', {
			tpl: [
				'<div class="box03">'+
				'	<div class="cnt01">'+
				'	<div class="title"><h1 class="fl portal">공지사항</h1><a href="#" onclick="onlink(\'aep080skr\',\'\',\'\', \'\', \'\', \'aprv2\')"><span class="fr txt12">more ></span></a>'+
				'	</div>'+
				'	<table class="basicTable02" cellspacing="0" cellpadding="0">'+
				'		<tpl for=".">'+		
				'		<tpl if="TYPE_FLAG ==\'1\'">'+		
				'		<tr>'+
				'			<th scope="row"><a href="#"  onclick="onlink(\'aep080skr\',\'\',\'\', \'\', \'\', \'aprv2\',{\'BULLETIN_ID\':\'{BULLETIN_ID}\'})">{TITLE}</a></th>'+
				'			<td><span class="date">{UPDATE_DB_TIME}</span></td>'+
				'		</tr>'+
				'		</tpl>'+
				'		</tpl>'+
				'	</table>'+
				'</div>'+
				'<div class="cnt02">'+
				'	<div class="title">'+
				'		<h1 class="fl portal">FAQ</h1><a href="#" onclick="onlink(\'aep090skr\',\'\',\'\', \'\', \'\', \'aprv2\')"><span class="fr txt12">more ></span></a>				'+	
				'	</div>'+
				'	<table class="basicTable02" cellspacing="0" cellpadding="0">'+
				'		<tpl for=".">'+		
				'		<tpl if="TYPE_FLAG ==\'2\'">'+		
				'		<tr>'+
				'			<th scope="row"><a href="#"  onclick="onlink(\'aep090skr\',\'\',\'\', \'\', \'\', \'aprv2\',{\'BULLETIN_ID\':\'{BULLETIN_ID}\'})">{TITLE}</a></th>'+
				'			<td><span class="date">{UPDATE_DB_TIME}</span></td>'+
				'		</tr>'+
				'		</tpl>'+
				'		</tpl>'+
				'	</table>'+
				'	</div>		'+
				'</div>'
			],
			border:true,
			autoScroll:false,
			itemSelector: 'div.box03',
			overItemCls: 'selectedBox',
			selectedItemCls : 'selectedBox',
			loadMask:false,
	        margin:'5 5 5 0',
	        store: Ext.data.StoreManager.lookup("board")//store3
		});
		
		var portlet4 = Ext.create('Ext.view.View', {
			tpl: [
				'<div class="box04">'+
					'	<button class="btn02" style="cursor: pointer;"  onclick="onlink(\'aep200skr\',\'\',\'\',\'\',\'\',\'aprv2\');"><span style="font-size:16px; color:#000;">전표조회</span><br>전표처리내역 확인</button>'+
					'	<button class="btn03" style="cursor: pointer;"  onclick="onlink(\'aep620skr\',\'\',\'\',\'\',\'\',\'aprv2\');"><span style="font-size:16px; color:#000;">카드관리</span><br>요청서처리내역 조회</button>'+

				'</div>'
				
			],
			border:true,
			autoScroll:false,
			itemSelector: 'div.box04',
			overItemCls: 'selectedBox',
			selectedItemCls : 'selectedBox',
			loadMask:false,
	        margin:'5 5 5 0'
		});
    	var itemCol1 = {
    		width:870,
    		height:275,
    		defaults:{
    			frame: false,
			    closable: false,
			    collapsible: false,
			    animCollapse: false,
			    border:0,
			    height:275,
			    width:800,
			    padding: '0 0 0 0',
			    draggable: false,
				floating :false 
    		},
	        items: [{
	        	 layout: 'fit',
	        	items:[portlet1]
	        },{
	           layout: 'fit',
	        	items:[portlet3]
	        }]
	    };
	    
	    var itemCol2 = {
	    	width:330,
	    	height:275,
    		defaults:{
    			frame: false,
			    closable: false,
			    collapsible: false,
			    animCollapse: false,
			    border:0,
			    height:275,
			    width:330,
			    layout: 'fit',
			    padding: '0 0 0 0',
			    closable: false,
			    collapsible: false,
			    animCollapse: false,
			    draggable: false,
				floating :false 
    		},
	        items: [{
	        	layout: 'fit',
	        	items:[portlet2]
	        },{
	            layout: 'fit',
	        	items:[portlet4]
	        }]
	    };
	    
	    return [itemCol1,
    			itemCol2]
    },
    
    //initialize
    initComponent: function() {
    	var me = this;
    	
    	Ext.apply(this, {
    		items: this.getPortalItems()
    	});
    		    
    	this.callParent();
    }
});

function onlink(prgID,text,url, cpath, domain, storeId, params)	{
	var store = Ext.data.StoreManager.lookup(storeId)
	var recData ;
	
	Ext.each(store.getData().items, function(item, idx) {
		if(item.get("menuID") == prgID)	{
			recData = item;
			recData.set("prgID", item.get("menuID"));
			recData.set("text", item.get("menuName"));
			if(Ext.isEmpty(url))	{
				url = item.get("url");
			}
			if(Ext.isEmpty(cpath))	{
				cpath = item.get("cpath");
			}
			if(Ext.isEmpty(domain))	{
				domain = item.get("domain");
			}
		}
	})
	
	//{'data':{'prgID': prgID,'text':text,'cpath':cpath,'domain':domain}};
	if(params)	{
		params.PGM_ID = 'dashboard';
	}
	openTab(recData, url, params, domain+cpath);
	
}