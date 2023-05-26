<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="hpa300ukr">
	<!-- 사업장 -->
	<t:ExtComboStore comboType="BOR120" />
	<!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" />
	<!-- 지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" />
	<!-- 고용형태 -->
	<t:ExtComboStore comboType="AU" comboCode="H011" />
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {
	color: #333333;
	font-weight: normal;
	padding: 1px 2px;
}
</style>
<script type="text/javascript">

var checkCount     = 0;                   // 체크박스 체크된 개수
var healthInsure   = '${healthInsure}';   // 노인요양보험 포함여부
var insureRateList = ${insureRateList}; // 보험 요율
// 보험구분 store
var insureType = [  {'text':'국민연금'		, 'value':'1'},
                     {'text':'건강보험'		, 'value':'2'},
                     {'text':'고용보험'		, 'value':'3'}];

function appMain() {
	
	// 노인요양보험 포함 안할 경우
	if(healthInsure == '1') {
		insureType.push({'text':'노인장기요양보험'		, 'value':'4'});
	}
		
	var InsurStore = Unilite.createStore('InsurStore', {
		fields: ['text', 'value'],
		data :  insureType
	});

	// Direct Proxy 정의
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'hpa300ukrService.selectList',
			update	: 'hpa300ukrService.update',
			create	: 'hpa300ukrService.update',
			syncAll	: 'hpa300ukrService.saveAll'
		}
	});

	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hpa300ukrModel', {
		fields: [
			{name: 'CHOICE'				, text: '선택'				, type: 'boolean'},
			{name: 'DIV_CODE'    		, text: '사업장'				, type: 'string', comboType: 'BOR120'},
			{name: 'DEPT_NAME'   		, text: '부서'				, type: 'string'},
			{name: 'POST_CODE'   		, text: '직위'				, type: 'string', comboType: 'AU', comboCode: 'H005'},
			{name: 'NAME'				, text: '성명'				, type: 'string'},
			{name: 'PERSON_NUMB'		, text: '사번'				, type: 'string'},
			{name: 'REPRE_NUM'			, text: '주민등록번호'			, type: 'string'},
			{name: 'JOIN_DATE'			, text: '입사일'				, type: 'uniDate'},
			{name: 'RETR_DATE'			, text: '퇴사일'				, type: 'uniDate'},
			{name: 'INSUR_OLD'			, text: '변경전보험금액'			, type: 'uniPrice'},
			{name: 'TOTAL_AMT'			, text: '연간보수총액'			, type: 'uniPrice'},
			{name: 'LONG_MONTH'			, text: '근무월수'				, type: 'uniQty'},
			{name: 'BASE_I'				, text: '기준액'				, type: 'uniPrice'},
			{name: 'INSUR_I'			, text: '보험금액'				, type: 'uniPrice'},
			{name: 'MED_INSUR_NO'		, text: '보험증번호'				, type: 'string'},
			{name: 'INSUR_TYPE'		    , text: '보험구분'				, type: 'string'}
	    ]
	});		// End of Ext.define('Hpa300ukrModel', {
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('hpa300MasterStore',{
		model: 'Hpa300ukrModel',
		uniOpt: {
            isMaster	: true,			// 상위 버튼 연결 
            editable	: true,			// 수정 모드 사용 
            deletable	: false,		// 삭제 가능 여부 
	        useNavi 	: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()	{				
 			var inValidRecs = this.getInvalidRecords();
 			var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();
            var toDelete = this.getRemovedRecords();
            var list = [].concat(toUpdate, toCreate);
 			console.log("inValidRecords : ", inValidRecs);
 			if(inValidRecs.length == 0 )	{
 				var paramMaster= panelSearch.getValues();   //syncAll 수정
 				config = {
                        params: [paramMaster],
                        success: function(batch, option) {
                        }
                };
 				this.syncAllDirect(config);				
 			}else {
 				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
 			}
 		}
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{	
			title: '기본정보', 	
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			holdable: 'hold',
			items: [{
				fieldLabel: '기준일',
				id: 'BASE_DATE',
				xtype: 'uniDatefield',
				name: 'BASE_DATE',
				value: UniDate.get('today'),
				allowBlank: false,
				holdable: 'hold',
				hidden: true,
				listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('BASE_DATE', newValue);

						// 년도가 바뀌는 경우
						if(oldValue.getFullYear() != newValue.getFullYear()){
							Ext.getBody().mask('로딩중...','loading-indicator');
							var param = { "S_COMP_CODE" : UserInfo.compCode
										, "BASE_YEAR"   : newValue.getFullYear()
							};
							// 해당 년도 바뀌는지 비교후 바뀌는 경우 요율 다시조회
							hpa300ukrService.selectInsuranceRate(param, function(provider, response) {
								if(provider){
									insureRateList = provider;
								}
								Ext.getBody().unmask();
							});	
						}
					}
				}
			},{
				fieldLabel: '보험구분',
				name: 'INSUR_TYPE', 
				xtype: 'combobox',
				store: InsurStore,
				displayField : 'text',
				valueField : 'value',
				value : '1',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('INSUR_TYPE', newValue);
                    }
                }
			},{
				fieldLabel: '사업장',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				holdable: 'hold',
				listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('YEAR_YYYY', newValue);
                    }
                }
			},
				Unilite.popup('DEPT',{
				fieldLabel: '부서',
				textFieldWidth: 170,
				valueFieldName: 'DEPT_CODE',
				textFieldName: 'DEPT_NAME',
				validateBlank: false,
				popupWidth: 710,
				holdable: 'hold',
				listeners: {
				onSelected: {
                      fn: function(records, type) {
                          panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
                          panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
                      },
                      scope: this
                  },
                  onClear: function(type) {
                      panelResult.setValue('DEPT_CODE', '');
                      panelResult.setValue('DEPT_NAME', '');
                      panelSearch.setValue('DEPT_CODE', '');
                      panelSearch.setValue('DEPT_NAME', '');
                  }
              }
			}),
			    Unilite.popup('DEPT', {
		    	fieldLabel: '~',
		    	valueFieldName: 'DEPT_CODE2',
		    	textFieldName: 'DEPT_NAME2',
		    	textFieldWidth: 170,
		    	validateBlank: false,
		    	popupWidth: 710,
		    	holdable: 'hold',
		    	listeners: {
                    onSelected: {
                      fn: function(records, type) {
                          panelResult.setValue('DEPT_CODE2', panelSearch.getValue('DEPT_CODE2'));
                          panelResult.setValue('DEPT_NAME2', panelSearch.getValue('DEPT_NAME2'));
                      },
                      scope: this
                      },
                      onClear: function(type) {
                          panelResult.setValue('DEPT_CODE2', '');
                          panelResult.setValue('DEPT_NAME2', '');
                          panelSearch.setValue('DEPT_CODE2', '');
                          panelSearch.setValue('DEPT_NAME2', '');
                      }
                }
			}),			
				Unilite.popup('Employee', {
				textFieldWidth: 170, 
				validateBlank: false,
				valueFieldName: 'PERSON_NUMB',
				textFieldName: 'NAME',
				extParam: {'CUSTOM_TYPE': '3'},
				holdable: 'hold',
				listeners: {
                     onSelected: {
                      fn: function(records, type) {
                          panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
                          panelResult.setValue('NAME', panelSearch.getValue('NAME'));
                      },
                      scope: this
                      },
                      onClear: function(type) {
                          panelResult.setValue('PERSON_NUMB', '');
                          panelResult.setValue('NAME', '');
                          panelSearch.setValue('PERSON_NUMB', '');
                          panelSearch.setValue('NAME', '');
                      }
                }
			})]
		},{	
			title: '추가정보', 	
			itemId: 'search_panel2',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '지급차수',
				name: 'PAY_PROV_FLAG', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H031',
				holdable: 'hold'
			},{
				fieldLabel: '고용형태',
				name: 'PAY_GUBUN', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H011',
				holdable: 'hold'
			},			
			{
				xtype: 'container',
				padding: '10 0 0 0',
				width: 300,
				layout: {
					type: 'hbox',
					align: 'center',
					pack:'center'
				},
				items:[{
					xtype: 'button',
					text: '파일 UpLoad',
					width: 100,
					margin: '0 20 0 50',
					handler: function(btn) {
						openExcelWindow();
					}
				},{
					xtype: 'button',
					id: 'select',
					text: '전체선택',
					width: 100,
					handler: function(){
						var record = directMasterStore.data.items.length;
                        if(!Ext.isEmpty(record) && record == 0 ){
                            alert('선택할 데이터가 없습니다.');
                            return false;
                        }else{
                            SelectAll();
                            UniAppManager.setToolbarButtons('save',true);
                        }
					}
				},{
					xtype: 'button',
					id: 'deselect',
					text: '전체해제',
					width: 100,
					hidden: true,
					handler: function(){
						DeSelectAll();
						UniAppManager.setToolbarButtons('save',false);
					}
				}]
			}
			]
		}],
        setAllFieldsReadOnly: setAllFieldsReadOnly
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm', {
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{
			xtype: 'container',
			layout:{type : 'uniTable', columns : 2},
			items:[{
				fieldLabel: '기준일',
				xtype: 'uniDatefield',
				name: 'BASE_DATE',
				value: UniDate.get('today'),
				allowBlank: false,
				holdable: 'hold',
				hidden: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('BASE_DATE', newValue);
						
						// 년도가 바뀌는 경우
						if(oldValue.getFullYear() != newValue.getFullYear()) {
							Ext.getBody().mask('로딩중...','loading-indicator');
							var param = { "S_COMP_CODE" : UserInfo.compCode
										, "BASE_YEAR"   : newValue.getFullYear()
							};
							// 해당 년도 바뀌는지 비교후 바뀌는 경우 요율 다시조회
							hpa300ukrService.selectInsuranceRate(param, function(provider, response) {
								if(provider){
									insureRateList = provider;
								}
								Ext.getBody().unmask();
							});	
						}
					}
				}
			},{
				fieldLabel: '보험구분',
				name: 'INSUR_TYPE', 
				xtype: 'combobox',
				store: InsurStore,
				displayField : 'text',
				valueField : 'value',
				value : '1',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('INSUR_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '사업장',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				holdable: 'hold',
				colspan:2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('DEPT',{
				fieldLabel: '부서',
				valueFieldName: 'DEPT_CODE',
				textFieldName: 'DEPT_NAME',
				textFieldWidth: 170,
				validateBlank: false,
				popupWidth: 710,
				holdable: 'hold',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
							panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
						},
						scope: this
					},
					onClear: function(type) {
						panelResult.setValue('DEPT_CODE', '');
						panelResult.setValue('DEPT_NAME', '');
						panelSearch.setValue('DEPT_CODE', '');
						panelSearch.setValue('DEPT_NAME', '');
					}
				}
			}),
			Unilite.popup('DEPT', {
				fieldLabel: '~',
				valueFieldName: 'DEPT_CODE2',
				textFieldName: 'DEPT_NAME2',
				textFieldWidth: 170,
				validateBlank: false,
				popupWidth: 710,
				holdable: 'hold',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('DEPT_CODE2', panelResult.getValue('DEPT_CODE2'));
							panelSearch.setValue('DEPT_NAME2', panelResult.getValue('DEPT_NAME2'));
						},
						scope: this
					},
					onClear: function(type) {
						panelResult.setValue('DEPT_CODE2', '');
						panelResult.setValue('DEPT_NAME2', '');
						panelSearch.setValue('DEPT_CODE2', '');
						panelSearch.setValue('DEPT_NAME2', '');
					}
				}
			}),
			Unilite.popup('Employee', {
				valueFieldName: 'PERSON_NUMB',
				textFieldName: 'NAME',
				textFieldWidth: 170, 
				validateBlank: false,
				extParam: {'CUSTOM_TYPE': '3'},
				holdable: 'hold',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
							panelSearch.setValue('NAME', panelResult.getValue('NAME'));
						},
						scope: this
					},
					onClear: function(type) {
						panelResult.setValue('PERSON_NUMB', '');
						panelResult.setValue('NAME', '');
						panelSearch.setValue('PERSON_NUMB', '');
						panelSearch.setValue('NAME', '');
					}
				}
			}),{
				fieldLabel: '지급차수',
				name: 'PAY_PROV_FLAG', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				hidden: true,
				comboCode: 'H031'
			},{
				fieldLabel: '고용형태',
				name: 'PAY_GUBUN', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				hidden: true,
				comboCode: 'H011'
			},{
				xtype: 'container',
				padding: '0 0 5 0',
				width: 300,
				layout: {
					type: 'hbox',
					align: 'center',
					pack:'center'
				},
			items:[{
				xtype: 'button',
				text: '파일 UpLoad',
				width: 100,
				margin: '0 20 0 50',
				handler: function(btn) {
					openExcelWindow();
				}
			},{
				xtype: 'button',
				id: 'select1',
				text: '전체선택',
				width: 100,
				handler: function(){
					var record = directMasterStore.data.items.length;
					if(!Ext.isEmpty(record) && record == 0 ) {
						alert('선택할 데이터가 없습니다.');
						return false;
					} else {
						SelectAll();
						UniAppManager.setToolbarButtons('save',true);
					}
				}
			},{
				xtype: 'button',
				id: 'deselect1',
				text: '전체해제',
				width: 100,
				hidden: true,
				handler: function() {
					DeSelectAll();
					UniAppManager.setToolbarButtons('save',false);
				}
			}]
		}]//,
	//setAllFieldsReadOnly: setAllFieldsReadOnly
	},{
		xtype:'component',
		margin: '0 0 0 100',
		width: 700,
		html:'<div style="color:#0033CC">※ 본 프로그램은 각 사원별  \'인사정보등록\'의 국민/건강/고용보험료 금액을 일괄 업데이트 하는 용도로, 업로드 전,<br> &nbsp;&nbsp;&nbsp;반드시 전월급여계산을 완료 후, 실행하시기를 바랍니다.<br> &nbsp;&nbsp;&nbsp;전월 급여 변동 가능시는, \'공제내역 기간등록\'에서 기간별로 업로드를 부탁드립니다.</div>'
	}],
	setAllFieldsReadOnly: setAllFieldsReadOnly
}); //end panelResult
       
	// 전체선택
	function SelectAll(){		
		var grid = Ext.getCmp('hpa300Grid1');
		var model = grid.getStore().getRange();

		Ext.each(model, function(record,i){
			record.set('CHOICE',true);
			checkCount = i+1;
		});

		Ext.getCmp('select1').setVisible(false);
		Ext.getCmp('select').setVisible(false);
		Ext.getCmp('deselect1').setVisible(true);
		Ext.getCmp('deselect').setVisible(true);
	}
	// 전체해제
	function DeSelectAll(){
		var grid = Ext.getCmp('hpa300Grid1');
		var model = grid.getStore().getRange();
		
		Ext.each(model, function(record,i){
			record.set('CHOICE',false);
			checkCount = i+1;
		});
		Ext.getCmp('select1').setVisible(true);
		Ext.getCmp('select').setVisible(true);
		Ext.getCmp('deselect1').setVisible(false);
		Ext.getCmp('deselect').setVisible(false);
	}
	
	var excelWindow; //업로드 선언
	function openExcelWindow() {
		
		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.ExcelUploadWin';

		if(!excelWindow) { 
			excelWindow =  Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				excelConfigName: 'hpa300ukr',
				grids: [{ //팝업창에서 가져오는 그리드
					itemId: 'grid01',
					title: '4대보험일괄등록',
					useCheckbox: true,
					model : 'Hpa300ukrModel',
					readApi: 'hpa300ukrService.selectExcelUploadSheet1',
					columns: [	
						  {dataIndex: 'DIV_CODE'         , width: 120}
						, {dataIndex: 'DEPT_NAME'        , width: 120}
						, {dataIndex: 'POST_CODE'        , width: 120}
						, {dataIndex: 'PERSON_NUMB'      , width: 120}
						, {dataIndex: 'NAME'             , width: 80}
						, {dataIndex: 'REPRE_NUM'        , width: 120}
						, {dataIndex: 'JOIN_DATE'        , width: 120}
						, {dataIndex: 'RETR_DATE'        , width: 120}
						, {dataIndex: 'ANU_INSUR_I'      , width: 120}
						, {dataIndex: 'TOTAL_AMT'        , width: 120}
						, {dataIndex: 'LONG_MONTH'       , width: 120}
						, {dataIndex: 'MED_INSUR_NO'     , width: 120}
						, {dataIndex: 'INSUR_I'          , width: 120}
						, {dataIndex: 'BASE_I'           , width: 120}
					]
				}],
				listeners: {
					close: function() {
						this.hide();
					}
				},
				onApply:function()	{
					
					var me = this;
					var grid = this.down('#grid01');
					var records = grid.getSelectionModel().getSelection();

					if(grid.getStore().getCount() < 1) {
						alert('업로드된 데이터가 없습니다.');
						return;
					}

					if(records < 1) {
						alert('선택된 데이터가 없습니다.');
						return;
					}

					excelWindow.getEl().mask('로딩중...','loading-indicator');
					// 기존 데이터 초기화
					masterGrid.reset();
					directMasterStore.clearData();

					// 엑셀에 업로드한 데이터 setting
					Ext.each(records, function(record,i){	
						UniAppManager.app.onNewDataButtonDown();
						masterGrid.setExcelData(record.data);
					});

					// 엑셀업로드한 데이터가 1개 이상 되는 경우 버튼 enable 재정의
					if(masterGrid.getStore().data.items.length > 0){
						
						panelResult.setAllFieldsReadOnly(true);
						panelSearch.setAllFieldsReadOnly(true);
						
						UniAppManager.setToolbarButtons('reset',true);
						UniAppManager.setToolbarButtons('query',false);
					}
					
					excelWindow.getEl().unmask();
					grid.getStore().removeAll();
					excelWindow.close();
					
				}
			});
		}
		excelWindow.center();
		excelWindow.show();
	};

	/**
	 * Master Grid 정의(Grid Panel)
	 * @type 
	 */

	var masterGrid = Unilite.createGrid('hpa300Grid1', {
		layout : 'fit',
		region : 'center',
		store: directMasterStore,
		uniOpt: {
			expandLastColumn: true,
			useRowNumberer: true,
			useMultipleSorting: true
		},
		columns: [
			{dataIndex: 'CHOICE', width: 33, xtype : 'checkcolumn',
				listeners: {
					checkchange: function(CheckColumn, rowIndex, checked, eOpts){
						var button1 = Ext.getCmp('select1');
						var button2 = Ext.getCmp('deselect1');
						var grdRecord = masterGrid.getStore().getAt(rowIndex);
						// check 박스 클릭
						if(checked == true){
							checkCount++;
							UniAppManager.setToolbarButtons('save',true);
						}else{
							checkCount--;
						}
						if(checkCount == 0){
							UniAppManager.setToolbarButtons('save',false);
							button1.setVisible(true);
							button2.setVisible(false);
						}else{
							UniAppManager.setToolbarButtons('save',true);
							button1.setVisible(false);
							button2.setVisible(true);
						}
					}
				}
			},
			{dataIndex: 'DIV_CODE'    		, width: 120, editable: false},
			{dataIndex: 'DEPT_NAME'   		, width: 120, editable: false},
			{dataIndex: 'POST_CODE'   		, width: 100, editable: false},
			{dataIndex: 'NAME'				, width: 106, editable: false},
			{dataIndex: 'PERSON_NUMB'		, width: 100, editable: false},
			{dataIndex: 'REPRE_NUM'			, width: 133, editable: false},
			{dataIndex: 'JOIN_DATE'			, width: 100, editable: false},
			{dataIndex: 'RETR_DATE'			, width: 80, hidden: true},
			{dataIndex: 'INSUR_OLD'			, width: 100, hidden: true},
			{dataIndex: 'TOTAL_AMT'			, width: 80, hidden: true},
			{dataIndex: 'LONG_MONTH'		, width: 60, hidden: true},
			{dataIndex: 'BASE_I'			, width: 120},
			{dataIndex: 'INSUR_I'			, width: 120},
			{dataIndex: 'MED_INSUR_NO'		, width: 6, hidden: true},
			{dataIndex: 'INSUR_TYPE'		, width: 60, hidden: true}
		],
		setExcelData: function(record) {   
			var grdRecord = this.getSelectedRecord();				
			grdRecord.set('DIV_CODE'     , record['DIV_CODE']);
			grdRecord.set('DEPT_NAME'    , record['DEPT_NAME']);
			grdRecord.set('POST_CODE'    , record['POST_CODE']);
			grdRecord.set('PERSON_NUMB'  , record['PERSON_NUMB']);
			grdRecord.set('NAME'		 , record['NAME']);
			grdRecord.set('REPRE_NUM'	 , record['REPRE_NUM']);
			grdRecord.set('JOIN_DATE'    , record['JOIN_DATE']);
			grdRecord.set('RETR_DATE'    , record['RETR_DATE']);
			grdRecord.set('ANU_INSUR_I'  , record['ANU_INSUR_I']);
			grdRecord.set('TOTAL_AMT'    , record['TOTAL_AMT']);
			grdRecord.set('LONG_MONTH'   , record['LONG_MONTH']);
			grdRecord.set('MED_INSUR_NO' , record['MED_INSUR_NO']);
			grdRecord.set('INSUR_TYPE'   , panelResult.getValue('INSUR_TYPE'));
			grdRecord.set('BASE_I'		 , record['BASE_I']);
			grdRecord.set('INSUR_I'		 , record['INSUR_I']);

		},
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				// 보험 구분
				var insureType = panelSearch.getValue('INSUR_TYPE');
				
				// 보험구분이 노인장기요양보험이면 기준액 변경 못함
				if (UniUtils.indexOf(e.field, ['BASE_I']) && "4" == insureType) {
					return false;
				}
			}
		}
	});
	
	 Unilite.Main( {
		 borderItems	: [{
				region	: 'center',
				layout	: 'border',
				border	: false,
				items	: [
					masterGrid, panelResult
				]
			},
				panelSearch
			],
		id : 'hpa300ukrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
			UniAppManager.setToolbarButtons('reset',false);
		},
		// 조회
		onQueryButtonDown : function()	{
			directMasterStore.loadStoreRecords();
			
			panelResult.setAllFieldsReadOnly(true);
			panelSearch.setAllFieldsReadOnly(true);
			UniAppManager.setToolbarButtons('reset',true);
			UniAppManager.setToolbarButtons('query',false);
		},
		// 신규
		onResetButtonDown: function()   {
			// 조회조건 readonly
			panelResult.setAllFieldsReadOnly(false);
			panelSearch.setAllFieldsReadOnly(false);
			masterGrid.reset(); // grid reset
			
			// 신규, 저장버튼 enable 처리
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('query',true);

        },
        onNewDataButtonDown: function()   {
            
            var divCode     = panelResult.getValue('DIV_CODE');
            var insurtype   = panelResult.getValue('INSUR_TYPE');
            var deptname    = '';
            var postcode    = '';
            var name        = '';
            var personnumb  = '';
            var retrnum     = '';
            var joindate    = '';
            var retrdate    = '';
            var insurold    = '';
            var totalamt    = '';
            var longmonth   = '';
            var base_i      = '0';
            var insur_i     = '0';
            var medinsurno  = '0';
            var anuinsuri   = '0';
            
            var r = {
               DIV_CODE		: divCode,
               DEPT_NAME	: deptname,
               POST_CODE	: postcode,
               PERSON_NUMB	: personnumb,
               NAME			: name,
               REPRE_NUM	: retrnum,
               JOIN_DATE	: joindate,
               RETR_DATE	: retrdate,
               ANU_INSUR_I	: anuinsuri,
               TOTAL_AMT	: totalamt,
               LONG_MONTH	: longmonth,
               MED_INSUR_NO	: medinsurno,
               BASE_I		: base_i,
               INSUR_I		: insur_i,
               INSUR_TYPE	: insurtype
           };
           masterGrid.createRow(r);
       },
        // 저장
		onSaveDataButtonDown : function(){
			directMasterStore.saveStore();
		}
	});
	 
	// validator
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			
			switch(fieldName) {
				// 기준액
				case "BASE_I" :
					// 보험구분
					var type = panelSearch.getValue('INSUR_TYPE');
					
					// 해당 보험구분의 요율 찾기
					var idx = insureRateList.findIndex((element, index, arr) => arr[index].INSUR_TYPE === type);
					var rateData = insureRateList[idx];
					
					// 해당 보험의 요율 적용
					var insurI = newValue * (rateData.INSUR_RATE/100);
					
					/* 노인요양보험이 건강보험에 포함할 경우 && 건강보험 선택시 노인요양보험 요율 적용
					 * healthInsure (1:포함안함, 2:포함)
					 * type (1:국민연금, 2:건강보험, 3:고용보험)
					 */
					if(healthInsure == '2' && type == '2') {
						insurI *= (rateData.INSUR_RATE1/100 + 1);
					}
					
					record.set('INSUR_I', insurI);
					break;
			}
			return rv;
		}
	});
	
	function setAllFieldsReadOnly(b) { 
		var r= true
		if(b) {
			var invalid = this.getForm().getFields().filterBy(function(field) {
				return !field.validate();
			});

			if(invalid.length > 0) {
				r=false;
				var labelText = ''
				
				if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
					var labelText = invalid.items[0]['fieldLabel']+'은(는)';
				
				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
					var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
				}
				alert(labelText+Msg.sMB083);
				invalid.items[0].focus();

			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(true); 
						}
					} 
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField');
						if(popupFC.holdable == 'hold') {
							popupFC.setReadOnly(true);
						}
					}
				});
			}
			
		} else {
			var fields = this.getForm().getFields();
			Ext.each(fields.items, function(item) {
				if(Ext.isDefined(item.holdable) ) {
					if (item.holdable == 'hold') {
						item.setReadOnly(false);
					}
				} 
				if(item.isPopupField) {
					var popupFC = item.up('uniPopupField');
					if(popupFC.holdable == 'hold' ) {
						item.setReadOnly(false);
					}
				}
			});
		}
		return r;
	}
};
</script>
