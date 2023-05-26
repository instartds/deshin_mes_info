<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="equ210skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 -->
   <t:ExtComboStore comboType="AU" comboCode="I800" /> <!-- 장비구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {

	var gsSiteGubun = '${gsSiteGubun}';
	/**
	 *   Model 정의
	 * @type
	 */



	Unilite.defineModel('equ210skrvModel', {
	    fields: [
	    	{name: 'COMP_CODE'		    , text: '법인코드'				, type: 'string'},
			{name: 'DIV_CODE'		    , text: '사업장코드'				, type: 'string'},
			{name: 'EQU_CODE_TYPE'		, text: '장비구분'				, type: 'string',comboType:'AU', comboCode:'I800' },
			{name: 'EQU_CODE'		    , text: '장비(금형)번호'				, type: 'string', allowBlank:false},
			{name: 'EQU_NAME'		    , text: '장비(금형)명'				, type: 'string'},
			{name: 'EQU_SPEC'		    , text: '규격'				, type: 'string'},
			{name: 'MODEL_CODE'		    , text: '대표모델'				, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '제작처'				, type: 'string'},
			{name: 'CUSTOM_NAME'        , text: '제작처명'               , type: 'string'},
			{name: 'PRODT_DATE'		    , text: '제작일'				    , type: 'uniDate'},
			{name: 'PRODT_Q'	   		,text: '제작수량'		,type: 'uniQty'},
			{name: 'PRODT_O'		, text: '제작금액'			, type: 'uniUnitPrice'},
			{name: 'REP_O'		, text: '수리금액'			, type: 'uniUnitPrice'},
			{name: 'ASSETS_NO'		, text: '자산번호'				, type: 'string'},
			{name: 'SN_NO'		, text: '시리얼번호'				, type: 'string'},
			{name: 'EQU_GRADE'		, text: '장비상태'				, type: 'string',	comboType:'AU',comboCode:'I801' },
			{name: 'WEIGHT'		, text: '장비중량'				, type: 'uniQty'},
			{name: 'EQU_PRSN'		, text: '담당자'				, type: 'string'},
			{name: 'EQU_TYPE'		, text: '금형종류'				, type: 'string',comboType:'AU',comboCode:'I802'},
			{name: 'MTRL_TYPE'		, text: '금형재질'				, type: 'string',comboType:'AU',comboCode:'I803'},
			{name: 'MTRL_TEXT'		, text: '재질_비고'				, type: 'string'},
			{name: 'BUY_COMP'		, text: '매입처'				, type: 'string'},
			{name: 'BUY_DATE'		    , text: 'BUY_DATE'				    , type: 'uniDate'},
			{name: 'BUY_AMT'		, text: '매입액'			, type: 'uniUnitPrice'},
			{name: 'SELL_DATE'		    , text: '매각일'				    , type: 'uniDate'},
			{name: 'SELL_AMT'		    , text: '매각액'				    , type: 'uniUnitPrice'},
			{name: 'ABOL_DATE'		    , text: '폐기일'				    , type: 'uniDate'},
			{name: 'ABOL_AMT'		    , text: '폐기액'				    , type: 'uniUnitPrice'},
			{name: 'CAPA'		    , text: '한도수량'				    , type: 'uniUnitPrice'},
			{name: 'WORK_Q'	   		,text: '사용수량'		,type: 'uniQty'},
			{name: 'CAVIT_BASE_Q'	   		,text: '캐비티수량'		,type: 'uniQty'},
			{name: 'TRANS_DATE'	   		,text: '이동날자'		,type: 'uniDate'},
			{name: 'FROM_DIV_CODE'	   		,text: '이관사업장'		,type: 'string'},
			{name: 'USE_CUSTOM_CODE'	   		,text: '보관처'		,type: 'string'},
			{name: 'USE_CUSTOM_NAME'         ,text: '보관처명'        ,type: 'string'},
			{name: 'REMARK'	   		,text: '비고'		,type: 'string'},
			{name: 'INSERT_DB_USER'	   		,text: '입력자'		,type: 'string'},
			{name: 'INSERT_DB_TIME'	   		,text: '입력일자'		,type: 'string'},
			{name: 'UPDATE_DB_USER'	   		,text: '수정자'		,type: 'string'},
			{name: 'UPDATE_DB_TIME'	   		,text: '수정일자'		,type: 'string'},
			{name: 'TEMPC_01'	   		,text: '여분필드01'		,type: 'string'},
			{name: 'TEMPC_02'	   		,text: '여분필드02'		,type: 'string'},
			{name: 'TEMPC_03'	   		,text: '여분필드03'		,type: 'string'},
			{name: 'TEMPN_01'	   		,text: '여분필드01'		,type: 'uniUnitPrice'},
			{name: 'TEMPN_02'	   		,text: '여분필드02'		,type: 'uniUnitPrice'},
			{name: 'TEMPN_03'	   		,text: '여분필드03'		,type: 'uniUnitPrice'}


		]
	});		// end of Unilite.defineModel('equ210skrvModel', {

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('equ210skrvMasterStore1',{
			model: 'equ210skrvModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable:false,			// 삭제 가능 여부
	            useNavi : false			// prev | newxt 버튼 사용
	            	//비고(*) 사용않함
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	   read: 'equ210skrvService.selectList'
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params : param
				});
			}

	});

	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
    var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
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
	        items:[{
		        fieldLabel: '제작년월',
		        xtype: 'uniDateRangefield',
				startFieldName: 'FROM_DATE',
				endFieldName: 'TO_DATE',
				startDate: UniDate.get('aMonthAgo'),
				endDate: UniDate.get('today'),

				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FROM_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_DATE',newValue);
			    	}
			    }
			},
			Unilite.popup('CUST', {
				fieldLabel: '제작처',
				valueFieldName: 'CUSTOM_CODE',
		   	 	textFieldName: 'CUSTOM_NAME',
		   	 	validateBlank: false,
				listeners: {
					onValueFieldChange: function( elm, newValue, oldValue ) {
						panelResult.setValue('CUSTOM_CODE', newValue);
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('CUSTOM_NAME', '');
							panelSearch.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function( elm, newValue, oldValue ) {
						panelResult.setValue('CUSTOM_NAME', newValue);
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('CUSTOM_CODE', '');
							panelSearch.setValue('CUSTOM_CODE', '');
						}
					}
				}
			}),
			{
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				allowBlank:false,
				xtype: 'uniCombobox' ,
				comboType: 'BOR120',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
		    },{
				fieldLabel: '장비구분',
				name: 'EQU_CODE_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'I800',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('EQU_CODE_TYPE', newValue);
					}
				}
		    },{
		        fieldLabel: '장비상태',
		        name:'EQU_GRADE',
		        xtype: 'uniCombobox',
		        comboType:'AU',
		        comboCode:'I801',
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('EQU_GRADE', newValue);
					}
				}
	        }, {
	        	fieldLabel: '장비(금형)번호',
				xtype: 'uniTextfield',
				name:'EQU_CODE',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('EQU_CODE', newValue);
					}
				}
		    }]
		 }],
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
					} else {
					//	this.mask();
	   				}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
		        fieldLabel: '제작년월',
		        xtype: 'uniDateRangefield',
				startFieldName: 'FROM_DATE',
				endFieldName: 'TO_DATE',
				startDate: UniDate.get('aMonthAgo'),
				endDate: UniDate.get('today'),

				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('FROM_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('TO_DATE',newValue);
			    	}
			    }
			},{
	        	fieldLabel: '',
				xtype: 'uniTextfield',
				hidden:true

		    },
		    Unilite.popup('CUST', {
				fieldLabel: '제작처',
				valueFieldName: 'CUSTOM_CODE',
		   	 	textFieldName: 'CUSTOM_NAME',
		   	 	validateBlank: false,
		   	 	colspan:2,
				listeners: {
					onValueFieldChange: function( elm, newValue, oldValue ) {
						panelSearch.setValue('CUSTOM_CODE', newValue);
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('CUSTOM_NAME', '');
							panelSearch.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function( elm, newValue, oldValue ) {
						panelSearch.setValue('CUSTOM_NAME', newValue);
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('CUSTOM_CODE', '');
							panelSearch.setValue('CUSTOM_CODE', '');
						}
					}
				}
			}),

		    {
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				allowBlank:false,
				xtype: 'uniCombobox' ,
				comboType: 'BOR120',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			 },{
				fieldLabel: '장비구분',
				name: 'EQU_CODE_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'I800',
				colspan:2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('EQU_CODE_TYPE', newValue);
					}
				}
		    },{
		        fieldLabel: '장비상태',
		        name:'EQU_GRADE',
		        xtype: 'uniCombobox',
		        comboType:'AU',
		        comboCode:'I801',
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('EQU_GRADE', newValue);
					}
				}
	        },{
	        	fieldLabel: '장비(금형)번호',
				xtype: 'uniTextfield',
				name:'EQU_CODE',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('EQU_CODE', newValue);
					}
				}
		    },{
		    	xtype:'button',
		    	text:'라벨출력',
		    	itemId :'labelBtn',
		    	width:150,
		    	margin: '0 0 0 100',
		    	hidden:true,
		    	handler: function(){
                	var selectedRecords = masterGrid.getSelectedRecords();
                	if(Ext.isEmpty(selectedRecords)){
						alert('출력할 데이터를 선택하여 주십시오.');
						return;
					}

					var equList;
					Ext.each(selectedRecords, function(record, idx) {
						if(idx ==0) {
							equList= record.get("EQU_CODE") + '@@' + record.get("EQU_CODE_TYPE");
						} else {
							equList= equList	+ ',' + record.get("EQU_CODE") + '@@' + record.get("EQU_CODE_TYPE");
						}

					});

					var param = panelResult.getValues();

					param["EQU_LIST"] = equList;
		            param["USER_LANG"] = UserInfo.userLang;
		            param["PGM_ID"]= PGM_ID;
		            param["SITE_GUBUN"] = gsSiteGubun;
		            param["DIV_CODE"] = panelResult.getValue('DIV_CODE');
//		            param["MAIN_CODE"] = 'P010';
//		            param["sTxtValue2_fileTitle"]='';

		        	win = Ext.create('widget.ClipReport', {
		                url: CPATH+'/equip/equ210clskrv.do',
		                prgID: 'equ210skrv',
		                extParam: param
		            });

		            win.center();
		            win.show();

		    	}
		    }

		    ]
    });

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */

    var masterGrid = Unilite.createGrid('equ210skrvGrid1', {
    	// for tab
        layout: 'fit',
        region: 'center',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			onLoadSelectFirst:false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },

        features: [{
        	id: 'masterGridSubTotal',
        	ftype: 'uniGroupingsummary',
        	showSummaryRow: false
        },
    	    {id: 'masterGridTotal',
    	    ftype: 'uniSummary',
    	    showSummaryRow: false}
    	],
    	store: directMasterStore1,
		selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true}),
        columns:  [
        	{dataIndex: 'COMP_CODE' , width: 120 ,hidden:true},
			{dataIndex: 'DIV_CODE' , width: 120  ,hidden:true},
			{dataIndex: 'EQU_CODE_TYPE' , width: 80},
			{dataIndex: 'EQU_CODE' , width: 120},
			{dataIndex: 'EQU_NAME' , width: 120},
			{dataIndex: 'EQU_SPEC' , width: 120},
			{dataIndex: 'MODEL_CODE' , width: 120},
			{dataIndex: 'CUSTOM_CODE' , width: 120},
			{dataIndex: 'CUSTOM_NAME' , width: 120},
			{dataIndex: 'PRODT_DATE' , width: 120},
			{dataIndex: 'PRODT_Q' , width: 120},
			{dataIndex: 'PRODT_O' , width: 120},
			{dataIndex: 'REP_O' , width: 120},
			{dataIndex: 'ASSETS_NO' , width: 120},
			{dataIndex: 'SN_NO' , width: 120},
			{dataIndex: 'EQU_GRADE' , width: 120},
			{dataIndex: 'WEIGHT' , width: 120},
			{dataIndex: 'EQU_PRSN' , width: 120},
			{dataIndex: 'EQU_TYPE' , width: 120},
			{dataIndex: 'MTRL_TYPE' , width: 120},
			{dataIndex: 'MTRL_TEXT' , width: 120},
			{dataIndex: 'BUY_COMP' , width: 120},
			{dataIndex: 'BUY_DATE' , width: 120},
			{dataIndex: 'BUY_AMT' , width: 120},
			{dataIndex: 'SELL_DATE' , width: 120},
			{dataIndex: 'SELL_AMT' , width: 120},
			{dataIndex: 'ABOL_DATE' , width: 120},
			{dataIndex: 'ABOL_AMT' , width: 120},
			{dataIndex: 'CAPA' , width: 120},
			{dataIndex: 'WORK_Q' , width: 120},
			{dataIndex: 'CAVIT_BASE_Q' , width: 120},
			{dataIndex: 'TRANS_DATE' , width: 120},
			{dataIndex: 'FROM_DIV_CODE' , width: 120},
			{dataIndex: 'USE_CUSTOM_CODE' , width: 120},
			{dataIndex: 'USE_CUSTOM_NAME' , width: 120}



		]
    });		// end of var masterGrid = Unilite.createGrid('equ210skrvGrid1', {


    Unilite.Main({
    	borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		id  : 'equ210skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);

			if(gsSiteGubun == 'KDG'){
				panelResult.down('#labelBtn').setHidden(false);
			}

		},
		onQueryButtonDown : function()	{

			masterGrid.getStore().loadStoreRecords();

		}
	});

};


</script>
