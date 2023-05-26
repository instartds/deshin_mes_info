<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_tes900skrv_kd"  >
	<t:ExtComboStore comboType="BOR120"  /> 				            <!-- 사업장 -->

<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo = {
    gsDefaultMoney      : '${gsDefaultMoney}'
};

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_tes900skrv_kdService.selectList'
		}
	});

	/**
	 * Model 정의
	 *
	 * @type
	 */
	Unilite.defineModel('s_tes900skrv_kdModel', {
	    fields: [
            {name: 'COMP_CODE'          ,text: '법인코드'         ,type: 'string'},
	    	{name: 'DIV_CODE'           ,text: '사업장' 		    ,type: 'string' , comboType:'BOR120'},
            {name: 'YYYY'               ,text: '수출년도'         ,type: 'string'},
            {name: 'CUSTOM_NAME'        ,text: '거래처명'         ,type: 'string'},
            {name: 'MM01'               ,text: '자사금액'            ,type: 'uniPrice'},  // ,type: 'uniPrice'
            {name: 'MM01_FOR'           ,text: '외화금액'            ,type: 'uniPrice'},  // ,type: 'uniPrice'
            {name: 'MM02'               ,text: '자사금액'            ,type: 'uniPrice'},
            {name: 'MM02_FOR'           ,text: '외화금액'            ,type: 'uniPrice'},
            {name: 'MM03'               ,text: '자사금액'            ,type: 'uniPrice'},
            {name: 'MM03_FOR'           ,text: '외화금액'            ,type: 'uniPrice'},
            {name: 'MM04'               ,text: '자사금액'            ,type: 'uniPrice'},
            {name: 'MM04_FOR'           ,text: '외화금액'            ,type: 'uniPrice'},
            {name: 'MM05'               ,text: '자사금액'            ,type: 'uniPrice'},
            {name: 'MM05_FOR'           ,text: '외화금액'            ,type: 'uniPrice'},
            {name: 'MM06'               ,text: '자사금액'            ,type: 'uniPrice'},
            {name: 'MM06_FOR'           ,text: '외화금액'            ,type: 'uniPrice'},
            {name: 'MM07'               ,text: '자사금액'            ,type: 'uniPrice'},
            {name: 'MM07_FOR'           ,text: '외화금액'            ,type: 'uniPrice'},
            {name: 'MM08'               ,text: '자사금액'            ,type: 'uniPrice'},
            {name: 'MM08_FOR'           ,text: '외화금액'            ,type: 'uniPrice'},
            {name: 'MM09'               ,text: '자사금액'            ,type: 'uniPrice'},
            {name: 'MM09_FOR'           ,text: '외화금액'            ,type: 'uniPrice'},
            {name: 'MM10'               ,text: '자사금액'           ,type: 'uniPrice'},
            {name: 'MM10_FOR'           ,text: '외화금액'           ,type: 'uniPrice'},
            {name: 'MM11'               ,text: '자사금액'           ,type: 'uniPrice'},
            {name: 'MM11_FOR'           ,text: '외화금액'           ,type: 'uniPrice'},
            {name: 'MM12'               ,text: '자사금액'           ,type: 'uniPrice'},
            {name: 'MM12_FOR'           ,text: '외화금액'           ,type: 'uniPrice'},
            {name: 'TOTAL_AMT'          ,text: '자사'        		 ,type: 'uniPrice'},
            {name: 'TOTAL_AMT_FOR'      ,text: '외화'         	 ,type: 'uniPrice'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 *
	 * @type
	 */
	var MasterStore = Unilite.createStore('s_tes900skrv_kdMasterStore',{
			model: 's_tes900skrv_kdModel',
			uniOpt : {
            	isMaster: false,			    // 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable:false,			// 삭제 가능 여부
	            useNavi : false			    // prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy,
            loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params : param
				});

			},
			groupField: 'YYYY'
		});

	/**
	 * 검색조건 (Search Panel)
	 *
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
		    items : [{
				fieldLabel: '사업장',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
                holdable: 'hold',
                allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
                fieldLabel: '기준년도',
                name: 'YYYY',
                xtype: 'uniYearField',
//                holdable: 'hold',
                value: new Date().getFullYear(),
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('YYYY', newValue);
                    }
                }
            },{
                fieldLabel: '~',
                name: 'YYYYMM',
                xtype: 'uniMonthfield',
//                holdable: 'hold',
                value: UniDate.get('today'),
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('YYYYMM', newValue);
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
		      		// this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true);
		        			}
		       			}
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	// this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		}
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ;
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		}
	});

	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4/*, tableAttrs: {width: '99.5%'}*/},
		padding:'1 1 1 1',
		border:true,
	    items :[{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
//                holdable: 'hold',
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('DIV_CODE', newValue);
                    }
                }
            },{
                fieldLabel: '기준년도',
                name: 'YYYY',
                xtype: 'uniYearField',
//                holdable: 'hold',
                value: new Date().getFullYear(),
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('YYYY', newValue);
                    }
                }
            },{
                fieldLabel: '~',
                name: 'YYYYMM',
                labelWidth: 10,
                xtype: 'uniMonthfield',
//                holdable: 'hold',
                value: UniDate.get('today'),
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('YYYYMM', newValue);
                    }
                }
            }
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
		      		// this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true);
		        			}
		       			}
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	// this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		}
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ;
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		}
	});

    /**
	 * Master Grid1 정의(Grid Panel)
	 *
	 * @type
	 */
    var masterGrid = Unilite.createGrid('s_tes900skrv_kdGrid', {
    	// for tab
        layout : 'fit',
        region:'center',
        uniOpt:{	expandLastColumn: false,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
    	store: MasterStore,
         tbar: [{
                xtype:'button',
                text : '출력',
                tdAttrs: {align: 'right'},
                handler:function()  {
                    UniAppManager.app.onPrintButtonDown();
            }
         }],
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true } ],
        columns:  [
            { dataIndex: 'COMP_CODE'   ,          width: 100, hidden: true},
        	{ dataIndex: 'DIV_CODE'    ,          width: 120,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
                }
            },     //, hidden: true
            { dataIndex: 'YYYY'        ,          width: 80, align : 'center'},
            { dataIndex: 'CUSTOM_NAME' ,          width: 100},
            {	text: '1월',
        		columns:  [ { dataIndex: 'MM01'        ,          width: 110, summaryType: 'sum'},
        		            { dataIndex: 'MM01_FOR'    ,          width: 110, summaryType: 'sum'}
        		          ]
            },
            {	text: '2월',
            	columns:  [    { dataIndex: 'MM02'        ,          width: 110, summaryType: 'sum'},
            	               { dataIndex: 'MM02_FOR'    ,          width: 110, summaryType: 'sum'}
            	           ]
            },
            {	text: '3월',
            	columns:  [ { dataIndex: 'MM03'        ,          width: 110, summaryType: 'sum'},
                 			{ dataIndex: 'MM03_FOR'    ,          width: 110, summaryType: 'sum'}
            			  ]
            },
			  {	text: '4월',
            	columns:  [{ dataIndex: 'MM04'        ,          width: 110, summaryType: 'sum'},
                           { dataIndex: 'MM04_FOR'    ,          width: 110, summaryType: 'sum'}
            	          ]

			  },
			  {	text: '5월',
				  columns:  [
				             { dataIndex: 'MM05'        ,          width: 110, summaryType: 'sum'},
					         { dataIndex: 'MM05_FOR'    ,          width: 110, summaryType: 'sum'}
				             ]

			  },
			  {	text: '6월',
				  columns:  [
				             { dataIndex: 'MM06'        ,          width: 110, summaryType: 'sum'},
					         { dataIndex: 'MM06_FOR'    ,          width: 110, summaryType: 'sum'}
				             ]
			  },
			  {	text: '7월',
				  columns:  [
				              { dataIndex: 'MM07'        ,          width: 110, summaryType: 'sum'},
					          { dataIndex: 'MM07_FOR'    ,          width: 110, summaryType: 'sum'}
				             ]
			  },
			  {	text: '8월',
				  columns:  [
				             { dataIndex: 'MM08'        ,          width: 110, summaryType: 'sum'},
					         { dataIndex: 'MM08_FOR'    ,          width: 110, summaryType: 'sum'}
				             ]
			  },
			  {	text: '9월',
				  columns:  [
				              { dataIndex: 'MM09'        ,          width: 110, summaryType: 'sum'},
					          { dataIndex: 'MM09_FOR'    ,          width: 110, summaryType: 'sum'}
				             ]
			  },
			  {	text: '10월',
				  columns:  [
					       	  { dataIndex: 'MM10'        ,          width: 110, summaryType: 'sum'},
					          { dataIndex: 'MM10_FOR'    ,          width: 110, summaryType: 'sum'}
				             ]
			  },
			  {	text: '11월',
				  columns:  [
				              { dataIndex: 'MM11'        ,          width: 110, summaryType: 'sum'},
					          { dataIndex: 'MM11_FOR'    ,          width: 110, summaryType: 'sum'}
				             ]
			  },
			  {	text: '12월',
				  columns:  [
				              { dataIndex: 'MM12'        ,          width: 110, summaryType: 'sum'},
					          { dataIndex: 'MM12_FOR'    ,          width: 110, summaryType: 'sum'}
				            ]
			  },
			  {	text: '총금액',
				  columns:  [
				             { dataIndex: 'TOTAL_AMT'   ,          width: 120, summaryType: 'sum'},
				             { dataIndex: 'TOTAL_AMT_FOR'   ,      width: 120, summaryType: 'sum'}
				            ]
			  }


        ]
    });

    Unilite.Main( {
		borderItems:[{
			border: false,
			region:'center',
			layout: 'border',
			items:[
				masterGrid, panelResult
			]
		}
		, panelSearch
		],
		id  : 's_tes900skrv_kdApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('reset',false);
            this.setDefault();
		},
		onQueryButtonDown : function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false) {
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
			masterGrid.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons(['reset'], true);
		},
		onResetButtonDown: function() {     // 초기화
            panelSearch.clearForm();
            panelResult.clearForm();
            masterGrid.reset();
            panelSearch.setAllFieldsReadOnly(false);
            panelResult.setAllFieldsReadOnly(false);
            MasterStore.clearData();
            this.setDefault();
        },
        onPrintButtonDown: function() {

            var param = panelResult.getValues();
            var win = Ext.create('widget.CrystalReport', {
                url: CPATH+'/z_kd/s_tes900crkrv_kd.do',
                prgID: 's_tes900crkrv_kd',
                    extParam: param
                });
                win.center();
                win.show();

        },
        setDefault: function() {        // 기본값
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('YYYY', new Date().getFullYear());
            panelResult.setValue('YYYYMM', UniDate.get('today'));

            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelSearch.setValue('YYYY', new Date().getFullYear());
            panelSearch.setValue('YYYYMM', UniDate.get('today'));

            UniAppManager.setToolbarButtons(['reset'], false);
        }
	});

};

</script>