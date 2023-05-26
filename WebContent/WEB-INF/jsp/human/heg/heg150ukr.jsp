<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="heg150ukr">
	<t:ExtComboStore comboType="BOR120"  /> 					<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="HE03" /> 		<!-- 결재상태 --> 
	<t:ExtComboStore comboType="AU" comboCode="HE17" /> 		<!-- 신청구분 --> 
	<t:ExtComboStore comboType="AU" comboCode="HE28" /> 		<!-- 직원선수구분 --> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	
	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 'heg150ukrService.insertList',				
			read	: 'heg150ukrService.selectList',
			update	: 'heg150ukrService.updateList',
			destroy	: 'heg150ukrService.deleteList',
			syncAll	: 'heg150ukrService.saveAll'
		}
	});
	
	
	
	
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('heg150ukrModel', {
		fields: [
			{name: 'COMP_CODE'		, text: '법인코드'		 	, type: 'string'},
			{name: 'DOC_ID'			, text: '자동채번'		 	, type: 'string'},
			{name: 'BASIS_NUM'		, text: '근거번호'		 	, type: 'string'},
			{name: 'PERSON_NUMB'	, text: '사원번호'		 	, type: 'string'	, allowBlank: false},
			{name: 'NAME'			, text: '사원명'		 	, type: 'string'},
			{name: 'REQ_DATE'		, text: '신청일자'		 	, type: 'uniDate'	, allowBlank: false},
			{name: 'REQ_NUM'		, text: '신청부수'		 	, type: 'uniNumber'},
			{name: 'TARGET_NAME'	, text: '대상자'	 		, type: 'string'},
			{name: 'POSITION_TYPE'	, text: '직원선수구분'	 	, type: 'string'	, comboType:'AU'	, comboCode:'HE28'},
			{name: 'REQ_TYPE'		, text: '신청구분'			, type: 'string'	, comboType:'AU'	, comboCode:'HE17'},
			{name: 'SOURCE_YEAR'	, text: '원천년도'		 	, type: 'string'},
			{name: 'TAX_MONTH'		, text: '갑근세(월)'		, type: 'string'},
			{name: 'SUBMIT_PLACE'	, text: '제출처'		 	, type: 'string'},
			{name: 'REASON'			, text: '신청사유'	 		, type: 'string'},
			{name: 'DRAFT_STATUS'	, text: '결재상태'	 		, type: 'string'	, comboType:'AU', comboCode:'HE03'}
		]										
	});//End of Unilite.defineModel('heg150ukrModel', {
	
	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */			
	var masterStore = Unilite.createStore('heg150ukrMasterStore1', {
		model	: 'heg150ukrModel',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: true,			// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function(){
			var param= Ext.getCmp('resultForm').getValues();			
			console.log(param);
			this.load({
				params: param
			});
		},
		saveStore : function()	{				
			var inValidRecs = this.getInvalidRecords();
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords( );      		
       		var toDelete	= this.getRemovedRecords();
			var changedRec	= [].concat(toCreate).concat(toUpdate);

			//발행 부수 체크
			if (fnCheckReqiured(changedRec)) return false;
			
			if(inValidRecs.length == 0 )	{
				config = {
//					params: [paramMaster],
					success: function(batch, option) {
						
					 } 
				};
				this.syncAllDirect(config);				
			}else {					
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function() {
				if (this.getCount() > 0) {
//				  	UniAppManager.setToolbarButtons('delete', true);
					} else {
//				  	  	UniAppManager.setToolbarButtons('delete', false);
					}  
			}
		}
	});
		

	
	
	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 2, tableAttrs: {width: '100%'}},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{ 
				fieldLabel		: '신청일',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'REQ_DATE_FR',
				endFieldName	: 'REQ_DATE_TO',
				startDate		: UniDate.get('startOfMonth'),
				endDate			: UniDate.get('today'),
				allowBlank		: false,	  	
				tdAttrs			: {width: 350, align: 'left'}, 
				width			: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
				}
			},{
				fieldLabel	: '신청구분',
				name		: 'REQ_TYPE', 
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'HE17',
				tdAttrs     : {align: 'left'}, 
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
					}
				}
			},
			Unilite.popup('Employee',{
				fieldLabel		: '사원',
			  	valueFieldName	: 'PERSON_NUMB',
				textFieldName	: 'NAME',
				validateBlank	: false,
				autoPopup		: true,
				tdAttrs         : {align: 'left'}, 
				listeners: {
					onValueFieldChange: function(field, newValue){
					},
					onTextFieldChange: function(field, newValue){
					}
				}
			}),
			{
				
                Id      : 'PrintBtn',
                text    : '증명서 출력',
                width   : 100,
                xtype   : 'button',
                tdAttrs : { align: 'right'}, 
                handler: function() {
                },
                disabled: false
            }
		]
	});
	
		
	
	
	
	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('heg150ukrGrid1', {
		store	: masterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: true,
		 	useRowNumberer		: true,
    		onLoadSelectFirst	: false,
		 	copiedRow			: true
//		 	useContextMenu		: true,
		},
    	selModel	: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: true, mode: 'SINGLE',
    		listeners: {  
//  				beforeselect: function(rowSelection, record, index, eOpts) {
//					if(this.selected.getCount() > 0){
//						return false;	
//					}
//        		},
  				select: function(grid, selectRecord, index, rowIndex, eOpts ){
	    			if (this.selected.getCount() > 0) {
						UniAppManager.setToolbarButtons('print', true);
	    			}
    			},
	    		deselect:  function(grid, selectRecord, index, eOpts ){
	    			if (this.selected.getCount() <= 0) {			//체크된 데이터가 0개일  때는 버튼 비활성화
						UniAppManager.setToolbarButtons('print', false);
	    			}
	    		}
    		}
        }),
		features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
				   	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
		columns	: [{														
				xtype		: 'rownumberer',									
				align		:'center  !important', 					
				width		: 35,														
				sortable	: false,													
				resizable	: true											
			},	
			{dataIndex: 'COMP_CODE'		, width: 80		, hidden: true},
//			{dataIndex: 'DOC_ID'		, width: 80		, hidden: true},
			{dataIndex: 'BASIS_NUM'		, width: 110},
			{dataIndex: 'PERSON_NUMB'	, width: 110,
				'editor' : Unilite.popup('Employee_G',{
					validateBlank : true,
					autoPopup:true,
	  				listeners: {
	  					'onSelected': {
							fn: function(records, type) {
									console.log('records : ', records);
									console.log(records);
									var grdRecord = masterGrid.getSelectionModel().getSelection()[0];
									grdRecord.set('PERSON_NUMB'		, records[0].PERSON_NUMB);
									grdRecord.set('NAME'			, records[0].NAME);
								},			  						
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = Ext.getCmp('heg150ukrGrid1').uniOpt.currentRecord;
							grdRecord.set('PERSON_NUMB'		, '');
							grdRecord.set('NAME'			, '');
						},
						applyextparam: function(popup){	
//							popup.setExtParam({'PAY_GUBUN' : '2'});
						}
	 				}
				})
			},
			{dataIndex: 'NAME'			, width: 110,
				'editor' : Unilite.popup('Employee_G',{
					validateBlank : true,
					autoPopup:true,
	  				listeners: {
	  					'onSelected': {
							fn: function(records, type) {
									console.log('records : ', records);
									console.log(records);
									var grdRecord = masterGrid.getSelectionModel().getSelection()[0];
									grdRecord.set('PERSON_NUMB'		, records[0].PERSON_NUMB);
									grdRecord.set('NAME'			, records[0].NAME);
								},			  						
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = Ext.getCmp('heg150ukrGrid1').uniOpt.currentRecord;
							grdRecord.set('PERSON_NUMB'		, '');
							grdRecord.set('NAME'			, '');
						},
						applyextparam: function(popup){	
//							popup.setExtParam({'PAY_GUBUN' : '2'});
						}
	 				}
				})
			},
			{dataIndex: 'REQ_DATE'		, width: 100},
			{dataIndex: 'REQ_NUM'		, width: 80},
//			{dataIndex: 'TARGET_NAME'	, width: 80		, hidden: true},
//			{dataIndex: 'POSITION_TYPE'	, width: 110	, hidden: true},
			{dataIndex: 'REQ_TYPE'		, width: 110},
			{dataIndex: 'SOURCE_YEAR'	, width: 100	, align: 'center'	/*,
				 getEditor: function(record) {
					return  Ext.create('Ext.grid.CellEditor', {
						ptype			: 'cellediting',
						clicksToEdit	: 1, // 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수 
						autoCancel		: false,
						selectOnFocus	: true,
						field			: {
				        	xtype	: 'uniYearField',
				        	value	: new Date().getFullYear()
				        }
 				 	})
	         	}*/
	        },
//			{dataIndex: 'TAX_MONTH'		, width: 100	, hidden: true},
			{dataIndex: 'SUBMIT_PLACE'	, width: 110},
			{dataIndex: 'REASON'		, width: 300}/*,
			{dataIndex: 'DRAFT_STATUS'	, width: 110	, hidden: true}*/
		], 
		listeners: {
	  		beforeedit  : function( editor, e, eOpts ) {
	      		if(e.record.phantom){
		  			if (UniUtils.indexOf(e.field, ['BASIS_NUM'])){
						return false;
					}

				} else {
		  			if (UniUtils.indexOf(e.field, ['BASIS_NUM', 'PERSON_NUMB', 'NAME', 'REQ_DATE'])){
						return false;
					}
				}
	  		}
		}
	});//End of var masterGrid = Unilite.createGr100id('heg150ukrGrid1', {	
			
	
	
	
	Unilite.Main( {
		id			: 'heg150ukrApp',
		border		: false,
		borderItems	: [{
			region	: 'center',
			layout	: {type: 'vbox', align: 'stretch'},
			border	: false,
			items	: [
				panelResult, masterGrid 
			]
		}],
		
		fnInitBinding: function() {
			//초기값 설정
			panelResult.setValue('REQ_DATE_FR'	, UniDate.get('startOfMonth'));
			panelResult.setValue('REQ_DATE_TO'	, UniDate.get('today'));
//			panelResult.setValue('REQ_TYPE'	, 'Y');

			//버튼 설정
			UniAppManager.setToolbarButtons(['newData']			, true);
			UniAppManager.setToolbarButtons(['reset', 'save', 'print']	, false);

			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('REQ_DATE_FR');
		},
		
		onQueryButtonDown: function() {
			//필수입력값 체크
			if(!this.isValidSearchForm()){
				return false;
			}
			
			masterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);
			UniAppManager.setToolbarButtons(['save', 'print']	, false);
		},
		
		onNewDataButtonDown : function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			var record = {
				REQ_DATE	: new Date(),
				REQ_NUM		: 1,
				SOURCE_YEAR : new Date().getFullYear()
			};
			masterGrid.createRow(record, null, masterGrid.getStore().getCount()-1);
			UniAppManager.setToolbarButtons('reset', true);
		},
		
		onSaveDataButtonDown : function() {
			masterGrid.getStore().saveStore();
		},
		
		onDeleteDataButtonDown : function()	{
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		
		onResetButtonDown : function() {
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();;
		}
	});//End of Unilite.Main( {
	
	
	
	
	function fnCheckReqiured(records) {					//DIVERT_DIVI 값에 따른 필수컬럼 체크 로직
        var isErr = false;
		Ext.each(records, function(record, index){
			var alertMessage = '';
			
        	if(record.get('REQ_NUM') == 0 || Ext.isEmpty(record.get('REQ_NUM'))) {								//"발행부수"가 0일 경우,
				alertMessage = alertMessage + ' 발행부수';
				isErr = true;
        	}
        	
    		if (Ext.isEmpty(alertMessage)) {
    			isErr = false;
    			return false;
    		} else {
    			alert ((index+1) + '행의' + alertMessage + ' 은(는) 0이 될 수 없습니다.')
				return false;
    		}
    	});
  		return isErr;					//필수값이 입력이 안 되었으면 위에서 메세지 출력 후 return true, 입력이 되었으면 return false
	}; 

};
</script>
