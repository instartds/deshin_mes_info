<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="had800skr"  >
		<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 -->
		<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 -->
		<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
		<t:ExtComboStore comboType="AU" comboCode="A097" /> <!-- 지급구분 -->
		<t:ExtComboStore comboType="AU" comboCode="H024" /> <!-- 사원구분 -->
		<t:ExtComboStore comboType="AU" comboCode="H181" /> <!-- 사원그룹 -->
		<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
</t:appConfig>
<script type="text/javascript" >


function appMain() {
	
	/**
	 * Model 정의 
	 * @type 
	 */   			 
	Unilite.defineModel('had800skrModel', {
	    fields: [	
	    	{name: 'DIV_CODE'		, text: '사업장코드'   , type: 'string', comboType: "BOR120"},
	    	{name: 'DIV_NAME'		, text: '사업장'      , type: 'string'},
		    {name: 'DEPT_CODE'		, text: '부서코드'		, type: 'string'},
		    {name: 'DEPT_NAME'		, text: '부서'		, type: 'string'},
		    {name: 'POST_CODE'		, text: '직위'		, type: 'string'/*, comboType: "AU", comboCode: "H005"*/},
		    {name: 'PERSON_NUMB'	, text: '사번'		, type: 'string'},
		    {name: 'NAME'			, text: '성명'		, type: 'string'},
		    {name: 'REPRE_NUM'		, text: '주민등록번호'	, type: 'string'},
		    {name: 'PAY_YYYYMM'		, text: '귀속년월'		, type: 'string'},
		    {name: 'PAYGUBN'		, text: '지급구분'		, type: 'string'},
		    {name: 'SUPPDATE'		, text: '지급일자'		, type: 'uniDate'},
		    {name: 'SUPPTOTAL'		, text: '지급총액'		, type: 'uniPrice'},
		    {name: 'TAXAMOUNT'		, text: '과세분'		, type: 'uniPrice'},
		    {name: 'NONTAXAMOUNT'	, text: '제출비과세'		, type: 'uniPrice'},
		    {name: 'NONTAXAMOUNT2'	, text: '미제출비과세'		, type: 'uniPrice'},
		    {name: 'ANU'			, text: '국민연금'		, type: 'uniPrice'},
		    {name: 'MED'			, text: '건강보험'		, type: 'uniPrice'},
		    {name: 'HIR'			, text: '고용보험'		, type: 'uniPrice'},
		    {name: 'BUSISHAREI'		, text: '사회보험부담금'	, type: 'uniPrice'},
		    {name: 'SUDK'			, text: '소득세'      , type: 'uniPrice'},
		    {name: 'JUMIN'			, text: '주민세'      , type: 'uniPrice'},
		    {name: 'PAYCODE'		, text: '급여지급방식'  , type: 'string'},
		    {name: 'TAXCODE'		, text: '세액구분'		, type: 'string'},
		    {name: 'GUBUN'		, text: 'GUBUN'		, type: 'string'}
	    ]	    
	});		//End of Unilite.defineModel
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */
	var MasterStore = Unilite.createStore('had800skrMasterStore',{
			model: 'had800skrModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,		// 수정 모드 사용 
            	deletable: false,		// 삭제 가능 여부 
	            useNavi: false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
               		read: 'had800skrService.selectList'
                }
            },
			loadStoreRecords: function(){
				var param= Ext.getCmp('searchForm').getValues();
				var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
				var deptCode = UserInfo.deptCode;	//부서코드
				if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
					param.DEPT_CODE = deptCode;
				}
				console.log( param );
				this.load({
					params: param
				});
			},
			_onStoreLoad: function ( store, records, successful, eOpts ) {
		    	if(this.uniOpt.isMaster) {
		    		var recLength = 0;
		    		Ext.each(records, function(record, idx){
		    			if(record.get('GUBUN') == '1'){
		    				recLength++;
		    			}
		    		});
			    	if (records) {
				    	UniAppManager.setToolbarButtons('save', false);
						var msg = recLength + Msg.sMB001; //'건이 조회되었습니다.';
				    	//console.log(msg, st);
				    	UniAppManager.updateStatus(msg, true);	
			    	}
		    	}
			}
	});		// End of var MasterStore 
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',
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
		items: [{
			title: '기본정보',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
				fieldLabel: '기준기간',
				xtype: 'uniMonthRangefield',
				startFieldName: 'PAY_YYYYMM_FR',
				endFieldName: 'PAY_YYYYMM_TO',
				startDate: UniHuman.getTaxReturnStartDate(),
				endDate: UniHuman.getTaxReturnEndDate(),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('PAY_YYYYMM_FR',newValue);			
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('PAY_YYYYMM_TO',newValue);			    		
			    	}
			    }
			},{
				xtype: 'radiogroup',
				fieldLabel: '조회기간 구분',
				allowBlank:false,
				hideLabel:false,
				holdable: 'hold',
				items: [{
					boxLabel: '귀속',
					width: 70,
					name: 'DATE_GUBUN',
					inputValue: '1',
					checked: true
				},{
					boxLabel : '지급',
					width: 70,
					name: 'DATE_GUBUN',
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {					
						panelResult.getField('DATE_GUBUN').setValue(newValue.DATE_GUBUN);
					}
				}
			},{ 
				fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',				
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '퇴사자포함',
	            xtype: 'radiogroup',
	            columns: [60,60],
	            items: [{
					boxLabel: '한다',
					name: 'RDO_USE',
					inputValue: 'Y',
					checked: true 					
				},{
					boxLabel: '안한다',
					name: 'RDO_USE',
					inputValue: 'N'
				}],
				listeners: {
					change : function(rb, newValue, oldValue, options) {
						panelResult.getField('RDO_USE').setValue(newValue.RDO_USE);
					}
				}
	        },
			Unilite.treePopup('DEPTTREE',{
				fieldLabel: '부서',
				valueFieldName:'DEPT',
				textFieldName:'DEPT_NAME' ,
				valuesName:'DEPTS' ,
				DBvalueFieldName:'TREE_CODE',
				DBtextFieldName:'TREE_NAME',
				selectChildren:true,
				textFieldWidth:89,
				validateBlank:true,
				width:300,
				autoPopup:true,
				useLike:true,
				listeners: {
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
			}),{
					fieldLabel: '지급구분',
					name: 'PAU_SUPP_TYPE', 
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'H032',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('PAU_SUPP_TYPE', newValue);
						}
					}
				},{
					fieldLabel: '지급차수',
					name: 'PAY_PROV_FLAG', 
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'H031',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('PAY_PROV_FLAG', newValue);
						}
					}
				},{
					fieldLabel: '급여지급방식',
					name: 'PAY_CODE', 
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'H028',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('PAY_CODE', newValue);
						}
					}
				},			
			     	Unilite.popup('Employee',{ 
					validateBlank: false,
					listeners: {
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
						},
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('PERSON_NUMB', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('NAME', newValue);				
						}
					}
				}),{
		        	fieldLabel: '합계표기',
		        	name: 'CHKCNT',
		        	checked: true,
		//			value:'Y',
					xtype: 'checkbox',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('CHKCNT', newValue);
						}
					}
				}
			]
		},{
			title: '추가정보',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
				fieldLabel: '퇴사일자',
				xtype: 'uniDateRangefield',
				startFieldName: 'RETR_DATE_FR',
				endFieldName: 'RETR_DATE_TO',
//				startDate: UniDate.get('startOfMonth'),
//				endDate: UniDate.get('today'),
//				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('RETR_DATE_FR',newValue);			
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('RETR_DATE_TO',newValue);			    		
			    	}
			    }
			},{
				fieldLabel: '사원구분',
				name: 'EMPLOY_TYPE', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H024'
			},{
				fieldLabel: '사원그룹',
				name: 'EMPLOY_GROUP', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H181'
			}
		    
		    ]}
		],		
	    setAllFieldsReadOnly: function(b) {
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
				}
	  		}
			return r;
  		}
	});
	
    var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
    	items: [{
			fieldLabel: '기준기간',
			xtype: 'uniMonthRangefield',
			startFieldName: 'PAY_YYYYMM_FR',
			endFieldName: 'PAY_YYYYMM_TO',
			startDate: UniHuman.getTaxReturnStartDate(),
			endDate: UniHuman.getTaxReturnEndDate(),
			allowBlank: false,
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('PAY_YYYYMM_FR',newValue);			
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('PAY_YYYYMM_TO',newValue);			    		
		    	}
		    }
		},{
			xtype: 'radiogroup',
			fieldLabel: '조회일자구분',
			hideLabel:true,
			holdable: 'hold',
			width:100,
			items: [{
				boxLabel: '귀속',
				width: 70,
				name: 'DATE_GUBUN',
				inputValue: '1',
				checked: true
			},{
				boxLabel : '지급',
				width: 70,
				name: 'DATE_GUBUN',
				inputValue: '2'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {					
					panelSearch.getField('DATE_GUBUN').setValue(newValue.DATE_GUBUN);
				}
			}
		},{ 
			fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {	
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '퇴사자포함',
            xtype: 'radiogroup',
            columns: [60,60],
            items: [{
				boxLabel: '한다',
				name: 'RDO_USE',
				inputValue: 'Y',
				checked: true 					
			},{
				boxLabel: '안한다',
				name: 'RDO_USE',
				inputValue: 'N'
			}],
			listeners: {
				change : function(rb, newValue, oldValue, options) {
					panelSearch.getField('RDO_USE').setValue(newValue.RDO_USE);
				}
			}
        },
        Unilite.treePopup('DEPTTREE',{
			fieldLabel: '부서',
			valueFieldName:'DEPT',
			textFieldName:'DEPT_NAME' ,
			valuesName:'DEPTS' ,
			DBvalueFieldName:'TREE_CODE',
			DBtextFieldName:'TREE_NAME',
			selectChildren:true,
			textFieldWidth:89,
			validateBlank:true,
			width:300,
			colspan:2,
			autoPopup:true,
			useLike:true,
			listeners: {
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
		}),{
			fieldLabel: '지급구분',
			name: 'PAU_SUPP_TYPE', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H032',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAU_SUPP_TYPE', newValue);
				}
			}
		},{
			fieldLabel: '지급차수',
			name: 'PAY_PROV_FLAG', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H031',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAY_PROV_FLAG', newValue);
				}
			}
		},{
			fieldLabel: '급여지급방식',
			name: 'PAY_CODE', 
			colspan:2,
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H028',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAY_CODE', newValue);
				}
			}
		},			
	     	Unilite.popup('Employee',{ 
			
			validateBlank: false,
			listeners: {
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
				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PERSON_NUMB', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('NAME', newValue);				
				}
			}
		}),{
        	fieldLabel: '합계표기',
        	name: 'CHKCNT',
        	checked: true,
//			value:'Y',
			xtype: 'checkbox',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('CHKCNT', newValue);
				}
			}
		}]
    });
    
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('had800skrGrid', {
    	region: 'center' ,
        layout : 'fit',
        store : MasterStore, 
//        sortableColumns: false,
        uniOpt:{	
        	expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	          	if(record.get('GUBUN') == '6'){
					cls = 'x-change-cell_dark';
				}
				else if(record.get('GUBUN') == '2' || record.get('GUBUN') == '3' || record.get('GUBUN') == '4' || record.get('GUBUN') == '5'){	//소계
					cls = 'x-change-cell_light';
				}
				return cls;
	        }
	    },
//    	features: [
//    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
//    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
//    	],
        columns:  [
			{dataIndex: 'DIV_CODE'		, width: 110, hidden: true},
			{dataIndex: 'DIV_NAME'		, width: 110},
			{dataIndex: 'DEPT_CODE'		, width: 80, hidden: true},
			{dataIndex: 'DEPT_NAME'		, width: 100},
			{dataIndex: 'POST_CODE'		, width: 80},
			{dataIndex: 'PERSON_NUMB'	, width: 70},
			{dataIndex: 'NAME'			, width: 80},
			{dataIndex: 'REPRE_NUM'		, width: 110},
			{dataIndex: 'PAY_YYYYMM'    , width: 73},			
			{dataIndex: 'PAYGUBN'		, width: 80},
			{dataIndex: 'SUPPDATE'       , width: 73},
			{dataIndex: 'SUPPTOTAL'		, width: 90},
			{dataIndex: 'TAXAMOUNT'		, width: 90},
			{dataIndex: 'NONTAXAMOUNT'	, width: 90},
			{dataIndex: 'NONTAXAMOUNT2'	, width: 110},
			{dataIndex: 'ANU'			, width: 90},
			{dataIndex: 'MED'			, width: 90},
			{dataIndex: 'HIR'			, width: 90},
			{dataIndex: 'BUSISHAREI'	, width: 110},
			{dataIndex: 'SUDK'			, width: 90},
			{dataIndex: 'JUMIN'			, width: 90},
			{dataIndex: 'PAYCODE'		, width: 86},
			{dataIndex: 'TAXCODE'		, minWidth: 70, flex: 1}
		]
    });		//End of var masterGrid 
    
    /**
	 * Main 정의(Main 정의)
	 * @type 
	 */
    Unilite.Main ({
		borderItems: [{
         	region:'center',
         	layout: 'border',
         	border: false,
         	items:[
           		masterGrid, panelResult
         	]	
      	},
      	panelSearch     
      	],
		id: 'had800skrApp',
		fnInitBinding: function(params) {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('PAY_YYYYMM_FR');
			
			if(!Ext.isEmpty(params && params.PGM_ID)){
                this.processParams(params);
			}
		},
		//링크로 넘어오는 params 받는 부분 
        processParams: function(params) {
            this.uniOpt.appParams = params;
            if(params.PGM_ID == 'hpe100ukr') {
            	panelSearch.setValue('DIV_CODE'			, params.DIV_CODE);
            	panelSearch.setValue('PAY_YYYYMM_FR'	, params.PAY_YYYYMM_FR);
            	panelSearch.setValue('PAY_YYYYMM_TO'	, params.PAY_YYYYMM_TO);
            	setTimeout(function(){
            		panelSearch.setValue('DATE_GUBUN'		, params.DATE_GUBUN);
                	panelResult.setValue('DATE_GUBUN'		, params.DATE_GUBUN);
            	}, 500);
            	
            	panelResult.setValue('DIV_CODE'			, params.DIV_CODE);
            	panelResult.setValue('PAY_YYYYMM_FR'	, params.PAY_YYYYMM_FR);
            	panelResult.setValue('PAY_YYYYMM_TO'	, params.PAY_YYYYMM_TO);
            	setTimeout(function(){UniAppManager.app.onQueryButtonDown();}, 1000);
            }
        },
		onQueryButtonDown: function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
//			if(panelSearch.setAllFieldsReadOnly(true) == false){
//				return false;
//			}
			masterGrid.getStore().loadStoreRecords();			
//			var viewNormal = masterGrid.getView();
//		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			this.fnInitBinding();			
		}
	});
};
</script>
