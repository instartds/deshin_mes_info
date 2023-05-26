<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//일일승무지시 등록
request.setAttribute("PKGNAME","Unilite_app_gop200ukrv");
%>
<t:appConfig pgmId="gop200ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="GO01"/>				<!-- 영업소   	-->  
	<t:ExtComboStore comboType="AU" comboCode="GO02"/>				<!-- 운행조   	-->  
	<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> <!-- 노선 -->
	<t:ExtComboStore comboType="AU" comboCode="GO16"/>				<!-- 노선그룹  	-->	
</t:appConfig>
<script type="text/javascript">
var editWindow;
//var confirmWindow;
function appMain() {
	Unilite.defineModel('gop200ukrvModel', {
	    fields: [
					 {name: 'DIV_CODE'   			,text:'사업장'				,type : 'string'} 
					,{name: 'OPERATION_DATE'    	,text:'운행일'				,type : 'string', convert:function(v) {return UniDate.safeFormat(v)} } 
					,{name: 'OFFICE_CODE'    		,text:'영업소코드'			,type : 'string'} 
					,{name: 'OFFICE_NAME'    		,text:'영업소'				,type : 'string'} 
					,{name: 'TEAM_CODE'    			,text:'운행조코드'			,type : 'string'} 
					,{name: 'TEAM_NAME'    			,text:'운행조'				,type : 'string'} 
					,{name: 'ROUTE_CODE'    		,text:'노선코드'			,type : 'string'} 
					,{name: 'ROUTE_NUM'    			,text:'노선번호'			,type : 'string'} 
					,{name: 'ROUTE_NAME'    		,text:'노선명'				,type : 'string'} 
					,{name: 'OPERATION_COUNT'  		,text:'운행순번'			,type : 'string'} 
					,{name: 'VEHICLE_CODE'    		,text:'차량코드'			,type : 'string'} 
					,{name: 'VEHICLE_NAME'    		,text:'차량번호'			,type : 'string'} 
					,{name: 'NAME'    				,text:'이름'				,type : 'string'} 					
					,{name: 'DRIVER_CODE'  			,text:'기사코드'			,type : 'string'}
					,{name: 'REMARK'  				,text:'비고'				,type : 'string'} 
					,{name: 'CHANGE_FLAG'    		,text:'변경구분'			,type : 'string'} 
					,{name: 'FIRST_DEPARTURE_DATE'  ,text:'첫차출발일자'		,type : 'uniDate'}
					,{name: 'FIRST_DEPARTURE_TIME'  ,text:'첫차출발시간'		,type : 'string'}
					,{name: 'LAST_DEPARTURE_DATE'   ,text:'막차출발일자'		,type : 'uniDate'} 
					,{name: 'LAST_DEPARTURE_TIME'   ,text:'막차출발시간'		,type : 'string'} 
					,{name: 'DUTY_FR_DATE'    		,text:'출근일자'			,type : 'uniDate'} 
					,{name: 'DUTY_FR_TIME'    		,text:'출근시간'			,type : 'string'} 
					,{name: 'DUTY_TO_DATE'    		,text:'퇴근일자'			,type : 'uniDate'} 
					,{name: 'DUTY_TO_TIME'    		,text:'퇴근시간'			,type : 'string'} 
					,{name: 'SYS_DUTY_TO_DATE'    	,text:'퇴근일자(출입통제)'	,type : 'uniDate'} 
					,{name: 'SYS_DUTY_TO_TIME'    	,text:'퇴근시간(출입통제)'	,type : 'string'} 
					,{name: 'CHANGE_REASON'    		,text:'변경사유'			,type : 'string'} 
					,{name: 'NOTINSERVICE_YN'    	,text:'운휴여부'			,type : 'string'}					
					,{name: 'OTHER_VEHICLE_YN'    	,text:'타차여부'			,type : 'string'}
					,{name: 'CONFIRM_YN'    		,text:'마감여부'			,type : 'string'}
					
					,{name: 'NODE_NUM'   			,text:'VIEW PROPERTY'		,type : 'string'} 	// 조회 최다운행수
					,{name: 'MAX_OPERATION_COUNT'   ,text:'VIEW PROPERTY'		,type : 'string'} 	// 조회 최다운행수
					,{name: 'MIN_OPERATION_COUNT'   ,text:'VIEW PROPERTY'		,type : 'string'} 	// 조회 처음운행수
					
					,{name: 'DT_MAX_OPERATION_COUNT',text:'VIEW PROPERTY'		,type : 'string'}   // 일일 최다운행수
					,{name: 'DT_MIN_OPERATION_COUNT',text:'VIEW PROPERTY'		,type : 'string'}	// 일일 최초운행수					
					,{name: 'FULL_OPERATION'		,text:'VIEW PROPERTY'		,type : 'string'}   // 조회 최다운행의 일자-노선-반
					,{name: 'OPERATION'				,text:'VIEW PROPERTY'		,type : 'string'}   // 조회 일일운행의 일자-노선-반
					,{name: 'COLSPAN'    			,text:'VIEW PROPERTY'		,type : 'int'} 		// 운행하지 않는 차수 컬럼 COLSPAN
					,{name: 'CONFIRM'				,text:'VIEW PROPERTY'		,type : 'string'}	//차량배차 확정 여부
					
			]
	});
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read : gop200ukrvService.selectList,
            update : gop200ukrvService.update,
			syncAll: 'gop200ukrvService.saveAll'
		}
	});
    var masterStore =  Unilite.createStore('gop200ukrvStore',{
        model: 'gop200ukrvModel',
         autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: directProxy,
            saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("store : ", this);
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					this.syncAllDirect();					
				}else {
					alert(Msg.sMB083);
				}
			} ,
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}searchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			},
			listeners:{
				update: function( store, record, operation, modifiedFieldNames, eOpts )	{
					if(record.get("OTHER_VEHICLE_YN") == 'Y')	{
						record.set('CHANGE_FLAG','OTHER');
					} else if(record.get("NOTINSERVICE_YN") == 'Y')	{
						record.set('CHANGE_FLAG','NOTINSERVICE');
					} else {
						record.set('CHANGE_FLAG','');
					}
					masterView.refreshNode(store.indexOf( record ));
				}
			}
            
		});
	
	
		
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}searchForm',{
		title: '일일승무지시정보',
        defaultType: 'uniSearchSubPanel',
        defaults: {
			autoScroll:true
	  	},
        width: 330,
		items: [{	
					title: '검색조건', 	
					id: 'search_panel1',
		   			itemId: 'search_panel1',
		   			height:140,
		           	layout: {type: 'uniTable', columns: 1},
		           	defaultType: 'uniTextfield',  
		           	defaults:{
		           		labelWidth:80
		           	},
			    	items:[{	    
						fieldLabel: '노선그룹',
						name: 'ROUTE_GROUP'	,
						xtype: 'uniCombobox',
						comboType:'AU', 
						comboCode:'GO16',
						allowBlank:false, 
						child: 'ROUTE_CODE'
						
					},{	    
						fieldLabel: '노선',
						name: 'ROUTE_CODE'	,
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('routeStore')
					},{	    
						fieldLabel: '운행일 기간',
						name: 'OPERATION_DATE',
						xtype: 'uniDateRangefield',
			            startFieldName: 'OPERATION_DATE_FR',
			            endFieldName: 'OPERATION_DATE_TO',	
			            startDate: UniDate.get('startOfMonth'),
			            endDate: UniDate.get('endOfMonth'),
			            width:320
					}]				
			
			}]
		
	});	//end panelSearch    
	
	
    var masterViewTplTemplate = new Ext.XTemplate(
	    '<table cellspacing="0" cellpadding="0" border="0" class="x-grid-table" style="border-right: #99bce8 solid 1px;">' ,
	    '<tpl for=".">' ,
	    	'<tpl if="CONFIRM == \'Y\' && FULL_OPERATION != \'\' && OPERATION == FULL_OPERATION">',
				'<tpl if="NODE_NUM == MIN_OPERATION_COUNT">' ,
					'<tr>',//<td width="110" class="x-column-header x-column-header-inner" style="text-align: center;border-left: 0px solid #c5c5c5;">승무지시확정</td>' +
					'<td width="100" class="x-column-header x-column-header-inner" style="text-align: center;border-left: 0px solid #c5c5c5;">운행일</td>' ,
					'<td width="60" class="x-column-header x-column-header-inner" style="text-align: center;border-left: 0px solid #c5c5c5;">노선</td>' ,
					'<td width="60" class="x-column-header x-column-header-inner" style="text-align: center;border-left: 0px solid #c5c5c5;">운행조</td>' ,
				'</tpl>',
				'<td  class="x-column-header x-column-header-inner" style="text-align: center;">{NODE_NUM}번</td>' ,
				'<tpl if="NODE_NUM == MAX_OPERATION_COUNT">',
			 		'</tr>' ,
			 	'</tpl>',
			 '</tpl>',
		 '</tpl>',
		 '<tpl for=".">' ,
			'<tpl if="NODE_NUM == MIN_OPERATION_COUNT">' ,
				'<tr class="x-grid-row x-grid-with-row-lines">' +
				'	 <td width="100" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner" style="vertical-align:middle;">{OPERATION_DATE}</td>' ,
				'	 <td width="60" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner" style="vertical-align:middle;">{ROUTE_NUM}</td>',
				' <tpl if="CONFIRM == \'N\' ">',
				'	 <td width="60" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner" style="vertical-align:middle;">미확정</td>' ,
				' </tpl>',
				' <tpl if="CONFIRM == \'Y\' ">',
				'	 <td width="60" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner" style="vertical-align:middle;">{TEAM_NAME}</td>' ,
				' </tpl>',
			'</tpl>',
				'<tpl if="OPERATION_COUNT !=\'\'">',
	                '<td width="163"  class="x-grid-cell x-grid-with-col-lines x-grid-td "><div class="data-source busData" style="border: 1px solid #ffffff">' ,	                 	
		                '<tpl if="CHANGE_FLAG == \'\'">',
		               		'<div class="busItemGreen">',
		                '</tpl>',
		                '<tpl if="CHANGE_FLAG == \'NOTINSERVICE\'">',
		                	'<div class="busItemRed">',
		                '</tpl>',    
		                '<tpl if="CHANGE_FLAG == \'OTHER\'">',
		                	'<div class="busItemGray">',
		                '</tpl>', 
		                '<table  cellspacing="0" cellpadding="0" width="100%" border="0"><tr>',
		            		'<td colspan="2" align="center" style="line-height:32px;">{ROUTE_NUM} -{ROUTE_NAME}</td>',
		            	'</tr><tr>',			            	
		            	'<tr><td width="70" align="left" style="line-height:12px;padding-left:25px;" ><font style="font-size:9px;color:#5b9bd5">■</font> {FIRST_DEPARTURE_TIME}</td>' ,
		            	'    <td height="54" rowspan="4" align="right" style="padding-right:24px" >',
		            	'<tpl if="DRIVER_CODE == \'\'">',
		            	'		<img src="'+CPATH+'/resources/images/busoperate/naPhoto.png" title="{NAME:htmlEncode}" width="50" height="50">',
		            	'</tpl>', 
		            	'<tpl if="DRIVER_CODE != \'\'">',
		            	'		<img src="'+CPATH+'/uploads/employeePhoto/{DRIVER_CODE}" title="{NAME:htmlEncode}" width="50" height="50">',
		            	'</tpl>', 
		            	'	 </td>',
		            	 '</tr>',
		            	 '<tr><td width="70" align="left"  style="line-height:12px;padding-left:25px;"><font style="font-size:9px;color:#ed7c31">■</font> {LAST_DEPARTURE_TIME}</td></tr>' ,
		            	 '<tr><td width="70" align="left"  style="line-height:12px;padding-left:25px;"><font style="font-size:9px;color:#ffc000">■</font> {DUTY_FR_TIME}</td></tr>' ,
		            	 '<tr><td width="70" align="left"  style="line-height:12px;padding-left:25px;"><font style="font-size:9px;color:#70ad47">■</font> {DUTY_TO_TIME}</td></tr>' ,
		            	
		            	'<tr>',
		            	'<tpl if="!this.showDriverCode">',
		            	'	<td>&nbsp;</td>',
		            	'</tpl>',
		            	'<tpl if="this.showDriverCode">',
		            	'	<td align="right">{DRIVER_CODE}</td>',
		            	'</tpl>',
		            		'<td align="center" style="padding-right:24px; height:12px;">{NAME}</td>' ,
		            	'</tr>',
		            	'<tr>',
		            		'<td  colspan="2" align="center" style="line-height:35px">{VEHICLE_NAME}</td>',
		            	'</tr>',
		            	'</table></div>',
	                '</div></td>',
	         '</tpl>',
	         '<tpl if="OPERATION_COUNT == \'\' ">',
	         		'<td width="163"  height="163"  class="x-grid-cell x-grid-with-col-lines x-grid-td " ><div style="width:163px" class="data-source">&nbsp;</div></td>',
	         '</tpl>',
	         '<tpl if="NODE_NUM == MAX_OPERATION_COUNT">',
				'</tr>',
			'</tpl>',
        '</tpl>' ,
        '</table>',
        {
        	showDriverCode:false,
        	setShowDriver: function	(visible)	{
        			this.showDriverCode = visible;
        	}
        }
	);
	
	var masterTableTplTemplate = new Ext.XTemplate(
	    '<table cellspacing="0" cellpadding="0" border="0" class="x-grid-table" style="border-right: #99bce8 solid 1px;table-layout:fixed;">' ,
	    '<tpl for=".">' ,
	    	'<tpl if="CONFIRM == \'Y\' && OPERATION == FULL_OPERATION">',
				'<tpl if="NODE_NUM == MIN_OPERATION_COUNT">' ,
					'<tr class="x-grid-row x-grid-with-row-lines">',
					'<td rowspan="2" class="x-column-header x-column-header-inner bus-fixed" style="width:100px;text-align: center;">운행일</td>' ,
					'<td rowspan="2" class="x-column-header x-column-header-inner bus-fixed" style="width:60px;text-align: center;">노선</td>' ,
					'<td rowspan="2" class="x-column-header x-column-header-inner bus-fixed" style="width:60px;text-align: center;">운행조</td>' ,
				'</tpl>',
				'<td  colspan="6" class="x-column-header x-column-header-inner bus-fixed" style="width:360px;text-align: center;">{NODE_NUM}번</td>' ,
				'<tpl if="NODE_NUM == MAX_OPERATION_COUNT">',
			 		'</tr>' ,
			 	'</tpl>',
			 '</tpl>',
		 '</tpl>',
		 '<tpl for=".">' ,
	    	'<tpl if="OPERATION == FULL_OPERATION">',
	    		'<tpl if="NODE_NUM == MIN_OPERATION_COUNT">' ,
					'<tr class="x-grid-row x-grid-with-row-lines">',
				'</tpl>',					
					'<td class="x-column-header x-column-header-inner bus-fixed" style="width:40px;text-align: center;">차량</td>' ,
					'<td class="x-column-header x-column-header-inner bus-fixed" style="width:50px;text-align: center;">첫차</td>' ,
					'<td class="x-column-header x-column-header-inner bus-fixed" style="width:50px;text-align: center;">막차</td>' ,
					'<td class="x-column-header x-column-header-inner bus-fixed" style="width:50px;text-align: center;">출근</td>' ,
					'<td class="x-column-header x-column-header-inner bus-fixed" style="width:50px;text-align: center;">퇴근</td>' ,
					'<td class="x-column-header x-column-header-inner bus-fixed" style="width:115px;text-align: center;">기사</td>' ,
				'<tpl if="NODE_NUM == MAX_OPERATION_COUNT">',
			 		'</tr>' ,
			 	'</tpl>',
			 '</tpl>',
		 '</tpl>',
		 '<tpl for=".">' ,
			'<tpl if="NODE_NUM == MIN_OPERATION_COUNT">' ,
				'<tr class="x-grid-row x-grid-with-row-lines">' +
				'	 <td width="100" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner bus-fixed" style="width:100px;">{OPERATION_DATE}</td>' ,
				'	 <td width="60" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner bus-fixed" style="width:60px;">{ROUTE_NUM}</td>',
				' <tpl if="CONFIRM == \'N\' ">',
				'	 <td width="60" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner bus-fixed" style="width:60px;">미확정</td>' ,
				' </tpl>',
				' <tpl if="CONFIRM == \'Y\' ">',
				'	 <td width="60" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner bus-fixed" style="width:60px;">{TEAM_NAME}</td>' ,
				' </tpl>',
			'</tpl>',
			'<tpl if="OPERATION_COUNT !=\'\'">',
	                '<td colspan="6"><div class="data-source" style="padding: 0 !important;">' ,	                 	
		                '<table  cellspacing="0" cellpadding="0" width="100%" border="0" style="table-layout:fixed;">',
		                '<tr class="x-grid-row x-grid-with-row-lines',
		                '<tpl if="NOTINSERVICE_YN ==\'Y\'">',
		                 ' bus-fixednotinservice',
		                 '</tpl>',
		                '">',		                
		            	'	<td class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner bus-fixed" width="40">{VEHICLE_NAME}</td>' ,	
		            	'	<td class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner bus-fixed" width="50">{FIRST_DEPARTURE_TIME}</td>' ,
		            	'	<td class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner bus-fixed" width="50">{LAST_DEPARTURE_TIME}</td>' ,
		            	'	<td class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner bus-fixed" width="50">{DUTY_FR_TIME}</td>' ,
		            	'	<td class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner bus-fixed" width="50">{DUTY_TO_TIME}</td>' ,
		            	'	<td class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner bus-fixed" width="65">{NAME}</td>' ,
		            	'	<td class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner bus-fixed" width="50">{DRIVER_CODE}</td>' ,
		            	'</tr>',
		            	'</table>',
	                '</div></td>',
	         '</tpl>',
	         '<tpl if="OPERATION_COUNT ==\'\' ">',
	         		'<td colspan="6"><div class="data-source" style="padding: 0 !important;">',
	         			'<table  cellspacing="0" cellpadding="0" width="100%" border="0" style="table-layout:fixed;">',
		                '<tr class="x-grid-row x-grid-with-row-lines">',
		                ' <tpl if="CONFIRM == \'N\' ">',
						'	 <td class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner bus-fixed" style="width:40px;">&nbsp</td>' ,
						' </tpl>',
						' <tpl if="CONFIRM == \'Y\' ">',
		            	'	<td class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner bus-fixed" style="width:40px;"><font color="gray">타차</font></td>' ,
		            	' </tpl>',
		            	'	<td class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner bus-fixed" style="width:50px;">&nbsp;</td>' ,
		            	'	<td class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner bus-fixed" style="width:50px;">&nbsp;</td>' ,
		            	'	<td class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner bus-fixed" style="width:50px;">&nbsp;</td>' ,
		            	'	<td class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner bus-fixed" style="width:50px;">&nbsp;</td>' ,
		            	'	<td class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner bus-fixed" style="width:65px;">&nbsp;</td>' ,
		            	'	<td class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner bus-fixed" style="width:50px;">&nbsp;</td>' ,	
		            	
		            	'</tr>',
	         		'</table></div></td>',
	         '</tpl>',
	         '<tpl if="NODE_NUM == MAX_OPERATION_COUNT">',
				'</tr>',
			'</tpl>',
        '</tpl>' ,
        '</table>'
	);
	
	var masterSmallViewTplTemplate = new Ext.XTemplate(
	    '<table cellspacing="0" cellpadding="0" border="0" class="x-grid-table" style="border-right: #99bce8 solid 1px;">' ,
	    '<tpl for=".">' ,
	    	'<tpl if="CONFIRM == \'Y\' && FULL_OPERATION != \'\' && OPERATION == FULL_OPERATION">',
				'<tpl if="NODE_NUM == MIN_OPERATION_COUNT">' ,
					'<tr>',//<td width="110" class="x-column-header x-column-header-inner" style="text-align: center;border-left: 0px solid #c5c5c5;">승무지시확정</td>' +
					'<td width="100" class="x-column-header x-column-header-inner" style="text-align: center;border-left: 0px solid #c5c5c5;">운행일</td>' ,
					'<td width="60" class="x-column-header x-column-header-inner" style="text-align: center;border-left: 0px solid #c5c5c5;">노선</td>' ,
					'<td width="60" class="x-column-header x-column-header-inner" style="text-align: center;border-left: 0px solid #c5c5c5;">운행조</td>' ,
					'<td width="100%" class="x-column-header x-column-header-inner" style="text-align: center;border-left: 0px solid #c5c5c5;">승무지시</td>' ,
				'</tpl>',
				'<tpl if="NODE_NUM == MAX_OPERATION_COUNT">',
			 		'</tr>' ,
			 	'</tpl>',
			 '</tpl>',
		 '</tpl>',
		 '<tpl for=".">' ,
			'<tpl if="NODE_NUM == MIN_OPERATION_COUNT">' ,
				'<tr class="x-grid-row x-grid-with-row-lines">' +
				'	 <td width="100" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner" style="vertical-align:middle;">{OPERATION_DATE}</td>' ,
				'	 <td width="60" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner" style="vertical-align:middle;">{ROUTE_NUM}</td>',
				' <tpl if="CONFIRM == \'N\' ">',
				'	 <td width="60" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner" style="vertical-align:middle;">미확정</td>' ,
				' </tpl>',
				' <tpl if="CONFIRM == \'Y\' ">',
				'	 <td width="60" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner" style="vertical-align:middle;">{TEAM_NAME}</td>' ,
				' </tpl>',
				'<td width="100%"  class="x-grid-cell x-grid-with-col-lines x-grid-td "><div>' +
			'</tpl>',
				'<tpl if="OPERATION_COUNT !=\'\'">',
	                 '<div class="busItemSmall-wrap"><div class="data-source" style="width:81px;border: 1px solid #ffffff">' ,	                 	
		                '<tpl if="CHANGE_FLAG == \'\'">',
		               		'<div class="busItemGreenSmall">',
		                '</tpl>',
		                '<tpl if="CHANGE_FLAG == \'NOTINSERVICE\'">',
		                	'<div class="busItemRedSmall">',
		                '</tpl>',    
		                '<tpl if="CHANGE_FLAG == \'OTHER\'">',
		                	'<div class="busItemGraySmall2">',
		                '</tpl>', 
		                '<br>{NODE_NUM}번<br>{NAME}<br>{VEHICLE_NAME}',		                
		            	'</div></div>',
	                '</div>',
	         '</tpl>',
	         '<tpl if="NODE_NUM == MAX_OPERATION_COUNT">',
				'</div><td></tr>',
			'</tpl>',
        '</tpl>' ,
        '</table>'
	);
	
	
    var masterView = Ext.create('UniDragandDropView', {
    	//title: '승무지시등록',
    	//layout:'fit',
		tpl: masterViewTplTemplate,
        store: masterStore,
        style:{
        		'background-color': '#fff' ,
        		'border': '1px'
        },
        flex:1,
        autoScroll:true,
        
        onDropEnter: function(target, dd, e, drag)	{
        	var me = this;
        	var drop = me.getDropRecord();
        	//타차의 경우
        	if("uniDragandDropView" == drag.view.getXType())	{
        		
	        	if(drag.record.get("OPERATION_DATE") != drop.get("OPERATION_DATE") || drag.record.get("ROUTE_CODE") != drop.get("ROUTE_CODE") ) {
	        		me.setAllowDrop(false);
	        		return false;
        		}
        	}
        	if(drop.get("OTHER_VEHICLE_YN") == "Y")	{
        		if("uniDragandDropView" != drag.view.getXType())	{
        			me.setAllowDrop(false);
        			return false;
        		}
        	}
        	if(Ext.isEmpty(drop.get("OPERATION_COUNT")))	{
        		me.setAllowDrop(false);
        		return false;
        	}
        	
        	if(drop.get("CONFIRM_YN") == 'Y')	{
        		me.setAllowDrop(false);
        		return false;
        	}
        	
        	me.setAllowDrop(true);
        	return true;
        	
        },
        
        onDrop : function(target, dd, e, drag){
        	var me = this;
        	var drop = me.getDropRecord();
        	var dragRec;
        	if("uniDragView" == drag.view.getXType())	{
	        	dragRec = drag.record;
        	}else if("uniDragandDropView" == drag.view.getXType())	{
        		dragRec = drag.record;
        	}else {
        		dragRec = drag.records[0];
        	}
        	var store = me.getStore();	           
	        
        	if(me.allowDrop)	{
        		
        		var dropIdx = store.indexOf( drop );
        		
        		if("uniDragandDropView" != drag.view.getXType())	{
	        		if(!Ext.isEmpty(dragRec.get("NAME")) ) 		{
			        	drop.set("NAME", dragRec.get("NAME"));
	        		}        		
			        if(!Ext.isEmpty(dragRec.get("DRIVER_CODE")) ) 		{
			        	drop.set("DRIVER_CODE", dragRec.get("DRIVER_CODE"));
			        }
			        if(!Ext.isEmpty(dragRec.get("VEHICLE_CODE")) ) 		{
			        	drop.set("VEHICLE_CODE", dragRec.get("VEHICLE_CODE"));
			        }
			        if(!Ext.isEmpty(dragRec.get("VEHICLE_NAME")) ) 		{
			        	drop.set("VEHICLE_NAME", dragRec.get("VEHICLE_NAME"));
			        }
			        if(!Ext.isEmpty(dragRec.get("OTHER_VEHICLE_YN")) ) 		{
			        	 drop.set("OTHER_VEHICLE_YN", dragRec.get("OTHER_VEHICLE_YN"));
			        }
		        
        		}else {
        			var dropDriverCode= drop.get("DRIVER_CODE");
	        		var dropDriverName= drop.get("NAME");
		        	var dropVehicleCode = drop.get("VEHICLE_CODE");
	    			var dropVehicleName = drop.get("VEHICLE_NAME");
	        		var dropOtherVehicleYn= drop.get("OTHER_VEHICLE_YN");
        			var dropChangeReason  = drop.get("CHANGE_REASON");
        			var dropNotinService= drop.get("NOTINSERVICE_YN");        			
        			var dropChangeFlag = drop.get("CHANGE_FLAG");
        			var dropRemark= drop.get("REMARK");
        			
        			drop.set("NAME", dragRec.get("NAME"));
        			drop.set("DRIVER_CODE", dragRec.get("DRIVER_CODE"));
        			drop.set("VEHICLE_CODE", dragRec.get("VEHICLE_CODE"));
        			drop.set("VEHICLE_NAME", dragRec.get("VEHICLE_NAME"));
        			drop.set("OTHER_VEHICLE_YN", dragRec.get("OTHER_VEHICLE_YN"));
        			drop.set("REMARK", dragRec.get("REMARK"));		        	
		        	drop.set("CHANGE_FLAG", dragRec.get("CHANGE_FLAG"));		        	
		        	drop.set("CHANGE_REASON", dragRec.get("CHANGE_REASON"));
		        	drop.set("NOTINSERVICE_YN", dragRec.get("NOTINSERVICE_YN"));
		        	drop.set("OTHER_VEHICLE_YN", dragRec.get("OTHER_VEHICLE_YN"));
		        	
		        	 
		        	var dragIdx = store.indexOf(dragRec);
	     			var record = store.getAt(dragIdx);
	     			
	             	record.set("NAME", dropDriverName);
         			record.set("DRIVER_CODE", dropDriverCode);
         			record.set("VEHICLE_CODE", dropVehicleCode);
         			record.set("VEHICLE_NAME", dropVehicleName);
         			
         			record.set("CHANGE_REASON", dropChangeReason);
         			record.set("CHANGE_FLAG", dropChangeFlag);         			
         			record.set("NOTINSERVICE_YN", dropNotinService);
         			record.set("OTHER_VEHICLE_YN", dropOtherVehicleYn);
         			record.set("REMARK", dropRemark);
         			
		     		masterView.refreshNode(dragIdx);
		        }
		        
		        masterView.refreshNode(dropIdx);
        	}
        	
            return true;
        },     
        listeners: {
            render: function()	{
            	var me = this;
            	this.getEl().on('dblclick', function(e, t, eOpt) {
            		var selectEl = me.getSelectedNodes();
			    	openWindow(me.getRecord(selectEl[0]));
			    });
            },
            itemcontextmenu:function(view, record, item, index, event, eOpts )	{
          	  		event.stopEvent();
					contextMenu.selectedRecord = record;
					contextMenu.selectedIndex = index;
					contextMenu.showAt(event.getXY());					
          	 }
        },
        setTemplate:function(type)	{
        	if(type=='view') {
        		this.tpl=  masterViewTplTemplate;
        	}else if(type=='small') {
        		this.tpl = masterSmallViewTplTemplate;        		
        	} else {
        		this.tpl = masterTableTplTemplate;
        	}
        	this.refresh();
        }
    });
    
    var contextMenu = new Ext.menu.Menu({
	        items: [
	                {	text: '기사정보 삭제',   iconCls : 'icon-link',
	                	handler: function(menuItem, event) {
	                		var param = menuItem.up('menu');
	                		var record = masterStore.getAt(param.selectedIndex);
					        
                			record.set("NAME", '');
			     			record.set("DRIVER_CODE", '');   		
     						
	                	}
	            	}
	        	]
    	});
    	
    Unilite.defineModel('gop200ukrvDriverModel', {
	    fields: [
					 {name: 'DIV_CODE'   		,text:'사업장'		,type : 'string'} 			
					,{name: 'NAME'    			,text:'이름'		,type : 'string'} 					
					,{name: 'DRIVER_CODE'  		,text:'기사코드'	,type : 'string'}
					,{name: 'ROUTE_GROUP'    	,text:'노선그룹'		,type : 'string'  ,comboType:'AU', comboCode:'GO16', child: 'ROUTE_CODE'}
					,{name: 'ROUTE_CODE'    	,text:'노선'			,type : 'string'  ,comboType:'AU', store: Ext.data.StoreManager.lookup('routeStore') }
					,{name: 'REMARK'  			,text:'비고'		,type : 'string'} 
			]
	});
	
		
		
	var driverStore =  Unilite.createStore('gop200ukrvDriverStore',{
        model: 'gop200ukrvDriverModel',
        idProperty: 'DRIVER_CODE',
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
                	   read : gopCommonService.driverList
                }
            },
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}driverForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			}
            
            
		});
		
     var driverView = Ext.create('UniDragView', {
		tpl: '<tpl for=".">'+
                '<div class="drivers-source bus-driver-photo"><img src="'+CPATH+'/uploads/employeePhoto/{DRIVER_CODE}" title="{NAME:htmlEncode}" width="77" height="77"><br/>'+	                
        			'<span>{NAME}</span><br><span>({DRIVER_CODE})</span>'+                    			
        		'</div>'+
            '</tpl>' ,
        itemSelector: 'div.drivers-source',
        overItemCls: 'drivers-over',
        selectedItemClass: 'drivers-selected',
        singleSelect: true,
        store: driverStore
    });
    
    var driverGrid =  Unilite.createGrid('gop200ukrvDriverGrid', {
        hidden:true,
        flex: .15,
        margins: 0,
    	store: driverStore,
    	uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
        },
        columns:  [ 
        	{dataIndex:'NAME' ,width:80},
        	{dataIndex:'DRIVER_CODE' ,width:80},
        	{dataIndex:'ROUTE_CODE',width:80} ,
        	{dataIndex:'ROUTE_GROUP' ,flex:1}
        	
        	
        ],
        viewConfig: {
        	itemId:'DirverList',
            plugins: {
                ddGroup: 'dataGroup',
                ptype: 'gridviewdragdrop',
                enableDrop: false
            }
        }
    });
    
     Unilite.defineModel('gop200ukrvBusModel', {
	    fields: [
					 {name: 'DIV_CODE'   		,text:'사업장'		,type : 'string'} 					
					,{name: 'VEHICLE_CODE'    	,text:'차량코드'	,type : 'string'} 
					,{name: 'VEHICLE_NAME'    	,text:'차량번호'	,type : 'string'} 
			]
	});
    var busStore = Unilite.createStore('gop200ukrvBusStore',{
        model: 'gop200ukrvBusModel',
        idProperty: 'VEHICLE_CODE',
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
                	   read : gop300ukrvService.busList
                }
            },
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}driverForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			}
            
		});
	var busView = Ext.create('UniDragView', {
		tpl: '<tpl for=".">'+
                '<div class="bus-source busData2" style="border: 1px solid #ffffff">' +	                 	
                '<div class="busItemSmall"><table  cellspacing="0" cellpadding="0" width="100%" border="0">'+      	
            	'<tr><td  height="30" style="vertical-align: bottom;padding-left:20px;">{VEHICLE_NAME}</td></tr>'+           		
            	'</table></div></div>'+
            '</tpl>' ,
        itemSelector: 'div.bus-source',
        overItemCls: 'bus-over',
        selectedItemClass: 'bus-selected',
        singleSelect: true,
        store: busStore
    });
    var busGrid =  Unilite.createGrid('gop300ukrvBusGrid', {
        hidden:true,
        flex: .1,
        
        margins: 0,
    	store: busStore,
    	uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
        },
        columns:  [ 
        	{dataIndex:'VEHICLE_NAME' ,flex:1},
        	{dataIndex:'VEHICLE_CODE' ,width:80} 
        ],
        viewConfig: {
        	itemId:'TmpBusList',
            plugins: {
                ddGroup: 'dataGroup',
                ptype: 'gridviewdragdrop',
                enableDrop: false,
                enableDrag: true
            }
        }
    });
     Unilite.defineModel('gop200ukrvOtherVehicleModel', {
	    fields: [
					 {name: 'OTHER_VEHICLE_YN'   		,text:'타차'		,type : 'string'},	 
					 {name: 'CHANGE_FLAG'   			,text:'OPTION'		,type : 'string', defaultValue:'OTHER'},
					 {name: 'OPTION'   					,text:'구분'		,type : 'string'} 
				]
    });
    var otherVehicleStore =  Unilite.createStore('gop200ukrvOtherVehicleStore',{ //Ext.create('Ext.data.Store', {
     model: 'gop200ukrvOtherVehicleModel',
     data : [
         {OTHER_VEHICLE_YN: 'Y', OPTION: 'OTHER_VEHICLE_INFO'}
     ]
 	});
     var otherVehicle = Ext.create('UniDragView', {
		tpl: '<tpl for=".">'+
			 '<div class="data-source" style="border: 1px solid #ffffff;padding-left:4px;padding-top:4px;">' +	                 	
                '<div class="busItemMedium-gray"><table  cellspacing="0" cellpadding="0" width="100%" border="0">'+      	
            	'<tr><td  height="30" style="padding-left:20px;vertical-align: bottom;">타차</td></tr>'+           		
            	'</table></div></div>'+
        	  '</tpl>',
        itemSelector: 'div.data-source',
        overItemCls: 'data-over',
        selectedItemClass: 'data-selected',
        store: otherVehicleStore
    });
    var panelSearch2 = Unilite.createSearchPanel('${PKGNAME}driverForm',{
		title: '참조정보',
		region:'east',
		collapseDirection : 'right',
        defaultType: 'uniSearchSubPanel',
        defaults: {
			autoScroll:true
	  	},
        width: 330,
		items: [{	
					title: '기사정보', 	
					collapsible:false,
		   			itemId: 'search_panel1',
		   			height:110,
		           	layout: {type: 'uniTable', columns: 1},
		           	defaultType: 'uniTextfield',  
		           	defaults:{
		           		labelWidth:80,		           		
						listeners:{
							specialkey: function(field, e){
			                    if (e.getKey() == e.ENTER) {
			                       driverStore.loadStoreRecords();
			                    }
			                }
						}	
		           	},
		           	tools: [
		           			{
			        			type: 'search',
			        			handler:function()	{
			        				driverStore.loadStoreRecords();
			        			}
			        		},{
								type: 'hum-grid',					            
					            handler: function () {
					            	driverView.hide();
					                driverGrid.show();
					            }
			        		},{

								type: 'hum-photo',					            
					            handler: function () {
					                driverGrid.hide();
					                driverView.show();
					            }
			        		}
						
					],
			    	items:[{	    
						fieldLabel: '기사명',
						name: 'NAME'						
					},{	    
						fieldLabel: '노선그룹',
						name: 'ROUTE_GROUP'	,
						xtype: 'uniCombobox',
						comboType:'AU', 
						comboCode:'GO16',
						child: 'ROUTE_CODE'
						
					},{	    
						fieldLabel: '노선',
						name: 'ROUTE_CODE'	,
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('routeStore')
					}]				
				},{
					itemId:'dirvers',
					header:false,
			        border:0,
			        defaults:{autoScroll:true},
			        layout: {type: 'vbox', align:'stretch'},
			        flex:1,
			        
			        items: [driverView,driverGrid]
			},{	
					title:'차량정보',	
					collapsible:false,
		   			itemId: 'search_panel2',
		   			height:60,
		           	layout: {type: 'uniTable', columns: 1},
		           	defaultType: 'uniTextfield',  
		           	defaults:{
		           		labelWidth:80,		           		
						listeners:{
							specialkey: function(field, e){
			                    if (e.getKey() == e.ENTER) {
			                       busStore.loadStoreRecords();
			                    }
			                }
						}	
		           	},
		           	tools: [{
			        			type: 'search',
			        			handler:function()	{
			        				busStore.loadStoreRecords();
			        			}
			        		},{
								type: 'hum-grid',					            
					            handler: function () {
					            	busView.hide();
					                busGrid.show();
					            }
			        		},{

								type: 'hum-photo',					            
					            handler: function () {
					                busGrid.hide();
					                busView.show();
					            }
			        		}
						
					],
			    	items:[{	    
						fieldLabel: '차량번호',
						name: 'VEHICLE_NAME'						
					}]				
				},{
					itemId:'otherVehicle',
					header:false,
					autoScroll:false,
			        border:0,
			        layout: {type: 'uniTable', columns: 1},
			        height:80,
			        items: [otherVehicle]						
				},{
					header:false,
			        border:0,
			        defaults:{autoScroll:true},
			        layout: {type: 'vbox', align:'stretch'},
			        flex:0.5,
			        items: [busGrid,busView]
			}]
		
	});	//end panelSearch   
	
	
	
	var editForm = Unilite.createSearchForm('gop200ukrvDetailForm', {
		layout: {type: 'uniTable', columns : 4},
		defaults:{
			labelWidth:75,
			width:240
		},
		disabled :false,
		trackResetOnLoad: true,
		defaultType:'textfield',
	    items: [	    
			{
				fieldLabel: '운행조',
				name: 'TEAM_CODE',
				xtype: 'uniCombobox',
				comboType:'AU', 
				comboCode:'GO02',
				readOnly: true,
				colspan:2
			},{
				fieldLabel: '첫차출발일자/시간',
				labelWidth:150,
				name: 'FIRST_DEPARTURE_DATE',
				xtype:'uniDatefield'
			},{
				fieldLabel: '시간',
				name: 'FIRST_DEPARTURE_TIME',
				hideLabel: true,
				width: 70,
				listeners:{
					blur: function (field, The, eOpts )	{
						editForm.chkTime(editForm.getValue('FIRST_DEPARTURE_DATE'), field, field.getValue());
					}
				}
			},{
				fieldLabel: '차량번호',
				name: 'VEHICLE_NAME',
				readOnly: true,
				colspan:2
			},{
				fieldLabel: '막차출발일자/시간',
				labelWidth:150,
				name: 'LAST_DEPARTURE_DATE',
				xtype:'uniDatefield'
			},{
				fieldLabel: '시간',
				name: 'LAST_DEPARTURE_TIME',
				hideLabel: true,
				width: 70,
				listeners:{
					blur: function (field, The, eOpts )	{
						editForm.chkTime(editForm.getValue('LAST_DEPARTURE_DATE'), field, field.getValue());
					}
				}
			},{
				fieldLabel: '기사코드',
				name: 'NAME',
				readOnly: true,
				width:170
			},{
				fieldLabel: '기사코드',
				name: 'DRIVER_CODE',
				readOnly: true,
				hideLabel:true,
				width:70
			},{
				fieldLabel: '출근일자/시간',
				labelWidth:150,
				name: 'DUTY_FR_DATE',
				xtype:'uniDatefield'
			},{
				fieldLabel: '시간',
				name: 'DUTY_FR_TIME',
				hideLabel: true,
				width: 70,
				listeners:{
					blur: function (field, The, eOpts )	{
						editForm.chkTime(editForm.getValue('DUTY_FR_DATE'), field, field.getValue());
					}
				}
			},{
				fieldLabel: '운휴여부',
				name: 'NOTINSERVICE_YN',
				xtype: 'uniCombobox',
				comboType:'AU', 
				comboCode:'A020',
				colspan:2
			},{
				fieldLabel: '퇴근일자/시간',
				labelWidth:150,
				name: 'DUTY_TO_DATE',
				xtype:'uniDatefield'
			},{
				fieldLabel: '시간',
				name: 'DUTY_TO_TIME',
				hideLabel: true,
				width: 70,
				listeners:{
					blur: function (field, The, eOpts )	{
						editForm.chkTime(editForm.getValue('DUTY_TO_DATE'), field, field.getValue());
					}
				}
			},{
				fieldLabel: '변경사유코드',
				name: 'CHANGE_REASON',
				xtype: 'uniCombobox',
				comboType:'AU', 
				comboCode:'GO17',
				colspan:2
			},{
				fieldLabel: '타차여부',
				name: 'OTHER_VEHICLE_YN',
				xtype: 'uniCombobox',
				labelWidth:150,
				width:310,
				comboType:'AU', 
				comboCode:'A020',
				colspan:2
			},{
				fieldLabel: '비고',
				name: 'REMARK',
				colspan:4,
				width: 550
			},{
				fieldLabel: '변경구분',
				name: 'CHANGE_FLAG',
				hidden: true
			}
		],
		setEditable:function(b)	{
			var form = this.getForm();
			form.findField('FIRST_DEPARTURE_DATE').setReadOnly(!b);
			form.findField('FIRST_DEPARTURE_TIME').setReadOnly(!b);
			form.findField('LAST_DEPARTURE_DATE').setReadOnly(!b);
			form.findField('LAST_DEPARTURE_TIME').setReadOnly(!b);
			
			form.findField('DUTY_FR_DATE').setReadOnly(!b);
			form.findField('DUTY_FR_TIME').setReadOnly(!b);
			form.findField('DUTY_TO_DATE').setReadOnly(!b);
			form.findField('DUTY_TO_TIME').setReadOnly(!b);
			
			form.findField('NOTINSERVICE_YN').setReadOnly(!b);
			form.findField('CHANGE_REASON').setReadOnly(!b);
			form.findField('OTHER_VEHICLE_YN').setReadOnly(!b);
			form.findField('REMARK').setReadOnly(!b);
		},
		chkTime: function(date, field, newValue)	{
			
			if(!date)	{
				alert("날짜를 입력해 주세요.");
				return;
			}
			var val = newValue.replace(/:/g, "");
			if(val.length == 4)	{
				if(!Ext.Date.isValid(date.getFullYear(),date.getMonth()+1,date.getDate(), val.substring(0,2), val.substring(2,4)))	{
					editForm.setValue(field.getName(), '');
					alert("시간을 정확히 입력해 주세요."+'\n'+'예: 06:00:00');
					return;
				}
				val = val.substring(0,2)+":"+val.substring(2,4);
				editForm.setValue(field.getName(), val);
			} else if(val.length == 6){
				if(!Ext.Date.isValid(date.getFullYear(),date.getMonth()+1,date.getDate(), val.substring(0,2), val.substring(2,4), val.substring(4,6)))	{
					editForm.setValue(field.getName(), '');
					alert("시간을 정확히 입력해 주세요."+'\n'+'예: 06:00:00');
					return;
				}
				val = val.substring(0,2)+":"+val.substring(2,4)+":"+val.substring(4,6);						
				editForm.setValue(field.getName(), val);
			} else  if(val.length != 0) {
				editForm.setValue(field.getName(), '');
				alert("00:00:00(시:분:초) 형식으로 입력하거나 숫자만 입력해 주세요.");
				
			}					
		}
	});
	
	function openWindow(record) {
		var otherVehicle = record.get("OTHER_VEHICLE_YN");
		var confirmYn = record.get("CONFIRM_YN");
		if( confirmYn =='Y')	{
			editForm.setEditable(false);
		}else {
			editForm.setEditable(true);
		}
		if(!editWindow) {
			editWindow = Ext.create('widget.uniDetailWindow', {
                title: '승무지시',
                width: 600,			                
                height: 260,
                formData: record,
                layout: {type:'vbox', align:'stretch'},	                
                items: [editForm],
                tbar:  [
				        '->',{
							itemId : 'closeBtn',
							text: '닫기',
							handler: function() {
								var node = masterView.getNode(editForm.activeRecord);
								var record= masterView.getRecord(node)
								masterView.refreshNode( masterStore.indexOf(record));
								editWindow.hide();
							},
							disabled: false
						}
				],
				listeners : {beforehide: function(me, eOpt)	{
											editForm.clearForm();
											editForm.reset();                							
                						},
                			 beforeclose: function( panel, eOpts )	{
											editForm.clearForm();
											editForm.reset();
                			 			},
                			 show: function( panel, eOpts )	{
                			 	editForm.setActiveRecord(panel.formData);	
                			 	editWindow.center();
                			 }
                }		
			})
		}
		editWindow.formData = record;
		editWindow.show();
    }
	
      Unilite.Main({
		borderItems:[
	 		panelSearch,
	 		{
	 		 	region:'center',
	 		 	xtype:'panel',
				layout:'fit',
	 		 	tbar:  [
	 		 		{
	 		 			xtype:'checkbox',
	 		 			boxLabel  : '사번표시&nbsp;',
	                    name      : 'SHOW_CODE',
	                    itemId	  : 'SHOW_CODE',
	                    listeners:{
	                    	change:function()	{
	                    		if(this.checked) masterViewTplTemplate.setShowDriver(true);
	                    		else masterViewTplTemplate.setShowDriver(false);
	                    		masterView.refresh();
	                    	}
	                    }
	 		 		},'-',{
	 		 			xtype:'uniNumberfield',
	 		 			hideLabel  : true,
	 		 			id: '${PKGNAME}DUTY_FR_CHANGE',
	                    name  : 'DUTY_FR_CHANGE',
	                    suffixTpl:'&nbsp;분',
	                    value:'30',
	                    width:40
	 		 		},{
	 		 			xtype:'button',
	 		 			text  : '출근시간조정',
	                    handler:function(){
	                    		Ext.each(masterStore.data.items, function(rec, idx) {
	                    				if(!Ext.isEmpty(rec.get("FIRST_DEPARTURE_DATE")) && !Ext.isEmpty(rec.get("FIRST_DEPARTURE_TIME")))	{
		                    				var firstDateTime = new Date(Ext.Date.format(rec.get("FIRST_DEPARTURE_DATE"), 'Y-m-d')+"T"+rec.get("FIRST_DEPARTURE_TIME")+':00Z');
		                    				
		                    				var firstDateTimeUTC = new Date(firstDateTime.getUTCFullYear(), firstDateTime.getUTCMonth()+1, firstDateTime.getUTCDate(), firstDateTime.getUTCHours(), firstDateTime.getUTCMinutes(), firstDateTime.getUTCSeconds());
		                    				
		                    				var fixedDateTimeUTC = UniDate.add(firstDateTimeUTC, {
											    minutes:Ext.getCmp('${PKGNAME}DUTY_FR_CHANGE').getValue()*(-1),
											    clearTime: false
											});
											
											rec.set("DUTY_FR_DATE", UniDate.safeFormat(fixedDateTimeUTC));
					             			rec.set("DUTY_FR_TIME", Ext.Date.format(fixedDateTimeUTC, 'H:i'));
	                    				}
					    		})
	                    }
	 		 		},'-',{
	 		 			xtype:'uniNumberfield',
	 		 			hideLabel  : true,
	 		 			id: '${PKGNAME}DUTY_TO_CHANGE',
	                    name      : 'DUTY_TO_CHANGE',
	                    suffixTpl:'&nbsp;분',
	                    value:'30',
	                    width:40
	 		 		},{
	 		 			xtype:'button',
	 		 			text  : '퇴근시간조정',
	                    handler:function(){
	                    	Ext.each(masterStore.data.items, function(rec, idx) {
	                    			if(!Ext.isEmpty(rec.get("LAST_DEPARTURE_DATE")) && !Ext.isEmpty(rec.get("LAST_DEPARTURE_TIME")))	{
	                    				var lastDateTime = new Date(Ext.Date.format(rec.get("LAST_DEPARTURE_DATE"), 'Y-m-d')+"T"+rec.get("LAST_DEPARTURE_TIME")+':00Z')
	                    				var lastDateTimeUTC = new Date(lastDateTime.getUTCFullYear(), lastDateTime.getUTCMonth()+1, lastDateTime.getUTCDate(), lastDateTime.getUTCHours(), lastDateTime.getUTCMinutes(), lastDateTime.getUTCSeconds());
	                    				
	                    				var fixedDateTime = UniDate.add(lastDateTimeUTC, {
										    minutes: Ext.getCmp('${PKGNAME}DUTY_TO_CHANGE').getValue(),
										    clearTime: false
										});

					             		rec.set("DUTY_TO_DATE", UniDate.safeFormat(fixedDateTime));
				             			rec.set("DUTY_TO_TIME", Ext.Date.format(fixedDateTime, 'H:i'));
	                    			}
					    		})
	                    }
	 		 		},
	 		 		'->',
		        	
	 				{xtype:'component',
           			 html:'<div  style="line-height:20px;">' +
   			 				/*'<img src="'+CPATH+'/resources/images/busoperate/greenO.png"> 정상&nbsp;&nbsp;' +
   			 				'<img src="'+CPATH+'/resources/images/busoperate/yellowO.png"> 변경&nbsp;&nbsp;' +
   			 				'<img src="'+CPATH+'/resources/images/busoperate/redO.png"> 운휴&nbsp;&nbsp;' +
   			 				'<img src="'+CPATH+'/resources/images/busoperate/grayO.png"> 타차&nbsp;&nbsp;&nbsp;&nbsp;' +*/
           			 	  	'<font style="color:#71d071">●</font> 운행&nbsp;&nbsp;'+
           			 	  	'<font style="color:#d17272">●</font> 운휴&nbsp;&nbsp;'+
           			 	  	'<font style="color:#989898">●</font> 타차&nbsp;&nbsp;&nbsp;&nbsp;'+
           			 	  	
           			 	  	'<font style="color:#5b9bd5">■</font> 첫차출발시각&nbsp;&nbsp;'+
           			 	  	'<font style="color:#ed7c31">■</font> 막차출발시각&nbsp;&nbsp;'+
           			 	  	'<font style="color:#ffc000">■</font> 출근시각&nbsp;&nbsp;'+
           			 	  	'<font style="color:#70ad47">■</font> 퇴근시각</div>'
           			}
				],
				tools: [
					{
						type: 'hum-grid',					            
			            handler: function () {
			                masterView.setTemplate('table');
			                UniAppManager.app.down('#SHOW_CODE').setDisabled(true);
			            }
	        		},{
	
						type: 'hum-photo',					            
			            handler: function () {
			                masterView.setTemplate('view');
			                UniAppManager.app.down('#SHOW_CODE').setDisabled(false);
			            }
	        		},{
	
						type: 'plus',					            
			            handler: function () {
			                masterView.setTemplate('small');
			                UniAppManager.app.down('#SHOW_CODE').setDisabled(false);
			            }
	        		}
							
				],
				
	 		 	items: [masterView]
	 		}
			,panelSearch2
		],
		id  : 'gop200ukrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset', 'excel','print','newData'],false);
			//driverStore.loadStoreRecords();
			//busStore.loadStoreRecords();	
		},
		
		onQueryButtonDown : function()	{
			masterStore.loadStoreRecords();
		},
		onPrevDataButtonDown:  function()	{
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function()	{
			masterGrid.selectNextRow();
		},		
		onSaveDataButtonDown: function (config) {
			masterStore.saveStore();
					
		},
		onDeleteDataButtonDown : function()	{
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				var me = this;
				
			}
		},
		onResetButtonDown:function() {
			var me = this;
			
			UniAppManager.setToolbarButtons('save',false);
		}
	});

	Unilite.createValidator('${PKGNAME}validator', {
		store : masterStore,
		forms: {'formA:':editForm},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			var form = this.forms["formA:"];
			switch(fieldName)	{
				case 'NOTINSERVICE_YN' :						
					if(newValue == 'Y')	{
						editForm.setValue('CHANGE_FLAG', "NOTINSERVICE");
					}else {
						var otherVehicle = editForm.activeRecord.get("OTHER_VEHICLE_YN"); 				
						if(otherVehicle == "Y" )	{
							editForm.setValue('CHANGE_FLAG', 'OTHER');
						}else {
							editForm.setValue('CHANGE_FLAG', '');
						}
					}
					break;
				default :
					break;
			}
			return rv;
		}
	}); // validator
	
}; // main
  
</script>