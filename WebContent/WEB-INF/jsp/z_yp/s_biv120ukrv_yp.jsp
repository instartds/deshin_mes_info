<%@page language="java" contentType="text/html; charset=utf-8"%>
	<t:appConfig pgmId="s_biv120ukrv_yp"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_biv120ukrv_yp"/> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var BsaCodeInfo = {	// 컨트롤러에서 값을 받아옴
	gsSumTypeLot:		'${gsSumTypeLot}',
	gsSumTypeCell:		'${gsSumTypeCell}'
};

/*var output ='';
	for(var key in BsaCodeInfo){
 		output += key + '  :  ' + BsaCodeInfo[key] + '\n';
	}
	alert(output);*/

var outDivCode = UserInfo.divCode;

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_biv120ukrv_ypService.selectMaster',
			update: 's_biv120ukrv_ypService.updateDetail',
			create: 's_biv120ukrv_ypService.insertDetail',
			destroy: 's_biv120ukrv_ypService.deleteDetail',
			syncAll: 's_biv120ukrv_ypService.saveAll'
		}
	});

	var masterForm = Unilite.createSearchPanel('searchForm', {		// 메인
		title: '<t:message code="system.label.inventory.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.inventory.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
					fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
					name:'DIV_CODE',
					xtype: 'uniCombobox',
					comboType:'BOR120',
					child:'WH_CODE',
					value: '01',
					allowBlank:false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
					name:'WH_CODE',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('whList'),
					allowBlank:false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('WH_CODE', newValue);
						}
					}
				},
				Unilite.popup('COUNT_DATE', {
					fieldLabel: '<t:message code="system.label.inventory.stockcountingdate" default="실사일"/>',
					//fieldStyle: 'text-align: center;',
					allowBlank: false,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								var countDATE = UniDate.getDbDateStr(records[0]['COUNT_DATE']).substring(0, 8);
								countDATE = countDATE.substring(0,4) + '.' + countDATE.substring(4,6) + '.' + countDATE.substring(6,8);
								masterForm.setValue('COUNT_DATE', countDATE);
								panelResult.setValue('COUNT_DATE', masterForm.getValue('COUNT_DATE'));
								masterForm.setValue('WH_CODE', records[0]['WH_CODE']);
								panelResult.setValue('WH_CODE', masterForm.getValue('WH_CODE'));
								masterForm.setValue('COUNT_DATE2', records[0]['COUNT_CONT_DATE']);
								panelResult.setValue('COUNT_DATE2', masterForm.getValue('COUNT_DATE2'));
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('COUNT_DATE', '');
							panelResult.setValue('WH_CODE', '');
							panelResult.setValue('COUNT_DATE2', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
							popup.setExtParam({'WH_CODE': masterForm.getValue('WH_CODE')});
						}
					}
				}),{
					fieldLabel: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',
					name:'ITEM_ACCOUNT',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'B020',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ITEM_ACCOUNT', newValue);
						}
					}
				},
				Unilite.popup('DIV_PUMOK',{
			        	fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
			        	valueFieldName: 'ITEM_CODE',
						textFieldName: 'ITEM_NAME',
						autoPopup: true,
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('ITEM_CODE', masterForm.getValue('ITEM_CODE'));
									panelResult.setValue('ITEM_NAME', masterForm.getValue('ITEM_NAME'));
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('ITEM_CODE', '');
								panelResult.setValue('ITEM_NAME', '');
							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
							}
						}
			   }),{
					fieldLabel: '<t:message code="system.label.inventory.stockcountingapplydate" default="실사반영일"/>',
					name: 'COUNT_DATE2',
					xtype: 'uniDatefield',
					readOnly: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('COUNT_DATE2', newValue);
						}
					}
				},{
				    xtype: 'radiogroup',
				    fieldLabel: '<t:message code="system.label.inventory.differenceqty" default="차이수량"/></br><t:message code="system.label.inventory.viewyn" default="조회여부"/>',
				    items : [{
				    	boxLabel: '<t:message code="system.label.inventory.yes" default="예"/>',
				    	name: 'DIFF_YN',
				    	inputValue: 'Y',
				    	width:80
				    }, {
				    	boxLabel: '<t:message code="system.label.inventory.no" default="아니오"/>',
				    	name: 'DIFF_YN' ,
				    	inputValue: 'N',
				    	width:80,
				    	checked: true
				    }],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.getField('DIFF_YN').setValue(newValue.DIFF_YN);
						}
					}
				}]
		},{
			title:'추가정보',
			id: 'search_panel2',
			itemId:'search_panel2',
	    	defaultType: 'uniTextfield',
	    	layout: {type: 'uniTable', columns: 1},
			items:[{
		    		xtype: 'uniCheckboxgroup',
		    		padding: '0 0 0 0',
		    		fieldLabel: ' ',
		    		id: 'ZERO_CK',
		    		items: [{
		    			boxLabel: '<t:message code="system.label.inventory.systemqtyzeroexcept" default="전산수량 0제외"/>',
		    			width: 120,
		    			name: 'BOOK_ZERO',
		    			inputValue: 'Y'
		    		},{
		    			boxLabel: '<t:message code="system.label.inventory.stockcountingqtyzeroexcept" default="실사수량 0제외"/>',
		    			width: 120,
		    			name: 'CONT_ZERO',
		    			inputValue: 'Y'
		    		}]
		        },{
					fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
					name: 'ITEM_LEVEL1' ,
					xtype: 'uniCombobox' ,
					store: Ext.data.StoreManager.lookup('itemLeve1Store') ,
					child: 'ITEM_LEVEL2'
				},{
					fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
					name: 'ITEM_LEVEL2' ,
					xtype: 'uniCombobox' ,
					store: Ext.data.StoreManager.lookup('itemLeve2Store') ,
					child: 'ITEM_LEVEL3'
				},{
					fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
					name: 'ITEM_LEVEL3' ,
					xtype: 'uniCombobox' ,
					store: Ext.data.StoreManager.lookup('itemLeve3Store'),
		            parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
		            levelType:'ITEM'
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
					//this.mask();
	   			}
		  	} else {
  				this.unmask();
  			}
			return r;
  		}
	});//End of var masterForm = Unilite.createSearchForm('searchForm', {

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				value: '01',
				child:'WH_CODE',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
				name:'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('WH_CODE', newValue);
					}
				}
			},
			Unilite.popup('COUNT_DATE', {
				fieldLabel: '<t:message code="system.label.inventory.stockcountingdate" default="실사일"/>',
				colspan: 2,
				//fieldStyle: 'text-align: center;',
				allowBlank: false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							var countDATE = UniDate.getDbDateStr(records[0]['COUNT_DATE']).substring(0, 8);
							countDATE = countDATE.substring(0,4) + '.' + countDATE.substring(4,6) + '.' + countDATE.substring(6,8);
							panelResult.setValue('COUNT_DATE', countDATE);
							masterForm.setValue('COUNT_DATE', panelResult.getValue('COUNT_DATE'));
							panelResult.setValue('WH_CODE', records[0]['WH_CODE']);
							masterForm.setValue('WH_CODE', panelResult.getValue('WH_CODE'));
							panelResult.setValue('COUNT_DATE2', records[0]['COUNT_CONT_DATE']);
							masterForm.setValue('COUNT_DATE2', panelResult.getValue('COUNT_DATE2'));
						},
						scope: this
					},
					onClear: function(type)	{
						masterForm.setValue('COUNT_DATE', '');
						masterForm.setValue('WH_CODE', '');
						masterForm.setValue('COUNT_DATE2', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						popup.setExtParam({'WH_CODE': panelResult.getValue('WH_CODE')});
					}
				}
			}),{
				fieldLabel: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',
				name:'ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{
		        	fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
		        	valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
					autoPopup: true,
		        	listeners: {
						onSelected: {
							fn: function(records, type) {
								masterForm.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
								masterForm.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
							},
							scope: this
						},
						onClear: function(type)	{
							masterForm.setValue('ITEM_CODE', '');
							masterForm.setValue('ITEM_NAME', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
					}
		   }),{
				fieldLabel: '<t:message code="system.label.inventory.stockcountingapplydate" default="실사반영일"/>',
				name: 'COUNT_DATE2',
				xtype: 'uniDatefield',
				readOnly: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							masterForm.setValue('COUNT_DATE2', newValue);
						}
					}
			},{
			    xtype: 'radiogroup',
			    fieldLabel: '<t:message code="system.label.inventory.differenceqty" default="차이수량"/></br><t:message code="system.label.inventory.viewyn" default="조회여부"/>',
			    items : [{
			    	boxLabel: '<t:message code="system.label.inventory.yes" default="예"/>',
			    	name: 'DIFF_YN',
			    	inputValue: 'Y',
			    	width:80
			    }, {
			    	boxLabel: '<t:message code="system.label.inventory.no" default="아니오"/>',
			    	name: 'DIFF_YN' ,
			    	inputValue: 'N',
			    	width:80,
			    	checked: true
			    }],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.getField('DIFF_YN').setValue(newValue.DIFF_YN);
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
	   					var labelText = invalid.items[0]['fieldLabel']+' : ';
	   				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   					var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
	   				}
			   		alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					//this.mask();
	   			}
		  	} else {
  				this.unmask();
  			}
			return r;
  		}
	});

	Unilite.defineModel('S_biv120ukrv_ypModel', {		// 메인
		fields: [
			{name: 'COMP_CODE'			  		     , text: '<t:message code="system.label.inventory.companycode" default="법인코드"/>'			, type: 'string'},
			{name: 'DIV_CODE'			  		     , text: '<t:message code="system.label.inventory.division" default="사업장"/>'			, type: 'string'},
			{name: 'WH_CODE'			  		     , text: '<t:message code="system.label.inventory.warehouse" default="창고"/>'			, type: 'string'},
			{name: 'COUNT_DATE'			  		     , text: '<t:message code="system.label.inventory.stockcountingdate" default="실사일"/>'			, type: 'uniDate'},
			{name: 'ITEM_ACCOUNT'		  		     , text: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>'			, type: 'string', comboType:'AU', comboCode:'B020'},
			{name: 'ITEM_LEVEL1'		  		     , text: '<t:message code="system.label.inventory.large" default="대"/>'				, type: 'string'},
			{name: 'ITEM_LEVEL2'		  		     , text: '<t:message code="system.label.inventory.middle" default="중"/>'				, type: 'string'},
			{name: 'ITEM_LEVEL3'		  		     , text: '<t:message code="system.label.inventory.small" default="소"/>'				, type: 'string'},
			{name: 'ITEM_LEVEL_NAME1'		  		 , text: '<t:message code="system.label.inventory.large" default="대"/>'				, type: 'string'},
			{name: 'ITEM_LEVEL_NAME2'		  		 , text: '<t:message code="system.label.inventory.middle" default="중"/>'				, type: 'string'},
			{name: 'ITEM_LEVEL_NAME3'		  		 , text: '<t:message code="system.label.inventory.small" default="소"/>'				, type: 'string'},
			{name: 'ITEM_CODE'			  		     , text: '<t:message code="system.label.inventory.item" default="품목"/>'			, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'			  		     , text: '<t:message code="system.label.inventory.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'				  		     , text: '<t:message code="system.label.inventory.spec" default="규격"/>'				, type: 'string'},
			{name: 'STOCK_UNIT'			  		     , text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>'			, type: 'string', displayField: 'value'},
			{name: 'UNIT_WGT'			  		     , text: '<t:message code="system.label.inventory.unitweight" default="단위중량"/>'			, type: 'string'},
			{name: 'WGT_UNIT'			  		     , text: '<t:message code="system.label.inventory.weightunit" default="중량단위"/>'			, type: 'string'},
			{name: 'WH_CELL_CODE'		  		     , text: '<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>'		, type: 'string'},
			{name: 'WH_CELL_NAME'		  		     , text: '<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>'			, type: 'string'},
			{name: 'LOT_NO'				  		     , text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>'			, type: 'string'},
			{name: 'GOOD_STOCK_BOOK_Q'	  		     , text: '<t:message code="system.label.inventory.good" default="양품"/>'				, type: 'uniQty'},
			{name: 'BAD_STOCK_BOOK_Q'	  		     , text: '<t:message code="system.label.inventory.defect" default="불량"/>'				, type: 'uniQty'},
			{name: 'GOOD_STOCK_BOOK_W'	  		     , text: '<t:message code="system.label.inventory.good" default="양품"/>'				, type: 'string'},
			{name: 'BAD_STOCK_BOOK_W'	  		     , text: '<t:message code="system.label.inventory.defect" default="불량"/>'				, type: 'string'},
			{name: 'GOOD_STOCK_Q'		  		     , text: '<t:message code="system.label.inventory.good" default="양품"/>'				, type: 'uniQty'/*, allowBlank: false*/},
			{name: 'BAD_STOCK_Q'		  		     , text: '<t:message code="system.label.inventory.defect" default="불량"/>'				, type: 'uniQty'},
			{name: 'GOOD_STOCK_W'		  		     , text: '<t:message code="system.label.inventory.good" default="양품"/>'				, type: 'string'},
			{name: 'BAD_STOCK_W'		  		     , text: '<t:message code="system.label.inventory.defect" default="불량"/>'				, type: 'string'},
			{name: 'COUNT_FLAG'			  		     , text: '<t:message code="system.label.inventory.processstatus" default="진행상태"/>'			, type: 'string'},
			{name: 'COUNT_CONT_DATE'	  		     , text: '<t:message code="system.label.inventory.applyyearmonth" default="반영년월"/>'			, type: 'uniDate'},
			{name: 'OVER_GOOD_STOCK_Q'			      		     , text: '<t:message code="system.label.inventory.good" default="양품"/>'				, type: 'uniQty'},
			{name: 'OVER_BAD_STOCK_Q'			      		     , text: '<t:message code="system.label.inventory.defect" default="불량"/>'				, type: 'uniQty'},
			{name: 'REMARK'			      		     , text: '<t:message code="system.label.inventory.remarks" default="비고"/>'				, type: 'string'},
			{name: 'UPDATE_DB_USER'		  		     , text: '<t:message code="system.label.inventory.writer" default="작성자"/>'				, type: 'string'},
			{name: 'UPDATE_DB_TIME'		  		     , text: '<t:message code="system.label.inventory.writtentiem" default="작성시간"/>'			, type: 'uniDate'},
			{name: 'GOOD_STOCK_BOOK_I'	  		     , text: '<t:message code="system.label.inventory.systeminventoryamount" default="전산재고금액"/>'			, type: 'uniQty'},
			{name: 'GOOD_STOCK_I'	  		     , text: '<t:message code="system.label.inventory.stockcountinginventoryamount" default="실사재고금액"/>'			, type: 'uniQty'},
			{name: 'CUSTOM_CODE'	  		     , text: '거래처코드'			, type: 'string'},
			{name: 'CUSTOM_NAME'	  		     , text: '거래처명'			, type: 'string'}
		]
	});//End of Unilite.defineModel('S_biv120ukrv_ypModel', {

   /**
    * Store 정의(Service 정의)
    * @type
    */
	var directMasterStore1 = Unilite.createStore('s_biv120ukrv_ypMasterStore1',{		// 메인
		model: 'S_biv120ukrv_ypModel',
		uniOpt: {
			isMaster: true,		// 상위 버튼 연결
            editable: true,		// 수정 모드 사용
            deletable: true,	// 삭제 가능 여부
	        useNavi : false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
        proxy: directProxy,
		loadStoreRecords: function() {
			var param= masterForm.getValues();
			/*var cOUNTdATE = masterForm.getValue('COUNT_DATE').replace('.','');
			param.COUNT_DATE = cOUNTdATE;	*/
			console.log(param);
			this.load({
				params : param
			});

		},
		listeners: {
			load: function(store, records, successful, eOpts) {
           	  if(!Ext.isEmpty(records[0])){
           		if(records[0].get('REF_CODE1') == 'Y'){
           			masterGrid.getColumn("WH_CELL_CODE").setHidden(false);
           			masterGrid.getColumn("WH_CELL_NAME").setHidden(false);
           		}else{masterGrid.getColumn("WH_CELL_CODE").setHidden(true);
       			masterGrid.getColumn("WH_CELL_NAME").setHidden(true);
       			}

           	  }
          	if(directMasterStore1.getCount() > 0){
				UniAppManager.setToolbarButtons(['deleteAll'], true);
			}
			}
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
       		console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);

			/*var orderNum = masterForm.getValue('ORDER_NUM');
			Ext.each(list, function(record, index) {
				if(record.data['ORDER_NUM'] != orderNum) {
					record.set('ORDER_NUM', orderNum);
				}
			})*/
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
						/*var master = batch.operations[0].getResultSet();
						masterForm.setValue("ORDER_NUM", master.ORDER_NUM);*/
						//3.기타 처리
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('s_biv120ukrv_ypGrid1');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});	//End of var directMasterStore1 = Unilite.createStore('s_biv120ukrv_ypMasterStore1',{

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
	var masterGrid = Unilite.createGrid('s_biv120ukrv_ypGrid1', {
       // for tab
		layout : 'fit',
        region:'center',
    	uniOpt: {
			expandLastColumn: true,
		 	useRowNumberer: false,
		 	useContextMenu: true
        },
    	store: directMasterStore1,
        features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	    {id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false}
    	],
		columns: [
			{dataIndex: 'COMP_CODE'			  			, width:66,hidden: true },
			{dataIndex: 'DIV_CODE'			  			, width:80,hidden: true },
			{dataIndex: 'WH_CODE'			  			, width:80,hidden: true },
			{dataIndex: 'COUNT_DATE'			  		, width:80,hidden: true },
			{dataIndex: 'ITEM_ACCOUNT'		  			, width:120 },
			{text: '<t:message code="system.label.inventory.itemgroup" default="품목분류"/>',
				columns:[
					{dataIndex: 'ITEM_LEVEL1'		  			, width:100 },
					{dataIndex: 'ITEM_LEVEL2'		  			, width:100 },
					{dataIndex: 'ITEM_LEVEL3'		  			, width:100 },
					{dataIndex: 'ITEM_LEVEL_NAME1'		  		, width:100, hidden: true},
					{dataIndex: 'ITEM_LEVEL_NAME2'		  		, width:100, hidden: true},
					{dataIndex: 'ITEM_LEVEL_NAME3'		  		, width:100, hidden: true}
				]
			},

			{dataIndex: 'ITEM_CODE'			        ,   width: 110,
				editor: Unilite.popup('DIV_PUMOK_G', {
				 	 				textFieldName: 'ITEM_CODE',
				 	 				DBtextFieldName: 'ITEM_CODE',
				 	 				extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
									autoPopup: true,
					 				listeners: {'onSelected': {
														fn: function(records, type) {
											                    console.log('records : ', records);
											                    Ext.each(records, function(record,i) {
																        			if(i==0) {
																								masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
																		        			} else {
																		        				UniAppManager.app.onNewDataButtonDown();
																		        				masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
																		        			}
																});
														},
														scope: this
												},
												'onClear': function(type) {
													masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
												}
										}
					 })
			},
			{dataIndex: 'ITEM_NAME'			        ,   width: 160,
				editor: Unilite.popup('DIV_PUMOK_G', {
			 		  				extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
									autoPopup: true,
									listeners: {'onSelected': {
														fn: function(records, type) {
											                    console.log('records : ', records);
											                    Ext.each(records, function(record,i) {
																        			if(i==0) {
																								masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
																		        			} else {
																		        				UniAppManager.app.onNewDataButtonDown();
																		        				masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
																		        			}
																});
														},
														scope: this
												},
												'onClear': function(type) {
													masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
												}
										}
					})
			},
			{dataIndex: 'SPEC'				  			, width:150 },
			{dataIndex: 'STOCK_UNIT'			  		, width:100, displayField: 'value' },
			{dataIndex: 'UNIT_WGT'			  			, width:100,hidden: true },
			{dataIndex: 'WGT_UNIT'			  			, width:80,hidden: true },
			{dataIndex: 'WH_CELL_CODE'		  			, width:100,hidden: true },
			{dataIndex: 'WH_CELL_NAME'		  			, width:80,hidden: true },
			{dataIndex: 'LOT_NO'				  		, width:120},
			{dataIndex: 'CUSTOM_CODE'				  		, width:100},
			{dataIndex: 'CUSTOM_NAME'				  		, width:150},
			{text:'<t:message code="system.label.inventory.systemqty" default="전산수량"/>',
				columns:[
					{dataIndex: 'GOOD_STOCK_BOOK_Q'	  			, width:80 },
					{dataIndex: 'BAD_STOCK_BOOK_Q'	  			, width:80,hidden: true }
				]
			},
			{dataIndex: 'GOOD_STOCK_BOOK_I'				, width:120},
			{dataIndex: 'GOOD_STOCK_BOOK_W'	  			, width:80,hidden: true },
			{dataIndex: 'BAD_STOCK_BOOK_W'	  			, width:80,hidden: true },
			{text:'<t:message code="system.label.inventory.stockcountingqty" default="실사수량"/>',
				columns:[
					{dataIndex: 'GOOD_STOCK_Q'		  			, width:80 },
					{dataIndex: 'BAD_STOCK_Q'		  			, width:80,hidden: true }
				]
			},
			{dataIndex: 'GOOD_STOCK_I'				    , width:120},
			{dataIndex: 'GOOD_STOCK_W'		  			, width:80,hidden: true },
			{dataIndex: 'BAD_STOCK_W'		  			, width:80,hidden: true },
			{dataIndex: 'COUNT_FLAG'			  		, width:80,hidden: true },
			{dataIndex: 'COUNT_CONT_DATE'	  			, width:80,hidden: true },
			{text:'<t:message code="system.label.inventory.shortage" default="과부족"/>',
				columns:[
					{dataIndex: 'OVER_GOOD_STOCK_Q'		  			, width:80 },
					{dataIndex: 'OVER_BAD_STOCK_Q'		  			, width:80}
				]
			},
			{dataIndex: 'REMARK'			      		, width:200 },
			{dataIndex: 'UPDATE_DB_USER'		  		, width:80,hidden: true },
			{dataIndex: 'UPDATE_DB_TIME'		  		, width:80,hidden: true }
		],

		listeners: {
	        beforeedit  : function( editor, e, eOpts ) {
	        	if(e.record.phantom == false) {
	        		if(UniUtils.indexOf(e.field, ['GOOD_STOCK_Q', 'BAD_STOCK_Q', 'REMARK']))
					{
						return true;
      				} else {
      					return false;
      				}
	        	} else {
	        		if(UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME', 'GOOD_STOCK_Q', 'BAD_STOCK_Q', 'REMARK','LOT_NO']))
				   	{
						return true;
      				} else {
      					return false;
      				}
	        	}
	        }
		},

		////품목정보 팝업에서 선택된 데이타가 그리드에 추가되는 함수, 품목팝업의 onSelected/onClear 이벤트가 일어날때 호출됨
		setItemData: function(record, dataClear, grdRecord) {
       		//var grdRecord = this.getSelectedRecord();
       		if(dataClear) {
       			grdRecord.set('ITEM_ACCOUNT'			, "");
       			grdRecord.set('ITEM_LEVEL1'				, "");
       			grdRecord.set('ITEM_LEVEL2'				, "");
       			grdRecord.set('ITEM_LEVEL3'				, "");
       			grdRecord.set('ITEM_CODE'				, "");
       			grdRecord.set('ITEM_NAME'				, "");
       			grdRecord.set('SPEC'					, "");
       			grdRecord.set('STOCK_UNIT'				, "");
       			grdRecord.set('GOOD_STOCK_BOOK_Q'		, 0);
       			grdRecord.set('BAD_STOCK_BOOK_Q'		, 0);
       			grdRecord.set('GOOD_STOCK_Q'			, 0);
       			grdRecord.set('BAD_STOCK_Q'				, 0);
       			grdRecord.set('REMARK'					, "");

       		} else {
       			grdRecord.set('ITEM_ACCOUNT'			, record['ITEM_ACCOUNT']);
       			grdRecord.set('ITEM_LEVEL1'				, record['ITEM_LEVEL_NAME1']);
       			grdRecord.set('ITEM_LEVEL2'				, record['ITEM_LEVEL_NAME2']);
       			grdRecord.set('ITEM_LEVEL3'				, record['ITEM_LEVEL_NAME3']);
       			grdRecord.set('ITEM_CODE'				, record['ITEM_CODE']);
       			grdRecord.set('ITEM_NAME'				, record['ITEM_NAME']);
       			grdRecord.set('SPEC'					, record['SPEC']);
       			grdRecord.set('STOCK_UNIT'				, record['STOCK_UNIT']);
       			grdRecord.set('GOOD_STOCK_BOOK_Q'		, record['GOOD_STOCK_BOOK_']);
       			grdRecord.set('BAD_STOCK_BOOK_Q'		, record['BAD_STOCK_BOOK_Q']);
       			grdRecord.set('GOOD_STOCK_Q'			, record['GOOD_STOCK_Q']);
       			grdRecord.set('BAD_STOCK_Q'				, record['BAD_STOCK_Q']);
       			grdRecord.set('REMARK'					, record['REMARK']);

				//UniSales.fnStockQ(grdRecord, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'),  grdRecord.get('WH_CODE'));
       		}
		}
    });	//End of var masterGrid = Unilite.createGrid('s_biv120ukrv_ypGrid1', {

	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			masterForm
		],
		id: 's_biv120ukrv_ypApp',
		fnInitBinding: function() {
			masterForm.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
         	UniAppManager.setToolbarButtons('newData', false);
			this.setDefault();
		},
		onQueryButtonDown: function() {    	// 조회버튼 눌렀을떄
			if(masterForm.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			directMasterStore1.loadStoreRecords();
			UniAppManager.setToolbarButtons('newData', true);
		},
		setDefault: function() {		// 기본값
        	masterForm.setValue('DIV_CODE',UserInfo.divCode);
        	masterForm.getForm().wasDirty = false;
         	masterForm.resetDirtyStatus();
         	UniAppManager.setToolbarButtons(['save','deleteAll'], false);
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			masterForm.clearForm();
			panelResult.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
		/* 	panelResult.reset();
			masterForm.reset(); */
			this.fnInitBinding();
			masterForm.getField('WH_CODE').focus();
			panelResult.getField('WH_CODE').focus();
			directMasterStore1.clearData();
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			directMasterStore1.saveStore();
		},
		rejectSave: function() {	// 저장
			var rowIndex = masterGrid.getSelectedRowIndex();
			masterGrid.select(rowIndex);
			directMasterStore1.rejectChanges();

			if(rowIndex >= 0){
				masterGrid.getSelectionModel().select(rowIndex);
				var selected = masterGrid.getSelectedRecord();

				var selected_doc_no = selected.data['DOC_NO'];
  				bdc100ukrvService.getFileList(
					{DOC_NO : selected_doc_no},
					function(provider, response) {
					}
				);
			}
			directMasterStore1.onStoreActionEnable();
		},
		confirmSaveData: function(config)	{	// 저장하기전 원복 시키는 작업
			var fp = Ext.getCmp('s_biv120ukrv_ypFileUploadPanel');
        	if(masterStore.isDirty() || fp.isDirty()) {
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		onDeleteDataButtonDown: function() {	// 행삭제 버튼
			var selRow1 = masterGrid.getSelectedRecord();
			if(selRow1.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onDeleteAllButtonDown: function() {
			if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
				masterGrid.reset();
				UniAppManager.app.onSaveDataButtonDown('no');
				UniAppManager.app.onResetButtonDown();
			}
		},
		/*onDeleteAllButtonDown: function() {
				var records = directMasterStore1.data.items;
				var isNewData = false;
				Ext.each(records, function(record,i) {
					if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
						isNewData = true;
					}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
						if(confirm('전체삭제 하시겠습니까?')) {
							var deletable = true;
							---------삭제전 로직 구현 시작----------
							Ext.each(records, function(record,i) {
								if(BsaCodeInfo.gsInoutAutoYN == "N" && record.get('ACCOUNT_Q') > 0) {//동시매출발생이 아닌 경우,매출존재체크 제외
									alert(Msg.sMS335);	//매출이 진행된 건은 수정/삭제할 수 없습니다.
									deletable = false;
									return false;
								}
								if(record.get('SALE_C_YN') == "Y"){
									alert(Msg.sMS214);	//계산서가 마감된 건은 수정/삭제가 불가능합니다.
									deletable = false;
									return false;
								}
							});
							---------삭제전 로직 구현 끝----------

							if(deletable){
								detailGrid.reset();
								UniAppManager.app.onSaveDataButtonDown();
							}
							isNewData = false;
						}
						return false;
					}
				});
				if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
					detailGrid.reset();
					UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
				}

		},*/
		onNewDataButtonDown: function()	{		// 행추가
			var compCode 	= UserInfo.compCode;
			var divCode 	= masterForm.getValue('DIV_CODE');
			var whCode 		= masterForm.getValue('WH_CODE');
			var whCellCode  = masterForm.getValue('WH_CELL_CODE');
			var countDate	= masterForm.getValue('COUNT_DATE');

			var r = {
				COMP_CODE:  compCode,
				DIV_CODE: 	divCode,
				WH_CODE: 	whCode,
				COUNT_DATE:	countDate
			};
			masterGrid.createRow(r);
			masterForm.setAllFieldsReadOnly(true);
			UniAppManager.setToolbarButtons(['deleteAll'], true);
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		}
	});//End of Unilite.Main( {

	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "GOOD_STOCK_Q" :
					if(newValue < 0) {
						rv= Msg.sMB076;
					}else{
						record.set('OVER_GOOD_STOCK_Q', (record.get('GOOD_STOCK_BOOK_Q')  - newValue) * -1 );
					}
					break;

				case "BAD_STOCK_Q" :
					if(newValue < 0) {
						rv= Msg.sMB076;
					}else{
						record.set('OVER_BAD_STOCK_Q', (record.get('BAD_STOCK_BOOK_Q')  - newValue) * -1 );
					}
					break;

				case "GOOD_STOCK_W" :
					if(newValue < 0) {
						rv= Msg.sMB076;
					}
					break;

				case "BAD_STOCK_W" :
					if(newValue < 0) {
						rv= Msg.sMB076;
					}
					break;
			}
			return rv;
		}
	});
};

</script>