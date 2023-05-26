<%@page language="java" contentType="text/html; charset=utf-8"%>

	var reqWindow;
		
	var empStore = Unilite.createStore('empStore', { 
		fields : [
			{name:'value', type:'string'}
			,{name:'text', type:'string'}
			,{name:'search', type:'string'}
		],
		data :[
			 {'value':'10129', 'text':'윤병현', 'search':'10129윤병현'}
			,{'value':'10015', 'text':'조광웅', 'search':'10015조광웅'}
			,{'value':'10071', 'text':'권종준', 'search':'10071권종준'}
			,{'value':'10188', 'text':'유영신', 'search':'10188유영신'}
			,{'value':'10191', 'text':'최호열', 'search':'10191최호열'}
			,{'value':'10192', 'text':'박무경', 'search':'10192박무경'}
			,{'value':'10190', 'text':'문하윤', 'search':'10190문하윤'}
			,{'value':'10157', 'text':'여운형', 'search':'10157여운형'}
			,{'value':'10169', 'text':'이동희', 'search':'10169이동희'}
			,{'value':'10166', 'text':'김현민', 'search':'10166김현민'}
			,{'value':'10170', 'text':'최우성', 'search':'10170최우성'}
			,{'value':'10179', 'text':'김홍희', 'search':'10179김홍희'}
			,{'value':'10184', 'text':'조영한', 'search':'10184조영한'}
			,{'value':'10185', 'text':'김의중', 'search':'10185김의중'}
			,{'value':'10193', 'text':'남기현', 'search':'10193남기현'}
			,{'value':'10187', 'text':'김용현', 'search':'10187김용현'}
			,{'value':'10093', 'text':'배성한', 'search':'10093배성한'}
			,{'value':'10100', 'text':'서민근', 'search':'10100서민근'}
			,{'value':'10136', 'text':'이혜민', 'search':'10136이혜민'}
			,{'value':'10127', 'text':'박재우', 'search':'10127박재우'}
			,{'value':'10168', 'text':'김태희', 'search':'10168김태희'}
			,{'value':'10175', 'text':'이정현', 'search':'10175이정현'}
			,{'value':'10198', 'text':'이가영', 'search':'10198이가영'}
			,{'value':'10146', 'text':'채성민', 'search':'10146채성민'}
			,{'value':'10172', 'text':'김예경', 'search':'10172김예경'}
			,{'value':'10165', 'text':'정노영', 'search':'10165정노영'}
			,{'value':'10154', 'text':'최바다', 'search':'10154최바다'}
		]
	});
		
	var stateStore = Unilite.createStore('stateStore', { 
		fields : [
			{name:'value', type:'string'}
			,{name:'text', type:'string'}
			,{name:'search', type:'string'}
		],
		data :[
			 {'value':'00', 'text':'개발요청', search:'00개발요청'}
			,{'value':'01', 'text':'확인', search:'01확인'}
			,{'value':'02', 'text':'진행', search:'02진행'}
			,{'value':'03', 'text':'완료', search:'03완료'}
		]
	});
	
	var testStateStore = Unilite.createStore('testStateStore', { 
		fields : [
			{name:'value', type:'string'}
			,{name:'text', type:'string'}
			,{name:'search', type:'string'}
		],
		data :[
			 {'value':'01', 'text':'진행', search:'01진행'}
			,{'value':'02', 'text':'테스트완료', search:'02테스트완료'}
			,{'value':'03', 'text':'배포', search:'03배포'}
		]
	});
	
	var editStateStore = Unilite.createStore('editStateStore', { 
		fields : [
			{name:'value', type:'string'}
			,{name:'text', type:'string'}
			,{name:'search', type:'string'}
		],
		data :[
			 {'value':'C', 'text':'생성', search:'C생성'}
			,{'value':'U', 'text':'수정', search:'U수정'}
			,{'value':'D', 'text':'삭제', search:'D삭제'}
		]
	});
	
	var workGubunStore = Unilite.createStore('workGubunStore', { 
		fields : [
			{name:'value', type:'string'}
			,{name:'text', type:'string'}
			,{name:'search', type:'string'}
		],
		data :[
			 {'value':'1', 'text':'정규', search:'1정규'}
			,{'value':'2', 'text':'사이트', search:'2사이트'}
		]
	});
	
	/*var projectStore = Unilite.createStore('projectStore', { 
		fields : [
			{name:'value', type:'string'}
			,{name:'text', type:'string'}
			,{name:'search', type:'string'}
		],
		data :[
			 {'value':'0000', 'text':'OmegaPlus(정규)', search:'0000OmegaPlus(정규)'}
			,{'value':'0001', 'text':'유양산전', search:'0001유양산전'}
			,{'value':'0002', 'text':'극동가스켓', search:'0002극동가스켓'}
			,{'value':'0003', 'text':'JWorld', search:'0003JWorld'}
			,{'value':'0004', 'text':'양평공사', search:'0004양평공사'}
			,{'value':'0005', 'text':'성남도시개발', search:'0005성남도시개발'}
		]
	});*/
	
	