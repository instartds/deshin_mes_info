<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hbs910ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="B010" /> <!-- 사용여부 --> 
	<t:ExtComboStore comboType="AU" comboCode="H005" /> <!-- 직위코드 --> 
	<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 --> 
	<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 --> 
	<t:ExtComboStore comboType="AU" comboCode="H032" /> <!-- 지급구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H153" /> <!-- 마감여부 -->
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	colData = ${colData};
	var flag = 0;
	var fields = createModelField(colData);
	var columns = createGridColumn(colData);

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'hbs910ukrvService.selectList',
			update	: 'hbs910ukrvService.updateList',
			create	: 'hbs910ukrvService.insertList',
			destroy	: 'hbs910ukrvService.deleteList',
			syncAll	: 'hbs910ukrvService.syncAll'
		}
	});

	Unilite.defineModel('Hbs910ukrvModel', {fields : fields });

	/* Store 정의(Service 정의)
	 * @type 
	 */
	var masterStore = Unilite.createStore('hbs910ukrvMasterStore1', {
		model : 'Hbs910ukrvModel', 
		uniOpt : {
        	isMaster	: true,			// 상위 버튼 연결 
        	editable	: true,			// 수정 모드 사용 
        	deletable	: false,		// 삭제 가능 여부 
            useNavi		: false			// prev | newxt 버튼 사용
        }, 
		autoLoad : false, 
        proxy: directProxy,
		loadStoreRecords : function() {	
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params: param
			});
		},
        saveStore : function()	{	
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
        	var toUpdate = this.getUpdatedRecords();
      	 	var toDelete = this.getRemovedRecords();
        	console.log("toUpdate",toUpdate);

//			폼에서 필요한 조건 가져올 경우
    		var payYyyymm 	= panelSearch.getValue('PAY_YYYYMM');
			var paramMaster	= panelSearch.getValues();
			paramMaster.PAY_YYYYMM	= UniDate.getDbDateStr(payYyyymm).substring(0,6);
			paramMaster.DIV_CODE	= panelSearch.getValue('DIV_CODE');
			paramMaster.SUPP_TYPE	= panelSearch.getValue('SUPP_TYPE');
			paramMaster.PERSON_NUMB	= panelSearch.getValue('PERSON_NUMB');
			paramMaster.FLAG		= flag	;
			
        	var rv = true;
   	
        	if(inValidRecs.length == 0 )	{										
				config = {
					params: [paramMaster],
					success: function(batch, option) {								
						//panelResult.resetDirtyStatus();
					} 
				};					
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
          	load: function(store, records, successful, eOpts) {
				UniAppManager.setToolbarButtons('reset', true);			
				UniAppManager.setToolbarButtons('delete', false);	
				
				//데이터가 있으면 초기화에서 비활성화 한 버튼 활성화
				if (records.length != 0){
					panelSearch.down('#btnBatchApply').enable();
					panelSearch.down('#btnClose').enable();
					panelSearch.down('#btnCancel').enable();
					panelResult.down('#btnBatchApply2').enable();
					panelResult.down('#btnClose2').enable();
					panelResult.down('#btnCancel2').enable();
				}
          	}          		
      	}
	});//End of var masterStore = Unilite.createStore('hbs910ukrvMasterStore1', {

	/* 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.human.searchconditon" default="검색조건"/>',		
        defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },		
		items : [{
			title: '<t:message code="system.label.human.basisinfo" default="기본정보"/>', 	
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items : [{
				fieldLabel	: '<t:message code="system.label.human.division" default="사업장"/>',
				id			: 'DIV_CODE',
				name		: 'DIV_CODE', 
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.human.suppyyyymm" default="급여지급년월"/>',
				xtype		: 'uniMonthfield',
				name		: 'PAY_YYYYMM',                    
				id			: 'PAY_YYYYMM',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_YYYYMM', newValue);
					}
				}
			},{
		        fieldLabel	: '<t:message code="system.label.human.supptype" default="지급구분"/>',
		        name		: 'SUPP_TYPE', 	
		        xtype		: 'uniCombobox',
		        comboType	: 'AU',
		        comboCode	: 'H032',
//		        value 		: '1',
		        allowBlank	: false,
			    listeners	: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelResult.setValue('SUPP_TYPE', newValue);
					}
				}
		    },
			Unilite.treePopup('DEPTTREE',{
				fieldLabel		: '<t:message code="system.label.human.department" default="부서"/>',
				valueFieldName	: 'DEPT',
				textFieldName	: 'DEPT_NAME' ,
				valuesName		: 'DEPTS' ,
				DBvalueFieldName: 'TREE_CODE',
				DBtextFieldName	: 'TREE_NAME',
				selectChildren	: true,
				autoPopup		: true,
				validateBlank	: false,
				useLike			: true,
				listeners		: {
	                'onValueFieldChange': function(field, newValue, oldValue  ){
	                    	panelResult.setValue('DEPT',newValue);
	                },
	                'onTextFieldChange':  function( field, newValue, oldValue  ){
	                    	panelResult.setValue('DEPT_NAME',newValue);
	                },
	                'onValuesChange':  function( field, records){
	                    	var tagfield = panelResult.getField('DEPTS') ;
	                    	tagfield.setStoreData(records)
	                }
				}
			}),
		      	Unilite.popup('Employee',{
		      	fieldLabel: '<t:message code="system.label.human.employee" default="사원"/>',
			    valueFieldName	: 'PERSON_NUMB',
			    textFieldName	: 'NAME',
				id				: 'PERSON_NUMB',
			    valueFieldWidth	: 79,
			    autoPopup		: true,
				validateBlank	: false,
				listeners		: {
	                'onValueFieldChange': function(field, newValue, oldValue  ){
							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
	                },
	                'onTextFieldChange':  function( field, newValue, oldValue  ){
							panelResult.setValue('NAME', panelSearch.getValue('NAME'));	
	                },
	                'onValuesChange':  function( field, records){
	                    	var tagfield = panelResult.getField('PERSON_NUMB') ;
	                    	tagfield.setStoreData(records)
	                },
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
							panelResult.setValue('NAME', panelSearch.getValue('NAME'));	
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('PERSON_NUMB', '');
						panelResult.setValue('NAME', '');
						panelSearch.setValue('PERSON_NUMB', '');
                        panelSearch.setValue('NAME', '');
					}
				}
      		}),{
	            fieldLabel	: '<t:message code="system.label.human.paygubun" default="고용형태"/>',
	            name		: 'PAY_GUBUN', 	
	            xtype		: 'uniCombobox', 
	            comboType	: 'AU',
	            comboCode	: 'H011',
			    listeners	: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('PAY_GUBUN', newValue);
		            	var radio2 = panelSearch.down('#RADIO2');
        				var radio3 = panelResult.down('#RADIO3');
			    		if(panelSearch.getValue('PAY_GUBUN') == '2'){
	            			radio2.show();
	            			radio3.show();
			    			radio2.setValue('0');
			    			radio3.setValue('0');
			    		} else {
	            			radio2.hide();
	            			radio3.hide();
			    			radio2.setValue('');
			    			radio3.setValue('');
			    		}
			    	}
	     		}
	        },{
	        	xtype		: 'container',
				layout		: {type : 'hbox'},
				items		:[{
					xtype		: 'radiogroup',
					fieldLabel	: ' ',
					itemId		: 'RADIO2',
					labelWidth	: 90,
					items		: [{
						boxLabel	: '<t:message code="system.label.human.whole" default="전체"/>', 
						width		: 50,
						name		: 'rdoSelect2' , 
						inputValue	: '', 
						checked		: true
					},{
						boxLabel	: '<t:message code="system.label.human.general" default="일반"/>',
						width		: 50, 
						name		: 'rdoSelect2' ,
						inputValue	: '2'
					},{
						boxLabel	: '<t:message code="system.label.human.dailyuse" default="일용"/>', 
						width		: 50, 
						name		: 'rdoSelect2' ,
						inputValue	: '1'					
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.getField('rdoSelect2').setValue(newValue.rdoSelect2);
						}
					}
				}]
			},{
                fieldLabel	: '<t:message code="system.label.human.payprovflag2" default="지급차수"/>',
                name		: 'PAY_PROV_FLAG', 	
                xtype		: 'uniCombobox',
                comboType	: 'AU',
                comboCode	: 'H031',
			    listeners	: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('PAY_PROV_FLAG', newValue);
			    	}
	     		}
            },{
                fieldLabel	: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',
                name		: 'PAY_CODE', 	
                xtype		: 'uniCombobox',
                comboType	: 'AU',
                comboCode	: 'H028',
			    listeners	: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('PAY_CODE', newValue);
			    	}
	     		}
            },{
	        	xtype		: 'container',
	           	layout		: {type: 'uniTable', columns: 2},
				items		:[{
					xtype		: 'uniTextfield',
					fieldLabel	: '<t:message code="system.label.human.remark" default="비고"/>',
	          		name		: 'REMARK', 	
					itemId		: 'REMARK',
					width		: 245,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {						
			    			panelResult.setValue('REMARK', newValue);
						}
					}
				},{
		    		xtype		: 'button',
		    		text		: '<t:message code="system.label.human.allapply1" default="일괄적용"/>',
					itemId		: 'btnBatchApply',
					margin		: '0 0 2 5',
					width		: 80,
		    		handler		: function(records){
		    			Ext.Msg.show({
		    			    title	: '',
		    			    msg		: '<t:message code="system.message.human.message070" default="입력된 내용을 일괄 적용 하시겠습니까?"/>',
		    			    buttons	: Ext.Msg.YESNO,
		    			    icon	: Ext.Msg.QUESTION,
		    			    fn		: function(btn) {
		    			        if (btn === 'yes') {
		    			        	var count = masterGrid.getStore().totalCount;
		    			        	if (Ext.isEmpty(count)) {
		    			        		alert('<t:message code="system.message.human.message072" default="조회된 자료가 존재하지 않습니다."/>');
		    			        		return false;
		    			        	} else {
		    			        		var records = masterStore.data.items;
		    			        		Ext.each(records, function(record, i) {
		    			        			record.set('REMARK', panelSearch.getValue('REMARK'));
		    			        		});
									}
		    			        } else if (btn === 'no') {
		    			            this.close();
		    			        } 
		    			    }
		    			});
		    		}
				}]
			},{
	        	xtype		: 'container',
				layout		: {type	: 'hbox'},
        		tdAttrs		: {width: '100%'},  
	    		margin		: '20 0 0 80',	
				items		:[{
		    		xtype		: 'button',
		    		text		: '<t:message code="system.label.human.deadline" default="마감"/>',
					itemId		: 'btnClose',
		    		width		: 80,
		    		handler		: function(){
						if(confirm('<t:message code="system.message.human.message067" default="마감을 실행시키겠습니까?"/>'))	{
				        	if (masterGrid.selModel.getCount() != 0){
								flag = 1;
								masterGrid.getStore().saveStore();
								masterGrid.reset();
	
				        	} else {
								alert('<t:message code="system.message.human.message071" default="선택된 자료가 없습니다."/>');
				        	}
	    					UniAppManager.app.onQueryButtonDown();			        	
				        } 
		    		}
				},{
		    		xtype		: 'button',
		    		text		: '<t:message code="system.label.human.cancel" default="취소"/>',
					itemId		: 'btnCancel',
		    		width		: 80,
		    		handler		: function(){
						if(confirm('<t:message code="system.message.human.message068" default="마감을 취소하겠습니까?"/>'))	{
				        	if (masterGrid.selModel.getCount() != 0){
								flag = 2;
								masterGrid.getStore().saveStore();
								masterGrid.reset();
				        	} else {
								alert('<t:message code="system.message.human.message071" default="선택된 자료가 없습니다."/>');
				        	}
	    					UniAppManager.app.onQueryButtonDown();
				        } 
		    		}
				}]
			}] 
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 4
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel	: '<t:message code="system.label.human.division" default="사업장"/>',
			name		: 'DIV_CODE', 
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
        	tdAttrs		: {width: 380},  
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.human.suppyyyymm" default="급여지급년월"/>',
			xtype		: 'uniMonthfield',
			name		: 'PAY_YYYYMM',    
			allowBlank	: false,
        	tdAttrs		: {width: 380},  
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAY_YYYYMM', newValue);
				}
			}
		},{
	        fieldLabel	: '<t:message code="system.label.human.supptype" default="지급구분"/>',
	        name		: 'SUPP_TYPE', 	
	        xtype		: 'uniCombobox',
	        comboType	: 'AU',
	        comboCode	: 'H032',
//	        value 		: '1',
	        allowBlank	: false,
	        colspan		: 2,
		    listeners	: {
				change: function(field, newValue, oldValue, eOpts) {      
					panelSearch.setValue('SUPP_TYPE', newValue);
				}
			}
	    },
		Unilite.treePopup('DEPTTREE',{
			fieldLabel		: '<t:message code="system.label.human.department" default="부서"/>',
			valueFieldName	: 'DEPT',
			textFieldName	: 'DEPT_NAME' ,
			valuesName		: 'DEPTS' ,
			DBvalueFieldName: 'TREE_CODE',
			DBtextFieldName	: 'TREE_NAME',
			selectChildren	: true,
			autoPopup		: true,
			validateBlank	: false,
			useLike			: true,
			listeners		: {
                'onValueFieldChange': function(field, newValue, oldValue  ){
                    	panelSearch.setValue('DEPT',newValue);
                },
                'onTextFieldChange':  function( field, newValue, oldValue  ){
                    	panelSearch.setValue('DEPT_NAME',newValue);
                },
                'onValuesChange':  function( field, records){
                    	var tagfield = panelSearch.getField('DEPTS') ;
                    	tagfield.setStoreData(records)
                }
			}
		}),
	      	Unilite.popup('Employee',{
	      	fieldLabel		: '<t:message code="system.label.human.employee" default="사원"/>',
		    valueFieldName	: 'PERSON_NUMB',
		    textFieldName	: 'NAME',
		    valueFieldWidth	: 79,
		    autoPopup		: true,
			validateBlank	: false,
			listeners		: {
                'onValueFieldChange': function(field, newValue, oldValue  ){
						panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
                },
                'onTextFieldChange':  function( field, newValue, oldValue  ){
						panelSearch.setValue('NAME', panelResult.getValue('NAME'));	
                },
                'onValuesChange':  function( field, records){
                    	var tagfield = panelSearch.getField('PERSON_NUMB') ;
                    	tagfield.setStoreData(records)
                },
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
						panelSearch.setValue('NAME', panelResult.getValue('NAME'));	
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('PERSON_NUMB', '');
					panelSearch.setValue('NAME', '');
					panelResult.setValue('PERSON_NUMB', '');
                    panelResult.setValue('NAME', '');
				}
			}
  		}),{
            fieldLabel	: '<t:message code="system.label.human.paygubun" default="고용형태"/>',
            name		: 'PAY_GUBUN', 	
            xtype		: 'uniCombobox', 
            comboType	: 'AU',
            comboCode	: 'H011',
		    listeners	: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('PAY_GUBUN', newValue);
	            	var radio2 = panelSearch.down('#RADIO2');
    				var radio3 = panelResult.down('#RADIO3');
		    		if(panelSearch.getValue('PAY_GUBUN') == '2'){
            			radio2.show();
            			radio3.show();
		    			radio2.setValue('0');
		    			radio3.setValue('0');
		    		} else {
            			radio2.hide();
            			radio3.hide();
		    			radio2.setValue('');
		    			radio3.setValue('');
		    		}
		    	}
     		}
        },{
        	xtype		: 'container',
			layout		: {type	: 'hbox'},
			items		:[{
				xtype		: 'radiogroup',
				fieldLabel	: '',
				itemId		: 'RADIO3',
				labelWidth	: 90,
				align: 'left',
				items		: [{
					boxLabel	: '<t:message code="system.label.human.whole" default="전체"/>', 
					width		: 50,
					name		: 'rdoSelect2' , 
					inputValue	: '', 
					checked		: true
				},{
					boxLabel	: '<t:message code="system.label.human.general" default="일반"/>',
					width		: 50, 
					name		: 'rdoSelect2' ,
					inputValue	: '2'
				},{
					boxLabel	: '<t:message code="system.label.human.dailyuse" default="일용"/>', 
					width		: 50, 
					name		: 'rdoSelect2' ,
					inputValue	: '1'					
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('rdoSelect2').setValue(newValue.rdoSelect2);
					}
				}
			}]
		},{
            fieldLabel	: '<t:message code="system.label.human.payprovflag2" default="지급차수"/>',
            name		: 'PAY_PROV_FLAG', 	
            xtype		: 'uniCombobox',
            comboType	: 'AU',
            comboCode	: 'H031',
		    listeners	: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('PAY_PROV_FLAG', newValue);
		    	}
     		}
        },{
            fieldLabel	: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',
            name		: 'PAY_CODE', 	
            xtype		: 'uniCombobox',
            comboType	: 'AU',
            comboCode	: 'H028',
            colspan		: 3,
		    listeners	: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('PAY_CODE', newValue);
		    	}
     		}
        },{
        	xtype		: 'container',
			layout		: {type : 'hbox'},
			colspan		: 3,
			items		:[{
				xtype		: 'uniTextfield',
				fieldLabel	: '<t:message code="system.label.human.remark" default="비고"/>',
          		name		: 'REMARK', 	
				itemId		: 'REMARK',
				width		: 645,
				
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
		    			panelSearch.setValue('REMARK', newValue);
					}
				}
			},{
	    		xtype		: 'button',
	    		text		: '<t:message code="system.label.human.allapply1" default="일괄적용"/>',
				itemId		: 'btnBatchApply2',
				width		: 100,
				margin		: '0 0 2 10',
				align		: 'left',
	    		handler		: function(records){
	    			Ext.Msg.show({
	    			    title	: '',
	    			    msg		: '<t:message code="system.message.human.message070" default="입력된 내용을 일괄 적용 하시겠습니까?"/>',
	    			    buttons	: Ext.Msg.YESNO,
	    			    icon	: Ext.Msg.QUESTION,
	    			    fn		: function(btn) {
	    			        if (btn === 'yes') {
	    			        	var count = masterGrid.getStore().totalCount;
	    			        	if (Ext.isEmpty(count)) {
	    			        		alert('<t:message code="system.message.human.message072" default="조회된 자료가 존재하지 않습니다."/>');
	    			        		return false;
	    			        	} else {
	    			        		var records = masterStore.data.items;
	    			        		Ext.each(records, function(record, i) {
	    			        			record.set('REMARK', panelSearch.getValue('REMARK'));
	    			        		});
								}
	    			        } else if (btn === 'no') {
	    			            this.close();
	    			        } 
	    			    }
	    			});
	    		}
			}]
		},{
        	xtype		: 'container',
			layout		: {type	: 'uniTable'},
	        tdAttrs		: {width: '100%', align : 'right'},  
			items		:[{
	    		xtype		: 'button',
	    		text		: '<t:message code="system.label.human.deadline" default="마감"/>',
				itemId		: 'btnClose2',
	    		width		: 100,
				align		: 'right',
				margin		: '0 0 2 0',
	    		handler		: function(){
					if(confirm('<t:message code="system.message.human.message067" default="마감을 실행시키겠습니까?"/>'))	{
			        	if (masterGrid.selModel.getCount() != 0){
							flag = 1;
							masterGrid.getStore().saveStore();
							masterGrid.reset();

			        	} else {
							alert('<t:message code="system.message.human.message071" default="선택된 자료가 없습니다."/>');
			        	}
    					UniAppManager.app.onQueryButtonDown();			        	
			        } 
	    		}
			},{
	    		xtype		: 'button',
	    		text		: '<t:message code="system.label.human.cancel" default="취소"/>',
				itemId		: 'btnCancel2',
	    		width		: 100,
				align		: 'right',
				margin		: '0 0 2 0',
	    		handler		: function(){
					if(confirm('<t:message code="system.message.human.message068" default="마감을 취소하겠습니까?"/>'))	{
			        	if (masterGrid.selModel.getCount() != 0){
							flag = 2;
							masterGrid.getStore().saveStore();
							masterGrid.reset();
			        	} else {
							alert('<t:message code="system.message.human.message071" default="선택된 자료가 없습니다."/>');
			        	}
    					UniAppManager.app.onQueryButtonDown();
			        } 
	    		}
			}]
		}]
	});
	
	var masterGrid = Unilite.createGrid('hbs910ukrvGrid1', {
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			useMultipleSorting	: true,			 	
			useLiveSearch		: false,			
			onLoadSelectFirst	: false,		//체크박스모델은 false로 변경		
			dblClickToEdit		: false,			
			useGroupSummary		: false,			
			useContextMenu		: false,			
			useRowNumberer		: true,			
			expandLastColumn	: false,				
			useRowContext		: false,	// rink 항목이 있을경우만 true		
			filter: {					
				useFilter	: false,			
				autoCreate	: false			
			}					
        },
        store	: masterStore,
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick : false,
    		listeners: {  
    			select: function(grid, selectRecord, index, rowIndex, eOpts ){
    				//체크박스 체크되면 개인별마감 컬럼 값을 '미마감' -> '마감'으로 변경
    				if (selectRecord.get('PERSONAL_CLOSE') == 'N') { 
    					selectRecord.set('PERSONAL_CLOSE', 'Y');
    				} else if (selectRecord.get('PERSONAL_CLOSE') == 'Y') {
    					selectRecord.set('PERSONAL_CLOSE', 'N');
    				}
//    				masterStore.commitChanges();  
					UniAppManager.setToolbarButtons('save', false);	
    				
    			},
	    		deselect:  function(grid, selectRecord, index, eOpts ){
    				if (selectRecord.get('PERSONAL_CLOSE') == 'N') { 
    					selectRecord.set('PERSONAL_CLOSE', 'Y');
    				} else if (selectRecord.get('PERSONAL_CLOSE') == 'Y') {
    					selectRecord.set('PERSONAL_CLOSE', 'N');
    				}
//    				masterStore.commitChanges();    				
    				UniAppManager.setToolbarButtons('save', false);		

	    		}
    		}
		}), 
        columns	: columns,
		listeners: {
	        beforeedit  : function( editor, e, eOpts ) {
	        	if(UniUtils.indexOf(e.field, ['REMARK'])){ 
					return true;
  				} else {
  					return false;
  				}
			},
			beforeselect: function(rowSelection, record, index, eOpts) {
                if(record.get('COMP_CLOSE') == 'Y'){
                      alert('월마감을 먼저 취소해 주시기 바랍니다');
                      return false;
                }
            }
		}
	});//End of var masterGrid = Unilite.createGr100id('hbs910ukrvGrid1', {   

	Unilite.Main({
		id			: 'hbs910ukrvApp',
	 	border		: false,
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
		 
		fnInitBinding : function(params) {
			//초기화면 버튼 비활성화
			panelSearch.down('#btnBatchApply').disable();
			panelSearch.down('#btnClose').disable();
			panelSearch.down('#btnCancel').disable();
			panelResult.down('#btnBatchApply2').disable();
			panelResult.down('#btnClose2').disable();
			panelResult.down('#btnCancel2').disable();

			//고용형태에 따른 라디오 버튼 초기화 시 숨김 처리
        	var radio2 = panelSearch.down('#RADIO2');
        	var radio3 = panelResult.down('#RADIO3');
			radio2.hide();
			radio3.hide();
			radio2.setValue('');
			radio3.setValue('');

			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.setValue('SUPP_TYPE', '1');
			panelResult.setValue('SUPP_TYPE', '1');
			panelSearch.setValue('PAY_YYYYMM', UniDate.get('today'));
			panelResult.setValue('PAY_YYYYMM', UniDate.get('today'));
			
			UniAppManager.setToolbarButtons('reset', false);
			UniAppManager.setToolbarButtons('save', false);
			
			//초기화 시 사업장로 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');

			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			masterStore.clearData();
			
			this.fnInitBinding();
		},
		
		onQueryButtonDown : function() { //조회버튼	
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		}, 
		
		onSaveDataButtonDown : function() {
			if (masterGrid.getStore().isDirty()) {
				flag = 0;
				masterGrid.getStore().saveStore();

			}
		},
        //링크로 넘어오는 params 받는 부분 
        processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 'hpa330ukr') {
				panelSearch.setValue('PAY_YYYYMM',	params.PAY_YYYYMM);
				panelResult.setValue('PAY_YYYYMM',	params.PAY_YYYYMM);
				panelSearch.setValue('NAME',		params.NAME);
				panelResult.setValue('NAME',		params.NAME);
				panelSearch.setValue('PERSON_NUMB',	params.PERSON_NUMB);
				panelResult.setValue('PERSON_NUMB',	params.PERSON_NUMB);
				panelSearch.setValue('SUPP_TYPE',	params.SUPP_TYPE);
				panelResult.setValue('SUPP_TYPE',	params.SUPP_TYPE);
				
				
				masterGrid.getStore().loadStoreRecords();
				
			} else if(params.PGM_ID == 'agb120skr' || params.PGM_ID == 'agb125skr') {
			
				
			} else if(params.PGM_ID == 'agb140skr') {
			
				
			} else if(params.PGM_ID == 'agc100skr') {
			
			
			} else if(params.PGM_ID == 'agc110skr') {
			
			
			} else if(params.PGM_ID == 'agb150skr'){
			
			}	
		}
	});//End of Unilite.Main( {
	

	function createModelField(colData) {
		var fields = [
			{name : 'COMP_CODE'		, text : 'COMP_CODE'	, type : 'string'	},
//			{name : 'CHK'			, text : '마감선택'			, type : 'boolean'	},
			{name : 'COMP_CLOSE'						, text : '<t:message code="system.label.human.monthdeadline" default="월마감"/>'			, type : 'string'	, comboType : 'AU', comboCode : 'H153' },
			{name : 'PERSONAL_CLOSE'				, text : '<t:message code="system.label.human.personaldeadline" default="개인별마감"/>'		, type : 'string'	, comboType : 'AU', comboCode : 'H153' },
			{name : 'DEPT_CODE'						, text : '<t:message code="system.label.human.deptcode" default="부서코드"/>'			, type : 'string'	},
			{name : 'DEPT_NAME'						, text : '<t:message code="system.label.human.department" default="부서"/>'			, type : 'string'	},
			{name : 'POST_CODE'						, text : '<t:message code="system.label.human.postcode" default="직위"/>'			, type : 'string'	, comboType : 'AU', comboCode : 'H005' },
			{name : 'PERSON_NUMB'					, text : '<t:message code="system.label.human.personnumb" default="사번"/>'			, type : 'string'	},
			{name : 'NAME'									, text : '<t:message code="system.label.human.name" default="성명"/>'			, type : 'string'	},
			{name : 'SUPP_TYPE'							, text : '<t:message code="system.label.human.supptype" default="지급구분"/>'			, type : 'string'	},
			{name : 'JOIN_DATE'							, text : '<t:message code="system.label.human.joindate" default="입사일"/>'			, type : 'uniDate'	},
			{name : 'REMARK'								, text : '<t:message code="system.label.human.remark" default="비고"/>'			, type : 'string'	},
			{name : 'SUPP_TOTAL_I'					, text : '<t:message code="system.label.human.payamounti" default="지급총액"/>'			, type : 'uniPrice'	},
			{name : 'REAL_AMOUNT_I'				, text : '<t:message code="system.label.human.realamounti" default="실지급액"/>'			, type : 'uniPrice'	},
			{name : 'PAY_YYYYMM'					, text : '<t:message code="system.label.human.suppyyyymm1" default="지급년월"/>'			, type : 'string'	},
			{name : 'DED_TOTAL_I'						, text : '<t:message code="system.label.human.dedtotali" default="공제총액"/>'			, type : 'uniPrice'	} 
		];

			Ext.each(colData, function(item, index) {
				if (index == 0)
					return '';
				
				if (index < 30)  dataIndex = 'WAGES_PAY' + item.WAGES_CODE;
				else dataIndex = 'WAGES_DED' + item.WAGES_CODE;
				
				fields.push({name : dataIndex, text : item.WAGES_NAME, type : 'uniPrice'
			});
		});
		console.log(fields);
		return fields;
	}

	function createGridColumn(colData) {
		var columns = [ 
			{dataIndex : 'COMP_CODE'		, width : 60	, hidden	: true }, 
            {dataIndex : 'PAY_YYYYMM'		, width : 86	, hidden	: true }, 
            {dataIndex : 'SUPP_TYPE'		, width : 50	, hidden	: true }, 
//            {dataIndex : 'CHK'				, width : 70	, xtype : 'checkcolumn' }, 
            {dataIndex : 'COMP_CLOSE'		, width : 80	, align		: 'center'}, 
            {dataIndex : 'PERSONAL_CLOSE'	, width : 80	, align		: 'center'},
			{dataIndex : 'DEPT_CODE'		, width : 100 }, 
			{dataIndex : 'DEPT_NAME'		, width : 180 }, 
			{dataIndex : 'POST_CODE'		, width : 100 }, 
			{dataIndex : 'PERSON_NUMB'		, width : 100 }, 
			{dataIndex : 'NAME'				, width : 120 }, 
			{dataIndex : 'JOIN_DATE'		, width : 100 }, 
			{dataIndex : 'REMARK'			, flex	: 1 }, 
			{dataIndex : 'SUPP_TOTAL_I'		, width : 86	, hidden : true  }, 
			{dataIndex : 'DED_TOTAL_I'		, width : 86	, hidden : true  }, 
			{dataIndex : 'REAL_AMOUNT_I'	, width : 86	, hidden : true  }
		];

		Ext.each(colData, function(item, index) {
			if (index == 0)
				return '';
			
			var dataIndex='';
			if (index < 30)  dataIndex = 'WAGES_PAY' + item.WAGES_CODE;
			else dataIndex = 'WAGES_DED' + item.WAGES_CODE;
			
			if (item.WAGES_NAME == null || item.WAGES_NAME == '') {
				columns.push({dataIndex : dataIndex, width : 100, summaryType : 'sum', hidden : true });
			} else {
				columns.push({dataIndex : dataIndex, width : 100, summaryType : 'sum', hidden : true  });
			}
		});
		return columns;
	}
};
</script>
