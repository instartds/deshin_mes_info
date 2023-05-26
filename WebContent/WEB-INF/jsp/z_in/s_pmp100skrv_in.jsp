<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmp100skrv_in"  >
	<t:ExtComboStore comboType="BOR120" /> 					 	 <!-- 사업장 -->
	<t:ExtComboStore comboType="W" /><!-- 작업장  -->
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo = {
		gsReportGubun : '${gsReportGubun}'	// 레포트 구분
	};
	
function appMain() {
	/**
	 *   Model 정의
	 * @type
	 */
	Unilite.defineModel('S_pmp100skrv_inModel', {
	    fields: [
	    	{name: 'DIV_CODE'						, text: '<t:message code="system.label.product.division" default="사업장"/>'		, type: 'string'},
	    	{name: 'WKORD_NUM'					, text: '작업지시번호'		, type: 'string'},
	    	{name: 'PRODT_START_DATE'		, text: '착수예정일'		, type: 'uniDate'},
	    	{name: 'ITEM_CODE'						, text: '<t:message code="system.label.product.item" default="품목"/>'		, type: 'string'},
	    	{name: 'ITEM_NAME'					, text: '<t:message code="system.label.product.itemname" default="품목명"/>'		, type: 'string'},
	    	{name: 'LOT_NO'							, text: 'LOT NO'		, type: 'string'},
	    	{name: 'DCM'									, text: 'DCM'		, type: 'string'},
	    	
	    	{name: 'POWDER_ITEM_CODE'	, text: '파우더 코드'		, type: 'string'},
	    	{name: 'POWDER_NAME'				, text: '파우더'				, type: 'string'},
	    	{name: 'BASE_VOL'						, text: '칭량기준'			, type: 'string'},
	    	{name: 'TOTAL_VOL'						, text: '총소분량'			, type: 'uniQty'},
	    	
	    	{name: 'CUSTOMER'						, text: '거래처'		, type: 'string'},
	    	{name: 'VOLUME'							, text: 'Volume(l)'		, type: 'uniQty'},
	    	{name: 'WKORD_Q'						, text: 'Plate(ea)'		, type: 'uniQty'},
	    	{name: 'EQUIP_CODE'					, text: 'MP No.'		, type: 'string'},
	    	{name: 'WORKSHOP_LINE'			, text: '분주라인'	 	, type: 'string'},
	    	{name: 'WORK_SHOP_CODE'			, text: '작업장'	 	, type: 'string'      , comboType: 'W'}
		]
	});	

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var masterStore = Unilite.createStore('s_pmp100skrv_inMasterStore',{
			model: 'S_pmp100skrv_inModel',
			uniOpt: {
            	isMaster: true,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable:false,			// 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	read: 's_pmp100skrv_inService.selectList'
                }
            },
            loadStoreRecords: function(){
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params : param
				});
			},
			listeners: {
	           	load: function(store, records, successful, eOpts) {
					if(masterStore.count() == 0)	{
						UniAppManager.setToolbarButtons('reset', false);
	   			}
			}}
	});

	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				value: UserInfo.divCode,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
							panelSearch.setValue('WORK_SHOP_CODE','');
						}
					}
			},{
				fieldLabel: '착수예정일',
				xtype: 'uniDateRangefield',
				startFieldName: 'PRODT_START_DATE_FR',
				endFieldName: 'PRODT_START_DATE_TO',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelResult) {
					panelResult.setValue('PRODT_START_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PRODT_START_DATE_TO',newValue);
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
	   						var labelText = invalid.items[0]['fieldLabel']+' : ';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
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

	var panelResult = Unilite.createSearchForm('panelResultForm', {
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('DIV_CODE', newValue);
						panelResult.setValue('WORK_SHOP_CODE','');
					}
				}
			},{
				fieldLabel: '착수예정일',
				xtype: 'uniDateRangefield',
				startFieldName: 'PRODT_START_DATE_FR',
				endFieldName: 'PRODT_START_DATE_TO',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PRODT_START_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) {
						panelSearch.setValue('PRODT_START_DATE_TO',newValue);
					}
				}
			}]
    });

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
    var masterGrid = Unilite.createGrid('s_pmp100skrv_inGrid',{
        region: 'center' ,
        layout : 'fit',
        store : masterStore,
        uniOpt: {
			expandLastColumn	: false,
			useMultipleSorting	: true,
			useLiveSearch		: false,
			useContextMenu		: false,
			useRowNumberer		: true,	   //순번표시 
			copiedRow			: false,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		selModel: 'rowmodel',
    	features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
        columns: [
        	{dataIndex:  'DIV_CODE'			  , width: 95 , hidden: true},
        	{dataIndex:  'WKORD_NUM'			  , width: 125},
        	{dataIndex:  'PRODT_START_DATE'	  , width: 95,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
            }},
        	{dataIndex:  'ITEM_CODE'			, width: 80},
        	{dataIndex:  'ITEM_NAME'			, width: 130},
        	{dataIndex:  'LOT_NO'				, width: 95},
        	
        	{dataIndex:'POWDER_ITEM_CODE'	    , width: 95},
        	{dataIndex:'POWDER_NAME'		    , width: 210},
        	{dataIndex:'BASE_VOL'			    , width: 95},
        	{dataIndex:'TOTAL_VOL'			    , width: 95, summaryType: 'sum'},
        	{dataIndex:  'DCM'				  , width: 130},
        	{dataIndex:  'CUSTOMER'			  , width: 110},
        	{dataIndex:  'VOLUME'				, width: 95 , summaryType: 'sum'},
        	{dataIndex:  'WKORD_Q'			  , width: 100 , summaryType: 'sum'},
        	{dataIndex:  'EQUIP_CODE'			, width: 120},
        	{dataIndex:  'WORKSHOP_LINE'		, width: 315},
        	{dataIndex:  'WORK_SHOP_CODE'		, width: 100, hidden: false}
		],
		listeners: {
          	onGridDblClick:function(grid, record, cellIndex, colName) {
          		 if(record)  {
                     var params = {
      						action		: 'new',
      						'PGM_ID'	: 's_pmp100skrv_in',
      						'record'	: record,
      						'formPram'	: panelResult.getValues(),
      						'DIV_CODE' : panelResult.getValue('DIV_CODE'),
      						'PRODT_START_DATE' : record.data.PRODT_START_DATE,
      						'WORK_SHOP_CODE' : record.data.WORK_SHOP_CODE ,
      						'WKORD_NUM' : record.data.WKORD_NUM,
      						'LOT_NO' : record.data.LOT_NO
      					}
                     var rec = {data : {prgID : 'pmp160ukrv', 'text':''}};
                     parent.openTab(rec, '/prodt/pmp160ukrv.do', params);
                 }
          	}
          }
    });	

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
		id: 's_pmp100skrv_inApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('PRODT_START_DATE_FR', UniDate.get('today'));
			panelSearch.setValue('PRODT_START_DATE_TO', UniDate.get('today'));
			panelResult.setValue('PRODT_START_DATE_FR', UniDate.get('today'));
			panelResult.setValue('PRODT_START_DATE_TO', UniDate.get('today'));
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}else{
			masterGrid.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons(['reset','print'], true);
			}
			
		},
		onResetButtonDown: function() {		// 초기화
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			masterStore.clearData();
			this.fnInitBinding();
		},
		onPrintButtonDown: function () {
            if(!panelResult.getInvalidMessage()) return;   //필수체크
            var param = panelResult.getValues();
            
            param["USER_LANG"] = UserInfo.userLang;
            param["PGM_ID"]= PGM_ID;
            param["MAIN_CODE"] = 'P010';  //생산용 공통 코드
            param["sTxtValue2_fileTitle"]='작업지시현황(요약)';
            
            var win = null;
            if(BsaCodeInfo.gsReportGubun == 'CLIP'){
	            win = Ext.create('widget.ClipReport', {
	                url: CPATH+'/z_in/s_pmp100clskrv_in.do',
	                prgID: 's_pmp100skrv_in',
	                extParam: param
	            });
            }else{
		    	/* win = Ext.create('widget.CrystalReport', {
                    url: CPATH + '/prodt/pmp130crkrv.do',
                    prgID: 'pmp130rkrv',
                    extParam: param
                }); */
                win = null;
            }

            win.center();
            win.show();
        }
	});		//End of Unilite.Main({
};
</script>

