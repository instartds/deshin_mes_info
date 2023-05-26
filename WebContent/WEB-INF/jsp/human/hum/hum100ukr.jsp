<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="hum100ukr"  >
	<t:ExtComboStore comboType="AU" comboCode="H012" /><!--  입사코드		 -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /><!--  사원구분		 -->
	<t:ExtComboStore comboType="AU" comboCode="H028" /><!--  급여지급방식	 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /><!--  직위구분		 -->
	<t:ExtComboStore comboType="AU" comboCode="H029" /><!--  세액구분		 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /><!--  급여지급일구분   -->
	<t:ExtComboStore comboType="AU" comboCode="H049" /><!--  월차지급방식	 -->
	<t:ExtComboStore comboType="AU" comboCode="H037" /><!--  상여계산구분자   -->
	<t:ExtComboStore comboType="AU" comboCode="H036" /><!--  잔업계산구분자   -->
	<t:ExtComboStore comboType="AU" comboCode="H006" /><!--  직책			 -->
	<t:ExtComboStore comboType="AU" comboCode="H173" /><!--  직렬			 -->
	<t:ExtComboStore comboType="AU" comboCode="H009" /><!--  최종학력		 -->
	<t:ExtComboStore comboType="AU" comboCode="H008" /><!--  담당업무		 -->
	<t:ExtComboStore comboType="AU" comboCode="H010" /><!--  졸업구분		 -->
	<t:ExtComboStore comboType="AU" comboCode="H023" /><!--  퇴사사유		 -->
	<t:ExtComboStore comboType="AU" comboCode="H017" /><!--  병역군별		 -->
	<t:ExtComboStore comboType="AU" comboCode="H018" /><!--  병역계급		 -->
	<t:ExtComboStore comboType="AU" comboCode="H019" /><!--  병역병과		 -->
	<t:ExtComboStore comboType="AU" comboCode="H016" /><!--  병역구분		 -->
	<t:ExtComboStore comboType="AU" comboCode="B012" /><!--  국가			  -->
	<t:ExtComboStore comboType="BOR120" />			   <!--  사업장		   -->
	<t:ExtComboStore comboType="AU" comboCode="B027" /><!--  제조판관		 -->
	<t:ExtComboStore items="${costPoolCombo}" storeId="costPoolCombo"/>		   <!--  Cost Pool		-->
	<t:ExtComboStore comboType="AU" comboCode="H011" /><!--  고용형태		 -->
	<t:ExtComboStore comboType="AU" comboCode="H007" /><!--  거주구분		 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /><!--  화폐단위		 -->
	<t:ExtComboStore comboType="BILL_DIV"/>			   <!--  신고사업장	   -->
	<t:ExtComboStore comboType="AU" comboCode="H112" /><!--  퇴직계산분류	 -->
	<t:ExtComboStore comboType="AU" comboCode="H143" /><!--  양음구분	 -->
	<t:ExtComboStore comboType="AU" comboCode="H144" /><!--  결혼여부	 -->
	<t:ExtComboStore comboType="AU" comboCode="A020" /><!--  예/아니오	 -->
	<t:ExtComboStore comboType="AU" comboCode="H020" /><!--  가족관계	 -->
	<t:ExtComboStore comboType="AU" comboCode="H080" /><!--  혈액형	 -->
	<t:ExtComboStore comboType="AU" comboCode="H081" /><!--  색맹여부	 -->
	<t:ExtComboStore comboType="AU" comboCode="H082" /><!--  주거구분	 -->
	<t:ExtComboStore comboType="AU" comboCode="H083" /><!--  생활수준	 -->
	<t:ExtComboStore comboType="AU" comboCode="H084" /><!--  보훈구분	 -->
	<t:ExtComboStore comboType="AU" comboCode="H085" /><!--  장애구분	 -->
	<t:ExtComboStore comboType="AU" comboCode="H086" /><!--  종교	 -->
	<t:ExtComboStore comboType="AU" comboCode="H163" /><!--  인정경력구분	 -->
	<t:ExtComboStore comboType="AU" comboCode="H087" /><!--  전공학과	  -->
	<t:ExtComboStore comboType="AU" comboCode="H089" /><!--  교육기관	  -->
	<t:ExtComboStore comboType="AU" comboCode="H090" /><!--  교육국가	  -->
	<t:ExtComboStore comboType="AU" comboCode="H091" /><!--  구분	  -->
	<t:ExtComboStore comboType="AU" comboCode="H022" /><!--  자격종류	  -->
	<t:ExtComboStore comboType="AU" comboCode="H094" /><!--  발령코드	  -->
	<t:ExtComboStore comboType="AU" comboCode="H095" /><!--  고과구분	  -->
	<t:ExtComboStore comboType="AU" comboCode="H096" /><!--  상벌종류	  -->
	<t:ExtComboStore comboType="AU" comboCode="H164" /><!--  계약구분	  -->
	<t:ExtComboStore comboType="AU" comboCode="H088" /><!--  비자종류	  -->
	<t:ExtComboStore comboType="AU" comboCode="H167" /><!--  재직구분	  -->
	<t:ExtComboStore items="${BussOfficeCode}" storeId="BussOfficeCode" /><!--  소속지점	  -->
	<t:ExtComboStore comboType="AU" comboCode="H174" />
	<t:ExtComboStore comboType="AU" comboCode="H072" /><!--  직종		 -->
	<t:ExtComboStore comboType="AU" comboCode="H169" /><!--  장애인구분	 -->
	<t:ExtComboStore comboType="AU" comboCode="H204" /><!--  업무속성	  -->
	<t:ExtComboStore comboType="AU" comboCode="H205" /><!--  인적속성	  -->
	<t:ExtComboStore comboType="AU" comboCode="H221" /><!--  퇴직연금 운용사 -->
</t:appConfig>
<link rel="stylesheet" type="text/css" href='<c:url value="/${ext_root}/app/Ext/ux/css/GroupTabPanel.css" />' />
<!-- 파일 첨부 -->
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />'></script>
<script type="text/javascript">
	var protocol = ("https:" == document.location.protocol)  ? "https" : "http"  ;
	if(protocol == "https") {
		document.write( unescape( "%3Cscript src='"+ protocol+ "://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E")  );
	} else {
		document.write( unescape( "%3Cscript src='"+ protocol+ "://dmaps.daum.net/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E") );
	}
</script><!-- Unilite.popup('ZIP',..) -->

<script type="text/javascript" >
var uploadWin;
var detailWin;  // 문서등록 팝업
var costPoolLabel	  = '${costPoolLabel}';
var announceTab	      = '${gsAnnounceTab}';        // 발령사항 탭 표시 여부
var academicBackgrTab = '${gsAcademicBackgrTab}';  // 학력사항 탭 표시여부 

