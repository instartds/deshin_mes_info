<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pms500ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="Q024" /> <!-- 검사담당 -->
	<t:ExtComboStore comboType="AU" comboCode="H004" /> <!-- 근무조 -->
	<t:ExtComboStore comboType="AU" comboCode="Q007" /> <!-- 검사유형 -->
	<t:ExtComboStore comboType="AU" comboCode="M414" /> <!-- 합격여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A" /> 	<!-- 창고 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" /> <!-- 입고담당 -->
	<t:ExtComboStore comboType="WU" />        <!-- 작업장-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var SearchInfoWindow; // 검색창
var CheckWindow; // 검사참조

function appMain() {  
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'pms500ukrvService.selectMaster',
			update: 'pms500ukrvService.updateDetail',
			create: 'pms500ukrvService.insertDetail',
			destroy: 'pms500ukrvService.deleteDetail',
			syncAll: 'pms500ukrvService.saveAll'
		}
	});
	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'pms500ukrvService.selectMaster2',
			update: 'pms500ukrvService.updateDetail',
			create: 'pms500ukrvService.insertDetail',
			destroy: 'pms500ukrvService.deleteDetail',
			syncAll: 'pms500ukrvService.saveAll'
		}
	});
	
	Unilite.defineModel('pms500ukrvModel', {		// 검증내역
	    fields: [  	 
	    	{name:'VERIFY_SEQ'       		,text: '<t:message code="system.label.product.seq" default="순번"/>'			,type:'string'},
			{name:'VERIFY_DATE'    			,text: '<t:message code="system.label.product.inspecdate" default="검사일"/>'			,type:'string'},
			{name:'TIME_GUBUN'       		,text: '<t:message code="system.label.product.daynightclass" default="주야구분"/>'		,type:'string'},
			{name:'INCH'             		,text: 'inch'			,type:'string'},
			{name:'INSPEC_PRSN'      		,text: '<t:message code="system.label.product.inspector" default="검사자"/>'			,type:'string'},
			{name:'ITEM_CODE'        		,text: '<t:message code="system.label.product.item" default="품목"/>'		,type:'string'},
			{name:'ITEM_NAME'        		,text: '<t:message code="system.label.product.itemname" default="품목명"/>'			,type:'string'},
			{name:'SPEC'             		,text: '원단명'			,type:'string'},
			{name:'ITEM_MAKER_NAME'			,text: '원단사'			,type:'string'},
			{name:'CUSTOM_NAME'      		,text: '고객사명'		,type:'string'},
			{name:'INSPEC_Q'         		,text: 'LOT수량'		,type:'string'},
			{name:'VERIFY_Q'         		,text: '샘플량'			,type:'string'},
			{name:'BAD_VERIFY_Q'     		,text: '부적합수량'		,type:'string'},
			{name:'BAD_PPM'          		,text: '부적합율(ppm)'	,type:'string'},
			{name:'VERIFY_PRSN'      		,text: '검증담당자'		,type:'string'},
			{name:'RAW_LOT_NO'       		,text: '원단LOT NO'		,type:'string'},
			{name:'OUT_LOT_NO'       		,text: '출하LOT NO'		,type:'string'}
		]            
	});
	
	Unilite.defineModel('pms500ukrvModel2', {		// 검증내역2
	    fields: [  	 
	    	{name: 'BAD_INSPEC_CODE'		,text: '<t:message code="system.label.product.defectcode" default="불량코드"/>'		,type:'string'},
			{name: 'BAD_INSPEC_NAME'		,text: '<t:message code="system.label.product.defectcodename" default="불량코드명"/>'			,type:'string'},
			{name: 'BAD_VERIFY_Q'   		,text: '<t:message code="system.label.product.defectinspecqty" default="불량검사량"/>'			,type:'string'},
			{name: 'VERIFY_REMARK'  		,text: '<t:message code="system.label.product.inspeccontents" default="검사내용"/>'			,type:'string'},
			{name: 'MANAGE_REMARK'  		,text: '<t:message code="system.label.product.actioncontents" default="조치내용"/>'			,type:'string'}
		]
	});
	
	Unilite.defineModel('pms500ukrvModel4', {		// 검색팝업
	    fields: [  	 
	    	{name: 'VERIFY_NUM'				,text: '<t:message code="system.label.product.verificationinspecno" default="검증검사번호"/>'			,type:'string'},
	    	{name: 'VERIFY_SEQ'				,text: '<t:message code="system.label.product.seq" default="순번"/>'					,type:'string'},
	    	{name: 'VERIFY_DATE'			,text: '<t:message code="system.label.product.inspecdate" default="검사일"/>'				,type:'uniDate'},
	    	{name: 'ITEM_CODE'				,text: '<t:message code="system.label.product.item" default="품목"/>'				,type:'string'},
	    	{name: 'ITEM_NAME'				,text: '<t:message code="system.label.product.itemname" default="품목명"/>'				,type:'string'},
	    	{name: 'SPEC'					,text: '원단명'				,type:'string'},
	    	{name: 'VERIFY_Q'				,text: '<t:message code="system.label.product.inspecqty" default="검사량"/>'				,type:'uniQty'},
	    	{name: 'GOOD_VERIFY_Q'			,text: '적합수량'				,type:'uniQty'},
	    	{name: 'BAD_VERIFY_Q'			,text: '부적합수량'				,type:'uniQty'},
	    	{name: 'VERIFY_PRSN'			,text: '<t:message code="system.label.product.inspecchargeperson" default="검사담당자"/>'				,type:'string'},
	    	{name: 'OUT_LOT_NO'				,text: '출하LOT NO'			,type:'string'},
	    	{name: 'PROJECT_NO'				,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'				,type:'string'},
	    	{name: 'PJT_CODE'				,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'			,type:'string'}
		]
	});
	
	Unilite.defineModel('pms500ukrvModel3', {		// 검사참조
	    fields: [  	 
	    	{name: 'CHK'					,text: '<t:message code="system.label.product.selection" default="선택"/>'			,type:'string'},
			{name: 'ITEM_CODE'				,text: '<t:message code="system.label.product.item" default="품목"/>'		,type:'string'},
			{name: 'ITEM_NAME'				,text: '<t:message code="system.label.product.itemname" default="품목명"/>'			,type:'string'},
			{name: 'SPEC'					,text: '원단명'			,type:'string'},
			{name: 'CUSTOM_CODE'			,text: '고객사'			,type:'string'},
			{name: 'INSPEC_DATE'			,text: '<t:message code="system.label.product.inspecdate" default="검사일"/>'			,type:'string'},
			{name: 'INSPEC_Q'				,text: '<t:message code="system.label.product.inspecqty" default="검사량"/>'			,type:'string'},
			{name: 'GOOD_INSPEC_Q'			,text: '<t:message code="system.label.product.gooditemqty" default="양품량"/>'		,type:'string'},
			{name: 'BAD_INSPEC_Q'			,text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'		,type:'string'},
			{name: 'INSPEC_PRSN'   			,text: '<t:message code="system.label.product.inspecchargeperson" default="검사담당자"/>'		,type:'string'},
			{name: 'INSPEC_NUM'				,text: '<t:message code="system.label.product.receiptno" default="접수번호"/>'		,type:'string'},
			{name: 'INSPEC_SEQ'				,text: '<t:message code="system.label.product.receiptseq" default="접수순번"/>'		,type:'string'},
			{name: 'LOT_NO'					,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'			,type:'string'}
		]
	});
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('pms500ukrvMasterStore1',{		// 검증내역
		model: 'pms500ukrvModel',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var directMasterStore2 = Unilite.createStore('pms500ukrvMasterStore2',{		// 검증내역2
		model: 'pms500ukrvModel2',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy2,
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {	// 검색 팝업창
			model: 'pms500ukrvModel4',
            autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable:false,			// 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                	read: 'pms500ukrvService.selectList'
                }
            },
            loadStoreRecords: function() {
			var param= orderNoSearch.getValues();
			console.log(param);
			this.load({
				params : param
			});
		}
	});
	
	var otherOrderStore = Unilite.createStore('pms500ukrvMasterStore3',{		// 검사참조
		model: 'pms500ukrvModel3',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false				// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
                read: 'pms500ukrvService.selectList3'                	
            }
        },
        loadStoreRecords : function()	{
			var param= otherOrderSearch.getValues();			
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
	var panelSearch = Unilite.createSearchPanel('searchForm',{		// 검증내역
		collapsed: UserInfo.appOption.collapseLeftSearch,
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
    	defaultType: 'uniSearchSubPanel',
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
		        comboType:'BOR120' ,
		        allowBlank:false,
			    value: UserInfo.divCode,
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			      		panelResult.setValue('DIV_CODE', newValue);
			     	}
			    }
		    },{
				fieldLabel: '검증검사일',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_DATE',
				endFieldName: 'TO_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_DATE',newValue);
                	}   
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_DATE',newValue);
			    	}   	
			    } 
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType: 'WU',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			      		panelResult.setValue('WORK_SHOP_CODE', newValue);
			     	}
			    }
			},
			{
				fieldLabel: '<t:message code="system.label.product.verificationinspecno" default="검증검사번호"/>',
				name: 'VERIFY_NUM',
				xtype: 'uniTextfield',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			      		panelResult.setValue('VERIFY_NUM', newValue);
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
		      		//this.mask();
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
		    	//this.unmask();
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
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
	    items: [{	
	    	xtype:'container',
	    	padding:'0 5 5 5',
	        defaultType: 'uniTextfield',
	        layout: {type: 'uniTable', columns : 4},
	        items:[{
			        fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
			        name:'DIV_CODE', 
			        xtype: 'uniCombobox', 
			        comboType:'BOR120' ,
			        allowBlank:false,
				    value: UserInfo.divCode,
				    listeners: {
				    	change: function(field, newValue, oldValue, eOpts) {      
				      		panelSearch.setValue('DIV_CODE', newValue);
				     	}
				    }
			    },{
					fieldLabel: '검증검사일',
					xtype: 'uniDateRangefield',
					startFieldName: 'FR_DATE',
					endFieldName: 'TO_DATE',
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today'),
					width: 315,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelSearch.setValue('FR_DATE',newValue);
	                	}   
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelSearch.setValue('TO_DATE',newValue);
				    	}   	
				    } 
				},{
					fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
					name: 'WORK_SHOP_CODE',
					xtype: 'uniCombobox',
					comboType: 'WU',
				    listeners: {
				    	change: function(field, newValue, oldValue, eOpts) {      
				      		panelSearch.setValue('WORK_SHOP_CODE', newValue);
				     	}
				    }
				},
				{
					fieldLabel: '<t:message code="system.label.product.verificationinspecno" default="검증검사번호"/>',
					name: 'VERIFY_NUM',
					xtype: 'uniTextfield',
				    listeners: {
				    	change: function(field, newValue, oldValue, eOpts) {      
				      		panelSearch.setValue('VERIFY_NUM', newValue);
				     	}
				    }
				}
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
		          		var labelText = invalid.items[0]['fieldLabel']+' : ';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
		        	}
					alert(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		//this.mask();
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
		    	//this.unmask();
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
    
    var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {		// 검색 팝업창
		layout: {type: 'uniTable', columns : 2},
	    trackResetOnLoad: true,
	    items: [{
		        fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
		        name:'DIV_CODE', 
		        xtype: 'uniCombobox', 
		        comboType:'BOR120' ,
		        allowBlank:false,
			    value: UserInfo.divCode
		    },{
				fieldLabel: '<t:message code="system.label.product.inspecdate" default="검사일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_DATE',
				endFieldName: 'TO_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315
			},
			Unilite.popup('DIV_PUMOK',{ 
	        	fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
	        	valueFieldName: 'ITEM_CODE', 
				textFieldName: 'ITEM_NAME'
	   		}),{
				fieldLabel: 'LOT번호',
				name: 'LOT_NO',
				xtype: 'uniTextfield'
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType: 'WU'
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
		    	//this.unmask();
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
  	}); // createSearchForm
    
    var otherOrderSearch = Unilite.createSearchForm('otherorderForm', {		//검사 참조
    	layout: {type : 'uniTable', columns : 3},
        items: [{
		        fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
		        name:'DIV_CODE', 
		        xtype: 'uniCombobox', 
		        comboType:'BOR120' ,
		        allowBlank:false,
			    value: UserInfo.divCode
		    },{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType: 'WU',
				colspan: 2
			},{ 
		        fieldLabel: '<t:message code="system.label.product.inspecdate" default="검사일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_DATE',
				endFieldName: 'TO_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315
			},
			Unilite.popup('DIV_PUMOK',{ 
	        	fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
	        	valueFieldName: 'ITEM_CODE', 
				textFieldName: 'ITEM_NAME',
				colspan: 2
		   }),{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType: 'WU'
			},{
				fieldLabel: '<t:message code="system.label.product.lotno" default="LOT번호"/>',
				name: 'LOT_NO',
				xtype: 'uniTextfield'
			},{
				fieldLabel: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>',
				name: 'PROJECT_NO',
				xtype: 'uniTextfield'
			}
		]
    });
	        
	/**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid1 = Unilite.createGrid('pms500ukrvGrid1', {		// 검증내역
    	layout : 'fit',
    	region:'center',
        store : directMasterStore1, 
        uniOpt:{	expandLastColumn: false,
        			useRowNumberer: false,
                    useMultipleSorting: true
        },
        tbar: [{
			xtype: 'splitbutton',
           	itemId:'orderTool',
			text: '<t:message code="system.label.product.reference" default="참조..."/>',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'CheckBtn',
					text: '검사 참조',
					handler: function() {
						openCheckWindow();
					}
				}]
			})
		}],
    	features: [ 
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: false} 
    	],
        columns: [        			 	
			{dataIndex: 'VERIFY_SEQ'       		, width: 40  }, 												
			{dataIndex: 'VERIFY_DATE'      		, width: 73 	 },
			{dataIndex: 'TIME_GUBUN'       		, width: 66  },
			{dataIndex: 'INCH'              	, width: 60  }, 								
			{dataIndex: 'INSPEC_PRSN'      		, width: 80  }, 
			{dataIndex: 'ITEM_CODE'        		, width: 80  }, 												
			{dataIndex: 'ITEM_NAME'        		, width: 146 },
			{dataIndex: 'SPEC'             		, width: 146},
			{dataIndex: 'ITEM_MAKER_NAME'   	, width: 100}, 								
			{dataIndex: 'CUSTOM_NAME'      		, width: 100},
			{dataIndex: 'INSPEC_Q'         		, width: 93},
			{dataIndex: 'VERIFY_Q'          	, width: 80}, 								
			{dataIndex: 'BAD_VERIFY_Q'     		, width: 80}, 
			{dataIndex: 'BAD_PPM'          		, width: 100}, 												
			{dataIndex: 'VERIFY_PRSN'      		, width: 80},
			{dataIndex: 'RAW_LOT_NO'       		, width: 100},
			{dataIndex: 'OUT_LOT_NO'        	, width: 100}
		] 
    });
    
    var masterGrid2 = Unilite.createGrid('pms500ukrvGrid2', {		// 검증내역2
    	layout : 'fit',
    	region:'south',
        store : directMasterStore2, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
    	store: directMasterStore2,
    	features: [ 
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: false} 
    	],
        columns: [        				
			{dataIndex: 'BAD_INSPEC_CODE'		, width: 66}, 							
			{dataIndex: 'BAD_INSPEC_NAME'		, width: 100}, 							
			{dataIndex: 'BAD_VERIFY_Q'    		, width: 100}, 								
			{dataIndex: 'VERIFY_REMARK'  		, width: 266}, 												
			{dataIndex: 'MANAGE_REMARK'  		, width: 500}
		] 
    });
    
    var orderNoMasterGrid = Unilite.createGrid('btr120ukrvOrderNoMasterGrid', {	// 검색팝업창
        // title: '기본',
        layout : 'fit',       
		store: orderNoMasterStore,
		uniOpt:{
			useRowNumberer: false
		},
        columns:  [ 
        	{ dataIndex: 'VERIFY_NUM'				,  width: 106},
        	{ dataIndex: 'VERIFY_SEQ'				,  width: 33},
        	{ dataIndex: 'VERIFY_DATE'			   	,  width: 80},
        	{ dataIndex: 'ITEM_CODE'				,  width: 80},
        	{ dataIndex: 'ITEM_NAME'				,  width: 146},
        	{ dataIndex: 'SPEC'					   	,  width: 100},
        	{ dataIndex: 'VERIFY_Q'				   	,  width: 73},
        	{ dataIndex: 'GOOD_VERIFY_Q'			,  width: 73},
        	{ dataIndex: 'BAD_VERIFY_Q'			   	,  width: 73},
        	{ dataIndex: 'VERIFY_PRSN'			   	,  width: 73},
        	{ dataIndex: 'OUT_LOT_NO'				,  width: 106},
        	{ dataIndex: 'PROJECT_NO'				,  width: 100}
//        	{ dataIndex: 'PJT_CODE'				   	,  width: 100}
        ],
        listeners: {	
       		onGridDblClick:function(grid, record, cellIndex, colName) {
  				orderNoMasterGrid.returnData(record);
		       	UniAppManager.app.onQueryButtonDown();
		       	SearchInfoWindow.hide();
          		//UniAppManager.setToolbarButtons('save', true);
  			}
        },
        returnData: function(record)   {
            if(Ext.isEmpty(record))	{
          		record = this.getSelectedRecord();
          	}
          	/*panelSearch.setValues({'DIV_CODE':record.get('DIV_CODE')});
          	panelSearch.setValues({'DEPT_CODE':record.get('DEPT_CODE')});
          	panelSearch.setValues({'DEPT_NAME':record.get('DEPT_NAME')});
          	panelResult.setValues({'DEPT_CODE':record.get('DEPT_CODE')});
          	panelResult.setValues({'DEPT_NAME':record.get('DEPT_NAME')});
          	panelSearch.setValues({'WH_CODE':record.get('WH_CODE')});
          	panelSearch.setValues({'INOUT_DATE':record.get('INOUT_DATE')});
          	panelSearch.setValues({'INOUT_NUM':record.get('INOUT_NUM')});
          	panelSearch.setValues({'INOUT_PRSN':record.get('INOUT_PRSN')});*/
        }   
    });
    
    var otherOrderGrid = Unilite.createGrid('pms500ukrvGrid3', {		// 검사참조
    	// title: '기본',
        layout : 'fit',
    	store: otherOrderStore,
    	selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }), 
		uniOpt:{
	       	onLoadSelectFirst : false
	    },
        columns: [        				
			{dataIndex: 'CHK'					, width: 33}, 							
			{dataIndex: 'ITEM_CODE'				, width: 93}, 							
			{dataIndex: 'ITEM_NAME'		 		, width: 120}, 								
			{dataIndex: 'SPEC'					, width: 120}, 												
			{dataIndex: 'CUSTOM_CODE'			, width: 120}, 							
			{dataIndex: 'INSPEC_DATE'			, width: 80}, 							
			{dataIndex: 'INSPEC_Q'		 		, width: 86}, 								
			{dataIndex: 'GOOD_INSPEC_Q'			, width: 86}, 	
			{dataIndex: 'BAD_INSPEC_Q'			, width: 86}, 							
			{dataIndex: 'INSPEC_PRSN'   		, width: 86}, 							
			{dataIndex: 'INSPEC_NUM'		 	, width: 93}, 								
			{dataIndex: 'INSPEC_SEQ'			, width: 66}, 												
			{dataIndex: 'LOT_NO'				, width: 93}
		] 
    });
    
    function openSearchInfoWindow() {	//검색팝업창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '<t:message code="system.label.product.verificationinspecno" default="검증검사번호"/>',
                width: 830,				                
                height: 580,
                layout: {type:'vbox', align:'stretch'},	                
                items: [orderNoSearch, orderNoMasterGrid], 
                tbar:  ['->',
					{itemId : 'saveBtn',
					text: '<t:message code="system.label.product.inquiry" default="조회"/>',
					handler: function() {
						orderNoMasterStore.loadStoreRecords();
					},
					disabled: false
					}, {
						itemId : 'OrderNoCloseBtn',
						text: '<t:message code="system.label.product.close" default="닫기"/>',
						handler: function() {
							SearchInfoWindow.hide();
						},
						disabled: false
					}
				],
				listeners: {beforehide: function(me, eOpt)
					{
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();	                							
                	},
                	beforeclose: function( panel, eOpts ) {
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
       	 			},
                	beforeshow: function( panel, eOpts )	{
                		/*field = orderNoSearch.getField('INOUT_PRSN');
                		field.fireEvent('changedivcode', field, panelSearch.getValue('DIV_CODE'), null, null, "DIV_CODE");*/
                	}
                }		
			})
		}
		SearchInfoWindow.show();
    }
    
    function openCheckWindow() {    	// 검사참조  		
  		//otherOrderStore.loadStoreRecords();
  		if(!CheckWindow) {
			CheckWindow = Ext.create('widget.uniDetailWindow', {
                title: '검사참조',
                width: 830,				                
                height: 580,
                layout:{type:'vbox', align:'stretch'},
                
                items: [otherOrderSearch, otherOrderGrid],
                tbar:  ['->',
					{	itemId : 'saveBtn',
						text: '<t:message code="system.label.product.inquiry" default="조회"/>',
						handler: function() {
							otherOrderStore.loadStoreRecords();
						},
						disabled: false
					},{	itemId : 'confirmBtn',
						text: '<t:message code="system.label.product.apply" default="적용"/>',
						handler: function() {
							otherOrderGrid.returnData();
						},
						disabled: false
					},{	itemId : 'confirmCloseBtn',
						text: '<t:message code="system.label.product.afterapplyclose" default="적용 후 닫기"/>',
						handler: function() {
							otherOrderGrid.returnData();
							CheckWindow.hide();
							UniAppManager.setToolbarButtons('reset', true)
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.product.close" default="닫기"/>',
						handler: function() {
							CheckWindow.hide();
							UniAppManager.setToolbarButtons('reset', true)
						},
						disabled: false
					}
				],
                listeners : {beforehide: function(me, eOpt)	
                	{
                		otherOrderSearch.clearForm();
                		otherOrderGrid.reset();
                	},
                	beforeclose: function(panel, eOpts)
                	{
						otherOrderSearch.clearForm();
                		otherOrderGrid.reset();
                	}
                }
			})
		}
		CheckWindow.show();
    }
    
	 Unilite.Main({
	 	border:false,
		borderItems:[{
				region:'center',
				layout: 'border',
	    		border : false,
				items:[
					masterGrid1, masterGrid2, panelResult
				]	
			},
			panelSearch
		], 
		id: 'pms500ukrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{		
			var verifyNum = panelSearch.getValue('VERIFY_NUM');
			if(Ext.isEmpty(verifyNum)) {
				openSearchInfoWindow() 
			} else {
				var param= panelSearch.getValues();
				directMasterStore1.loadStoreRecords();
				if(panelSearch.setAllFieldsReadOnly(true) == false){
					return false;
				}
				if(panelResult.setAllFieldsReadOnly(true) == false){
					return false;
				}	
			}
			UniAppManager.setToolbarButtons('reset', true); 
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});
};


</script>
