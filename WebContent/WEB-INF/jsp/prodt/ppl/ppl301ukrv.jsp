<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<t:appConfig pgmId="ppl301ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="ppl301ukrv"/> 					 <!-- 사업장 -->
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
window.ResizeObserver = undefined;
function appMain() {

	var gantt = Ext.get(Ext.fly("container"));
	var referOrderInformationWindow;	//수주정보참조
	var apsParameterPopup;				//aps파라미터 팝업
	var saveFlag = ''					//고정, 확정, dummy 저장 flag
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'ppl301ukrvService.selectEstiList'
		}
	});
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'ppl301ukrvService.selectDetailList',
			update	: 'ppl301ukrvService.updateList',
			syncAll	: 'ppl301ukrvService.saveAll2'
		}
	});
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'ppl301ukrvService.selectApsParameter',
			update	: 'ppl301ukrvService.updateDetail',
			syncAll	: 'ppl301ukrvService.saveAll'
		}
	});


	/* Model 정의
	 * @type
	 */
	Unilite.defineModel('ppl301ukrvModel', {
	    fields: [
	    	  {name : 'SCHEDULE_NO'      , text:'NO'         	,type:'string' }
	    	 ,{name : 'ORDER_NUM'        , text:'수주번호'      	,type:'string' }
	    	 ,{name : 'SEQ'              , text:'수주순번'      	,type:'string' }
	    	 ,{name : 'WORK_SHOP_CODE'   , text:'작업장'    	   	,type:'string' }
	    	 ,{name : 'TREE_NAME'        , text:'작업장'    	   	,type:'string' }
	    	 ,{name : 'EQU_CODE'   		 , text:'설비'     	   	,type:'string' }
	    	 ,{name : 'EQU_NAME'   		 , text:'설비명'    	   	,type:'string' }
	    	 ,{name : 'ITEM_CODE'        , text:'품목'     	   	,type:'string' }
	    	 ,{name : 'ITEM_NAME'        , text:'품목명'     	   	,type:'string' }
	    	 ,{name : 'FIX_YN'       	 , text:'고정'     	   	,type:'boolean'}
	    	 ,{name : 'CONFIRM_YN'       , text:'확정'     	   	,type:'boolean'}
	    	 ,{name : 'WKORD_YN'         , text:'작지'     	   	,type:'string' }
	    	 ,{name : 'ORDER_Q'          , text:'누적계획량'     	,type:'string' }
	    	 ,{name : 'DVRY_DATE'        , text:'납기일'    	   	,type:'string' }
	    	 ,{name : 'WK_PLAN_Q'        , text:'계획량'    	   	,type:'string' }
	    	 ,{name : 'LOT_Q'            , text:'LOT분할'  	   	,type:'string' }
	    	 ,{name : 'PLAN_START_DATE'  , text:'시작일'    	   	,type:'string', align:'center' }
	    	 ,{name : 'PLAN_START_TIME'  , text:'시작시간'    	   	,type:'string', align:'center'}
	    	 ,{name : 'PLAN_END_DATE'    , text:'종료일'      		,type:'string', align:'center' }
	    	 ,{name : 'PLAN_END_TIME'    , text:'종료시간'      	,type:'string', align:'center' }
	    	 ,{name : 'PLAN_TIME'        , text:'제조시간'     	   	,type:'string' }
	    	 ,{name : 'CYCLE_TIME'  	 , text:'Unit C/T'   	,type:'string' }
	    	 ,{name : 'WORK_MEN'         , text:'작업인원'      	,type:'string' }
	    	 ,{name : 'LOT_NO'           , text:'LOT_NO'    	,type:'string' }
	    	 ,{name : 'EVIDENCE_NO'      , text:'실행근거번호'    	,type:'string' }
	    	 ,{name : 'WKORD_NUM'        , text:'작업지시번호'    	,type:'string' }
	    	 ,{name : 'WKORD_Q'          , text:'지시량'     	 	,type:'string' }
	    	 ,{name : 'PRODT_Q'          , text:'실적량'       	,type:'string' }
	    	 ,{name : 'WK_PLAN_NUM'	     , text:'계획번호'     		,type:'string' }
	    	 ,{name : 'ACT_SET_M'  		 , text:'준비시간'    	   	,type:'string', align:'center'}
	    	 ,{name : 'ACT_OUT_M'  		 , text:'정리시간'    	   	,type:'string', align:'center'}
	    	 ,{name : 'DUMMY_YN'          , text:'더미 이벤트 여부'    ,type:'string' }
	    	 ,{name : 'DELAY_YN'          , text:'납기 지연 여부'     	,type:'string' }
			]
	});

	/* Store 정의(Service 정의)
	 * @type
	 */
	var apsStore = Unilite.createStore('ppl301ukrvMasterStore1',{
		model: 'ppl301ukrvModel',
		uniOpt : {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: false,			// 삭제 가능 여부
			useNavi 	: false			// prev | newxt 버튼 사용
		},
        autoLoad: false,
        proxy	: directProxy1,
        loadStoreRecords : function( dummy_yn )	{
			var param= Ext.getCmp('resultForm').getValues();
				if(Ext.isEmpty(dummy_yn)){
					dummy_yn = 'N';
				}
				param.DUMMY_YN = dummy_yn;
		  	/*var param = {	'FROM_DT'		  :  $( '.from-date' ).val().replace(/-/gi,'')
		   					,'TO_DT' 		  :  $( '.to-date' )  .val().replace(/-/gi,'')
		   			   	    ,'DIV_CODE'       :  $( '#selDivCode' ).val()
		   				 	,'WORK_SHOP_CODE' :  $( '#selWorkShopCode' ).val()
		   				 	,'LOT_NO'		  :  $( '#txtLotNo' ).val()
	   			   };*/
			//Ext.Object.merge(param, addResult.getValues());
			console.log( param );
			this.load({
				params : param
			});
		},saveStore: function( flag ) {
			var inValidRecs	= this.getInvalidRecords();
			var toCreate = this.getNewRecords();		// 추가
			var toUpdate = this.getUpdatedRecords();	// 수정
			var toDelete = this.getRemovedRecords();	// 삭제
			var list = [].concat(toCreate, toUpdate, toDelete);
			var paramMaster = Ext.getCmp('resultForm').getValues();
			paramMaster.SAVE_FLAG = flag ;
			if(inValidRecs.length == 0) {

				config = {
					params: [paramMaster],
					success: function(batch, option) {

					}
				};

				this.syncAllDirect(config);
			} else {
				 masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {

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
		layout	: {type : 'uniTable', columns : 13},
		padding: '1 1 1 1',
		border: true,
		items: [{	fieldLabel: '사업장',
					name:'DIV_CODE',
					xtype: 'uniCombobox',
					width: 180,
			        allowBlank: false,
			        typeAhead: false,
			        comboType:'BOR120',
			       // tdAttrs	: {align: 'left',width: 200},
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {

						}
					}
				},{
					fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
					name: 'WORK_SHOP_CODE',
					xtype: 'uniCombobox',
					comboType:'WU',
					allowBlank: true,
					holdable: 'hold',
					//tdAttrs	: {align: 'left',width: 200},
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						},
						beforequery:function( queryPlan, eOpts ) {
							var store = queryPlan.combo.store;
							store.clearFilter();

							if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
								store.filterBy(function(record){
									return record.get('option') == panelResult.getValue('DIV_CODE');
								});
							} else{
								store.filterBy(function(record){
									return false;
								});
							}
						}
					}
				},{
					fieldLabel	: '계획주차',
					name		: 'FROM_DATE',
					xtype		: 'uniDatefield',
					allowBlank	: true,
					id			: 'testest',
					listeners	: {
						/*change: function(field, newValue, oldValue, eOpts) {
							if(!Ext.isEmpty(newValue)){
								scheduler.setTimeSpan(newValue, panelResult.getValue('TO_DATE'));
							}else{
								scheduler.setTimeSpan(UniDate.get('threeMonthsAgo'), panelResult.getValue('TO_DATE'));
							}

						},*/
						blur : function (field, event, eOpts) {
							if(Ext.isEmpty(field.value)){
								panelSearch.setValue('WEEK_NUM_FR','');
								scheduler.setTimeSpan(UniDate.get('startOfWeek'), panelResult.getValue('TO_DATE'));
							}else{
								var param = {
									'OPTION_DATE'	: UniDate.getDbDateStr(field.value),
									'CAL_TYPE'		: '3' //주단위
								}
								prodtCommonService.getCalNo(param, function(provider, response) {
									if(!Ext.isEmpty(provider.CAL_NO)){
										panelResult.setValue('WEEK_NUM_FR',provider.CAL_NO);
									}else{
										panelResult.setValue('WEEK_NUM_FR','');
									}
								})
								
								scheduler.setTimeSpan(field.value, panelResult.getValue('TO_DATE'));
								
								
							}
						}
					}
				},{
					fieldLabel	: '계획주차FR',
					xtype		: 'uniTextfield',
					name		: 'WEEK_NUM_FR',
					width		: 60,
					hideLabel	: true,
					allowBlank	: false
				},{
					xtype	: 'component',
					html	: '~',
					style	: {
						marginTop	: '3px !important',
						font		: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel	: '계획주차',
					hideLabel	: true,
					name		: 'TO_DATE',
					xtype		: 'uniDatefield',
					allowBlank	: false,
					listeners	: {
						/*change: function(field, newValue, oldValue, eOpts) {
							if(!Ext.isEmpty(newValue)){
								scheduler.setTimeSpan(panelResult.getValue('FROM_DATE'), newValue);
							}else{
								scheduler.setTimeSpan(panelResult.getValue('FROM_DATE'), oldValue);
							}
						},*/
						blur : function (field, event, eOpts) {
							if(Ext.isEmpty(field.value)){
								panelSearch.setValue('WEEK_NUM_TO','');
							}else{
								var param = {
									'OPTION_DATE' : UniDate.getDbDateStr(field.value),
									'CAL_TYPE' : '3' //주단위
								}
								prodtCommonService.getCalNo(param, function(provider, response) {
									if(!Ext.isEmpty(provider.CAL_NO)){
										panelResult.setValue('WEEK_NUM_TO',provider.CAL_NO);
									}else{
										panelResult.setValue('WEEK_NUM_TO','');
									}
								})
								
								scheduler.setTimeSpan(panelResult.getValue('FROM_DATE'), field.value);
								
							}
						}
					}
				},{
					fieldLabel	: '계획주차TO',
					xtype		: 'uniTextfield',
					name		: 'WEEK_NUM_TO',
					width		: 60,
					hideLabel	: true,
					allowBlank	: false
				},{ fieldLabel: 'APS_NO',
					xtype: 'uniTextfield',
					name: 'APS_NO',
					hidden: false
				},{	xtype: 'button',
					itemId	: 'apsSearchBtn',
					id		: 'apsSearchBtn1',
					text	: '조회',
					width	: 80,
					margin  : '0 0 0 25',
					tdAttrs	: {align: 'right',width: 80},
					handler	: function() { /////
							  	   var param = Ext.getCmp('resultForm').getValues();
							  	    param.DUMMY_YN = 'N';
								   scheduler.crudManager.load(param).
						        	// loading failed
							        catch(response => {
							            // show notification with error message
							            Toast.show(response && response.message || 'Unknown error occurred');
							        }).
							        // no load errors occurred
							        then(() => {
							           // Ext.getBody().unmask(); // 로딩 풀기
							        		 // Ext.getBody().mask('조회중...','loading-indicator');
								       /* apsStore.load({
											    params: param,
											    callback: function(records, operation, success) {

											    	// do something after the load finishes
											    },
											    scope: this
										});*/
							        	apsStore.loadStoreRecords("N");
							        	//scheduler.setTimeSpan(new Date(2021, 6, 1,0), new Date(2021, 7, 1,0))
							        });

					},
					disabled: false
				},{ xtype: 'button',
					itemId	: 'apsSaveBtn',
					id		: 'apsSaveBtn1',
					text	: '저장',
					width	: 80,
					hidden  : true,
					margin  : '0 0 0 30',
					tdAttrs	: {align: 'right',width: 80},
					handler	: function() {

					},
					disabled: false
				},{ xtype: 'button',
					itemId	: 'apsBtn',
					id		: 'apsBtn1',
					text	: 'APS',
					width	: 80,
					margin  : '0 0 0 35',
					tdAttrs	: {align: 'right',width: 80},
					handler	: function() {
						var param = Ext.getCmp('resultForm').getValues();
						
//							param["ORDER_NUMS"] 	 = orderNums;
//							param["ORDER_SEQS"] 	 = orderSeqs;
//							param["dataCount"]  	 = selectedRecords.length;
//							param["BASE_START_DATE"] = UniDate.getDbDateStr(apsParameterGrid.down('#dateNextProdtStDt').getValue());
						var apsParamStore 		 = Ext.data.StoreManager.lookup('apsParamStore');	//aps파라미터 스토어
						Ext.each(apsParameterStore.data.items, function(record, idx) {				//aps파라미터 스토어에서 파라미터 세팅
							if(record.get('CODE') == 'P2'){
								param["REMAINING_TIME"] = record.get('SETTING'); 					//일반 생산(성형,포장)일 경우 다음날로 이월이 가능한 최소 근무시간 파라미터
							}
						});
						
						
						Ext.getBody().mask('생성중...','loading-indicator');
						$.ajax({    
							type: "POST",
				            url : "<c:url value='/prodt/ganttApsData1.do'/>",
				            data: param,
//							            contentType : "application/json; charset:UTF-8",
				            success: function(data){
								if(String(data) == 'no_input'){
									Ext.Msg.alert('알림','생성할 input data가 없습니다.');
									Ext.getBody().unmask();
								}else if(data.split(';')[0] == '44444'){
//												Ext.Msg.alert('알림','해당 ITEM_CODE가 없습니다'+ data.split(';')[1]);
									if(data.split(';')[1] == '4444'){
//													Unilite.messageBox('생산공수등록이 되지 않은 품목이 있습니다','품목코드 : '+data.split(';')[2].slice(0, -1));
										Unilite.messageBox('생산공수등록이 되지 않은 품목이 있습니다','품목코드 : '+data.split(';')[2].slice(0, -1));
									}else if(data.split(';')[1] == '44'){
										Unilite.messageBox('APS 생성 에러',data.split(';')[2]);
									}

									Ext.getBody().unmask();
								}else{

									Ext.getBody().unmask();
									Ext.Msg.alert('알림','APS 생산계획 데이터가 생성되었습니다.');
									 //LoadingWithMask();

									       panelResult.setValue('APS_NO',String(data));
										   var param = Ext.getCmp('resultForm').getValues();
											param.DUMMY_YN = 'N';
										   scheduler.crudManager.load(param).
								        	// loading failed
									        catch(response => {
									            // show notification with error message
									            Toast.show(response && response.message || 'Unknown error occurred');
									        }).
									        // no load errors occurred
									        then(() => {
									           apsStore.loadStoreRecords();
									        	// Ext.getBody().unmask(); // 로딩 풀기
									        });
								}
				            },
				            error: function(){
				                Ext.getBody().unmask();
				                Ext.Msg.alert('알림','데이터 생성중 오류가 발생했습니다.');
				            }
					 	});
					},
					disabled: false
				},{ xtype: 'button',
					itemId	: 'settingBtn',
					id		: 'settingBtn1',
					text	: '설정',
					width	: 80,
					margin  : '0 0 0 40',
					tdAttrs	: {align: 'right',width: 80},
					handler	: function() {
						openApsParameterWindow();
					},
					disabled: false
				}
			]
	});
	/* Master Grid 정의(Grid Panel)
     * @type
     */
    var masterGrid = Unilite.createGrid('ppl301ukrvGrid1', {
    	flex   : .3,
        region : 'south',
        store  : apsStore,
        split  : true,
		uniOpt :{
			expandLastColumn: false,
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: true,
			onLoadSelectFirst: true,/*,
			filter: {
				useFilter: true,
				autoCreate: true
			}*/
			state: {
			useState: false,			//그리드 설정 버튼 사용 여부
			useStateList: false		//그리드 설정 목록 사용 여부
			}
		},
		features: [ {id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
        selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					Ext.each(scheduler.eventStore._data, function(eventData,i){
						if( eventData.scheduleNo == selectRecord.get('SCHEDULE_NO')){
							scheduler.scrollEventIntoView(scheduler.eventStore.getAt(i), {highlight: true, focus: true})
							return false;
						}
       				});
				},
				deselect:  function(grid, selectRecord, index, eOpts ){

				}
			}
		}),
		tbar: [ { fieldLabel: '설비',
					xtype     : 'uniTextfield',
					itemId	  : 'txtEquCode',
					name      : 'APS_EQU_CODE',
					width	  : 130,
					labelWidth: 40,
					hidden    : false,
					listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {
						fnCreateFilter();

			     	}
			    }
				},
				{   fieldLabel: '',
					xtype     : 'uniTextfield',
					itemId	  : 'txtEquName',
					name      : 'APS_EQU_NAME',
					hidden    : false,
					listeners: {
				    	change: function(field, newValue, oldValue, eOpts) {
							fnCreateFilter();

				     	}
					}
				},
				{   fieldLabel: '수주번호',
					xtype     : 'uniTextfield',
					itemId	  : 'txtOrderNum',
					name      : 'APS_ORDER_NUM',
					margin 	  : '0 0 0 10',
					width	  : 180,
					labelWidth: 60,
					hidden    : false,
					listeners: {
				    	change: function(field, newValue, oldValue, eOpts) {
							fnCreateFilter();

				     	}
					}
				},
				{   fieldLabel: '품목',
					xtype     : 'uniTextfield',
					itemId	  : 'txtPumok',
					name      : 'APS_ITEM_CODE',
					margin 	  : '0 0 0 10',
					width	  : 130,
					labelWidth: 50,
					hidden    : false,
					listeners: {
				    	change: function(field, newValue, oldValue, eOpts) {
							fnCreateFilter();

				     	}
					}
				},
				{   fieldLabel: '',
					itemId	  : 'txtPumokName',
					xtype     : 'uniTextfield',
					name      : 'APS_ITEM_NAME',
					hidden    : false,
					listeners: {
				    	change: function(field, newValue, oldValue, eOpts) {
							fnCreateFilter();

				     	}
					}
				},{
					xtype: 'uniCheckboxgroup',
					fieldLabel: '',
					padding: '0 0 0 0',
					padding: '0 0 0 10',
					items: [{	boxLabel: '고정',
								itemId	  : 'chkFix',
								//width: 200,
								name: 'FIX_YN',
								inputValue: 'Y',
								listeners: {
									change: function(field, newValue, oldValue, eOpts) {
										fnCreateFilter();
									}
								}
							},{	boxLabel: '확정',
								itemId	  : 'chkConfirm',
								//width: 200,
								name: 'CONFIRM_YN',
								inputValue: 'Y',
								listeners: {
									change: function(field, newValue, oldValue, eOpts) {
										fnCreateFilter();
									}
								}
							},{	boxLabel: '납기지연',
								itemId	  : 'chkDelay',
								width: 100,
								name: 'DELAY_YN',
								inputValue: 'Y',
								listeners: {
									change: function(field, newValue, oldValue, eOpts) {
										fnCreateFilter();
									}
								}
							}]
				},{
					itemId: 'btnFilterClear',
					text: '<div style="color: blue">Filter Clear</div>',
					handler: function() {
							if(!Ext.isEmpty(masterGrid.down('#txtEquCode').getValue()))  { masterGrid.down('#txtEquCode').setValue('')};
							if(!Ext.isEmpty(masterGrid.down('#txtEquName').getValue()))  { masterGrid.down('#txtEquName').setValue('')};
							if(!Ext.isEmpty(masterGrid.down('#txtOrderNum').getValue())) { masterGrid.down('#txtOrderNum').setValue('')};
							if(!Ext.isEmpty(masterGrid.down('#txtPumok').getValue()))    { masterGrid.down('#txtPumok').setValue('')};
							if(!Ext.isEmpty(masterGrid.down('#txtPumokName').getValue())){ masterGrid.down('#txtPumokName').setValue('')};
							if(!Ext.isEmpty(masterGrid.down('#chkFix').getValue())){ masterGrid.down('#chkFix').setValue('false')};
							if(!Ext.isEmpty(masterGrid.down('#chkConfirm').getValue())){ masterGrid.down('#chkConfirm').setValue('false')};
							if(!Ext.isEmpty(masterGrid.down('#chkDelay').getValue())){ masterGrid.down('#chkDelay').setValue('false')};
							apsStore.clearFilter();
					}
				},{
  					xtype:'component',
  					width: 160,
  					margin : '0 0 0 0'/*,
  					style: {
  						marginTop: '3px !important',
  						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
  					}*/
  				},
				{ itemId: 'btnDumySearch',
						text: '<div style="color: blue">Dummy 조회</div>',
						hidden: false,
						handler: function() {
							   var param = Ext.getCmp('resultForm').getValues();
							   param.DUMMY_YN = 'Y';
							   scheduler.crudManager.load(param).
					        	// loading failed
						        catch(response => {
						            // show notification with error message
						            Toast.show(response && response.message || 'Unknown error occurred');
						        }).
						        // no load errors occurred
						        then(() => {
						           // Ext.getBody().unmask(); // 로딩 풀기
						        		 // Ext.getBody().mask('조회중...','loading-indicator');
							       /* apsStore.load({
										    params: param,
										    callback: function(records, operation, success) {

										    	// do something after the load finishes
										    },
										    scope: this
									});*/
						        	apsStore.loadStoreRecords('Y');
						        	//scheduler.setTimeSpan(new Date(2021, 6, 1,0), new Date(2021, 7, 1,0))
						        });
						}
				},
				{
					itemId: 'btnDumySave',
					text: '<div style="color: red">Dummy 수정</div>',
					hidden: false,
					//disabled: true,
					handler: function() {
							apsStore.saveStore('DUMMY');
					}
				},
				'-',{
					itemId: 'btnPlanLock',
					text: '<div style="color: blue">계획고정</div>',
					handler: function() {
							apsStore.saveStore('FIX');
					}
				},
				'-',{
					itemId: 'btnPlanConfirm',
					text: '<div style="color: blue">계획확정</div>',
					disabled:true,
					handler: function() {
							apsStore.saveStore('CONFIRM');
					}
		}],
        columns:  [
        	{dataIndex  : 'SCHEDULE_NO'      , width: 80	,hidden: false, style: {textAlign: 'center'}, align: 'center',hideable: false},
        	{dataIndex  : 'ORDER_NUM'        , width: 120	,hidden: false, align: 'center'},
        	{dataIndex  : 'SEQ'              , width: 70	,hidden: false, style: {textAlign: 'center'}, align: 'right'},
        	{dataIndex  : 'WORK_SHOP_CODE'   , width: 80	,hidden: false, style: {textAlign: 'center'}},
        	{dataIndex  : 'TREE_NAME'        , width: 100	,hidden: true,  style: {textAlign: 'center'}},
        	{dataIndex  : 'EQU_CODE'   		 , width: 100	,hidden: false, style: {textAlign: 'center'}},
        	{dataIndex  : 'EQU_NAME'   		 , width: 100	,hidden: false,  style: {textAlign: 'center'}},
        	{dataIndex  : 'ITEM_CODE'        , width: 100	,hidden: false, style: {textAlign: 'center'}},
        	{dataIndex  : 'ITEM_NAME'        , width: 250	,hidden: false, style: {textAlign: 'center'}},
        	{dataIndex  : 'FIX_YN'		     , width: 60	,xtype: 'checkcolumn', align: 'center', disabledCls : ''
        		,listeners: {
								beforecheckchange : function(CheckColumn, rowIndex, checked, record){
									if(record.get('CONFIRM_YN') == true || record.get('DUMMY_YN') == 'Y'){
										return false;
									}
								}
				}
        	},
        	{dataIndex  : 'CONFIRM_YN'       , width: 60	,xtype: 'checkcolumn', align: 'center', disabledCls : ''
        				,listeners: {
								beforecheckchange : function(CheckColumn, rowIndex, checked, record){
									if(record.get('DUMMY_YN') == 'Y'){
										return false;
									}
								}
						}
        	},
        	{dataIndex  : 'WKORD_YN'         , width: 60	,hidden: false, style: {textAlign: 'center'}, align: 'center'},
        	{dataIndex  : 'ORDER_Q'          , width: 100	,hidden: false, style: {textAlign: 'center'}},
        	{dataIndex  : 'DVRY_DATE'        , width: 120	,hidden: false, style: {textAlign: 'center'}, align: 'center'},
        	{dataIndex  : 'WK_PLAN_Q'        , width: 100	,hidden: false, style: {textAlign: 'center'}},
        	{dataIndex  : 'LOT_Q'            , width: 100	,hidden: false, style: {textAlign: 'center'}},
        	{dataIndex  : 'PLAN_START_DATE'  , width: 100	,hidden: true,  style: {textAlign: 'center'}},
        	{dataIndex  : 'PLAN_START_TIME'  , width: 150	,hidden: false, style: {textAlign: 'center'}},
        	{dataIndex  : 'PLAN_END_DATE'    , width: 100	,hidden: true,  style: {textAlign: 'center'}},
        	{dataIndex  : 'PLAN_END_TIME'    , width: 150	,hidden: false, style: {textAlign: 'center'}},
        	{dataIndex  : 'ACT_SET_M'        , width: 100	,hidden: false, style: {textAlign: 'center'}},
        	{dataIndex  : 'PLAN_TIME'        , width: 100	,hidden: false, style: {textAlign: 'center'}},
        	{dataIndex  : 'ACT_OUT_M'        , width: 100	,hidden: false, style: {textAlign: 'center'}},
        	{dataIndex  : 'CYCLE_TIME'  	 , width: 100	,hidden: false, style: {textAlign: 'center'}},
        	{dataIndex  : 'WORK_MEN'         , width: 100	,hidden: false, style: {textAlign: 'center'}},
        	{dataIndex  : 'LOT_NO'           , width: 100	,hidden: false, style: {textAlign: 'center'}},
        	{dataIndex  : 'EVIDENCE_NO'      , width: 150	,hidden: false, style: {textAlign: 'center'}},
        	{dataIndex  : 'WKORD_NUM'        , width: 100	,hidden: false, style: {textAlign: 'center'}},
        	{dataIndex  : 'WKORD_Q'          , width: 100	,hidden: false, style: {textAlign: 'center'}},
        	{dataIndex  : 'PRODT_Q'          , width: 100	,hidden: false, style: {textAlign: 'center'}},
        	{dataIndex  : 'WK_PLAN_NUM'	   	 , width: 100	,hidden: false, style: {textAlign: 'center'}},
        	{dataIndex  : 'DUMMY_YN'	   	 , width: 120	,hidden: false, style: {textAlign: 'center'}},
        	{dataIndex  : 'DELAY_YN'	   	 , width: 80	,hidden: false, style: {textAlign: 'center'}}
        ],
        listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (e.record.phantom){
					return true;
				} else {
					if (UniUtils.indexOf(e.field, ['FIX_YN'])) {
						if(e.record.get('CONFIRM_YN') == true){
							return false;
						}
					}
					if (UniUtils.indexOf(e.field, ['ORDER_Q','LOT_Q'])) {
						return true;
					}else{
						return false;
					}
				}
			}
       }
    });
		//수주참조 참조 메인
	function openOrderInformationWindow() {
		if(!panelResult.getInvalidMessage()) return;	//필수체크
		orderSearch.setValue('DIV_CODE'		, panelResult.getValue('DIV_CODE'));
		orderSearch.setValue('DVRY_DATE_FR'	, panelResult.getValue('FROM_DATE'));
		orderSearch.setValue('DVRY_DATE_TO'	, panelResult.getValue('TO_DATE'));
		orderSearch.setValue('WEEK_NUM_FR'	, panelResult.getValue('WEEK_NUM_FR'));
		orderSearch.setValue('WEEK_NUM_TO'	, panelResult.getValue('WEEK_NUM_TO'));

		if(!referOrderInformationWindow) {
			referOrderInformationWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.product.soinforeference" default="수주정보참조"/>',
				width	: 1200,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [orderSearch, OrderGrid],
				tbar	: ['->',{
					itemId	: 'saveBtn',
					id		: 'saveBtn1',
					text	: '<t:message code="system.label.product.inquiry" default="조회"/>',
					handler	: function() {
						if(!orderSearch.getInvalidMessage()) return;	//필수체크
						OrderStore.loadStoreRecords();

					},
					disabled: false
				},{
					itemId	: 'cancelBtn',
					id		: 'cancelBtn1',
					text	: '취소',
					handler	: function() {
						referOrderInformationWindow.hide();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					id		: 'closeBtn1',
					text	: '적용 후 닫기',
					handler	: function() {
//						detailStore.saveStore();
						var selectedRecords = OrderGrid.getSelectedRecords();
						var orderNums = '';
						var orderSeqs = '';
						if(Ext.isEmpty(selectedRecords)){
							Unilite.messageBox("선택된 데이터가 없습니다.");
							return false;
						}
						Ext.each(selectedRecords, function(selectedRecord, index){
								if(index ==0) {
									orderNums	= orderNums + selectedRecord.get('ORDER_NUM');
									orderSeqs	= orderSeqs + selectedRecord.get('SER_NO');

								}else{
									orderNums	= orderNums + ',' + selectedRecord.get('ORDER_NUM');
									orderSeqs	= orderSeqs + ',' + selectedRecord.get('SER_NO');
								}
						});
						var param = Ext.getCmp('resultForm').getValues();
							param["ORDER_NUMS"] 	 = orderNums;
							param["ORDER_SEQS"] 	 = orderSeqs;
							param["dataCount"]  	 = selectedRecords.length;
							param["BASE_START_DATE"] = UniDate.getDbDateStr(apsParameterGrid.down('#dateNextProdtStDt').getValue());
							var apsParamStore 		 = Ext.data.StoreManager.lookup('apsParamStore');	//aps파라미터 스토어
							Ext.each(apsParameterStore.data.items, function(record, idx) {				//aps파라미터 스토어에서 파라미터 세팅
								if(record.get('CODE') == 'P2'){
									param["REMAINING_TIME"] = record.get('SETTING'); 					//일반 생산(성형,포장)일 경우 다음날로 이월이 가능한 최소 근무시간 파라미터
								}
							});
							Ext.getBody().mask('생성중...','loading-indicator');
							$.ajax({    type: "POST",
							            url : "<c:url value='/prodt/ganttApsData.do'/>",
							            data: param,
//							            contentType : "application/json; charset:UTF-8",
							            success: function(data){
											if(String(data) == 'no_input'){
												Ext.Msg.alert('알림','생성할 input data가 없습니다.');
												Ext.getBody().unmask();
											}else if(data.split(';')[0] == '44444'){
//												Ext.Msg.alert('알림','해당 ITEM_CODE가 없습니다'+ data.split(';')[1]);
												if(data.split(';')[1] == '4444'){
//													Unilite.messageBox('생산공수등록이 되지 않은 품목이 있습니다','품목코드 : '+data.split(';')[2].slice(0, -1));
													Unilite.messageBox('생산공수등록이 되지 않은 품목이 있습니다','품목코드 : '+data.split(';')[2].slice(0, -1));
												}else if(data.split(';')[1] == '44'){
													Unilite.messageBox('APS 생성 에러',data.split(';')[2]);
												}

												Ext.getBody().unmask();
											}else{

												Ext.getBody().unmask();
												Ext.Msg.alert('알림','APS 생산계획 데이터가 생성되었습니다.');
												 //LoadingWithMask();

												       panelResult.setValue('APS_NO',String(data));
													   var param = Ext.getCmp('resultForm').getValues();
														param.DUMMY_YN = 'N';
													   scheduler.crudManager.load(param).
											        	// loading failed
												        catch(response => {
												            // show notification with error message
												            Toast.show(response && response.message || 'Unknown error occurred');
												        }).
												        // no load errors occurred
												        then(() => {
												           apsStore.loadStoreRecords();
												        	// Ext.getBody().unmask(); // 로딩 풀기
												        });
											}
							            },
							            error: function(){
							                Ext.getBody().unmask();
							                Ext.Msg.alert('알림','데이터 생성중 오류가 발생했습니다.');
							            }
		 						 });
						referOrderInformationWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						OrderGrid.reset();
						OrderStore.clearData();
						orderSearch.clearForm();
					},
					beforeclose: function( panel, eOpts ) {
					},
					beforeshow: function ( me, eOpts ) {
					}
				}
			})
		}
		referOrderInformationWindow.show();
		referOrderInformationWindow.center();
	}
	// 수주정보 참조 모델 정의
	Unilite.defineModel('ppl113ukrvOrderModel', {
		fields: [
			{name: 'PLAN_TYPE'			, text: '<t:message code="system.label.product.typecode" default="유형코드"/>'			, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.product.item" default="품목"/>'				, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.product.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.product.spec" default="규격"/>'				, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.product.unit" default="단위"/>'				, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.product.custom" default="거래처"/>'				, type: 'string'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.product.sono" default="수주번호"/>'				, type: 'string'},
			{name: 'ORDER_Q'			, text: '<t:message code="system.label.product.soqty" default="수주량"/>'				, type: 'uniQty'},
			{name: 'INIT_DVRY_DATE'		, text: '납품요청일'			, type: 'uniDate'},//추가
			{name: 'DVRY_DATE'			, text: '납품변경일'			, type: 'uniDate'},//추가
			{name: 'WEEK_NUM'			, text: '납기주차'			, type: 'string'},//추가
			{name: 'ORDER_DATE'			, text: '<t:message code="system.label.product.sodate" default="수주일"/>'				, type: 'uniDate'},
			{name: 'PO_NUM'				, text: '오더번호'			, type: 'string'},//추가
			{name: 'REMARK'				, text: '비고'			, type: 'string'},//추가
			{name: 'SER_NO'				, text: '<t:message code="system.label.product.soseq" default="수주순번"/>'				, type: 'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'	, type: 'string' , comboType: 'WU'},
			/* 파라미터 */
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.product.division" default="사업장"/>'			, type: 'string'},
			{name: 'PAD_STOCK_YN'		, text: '<t:message code="system.label.product.availableinventoryapplyyn" default="가용재고 반영여부"/>'	 , type: 'string'},
			{name: 'CHECK_YN'			, text: '그리드선택 여부'		, type: 'string'},  // 선택 했을때 체크하는 값 (그리드 데이터랑 관련없음)
			{name: 'PROD_END_DATE'		, text: '생산요청일'			, type: 'uniDate'}
		]
	});
	//수주정보 참조 스토어 정의
	var OrderStore = Unilite.createStore('ppl113ukrvOrderStore', {
		proxy	: directProxy,
		model	: 'ppl113ukrvOrderModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords : function() {
			var param= orderSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	/** 수주정보참조을 참조하기 위한 Search Form, Grid, Inner Window 정의
	 */
		var orderSearch = Unilite.createSearchForm('orderForm', {
		layout	: {type : 'uniTable', columns : 2},
		items	: [{
			fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false
		},{
			xtype	: 'container',
			layout	: {type:'hbox', align:'stretch'},
			width	: 530,
			colspan	: 2,
			items	: [{
				fieldLabel	: '납기주차',
				name		: 'DVRY_DATE_FR',
				xtype		: 'uniDatefield',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					},
					blur : function (field, event, eOpts) {
						if(Ext.isEmpty(field.value)){
							orderSearch.setValue('WEEK_NUM_FR','');
						}else{
							var param = {
								'OPTION_DATE'	: UniDate.getDbDateStr(field.value),
								'CAL_TYPE'		: '3' //주단위
							}
							prodtCommonService.getCalNo(param, function(provider, response) {
								if(!Ext.isEmpty(provider.CAL_NO)){
									orderSearch.setValue('WEEK_NUM_FR',provider.CAL_NO);
								}else{
									orderSearch.setValue('WEEK_NUM_FR','');
								}
							})
						}
					}
				}
			},{
				fieldLabel	: '계획주차FR',
				xtype		: 'uniTextfield',
				name		: 'WEEK_NUM_FR',
				width		: 60,
				hideLabel	: true,
				allowBlank	: false
			},{
				xtype	: 'component',
				html	: '~',
				style	: {
					marginTop	: '3px !important',
					font		: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
			},{
				fieldLabel	: '계획주차',
				hideLabel	: true,
				name		: 'DVRY_DATE_TO',
				xtype		: 'uniDatefield',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					},
					blur : function (field, event, eOpts) {
						if(Ext.isEmpty(field.value)){
							orderSearch.setValue('WEEK_NUM_TO','');
						}else{
							var param = {
								'OPTION_DATE' : UniDate.getDbDateStr(field.value),
								'CAL_TYPE' : '3' //주단위
							}
							prodtCommonService.getCalNo(param, function(provider, response) {
								if(!Ext.isEmpty(provider.CAL_NO)){
									orderSearch.setValue('WEEK_NUM_TO',provider.CAL_NO);
								}else{
									orderSearch.setValue('WEEK_NUM_TO','');
								}
							})
						}
					}
				}
			},{
				fieldLabel	: '계획주차TO',
				xtype		: 'uniTextfield',
				name		: 'WEEK_NUM_TO',
				width		: 60,
				hideLabel	: true,
				allowBlank	: false
			}]
		},
/*		{
			fieldLabel: '<t:message code="system.label.product.productionrequestdate" default="생산요청일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'PROD_END_DATE_FR',
			endFieldName: 'PROD_END_DATE_TO',
			width: 350,
			startDate: UniDate.get('mondayOfWeek'),
			endDate: UniDate.get('endOfWeek')
		},*/
		Unilite.popup('ORDER_NUM',{
			fieldLabel		: '수주번호',
			valueFieldName	: 'ORDER_NUM',
			textFieldName	: 'ORDER_NUM',
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': orderSearch.getValue('DIV_CODE')});
				}
			}
		}),
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': orderSearch.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.product.sentence001" default="※ 생산계획계산시 가용재고(현재고+입고예정-출고예정-안전재고)반영여부"/>',
			xtype		: 'uniRadiogroup',
			labelWidth	: 450,
			width		: 235,
			colspan		: 2,
			name		: 'PAD_STOCK_YN',
			id			: 'padStockYn',
			items		: [{
				boxLabel	: '<t:message code="system.label.product.yes" default="예"/>',
				width		: 70,
				name		: 'PAD_STOCK_YN',
				inputValue	: 'Y'
			},{
				boxLabel	: '<t:message code="system.label.product.no" default="아니오"/>',
				width		: 70,
				name		: 'PAD_STOCK_YN',
				inputValue	: 'N' ,
				checked		: true
			}]
		}]
	});
	/* 수주정보 그리드 */
	var OrderGrid = Unilite.createGrid('ppl113ukrvOrderGrid', {
		store	: OrderStore,
		layout	: 'fit',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		uniOpt	: {
			onLoadSelectFirst : false
		},
		columns: [
			{ dataIndex: 'CHECK_YN'			, width: 40 , hidden: true},
			{ dataIndex: 'PLAN_TYPE'		, width: 40 , hidden: true},
			{ dataIndex: 'ITEM_CODE'		, width: 120},
			{ dataIndex: 'ITEM_NAME'		, width: 140},
			{ dataIndex: 'SPEC'				, width: 126},
			{ dataIndex: 'STOCK_UNIT'		, width: 44},
			{ dataIndex: 'CUSTOM_NAME'		, width: 120},
			{ dataIndex: 'ORDER_NUM'		, width: 100},
			{ dataIndex: 'ORDER_Q'			, width: 66},
			{ dataIndex: 'INIT_DVRY_DATE'	, width: 80},
			{ dataIndex: 'DVRY_DATE'		, width: 80},
			{ dataIndex: 'WEEK_NUM'			, width: 80},
			{ dataIndex: 'ORDER_DATE'		, width: 80},
			{ dataIndex: 'PO_NUM'			, width: 100},
			{ dataIndex: 'REMARK'			, width: 100},
			{ dataIndex: 'SER_NO'			, width: 100,hidden:true},
			{ dataIndex: 'DIV_CODE'			, width: 100,hidden:true},
			{ dataIndex: 'PAD_STOCK_YN'		, width: 100,hidden:true},
			{ dataIndex: 'WORK_SHOP_CODE'	, width: 100,hidden: true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			},
			deselect: function( model, record, index, eOpts ){
				record.set('CHECK_YN', '')
			},
			select: function( model, record, index, eOpts ){
				record.set('CHECK_YN', 'S')
			}
		}
	});


	function openApsParameterWindow() {
		//if(!UniAppManager.app.checkForNewDetail()) return false;
		if(!apsParameterPopup) {
			apsParameterPopup = Ext.create('widget.uniDetailWindow', {
				title		: 'APS',
				width		: 1170,
				height		: 385,
				//resizable	: false,
				layout		:{type:'vbox', align:'stretch'},
				items		: [apsParameterSearch, apsParameterGrid, apsParameterSearch2],
				listeners	: {
					beforehide	: function(me, eOpt) {
						//apsParameterGrid.reset();
						//apsParameterStore.clearData();
						//apsParameterSearch.clearForm();
						//apsParameterStore.loadStoreRecords();
					},
					beforeclose: function( panel, eOpts ) {

					},
					beforeshow: function ( me, eOpts ) {

					},
					show: function(me, eOpts) {
						apsParameterStore.loadStoreRecords();
					}
				}
			})
		}
		apsParameterPopup.center();
		apsParameterPopup.show();
	}

	//APS파라미터 폼
	var apsParameterSearch = Unilite.createSearchForm('apsParamegerForm', {
		layout	  : {type : 'vbox', align:'center'},
		height	   : 30,
		border:true,
		items	: [{
						xtype	: 'label',
						text	: '♣APS 환경설정',
						//margin	: '0 0 0 0',
						height	   : 30,
						fieldStyle: 'text-align: center;'
					}]
	});

	 Unilite.defineModel('apsParameterModel', {		//aps 파라미터 폼 그리드 모델
		fields: [
			{name: 'CODE'			, text: '코드'		, type: 'string'},
			{name: 'SETTING'		, text: '설정'		, type: 'string'},
			{name: 'DEFAULT_VALUE'	, text: '기본값'		, type: 'string'},
			{name: 'UNIT'			, text: '단위'		, type: 'string'},
			{name: 'DESCRIPTION'	, text: '설명'		, type: 'string'}
		]
	});
	 var apsParameterStore = Unilite.createStore('apsParameterStore', {	//aps 파라미터 폼 그리드 스토어
		model: 'apsParameterModel',
		autoLoad: false,
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결
			editable: true,				// 수정 모드 사용
			deletable: false,			// 삭제 가능 여부
			useNavi: false				// prev | newxt 버튼 사용
		},
		proxy: directProxy2,
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			var isErr = false;
			console.log("list:", list);

			var paramMaster= panelResult.getValues();   //syncAll 수정

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						apsParameterStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('apsParameterGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		loadStoreRecords: function() {
			var param= "";
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
				Ext.each(records, function(record, idx) {
					if(record.get('CODE') == 'P0' && record.get('SETTING') == 'Y'){
						masterGrid.down('#btnPlanConfirm').setDisabled(false);
					}
					if(record.get('CODE') == 'P0' && record.get('SETTING') == 'N'){
						masterGrid.down('#btnPlanConfirm').setDisabled(true);
					}
				});
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {

			}
		}
	 });
		//aps파라미터 폼
	var apsParameterSearch2 = Unilite.createSearchForm('apsParameterSearchForm2', {
		layout		: {type:'vbox', align:'center', pack: 'center' },
		region: 'south',
		padding :'1 1 1 1',
		border:true,
		items	: [{
			xtype		: 'container',
			defaultType	: 'uniTextfield',
			layout		: {type : 'uniTable', columns : 2},
			items		: [{
				xtype	: 'button',
				name	: 'labelPrint',
				text	: '저장',
				width	: 80,
				hidden	: false,
				handler : function() {
					if(!apsParameterStore.isDirty()){
						Unilite.messageBox("수정된 데이터가 없습니다.");
						return false;
					}
					apsParameterStore.saveStore();
				}
			},{
				xtype	: 'button',
				name	: 'btnCancel',
				text	: '<t:message code="system.label.purchase.close" default="닫기"/>',
				width	: 80,
				hidden	: false,
				handler	: function() {
					apsParameterSearch.clearForm();
					apsParameterPopup.hide();
				}
			}]
		}]
	});
	var apsParameterGrid = Unilite.createGrid('apsParameterGrid', {		//aps설정 폼 그리드
		layout :'fit',
		store: apsParameterStore,
		uniOpt: {
			userToolbar:true,
			expandLastColumn: false,
			useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useGroupSummary: false,
			useRowNumberer: true,
			onLoadSelectFirst: false,
			state: {
				useState: false,
				useStateList: false
			}
		},
		tbar:  ['->',{	//padding: '0 0 0 0',
		          		fieldLabel: '차기 생산계획 시작일',
		          		labelWidth: 120,
						xtype: 'uniDatefield',
						name: 'NEXT_PRODT_ST_DT',
						itemId: 'dateNextProdtStDt',
						value:UniDate.get('today'),
						readOnly : false,
						allowBlank:true
					  }
				],
		features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: false},
					{id : 'masterGridTotal',	ftype: 'uniSummary',			showSummaryRow: false} ],
		columns:  [
			{ dataIndex: 'CODE'				,width:100, align: 'center' },
			{ dataIndex: 'SETTING'			,width:100, align: 'center' },
			{ dataIndex: 'DEFAULT_VALUE'	,width:100, align: 'center' },
			{ dataIndex: 'UNIT'				,width:100, align: 'center' },
			{ dataIndex: 'DESCRIPTION'		,width:700, align: 'left'   }
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['SETTING'])){
					return true;
				}else{
					return false;
				}
			}
		}
	});

	/*function formatSetting(selRecord){
		if(selRecord.get('CODE') == 'A1'){
			editField = {	xtype: 'timefield',
							format: 'H:i',
							align:'center'
						}
		}else{
			editField = {xtype : 'textfield', maxLength:20};
		}
		var editor = Ext.create('Ext.grid.CellEditor', {
			ptype: 'cellediting',
			clicksToEdit: 1, // 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수
			autoCancel : false,
			selectOnFocus:true,
			field: editField
		});
		return editor;
	}*/

    Unilite.Main({
    	borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult,
				{
					region : 'center',
					//scrollable : true,
					layout :'fit',
					items : [ gantt]
				},
				masterGrid
			]
		}/*,
			panelSearch*/
		],
		uniOpt:{showKeyText:false,
				showToolbar: false
//        	forceToolbarbutton:true
		},
		id  : 'ppl301ukrvApp',
		fnInitBinding : function(params) {
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
//			scheduler.zoomLevel = 10;
			scheduler.on({
			    eventclick(event) {
			        // The eventclick event has the following properties:
			        // source - Triggering object
			        // eventRecord - Clicked events record
			        // event - The browser click event
			    	//event.eventRecord.data.wkPlanNum
			    	Ext.each( masterGrid.getStore().data.items, function(record, i){
								if(record.get('SCHEDULE_NO') == event.eventRecord.data.scheduleNo){
										masterGrid.getSelectionModel().select(i)
										var view = masterGrid.getView();
										var navi = view.getNavigationModel();
										navi.setPosition(i, 0);
										var normalView = view.getScrollable();
										normalView.scrollTo(0, view.getScrollY(), false);
								}
					});
			    	;
			    },eventDrop(event){
			    	Ext.each( masterGrid.getStore().data.items, function(record, i){
						if(!Ext.isEmpty(event.eventRecords[0].data.scheduleNo)){
								if(record.get('SCHEDULE_NO') == event.eventRecords[0].data.scheduleNo){

										var startDate = Ext.Date.format(event.eventRecords[0].data.startDate, Unilite.dateFormat);
										var startTime = getYyyyMmDdMmSsToString(event.eventRecords[0].data.startDate).substring(8,12);
											startTime = startTime.substring(0,2) + ':' + startTime.substring(2,4);

										var endDate   = Ext.Date.format(event.eventRecords[0].data.endDate, Unilite.dateFormat);
										var endTime   = getYyyyMmDdMmSsToString(event.eventRecords[0].data.endDate).substring(8,12);
											endTime   = endTime.substring(0,2) + ':' + endTime.substring(2,4);

										record.set('PLAN_START_DATE', startDate);
										record.set('PLAN_START_TIME', startDate + ' ' + startTime + ':00');
										record.set('PLAN_END_DATE'  , endDate);
										record.set('PLAN_END_TIME'  , endDate + ' ' + endTime+ ':00');
										record.set('EQU_CODE'       , event.assignmentRecords[0].data.resource.data.equCode);
										record.set('EQU_NAME'       , event.assignmentRecords[0].data.resource.data.type);
								}
						}
					});
			    },eventResizeEnd(event){
					//event.eventRecord.$changed.endDate
					Ext.each( masterGrid.getStore().data.items, function(record, i){
								if(record.get('SCHEDULE_NO') == event.eventRecord.data.scheduleNo){

									if(!Ext.isEmpty(event.eventRecord.$changed.startDate)){
										var startDate = Ext.Date.format(event.eventRecord.$changed.startDate, Unilite.dateFormat);
										var startTime = getYyyyMmDdMmSsToString(event.eventRecord.$changed.startDate).substring(8,12);
											startTime = startTime.substring(0,2) + ':' + startTime.substring(2,4);
											record.set('PLAN_START_DATE', startDate);
											record.set('PLAN_START_TIME', startDate + ' ' + startTime + ':00');
									}
									if(!Ext.isEmpty(event.eventRecord.$changed.endDate)){
										var endDate   = Ext.Date.format(event.eventRecord.$changed.endDate, Unilite.dateFormat);
										var endTime   = getYyyyMmDdMmSsToString(event.eventRecord.$changed.endDate).substring(8,12);
											endTime   = endTime.substring(0,2) + ':' + endTime.substring(2,4);
											record.set('PLAN_END_DATE'  , endDate);
											record.set('PLAN_END_TIME'  , endDate + ' ' + endTime+ ':00');
									}




								}
					});
			    },afterEventSave(event){
			    			Ext.each( masterGrid.getSelectedRecords(), function(record, i){
								if(record.get('SCHEDULE_NO') == event.eventRecord.data.scheduleNo){

									if(!Ext.isEmpty(event.eventRecord.get("startDate"))){
										var startDate = Ext.Date.format(event.eventRecord.get("startDate"), Unilite.dateFormat);
										var startTime = getYyyyMmDdMmSsToString(event.eventRecord.get("startDate")).substring(8,12);
											startTime = startTime.substring(0,2) + ':' + startTime.substring(2,4);
											record.set('PLAN_START_DATE', startDate);
											record.set('PLAN_START_TIME', startDate + ' ' + startTime + ':00');
									}
									if(!Ext.isEmpty(event.eventRecord.get("endDate"))){
										var endDate   = Ext.Date.format(event.eventRecord.get("endDate"), Unilite.dateFormat);
										var endTime   = getYyyyMmDdMmSsToString(event.eventRecord.get("endDate")).substring(8,12);
											endTime   = endTime.substring(0,2) + ':' + endTime.substring(2,4);
											record.set('PLAN_END_DATE'  , endDate);
											record.set('PLAN_END_TIME'  , endDate + ' ' + endTime+ ':00');
									}
								}
							});
			    }
			});
			panelResult.setValue('DIV_CODE'	    , UserInfo.divCode);
			
			//스케줄러에 오늘날짜의 주차의 날짜를 세팅하면 일요일 ~ 토요일 인데
			//스케줄러에 보여줄날짜는 이번주차의 월요일 ~ 토요일 이라 1일씩 add함 
			var fromDt = UniDate.get('startOfWeek');
			fromDt = fromDt.substring(0,4) + '/' + fromDt.substring(4,6) + '/' + fromDt.substring(6,8);
			fromDt = new Date(fromDt);
			var toDt = UniDate.get('endOfWeek');
			toDt = toDt.substring(0,4) + '/' + toDt.substring(4,6) + '/' + toDt.substring(6,8);
			toDt = new Date(toDt);
			panelResult.setValue('FROM_DATE'	, UniDate.add(fromDt, {days: +1}));
			panelResult.setValue('TO_DATE'		, UniDate.add(toDt, {days: +1}));
			var param = {
				'OPTION_DATE'	: UniDate.getDbDateStr(UniDate.get('startOfWeek')),
				'CAL_TYPE'		: '3' //주단위
			}
			prodtCommonService.getCalNo(param, function(provider, response) {
				if(!Ext.isEmpty(provider.CAL_NO)){
					panelResult.setValue('WEEK_NUM_FR', provider.CAL_NO);
					gsWeekNum = provider.CAL_NO;	//20200716 추가: 불필요하게 쿼리하는 로직 삭제하기 위해 전역변수 추가
				}else{
					panelResult.setValue('WEEK_NUM_FR', '');
				}
			});
			var param = {
				'OPTION_DATE'	: UniDate.getDbDateStr(UniDate.get('endOfWeek')),
				'CAL_TYPE'		: '3' //주단위
			}
			prodtCommonService.getCalNo(param, function(provider, response) {
				if(!Ext.isEmpty(provider.CAL_NO)){
					panelResult.setValue('WEEK_NUM_TO', provider.CAL_NO);
				}else{
					panelResult.setValue('WEEK_NUM_TO', '');
				}
				
				/*const frStr = UniDate.get('startOfWeek');
				const toStr = UniDate.get('endOfWeek');
		
				const frDate = new Date(frStr.substring(0,4), frStr.substring(4,6)-1, frStr.substring(6,8));
				const toDate = new Date(toStr.substring(0,4), toStr.substring(4,6)-1, toStr.substring(6,8));
				

				scheduler.setTimeSpan(frDate, toDate);*/
				
//				scheduler.zoomToLevel(10,{
//					startDate: frDate,
//				    endDate: toDate,
//				    centerDate: frDate
//				});
			});
			apsParameterStore.loadStoreRecords();
			scheduler.setTimeSpan(panelResult.getValue('FROM_DATE'), panelResult.getValue('TO_DATE'))
			
//(
//preset, options
//)
//			scheduler.zoomIn(10)

//			const frStr = UniDate.get('startOfWeek');
//			const toStr = UniDate.get('endOfWeek');
//	
//			const frDate = new Date(frStr.substring(0,4), frStr.substring(4,6)-1, frStr.substring(6,8));
//			const toDate = new Date(toStr.substring(0,4), toStr.substring(4,6)-1, toStr.substring(6,8));
//			
//			scheduler.zoomLevel = 10;
			
//			setTimeout( function() {
//				scheduler.setTimeSpan(frDate, toDate);
//			}, 500 );
				
		},
		onQueryButtonDown : function()	{
			directMasterStore.loadStoreRecords();
//			setTimeout( function() {
//				scheduler.setTimeSpan(panelResult.getValue('FROM_DATE'), panelResult.getValue('TO_DATE'));
//			}, 500 );
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			masterGrid.reset();
			this.fnInitBinding();
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

	/** Validation
	 */
	Unilite.createValidator('validator01', {
		store: apsParameterStore,
		grid : apsParameterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
					case "SETTING" :	//공통코드 p200 S1 값 변경시 값 만큼 차기 생산일 계산
									if(record.get('CODE') == 'S1'){
										var nextDate = apsParameterGrid.down('#dateNextProdtStDt').getValue();
										var plusDay  = record.get('SETTING');
										var calcDay  = UniDate.add(nextDate, {days: + plusDay});
										apsParameterGrid.down('#dateNextProdtStDt').setValue(calcDay);
									}
					break;
			}
			return rv;
		}
	}); // validator
	Unilite.createValidator('validator02', {
		store: apsStore,
		grid : masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
					case "PLAN_START_TIME" :
									if(record.get('DUMMY_YN') == 'Y' && newValue != oldValue){
										masterGrid.down('#btnDumySave').setDisabled(false);
									}
								break;
					case "PLAN_END_TIME" :
									if(record.get('DUMMY_YN') == 'Y' && newValue != oldValue){
										masterGrid.down('#btnDumySave').setDisabled(false);
									}
								break;
					case "LOT_Q"	:
								alert(newValue);
								alert(oldValue);
								break;
					break;
			}
			return rv;
		}
	}); // validator
	function fnCreateFilter() {
		apsStore.clearFilter();
		var txtEquCode	= masterGrid.down('#txtEquCode').getValue();
		var txtEquName	= masterGrid.down('#txtEquName').getValue();
		var txtOrderNum	= masterGrid.down('#txtOrderNum').getValue();
		var txtPumok	= masterGrid.down('#txtPumok').getValue();
		var txtPumokName= masterGrid.down('#txtPumokName').getValue();
		var chkFix	    = masterGrid.down('#chkFix').getValue();
		var chkConfirm  = masterGrid.down('#chkConfirm').getValue();
		var chkDelay    = masterGrid.down('#chkDelay').getValue();

		if(!Ext.isEmpty(txtEquCode)) {
			apsStore.filterBy(function(item){
				return item.get('EQU_CODE').indexOf(txtEquCode) !== -1;
			});
		}
		if(!Ext.isEmpty(txtEquName)) {
			apsStore.filterBy(function(item){
				return item.get('EQU_NAME').indexOf(txtEquName) !== -1;
			});
		}
		if(!Ext.isEmpty(txtOrderNum)) {
			apsStore.filterBy(function(item){
				return item.get('ORDER_NUM').indexOf(txtOrderNum) !== -1;
			});
		}
		if(!Ext.isEmpty(txtPumok)) {
			apsStore.filterBy(function(item){
				return item.get('ITEM_CODE').indexOf(txtPumok) !== -1;
			});
		}
		if(!Ext.isEmpty(txtPumokName)) {
			apsStore.filterBy(function(item){
				return item.get('ITEM_NAME').indexOf(txtPumokName) !== -1;
			});
		}
		if(chkFix) {
			apsStore.filterBy(function(item){
				return item.get('FIX_YN')== true;
			});
		}
		if(chkConfirm) {
			apsStore.filterBy(function(item){
				return item.get('CONFIRM_YN')== true;
			});
		}
		if(chkDelay) {
			apsStore.filterBy(function(item){
				return item.get('DELAY_YN')== 'DELAY';
			});
		}
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
<script src="<c:url value='/resources/js/scheduler-4.2.1/examples/_shared/browser/helper.js' />" ></script>
<link rel="stylesheet" href='<c:url value="/resources/js/scheduler-4.2.1/examples/_shared/shared.css" />'  >
<link rel="stylesheet" href='<c:url value="/resources/js/scheduler-4.2.1/examples/fillticks/resources/app.css" />'  >
<script src="<c:url value='/resources/js/scheduler-4.2.2/examples/_shared/locales/examples.locales.umd.js'   />" charset="utf-8"></script>
<div id="container"></div>
<script data-default-locale="En" type="module" src="<c:url value='/resources/js/scheduler-4.2.1/examples/fillticks/app.module.js'   />" charset="utf-8" ></script>


