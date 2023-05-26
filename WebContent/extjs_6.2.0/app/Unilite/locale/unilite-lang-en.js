

Ext.define("Unilite.locale.ko.com.BaseApp", {
    override: "Unilite.com.BaseApp",
    text: {
        btnQuery: '조회',
        btnReset: '신규',
        btnNewData: '추가',
        btnDelete: '삭제',
        btnSave: '저장',
        btnDeleteAll: '전체삭제',
        btnExcel: '다운로드',
        btnPrev: '이전',
        btnNext: '이후',
        btnDetail: '추가검색',
        btnClose: '닫기'
    }
});

Ext.define("Unilite.locale.ko.com.BaseJSPopupApp", {
    override: "Unilite.com.BaseJSPopupApp",
	text: {
	        btnQuery: '조회',
	        btnReset: '신규',
	        btnNewData: '추가',
	        btnDelete: '삭제',
	        btnSave: '저장',
	        btnDeleteAll: '전체삭제',
	        btnExcel: '다운로드',
	        btnPrev: '이전',
	        btnNext: '이후',
	        btnDetail: '추가검색',
	        btnClose: '닫기'
	    }
});
    
Ext.define("Unilite.locale.ko.com.form.field.UniYearField", {
    override: "Unilite.com.form.field.UniYearField",
    minText : "연도는 {0}보다 같더나 커야 합니다.",
    maxText : "연도는 {0}보다 같거나 작아야 합니다.",
    invalidText : "{0} 는 유효한 연도가 아닙니다."
});


Ext.define("Unilite.locale.ko.com.tab.UniTabScrollerMenu", {
    override: "Unilite.com.tab.UniTabScrollerMenu",
    text: {
//	    closeWinMsgTitle: "확인",
//	    closeWinMsgMessage : "비활성창 닫기",
        closeAllTabs: "모든창 닫기",
        closeOthersTabs: "비활성창 닫기"
    }
});



Ext.define("Unilite.locale.ko.main.MainContentPanel", {
    override: "Unilite.main.MainContentPanel",
    text: {
    	closeWinMsgTitle: "확인",
	    closeWinMsgMessage : "저장되지 않은 자료가 있습니다. 현재 페이지를 닫으시겠습니까?"    
    }
});

Ext.define("Unilite.locale.ko.com.grid.UniGridPanel", {
    override: "Unilite.com.grid.UniGridPanel",
    uniText: {
		sortingBar: {
			btnSort: '정렬',
			sortingOrder: '정렬순서',
			dragAndDropHelp: '이곳에 필드명을 가져다 놓으세요.'
		},
		groupingBar: {
			btnGroup: '그룹핑',
			groupColumn: '그룹항목',
			dragAndDropHelp: '이곳에 필드명을 가져다 놓으세요.'
		},
		searchBar: {
			btnFind: '내용검색',
			searchColumn: '내용검색',
			emptyText: '검색어를 입력하세요.',
			btnPrev: '이전 찾기',
			btnNext: '다음 찾기'
		},
		btnSummary: '합계표시',
		btnExcel: '엑셀 다운로드',
		columns: {
			etc: '*'
		},
		contextMenu: {
			rowCopy: '행 복사',
			rowPaste: '복사한 행 삽입'
		}
	}
});
