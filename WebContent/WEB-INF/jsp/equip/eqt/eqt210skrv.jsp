<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="eqt210skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="P001"/> <!-- 진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="B039"/> <!-- 출고방법 -->
	<t:ExtComboStore comboType="AU" comboCode="P103"/> <!-- 참조구분 -->
	<t:ExtComboStore comboType="AU" comboCode="0"/>    <!-- 창고 -->
	<t:ExtComboStore comboType="AU" comboCode="M105"/> <!-- 사급구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B081"/> <!-- 대체품목여부 -->
    <t:ExtComboStore comboType="AU" comboCode="P103"/> <!-- 참조구분 -->
    <t:ExtComboStore comboType="AU" comboCode="I800" /> <!-- 장비구분 -->
    <t:ExtComboStore comboType="AU" comboCode="I812" /> <!-- 점검항목 -->
    <t:ExtComboStore comboType="AU" comboCode="I813" /> <!-- 판정기준 -->
    <t:ExtComboStore comboType="AU" comboCode="I814" /> <!-- 판정방법 -->
    <t:ExtComboStore comboType="AU" comboCode="I815" /> <!-- 판정주기 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var activeGrid='eqt210skrvGridTab3';

function appMain() {

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read:		'eqt210skrvService.selectList'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read:		'eqt210skrvService.selectList2'
		}
	});

	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read:		'eqt210skrvService.selectList3'
		}
	});

	var panelSearch = Unilite.createSearchPanel('eqt210skrvpanelSearch', {
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
		items: [
		    {
			title: '기본정보',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
	    		fieldLabel:'사업장',
			    name: 'DIV_CODE',
			    xtype: 'uniCombobox',
				comboType:'BOR120',
			    value:UserInfo.divCode,
			    listeners: {
				    change: function(combo, newValue, oldValue, eOpts) {
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
				    change: function(combo, newValue, oldValue, eOpts) {
				    	panelResult.setValue('EQU_CODE_TYPE', newValue);
			    	}
			    }
			},
		    	{
	           		fieldLabel:'조회일자',
	           		xtype: 'uniDateRangefield',
	           		startFieldName: 'FR_DATE',
	           		endFieldName: 'TO_DATE',
	           		width:315,
	                startDate: UniDate.get('startOfMonth'),
	                endDate: UniDate.get('today'),
	                onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                    if(panelResult) {
	                        panelResult.setValue('FR_DATE',newValue);
	                        //panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
	                    }
	                },
	                onEndDateChange: function(field, newValue, oldValue, eOpts) {
	                    if(panelResult) {
	                        panelResult.setValue('TO_DATE',newValue);
	                        //panelSearch.getField('ISSUE_REQ_DATE_TO').validate();

	                    }
	                }
				}
		    	,Unilite.popup('EQU_CODE', {
					fieldLabel: '장비번호',
					valueFieldName: 'EQU_CODE',
			   	 	textFieldName: 'EQU_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('EQU_CODE', records[0].EQU_CODE);
								panelResult.setValue('EQU_NAME', records[0].EQU_NAME);
	                    	},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('EQU_CODE', '');
							panelResult.setValue('EQU_NAME', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE':panelSearch.getValue('DIV_CODE')});
						}
					}
				})
			    ,Unilite.popup('CUST', { // 20210810 팝업창 표준화 작업
					fieldLabel: '보관/수정처',
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
				})
		    ]
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
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{
    		fieldLabel:'사업장',
		    name: 'DIV_CODE',
		    xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank:false,
		    value:UserInfo.divCode,
		    listeners: {
			    change: function(combo, newValue, oldValue, eOpts) {
			    	panelSearch.setValue('DIV_CODE', newValue);
		    	}
		    }
    	},{
			fieldLabel: '장비구분',
			name: 'EQU_CODE_TYPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'I800',
		    listeners: {
			    change: function(combo, newValue, oldValue, eOpts) {
			    	panelSearch.setValue('EQU_CODE_TYPE', newValue);
		    	}
		    }
		},{
       		fieldLabel:'조회일자',
       		xtype: 'uniDateRangefield',
       		startFieldName: 'FR_DATE',
       		endFieldName: 'TO_DATE',
       		width:315,
       		startDate: UniDate.get('startOfMonth'),
	        endDate: UniDate.get('today'),
	        onStartDateChange: function(field, newValue, oldValue, eOpts) {
	        if(panelResult) {
		           panelSearch.setValue('FR_DATE',newValue);
		          //panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
		        }
	        },
	        onEndDateChange: function(field, newValue, oldValue, eOpts) {
	        if(panelResult) {
		        panelSearch.setValue('TO_DATE',newValue);
		        //panelSearch.getField('ISSUE_REQ_DATE_TO').validate();
		        }
	        }
		}

    	,Unilite.popup('EQU_CODE', {
			fieldLabel: '장비번호',
			valueFieldName: 'EQU_CODE',
	   	 	textFieldName: 'EQU_NAME',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('EQU_CODE', records[0].EQU_CODE);
						panelSearch.setValue('EQU_NAME', records[0].EQU_NAME);
                	},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('EQU_CODE', '');
					panelSearch.setValue('EQU_NAME', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE':panelResult.getValue('DIV_CODE')});
				}
			}
		})
	    ,Unilite.popup('CUST', { // 20210810 팝업창 표준화 작업
			fieldLabel: '보관/수정처',
			valueFieldName: 'CUSTOM_CODE',
	   	 	textFieldName: 'CUSTOM_NAME',
	   	 	validateBlank: false,
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
		})
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
                    } else {
                    //  this.mask();
                    }
                } else {
                    this.unmask();
                }
                return r;
            }
	    });




	/**Model 정의
	 * @type
	 */
	Unilite.defineModel('eqt210skrvMasterModel', {
	    fields: [
			{name: 'DIV_CODE'         	,text: '사업장코드'				,type:'string'},
			{name: 'EQU_CODE_TYPE'		    , text: '장비구분'				, type: 'string',comboType:'AU', comboCode:'I800' },
			{name: 'EQU_CODE'        	,text: '장비번호'				,type:'string'},
			{name: 'EQU_NAME'        	,text: '품명'					,type:'string'},
			{name: 'EQU_SPEC'        	,text: '규격'					,type:'string'},
			{name: 'ASSETS_NO'        	,text: '자산번호'				,type:'string'},
			{name: 'CUSTOM_CODE'    	,text: '제작처'					,type:'string'},
			{name: 'CUSTOM_NAME'    	,text: '제작처명'				,type:'string'},
			{name: 'PRODT_DATE'        	,text: '제작일자'				,type:'uniDate'},
			{name: 'PRODT_Q'        	,text: '수량'					,type:'uniQty'},
			{name: 'PRODT_O'        	,text: '금액'					,type:'uniPrice'},
			{name: 'TRANS_SEQ'        	,text: '순번'					,type:'int'},
			{name: 'TRANS_DATE'        	,text: '불출일자'				,type:'uniDate'},
			{name: 'USE_CUSTOM_CODE'    ,text: '보관처'					,type:'string'},
			{name: 'USE_CUSTOM_NAME'    ,text: '보관처명'				,type:'string'},
			{name: 'REP_AMT'        	,text: '수정금액'				,type:'uniPrice'},
			{name: 'TRANS_REASON'       ,text: '이동내역'				,type:'string'}
		]
	});

	Unilite.defineModel('eqt210skrvMasterModel2', {
        fields: [
            {name: 'DIV_CODE'           ,text: '사업장코드'              ,type:'string'},
            {name: 'EQU_CODE_TYPE'      , text: '장비구분'              ,type: 'string',comboType:'AU', comboCode:'I800' },
            {name: 'EQU_CODE'           ,text: '장비번호'               ,type:'string'},
            {name: 'EQU_NAME'           ,text: '품명'                 ,type:'string'},
            {name: 'EQU_SPEC'           ,text: '규격'                 ,type:'string'},
            {name: 'ASSETS_NO'          ,text: '자산번호'               ,type:'string'},
            {name: 'CUSTOM_CODE'        ,text: '제작처'                ,type:'string'},
            {name: 'CUSTOM_NAME'        ,text: '제작처명'               ,type:'string'},
            {name: 'PRODT_DATE'         ,text: '제작일자'               ,type:'uniDate'},
            {name: 'PRODT_Q'            ,text: '수량'                 ,type:'uniQty'},
            {name: 'PRODT_O'            ,text: '금액'                 ,type:'uniPrice'},
            {name: 'REP_SEQ'            ,text: '수리순번'                 ,type:'int'},
            {name: 'REP_DATE'           ,text: '수리일자'               ,type:'uniDate'},
            {name: 'REP_COMP_CODE'      ,text: '수리업체'                ,type:'string'},
            {name: 'REP_COMP_NAME'      ,text: '수리업명'               ,type:'string'},
            {name: 'REP_AMT'            ,text: '수리긍액'               ,type:'uniPrice'},
            {name: 'DEF_REASON'         ,text: '고장원인'               ,type:'string'}
        ]
    });

	Unilite.defineModel('eqt210skrvMasterModel3', {
 	    fields: [
   			{name: 'DIV_CODE'         	,text: '사업장코드'				,type:'string',allowBlank: false},
   			{name: 'WORK_SHOP_CODE'     ,text: '공정코드'				,type:'string',allowBlank: false},
   			{name: 'SEQ'         		,text: '순번'				    ,type:'int',allowBlank: false},
   			{name: 'EQU_CODE_TYPE'		,text: '장비구분'				,type:'string', allowBlank:false,comboType:'AU', comboCode:'I800' },
   			{name: 'EQU_CODE'        	,text: '장비(금형)번호'			,type:'string',allowBlank: false},
   			{name: 'CHECKHISTNO'        ,text: '점검항목'				,type:'string',comboType:'AU', comboCode:'I812'},
   			{name: 'CHECKNOTE'         	,text: '점검내용'				,type:'string'},
   			{name: 'WORKDATE'         	,text: '점검일자'				,type:'uniDate'},
   			{name: 'RESULTS_STD'        ,text: '판정기준'				,type:'string',comboType:'AU', comboCode:'I813'},
   			{name: 'RESULTS_METHOD'     ,text: '판정방법'				,type:'string',comboType:'AU', comboCode:'I814'},
   			{name: 'RESULTS_ROUTINE'    ,text: '판정주기'				,type:'string',comboType:'AU', comboCode:'I815'},
   			{name: 'PRESSUREVALUE'    	,text: '압력'					,type:'string'},
   			{name: 'INTERFACEFLAG'    	,text: '인터페이스FLAG'			,type:'string'},
   			{name: 'INTERFACETIME'    	,text: '인터페이스시간'			,type:'string'},
   			{name: 'WORKHISTORYNO'    	,text: '작업지시번호'				,type:'string'}
   		]
    });


	var MasterStore = Unilite.createStore('eqt210skrvMasterStore', {
		model: 'eqt210skrvMasterModel',
		autoLoad: false,
		uniOpt: {
			isMaster:	true,			// 상위 버튼 연결
			editable:	false,			// 수정 모드 사용
			deletable:	false,			// 삭제 가능 여부
			useNavi:	false			// prev | next 버튼 사용
		},
		proxy: directProxy,
		loadStoreRecords: function() {
			var param= panelSearch.getValues();
			console.log(param);
			this.load({params : param});
			/*	{


					params : param,
					callback : function(records,options,success)	{
						if(success)	{
								UniAppManager.setToolbarButtons(['delete', 'newData'], true);
						}
					}
				}
			);*/
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

    var MasterGrid = Unilite.createGrid('eqt210skrvGrid', {
    	layout: 'fit',
        region:'center',
        uniOpt: {
			expandLastColumn:	false,
			useRowNumberer:		false
        },
    	store: MasterStore,
    	features: [ {id : 'MasterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
           	{id : 'MasterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns: [
        	{dataIndex: 'DIV_CODE'        	 	, width: 110		, hidden: true,comboType:'BOR120'},
			{dataIndex: 'EQU_CODE_TYPE' , width: 80,locked:true},
			{dataIndex: 'EQU_CODE'     			, width: 110,locked:true},
			{dataIndex: 'EQU_NAME'     			, width: 110,locked:true},
			{dataIndex: 'EQU_SPEC'     			, width: 110,locked:true},
			{dataIndex: 'ASSETS_NO'     		, width: 110},
			{dataIndex: 'CUSTOM_CODE'     		, width: 110},
			{dataIndex: 'CUSTOM_NAME'     		, width: 110},
			{dataIndex: 'TRANS_SEQ'       		, width: 110,hidden:true},
			{dataIndex: 'PRODT_DATE'       		, width: 110},
			{dataIndex: 'PRODT_Q'       		, width: 110},
			{dataIndex: 'PRODT_O'       		, width: 110},
			{dataIndex: 'TRANS_DATE'       		, width: 110},
			{dataIndex: 'USE_CUSTOM_CODE'		, width: 80 ,
				   editor: Unilite.popup('CUST_G',
				   		{listeners:{
				   			'onSelected': {
			                    fn: function(records, type  ){
			                    var grdRecord = Ext.getCmp('eqt210skrvGrid').uniOpt.currentRecord;
			                    grdRecord.set('USE_CUSTOM_CODE',records[0]['CUSTOM_CODE']);
			                    grdRecord.set('USE_CUSTOM_NAME',records[0]['CUSTOM_NAME']);
			                    },
			                    scope: this
			                  },
			                'onClear' : function(type)	{
		                  		var grdRecord = Ext.getCmp('eqt210skrvGrid').uniOpt.currentRecord;
		                  		grdRecord.set('USE_CUSTOM_CODE', '');
		                  		grdRecord.set('USE_CUSTOM_NAME', '');
			                  }
							}
						} )
				  },
				  {dataIndex: 'USE_CUSTOM_NAME'		, width: 80 ,
					   editor: Unilite.popup('CUST_G',
					   		{listeners:{
					   			'onSelected': {
				                    fn: function(records, type  ){
				                    var grdRecord = Ext.getCmp('eqt210skrvGrid').uniOpt.currentRecord;
				                    grdRecord.set('USE_CUSTOM_CODE',records[0]['CUSTOM_CODE']);
				                    grdRecord.set('USE_CUSTOM_NAME',records[0]['CUSTOM_NAME']);
				                    },
				                    scope: this
				                  },
				                'onClear' : function(type)	{
			                  		var grdRecord = Ext.getCmp('eqt210skrvGrid').uniOpt.currentRecord;
			                  		grdRecord.set('USE_CUSTOM_CODE', '');
			                  		grdRecord.set('USE_CUSTOM_NAME', '');
				                  }
								}
							} )
					  },
			{dataIndex: 'REP_AMT'       	, width: 110,comboType:'BOR120',hidden:true},
			{dataIndex: 'TRANS_REASON'      , width: 110}
		],
		listeners: {
/*			beforeedit현재는 필요 없음(masterStore에서 uniOpt에 editable:	false처리 해 놓았음	*/
  			beforeedit: function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field,
					['DIV_CODE','TRANS_SEQ','EQU_CODE']))
				return false;

        	}

  			}
	});

    var MasterStore2 = Unilite.createStore('eqt210skrvMasterStore2', {
		model: 'eqt210skrvMasterModel2',
		autoLoad: false,
		uniOpt: {
			isMaster:	true,			// 상위 버튼 연결
			editable:	false,			// 수정 모드 사용
			deletable:	false,			// 삭제 가능 여부
			useNavi:	false			// prev | next 버튼 사용
		},
		proxy: directProxy2,
		loadStoreRecords: function(){
			var param= panelSearch.getValues();

			this.load({params : param});
			/*this.load({
				params : param,
				callback : function(records,options,success)	{
					if(success)	{
							UniAppManager.setToolbarButtons(['delete', 'newData'], true);
					}
				}
			});*/
     	},groupField: 'EQU_CODE'
	});

    var MasterGrid2 = Unilite.createGrid('eqt210skrvGrid2', {
    	layout: 'fit',
        region:'south',
        uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
        },
    	store: MasterStore2,
    	features: [ {id : 'MasterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
    	           	{id : 'MasterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
        columns: [
        	{dataIndex: 'DIV_CODE'        	 	, width: 110		, hidden: true,comboType:'BOR120'},
			{dataIndex: 'EQU_CODE_TYPE' , width: 80,locked:true},
			{dataIndex: 'EQU_CODE'     			, width: 110,locked:true,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '장비번호계', '총계');
	    	}},
			{dataIndex: 'EQU_NAME'     			, width: 110,locked:true},
			{dataIndex: 'EQU_SPEC'     			, width: 110,locked:true},
			{dataIndex: 'ASSETS_NO'     		, width: 110},
			{dataIndex: 'CUSTOM_CODE'     		, width: 110},
			{dataIndex: 'CUSTOM_NAME'     		, width: 110},
			{dataIndex: 'REP_SEQ'       		, width: 110,hidden:true},
			{dataIndex: 'PRODT_DATE'       		, width: 110},
			{dataIndex: 'PRODT_Q'       		, width: 110},
			{dataIndex: 'PRODT_O'       		, width: 110},
			{dataIndex: 'REP_DATE'       		, width: 110},
			{dataIndex: 'REP_COMP_CODE'       	, width: 80 ,
				   editor: Unilite.popup('CUST_G',
				   		{listeners:{
				   			'onSelected': {
			                    fn: function(records, type  ){
			                    var grdRecord = Ext.getCmp('eqt210skrvGrid').uniOpt.currentRecord;
			                    grdRecord.set('REP_COMP',records[0]['CUSTOM_CODE']);
			                    grdRecord.set('REP_COMP_NAME',records[0]['CUSTOM_NAME']);
			                    },
			                    scope: this
			                  },
			                'onClear' : function(type)	{
		                  		var grdRecord = Ext.getCmp('eqt210skrvGrid').uniOpt.currentRecord;
		                  		grdRecord.set('REP_COMP', '');
		                  		grdRecord.set('REP_COMP_NAME', '');
			                  }
							}
						} )
				  },
				  {dataIndex: 'REP_COMP_NAME'		, width: 80 ,
					   editor: Unilite.popup('CUST_G',
					   		{listeners:{
					   			'onSelected': {
				                    fn: function(records, type  ){
				                    var grdRecord = Ext.getCmp('eqt210skrvGrid').uniOpt.currentRecord;
				                    grdRecord.set('REP_COMP',records[0]['CUSTOM_CODE']);
				                    grdRecord.set('REP_COMP_NAME',records[0]['CUSTOM_NAME']);
				                    },
				                    scope: this
				                  },
				                'onClear' : function(type)	{
			                  		var grdRecord = Ext.getCmp('eqt210skrvGrid').uniOpt.currentRecord;
			                  		grdRecord.set('REP_COMP', '');
			                  		grdRecord.set('REP_COMP_NAME', '');
				                  }
								}
							} )
					  },
			{dataIndex: 'REP_AMT'       	, width: 110,summaryType: 'sum'},
			{dataIndex: 'DEF_REASON'      , width: 300}

		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ){
				if (UniUtils.indexOf(e.field,
						['DIV_CODE','REP_SEQ','EQU_CODE']))
					return false;
			}
       	}
	});

    var MasterStore3 = Unilite.createStore('eqt210skrvMasterStore3', {
	    model: 'eqt210skrvMasterModel3',
		autoLoad: false,
		uniOpt: {
			isMaster:	true,			// 상위 버튼 연결
			editable:	true,			// 수정 모드 사용
			deletable:	true,			// 삭제 가능 여부
			useNavi:	false			// prev | next 버튼 사용
		},

		proxy: directProxy3,
		loadStoreRecords: function(){
			var param= panelResult.getValues();
			this.load({
				params : param,
				callback : function(records,options,success)	{
					if(success)	{
							UniAppManager.setToolbarButtons(['delete', 'newData'], true);
					}
				}
			});
     	},

     	saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			var equCode = panelResult.getValue('EQU_CODE');
			Ext.each(list, function(record, index) {
				if(record.data['EQU_CODE'] != equCode) {
					record.set('EQU_CODE', equCode);
				}
			})
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			var paramMaster= masterForm.getValues();	//syncAll 수정
			paramMaster.TYPE='C'; //模具维修
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.app.onQueryButtonDown();
						UniAppManager.setToolbarButtons('save', false);
					 }
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('eqt300ukrvGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	var MasterGrid3 = Unilite.createGrid('eqt300ukrvGrid', {
	    	layout: 'fit',
	        region:'center',
	        uniOpt: {
				expandLastColumn:	false,
				useRowNumberer:		false
	        },
	    	store: MasterStore3,
	    	features: [ {id : 'MasterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
	           	{id : 'MasterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
	        columns: [
	   			{dataIndex: 'DIV_CODE'        	 	, width: 110, 	hidden: false,comboType:'BOR120'},
	   			{dataIndex: 'SEQ'           		, width: 80, align: 'center' },
	   			{dataIndex: 'WORK_SHOP_CODE'     	, width: 110},
	   			{dataIndex: 'EQU_CODE_TYPE'         , width: 110, 	hidden: false,comboType:'I800'},
	   			{dataIndex: 'EQU_CODE'     			, width: 110},
	   			{dataIndex: 'CHECKHISTNO'     		, width: 110, 	hidden: false,comboType:'I812'},
	   			{dataIndex: 'CHECKNOTE'     		, width: 110},
	   			{dataIndex: 'WORKDATE'     			, width: 110},
	   			{dataIndex: 'RESULTS_STD'         	, width: 110,	hidden: false,comboType:'I813'},
	   			{dataIndex: 'RESULTS_METHOD'     	, width: 110,	hidden: false,comboType:'I814'},
	   			{dataIndex: 'RESULTS_ROUTINE'     	, width: 110,	hidden: false,comboType:'I815'},
	   			{dataIndex: 'PRESSUREVALUE'     	, width: 110},
	   			{dataIndex: 'INTERFACEFLAG'     	, width: 110},
	   			{dataIndex: 'INTERFACETIME'     	, width: 110},
	   			{dataIndex: 'WORKHISTORYNO'     	, width: 110}
			],
			listeners: {
	/*			beforeedit현재는 필요 없음(masterStore에서 uniOpt에 editable:	false처리 해 놓았음	*/
	  			beforeedit: function( editor, e, eOpts ) {
					if (UniUtils.indexOf(e.field,
						['DIV_CODE','WORK_SHOP_CODE','WORKDATE']))
					return false;
	        	}
	  			}
		});

    var tab = Unilite.createTabPanel('tabPanel',{
        activeTab: 0,
        region: 'center',
        items: [{
            title: '일상점검현황'
                ,xtype:'container'
                ,layout:{type:'vbox', align:'stretch'}
                ,items:[MasterGrid3]
                ,id: 'eqt210skrvGridTab3'
           },{
              title: '설비이동현황'
             ,xtype:'container'
             ,layout:{type:'vbox', align:'stretch'}
             ,items:[MasterGrid]
             ,id: 'eqt210skrvGridTab'
        	},{
              title: '설비수리현황'
             ,xtype:'container'
             ,layout:{type:'vbox', align:'stretch'}
             ,items:[MasterGrid2]
             ,id: 'eqt210skrvGridTab2'
        	} ],
        listeners:  {
            tabChange:  function ( tabPanel, newCard, oldCard, eOpts )  {
            	activeGrid=newCard.id;
            	if(activeGrid=="eqt210skrvGridTab"){
            		MasterStore.loadStoreRecords();
            	}else if(activeGrid=="eqt210skrvGridTab2")
            	{
            		MasterStore2.loadStoreRecords();
            	}else if(activeGrid=="eqt210skrvGridTab3")
            	{
            		MasterStore3.loadStoreRecords();
            	}
            }
        }
    });
    Unilite.Main({
		id: 'eqt210skrvApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult ,tab
			]
		},
			panelSearch

		],
		fnInitBinding: function(params) {
			var toDate=UniDate.get('today');
			var frDate=getPreMonth(toDate);
			panelResult.setValue("FR_DATE",frDate);
			panelResult.setValue("TO_DATE",toDate);
			panelSearch.setValue("FR_DATE",frDate);
			panelSearch.setValue("TO_DATE",toDate);
			panelSearch.setValue("DIV_CODE",UserInfo.divCode);
			panelResult.setValue("DIV_CODE",UserInfo.divCode);

            UniAppManager.setToolbarButtons(['save','deleteAll','delete','newData'], false);

			this.processParams(params);
		},
		processParams: function(params) {
			this.uniOpt.appParams = params;

			if(params && params.EQU_CODE ) {

				tab.setActiveTab(Ext.getCmp('eqt210skrvGridTab2'));

				panelSearch.setValue('DIV_CODE',params.DIV_CODE);
				panelSearch.setValue('EQU_CODE',params.EQU_CODE);
				panelSearch.setValue('EQU_NAME',params.EQU_NAME);
				panelSearch.setValue("FR_DATE",'');
				panelSearch.setValue("TO_DATE",'');


				panelResult.setValue('DIV_CODE',params.DIV_CODE);
				panelResult.setValue('EQU_CODE',params.EQU_CODE);
				panelResult.setValue('EQU_NAME',params.EQU_NAME);
				panelResult.setValue("FR_DATE",'');
				panelResult.setValue("TO_DATE",'');

				MasterGrid2.getStore().loadStoreRecords();
			}
		},
		onQueryButtonDown: function() {
			if(panelSearch.setAllFieldsReadOnly(true) == false || panelResult.setAllFieldsReadOnly(true) == false)   // 필수값을 체크
			{
        		return false;
			}else{
				if(activeGrid=="eqt210skrvGridTab")
     			{
                 	MasterStore.loadStoreRecords();
     			}else if(activeGrid=="eqt210skrvGridTab2")
     			{
     				MasterStore2.loadStoreRecords();
     			}else if(activeGrid=="eqt210skrvGridTab3")
     			{
     			//	alert('여기까지 디버그111!!!.');
     				MasterStore3.loadStoreRecords();
     			}
			}
		},
		onPrevDataButtonDown:  function()   {
        },
        onNextDataButtonDown:  function()   {
        },
		onResetButtonDown: function() {
			panelResult.clearForm();
			panelSearch.clearForm();
            MasterGrid.getStore().loadData({});
            MasterGrid2.getStore().loadData({});
            MasterGrid3.getStore().loadData({});
			this.fnInitBinding();
		},

		onQueryImages:function(){
			var param=panelResult.getValues();
			eqt210skrvService.selectImages(param,function(provider, response){
				if(provider.length!=0){
					Ext.each(provider,function(record,index){
						imagesForm.setImage(record["IMAGE_FID"],index+1);
					})
				}else
				{
					for(var i =1;i<=3;i++)
					{
						imagesForm.setImage(null,i);
					}
				}
			});

		}
	});


	Unilite.createValidator('validator', {   		//  Grid 2 createValidator
		store: MasterStore2,
		grid: MasterGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			if(record.get('OUTSTOCK_REQ_Q') > 0){
                alert('출고요청된 수량이 있어 수정이 불가능합니다.');
                return false;
            }
			switch(fieldName) {
				case "UNIT_Q" : // "원단위량"
					if(newValue < 0 ){
						rv='<t:message code="unilite.msg.sMP570"/>';
						//0보다 큰수만 입력가능합니다.
					break;
					}
					record.set('ALLOCK_Q', newValue * MasterGrid.getSelectedRecord().get('WKORD_Q'))
				break;
			}
			return rv;
		}
	});
}
function getPreMonth(date) {
    var year = date.substr(0,4); //获取当前日期的年份
    var month = date.substr(4,2); //获取当前日期的月份
    var day = date.substr(6,2); //获取当前日期的日
    var days = new Date(year, month, 0);
    days = days.getDate(); //获取当前日期中月的天数
    var year2 = year;
    var month2 = parseInt(month) - 1;
    if (month2 == 0) {
        year2 = parseInt(year2) - 1;
        month2 = 12;
    }
    var day2 = day;
    var days2 = new Date(year2, month2, 0);
    days2 = days2.getDate();
    if (day2 > days2) {
        day2 = days2;
    }
    if (month2 < 10) {
        month2 = '0' + month2;
    }
    if (day2 < 10) {
    	day2 = '0' + day2;
    }
    var t2 = year2 + '' + month2 + '' + day2;
    return t2;
}
</script>
