<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="equ888ukrv"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="equ888ukrv"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="WB04" />             <!-- 차종  -->
    <t:ExtComboStore comboType="AU" comboCode="WZ33" />             <!-- 거래처  -->
    <t:ExtComboStore comboType="AU" comboCode="B020" /> 			<!-- 품목계정 -->
</t:appConfig>

	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/hyper/vendor.js" ></script>
		<!-- <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/hyper/app.js" ></script>-->
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/hyper/vendor/moment.min.js" ></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/hyper/vendor/snap.svg-min.js" ></script>

    <!-- gantt js-->
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/hyper/vendor/frappe-gantt.js" ></script>

    <!-- demo app -->
    <!-- end demo js-->

	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/hyper/vendor/frappe-gantt.css"/>" />

    <!-- third party css end -->

    <!-- App css -->

	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/hyper/icons.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/hyper/app-dark.css"/>" id="dark-style" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/hyper/app.css"/>" id="light-style" />

<style type="text/css">



.x-change-cell {
background-color: #fed9fe;
}
</style>

<script type="text/javascript" >

var equWindow; // 금형등록팝업
var coreWindow; // 코어등록팝업
var activeGridId = 'dummyGrid';
var uploadWin;				//업로드 윈도우
var photoWin;			// 이미지 보여줄 윈도우
var gsNeedPhotoSave	= false;


