<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<t:appConfig pgmId="ppl320ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="ppl320ukrv"/> 					 <!-- 사업장 -->
	<t:ExtComboStore comboType="WU" />											 <!-- 작업장  -->
	<t:ExtComboStore comboType="AU" comboCode="P402" /> 						 <!-- 참조유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B074" /> 						 <!-- 양산구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S002" /> 						 <!-- 매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> 						 <!-- 품목계정 -->


</t:appConfig>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/js/moment/moment-with-langs.min.js" />' ></script>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<!-- App css -->
<link href="<c:url value='/resources/z_rmgmt/assets/css/icons.min.css '/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/resources/z_rmgmt/assets/css/app-dark.min.css '/>" rel="stylesheet" type="text/css" id="light-style" />

<link href="<c:url value='/resources/z_rmgmt/assets/css/dataTables/dataTables.bootstrap4.min.css '/>" type="text/css" rel="stylesheet" />
<link href="<c:url value='/resources/z_rmgmt/assets/css/dataTables/buttons.bootstrap4.min.css '/>" type="text/css" rel="stylesheet" />
<script src="<c:url value='/resources/z_rmgmt/assets/js/vendor.min.js' />"></script>
<script src="<c:url value='/resources/z_rmgmt/assets/js/app.min.js' />"></script>
<link rel="shortcut icon" href='<c:url value="/resources/images/main/${logoIco}" />' type="image/x-icon" />