function appMain() {

	/**
	 * Model 정의
	 * @type
	 */
	Unilite.defineModel('hum100ukrModel', {
		// pkGen : user, system(default)
		fields: [
			{name: 'DEPT_CODE',			text: '<t:message code="system.label.human.deptcode" default="부서코드"/>',	type: 'string'},
			{name: 'DEPT_NAME',			text: '<t:message code="system.label.human.department" default="부서"/>',	type: 'string'},
			{name: 'NAME',				text: '<t:message code="system.label.human.name" default="성명"/>',		type: 'string'},
			{name: 'PERSON_NUMB',		text: '<t:message code="system.label.human.personnumb" default="사번"/>',	type: 'string'},
			{name: 'NAME_ENG',			text: '<t:message code="system.label.human.engname" default="영문명"/>',	type: 'string'},
			{name: 'PHONE_NO',			text: '<t:message code="system.label.human.telephone" default="전화번호"/>',type: 'string'},
			{name: 'JOIN_DATE',			text: '<t:message code="system.label.human.joindate" default="입사일"/>'  ,type: 'uniDate'},
			{name: 'RETR_DATE',		text: '<t:message code="system.label.human.retrdate" default="퇴사일"/>'  ,type: 'uniDate'},
			{name: 'NAME_CHI',			text: 'NAME_CHI',		type: 'string'},
			{name: 'DIV_CODE',			text: 'DIV_CODE',		type: 'string'},
			{name: 'POST_CODE',			text: 'POST_CODE',		type: 'string'},
			{name: 'ABIL_CODE',			text: 'ABIL_CODE',		type: 'string'},
			{name: 'ZIP_CODE',			text: 'ZIP_CODE',		type: 'string'},
			{name: 'KOR_ADDR',			text: 'KOR_ADDR',		type: 'string'},
			{name: 'dc',				text: 'dc',				type: 'string'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var searchPanelStore = Unilite.createStore('hum100ukrMasterStore',{
		model	: 'hum100ukrModel',
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read : 'hum100ukrService.selectList'
			}
		},// proxy
		listeners: {
			load: function(){
				console.log("test");
			}
		},// listeners
		// Store 관련 BL 로직
		// 검색 조건을 통해 DB에서 데이타 읽어 오기
		loadStoreRecords : function(personNumb) {
			var param= panelSearch.getValues();
			console.log( param );
			var me = this;
			this.load({
				params	: param,
				callback: function(records, operation, success) {
					if (success) {
						if(!Ext.isEmpty(panelSearch.getValue('TXT_SEARCH'))){
							var sm = panelSearch.down('#textList').getSelectionModel();
							var selRecords = panelSearch.down('#textList').getSelectionModel().getSelection();
							var records = searchPanelStore.data.items;
							var activeTab = panelDetail.down('#hum100Tab').getActiveTab();
							var basicForm;
							if(activeTab.getItemId() == 'personalInfo'){
								basicForm = panelDetail.down('#personalInfo').getValue('PERSON_NUMB');
							}else{
								basicForm = activeTab.down('#basicInfoForm').getValue('PERSON_NUMB');
							}
							if(!Ext.isEmpty(basicForm)){
								Ext.each(records, function(record, index){
									if( basicForm == record.get('PERSON_NUMB')){
										selRecords.push(record);
									}
								});
								sm.select(selRecords);
							}
						}
						var record = me.find('PERSON_NUMB', personNumb);
						panelSearch.down('#imageList').getSelectionModel().select(record);

						//20200602 추가: 저장한 행 보여주기 위해서 추가
						Ext.each(records, function(item, index){
							if( personNumb == item.get('PERSON_NUMB')){
								var view	= textList.getView();
								var navi	= view.getNavigationModel();
								var columns	= textList.getVisibleColumns();
								Ext.each(columns, function(item, idx) {
									if(item.dataIndex && item.dataIndex == 'PERSON_NUMB') {
										columnIndex = idx;
									}
								});
								var currentRecord = textList.getSelectedRecord();
								if(currentRecord) {
									var currRowIndex = textList.store.indexOf(currentRecord);
									navi.setPosition(currRowIndex, columnIndex);
									var normalView = view.getScrollable();
									normalView.scrollTo(0, view.getScrollY()+100, false);
								}
							}
						});


						if(Ext.isEmpty(textList.getSelectedRecord())){//조회 후 마스터그리드 선택된 행이 없을 경우에는 선택된 사람이 없는 것이기 때문에 디테일 정보 클리어 처리
								var activeTab = panelDetail.down('#hum100Tab').getActiveTab();
								var basicInfo1 = activeTab.down('#basicInfo');

								basicInfo1.loadBasicData(null);
								activeTab.loadData(null);
								basicInfo1.down('#EmpImg').getEl().dom.src=CPATH+'/resources/images/human/noPhoto.png';
								basicInfo1.down('#empName').update('');
								basicInfo1.down('#empEngName').update('');
								basicInfo1.down('#empNo').update('');
								basicInfo1.down('#empTel').update('');
								basicInfo1.down('#docaddbutton').setText('문서등록');
								UniAppManager.app.setToolbarButtons('save',false);
								panelDetail.down('#hum100Tab').getEl().unmask();
								panelDetail.getEl().mask();
						}
					}
				}
			});
		},
		loadDetailForm: function(node) {
			var activeTab = panelDetail.down('#hum100Tab').getActiveTab();
			if(!Ext.isEmpty(node)) {
				var data = node.getData();
				if(!Ext.isEmpty(data)) {
					activeTab.loadData(data['PERSON_NUMB']);
					activeTab.down('#basicInfo').loadBasicData(node);
					panelDetail.down('#hum100Tab').getEl().unmask();
				}
			}

			UniAppManager.app.setToolbarButtons('save',false);
		}
	});

	/** 한다/않한다(Y/N) 라디오그룹 Store
	 */
	var ynOptStore = Unilite.createStore('Hum100ukrYNStore', {
		fields	: ['text', 'value'],
		data	: [
			{'text':'<t:message code="system.label.human.do" default="한다"/>'		, 'value':'Y'},
			{'text':'<t:message code="system.label.common.donot" default="안한다"/>'	, 'value':'N'}
		]
	});

	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
	var imageList = Ext.create('Unilite.human.ImageListPanel', {
		itemId	: 'imageList',
		store	: searchPanelStore,
		hidden	: true,
		listeners: {
			selectionchange: function(dv, nodes ){
				var me = this;
				if(!Ext.isEmpty(nodes)) {
					var config = {
						success : function() {
							panelSearch.down('#imageList').dataSelect(nodes[0]);
						}
					};
					if(UniAppManager.app.checkSave(config)) {
						me.dataSelect(nodes[0]);
					}
				}
			}
		},
		dataSelect:function(node) {
			var me = this;
			me.getStore().loadDetailForm(node);
			panelSearch.down('#textList').getSelectionModel().select(node);
		}
	});

	var textList = Unilite.createGrid('hum100ukrGrid', {
		itemId	: 'textList',
		store	: searchPanelStore,
		border	: 0,
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: false,
			onLoadSelectFirst	: false,
			userToolbar			: false,
			useLoadFocus		: false		//20200602 추가: 저장한 행 보여주기 위해서 추가
		},
		hidden	: false,
		selModel: 'rowmodel',
		columns	: [
			{ dataIndex: 'PERSON_NUMB'	,width: 100 },
			{ dataIndex: 'NAME' 		,width: 100 },
			{ dataIndex: 'DEPT_NAME'	,flex:1 },
			{ dataIndex: 'DEPT_CODE'	,width: 80 , hidden: true},
			{ dataIndex: 'PHONE_NO'		,width: 100 , hidden: true},
			{ dataIndex: 'JOIN_DATE'	,width: 100, hidden: true},
			{ dataIndex: 'RETR_DATE'	,width: 100, hidden: true}
			
		],
		listeners: {
			load:function(store, records, successful, eOpts) {
				
				if(successful) {
				}
			},
			selectionchange: function(grid, selNodes ){
				var me = this;
				var config = {success : function() {
											panelSearch.down('#textList').dataSelect(selNodes[0]);
										}
								};
				if(UniAppManager.app.checkSave(config)) {
					me.dataSelect(selNodes[0]);
				}
				panelDetail.unmask();

				// 신규추가일 경우 
				if(selNodes.length < 1) return;
				
				var activeTab = panelDetail.down('#hum100Tab').getActiveTab(); // 활성화된 탭 ID
				var personnum = selNodes[0].data.PERSON_NUMB;
				// 문서 개수 조회
				hum100ukrService.selectDocCnt({DOC_NO : personnum}, function(provider, response){
					if(!Ext.isEmpty(provider)){
						// button enable
						activeTab.getItemId() == 'personalInfo' ? panelDetail.down('#personalInfo').down('#docaddbutton').enable() : true;
						$fileBtn = activeTab.getItemId() == 'personalInfo' 
						              ? panelDetail.down('#docaddbutton')
						              : activeTab.down('#docaddbutton');
						
						if( provider > 0){
							$fileBtn.setText( '문서등록: ' + provider + '건');
						} else {
							$fileBtn.setText( '문서등록');
						}
					}
				});
			}
		},
		dataSelect:function(node) {
			var me = this;

			me.getStore().loadDetailForm(node);
			panelSearch.down('#imageList').getSelectionModel().select(node);
		}
	});

	var panelSearch = Unilite.createSearchPanel('${PKGNAME}_searchForm',{
		title		: '<t:message code="system.label.human.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		defaults	: {
			autoScroll: true
		},
		collapsed	: false,
		width		: 330,
		items		: [{
			title		: '<t:message code="system.label.human.basisinfo" default="기본정보"/>',
			id			: 'search_panel1',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.human.personnumb" default="사번"/>/<t:message code="system.label.human.name" default="성명"/>',
				name		: 'TXT_SEARCH',
				listeners	:{
					specialkey: function(field, e){
						if(e.getKey() == e.ENTER) {
							UniAppManager.app.onQueryButtonDown();
						}
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.human.incumbenttype" default="재직구분"/>',
				name		: 'RETR_DATE',
				xtype		: 'uniRadiogroup',
				width		: 300,
				items		: [{
					boxLabel	: '<t:message code="system.label.human.whole" default="전체"/>',
					name		: 'RETR_DATE',
					inputValue	: '1'
				},{
					boxLabel	: '<t:message code="system.label.human.incumbent" default="재직"/>',
					name		: 'RETR_DATE',
					inputValue	: '00000000',
					checked		: true
				},{
					boxLabel	: '<t:message code="system.label.human.retr" default="퇴사"/>',
					name		: 'RETR_DATE',
					inputValue	: UniDate.getDateStr(new Date())
				}]
			},{
				fieldLabel	: '<t:message code="system.label.human.paygubun" default="고용형태"/>',
				name		: 'PAY_GUBUN',
				xtype		: 'uniRadiogroup',
				width		: 300,
				items		: [{
					boxLabel	: '<t:message code="system.label.human.whole" default="전체"/>',
					name		: 'PAY_GUBUN',
					inputValue	: ''
				},{
					boxLabel	: '<t:message code="system.label.human.fulltime" default="정규직"/>',
					name		: 'PAY_GUBUN',
					inputValue	: '1',
					checked		: true
				},{
					boxLabel	: '<t:message code="system.label.human.irregularwork" default="비정규직"/>',
					name		: 'PAY_GUBUN',
					inputValue	: '2'
				}]
			}]
		},{
			itemId	: 'result',
			border	: 0,
			defaults: {autoScroll:true},
			layout	: {type: 'vbox', align:'stretch'},
			flex	: 1,
			tools	: [{
				type	: 'hum-grid',
				handler	: function () {
					imageList.hide();
					textList.show();
				}
			},{
				type	: 'hum-photo',
				handler	: function () {
					textList.hide();
					imageList.show();
				}
			}/*,{
				type	: 'hum-tree',
				handler	: function () {
				}
			}*/
			],
			items: [textList,imageList]
		}],
		listeners:{
			afterrender: function( form, eOpts ) {
				form.expand(false);
			}
		}
	});	//end panelSearch


	/**
	 * 상세 조회(Detail Form Panel)
	 * @type
	 */
	var basicInfo = {//Ext.create('Unilite.com.form.UniDetailForm', {
		xtype		: 'uniFieldset',
		itemId		: 'basicInfo',
		layout		: {type: 'uniTable', columns:'2'},
		margin		: '10 10 10 10',
		scrollable	: true,
		width		: 900,
		items		: [{
			xtype	: 'container',
			margin	: '10 0 10 0',
			layout	: {type: 'uniTable', columns:'2', tableAttrs:{class:'photo-background'}},
			cls		: 'photo-background',
			width	: 274,
			items	: [{
				xtype	: 'component',
				itemId	: 'EmpImg',
				width	: 130,
				autoEl	: {
					tag: 'img',
					src: CPATH+'/resources/images/human/noPhoto.png',
					cls:'photo-wrap'
				}
			},{
				xtype	: 'container',
				layout	: {type: 'vbox', align:'stretch'},
				width	: 140,
				defaults: {cls:'photo-lable-group'},
				tdAttrs	: {valign:'top'},
				margin	: '20 5 5 5',
				items	: [{
					xtype	: 'component',
					itemId	: 'empName',
					cls		: 'photo-lable-name',
					html	: ' '
				},{
					xtype	: 'component',
					itemId	: 'empEngName',
					cls		: 'photo-lable-engname',
					html	: ' '
				},{
					xtype	: 'component',
					itemId	: 'empNo',
					html	: ' '
				},{
					xtype	: 'component',
					itemId	: 'empTel',
					html	: ' '
				},{
					xtype	: 'component',
					itemId	: 'emptyForm',
					cls:'photo-search-icon ',
					html	: ' '
				},{
					xtype:'container',
					padding : '2 0 0 0',
		        	items:[{
						xtype: 'button',
						text: '문서등록',
						itemId: 'docaddbutton',
						holdable: 'hold',
						width : '80%',
						handler: function() {
							openFileWindow();
						}
					}]
				}]
			}]},{
				xtype	: 'uniDetailForm',
				itemId	: 'basicInfoForm',
				disabled: false,
				layout	: {type: 'uniTable',  columns:'2'},
				margin	: '0 0 5 -5',
				width	: 540,
				bodyCls	: 'human-panel-form-background',
				defaults: {
					width		: 260,
					labelWidth	: 150,
					readOnly	: true
				},
				api		: {
					load: 'hum100ukrService.select'
				},
				items:[{
					fieldLabel	: '<t:message code="system.label.human.personnumb" default="사번"/>'	,
					name		: 'PERSON_NUMB' ,
					width		: 230,
					labelWidth	: 110
				},{
					fieldLabel	: '<t:message code="system.label.human.division" default="사업장"/>',
					name		: 'DIV_CODE' ,
					xtype		: 'uniCombobox',
					comboType	: 'BOR120'
				},{
					fieldLabel	: '<t:message code="system.label.human.name" default="성명"/>',
					name		: 'NAME' ,
					width		: 230,
					labelWidth	: 110
				},{
					fieldLabel	: '<t:message code="system.label.human.department" default="부서"/>',
					name		: 'DEPT_NAME'
				},{
					fieldLabel	: '<t:message code="system.label.human.engname" default="영문명"/>',
					name		: 'NAME_ENG',
					width		: 230,
					labelWidth	: 110
				},{
					fieldLabel	: '<t:message code="system.label.human.postcode" default="직위"/>',
					name		: 'POST_CODE' ,
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'H005'
				},{
					fieldLabel	: '<t:message code="system.label.human.namechi" default="한자명"/>',
					name		: 'NAME_CHI',
					width		: 230,
					labelWidth	: 110
				},{
					fieldLabel	: '<t:message code="system.label.human.abil" default="직책"/>',
					name		: 'ABIL_CODE',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'H006'
				},{
					fieldLabel	: '<t:message code="system.label.human.address2" default="주소"/>',
					name		: 'ZIP_CODE',
					showValue	: false,
					width		: 230,
					labelWidth	: 110
				},{
					fieldLabel	: '<t:message code="system.label.human.serial" default="직렬"/>',
					name		: 'AFFIL_CODE',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'H173'
				},{
					fieldLabel	: '<t:message code="system.label.human.addressdetail" default="상세주소"/>',
					name		: 'KOR_ADDR',
					hideLabel	: true,
					width		: 250,
					margin		: '0 0 0 115'
				},{
					fieldLabel	: '<t:message code="system.label.human.ocpt" default="직종"/>',
					name		: 'KNOC',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'H072'
				}]
			}
		],
		loadBasicData: function(node) {
			var basicForm = this.down('#basicInfoForm').getForm();
			if(!Ext.isEmpty(node)) {
				basicForm.loadRecord(node);
				var data = node.getData();
				this.down('#EmpImg').getEl().dom.src=CPATH+'/uploads/employeePhoto/'+data['PERSON_NUMB'];
				this.down('#empName').update(data['NAME']);
				this.down('#empEngName').update(data['NAME_ENG']);
				this.down('#empNo').update(data['PERSON_NUMB']);
				this.down('#empTel').update(data['PHONE_NO']);

			}else {
//				basicForm.clearForm();
				basicForm.reset();
				if(Ext.isEmpty(textList.getSelectedRecord())){//조회 후 마스터그리드 선택된 행이 없을 경우에는 선택된 사람이 없는 것이기 때문에 디테일 정보 클리어 처리
					this.down('#basicInfoForm').clearForm();
				}
				this.down('#EmpImg').getEl().dom.src=CPATH+'/resources/images/human/noPhoto.png';
				this.down('#empName').update('');
				this.down('#empEngName').update('');
				this.down('#empNo').update('');
				this.down('#empTel').update('');
			}
		}
	};
//인사기본정보
<%@include file="./hum100ukrs01.jsp" %>
//인사추가정보
<%@include file="./hum100ukrs02.jsp" %>
//가족사항
<%@include file="./hum100ukrs03.jsp" %>
//신상정보
/* < %@include file="./hum100ukrs04.jsp" % > */
//급여정보
<%@include file="./hum100ukrs05.jsp" %>
//고정지급/공제
/* < %@include file="./hum100ukrs06.jsp" % > */
//경력사항
<%@include file="./hum100ukrs07.jsp" %>
//학력사항
/* < %@include file="./hum100ukrs08.jsp" % > */
//교육사항
/* < %@include file="./hum100ukrs09.jsp" % >  */
//자격면허
<%@include file="./hum100ukrs10.jsp" %>
//인사변동
//< %@include file="./hum100ukrs11.jsp" % >
//고과사항
//< %@include file="./hum100ukrs12.jsp" % >
//상벌사항
//< %@include file="./hum100ukrs13.jsp" % >
//계약사항
//<%@include file="./hum100ukrs14.jsp" %>
//여권비자
//< %@include file="./hum100ukrs15.jsp" % >
//해외출장
//< %@include file="./hum100ukrs16.jsp" % >
//학자금지원
//< %@include file="./hum100ukrs17.jsp" % >
//추천인
//< %@include file="./hum100ukrs18.jsp" % >
//보증인
//< @include file="./hum100ukrs19.jsp" % >
// 발령사항
<%@include file="./hum100ukrs20.jsp" %>
// 학력사항
<%@include file="./hum100ukrs21.jsp" %>

	// 메뉴탭 지정
	var tabMenu = [personalInfo,		//인사기본정보
				   salaryInfo,			//급여정보
				   etcInfo,				//인사추가정보
				   familyInfo,			//가족사항
				   careerInfo,			//경력사항
				   certificateInfo];	//자격면허
	// 발령사항
	if("Y" == announceTab) {
		tabMenu.push(announceInfo);
	}
	// 학력사항
	if("Y" == academicBackgrTab) {
		tabMenu.push(academicBackground);
	}

	var panelDetail = Ext.create('Ext.panel.Panel', {
		layout	: 'fit',
		region	: 'center',
		disabled: false,
		items	: [{
			xtype		: 'uniGroupTabPanel',
			itemId		: 'hum100Tab',
			activeGroup	: 0,
			collapsed	: false,
			cls			: 'human-panel',
			defaults	: {
				defaults:{
					xtype	: 'container',
					layout	: {type:'vbox', align:'stretch'}
				}
			},
			items		: [{
				defaults:{
					bodyCls		: 'human-panel-form-background',
					border		: 0,
					disabled	: false,
					autoScroll	: true
				},
				items	: tabMenu
			}/*,{
				defaults:{
					bodyCls: 'human-panel-form-background',
					border:0,
					disabled:false,
					autoScroll:true
				},
				items:[
					salaryInfo, 		//급여정보
					deductionInfo		//고정지급/공제
				]
			},{
				defaults:{
					bodyCls: 'human-panel-form-background',
					border:0,
					disabled:false,
					autoScroll:true
				},
				items:[
					careerInfo,			//경력사항
					academicBakground,	//학력사항
					educationInfo,		//교육사항
					certificateInfo		//자격면허
				]
			},{
				defaults:{
					bodyCls: 'human-panel-form-background',
					border:0,
					disabled:false,
					autoScroll:true
				},
				items:[
					hrChanges,			//인사변동
					personalRating,		//고과사항
					disciplinaryInfo	//상벌사항
				]
			},{
				defaults:{
					bodyCls: 'human-panel-form-background',
					border:0,
					disabled:false,
					autoScroll:true
				},
				items:[
					contractInfo,		//계약사항
					visaInfo ,			//여권비자
					abroadTrip,			//해외출장
					schoolExpence,		//학자금지원
					recommender,		//추천인
					surety				//보증인
				]
			}*/
			],
			listeners: {
				afterrender: function( grouptabPanel, eOpts ) {
					this.getEl().mask();
				},
				beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts ) {
					if(Ext.isObject(oldCard)) {
//						var activeTab = panelDetail.down('#hum100Tab').getActiveTab();
//						if(!activeTab.getInvalidMessage()) return false;
						grouptabPanel.mask('Loading');
						var config = {
							success : function() {
								var tabPanel = grouptabPanel;
								var tab		 = oldCard;
								tabPanel.setActiveTab(tab);
							}
						}
						if(UniAppManager.app.checkSave(config)) {
							var record = panelSearch.down('#imageList').getSelectionModel().getSelection();
							if(!Ext.isEmpty(record) ) {
								newCard.loadData(record[0].data['PERSON_NUMB']);
								newCard.down('#basicInfo').loadBasicData(record[0]);
							}else if(Ext.isDefined(this.getEl())) {
								UniAppManager.app.onResetButtonDown();
								Unilite.messageBox('<t:message code="system.message.human.message001" default="사원을 선택하세요."/>');
								this.getEl().mask();
								grouptabPanel.setActiveTab(oldCard);
								return false;
							}

							var nerCardItemId = newCard.getItemId();
							if(nerCardItemId == 'visaInfo') {
								visaInfoSelectedGrid = 'hum100ukrs15_1Grid';
							}
							if( nerCardItemId == 'etcInfo'       ||
								nerCardItemId == 'deductionInfo' ||
								nerCardItemId == 'healthInfo'    ||
								nerCardItemId == 'salaryInfo'    ||
								nerCardItemId == 'recommender'   ||
								nerCardItemId == 'surety'        ||
								nerCardItemId == 'announceInfo'  ||
								nerCardItemId == 'academicBackground') {
								UniAppManager.app.setToolbarButtons('newData',false);
							} else {
								UniAppManager.app.setToolbarButtons('newData',true);
							}
							// 삭제버튼이 그리드가 있는 탭에서 활성화되므로 탭 이동시 비활성화 시킴
							UniAppManager.setToolbarButtons('delete',false);
							grouptabPanel.unmask();
						}else {
							grouptabPanel.setActiveTab(oldCard);
							grouptabPanel.unmask();
							return false;
						}
					}
				},
				// 탭 변경시 문서등록건 존재할 경우 건수 세팅
				tabchange : function( tabPanel, newCard, oldCard, eOpts ) {

					// 초기 세팅 제외
					if(!(oldCard instanceof Ext.panel.Panel)) return true;
					
					var activeTab = newCard; // 활성화된 탭 ID
					var personnum = activeTab.itemId == 'personalInfo' 
								                   ? panelDetail.down('#personalInfo').getField('PERSON_NUMB').originalValue
								                   : activeTab.down('#basicInfoForm').getValue('PERSON_NUMB');
					// 문서 개수 조회
					hum100ukrService.selectDocCnt({DOC_NO : personnum}, function(provider, response){
						if(!Ext.isEmpty(provider)){
							// button enable
							activeTab.itemId == 'personalInfo' ? panelDetail.down('#personalInfo').down('#docaddbutton').enable() : true;
							
							$fileBtn = activeTab.itemId == 'personalInfo' 
							              ? panelDetail.down('#docaddbutton')
							              : activeTab.down('#docaddbutton');
							
							if( provider > 0){
								$fileBtn.setText('문서등록: ' + provider + '건');
							} else {
								$fileBtn.setText('문서등록');
							}
						}
					});
				}
			}
		}]
	}); // detailForm



	function openUploadWindow() {
		var photoForm = Ext.create('Unilite.com.form.UniDetailForm',{
			xtype		: 'uniDetailForm',
			disabled	: false,
			fileUpload	: true,
			itemId		: 'photoForm',
			//url:  CPATH+'/uploads/employeePhoto/upload.do',
			//url:  CPATH+'/fileman/upload.do',
			api			: {
				submit: hum100ukrService.photoUploadFile
			},
			items:[{
				fieldLabel	: '<t:message code="system.label.human.personnumb" default="사번"/>',
				xtype		: 'uniTextfield',
				name		: 'PERSON_NUMB',
				hidden		: true
			},{
				fieldLabel	: '<t:message code="system.label.human.photo" default="사진"/>',
				xtype		: 'filefield',
				buttonOnly	: false,
				flex		: 1,
				name		: 'photoFile',
				buttonText	: '<t:message code="system.label.human.selectfile" default="파일선택"/>',
				width		: 270,
				labelWidth	: 70
			}]
		});
		if(!uploadWin) {
			uploadWin = Ext.create('Ext.window.Window', {
				title		: '<t:message code="system.label.human.uploadphoto" default="사진등록"/>',
				width		: 300,
				height		: 100,
				closable	: false,
				closeAction	: 'hide',
				modal		: true,
				resizable	: true,
				layout		: {
					type: 'fit'
				},
				items		: [ photoForm
					/*, {	xtype:'uniDetailForm',
						disabled:false,
						fileUpload: true,
						itemId:'photoForm',
						//url:  CPATH+'/uploads/employeePhoto/upload.do',
						//url:  CPATH+'/fileman/upload.do',
						api: {
							submit: hum100ukrService.photoUploadFile
						},
						items:[{
								fieldLabel:'사번',
								name:'PERSON_NUMB',
								hidden:true
							},{
								xtype: 'filefield',
								buttonOnly: false,
								fieldLabel: '사진',
								flex:1,
								name: 'photoFile',
								buttonText: '파일선택',
								width: 270,
								labelWidth: 70
							}
						]
				}*/
				],
				listeners	: {
					beforeshow: function( window, eOpts) {
						var dataform	= panelDetail.down('#personalInfo').getForm();
						var config		= {success : function() {
												uploadWin.show();
											}
						}
						if(!dataform.isValid()) {
							var invalidFields		= [];
							var invalidFieldNames	= '';
							dataform.getFields().filterBy(function(field) {
								if (field.validate()) return;
								if(field.isVisible()) {
									if(field.fieldLabel) invalidFieldNames = invalidFieldNames+field.fieldLabel+', ';
									else if(field.up() && field.up().fieldLabel) invalidFieldNames = invalidFieldNames+field.up().fieldLabel+', ';
								}
								invalidFields.push(field);
							});
							console.log("invalidFields : ", invalidFields);
							Unilite.messageBox('<t:message code="system.message.human.message002" default="필수입력사항을 입력하신 후 사진을 올려주세요."/>','<t:message code="system.message.human.message003" default="미입력항목: "/>'+invalidFieldNames.substring(0,invalidFieldNames.length-2));
							return false;
						}else if(UniAppManager.app._needSave()) {
							UniAppManager.app.checkSave(config);
							return false;
						}
					},
					show: function( window, eOpts) {
						window.down('#photoForm').setValue('PERSON_NUMB', panelDetail.down('#personalInfo').getValue('PERSON_NUMB'))
						window.center();
					}
				},
				afterSavePhoto: function() {
					var photoForm = uploadWin.down('#photoForm');
					photoForm.clearForm();
					uploadWin.down('#photoForm').getForm().getFields().items[1].lastValue = '';
					uploadWin.hide();
				},
				afterSuccess: function() {
					var formPanel = this.down('#photoForm');
					var personNumb = formPanel.getValue('PERSON_NUMB');
					//var r = Math.random();
					searchPanelStore.loadStoreRecords(personNumb);
					this.afterSavePhoto();
				},
				tbar:['->', {
					xtype	: 'button',
					text	: '<t:message code="system.label.human.upload" default="올리기"/>',
					handler	: function() {
						var photoForm = uploadWin.down('#photoForm').getForm();
						if(photoForm.getFields().items[1].lastValue != ''){
							if(panelDetail.down('#personalInfo').getForm().isDirty()) {
								photoForm.submit({
									waitMsg: 'Uploading your files...',
									success: function(form, action) {
										uploadWin.afterSuccess();
										UniAppManager.updateStatus("사진파일이 업로드 되었습니다.");
									},
									failure: function(form, action) {
										Unilite.messageBox("사진파일을 확인해 주십시오.", "jpg 파일만 저장가능 합니다.", "실패");
										uploadWin.afterSavePhoto();
									}
								});
//										UniAppManager.app.onSaveDataButtonDown(config);
							}else {
								var photoForm = uploadWin.down('#photoForm').getForm();
								photoForm.submit({
									waitMsg: 'Uploading your files...',
									success: function(form, action) {
										UniAppManager.updateStatus("사진파일이 업로드 되었습니다.");
										uploadWin.afterSuccess();
									},
									failure: function(form, action) {
										Unilite.messageBox("사진파일을 확인해 주십시오.", "jpg 파일만 저장가능 합니다.", "실패");
									}
								});
							}
						}
					}
				},{
					xtype	: 'button',
					text	: '<t:message code="system.label.human.close" default="닫기"/>',
					handler	: function() {
						var photoForm = uploadWin.down('#photoForm').getForm();
						uploadWin.afterSavePhoto();
//						if(photoForm.isDirty()) {
//							if(!Ext.isEmpty(photoForm.getFields().items[1].lastValue)){
//								if(confirm('<t:message code="system.message.human.message004" default="사진이 변경되었습니다. 저장하시겠습니까?"/>')) {
//									var config = {success : function() {
//										// TODO: fix it!!!
//										uploadWin.afterSavePhoto();
//									}
//								}
//								UniAppManager.app.onSaveDataButtonDown(config);
//							}else{
//								// TODO: fix it!!!
//								uploadWin.afterSavePhoto();
//							}
//						}else {
//							uploadWin.hide();
//						}
					}
				}]
			});
		}
		uploadWin.show();
	}	
	
	
	//문서등록
	var detailSearch = Unilite.createSearchForm('DetailForm', {
		layout :  {type : 'uniTable', columns : 3},
		items :[{
			fieldLabel	: ' ',
			xtype		: 'uniTextfield',
			name		: 'ADD_FIDS',
			hidden		: true,
			width		: 815
		},{
			fieldLabel	: ' ',
			xtype		: 'uniTextfield',
			name		: 'DEL_FIDS',
			hidden		: true,
			width		: 815
		}]
	});

	var detailForm = Unilite.createForm('hum100ukrDetail', {
		autoScroll	: true,
		layout		: 'fit',
		layout		: {type: 'uniTable', columns: 4,tdAttrs: {valign:'top'}},
		defaults	: {labelWidth:60},
		disabled	: false,
		items		: [{
			xtype		: 'xuploadpanel',
			id			: 'hum100ukrvFileUploadPanel',
			itemId		: 'fileUploadPanel',
			flex		: 1,
			width		: 975,
			height		: 300,
			listeners	: {
			}
		}],
		loadForm: function() {
			// window 오픈시 form에 Data load
			this.reset();
			this.resetDirtyStatus();
			var win = this.up('uniDetailFormWindow');

			if(win) {	// 처음 윈도열때는 윈독 존재 하지 않음.
				win.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
				win.setToolbarButtons(['prev','next'],true);
			}

			//첨부파일
			var fp = Ext.getCmp('hum100ukrvFileUploadPanel');
			var activeTab = panelDetail.down('#hum100Tab').getActiveTab(); // 활성화된 탭 ID
			var personnum = activeTab.getItemId() == 'personalInfo' 
						                   ? panelDetail.down('#personalInfo').getValue('PERSON_NUMB')
						                   : activeTab.down('#basicInfoForm').getValue('PERSON_NUMB');
			if(!Ext.isEmpty(personnum)) {
				hum100ukrService.getFileList({DOC_NO : personnum}, function(provider, response) {
					fp.loadData(response.result.data);
				})
			} else {
				fp.clear(); //  fp.loadData() 실행 시 데이타 삭제됨.
			}
		},
		listeners : {
			beforeshow: function( window, eOpts) {
						
					}
		}
	});
	
	// 문서등록 팝업창
	function openFileWindow(selRecord, isNew) {

		// form에 data load
		detailForm.loadForm();

		if(!detailWin) {
			detailWin = Ext.create('widget.uniDetailWindow', {
				title	: '문서등록',
				width	: 1000,
				height	: 370,
				isNew	: false,
				x		: 0,
				y		: 0,
				layout	: {type:'vbox', align:'stretch'},
				items	: [detailSearch,detailForm],
				tbar	: ['->',{
					itemId	: 'confirmBtn',
					text	: '문서저장',
					handler	: function() {
						var activeTab = panelDetail.down('#hum100Tab').getActiveTab(); // 활성화된 탭 ID
						var personnum = activeTab.getItemId() == 'personalInfo' 
						                   ? panelDetail.down('#personalInfo').getValue('PERSON_NUMB')
						                   : activeTab.down('#basicInfoForm').getValue('PERSON_NUMB');
						var fp			= Ext.getCmp('hum100ukrvFileUploadPanel');
						var addFiles	= fp.getAddFiles();
						console.log("addFiles : " , addFiles.length)

						if(addFiles.length > 0) {
							detailSearch.setValue('ADD_FIDS', addFiles );
						} else {
							detailSearch.setValue('ADD_FIDS', '' );
						}
						var param = {
							DOC_NO		: personnum,
							ADD_FIDS	: detailSearch.getValue('ADD_FIDS')
						}
						hum100ukrService.insertFileInfo(param , function(provider, response){
							// 저장 완료 리턴 메세지
							if(!Ext.isEmpty(provider) && provider > 0){
								UniAppManager.updateStatus('<t:message code="system.message.sales.message033" default="저장되었습니다."/>');
								// 저장 후 재조회
								hum100ukrService.getFileList({DOC_NO : personnum}, function(provider, response) {
									fp.loadData(response.result.data);
								});
							}
						});
					},
					disabled: false
				},{
					itemId	: 'confirmCloseBtn',
					text	: '문서저장 후 닫기',
					handler	: function() {
						var activeTab = panelDetail.down('#hum100Tab').getActiveTab(); // 활성화된 탭 ID
						var personnum = activeTab.getItemId() == 'personalInfo' 
						                   ? panelDetail.down('#personalInfo').getValue('PERSON_NUMB')
						                   : activeTab.down('#basicInfoForm').getValue('PERSON_NUMB');
						var fp			= Ext.getCmp('hum100ukrvFileUploadPanel');
						var addFiles	= fp.getAddFiles();
						
						console.log("addFiles : " , addFiles.length)

						if(addFiles.length > 0) {
							detailSearch.setValue('ADD_FIDS', addFiles );
						} else {
							detailSearch.setValue('ADD_FIDS', '' );
						}
						var param = {
							DOC_NO		: personnum,
							ADD_FIDS	: detailSearch.getValue('ADD_FIDS')
						}
						// 저장
						hum100ukrService.insertFileInfo(param , function(provider, response){});

						// 문서 개수 조회
						hum100ukrService.selectDocCnt(param, function(provider, response){
							if(!Ext.isEmpty(provider)){
								$fileBtn = activeTab.getItemId() == 'personalInfo' 
								              ? panelDetail.down('#docaddbutton')
								              : activeTab.down('#docaddbutton');
								
								if( provider > 0){
									$fileBtn.setText( '문서등록: ' + provider + '건');
								} else {
									$fileBtn.setText( '문서등록');
								}
							}
						});
						detailWin.hide();
					},
					disabled: false
				},{
					itemId	: 'DeleteBtn',
					text	: '삭제',
					handler	: function() {
						
						var fp			= Ext.getCmp('hum100ukrvFileUploadPanel');
						var delFiles	= fp.getRemoveFiles();
						
						if(delFiles.length > 0) {
							detailSearch.setValue('DEL_FIDS', delFiles );
						} else {
							detailSearch.setValue('DEL_FIDS', '' );
						}
						
						// 삭제
						if(!Ext.isEmpty(detailSearch.getValue('DEL_FIDS'))){
							if(confirm('문서를 삭제 하시겠습니까?')) {
								var param = {
									DEL_FIDS: detailSearch.getValue('DEL_FIDS')
								}
								hum100ukrService.deleteFileInfo(param , function(provider, response){})
							}
						} else {
							Unilite.messageBox('삭제할 문서가 없습니다.');
							return false;
						}
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						var activeTab = panelDetail.down('#hum100Tab').getActiveTab(); // 활성화된 탭 ID
						var personnum = activeTab.getItemId() == 'personalInfo' 
						                   ? panelDetail.down('#personalInfo').getValue('PERSON_NUMB')
						                   : activeTab.down('#basicInfoForm').getValue('PERSON_NUMB');
						var param		= {
								DOC_NO : personnum
						}
						hum100ukrService.selectDocCnt(param, function(provider, response){
							if(!Ext.isEmpty(provider)){
								$fileBtn = activeTab.getItemId() == 'personalInfo' 
								              ? panelDetail.down('#docaddbutton')
								              : activeTab.down('#docaddbutton');
								
								if( provider > 0){
									$fileBtn.setText( '문서등록: ' + provider + '건');
								} else {
									$fileBtn.setText( '문서등록');
								}
							}
						});
						detailWin.hide();
					},
					disabled: false
				}],
				listeners : {
					show:function( window, eOpts) {
						detailForm.body.el.scrollTo('top',0);
					},
					
					// 팝업 띄우기 전 valid체크
					beforeshow: function( window, eOpts) {
						var dataform	= panelDetail.down('#personalInfo').getForm();
						var config		= {success : function() {
												uploadWin.show();
											}
						}
						
						if(!dataform.isValid()) {
							var invalidFields		= [];
							var invalidFieldNames	= '';
							dataform.getFields().filterBy(function(field) {
								if (field.validate()) return;
								if(field.isVisible()) {
									if(field.fieldLabel) invalidFieldNames = invalidFieldNames+field.fieldLabel+', ';
									else if(field.up() && field.up().fieldLabel) invalidFieldNames = invalidFieldNames+field.up().fieldLabel+', ';
								}
								invalidFields.push(field);
							});
							console.log("invalidFields : ", invalidFields);
							Unilite.messageBox('<t:message code="system.message.human.message103" default="필수입력 값을 입력하세요."/>','<t:message code="system.message.human.message003" default="미입력항목: "/>'+invalidFieldNames.substring(0,invalidFieldNames.length-2));
							return false;
							
						} else if (UniAppManager.app._needSave()) {
							UniAppManager.app.checkSave(config);
							return false;
						}
					}
				}
			})
		}
		detailWin.show();
		detailWin.center();
	}



	Unilite.Main({
		id			: 'hum200ukrApp',
		borderItems	: [
			panelSearch, panelDetail
		],
		autoButtonControl : false,
		fnInitBinding : function(params) {
			if (typeof params !== 'undefined') {
				this.processParams(params);
			}
			UniAppManager.setToolbarButtons(['reset', 'excel'],false);
			UniAppManager.setToolbarButtons(['newData','print'],true);
		},
		onSaveAsExcelButtonDown: function() {
			var masterGrid = Ext.getCmp('hum100ukrGrid');
			masterGrid.downloadExcelXml();
		},
		//링크로 넘어오는 params 받는 부분
		processParams: function(params) {
			//this.uniOpt.appParams = params;
			if(params.PGM_ID == 'hum920skr') {
				//alert(params.ESS);
				panelSearch.setValue('TXT_SEARCH'	  , params.PERSON_NUMB);

				UniAppManager.app.onQueryButtonDown();
			} else if (params.PGM_ID == 's_hum920skr_yg') {
				//alert(params.ESS);
				panelSearch.setValue('TXT_SEARCH'	  , params.PERSON_NUMB);

				UniAppManager.app.onQueryButtonDown();
			}
		},
		onQueryButtonDown : function() {
			searchPanelStore.loadStoreRecords();
		},
		onNewDataButtonDown : function() {
			var me = this;
			panelDetail.down('#hum100Tab').getEl().unmask();
			panelDetail.down('#personalInfo').getEl().unmask();

			var config={
				success:function() {
					UniAppManager.app.onNewDataButtonDown();
				}
			};
			var activeTab = panelDetail.down('#hum100Tab').getActiveTab();
			switch(activeTab.getItemId()) {
				case 'personalInfo':
					var config={
						success:function() {
							UniAppManager.app.onNewDataButtonDown();
						}
					};
					if(!me.checkSave(config)) {
						break;
					}
					var selmodel = panelSearch.down('#textList').getSelectionModel().getSelection( );
					panelSearch.down('#textList').getSelectionModel().deselect(selmodel[0]);
					selmodel = panelSearch.down('#imageList').getSelectionModel().getSelection( );
					panelSearch.down('#imageList').getSelectionModel().deselect(selmodel[0]);
					activeTab.clearForm();
					activeTab.down('#basicInfo').loadBasicData(null);

					//기본값셋팅
					var formPanel = panelDetail.down('#personalInfo');
					formPanel.setValue('JOIN_DATE'		, UniDate.get('today'));	//입사일
					formPanel.setValue('NATION_CODE'	, 'KR');					//국적
					formPanel.setValue('LIVE_CODE'		, 'KR');					//국적
					formPanel.setValue('PAY_GUBUN'		, '1');						//고용형태
					formPanel.setValue('PAY_GUBUN2'		, '2')						//일반
					formPanel.setValue('SECT_CODE'		, '01');					//신고사업장
					formPanel.setValue('RETR_OT_KIND'	, 'ST');					//퇴직계산분류
					formPanel.setValue('DIV_CODE'		, '01');					//사업장
					formPanel.setValue('JOIN_CODE'		, '1');						//입사방식
					formPanel.setValue('EMPLOY_TYPE'	, '1');						//사원구분
					formPanel.setValue('DEFORM_YN'	, 'N');							//장애인여부
					formPanel.down('#docaddbutton').setText('문서등록');               // 문서등록 버튼 TEXT
					formPanel.down('#docaddbutton').disable();
					//

					panelDetail.down('#personalInfo').getField('PERSON_NUMB').originalValue = '';
					UniAppManager.setToolbarButtons('save',true);
					// 20210325 조회 후 추가 버튼 클릭시 화면 비활성화 오류 수정
					panelDetail.getEl().unmask();
					break;
				case 'familyInfo':
					var personNum = activeTab.down('#basicInfoForm').getValue('PERSON_NUMB');
					activeTab.down('#hum100ukrs2Grid').createRow({'PERSON_NUMB':personNum});
					break;
				case 'careerInfo':
					var personNum = activeTab.down('#basicInfoForm').getValue('PERSON_NUMB');
					activeTab.down('#hum100ukrs7Grid').createRow({'PERSON_NUMB':personNum});
					break;
				case 'academicBakground':
					var personNum = activeTab.down('#basicInfoForm').getValue('PERSON_NUMB');
					activeTab.down('#hum100ukrs8Grid').createRow({'PERSON_NUMB':personNum});
					break;
				case 'educationInfo':
					var personNum = activeTab.down('#basicInfoForm').getValue('PERSON_NUMB');
					activeTab.down('#hum100ukrs9Grid').createRow({'PERSON_NUMB':personNum});
					break;
				case 'certificateInfo':
					var personNum = activeTab.down('#basicInfoForm').getValue('PERSON_NUMB');
					activeTab.down('#hum100ukrs10Grid').createRow({'PERSON_NUMB':personNum});
					break;
				case 'hrChanges':
					var personNum = activeTab.down('#basicInfoForm').getValue('PERSON_NUMB');
					activeTab.down('#hum100ukrs11Grid').createRow({'PERSON_NUMB':personNum});
					break;
				case 'personalRating':
					var personNum = activeTab.down('#basicInfoForm').getValue('PERSON_NUMB');
					activeTab.down('#hum100ukrs12Grid').createRow({'PERSON_NUMB':personNum});
					break;
				case 'disciplinaryInfo':
					var personNum = activeTab.down('#basicInfoForm').getValue('PERSON_NUMB');
					activeTab.down('#hum100ukrs13Grid').createRow({'PERSON_NUMB':personNum});
					break;
				case 'contractInfo':
					var personNum = activeTab.down('#basicInfoForm').getValue('PERSON_NUMB');
					activeTab.down('#hum100ukrs14Grid').createRow({'PERSON_NUMB':personNum});
					break;
				case 'visaInfo':
					var personNum = activeTab.down('#basicInfoForm').getValue('PERSON_NUMB');
					if(visaInfoSelectedGrid=='hum100ukrs15_2Grid') {
						activeTab.down('#hum100ukrs15_2Grid').createRow({'PERSON_NUMB':personNum});
					}else {
						activeTab.down('#hum100ukrs15_1Grid').createRow({'PERSON_NUMB':personNum});
					}
					break;
				case 'abroadTrip':
					var personNum = activeTab.down('#basicInfoForm').getValue('PERSON_NUMB');
					activeTab.down('#hum100ukrs16Grid').createRow({'PERSON_NUMB':personNum});
					break;
				case 'schoolExpence':
					var personNum = activeTab.down('#basicInfoForm').getValue('PERSON_NUMB');
					activeTab.down('#hum100ukrs17Grid').createRow({'PERSON_NUMB':personNum});
					break;
				default:
					break;
			}
		},
		onPrevDataButtonDown:  function() {
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function() {
			masterGrid.selectNextRow();
		},
		onSaveDataButtonDown: function (config) {
			var me = this;
			var activeTab = panelDetail.down('#hum100Tab').getActiveTab();
			switch(activeTab.getItemId()) {
				case 'personalInfo':
					if(!activeTab.isValid()) {
						UniAppManager.app.findInvalidField(activeTab);
					} else {
						//퇴사일, 퇴사사유 체크
						var formPanel = this.down('#personalInfo');
						var retrDate = formPanel.getValue('RETR_DATE'); //퇴사일
						var retrResn = formPanel.getValue('RETR_RESN'); //퇴사사유

						if((retrDate == null || Ext.isEmpty(retrDate)) && (retrResn != null || !Ext.isEmpty(retrResn))){
							Unilite.messageBox('<t:message code="system.message.human.message005" default="퇴사일를 입하세요."/>');
							formPanel.getField('RETR_DATE').focus();
							break;
						}
						if((retrDate != null || !Ext.isEmpty(retrDate)) && (retrResn == null || Ext.isEmpty(retrResn))){
							Unilite.messageBox('<t:message code="system.message.human.message006" default="퇴사사유를 선택하세요."/>');
							formPanel.getField('RETR_RESN').focus();
							break;
						}

						var activeform = activeTab.getForm();
						activeTab.mask('<t:message code="system.message.human.message010" default="저장중..."/>');
						var param = activeform.getValues();
						param.PERSONALINFO = 'Y';		//인사기본정보 탭에서만  param.setRETR_DATE("00000000"); 로직 태우기 위해
						activeform.submit({
							params: param,
							success:function(form, action) {
								UniAppManager.app.setToolbarButtons('save',false);
								var personNumb = action.result['PERSON_NUM'];

								if(Ext.isEmpty(activeform.getValues().RETR_DATE)){
									panelSearch.setValue('RETR_DATE','00000000');
									searchPanelStore.loadStoreRecords(personNumb);
								}else{
									panelSearch.setValue('RETR_DATE',UniDate.getDateStr(new Date()));
									searchPanelStore.loadStoreRecords(personNumb);
								}
/*	searchPanelStore.loadStoreRecords(personNumb);
인사기본정보 의  퇴사일  변경후 저장시
좌측 조회 조건의 재직에서 데이터가 없어지기 때문에 다른탭 클릭하면
사원정보를 입력하라 는 메시지 뜨는 현상
>저장 시 좌측 그리드 재조회를 태우지 않도록 */
								if(Ext.isDefined(config)) {
									config.success.call(this);
								}
								activeTab.unmask();
								UniAppManager.updateStatus('<t:message code="system.message.human.message007" default="저장되었습니다."/>');
							},
							failure: function(form, action) {	// 2021.07.26 추가 : 에러 발생 후 저장중 로딩바 제거
								activeTab.unmask();
 							}
						})
					}
					break;
				case 'etcInfo':
					var activePanel = activeTab.down('#etcForm');
					if(!activePanel.isValid()) {
						UniAppManager.app.findInvalidField(activePanel);
					} else {
						var activeform = activePanel.getForm();
						var r = true;
						if(!activePanel.chkSupportNum()) {  //부양가족 수 체크
							r = false;
						}
						if(r) {
							activePanel.mask('<t:message code="system.message.human.message010" default="저장중..."/>');
							activeform.submit({
								success:function(form, action) {
									UniAppManager.app.setToolbarButtons('save',false);
									if(Ext.isDefined(config)) {
										config.success.call(this);
									}
									activePanel.unmask();
									UniAppManager.updateStatus('<t:message code="system.message.human.message007" default="저장되었습니다."/>');
								}
							});
						}
					}
					break;
				case 'familyInfo':
					var activeStore = activeTab.down('#hum100ukrs2Grid').getStore();
					activeStore.saveStore();
					break;
				case 'healthInfo':
					var activePanel = activeTab.down('#healthForm');
					if(!activePanel.isValid()) {
						UniAppManager.app.findInvalidField(activePanel);
					} else {
						var activeform = activePanel.getForm();
						activePanel.mask('<t:message code="system.message.human.message010" default="저장중..."/>');
						activeform.submit({
							success:function(form, action) {
								UniAppManager.app.setToolbarButtons('save',false);
								if(Ext.isDefined(config)) {
									config.success.call(this);
								}
								activePanel.unmask();
								UniAppManager.updateStatus('<t:message code="system.message.human.message007" default="저장되었습니다."/>');
							}
						});
					}
					break;
				case 'salaryInfo':
					var activePanel = activeTab.down('#salaryForm');
					if(!activePanel.isValid()) {
						UniAppManager.app.findInvalidField(activePanel);
					} else {
						var activeform = activePanel.getForm();
						var foreignSkillYn = activePanel.getValue('FOREIGN_SKILL_YN');

						if(foreignSkillYn != "Y" && Ext.isEmpty(activePanel.getValue('YOUTH_EXEMP_RATE')) && !Ext.isEmpty(activePanel.getValue('YOUTH_EXEMP_DATE'))){
							Unilite.messageBox('청년세액감면율을 입력해주십시오.');
							activePanel.getField('YOUTH_EXEMP_RATE').focus();
							return false;
						}else if(foreignSkillYn != "Y" && !Ext.isEmpty(activePanel.getValue('YOUTH_EXEMP_RATE')) && Ext.isEmpty(activePanel.getValue('YOUTH_EXEMP_DATE'))){
							Unilite.messageBox('청년세액감면기한을 입력해주십시오.');
							activePanel.getField('YOUTH_EXEMP_DATE').focus();
							return false;
						}else{

							activePanel.mask('<t:message code="system.message.human.message010" default="저장중..."/>');
							activeform.submit({
								success:function(form, action) {
									UniAppManager.app.setToolbarButtons('save',false);
									if(Ext.isDefined(config)) {
										config.success.call(this);
									}
									activePanel.unmask();
									UniAppManager.updateStatus('<t:message code="system.message.human.message007" default="저장되었습니다."/>');
								}
							});
						}
					}
					break;
				case 'deductionInfo':
					var activeStore1 = activeTab.down('#hum100ukrs6_1Grid').getStore();
					var activeStore2 = activeTab.down('#hum100ukrs6_2Grid').getStore();
					activeStore1.saveStore();
					activeStore2.saveStore();
					break;
				case 'careerInfo':
					var activeStore = activeTab.down('#hum100ukrs7Grid').getStore();
					activeStore.saveStore();
					break;
				case 'academicBakground':
					var activeStore = activeTab.down('#hum100ukrs8Grid').getStore();
					activeStore.saveStore();
					break;
				case 'educationInfo':
					var activeStore = activeTab.down('#hum100ukrs9Grid').getStore();
					activeStore.saveStore();
					break;
				case 'certificateInfo':
					var activeStore = activeTab.down('#hum100ukrs10Grid').getStore();
					activeStore.saveStore();
					break;
				case 'hrChanges':
					var activeStore = activeTab.down('#hum100ukrs11Grid').getStore();
					activeStore.saveStore();
					break;
				case 'personalRating':
					var activeStore = activeTab.down('#hum100ukrs12Grid').getStore();
					activeStore.saveStore();
					break;
				case 'disciplinaryInfo':
					var activeStore = activeTab.down('#hum100ukrs13Grid').getStore();
					activeStore.saveStore();
					break;
				case 'contractInfo':
					var activeStore = activeTab.down('#hum100ukrs14Grid').getStore();
					activeStore.saveStore();
					break;
				case 'visaInfo':
					var activeStore1 = activeTab.down('#hum100ukrs15_1Grid').getStore();
					activeStore1.saveStore();
					var activeStore2 = activeTab.down('#hum100ukrs15_2Grid').getStore();
					activeStore2.saveStore();
					break;
				case 'abroadTrip':
					var activeStore = activeTab.down('#hum100ukrs16Grid').getStore();
					activeStore.saveStore();
					break;
				case 'schoolExpence':
					var activeStore = activeTab.down('#hum100ukrs17Grid').getStore();
					activeStore.saveStore();
					break;
				case 'recommender':
					var activePanel = activeTab.down('#recommenderForm');
					if(!activePanel.isValid()) {
						UniAppManager.app.findInvalidField(activePanel);
					} else {
						var activeform = activePanel.getForm();
						activePanel.mask('<t:message code="system.message.human.message010" default="저장중..."/>');
						activeform.submit(
							{
								success:function(form, action) {
									UniAppManager.app.setToolbarButtons('save',false);
									if(Ext.isDefined(config)) {
										config.success.call(this);
									}
									activePanel.unmask();
									UniAppManager.updateStatus('<t:message code="system.message.human.message007" default="저장되었습니다."/>');
								}
							}
						);
					}
					break;
				case 'surety':
					var activePanel = activeTab.down('#suretyForm');
					if(!activePanel.isValid()) {
						UniAppManager.app.findInvalidField(activePanel);
					} else {
						var activeform = activePanel.getForm();
						activePanel.mask('<t:message code="system.message.human.message010" default="저장중..."/>');
						activeform.submit(
							{
								success:function(form, action) {
									UniAppManager.app.setToolbarButtons('save',false);
									if(Ext.isDefined(config)) {
										config.success.call(this);
									}
									activeform.unmask();
									UniAppManager.updateStatus('<t:message code="system.message.human.message007" default="저장되었습니다."/>');
								}
							}
						);
					}
					break;
				default:
					break;
			}
		},
/*		onDeleteDataButtonDown : function() {
			if(confirm('<t:message code="system.message.human.message008" default="현재행을 삭제 합니다."/>\n <t:message code="system.message.human.message009" default="삭제 하시겠습니까?"/>')) {
				var me = this;
				var activeTab = panelDetail.down('#hum100Tab').getActiveTab();
				switch(activeTab.getItemId()) {
					case 'familyInfo':
						var activeGrid =  activeTab.down('#hum100ukrs2Grid');
						activeGrid.deleteSelectedRow();
						break;
					case 'deductionInfo':
						var activeGrid1 =  activeTab.down('#hum100ukrs6_1Grid');
						activeGrid1.deleteSelectedRow();
						var activeGrid2 =  activeTab.down('#hum100ukrs6_2Grid');
						activeGrid2.deleteSelectedRow();
						break;
					case 'careerInfo':
						var activeGrid =  activeTab.down('#hum100ukrs7Grid');
						activeGrid.deleteSelectedRow();
						break;
					case 'academicBakground':
						var activeGrid =  activeTab.down('#hum100ukrs8Grid');
						activeGrid.deleteSelectedRow();
						break;
					case 'educationInfo':
						var activeGrid =  activeTab.down('#hum100ukrs9Grid');
						activeGrid.deleteSelectedRow();
						break;
					case 'certificateInfo':
						var activeGrid =  activeTab.down('#hum100ukrs10Grid');
						activeGrid.deleteSelectedRow();
						break;
					case 'hrChanges':
						var activeGrid =  activeTab.down('#hum100ukrs11Grid');
						activeGrid.deleteSelectedRow();
						break;
					case 'personalRating':
						var activeGrid =  activeTab.down('#hum100ukrs12Grid');
						activeGrid.deleteSelectedRow();
						break;
					case 'disciplinaryInfo':
						var activeGrid =  activeTab.down('#hum100ukrs13Grid');
						activeGrid.deleteSelectedRow();
						break;
					case 'contractInfo':
						var activeGrid =  activeTab.down('#hum100ukrs14Grid');
						activeGrid.deleteSelectedRow();
						break;
					case 'visaInfo':
						if(visaInfoSelectedGrid=='hum100ukrs15_2Grid') {
							var activeGrid =  activeTab.down('#hum100ukrs15_2Grid');
							activeGrid.deleteSelectedRow();
						}else {
							var activeGrid =  activeTab.down('#hum100ukrs15_1Grid');
							activeGrid.deleteSelectedRow();
						}
						break;
					case 'abroadTrip':
						var activeGrid =  activeTab.down('#hum100ukrs16Grid');
						activeGrid.deleteSelectedRow();
						break;
					case 'schoolExpence':
						var activeGrid =  activeTab.down('#hum100ukrs17Grid');
						activeGrid.deleteSelectedRow();
						break;
					default:
						break;
				}
			}
		},*/
		onResetButtonDown:function() {
			var me = this;
			var activeTab = panelDetail.down('#hum100Tab').getActiveTab();
			var basicInfo = activeTab.down('#basicInfo');
			basicInfo.loadBasicData(null);
			activeTab.loadData(null);
			/* switch(activeTab.getItemId()) {
				case 'personalInfo':
					activeTab.clearForm();
					break;
				case 'etcInfo':
					var activePanel = activeTab.down('#etcForm');
					activePanel.clearForm();
					break;
				case 'familyInfo':
					var activeGrid = activeTab.down('#hum100ukrs2Grid');
					activeGrid.reset();
					break;
				case 'healthInfo':
					var activePanel = activeTab.down('#healthForm');
					activePanel.clearForm();
					break;
				case 'salaryInfo':
					var activePanel = activeTab.down('#salaryForm');
					activePanel.clearForm();
					break;
				case 'deductionInfo':
					var activeGrid1 = activeTab.down('#hum100ukrs6_1Grid');
					activeGrid1.reset();
					var activeGrid2 = activeTab.down('#hum100ukrs6_2Grid');
					activeGrid2.reset();
					break;
				case 'careerInfo':
					var activeGrid = activeTab.down('#hum100ukrs7Grid');
					activeGrid.reset();
					break;
				case 'academicBakground':
					var activeGrid = activeTab.down('#hum100ukrs8Grid');
					activeGrid.reset();
					break;
				case 'educationInfo':
					var activeGrid = activeTab.down('#hum100ukrs9Grid');
					activeGrid.reset();
					break;
				case 'certificateInfo':
					var activeGrid = activeTab.down('#hum100ukrs10Grid');
					activeGrid.reset();
					break;
				case 'hrChanges':
					var activeGrid = activeTab.down('#hum100ukrs11Grid');
					activeGrid.reset();
					break;
				case 'personalRating':
					var activeGrid = activeTab.down('#hum100ukrs12Grid');
					activeGrid.reset();
					break;
				case 'disciplinaryInfo':
					var activeGrid = activeTab.down('#hum100ukrs13Grid');
					activeGrid.reset();
					break;
				case 'contractInfo':
					var activeGrid = activeTab.down('#hum100ukrs14Grid');
					activeGrid.reset();
					break;
				case 'visaInfo':
					var activeGrid1 = activeTab.down('#hum100ukrs15_1Grid');
					activeGrid1.reset();
					var activeGrid2 = activeTab.down('#hum100ukrs15_2Grid');
					activeGrid2.reset();
					break;
				case 'abroadTrip':
					var activeGrid = activeTab.down('#hum100ukrs16Grid');
					activeGrid.reset();
					break;
				case 'schoolExpence':
					var activeGrid = activeTab.down('#hum100ukrs17Grid');
					activeGrid.reset();
					break;
				case 'recommender':
					var activePanel = activeTab.down('#recommenderForm');
					activePanel.clearForm();
					break;
				case 'surety':
					var activePanel = activeTab.down('#suretyForm');
					activePanel.clearForm();
					break;
				default:
					break;
			}*/
			UniAppManager.setToolbarButtons('save',false);
		},
		onDeleteDataButtonDown : function() {
			if(confirm('<t:message code="system.message.human.message008" default="현재행을 삭제 합니다."/>', '<t:message code="system.message.human.message009" default="삭제 하시겠습니까?"/>')) {
				var me = this;
				var activeTab = panelDetail.down('#hum100Tab').getActiveTab();
				switch(activeTab.getItemId()) {
					case 'personalInfo':
						var selectedRec = textList.getSelectedRecord();

						if(!Ext.isEmpty(selectedRec)){
							var param = {
								"PERSON_NUMB" : selectedRec.get('PERSON_NUMB')
							};

							hum100ukrService.personalInfoDelete(param, function(provider, response)  {
								if(!Ext.isEmpty(provider)){
									if(provider=='C'){
										Unilite.messageBox('<t:message code="system.message.human.message134" default="근태 및 급상여자료가 존재하는 사원은 삭제하실수 없습니다."/>');	//다국어 서버 이전으로 대기
									}else if(provider=='Y'){
										Unilite.messageBox('<t:message code="system.message.human.message133" default="삭제 되었습니다."/>');
										var activeTab = panelDetail.down('#hum100Tab').getActiveTab();
										var basicInfo = activeTab.down('#basicInfo');
										basicInfo.loadBasicData(null);
										activeTab.loadData(null);
//										UniAppManager.setToolbarButtons('save',false);
										searchPanelStore.loadStoreRecords();

									}else{
										Unilite.messageBox('<t:message code="system.message.human.message131" default="데이터를 확인해 주십시오."/>');
									}
								}else{
									Unilite.messageBox('<t:message code="system.message.human.message131" default="데이터를 확인해 주십시오."/>');
								}

							});
						}else{
							Unilite.messageBox('<t:message code="system.message.human.message132" default="삭제 할 데이터가 없습니다."/>');
						}

						break;
					case 'familyInfo':
						var activeGrid =  activeTab.down('#hum100ukrs2Grid');
						activeGrid.deleteSelectedRow();
						break;
					case 'deductionInfo':
						var activeGrid1 =  activeTab.down('#hum100ukrs6_1Grid');
						activeGrid1.deleteSelectedRow();
						var activeGrid2 =  activeTab.down('#hum100ukrs6_2Grid');
						activeGrid2.deleteSelectedRow();
						break;
					case 'careerInfo':
						var activeGrid =  activeTab.down('#hum100ukrs7Grid');
						activeGrid.deleteSelectedRow();
						break;
					case 'academicBakground':
						var activeGrid =  activeTab.down('#hum100ukrs8Grid');
						activeGrid.deleteSelectedRow();
						break;
					case 'educationInfo':
						var activeGrid =  activeTab.down('#hum100ukrs9Grid');
						activeGrid.deleteSelectedRow();
						break;
					case 'certificateInfo':
						var activeGrid =  activeTab.down('#hum100ukrs10Grid');
						activeGrid.deleteSelectedRow();
						break;
					case 'hrChanges':
						var activeGrid =  activeTab.down('#hum100ukrs11Grid');
						activeGrid.deleteSelectedRow();
						break;
					case 'personalRating':
						var activeGrid =  activeTab.down('#hum100ukrs12Grid');
						activeGrid.deleteSelectedRow();
						break;
					case 'disciplinaryInfo':
						var activeGrid =  activeTab.down('#hum100ukrs13Grid');
						activeGrid.deleteSelectedRow();
						break;
					case 'contractInfo':
						var activeGrid =  activeTab.down('#hum100ukrs14Grid');
						activeGrid.deleteSelectedRow();
						break;
					case 'visaInfo':
						if(visaInfoSelectedGrid=='hum100ukrs15_2Grid') {
							var activeGrid =  activeTab.down('#hum100ukrs15_2Grid');
							activeGrid.deleteSelectedRow();
						}else {
							var activeGrid =  activeTab.down('#hum100ukrs15_1Grid');
							activeGrid.deleteSelectedRow();
						}
						break;
					case 'abroadTrip':
						var activeGrid =  activeTab.down('#hum100ukrs16Grid');
						activeGrid.deleteSelectedRow();
						break;
					case 'schoolExpence':
						var activeGrid =  activeTab.down('#hum100ukrs17Grid');
						activeGrid.deleteSelectedRow();
						break;
					default:
						break;
				}
			}
			// 20210325 삭제 후 삭제버튼 enable 처리
			UniAppManager.setToolbarButtons('delete',false);
		},
		onPrintButtonDown: function() {
			var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
			if(!Ext.isEmpty(records) ) {
				var pPersonNumb = Ext.isArray(records)? records[0].get('PERSON_NUMB') : records.get('PERSON_NUMB')
				var win = Ext.create('widget.PDFPrintWindow', {
					prgID: 'hum960rkr',
					url: CPATH+'/human/hum960rkrPrint.do',
					extParam: {
						PERSON_NUMB: pPersonNumb
					}
				});
				win.show();
			}else if(Ext.isDefined(this.getEl())) {
				UniAppManager.app.onResetButtonDown();
				Unilite.messageBox('<t:message code="system.message.human.message001" default="사원을 선택하세요."/>');
				return false;
			}
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		},
		checkSave:function(config) {
			var me = this;
			if( me._needSave() ) {
				if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {
					me.onSaveDataButtonDown(config);
					return false;
				}else {
					UniAppManager.setToolbarButtons('save',false);
				}
			}
			return true;
		},
		findInvalidField:function(formPanel) {
			var invalid = formPanel.getForm().getFields().filterBy(function(field) {
				return !field.validate();
			});
			if(invalid.length > 0) {
				r=false;
				var labelText = ''
				if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
					var labelText = invalid.items[0]['fieldLabel']+'은(는)';
				}else if(Ext.isDefined(invalid.items[0].ownerCt)) {
					var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
				}
				Unilite.messageBox(labelText+Msg.sMB083);
				invalid.items[0].focus();
			}
		}
	});	// Main

	Unilite.createValidator('validator04', {
		store: hum100ukrs2Store,
		grid: panelDetail.down('#hum100ukrs2Grid'),
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "REPRE_NUM_EXPOS" :

					if(!Ext.isEmpty(newValue)){
						newValue = newValue.replace(/-/g,'');
						if(!Ext.isNumeric(newValue) && !Ext.isEmpty(newValue)) {
							rv= '<t:message code="system.message.human.message046" default="숫자만 입력가능합니다."/>';
							break;
						}
						if(Unilite.validate('residentno',newValue) != true && !Ext.isEmpty(newValue)) {
							if(!confirm('<t:message code="system.message.human.message137" default="잘못된 주민등록번호를 입력하셨습니다."/>'+'\n'+'<t:message code="system.message.human.message136" default="잘못된 주민등록번호를 저장하시겠습니까?"/>')) {
								rv = false;
								break;
							}
						}
						var param = {
							"DECRYP_WORD" : newValue
						};
						humanCommonService.encryptField(param, function(provider, response)  {
							if(!Ext.isEmpty(provider)){
								record.set('REPRE_NUM',provider);
							}else{
								record.set('REPRE_NUM_EXPOS','');
								record.set('REPRE_NUM','');
							}
						});

					}
					break;
			}
			return rv;
		}
	});
}; // main
</script>