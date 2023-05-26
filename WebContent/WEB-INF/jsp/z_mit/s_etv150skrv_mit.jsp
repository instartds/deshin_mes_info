<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<t:appConfig pgmId="s_etv150skrv_mit"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="s_etv150skrv_mit"  />			 <!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="WZ08" /> <!-- 외주/자재구분  --> 
	<t:ExtComboStore comboType="AU" comboCode="WZ21" /> <!-- 가공구분  -->
</t:appConfig>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' >
</script>

<style type="text/css">

.x-change-cell1 {
color: red;
}

.x-group-header {
height:auto;
}
.x-grid-cell-essential {background-color:yellow;}

.x-grid-cell {
	height: 40px;
	border-left: 1px solid #FFFFFF !important;
	border-right: 1px solid #eee !important;
	font: normal 20px Malgun Gothic,Gulim,tahoma, arial, verdana, sans-serif;
	font-weight: bold;
}
.x-grid-cell-inner {
	padding: 5px 6px 2px 6px;
}
</style>
<script type="text/javascript" >

function appMain() {
	
	var glInterval = ${glInterval};
	var chkinterval = null;
	var exchgInterval = null;
	var nextPgmId = '${nextPgmId}';
	var contentsList = ${contentsList};
	var glPageSize = 15;
	
	var contents = new Array();
	
	Unilite.defineModel('s_etv150skrv_mitModel', {
		fields: [
			{name: 'ITEM_CODE'		, text:'품목코드'		, type: 'string'},
			{name: 'SPEC'			, text:'규격'			, type: 'string'},
			{name: 'PLAN_Q'			, text:'계획량'		, type: 'uniQty'},
			{name: 'ITEM_WITH'		, text:'직경'		, type: 'uniQty'},
			{name: 'ITEM_LENGTH'		, text:'길이'		, type: 'uniQty'},
			{name: 'SPRING_VALE'		, text:'탄성측정값'		, type: 'uniQty'}
		]
	});

	Unilite.defineModel('s_etv150skrv_mitModelContents', {
		fields: [
			{name: 'TITLE'			, text:'제목'			,type: 'string'},
			{name: 'CONTENTS'		, text:'공시사항'		,type: 'string'}
		]
	});
	
	var directMasterStore = Unilite.createStore('s_etv150skrv_mitMasterStore',{
		model: 's_etv150skrv_mitModel',
		uniOpt : {
			isMaster:  false,			// 상위 버튼 연결 
			editable:  false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi :  false			// prev | newxt 버튼 사용
		},
		autoLoad: true,
		pageSize: glPageSize,
		proxy: Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			
			api: {			
			   read: 's_etv150skrv_mitService.selectList'
			},
			reader: {
				rootProperty: 'records',
				totalProperty: 'total'
			}
		}),
		loadStoreRecords : function() {
			this.load(
//				 params :param 
			);
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)){
					clearInterval(chkinterval);
					chkinterval = setInterval(function(){
						var record = records[records.length - 1];
						if(record.get('TOTAL') == record.get('ROW_NUMBER')){
							if(Ext.isEmpty(nextPgmId)) {
								//masterGrid.down("#ptb").moveFirst();
								window.location.reload();
							}
							else {
								window.location.href = CPATH + nextPgmId + ".do";
							}
						} else {
							masterGrid.down("#ptb").moveNext();
						}
						//directMasterStore.loadStoreRecords();
					}, glInterval);
				}else{
					clearInterval(chkinterval);
					chkinterval = setInterval(function(){
						if(Ext.isEmpty(nextPgmId)) {
							//directMasterStore.loadStoreRecords();
							window.location.reload();
						}
						else {
							window.location.href = CPATH + nextPgmId + ".do";
						}
					}, glInterval);
				}
			}
		}
	});
	
	var directContentsStore = Unilite.createStore('s_etv150skrv_mitContentsStore', {
		model: 's_etv150skrv_mitModelContents',
		uniOpt: {
			isMaster:  false,	// 상위 버튼 연결 
			editable:  false,	// 수정 모드 사용 
			deletable: false,	// 삭제 가능 여부 
			useNavi :  false	// prev | newxt 버튼 사용
		},
		autoLoad: true,
		proxy: Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
			api: {
				read: 's_etv150skrv_mitService.selectContents'
			}
		}),
		loadStoreRecords : function() {
			this.load(
				
			);
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(store.getCount() > 0) {
					fnSetExchgItems(records);
					//panelsouth.suspendLayouts(true);
					panelsouth.removeAll();
					panelsouth.add(contents);
					//panelsouth.suspendLayouts(false);
					panelsouth.updateLayout();
				}
			}
		}
	});	

	var masterGrid = Unilite.createGrid('s_etv150skrv_mitMasterGrid', {
		layout : 'fit',
		region: 'center',
		//width:'100%',
		store: directMasterStore,
		uniOpt: {
			onLoadSelectFirst : false,
			expandLastColumn: false,
			userToolbar :false,
			useRowNumberer: false,		//번호 컬럼 사용 여부
			useLoadFocus:false
		},
		bbar: [{
				itemId:'ptb',
				xtype: 'pagingtoolbar',
				store: directMasterStore,
				pageSize: glPageSize,
				displayInfo: true
		}],
		selModel:'rowmodel',
		columns:  [ 
			{ dataIndex: 'ITEM_CODE'			, flex: 1	, minWidth: 120, align:'center'},
			{ dataIndex: 'SPEC'					, flex: 1	, minWidth: 120},
			{ dataIndex: 'PLAN_Q'				, flex: 1	, minWidth: 120},
			{ dataIndex: 'ITEM_WITH'				, flex: 1	, minWidth: 120},
			{ dataIndex: 'ITEM_LENGTH'			, flex: 1	, minWidth: 120},
			{ dataIndex: 'SPRING_VALE'				, flex: 1	, minWidth: 120}
		] 
	});
	
	var panelSearch = Unilite.createSearchForm('panelSearch',{
		region: 'north',
		layout : {type : 'uniTable', columns : 1
				,tableAttrs: {width: '100%'}
		},
		padding:'0 0 0 0',
		border:false,
		items: [
			{
			xtype	: 'component',
			html	: '스텐트탄성측정 현황',
			style 	: {
				'font-size': '40px !important',
				'font-weight':'bold',
				'text-align':'center'
			}
		},
		{
			xtype	: 'component',
			html	: '',
			style 	: {
				'font-size': '32px !important',
        		'font-weight':'bold',
        		'text-align':'center'
			},
			itemId 	: 'nowDay'
		}]
	});
	
	var panelsouth = Unilite.createSearchForm('southForm', {
		region: 'south',
		title : '[공지사항]',
		layout : {type : 'uniTable', columns : 1, tableAttrs: { width: '100%'},
												  tdAttrs: {style: 'font-size:14px;', align : 'left'}},
		height		: '15%',
		padding:'1 1 1 1',
		border:true,
		items: contents
	});

	Unilite.Main( {
		borderItems:[{
				region:'center',
				layout: 'border',
				border: false,
				items:[
					panelSearch, masterGrid, panelsouth
				]
			}   
		],
		uniOpt:{
			showToolbar: false
//			forceToolbarbutton:true
		},
		id  : 's_etv150skrv_mitApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'],false);
			UniAppManager.setToolbarButtons(['reset'], true);
			this.setDefault();
			goFullscreen();
		},
		onQueryButtonDown : function()  {
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			directMasterStore.clearData(); 
			masterGrid.reset();
			
			clearInterval(chkinterval);
			this.setDefault();
		},
		setDefault: function() {
			realTime();
		}
	}); 
	
	//시간 출력
	function realTime() {
		const nowDate = new Date();
		const year	  = nowDate.getFullYear();
		const month	  = nowDate.getMonth() + 1;
		const date	  = nowDate.getDate();
		
		panelSearch.down('#nowDay').setHtml("(" + year + "." + addzero(month) + "." + addzero(date) + ")");
	}
	
	// 1자리 수의 숫자인 경우 앞에 0을 붙여준다.
	function addzero(num) {
		if(num < 10) {num = "0" + num;}
		return num;
	}  
	
	function goFullscreen() {
		var el = document.getElementById('ext-body');
		var requestMethod = el.requestFullScreen || el.webkitRequestFullScreen || el.mozRequestFullScreen || el.msRequestFullScreen;
		
		if (requestMethod) { // Native full screen.
			requestMethod.call(el);
		} else if (typeof window.ActiveXObject !== "undefined") { // Older IE.
			var wscript = new ActiveXObject("WScript.Shell");
			if (wscript !== null) {
				wscript.SendKeys("{F11}");
			}
		}
	}
	
	function fnSetExchgItems(param) {
		contents = [];
			
		contents.push({
			xtype:'component',
			html:'&nbsp;',
			height:5,
			tdAttrs: {width:'100%'}
		});	//	상단공백	
		
		Ext.each(param, function(record, index){
			if(record.hasOwnProperty('data')) {
				record = record.data;
			}			
			
			/*
			
			var text1 = '<div style="display:inline-block;">'
					 + record.TITLE + ' : '
					 + '</div>';
			
			var content1 = {
				xtype:'component',
				html:text1
			};
					
			contents.push(content1);
			*/
			
			if(lLoop < 2) {
				return false;
			}
			else {
				lLoop++;
			}
			
			var text2 = '<div style="display:inline-block;font-size:15pt;">'
					 + ' '
					 + record.CONTENTS
					 + '</div>';
			
			var content2 = {
				xtype:'component',
				html:text2
			};
			
			contents.push(content2);
		});	
		
		for(var rowCnt = 2 - param.length; rowCnt > 0; rowCnt--){
			contents.push({
				xtype:'component',
				html:'&nbsp;'
			});	//	하단공백채우기
		}
		
		contents.push({
			xtype:'component',
			html:'&nbsp;',
			height:5
		});	//	하단공백
	}
}
</script>