<script type="text/javascript" >
function appMain() {

	var gantt = Ext.get(Ext.fly("container"));
	var referOrderInformationWindow;	//수주정보참조
	var apsParameterPopup;				//aps파라미터 팝업
	var saveFlag = ''					//고정, 확정, dummy 저장 flag
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'ppl320ukrvService.selectList'
		}
	});
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'ppl320ukrvService.selectDetailList',
			update	: 'ppl320ukrvService.updateList',
			syncAll	: 'ppl320ukrvService.saveAll'
		}
	});
	


	/* Model 정의
	 * @type
	 */
	Unilite.defineModel('ppl320ukrvModel', {
	    fields: [
	    	  {name : 'SCHEDULE_NO'      , text:'NO'         		,type:'int' }
		     ,{name : 'DIV_CODE'         , text:'사업장'      		,type:'string' }
	    	 ,{name : 'ORDER_NUM'        , text:'수주번호'      		,type:'string' }
	    	 ,{name : 'SEQ'              , text:'수주순번'      		,type:'string' }
	    	 ,{name : 'WORK_SHOP_CODE'   , text:'작업장'    	   		,type:'string' }
	    	 ,{name : 'WORK_SHOP_NM'     , text:'작업장'    	   		,type:'string' }
	    	 ,{name : 'EQU_CODE'   		 , text:'설비'     	   		,type:'string' }
	    	 ,{name : 'EQU_NAME'   		 , text:'설비명'    	   		,type:'string' }
	    	 ,{name : 'ITEM_CODE'        , text:'품목'     	   		,type:'string' }
	    	 ,{name : 'ITEM_NAME'        , text:'품목명'     	   		,type:'string' }
	    	 ,{name : 'ORDER_Q'          , text:'누적계획량'     		,type:'string' }
	    	 ,{name : 'WK_PLAN_Q'        , text:'계획량'    	   		,type:'uniQty' }
	    	 ,{name : 'PLAN_START_DATE'  , text:'시작일'    	   		,type:'string', align:'center' }
	    	 ,{name : 'PLAN_START_TIME'  , text:'시작시간'    	   	,type:'string', align:'center'}
	    	 ,{name : 'PLAN_END_DATE'    , text:'종료일'      		,type:'string', align:'center' }
	    	 ,{name : 'PLAN_END_TIME'    , text:'종료시간'      		,type:'string', align:'center' }
	    	 ,{name : 'DURATION'         , text:'기간'     	   	 	,type:'int' }
	    	 ,{name : 'WK_PLAN_NUM'	     , text:'계획번호'     		,type:'string' }
	    	 ,{name : 'START_DATE'       , text:'준비시간'    	   	,type:'string', align:'center'}
	    	 ,{name : 'END_DATE'  		 , text:'정리시간'    	   	,type:'string', align:'center'}
	    	 ,{name : 'CONFIRM_YN'		 , text:'확정여부'			,type:'string'}
	    	 ,{name : 'DEPENDENCY_FROM'	 , text:'Dependency 시작'	,type:'string'}
	    	 ,{name : 'DEPENDENCY_TO'	 , text:'Dependency 종료'	,type:'string'}
			]
	});

	/* Store 정의(Service 정의)
	 * @type
	 */
	var apsStore = Unilite.createStore('ppl320ukrvMasterStore1',{
		model: 'ppl320ukrvModel',
		uniOpt : {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: false,			// 삭제 가능 여부
			useNavi 	: false			// prev | newxt 버튼 사용
		},
        autoLoad: false,
        proxy	: directProxy1,
        loadStoreRecords : function( )	{
			var param= Ext.getCmp('resultForm').getValues();
			console.log( param );
			//Ext.getBody().mask();
			this.load({
				params : param,
				callback : function()	{
					Ext.getBody().unmask();
				}
			});
		},
		saveStore: function( flag ) {
			var inValidRecs	= this.getInvalidRecords();
			var toCreate = this.getNewRecords();		// 추가
			var toUpdate = this.getUpdatedRecords();	// 수정
			var toDelete = this.getRemovedRecords();	// 삭제
			var list = [].concat(toCreate, toUpdate, toDelete);
			var paramMaster = Ext.getCmp('resultForm').getValues();
			
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						UniAppManager.app.setBtnDisabled(false);
					},
					failure: function()	{
						UniAppManager.app.setBtnDisabled(false);
					}
				};
				UniAppManager.app.setBtnDisabled(true);
				this.syncAllDirect(config);
			} 
		},
		updateStore:function(eventRecord) {
			var store = this;
			Ext.each( store.getData().items, function(record, i){
				if(record.get('SCHEDULE_NO') == eventRecord.get('SCHEDULE_NO')){
					if(!Ext.isEmpty(eventRecord.get("startDate"))){
						var startDate = eventRecord.get("startDate");
							startTime = startDate.getHours()*60 + startDate.getMinutes() ;
							
							record.set('PLAN_START_DATE', Ext.Date.format(startDate, Unilite.dbDateFormat));
							if(startTime > 0)	{
								tStartDateTime = UniDate.add(startDate, {'minutes' : startTime*-1});
								record.set('PLAN_START_TIME', UniDate.diff(tStartDateTime, startDate, 'm'));
							} else {
								record.set('PLAN_START_TIME',0);
							}
							record.set('startDate', eventRecord.get("startDate"));
					}
					if(!Ext.isEmpty(eventRecord.get("endDate"))){
						var endDate   = eventRecord.get("endDate");
							endTime   = endDate.getHours()*60 + endDate.getMinutes();
							record.set('PLAN_END_DATE'  , Ext.Date.format(endDate, Unilite.dbDateFormat));
							if(endTime > 0)	{
								tEndDateTime = UniDate.add(endDate, {'minutes' : endTime*-1})
								record.set('PLAN_END_TIME'  , UniDate.diff(tEndDateTime, endDate, 'm'));
							}else {
								record.set('PLAN_END_TIME'  , 0);
							}
							record.set('endDate', eventRecord.get("endDate"));
					}
					if(!Ext.isEmpty(eventRecord.get("WK_PLAN_Q"))){
						var wkPlanQ   = eventRecord.get("WK_PLAN_Q");
						record.set('WK_PLAN_Q'  , wkPlanQ);
					}
				}
			}); 
			store.saveStore();
		},	
		loadDependency : function (eventRecord, showDependency) {
			var store = this;
			if(showDependency == null)	{
				showDependency = schedulerTask.getField("showDependency").checked;
			}
			if(showDependency)	{
				var dependencyData = new Array();
				if (eventRecord == null && scheduler && scheduler.selectedEvents && scheduler.selectedEvents.length > 0){
					eventRecord = scheduler.selectedEvents[0]
				}
				if(eventRecord != null )	{
					Ext.each( store.getData().items, function(record, i){
						if(record.get('ORDER_NUM') == eventRecord.get('ORDER_NUM') && record.get('SEQ') == eventRecord.get('SEQ')){
							var dependency = new Object();
							dependency = {
									'id' : record.get("id"),
									'from' : record.get("DEPENDENCY_FROM"),
									'to' : record.get("DEPENDENCY_TO")
							}
							dependencyData.push(dependency);
						}
					}); 
					scheduler.dependencyStore.data = dependencyData;
				}
				setTimeout(function() {scheduler.highlightSuccessors = scheduler.highlightPredecessors = true;}, 500)
			} else {
				scheduler.dependencyStore.data = [];
				scheduler.highlightSuccessors = scheduler.highlightPredecessors = false;
			}
			
		},	
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		store.loadDependency();  
           	},
           	update: function(store, records, successful, eOpts) {

           	}
		}
	});


	/* 검색조건 (Search Panel)
	 * @type
	 */


	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout	: {type : 'uniTable', columns : 4},
		padding: '1 1 1 1',
		border: true,
		items: [{
				fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false
			},{
				xtype	: 'container',
				layout	: {type:'hbox', align:'stretch'},
				width	: 330,
				items	: [{
					fieldLabel	: '계획주차',
					name		: 'PLAN_DATE_FR',
					xtype		: 'uniDatefield',
					allowBlank	: false,
					value       : UniDate.today(),
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							if(Ext.isDate(newValue) && newValue != oldValue)	{
								if(!Ext.isEmpty(newValue)){
									UniAppManager.app.getCalNo(newValue, panelResult.getField("WEEK_NUM"), true);
								}
							}
						}
					}
				},{
					fieldLabel	: '계획주차FR',
					xtype		: 'uniTextfield',
					name		: 'WEEK_NUM',
					width		: 60,
					hideLabel	: true,
					allowBlank	: false,
					readOnly    : true
				}]
			},{
				xtype : 'button',
				text  : '조회',
				itemId : 'bSearch',
				tdAttrs : {width : 200, align:'right'},
				width : 100,
				colspan : 2,
				handler : function()	{ 
					UniAppManager.app.loadSchedule();   
					
				}
			},
			 Unilite.popup('ORDER_NUM',{
				fieldLabel		: '수주번호',
				textFieldName:'ORDER_NUM',
				DBtextFieldName: 'ORDER_NUM',
				autoPopup       : true,
				listeners		: {
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
			}), 
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				listeners		: {
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
			}),{
				xtype : 'button',
				text  : '확정',
				width : 100,
				tdAttrs : {width : 200, align:'right'},
				colspan : 2,
				handler : function()	{
					var i = 0;
					if(confirm("해당 주차의 스케줄을 확정 하시겠습니까?"))	{
						Ext.each( apsStore.getData().items, function(record, i){
							if(record.set('CONFIRM_YN') != "Y")	{
								record.set('CONFIRM_YN', 'Y');
								i++;
							}
						});
						if(i == 0)	{
							Unilite.messageBox("확정할 데이터가 없습니다.");
							return;
						}
						apsStore.saveStore();
					} 
				}
			},{
				fieldLabel	: '스케줄러 시작일',
				name		: 'START_DATE',
				xtype		: 'uniDatefield',
				hidden   	: true
			},{
				fieldLabel	: '스케줄러 마지막일',
				name		: 'END_DATE',
				xtype		: 'uniDatefield',
				hidden   	: true
			}]
	});
	var schedulerTask = Unilite.createSearchForm('schedulerTaskForm',{
    	region: 'north',
		layout	: {type : 'uniTable', columns : 6, tableAttrs:{border : 0}},
		padding: '1 1 1 1',
		title : 'APS 차트 설정',
		border: false,
		collapsible : true,
		collapseDirection : 'top',
		items: [{
				fieldLabel	: '틱보기',
				labelWidth   : 90,
				xtype		: 'checkbox',
				width		: 120,
				checked     : true,
				listeners : {
					change : function(field, checked)	{
						if(!Ext.isEmpty(scheduler))	{
								scheduler.fillTicks = checked;
						}
					}
				}
			},{
				fieldLabel	: '연결 보기',
				labelWidth  : 150,
				name        : 'showDependency',
				xtype		: 'checkbox',
				width		: 1000,
				checked     : true,
				listeners : {
					change : function(field, checked)	{
						if(!Ext.isEmpty(scheduler))	{
							apsStore.loadDependency(null, checked);
						}
					}
				}
			},{
				xtype : 'container',
				layout : 'hbox',
				width : 200,
				items : [{
					xtype : 'button',
					itemId : 'bPrev',
					text  : '<',
					width : 55,
					handler : function()	{
						var dt = panelResult.getValue("START_DATE");
						if(!moment.isMoment(dt)) {
							dt =moment(UniDate.extParseDate(dt));
						}
						var rv = dt.startOf("week").add('day',-7).format('YYYYMMDD');
						panelResult.setValue('PLAN_DATE_FR',rv)
						UniAppManager.app.getCalNo(rv, panelResult.getField("WEEK_NUM"), true);
					}
				},{
					xtype : 'button',
					text  : '현재',
					itemId : 'bNow',
					width : 90,
					handler : function()	{
						panelResult.setValue('PLAN_DATE_FR',UniDate.today())
						UniAppManager.app.getCalNo(UniDate.today(), panelResult.getField("WEEK_NUM"), true);
					}
				},{
					xtype : 'button',
					text  : '>',
					itemId : 'bNext',
					width : 55,
					handler : function()	{
						var dt = panelResult.getValue("START_DATE");
						if(!moment.isMoment(dt)) {
							dt =moment(UniDate.extParseDate(dt));
						}
						var rv = dt.startOf("week").add('day',7).format('YYYYMMDD');
						panelResult.setValue('PLAN_DATE_FR',rv)
						UniAppManager.app.getCalNo(rv, panelResult.getField("WEEK_NUM"), true);
					}
				}]
			},{
				xtype : 'component',
				flex : 1,
				html : '&nbsp;'
			},{
				xtype : 'button',
				text  : '전체화면',
				handler : function()	{
					var fullScreenBtn = Ext.fly('fullscreen-button');
					if(fullScreenBtn)	{
						fullScreenBtn.dom.click()
					}
				}
			},{
				xtype : 'button',
				text  : 'APS 설정',
				hidden : true,
				handler : function()	{
					var infoButtonBtn = Ext.fly('b-button-3');
					if(infoButtonBtn)	{
						infoButtonBtn.dom.click()
					}
					
				}
			}]
	});

    Unilite.Main({
    	borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult,
				schedulerTask,
				{
					region : 'center',
					layout :'fit',
					items : [ gantt]
				}
			]
		}/*,
			panelSearch*/
		],
		uniOpt:{showKeyText:false,
				showToolbar: false
//        	forceToolbarbutton:true
		},
		id  : 'ppl320ukrvApp',
		fnInitBinding : function(params) {
		
			scheduler.on({
				eventClick(event) {
					apsStore.loadDependency(event.eventRecord);
					;  //eventClick에서 마지막 빈 라인이 없을 경우 스케줄 수정 팝업이 생성 되지 않음.
				},
			    eventDrop(event){
			    	apsStore.updateStore(event.eventRecord);
			    },eventResizeEnd(event){
			    	apsStore.updateStore(event.eventRecord);
			    },afterEventSave(event){
			    	apsStore.updateStore(event.eventRecord);
			    }  /* ,
			    dependenciesDrawn(event){
			    	
		    		var showDependency = schedulerTask.getField("showDependency").checked;
					scheduler.highlightSuccessors = scheduler.highlightPredecessors = showDependency;
			    	
					;
			    }  */
			});
			try {
				var schedulerHeaderDom = Ext.fly("container").dom.getElementsByClassName('demo-header');
				if(schedulerHeaderDom && schedulerHeaderDom.length > 0)	{
					schedulerHeaderDom[0].hidden = true;
				} 
			} catch(e){
				console.log(e);
			}
			panelResult.setValue('DIV_CODE'	    , UserInfo.divCode);
			this.getCalNo(UniDate.today(), panelResult.getField("WEEK_NUM"));
		},
		getCalNo : function(cal_date, field, dataLoad) {
			var param = {
				'OPTION_DATE'	: UniDate.getDbDateStr(cal_date),
				'CAL_TYPE'		: '3' //주단위
			}
			UniAppManager.app.setBtnDisabled(true);
			ppl320ukrvService.getCalNo(param, function(provider, response) {
				UniAppManager.app.setBtnDisabled(false);
				if(!Ext.isEmpty(provider.CAL_NO)){
					field.setValue(provider.CAL_NO);
					panelResult.setValue("START_DATE", provider.START_DATE);
					panelResult.setValue("END_DATE", provider.END_DATE);
					if(dataLoad)	{
						UniAppManager.app.loadSchedule();
					} else {
						scheduler.setTimeSpan(panelResult.getValue("START_DATE"), UniDate.add(panelResult.getValue("END_DATE"),{millis : (12*60*60*1000-1)}));
					}
				}else{
					field.setValue('');
					panelResult.setValue("START_DATE", new Date());
					panelResult.setValue("END_DATE", new Date().getTime()+(8*24*60*60*1000-1));
				}
			})
		},
		loadSchedule : function()	{
			var param = Ext.getCmp('resultForm').getValues();
		  	if(Ext.getCmp('resultForm').isValid()){
		  		try {

	        		scheduler.dependencyStore.data = [];
					scheduler.highlightSuccessors = scheduler.highlightPredecessors = false;
					
					UniAppManager.app.setBtnDisabled(true);
					scheduler.crudManager.load(param).
			        catch(response => {
			            Toast.show(response && response.message || 'Unknown error occurred');
			        }).
			        then(() => {
			        	UniAppManager.app.setBtnDisabled(false);
			        	scheduler.setTimeSpan(panelResult.getValue("START_DATE"), UniDate.add(panelResult.getValue("END_DATE"),{millis : (12*60*60*1000-1)}));
			        	apsStore.loadStoreRecords();
						
			        });
		  		}catch(e){}
		  	}
		},
		setBtnDisabled : function(disable) {
			var  bSearch = panelResult.down("#bSearch")
			   , bPrev   = schedulerTask.down("#bPrev")
			   , bNow    = schedulerTask.down("#bNow")
			   , bNext   = schedulerTask.down("#bNext");
			
			bSearch.setDisabled(disable);
			bPrev.setDisabled(disable);
			bNow.setDisabled(disable);
			bNext.setDisabled(disable);
		}
	});
	//날짜형식 문자열 변환 함수 YYYYMMDDHHMMSS
	function getYyyyMmDdMmSsToString(date)
	{
			var dd = date.getDate();
			var mm = date.getMonth()+1; //January is 0!

			var yyyy = date.getFullYear();
			if(dd<10){dd='0'+dd} if(mm<10){mm='0'+mm}

			yyyy = yyyy.toString();
			mm = mm.toString();
			dd = dd.toString();

			var m = date.getHours();
			var s = date.getMinutes();

			if(m<10){m='0'+m} if(s<10){s='0'+s}
			m = m.toString();
			s = s.toString();

			var s1 = yyyy+mm+dd+m+s;
			return s1;
 	}


};
Ext.onReady(function(){
		var date = new Date();
		var dateY = date.getFullYear();
		var dateM = date.getMonth();
		var dateD = date.getDate();

		$('.from-date').datepicker({
		    format: 'yyyy-mm-dd',
		    autoclose: 'true'
		}).datepicker("setDate", new Date(dateY, 0, 1));
		$('.to-date, .date-i').datepicker({
		    format: 'yyyy-mm-dd',
		    autoclose: 'true'
		}).datepicker("setDate", new Date(dateY, dateM, dateD));


		$('.from-date').datepicker()
		.on('changeDate', function(selected) {
			var startDate = new Date(selected.date.valueOf());
			$('.to-date').datepicker('setStartDate', startDate);
		}).on('clearDate', function(selected) {
			$('.to-date').datepicker('setStartDate', null);
		});
		$('.demo-header').css('height','30px');

		
});

</script>
<script src="<c:url value='/resources/js/scheduler-4.2.1/apps/_shared/browser/helper.js' />" ></script>
<link rel="stylesheet" href='<c:url value="/resources/js/scheduler-4.2.1/apps/_shared/shared.css" />'  >
<link rel="stylesheet" href='<c:url value="/resources/js/scheduler-4.2.1/apps/_resources/app.css" />'  >
<script src="<c:url value='/resources/js/scheduler-4.2.1/apps/_shared/locales/common.locales.umd.js'   />" charset="utf-8"></script>
<div id="container"></div>
<script data-default-locale="En" type="module" src="<c:url value='/resources/js/scheduler-4.2.1/apps/ppl320ukrv/app.module.js'   />" charset="utf-8" ></script>