function appMain() {
	var gantt = null;
	var gsTasks=[];

	 Ext.define('StudentDataModel', {
            extend: 'Ext.data.Model',
            fields: [
               {name: 'name', mapping : 'name'},
               {name: 'age', mapping : 'age'},
               {name: 'marks', mapping : 'marks'}
            ]
         });


	  var myData = [
               { name : "Asha", age : "16", marks : "90" },
               { name : "Vinit", age : "18", marks : "95" },
               { name : "Anand", age : "20", marks : "68" },
               { name : "Niharika", age : "21", marks : "86" },
               { name : "Manali", age : "22", marks : "57" }
            ];

                        // create the data store
                        var firstGridStore = Ext.create('Ext.data.Store', {
                            model: 'StudentDataModel',
                            data: myData
                        });


                        // Column Model shortcut array
//                        var columns = [
//                            {text: "User Name", sortable: true, dataIndex: 'name'},
//
//                        ];

                        // declare the source Grid which have data .
                         var firstGrid = Ext.create('Ext.grid.Panel', {
                         	region:'center',
                       		flex:1,
				               multiSelect: true,
				               viewConfig: {
				                  plugins: {
				                     ptype: 'gridviewdragdrop',
				                     dragGroup: 'firstGridDDGroup',
				                     dropGroup: 'secondGridDDGroup'
				                  },
				                  listeners: {
				                     drop: function(node, data, dropRec, dropPosition) {
				                        var dropOn = dropRec ? ' ' + dropPosition + ' ' + dropRec.get('name') : ' on empty view';
				                     }
				                  }
				               },
				               store            : firstGridStore,
				               columns          :
				               [{
				                  header: "Student Name",
				                  dataIndex: 'name',
				                  id : 'name',
				                  flex:  1,
				                  sortable: true
				               },{
				                  header: "Age",
				                  dataIndex: 'age',
				                  flex: .5,
				                  sortable: true
				               },{
				                  header: "Marks",
				                  dataIndex: 'marks',
				                  flex: .5,
				                  sortable: true
				               }],
				               stripeRows       : true,
				               title            : 'First Grid',
				               margins          : '0 2 0 0'
				            });

                        var secondGridStore = Ext.create('Ext.data.Store', {
                            model: 'StudentDataModel'
                        });

                       var secondGrid = Ext.create('Ext.grid.Panel', {
                       	region:'east',
                       	flex:1,
			               viewConfig: {
			                  plugins: {
			                     ptype: 'gridviewdragdrop',
			                     dragGroup: 'secondGridDDGroup',
			                     dropGroup: 'firstGridDDGroup'
			                  },
			                  listeners: {
			                     drop: function(node, data, dropRec, dropPosition) {
			                        var dropOn = dropRec ? ' ' + dropPosition + ' ' + dropRec.get('name') : ' on empty view';
			                     }
			                  }
			               },
			               store            : secondGridStore,
			               columns          :
			               [{
			                  header: "Student Name",
			                  dataIndex: 'name',
			                  id : 'name2',
			                  flex:  1,
			                  sortable: true
			               },{
			                  header: "Age",
			                  dataIndex: 'age',
			                  flex: .5,
			                  sortable: true
			               },{
			                  header: "Marks",
			                  dataIndex: 'marks',
			                  flex: .5,
			                  sortable: true
			               }],
			               stripeRows       : true,
			               title            : 'Second Grid',
			               margins          : '0 0 0 3'
			            });

//Simple 'border layout' panel to house both grids .
/*                        var displayPanel = Ext.create('Ext.Panel', {
               width        : 600,
               height       : 200,
				region :'center',
               layout       : {
                  type: 'hbox',
                  align: 'stretch',
                  padding: 5
               },
               renderTo     : 'panel',
               defaults     : { flex : 1 },
               items        : [
                  firstGrid,
                  secondGrid
               ]
               dockedItems: {
                  xtype: 'toolbar',
                  dock: 'bottom',
                  items: ['->',
                  {
                     text: 'Reset both grids',
                     handler: function() {
                        firstGridStore.loadData(myData);
                        secondGridStore.removeAll();
                     }
                  }]
               }
            });


	*/






	var directProxyMaster = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'equ888ukrvService.selectMaster',
            create: 'equ888ukrvService.insertMaster',
            update: 'equ888ukrvService.updateMaster',
            destroy: 'equ888ukrvService.deleteMaster',
            syncAll: 'equ888ukrvService.saveAllMaster'
        }
    });

    Unilite.defineModel('mainModel', {
        fields: [

            {name: 'id'              ,text:'id'        	  ,type: 'string'},
            {name: 'name'            ,text:'name'         ,type: 'string'},
            {name: 'start'           ,text:'start'        ,type: 'uniDate'},
            {name: 'end'             ,text:'end'          ,type: 'uniDate'},
            {name: 'progress'        ,text:'progress'     ,type: 'string'},
            {name: 'dependencies'    ,text:'dependencies' ,type: 'string'}

        ]
    });


    var masterStore = Unilite.createStore('masterStore',{
        model: 'mainModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결
            editable:  true,            // 수정 모드 사용
            deletable: true,           // 삭제 가능 여부
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxyMaster,
        loadStoreRecords : function()   {
            var param= panelResult.getValues();
            this.load({
                  params : param
            });
        },
        saveStore: function(/*index*/) {
            var inValidRecs = this.getInvalidRecords();
            var paramMaster= panelResult.getValues();    //syncAll 수정
            if(inValidRecs.length == 0 )    {
                var config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                 		masterStore.loadStoreRecords();
                  /*
                        if(subStore.getCount() == 0){
                            UniAppManager.app.onResetButtonDown();
                            return false;
                        }
                        var master = batch.operations[0].getResultSet();
                        var fp = inputTable.down('xuploadpanel');                  //mask on
                        fp.loadData({});
                        fp.getEl().mask('로딩중...','loading-indicator');
                        equ888ukrvService.getFileList({ITEM_CODE : master.ITEM_CODE},              //파일조회 메서드  호출(param - 파일번호)
                            function(provider, response) {
                                fp.loadData(response.result);                       //업로드 파일 load해서 보여주기
                                fp.getEl().unmask();                                //mask off
                            }
                         );
                        UniAppManager.setToolbarButtons('save', false);
                        UniAppManager.setToolbarButtons('newData', false);

                        if(index){
                            subGrid.getSelectionModel().select(index);
                        }*/
                     }
                };
                this.syncAllDirect(config);
            }else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
		listeners:{

	/*		datachanged:function( store, eOpts ) {
					var tasks=[];
				Ext.each(store.data.items, function(record,i){
					tasks.push(record.data);



				});
				gantt.update_task(task);
//						{
//					this.tasks[task._index]=task;
//					this.refresh(this.tasks);
//				}
			},*/
			load:function(store, records, successful, eOpts)	{

				Ext.each(records, function(record,i){
					gsTasks.push(record.data);



				});

			/*	//그리드 좌우스크롤 동기화
        	  Ext.getCmp('masterGrid').view.getEl().on('scroll', function(e, t) {
				 Ext.getCmp('ganttPanel').view.getEl().dom.scrollLeft = t.scrollLeft;
			});
				Ext.getCmp('ganttPanel').view.getEl().on('scroll', function(e, t) {
				Ext.getCmp('masterGrid').view.getEl().dom.scrollLeft = t.scrollLeft;
				});
				*/

		/*			var tasks = [{
            id: '1',
            name: 'Draft the new contract document for sales team',
            start: '2019-07-16',
            end: '2019-07-20',
            progress: 55
        },
        {
            id: '2',
            name: 'Find out the old contract documents',
            start: '2019-07-19',
            end: '2019-07-21',
            progress: 85,
            dependencies: '1'
        },
        {
            id: '3',
            name: 'Organize meeting with sales associates to understand need in detail',
            start: '2019-07-21',
            end: '2019-07-22',
            progress: 80,
            dependencies: '2'
        },
        {
            id: '4',
            name: 'iOS App home page',
            start: '2019-07-15',
            end: '2019-07-17',
            progress: 80
        },
        {
            id: '5',
            name: 'Write a release note',
            start: '2019-07-18',
            end: '2019-07-22',
            progress: 65,
            dependencies: '4'
        },
        {
            id: '6',
            name: 'Setup new sales project',
            start: '2019-07-20',
            end: '2019-07-31',
            progress: 15
        },
        {
            id: '7',
            name: 'Invite user to a project',
            start: '2019-07-25',
            end: '2019-07-26',
            progress: 99,
            dependencies: '6'
        },
        {
            id: '8',
            name: 'Coordinate with business development',
            start: '2019-07-28',
            end: '2019-07-30',
            progress: 35,
            dependencies: '7'
        },
        {
            id: '9',
            name: 'Kanban board design',
            start: '2019-08-01',
            end: '2019-08-03',
            progress: 25,
            dependencies: '8'
        },
        {
            id: '10',
            name: 'Enable analytics tracking',
            start: '2019-08-05',
            end: '2019-08-07',
            progress: 60,
            dependencies: '9'
        }
    ];*/
	setGantt(gsTasks);
		/* gantt = new Gantt('#tasks-gantt', tasks, {
		        view_modes: ['Quarter Day', 'Half Day', 'Day', 'Week', 'Month'],
		        header_height: 40,
		        bar_height: 20,
		        padding: 18,
		        view_mode: 'Quarter Day',
//		        language:'ko',
		        custom_popup_html: function(task) {
		            // the task object will contain the updated
		            // dates and progress value
		            var end_date = task.end;
		            var progressCls = task.progress >= 60? "bg-success": (task.progress >= 30 && task.progress < 60 ? "bg-primary": "bg-warning");
		            return '<div class="popover fade show bs-popover-right gantt-task-details" role="tooltip">' +
		                '<div class="arrow"></div><div class="popover-body">' +
		                '<h5>${task.name}</h5><p class="mb-2">Expected to finish by ${end_date}</p>' +
		                '<div class="progress mb-2" style="height: 10px;">' +
		                '<div class="progress-bar ${progressCls}" role="progressbar" style="width: ${task.progress}%;" aria-valuenow="${task.progress}"'+
		                    ' aria-valuemin="0" aria-valuemax="100">${task.progress}%</div>' +
		                '</div></div></div>';
		        },

		        on_click: function (task) {
					console.log(task);
				},
				on_date_change: function(task, start, end) {

//					var records = masterStore.data.items;


					Ext.each(store.data.items, function(record,i){
						if(record.get('id') == task.id){
							record.set('start',start);
							record.set('end',end);
						}



					});

					console.log(task, start, end);
				},
				on_progress_change: function(task, progress) {
					console.log(task, progress);
				},
				on_view_change: function(mode) {
					console.log(mode);
				}


		    });

		    // handling the mode changes
		    $("#modes-filter :input").change(function() {
		        gantt.change_view_mode($(this).val());
		    });	    */

				/*if(Ext.isEmpty(records)){
        			inputTable.down('xuploadpanel').loadData({});
        			inputTable.disable();
				}*/
			}
		}
    });

   /*
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 5},
        padding:'1 1 1 1',
        border:true,
        items: [{
			fieldLabel: '사업장',
			name: 'DIV_CODE',
			xtype: 'uniCombobox' ,
			allowBlank:false,
			comboType: 'BOR120'
	    },{
        	fieldLabel: '금형번호',
			xtype: 'uniTextfield',
			name:'EQU_CODE'
	    },{
        	fieldLabel: '금형명',
			xtype: 'uniTextfield',
			name:'EQU_NAME'
	    },{
        	fieldLabel: '모델',
			xtype: 'uniTextfield',
			name:'MODEL_CODE'
	    }]
    });*/

    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 4},
        padding:'1 1 1 1',
        border:true,
        items: [{
			fieldLabel: '사업장',
			name: 'DIV_CODE',
			xtype: 'uniCombobox' ,
			allowBlank:false,
			comboType: 'BOR120'
	    },{
			fieldLabel: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
		 	xtype: 'uniDateRangefield',
		 	startFieldName: 'DVRY_DATE_FR',
		 	endFieldName: 'DVRY_DATE_TO',
		 	width: 315
//			startDate: UniDate.get('today'),
//			endDate: UniDate.get('todayForMonth')
		},{
			fieldLabel: '<t:message code="system.label.product.sono" default="수주번호"/>',
			xtype: 'uniTextfield',
			name: 'ORDER_NUM',
			colspan:2,
			listeners: {
                render: function(p) {
                    p.getEl().on('dblclick', function(p) {
                    	openSearchOrderWindow();
                    });
                }
            }
		},{
			fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name: 'WORK_SHOP_CODE',
			xtype: 'uniCombobox',
			comboType:'WU',
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
			fieldLabel: '착수예정일',
			xtype: 'uniDateRangefield',
			startFieldName: 'PRODT_START_DATE_FR',
			endFieldName: 'PRODT_START_DATE_TO',
			width: 350,
			startDate: UniDate.get('today'),
			endDate: UniDate.get('todayForMonth'),
			allowBlank:false
		},{
			xtype: 'radiogroup',
			fieldLabel : '일수기준',
			name:'RADIOS',
			items : [{
				boxLabel: '착수예정일',
				name: 'RDO_SELECT',
				inputValue : '1',
				width: 100,
				checked	: true
			}, {
				boxLabel: '완료예정일',
				name: 'RDO_SELECT' ,
				inputValue : '2',
				width: 100
			}]
		},{
			xtype: 'radiogroup',
			fieldLabel : '상태',
			name:'RADIOS2',
			items : [{
				boxLabel: '진행',
				name: 'RDO_SELECT2',
				inputValue : '1',
				width: 50,
				checked	: true
			}, {
				boxLabel: '전체',
				name: 'RDO_SELECT2' ,
				inputValue : '2',
				width: 50
			}]
		}]
    });



    var masterGrid = Unilite.createGrid('masterGrid', {
        layout : 'fit',
        region: 'center',
        store: masterStore,
        split:true,
        selModel: 'rowmodel',
        flex:1,
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useRowNumberer: false,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        columns:  [
            { dataIndex: 'id'                       , width: 100},
            { dataIndex: 'name'                     , width: 100},
            { dataIndex: 'start'                    , width: 100},
            { dataIndex: 'end'                      , width: 100},
            { dataIndex: 'progress'                 , width: 100},
            { dataIndex: 'dependencies'             , width: 100}
        ],
	/*	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	if(record.get('CORE_CODE').substring(record.get('CORE_CODE').length-1) != 0){
					cls = 'x-change-cell';
				}
				return cls;
	        }
	    },*/
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
            },

        	beforeselect: function(){
		    	/*if(subStore.isDirty()){
//		    		Unilite.messageBox('코어정보를 입력중입니다..');
		    		return false;
		    	}*/
        	},
            selectionchange:function( model1, selected, eOpts ){

	   /*   		if(selected.length > 0) {
					var record = selected[0];

						var param = {
							DIV_CODE : record.get('DIV_CODE'),
							EQU_CODE : record.get('EQU_CODE')
						};


					if(record.phantom == true){
//						equInfoGrid.setDisabled(true);
						subStore.loadData({});
                	}else{
//						equInfoGrid.setDisabled(false);

						subStore.loadStoreRecords(param);
                	}

//					equInfoStore.loadData({});
//					equInfoStore.loadStoreRecords(param);
//
//					imageViewStore1.loadData({});
//					imageViewStore1.loadStoreRecords(param);
//					imageViewStore2.loadData({});
//					imageViewStore2.loadStoreRecords(param);


				}*/
            },
            onGridDblClick:function(grid, record, cellIndex, colName) {

//				if(!Ext.isEmpty(record.get('EQU_CODE'))) {
		/*		if(record.phantom == false){
	   				 openEquWindow();
	   				 equForm.getField('EQU_CODE_1').setReadOnly(true);
	   				 equForm.getField('EQU_CODE_2').setReadOnly(true);
				}*/
			},
			cellclick :function(grid, td, cellIndex, record, tr, rowIndex, e, eOpts ) {

        /*        UniAppManager.setToolbarButtons(['delete'], true);
//				if(Ext.isEmpty(record.get('EQU_CODE'))) {
				if(record.phantom == true){
	   				 openEquWindow();
	   				 equForm.getField('EQU_CODE_1').setReadOnly(false);
	   				 equForm.getField('EQU_CODE_2').setReadOnly(false);
				}*/
			},

			render: function(grid, eOpts){
			 	var girdNm = grid.getItemId();
			    grid.getEl().on('click', function(e, t, eOpt) {
			    	var oldGrid = Ext.getCmp(activeGridId);
//			    	if(subStore.isDirty()){
//						Unilite.messageBox('코어정보를 입력중입니다..');
//			    		return false;
//			    	}
			    	grid.changeFocusCls(oldGrid);
			    	activeGridId = girdNm;
//	    			UniAppManager.setToolbarButtons(['newData','delete'],false);
			    });
			 }
        }
    });


    var equForm = Unilite.createSearchForm('equForm', {       // 금형 등록팝업
        layout: {type : 'uniTable', columns : 3},
        height:320,
        width: 1110,
		region: 'center',
		autoScroll: false,
		border: true,
		padding: '1 1 1 1',
		layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
		xtype: 'container',
		defaultType: 'container',
        items:[{
			layout: {type: 'uniTable', columns: 1, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
			defaultType: 'uniFieldset',
			defaults: { padding: '10 15 15 15'},
			items: [{
				title: '금형 상세정보',
				layout: { type: 'uniTable', columns: 3},
				margin: '10 0 15 15',
				width:1010,
				items: [{
					xtype: 'container',
					layout: { type: 'uniTable', columns: 2},
//					defaults : {enforceMaxLength: true},
					items:[{
						fieldLabel: '금형번호',
						name: 'EQU_CODE_1',
						xtype: 'uniTextfield',
						width: 165,
						listeners: {
							blur: function(field, event, eOpts) {
								if(!field.readOnly){
									var param= {
										DIV_CODE : panelResult.getValue("DIV_CODE"),
										EQU_CODE_1:	equForm.getValue("EQU_CODE_1")
									}
									equ888ukrvService.autoEquCode(param , function(provider, response){
										if(!Ext.isEmpty(provider))	{
											equForm.setValue('EQU_CODE_2',provider.EQU_CODE_2);

										}
									})
								}
							}
						}
					},{
						name: 'EQU_CODE_2',
						xtype: 'uniTextfield'
					}]
	    		},{
					fieldLabel: '금형명',
					name: 'EQU_NAME',
					xtype: 'uniTextfield'
				},{
					fieldLabel: '금형상태',
					name: 'EQU_GRADE',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'I801'
				},{
					fieldLabel: '몰드타입',
					name: 'EQU_TYPE',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'I802'
				},{
		        	fieldLabel: '모델',
					xtype: 'uniTextfield',
					name:'MODEL_CODE'
			    },{
					xtype: 'container',
					layout: { type: 'uniTable', columns: 3},
					defaults : {enforceMaxLength: true},
					items:[{
						fieldLabel: '몰드치수',
						name: 'EQU_SIZE_W',
						xtype: 'uniNumberfield',
						decimalPrecision: 0,
						width: 165,
						emptyText:'가로'
					},{
						fieldLabel: '',
						name: 'EQU_SIZE_L',
						xtype: 'uniNumberfield',
						decimalPrecision: 0,
						width: 75,
						emptyText:'세로'
					},{
						fieldLabel: '',
						name: 'EQU_SIZE_H',
						xtype: 'uniNumberfield',
						decimalPrecision: 0,
						width: 75,
						emptyText:'높이'
					}]
			    },
			    Unilite.popup('CUST', {
					fieldLabel: '제작처',
					valueFieldName: 'CUSTOM_CODE',
			   	 	textFieldName: 'CUSTOM_NAME',
//			   	 	allowBlank:false,
			   	 	autoPopup:true
				}),
				{
					fieldLabel: '제작일' ,
					xtype:'uniDatefield',
					name: 'PRODT_DATE',
           			value: UniDate.get('today')
				},{
					fieldLabel: '제작금액' ,
					xtype:'uniNumberfield' ,
					name: 'PRODT_O',
					decimalPrecision:2
				},{
					fieldLabel: '자산번호' ,
					xtype:'uniTextfield' ,
					name: 'ASSETS_NO'
				},{
					fieldLabel: '상각방법' ,
					xtype:'uniCombobox' ,
					name: 'MT_DEPR',
					comboType:'AU',
					comboCode:'A036'
				},{
					fieldLabel: '사용SHOT' ,
					xtype:'uniNumberfield' ,
					name: 'WORK_Q',
					decimalPrecision:0
				},{
					fieldLabel: '금형위치' ,
					xtype:'uniTextfield' ,
					name: 'LOCATION'
				},
				Unilite.popup('CUST', {
					fieldLabel: '보관처',
					valueFieldName: 'USE_CUSTOM_CODE',
			   	 	textFieldName: 'USE_CUSTOM_NAME'
				}),
				Unilite.popup('CUST', {
					fieldLabel: '소유업체',
					valueFieldName: 'COMP_OWN',
			   	 	textFieldName: 'COMP_OWN_NAME'
				}),
				{
					fieldLabel: '사용여부' ,
					xtype:'uniCombobox' ,
					name: 'USE_YN',
					comboType:'AU',
					comboCode:'A004'
				},{
					fieldLabel: '폐기일자' ,
					xtype:'uniDatefield' ,
					name: 'ABOL_DATE',
           			value: UniDate.get('today')
				},{
					fieldLabel: '폐기사유',
					xtype:'uniTextfield',
					name: 'DISP_REASON'
				},{
					fieldLabel: '비고' ,
					xtype:'textareafield' ,
					name: 'REMARK',
					width: 950,
					height: 50,
					colspan:3
				}]
			}]
		}]
    });


    function openEquWindow() {   // 금형대장등록 금형등록 팝업창
		if(!equWindow) {
			equWindow = Ext.create('widget.uniDetailWindow', {
				title: '금형등록',
				width: 1070,
				minWidth:1070,
				maxWidth:1070,
				height: 380,
				minHeight: 380,
				maxHeight: 380,
				tabDirection: 'left-right',
				resizable:true,
				layout: {type:'vbox', align:'stretch'},
				items: [equForm],
				tbar:  ['->', {
						id : 'equSaveBtn',
						width: 100,
						text: '<t:message code="system.label.product.save" default="저장"/>',
						handler: function() {

							var masterRecord = masterGrid.getSelectedRecord();

//							masterRecord.set('EQU_CODE'				,equForm.getValue('EQU_CODE'));
							masterRecord.set('EQU_CODE_1'				,equForm.getValue('EQU_CODE_1'));
							masterRecord.set('EQU_CODE_2'				,equForm.getValue('EQU_CODE_2'));
							masterRecord.set('EQU_NAME'					,equForm.getValue('EQU_NAME'));
							masterRecord.set('EQU_GRADE'			,equForm.getValue('EQU_GRADE'));
							masterRecord.set('EQU_TYPE'					,equForm.getValue('EQU_TYPE'));
							masterRecord.set('MODEL_CODE'				,equForm.getValue('MODEL_CODE'));
							masterRecord.set('EQU_SIZE_W'				,equForm.getValue('EQU_SIZE_W'));
							masterRecord.set('EQU_SIZE_L'				,equForm.getValue('EQU_SIZE_L'));
							masterRecord.set('EQU_SIZE_H'				,equForm.getValue('EQU_SIZE_H'));
							masterRecord.set('CUSTOM_CODE'				,equForm.getValue('CUSTOM_CODE'));
							masterRecord.set('CUSTOM_NAME'				,equForm.getValue('CUSTOM_NAME'));
							masterRecord.set('PRODT_DATE'				,equForm.getValue('PRODT_DATE'));
							masterRecord.set('PRODT_O'					,equForm.getValue('PRODT_O'));
							masterRecord.set('ASSETS_NO'				,equForm.getValue('ASSETS_NO'));
							masterRecord.set('MT_DEPR'					,equForm.getValue('MT_DEPR'));
							masterRecord.set('WORK_Q'					,equForm.getValue('WORK_Q'));
							masterRecord.set('LOCATION'					,equForm.getValue('LOCATION'));
							masterRecord.set('USE_CUSTOM_CODE'			,equForm.getValue('USE_CUSTOM_CODE'));
							masterRecord.set('USE_CUSTOM_NAME'			,equForm.getValue('USE_CUSTOM_NAME'));
							masterRecord.set('COMP_OWN'					,equForm.getValue('COMP_OWN'));
							masterRecord.set('COMP_OWN_NAME'					,equForm.getValue('COMP_OWN_NAME'));
							masterRecord.set('USE_YN'					,equForm.getValue('USE_YN'));
							masterRecord.set('ABOL_DATE'				,equForm.getValue('ABOL_DATE'));
							masterRecord.set('DISP_REASON'				,equForm.getValue('DISP_REASON'));
							masterRecord.set('REMARK'					,equForm.getValue('REMARK'));

							equForm.clearForm();
							equWindow.hide();
							masterStore.saveStore();
						},
						disabled: false

					},{


						id : 'equCloseBtn',
						width: 100,
						text: '닫기',
						handler: function() {
							equWindow.hide();
						},

						disabled: false
					}
				],
				listeners: {
					beforehide: function(me, eOpt) {
					},
					beforeclose: function( panel, eOpts ) {
					},
					beforeshow: function( panel, eOpts )	{

						var masterRecord = masterGrid.getSelectedRecord();

						equForm.setValue('EQU_CODE_1'		,masterRecord.get('EQU_CODE_1'));
						equForm.setValue('EQU_CODE_2'		,masterRecord.get('EQU_CODE_2'));
						equForm.setValue('EQU_NAME'			,masterRecord.get('EQU_NAME'));
						equForm.setValue('EQU_GRADE'	,masterRecord.get('EQU_GRADE'));
						equForm.setValue('EQU_TYPE'			,masterRecord.get('EQU_TYPE'));
						equForm.setValue('MODEL_CODE'		,masterRecord.get('MODEL_CODE'));
						equForm.setValue('EQU_SIZE_W'		,masterRecord.get('EQU_SIZE_W'));
						equForm.setValue('EQU_SIZE_L'		,masterRecord.get('EQU_SIZE_L'));
						equForm.setValue('EQU_SIZE_H'		,masterRecord.get('EQU_SIZE_H'));
						equForm.setValue('CUSTOM_CODE'		,masterRecord.get('CUSTOM_CODE'));
						equForm.setValue('CUSTOM_NAME'		,masterRecord.get('CUSTOM_NAME'));
						equForm.setValue('PRODT_DATE'		,masterRecord.get('PRODT_DATE'));
						equForm.setValue('PRODT_O'			,masterRecord.get('PRODT_O'));
						equForm.setValue('ASSETS_NO'		,masterRecord.get('ASSETS_NO'));
						equForm.setValue('MT_DEPR'			,masterRecord.get('MT_DEPR'));
						equForm.setValue('WORK_Q'			,masterRecord.get('WORK_Q'));
						equForm.setValue('LOCATION'			,masterRecord.get('LOCATION'));
						equForm.setValue('USE_CUSTOM_CODE'	,masterRecord.get('USE_CUSTOM_CODE'));
						equForm.setValue('USE_CUSTOM_NAME'	,masterRecord.get('USE_CUSTOM_NAME'));
						equForm.setValue('COMP_OWN'			,masterRecord.get('COMP_OWN'));
						equForm.setValue('COMP_OWN_NAME'	,masterRecord.get('COMP_OWN_NAME'));
						equForm.setValue('USE_YN'			,masterRecord.get('USE_YN'));
						equForm.setValue('ABOL_DATE'		,masterRecord.get('ABOL_DATE'));
						equForm.setValue('DISP_REASON'		,masterRecord.get('DISP_REASON'));
						equForm.setValue('REMARK'			,masterRecord.get('REMARK'));
					}
				}
			})
		}
		equWindow.center();
		equWindow.show();
	}







	Unilite.defineModel('imageViewModel1', {
	    fields: [
	    	{name: 'FILE_ID'		, text:'이미지id'	, type: 'string'},
	    	{name: 'FILE_EXT'		, text:'이미지타입'	, type: 'string'}
//	    	{name: 'IMG_NAME'		, text:'이미지명'	, type: 'string'}
		]
	});
	var imageViewStore1 = Unilite.createStore('imageViewStore1', {
		model: 'imageViewModel1',
		autoLoad: false,
		uniOpt: {
			isMaster:	false,			// 상위 버튼 연결
			editable:	false,			// 수정 모드 사용
			deletable:	false,			// 삭제 가능 여부
			useNavi:	false			// prev | next 버튼 사용
		},
		proxy: {
            type: 'direct',
            api: {
            	   read : 'equ201ukrvService.imagesList1'
            }
        },
		loadStoreRecords: function(param) {
//			var param= panelResult.getValues();

/*			var param = null;
			if(activeGridId == 'masterGrid'){
				param = {
					'DIV_CODE' : record.get('DIV_CODE'),
					'EQU_CODE' : record.get('EQU_CODE')
				};
			}else if(activeGridId == 'subGrid'){
				param = {
					'DIV_CODE' : record.get('DIV_CODE'),
					'EQU_CODE' : record.get('CORE_CODE')
				};
			}*/
		/*	if(Ext.isEmpty(masterForm.getValue('EQU_GRADE'))){
				param.CTRL_TYPE = '';
			}else{
				param.CTRL_TYPE = masterForm.getValue('EQU_GRADE');
			}*/
			this.load({
				params : param
//				callback : function(records,options,success)	{
//					if(success)	{
//							UniAppManager.setToolbarButtons(['delete', 'newData'], true);
//					}
//				}
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {


           	}/*,
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}*/
		}
	});

	var viewTpl = new Ext.XTemplate(




		'<tpl for=".">'+
/*			'<div class="col-xl-9 mt-4 mt-xl-0">                                                                                                      '+
            '                           <div class="pl-xl-3">                                                                                         '+
            '                               <div class="row">                                                                                         '+
            '                                   <div class="col-auto">                                                                                '+
            '                                       <a href="javascript: void(0);" class="btn btn-success btn-sm mb-2">Add New Task</a>               '+
            '                                   </div>                                                                                                '+
            '                                   <div class="col text-sm-right">                                                                       '+
            '                                       <div class="btn-group btn-group-sm btn-group-toggle mb-2" data-toggle="buttons" id="modes-filter">'+
            '                                           <label class="btn btn-light d-none d-sm-inline-block">                                        '+
            '                                               <input type="radio" name="modes" id="qday" value="Quarter Day" > Quarter Day              '+
            '                                           </label>                                                                                      '+
            '                                           <label class="btn btn-light">                                                                 '+
            '                                               <input type="radio" name="modes" id="hday" value="Half Day"> Half Day                     '+
            '                                           </label>                                                                                      '+
            '                                           <label class="btn btn-light">                                                                 '+
            '                                               <input type="radio" name="modes" id="day" value="Day"> Day                                '+
            '                                           </label>                                                                                      '+
            '                                           <label class="btn btn-light active">                                                          '+
            '                                               <input type="radio" name="modes" id="week" value="Week" checked> Week                     '+
            '                                           </label>                                                                                      '+
            '                                           <label class="btn btn-light">                                                                 '+
            '                                               <input type="radio" name="modes" id="month" value="Month"> Month                          '+
            '                                           </label>                                                                                      '+
            '                                       </div>                                                                                            '+
            '                                   </div>                                                                                                '+
            '                               </div>                                                                                                    '+
            '                                                                                                                                         '+
            '                               <div class="row">                                                                                         '+
            '                                   <div class="col mt-3">                                                                                '+
            '                                       <svg id="tasks-gantt"></svg>                                                                      '+
            '                                   </div>                                                                                                '+
            '                               </div>                                                                                                    '+
            '                           </div>                                                                                                        '+
            '                       </div>                                                                                                            '+

		*/
		/*
        			'<div class="thumb-wrap"><img src="'+ CPATH+'/equit/equ201Photo/{FILE_ID}.{FILE_EXT}" height= "200" width="250"></div>'+
*/
         	  '</tpl>'

	)

	var imagesView1 = Ext.create('Ext.view.View', {
		tpl: viewTpl,

	/*
		['<tpl for=".">'+

        			'<div class="thumb-wrap"><img src="'+ CPATH+'/equit/equPhoto/{FILE_ID}.{FILE_EXT}" height= "200" width="400"></div>'+
//     			'<tpl if="IMAGE_FID == null"  || IMAGE_FID == \"\">'+
//     			     '<div class="thumb-wrap"><img src="'+ CPATH+'/equit/equPhoto/Noimage.png" height= "200" width="400"></div>'+
//    			'<tpl else>'+
//        			'<div class="thumb-wrap"><img src="'+ CPATH+'/equit/equPhoto/{IMAGE_FID}.{IMG_TYPE}" height= "200" width="400"></div>'+
//    			'</tpl>'+
         	  '</tpl>'
         	  ],*/
//        itemSelector: 'div.data-source ',
//		height:320,
        flex:1,
		width:300,
//        region: 'center',
        store: imageViewStore1,
        frame:true,
		trackOver: true,
		itemSelector: 'div.thumb-wrap',
        overItemCls: 'x-item-over',
        scrollable:true,
        border:true,
        style:{
        		'background-color': '#fff' ,
        		'border': '1px solid #9598a8; '
        }
//        border:true
	});

/*

	var drawContainer = Ext.create('Ext.draw.Container', {
//    renderTo: Ext.getBody(),
    width:200,
    height:200,
    sprites: [{
        type: 'circle',
        fillStyle: '#79BB3F',
        r: 100,
        x: 100,
        y: 100
     }]
});
	*/
	    var data = [
			        [true,  false, 1,  "책이름 : ???", 54, "240 x 320 pixels", "2 Megapixel", "Pink", "Slider", 359, 2.400000]
			/*        [true,  true,  2,  "Sony Ericsson C510a Cyber-shot", 180, "320 x 240 pixels", "3.2 Megapixel", "Future black", "Candy bar", 11, 0.000000],
			        [true,  true,  3,  "LG PRADA KE850", 155, "240 x 400 pixels", "2 Megapixel", "Black", "Candy bar", 113, 0.000000],
			        [true,  true,  4,  "Nokia N900 Smartphone 32 GB", 499, "800 x 480 pixels", "5 Megapixel", "( the image of the product displayed may be of a different color )", "Slider", 320, 3.500000],
			        [true,  false, 5,  "Motorola RAZR V3", 65, "96 x 80 pixels", "0.3 Megapixel", "Silver", "Folder type phone", 5, 2.200000],
			        [true,  true,  6,  "LG KC910 Renoir", 242, "240 x 400 pixels", "8 Megapixel", "Black", "Candy bar", 79, 0.000000],
			        [true,  true,  7,  "도서검색1", 299, "320 x 240 pixels", "2 Megapixel", "Frost", "Candy bar", 320, 2.640000],
			        [true,  true,  8,  "Sony Ericsson W580i Walkman", 120, "240 x 320 pixels", "2 Megapixel", "Urban gray", "Slider", 1, 0.000000],
			        [true,  true,  9,  "Nokia E63 Smartphone 110 MB", 170, "320 x 240 pixels", "2 Megapixel", "Ultramarine blue", "Candy bar", 319, 2.360000],
			        [true,  true,  10, "Sony Ericsson W705a Walkman", 274, "320 x 240 pixels", "3.2 Megapixel", "Luxury silver", "Slider", 5, 0.000000],
			        [false, false, 11, "Nokia 5310 XpressMusic", 140, "320 x 240 pixels", "2 Megapixel", "Blue", "Candy bar", 344, 2.000000],
			        [false, true,  12, "Motorola SLVR L6i", 50, "128 x 160 pixels", "", "Black", "Candy bar", 38, 0.000000],
			        [false, true,  13, "T-Mobile Sidekick 3 Smartphone 64 MB", 75, "240 x 160 pixels", "1.3 Megapixel", "", "Sidekick", 115, 0.000000],
			        [false, true,  14, "Audiovox CDM8600", 5, "", "", "", "Folder type phone", 1, 0.000000],
			        [false, true,  15, "Nokia N85", 315, "320 x 240 pixels", "5 Megapixel", "Copper", "Dual slider", 143, 2.600000],
			        [false, true,  16, "Sony Ericsson XPERIA X1", 399, "800 x 480 pixels", "3.2 Megapixel", "Solid black", "Slider", 14, 0.000000],
			        [false, true,  17, "Motorola W377", 77, "128 x 160 pixels", "0.3 Megapixel", "", "Folder type phone", 35, 0.000000],
			        [true,  true,  18, "LG Xenon GR500", 1, "240 x 400 pixels", "2 Megapixel", "Red", "Slider", 658, 2.800000],
			        [true,  false, 19, "BlackBerry Curve 8900 BlackBerry", 349, "480 x 360 pixels", "3.2 Megapixel", "", "Candy bar", 21, 2.440000],
			        [true,  false, 20, "Samsung SGH U600 Ultra Edition 10.9", 135, "240 x 320 pixels", "3.2 Megapixel", "", "Slider", 169, 2.200000]*/
			    ];

	Ext.define('GanttModel', {
			        extend: 'Ext.data.Model',
			        fields: [
			            {name: 'hasEmail', type: 'bool'},
			            {name: 'hasCamera', type: 'bool'},
			            {name: 'id', type: 'int'},
			            'name',
			            {name: 'price', type: 'int'},
			            'screen',
			            'camera',
			            'color',
			            'type',
			            {name: 'reviews', type: 'int'},
			            {name: 'screen-size', type: 'int'}
//			            { name: 'ITEM_CODE',  				text: '품목코드', 		type : 'string', 	maxLength: 20},
//			  			{ name: 'ITEM_NAME',  				text: '품목명', 		type : 'string', 	maxLength: 40},
//			  			{ name: 'DIV_CODE',  				text: '사업장', 		type : 'string', 	maxLength: 80, allowBlank: false, comboType: 'BOR120'},
//			  			{ name: 'ISBN_CODE',  				text: 'ISBN코드', 	type : 'string', 	maxLength: 20},
//			  			{ name: 'PUBLISHER',  				text: '출판사', 		type : 'string', 	maxLength: 50},
//			  			{ name: 'PUB_DATE',  				text: '초판발행일', 	type : 'uniDate', 	maxLength: 8},
//			  			{ name: 'AUTHOR1',  				text: '저자1', 		type : 'string', 	maxLength: 30},
//			  			{ name: 'AUTHOR2',  				text: '저자2', 		type : 'string', 	maxLength: 30},
//			  			{ name: 'TRANSRATOR',  				text: '역자', 		type : 'string', 	maxLength: 30},
//			  			{ name: 'BIN_NUM',  				text: '서가진열대번호', 	type : 'string', 	maxLength: 10},
//			  			{ name: 'SALE_BASIS_P',  			text: '시중가', 		type : 'uniPrice', 	maxLength: 18, allowBlank: false}
			        ]
			    });

			    var store = Ext.create('Ext.data.ArrayStore', {
			        model: 'GanttModel',
			        sortInfo: {
			            field    : 'name',
			            direction: 'ASC'
			        },
			        data: data
			    });

	var dataview = Ext.create('Ext.view.View', {
//		height:500,
//		padding	: '1 1 1 1',
//		margin	: '1 1 1 1',
			      //  store: store,
			        tpl  : Ext.create('Ext.XTemplate',
//			            '<tpl for=".">',
			                '<div class="col-xl-12 mt-4 mt-xl-0">                                                                         ',
//            '                           <div class="pl-xl-3">                                                                                         ',
      /*      '                               <div class="row">                                                                                         ',
//            '                                   <div class="col-auto">                                                                                ',
//            '                                       <a href="javascript: void(0);" class="btn btn-success btn-sm mb-2">Add New Task</a>               ',
//            '                                   </div>                                                                                                ',
            '                                   <div class="col text-sm-right">                                                                       ',
            '                                       <div class="btn-group btn-group-sm btn-group-toggle mb-2" data-toggle="buttons" id="modes-filter">',
            '                                           <label class="btn btn-light d-none d-sm-inline-block active">                                        ',
            '                                               <input type="radio" name="modes" id="qday" value="Quarter Day" > Quarter Day              ',
            '                                           </label>                                                                                      ',
            '                                           <label class="btn btn-light">                                                                 ',
            '                                               <input type="radio" name="modes" id="hday" value="Half Day"> Half Day                     ',
            '                                           </label>                                                                                      ',
            '                                           <label class="btn btn-light">                                                                 ',
            '                                               <input type="radio" name="modes" id="day" value="Day"> Day                                ',
            '                                           </label>                                                                                      ',
            '                                           <label class="btn btn-light">                                                          ',
            '                                               <input type="radio" name="modes" id="week" value="Week" checked> Week                     ',
            '                                           </label>                                                                                      ',
            '                                           <label class="btn btn-light">                                                                 ',
            '                                               <input type="radio" name="modes" id="month" value="Month"> Month                          ',
            '                                           </label>                                                                                      ',
            '                                       </div>                                                                                            ',
            '                                   </div>                                                                                                ',
            '                               </div>                                                                                                    ',
            '                                                                                                                                         ',*/
            '                               <div class="row">                                                                                         ',
            '                                   <div class="col mt-0">                                                                                ',//margin top
            '                                       <svg id="tasks-gantt"></svg>                                                                      ',
            '                                   </div>                                                                                                ',
            '                               </div>                                                                                                    ',
            '                           </div>                                                                                                        ',
//            '                       </div>  ',
//			            '</tpl>',
			            {



			            }

			        ),

			        plugins : [
		//		            Ext.create('Ext.ux.DataView.Animated', {
		//		                duration  : 550,
		//		                idProperty: 'id'
		//		            })
			        ],
			        id: 'ganttTest',

			        itemSelector: 'div.ganttTest',
//			        overItemCls : 'book-hover',
//			        multiSelect : true,
			        scrollable  : true,

					listeners: {/*
				        activate :function( me, eOpts ){
				        	var tasks = [{
					            id: '1',
					            name: 'Draft the new contract document for sales team',
					            start: '2019-07-16',
					            end: '2019-07-20',
					            progress: 55
					        },
					        {
					            id: '2',
					            name: 'Find out the old contract documents',
					            start: '2019-07-19',
					            end: '2019-07-21',
					            progress: 85,
					            dependencies: '1'
					        }];

				        	gantt = new Gantt('#tasks-gantt', tasks, {
						        view_modes: ['Quarter Day', 'Half Day', 'Day', 'Week', 'Month'],
						        header_height: 40,
						        bar_height: 20,
						        padding: 18,
						        view_mode: 'Quarter Day',
				//		        language:'ko',
						        custom_popup_html: function(task) {
						            // the task object will contain the updated
						            // dates and progress value
						            var end_date = task.end;
						            var progressCls = task.progress >= 60? "bg-success": (task.progress >= 30 && task.progress < 60 ? "bg-primary": "bg-warning");
						            return '<div class="popover fade show bs-popover-right gantt-task-details" role="tooltip">' +
						                '<div class="arrow"></div><div class="popover-body">' +
						                '<h5>${task.name}</h5><p class="mb-2">Expected to finish by ${end_date}</p>' +
						                '<div class="progress mb-2" style="height: 10px;">' +
						                '<div class="progress-bar ${progressCls}" role="progressbar" style="width: ${task.progress}%;" aria-valuenow="${task.progress}"'+
						                    ' aria-valuemin="0" aria-valuemax="100">${task.progress}%</div>' +
						                '</div></div></div>';
						        },

						        on_click: function (task) {
									console.log(task);
								},
								on_date_change: function(task, start, end) {
									console.log(task, start, end);
								},
								on_progress_change: function(task, progress) {
									console.log(task, progress);
								},
								on_view_change: function(mode) {
									console.log(mode);
								}


						    });

						    // handling the mode changes
						    $("#modes-filter :input").change(function() {
						        gantt.change_view_mode($(this).val());
						    });

				        },


				        afterrender :function( me, eOpts ){
				        	var tasks = [{
					            id: '1',
					            name: 'Draft the new contract document for sales team',
					            start: '2019-07-16',
					            end: '2019-07-20',
					            progress: 55
					        },
					        {
					            id: '2',
					            name: 'Find out the old contract documents',
					            start: '2019-07-19',
					            end: '2019-07-21',
					            progress: 85,
					            dependencies: '1'
					        }];

				        	gantt = new Gantt('#tasks-gantt', tasks, {
						        view_modes: ['Quarter Day', 'Half Day', 'Day', 'Week', 'Month'],
						        header_height: 40,
						        bar_height: 20,
						        padding: 18,
						        view_mode: 'Quarter Day',
				//		        language:'ko',
						        custom_popup_html: function(task) {
						            // the task object will contain the updated
						            // dates and progress value
						            var end_date = task.end;
						            var progressCls = task.progress >= 60? "bg-success": (task.progress >= 30 && task.progress < 60 ? "bg-primary": "bg-warning");
						            return '<div class="popover fade show bs-popover-right gantt-task-details" role="tooltip">' +
						                '<div class="arrow"></div><div class="popover-body">' +
						                '<h5>${task.name}</h5><p class="mb-2">Expected to finish by ${end_date}</p>' +
						                '<div class="progress mb-2" style="height: 10px;">' +
						                '<div class="progress-bar ${progressCls}" role="progressbar" style="width: ${task.progress}%;" aria-valuenow="${task.progress}"'+
						                    ' aria-valuemin="0" aria-valuemax="100">${task.progress}%</div>' +
						                '</div></div></div>';
						        },

						        on_click: function (task) {
									console.log(task);
								},
								on_date_change: function(task, start, end) {
									console.log(task, start, end);
								},
								on_progress_change: function(task, progress) {
									console.log(task, progress);
								},
								on_view_change: function(mode) {
									console.log(mode);
								}


						    });

						    // handling the mode changes
						    $("#modes-filter :input").change(function() {
						        gantt.change_view_mode($(this).val());
						    });
				        }
					*/}

			    });


   // var panel = Ext.create('Ext.panel.Panel', {

    var panel = Unilite.createSearchForm('ganttPanel', {
    	padding	: '1 1 1 1',
		border	: true,
		split:true,
                    region: 'east',
//			        title: 'gantt테스트',
			        layout: 'fit',
			        items : dataview,
                       	flex:2
//			        height: 800,
//			        width : 1200
			        //renderTo:  Ext.getBody()
			    });



/*    var gantt = new Gantt("#tasks-gantt", tasks, {
        view_modes: ['Quarter Day', 'Half Day', 'Day', 'Week', 'Month'],
        bar_height: 20,
        padding: 18,
        view_mode: 'Week',
        custom_popup_html: function(task) {
            // the task object will contain the updated
            // dates and progress value
            var end_date = task.end;
            var progressCls = task.progress >= 60? "bg-success": (task.progress >= 30 && task.progress < 60 ? "bg-primary": "bg-warning");
            return '<div class="popover fade show bs-popover-right gantt-task-details" role="tooltip">' +
                '<div class="arrow"></div><div class="popover-body">' +
                '<h5>${task.name}</h5><p class="mb-2">Expected to finish by ${end_date}</p>' +
                '<div class="progress mb-2" style="height: 10px;">' +
                '<div class="progress-bar ${progressCls}" role="progressbar" style="width: ${task.progress}%;" aria-valuenow="${task.progress}"'+
                    ' aria-valuemin="0" aria-valuemax="100">${task.progress}%</div>' +
                '</div></div></div>';
        }
    });

    // handling the mode changes
    $("#modes-filter :input").change(function() {
        gantt.change_view_mode($(this).val());
    });



			   */
	function fnDatePickerInit(){
		var date = new Date();
		var dateY = date.getFullYear();
		var dateM = date.getMonth();
		var dateD = date.getDate();

		$('#wkordDate').datepicker({
		    format: 'yyyy-mm-dd',
		    autoclose: 'true'
		}).datepicker("setDate", new Date(dateY, dateM, dateD));

	}


	function setGantt(tasks){
		gantt = new Gantt('#tasks-gantt', tasks, {
		        view_modes: ['Quarter Day', 'Half Day', 'Day', 'Week', 'Month'],
//		        header_height: 40,
//		        bar_height: 20,
//		        padding: 18,

		        header_height: 55,
		        bar_height: 12,
		        padding: 10,

		        view_mode: 'Quarter Day',
//		        language:'ko',
		        custom_popup_html: function(task) {
		            // the task object will contain the updated
		            // dates and progress value
		            var end_date = task.end;
		            var progressCls = task.progress >= 60? "bg-success": (task.progress >= 30 && task.progress < 60 ? "bg-primary": "bg-warning");

		           /*
		            <div class="details-container">
					  <h5>${task.name}</h5>
					  <p>Expected to finish by ${end_date}</p>
					  <p>${task.progress}% completed!</p>
					</div>
		            */


		            return '<div class="popover fade show bs-popover-right gantt-task-details" role="tooltip">' +
		                '<div class="arrow"></div><div class="popover-body">' +
		                '<h5>${task.name}</h5><p class="mb-2">Expected to finish by ${end_date}</p>' +
		                '<div class="progress mb-2" style="height: 10px;">' +
		                '<div class="progress-bar ${progressCls}" role="progressbar" style="width: ${task.progress}%;" aria-valuenow="${task.progress}"'+
		                    ' aria-valuemin="0" aria-valuemax="100">${task.progress}%</div>' +
		                '</div></div></div>';
		        },

		        on_click: function (task) {
//					console.log(task);
				},
				on_date_change: function(task, start, end) {

					var records = masterStore.data.items;


					Ext.each(records, function(record,i){
						if(record.get('id') == task.id){
							record.set('start',start);
							record.set('end',end);
						}



					});

//					console.log(task, start, end);
				},
				on_progress_change: function(task, progress) {
					var records = masterStore.data.items;
					Ext.each(records, function(record,i){
						if(record.get('id') == task.id){
							record.set('progress',progress);
						}



					});


//					console.log(task, progress);
				},
				on_view_change: function(mode) {
//					console.log(mode);
				}


		    });

		    // handling the mode changes
		    $("#modes-filter :input").change(function() {
		        gantt.change_view_mode($(this).val());
		    });

			$("#ganttTest").scroll(function () {
    $("#tableview-1044").scrollTop($("#ganttTest").scrollTop());
    $("#tableview-1044").scrollLeft($("#ganttTest").scrollLeft());
});
$("#tableview-1044").scroll(function () {
    $("#ganttTest").scrollTop($("#tableview-1044").scrollTop());
    $("#ganttTest").scrollLeft($("#tableview-1044").scrollLeft());
});
//		    var new_height = gantt. $ svg.getAttribute ( 'height')-100;
//				gantt. $ svg.setAttribute ( 'height', new_height);
	}



    Unilite.Main( {
        borderItems:[{
                region:'center',
                layout: 'border',
                border: false,
                items:[
              /*  	{
			                    region: 'north',
			                    xtype: 'container',
			                    layout: 'fit',
			                    layout: {type:'hbox', align:'stretch'},
			                    split:true,
			                    flex: 1,
//			                    title:'금형사진/부품사진',
			                    items: [firstGrid,secondGrid]
                },*/
                	panelResult,
                		{
			                    region: 'center',
			                    xtype: 'container',
			                    layout: 'fit',
			                    layout: {type:'hbox', align:'stretch'},
			                    split:true,
			                    flex: 1,
//			                    title:'금형사진/부품사진',
			                    items: [masterGrid,panel]
                }






        /*        		{
			                    region: 'east',
			                    xtype: 'draw',
                				width:200,
							    height:200,
							    sprites: [{
							        type: 'circle',
							        fillStyle: '#79BB3F',
							        r: 100,
							        x: 100,
							        y: 100
							     }]
                		}*/

			      /*


                	{
			                    region: 'east',
			                    xtype: 'container',
			                    layout: 'fit',
			                    layout: {type:'hbox', align:'stretch'},
			                    split:true,
			                    flex: 3,
//			                    title:'금형사진/부품사진',
			                    items: [




			             {
									xtype: 'component',
									id:'ttt',
									html:'<div class="col-xl-9 mt-4 mt-xl-0">                                                                         '+
            '                           <div class="pl-xl-3">                                                                                         '+
            '                               <div class="row">                                                                                         '+
            '                                   <div class="col-auto">                                                                                '+
            '                                       <a href="javascript: void(0);" class="btn btn-success btn-sm mb-2">Add New Task</a>               '+
            '                                   </div>                                                                                                '+
            '                                   <div class="col text-sm-right">                                                                       '+
            '                                       <div class="btn-group btn-group-sm btn-group-toggle mb-2" data-toggle="buttons" id="modes-filter">'+
            '                                           <label class="btn btn-light d-none d-sm-inline-block">                                        '+
            '                                               <input type="radio" name="modes" id="qday" value="Quarter Day" > Quarter Day              '+
            '                                           </label>                                                                                      '+
            '                                           <label class="btn btn-light">                                                                 '+
            '                                               <input type="radio" name="modes" id="hday" value="Half Day"> Half Day                     '+
            '                                           </label>                                                                                      '+
            '                                           <label class="btn btn-light">                                                                 '+
            '                                               <input type="radio" name="modes" id="day" value="Day"> Day                                '+
            '                                           </label>                                                                                      '+
            '                                           <label class="btn btn-light active">                                                          '+
            '                                               <input type="radio" name="modes" id="week" value="Week" checked> Week                     '+
            '                                           </label>                                                                                      '+
            '                                           <label class="btn btn-light">                                                                 '+
            '                                               <input type="radio" name="modes" id="month" value="Month"> Month                          '+
            '                                           </label>                                                                                      '+
            '                                       </div>                                                                                            '+
            '                                   </div>                                                                                                '+
            '                               </div>                                                                                                    '+
            '                                                                                                                                         '+
            '                               <div class="row">                                                                                         '+
            '                                   <div class="col mt-3">                                                                                '+
            '                                       <svg id="tasks-gantt"></svg>                                                                      '+
            '                                   </div>                                                                                                '+
            '                               </div>                                                                                                    '+
            '                           </div>                                                                                                        '+
            '                       </div>  '
								}




								]
							}

					*/

//
//
//
//
//                				{
//	                    region: 'center',
//	                    xtype: 'container',
//	                    layout: 'fit',
//	                    layout: {type:'vbox', align:'stretch'},
//	                    split:true,
//	                    flex: 1,
//	                    items: [firstGrid,
//                                secondGrid]
//	                }



                	/*panelResult,
                	{
	                    region: 'center',
	                    xtype: 'container',
	                    layout: 'fit',
	                    layout: {type:'vbox', align:'stretch'},
	                    split:true,
	                    flex: 1,
	                    items: [ masterGrid]
	                }*/


                ]
            }
        ],
        id  : 'equ888ukrvApp',
        fnInitBinding : function() {
            this.setDefault();
	fnDatePickerInit();
        },
        onQueryButtonDown : function()  {
            if(!panelResult.getInvalidMessage()) return;   //필수체크
            masterStore.loadStoreRecords();
   /*
            	var tasks2 = [{


		}];

            gantt.custom_popup_html(tasks2);*/





        },
        onResetButtonDown: function() {
            panelResult.clearForm();
            masterGrid.reset();
            masterStore.clearData();
            this.setDefault();
        },

        onNewDataButtonDown: function()	{
			if(!panelResult.getInvalidMessage()) return;   // 필수체크
		        	var r = {
		        		'COMP_CODE':UserInfo.compCode,
		        		'DIV_CODE':panelResult.getValue("DIV_CODE")

		        	};

	//	            subGrid.reset();
	//	            subStore.clearData();
		        	masterGrid.createRow(r);
        },

        onSaveDataButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return;   // 필수체크

            if(masterStore.isDirty()) {
                masterStore.saveStore();
            }
        },
        onDeleteDataButtonDown: function() {
            var param = panelResult.getValues();

                if(record.phantom == true) {
                    masterGrid.deleteSelectedRow();
                } else {

            		if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                        masterGrid.deleteSelectedRow();
                    }

                }
        },
        setDefault: function() {
//            panelResult.setValue('ITEM_ACCOUNT','10');
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'delete', 'deleteAll'],false);
            UniAppManager.setToolbarButtons(['reset','newData'], true);




        }
    });


    Unilite.createValidator('validator01', {
		store: masterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "id":
					var records = masterStore.data.items;
					var tasks=[];
					Ext.each(records, function(rec,i){
						if(record.get('id') == rec.get('id')){
							rec.set('id',newValue);
						}
						tasks.push(rec.data);

					});
					tasks.sort(function(a,b) {

						return parseInt(a.id) - parseInt(b.id);
						//b - a 는 내림차순 a - b 는 오름차순

					});
					gantt.refresh(tasks);
				break;


				case "name":
				case "start":
				case "end":
				case "progress":
				case "dependencies":
					setTimeout( function() {
						gantt.get_task(record.get('id')).fieldName = newValue;
						gantt.refresh(gsTasks);
		   			}, 50 );


				break;
				/*

				case "name" :
					var records = masterStore.data.items;
					var tasks=[];
					Ext.each(records, function(rec,i){
						if(record.get('id') == rec.get('id')){
							rec.set('name',newValue);
						}
						tasks.push(rec.data);

					});
					gantt.refresh(tasks);
				break;


				case "start" :

					var records = masterStore.data.items;
					var tasks=[];
					Ext.each(records, function(rec,i){
						if(record.get('id') == rec.get('id')){
							rec.set('start',newValue);
						}
						tasks.push(rec.data);

					});
					gantt.refresh(tasks);
				break;


				case "end" :
					var records = masterStore.data.items;
					var tasks=[];
					Ext.each(records, function(rec,i){
						if(record.get('id') == rec.get('id')){
							rec.set('end',newValue);
						}
						tasks.push(rec.data);

					});
					gantt.refresh(tasks);
				break;

				case "progress" :
					var records = masterStore.data.items;
					var tasks=[];
					Ext.each(records, function(rec,i){
						if(record.get('id') == rec.get('id')){
							rec.set('progress',newValue);
						}
						tasks.push(rec.data);

					});
					gantt.refresh(tasks);
				break;

				case "dependencies" :
					var records = masterStore.data.items;
					var tasks=[];
					Ext.each(records, function(rec,i){
						if(record.get('id') == rec.get('id')){
							rec.set('dependencies',newValue);
						}
						tasks.push(rec.data);

					});
					gantt.refresh(tasks);
				break;*/
			}
			return rv;
		}
	}); // validator


}


/*	Ext.onReady(function() {






});
    */

</script>


