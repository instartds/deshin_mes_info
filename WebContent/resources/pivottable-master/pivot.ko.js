(function() {
  var callWithJQuery;

  callWithJQuery = function(pivotModule) {
    if (typeof exports === "object" && typeof module === "object") {
      return pivotModule(require("jquery"));
    } else if (typeof define === "function" && define.amd) {
      return define(["jquery"], pivotModule);
    } else {
      return pivotModule(jQuery);
    }
  };

  callWithJQuery(function($) {
    var koFmt, koFmtInt, koFmtPct, nf, tpl;
    nf = $.pivotUtilities.numberFormat;
    tpl = $.pivotUtilities.aggregatorTemplates;
    koFmt = nf({
      thousandsSep: ",",
      decimalSep: "."
    });
    koFmtInt = nf({
      digitsAfterDecimal: 0,
      thousandsSep: ",",
      decimalSep: "."
    });
    koFmtPct = nf({
      digitsAfterDecimal: 1,
      scaler: 100,
      suffix: "%",
      thousandsSep: ",",
      decimalSep: "."
    });
    return $.pivotUtilities.locales.ko = {
	      localeStrings: {
	    	  renderError: "피벗 테이블 결과를 렌더링하는 동안 오류가 발생했습니다.",
	          computeError: "피벗 테이블 결과를 계산하는 동안 오류가 발생했습니다.",
	          uiRenderError: "피벗 테이블 UI를 렌더링하는 동안 오류가 발생했습니다.",
	          selectAll: "전체선택",
	          selectNone: "선택없음",
	          tooMany: "(너무 많아 열거할 수 없음)",
	          filterResults: "필터 값",
	          apply: "적용",
	          cancel: "취소",
	          totals: "합계",
	          vs: "대",
	          by: "의"
	      },
	      aggregators: {
	        "개수": tpl.count(koFmtInt),
	        //"개수 (고유값)": tpl.countUnique(koFmtInt),
	        //"목록 (고유값)": tpl.listUnique(", "),
	        "합계": tpl.sum(koFmt),
	        "정수 합계": tpl.sum(koFmtInt),
	        "평균": tpl.average(koFmt),
	        //"중앙값": tpl.median(koFmt),
	        "표본분산": tpl["var"](1, koFmt),
	        "표본표준편자": tpl.stdev(1, koFmt),
	        "최소": tpl.min(koFmt),
	        "최대": tpl.max(koFmt),
	        //"최초": tpl.first(koFmt),
	        //"마지막": tpl.last(koFmt),
	        //"두 합계의 비율": tpl.sumOverSum(koFmt),
	        //"80% 상한": tpl.sumOverSumBound80(true, koFmt),
	        //"80% 하한": tpl.sumOverSumBound80(false, koFmt),
	        "합계비율": tpl.fractionOf(tpl.sum(), "total", koFmtPct),
	        //"행 합계비율": tpl.fractionOf(tpl.sum(), "row", koFmtPct),
	        //"열 합계비율": tpl.fractionOf(tpl.sum(), "col", koFmtPct),
	        "개수비율": tpl.fractionOf(tpl.count(), "total", koFmtPct)//,
	        //"행 개수비율": tpl.fractionOf(tpl.count(), "row", koFmtPct),
	        //"열 개수비율": tpl.fractionOf(tpl.count(), "col", koFmtPct)
	    },
	    renderers: {
	          "표": $.pivotUtilities.renderers["Table"],
		      "표(막대그래프)": $.pivotUtilities.renderers["Table Barchart"],
		      "히트맵(열지도)": $.pivotUtilities.renderers["Heatmap"],
		      "히트맵（행）": $.pivotUtilities.renderers["Row Heatmap"],
		      "히트맥（열）": $.pivotUtilities.renderers["Col Heatmap"]
	    }
    };
  });

}).call(this);


