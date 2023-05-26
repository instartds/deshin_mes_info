!function(e,n){if("object"==typeof exports&&"object"==typeof module)module.exports=n();else if("function"==typeof define&&define.amd)define([],n);else{var r=n();for(var t in r)("object"==typeof exports?exports:e)[t]=r[t]}}(window,(function(){return function(e){var n={};function r(t){if(n[t])return n[t].exports;var a=n[t]={i:t,l:!1,exports:{}};return e[t].call(a.exports,a,a.exports,r),a.l=!0,a.exports}return r.m=e,r.c=n,r.d=function(e,n,t){r.o(e,n)||Object.defineProperty(e,n,{enumerable:!0,get:t})},r.r=function(e){"undefined"!=typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(e,"__esModule",{value:!0})},r.t=function(e,n){if(1&n&&(e=r(e)),8&n)return e;if(4&n&&"object"==typeof e&&e&&e.__esModule)return e;var t=Object.create(null);if(r.r(t),Object.defineProperty(t,"default",{enumerable:!0,value:e}),2&n&&"string"!=typeof e)for(var a in e)r.d(t,a,function(n){return e[n]}.bind(null,a));return t},r.n=function(e){var n=e&&e.__esModule?function(){return e.default}:function(){return e};return r.d(n,"a",n),n},r.o=function(e,n){return Object.prototype.hasOwnProperty.call(e,n)},r.p="",r(r.s="./examples/localization/locales/custom.locale.SvSE.js")}({"../Core/lib/Core/localization/LocaleHelper.js":
/*!*****************************************************!*\
  !*** ../Core/lib/Core/localization/LocaleHelper.js ***!
  \*****************************************************/
/*! exports provided: default */function(module,__webpack_exports__,__webpack_require__){"use strict";eval('__webpack_require__.r(__webpack_exports__);\n/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return LocaleHelper; });\nfunction ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) { symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); } keys.push.apply(keys, symbols); } return keys; }\n\nfunction _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(Object(source), true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }\n\nfunction _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }\n\nfunction _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }\n\nfunction _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }\n\nfunction _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }\n\nfunction _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }\n\n/**\n * @module Core/localization/LocaleHelper\n */\n\n/**\n * Provides locale management methods.\n */\nvar LocaleHelper = /*#__PURE__*/function () {\n  function LocaleHelper() {\n    _classCallCheck(this, LocaleHelper);\n  }\n\n  _createClass(LocaleHelper, null, [{\n    key: "mergeLocales",\n    value:\n    /**\n     * Merges all properties of provided locales into new locale.\n     * Locales are merged in order they provided and locales which go later replace same properties of previous locales.\n     * @param {...Object} locales Locales to merge\n     * @return {Object} Merged locale\n     */\n    function mergeLocales() {\n      var result = {};\n\n      for (var _len = arguments.length, locales = new Array(_len), _key = 0; _key < _len; _key++) {\n        locales[_key] = arguments[_key];\n      }\n\n      locales.forEach(function (locale) {\n        Object.keys(locale).forEach(function (key) {\n          if (_typeof(locale[key]) === \'object\') {\n            result[key] = _objectSpread(_objectSpread({}, result[key]), locale[key]);\n          } else {\n            result[key] = locale[key];\n          }\n        });\n      });\n      return result;\n    }\n    /**\n     * Removes all properties from `locale` that are present in the provided `trimLocale`.\n     * @param {Object} locale locales to merge\n     * @param {Object} trimLocale locales to merge\n     */\n\n  }, {\n    key: "trimLocale",\n    value: function trimLocale(locale, _trimLocale) {\n      var remove = function remove(key, subKey) {\n        if (!locale[key]) {\n          throw new Error("Key \\"".concat(key, "\\" doesn\'t exist in locale"));\n        }\n\n        if (subKey) {\n          if (!locale[key][subKey]) {\n            throw new Error("SubKey \\"".concat(key, ".").concat(subKey, "\\" doesn\'t exist in locale"));\n          }\n\n          delete locale[key][subKey];\n        } else {\n          delete locale[key];\n        }\n      };\n\n      Object.keys(_trimLocale).forEach(function (key) {\n        if (Object.keys(_trimLocale[key]).length > 0) {\n          Object.keys(_trimLocale[key]).forEach(function (subKey) {\n            return remove(key, subKey);\n          });\n        } else {\n          remove(key);\n        }\n      });\n    }\n    /**\n     * Put the locale under `window.bryntum.locales` to make sure it can be discovered automatically\n     * @param {String} localeName Locale name\n     * @param {Object} config Locale config\n     */\n\n  }, {\n    key: "publishLocale",\n    value: function publishLocale(localeName, config) {\n      var bryntum = window.bryntum = window.bryntum || {},\n          locales = bryntum.locales = bryntum.locales || {}; // Avoid registering locales twice\n\n      locales[localeName] = !locales[localeName] ? config : this.mergeLocales(locales[localeName], config);\n    }\n  }]);\n\n  return LocaleHelper;\n}();\n\n\n\n//# sourceURL=webpack:///../Core/lib/Core/localization/LocaleHelper.js?')},"../Core/lib/Core/localization/SvSE.js":
/*!*********************************************!*\
  !*** ../Core/lib/Core/localization/SvSE.js ***!
  \*********************************************/
/*! exports provided: default */function(module,__webpack_exports__,__webpack_require__){"use strict";eval("__webpack_require__.r(__webpack_exports__);\nvar localeName = 'SvSE',\n    localeDesc = 'Svenska',\n    locale = {\n  localeName: localeName,\n  localeDesc: localeDesc,\n  Object: {\n    Yes: 'Ja',\n    No: 'Nej',\n    Cancel: 'Avbryt',\n    Ok: 'OK'\n  },\n  //region Widgets\n  Combo: {\n    noResults: 'Inga resultat'\n  },\n  FilePicker: {\n    file: 'Fil'\n  },\n  Field: {\n    // native input ValidityState statuses\n    badInput: 'Ogiltigt värde',\n    patternMismatch: 'Värdet ska matcha ett specifikt mönster',\n    rangeOverflow: function rangeOverflow(value) {\n      return \"V\\xE4rdet m\\xE5ste vara mindre \\xE4n eller lika med \".concat(value.max);\n    },\n    rangeUnderflow: function rangeUnderflow(value) {\n      return \"V\\xE4rdet m\\xE5ste vara st\\xF6rre \\xE4n eller lika med \".concat(value.min);\n    },\n    stepMismatch: 'Värdet bör passa steget',\n    tooLong: 'Värdet för långt',\n    tooShort: 'Värdet för kort',\n    typeMismatch: 'Värdet är inte i förväntat format',\n    valueMissing: 'Detta fält är obligatoriskt',\n    invalidValue: 'Ogiltigt värde',\n    minimumValueViolation: 'För lågt värde',\n    maximumValueViolation: 'För högt värde',\n    fieldRequired: 'Detta fält är obligatoriskt',\n    validateFilter: 'Värdet måste väljas från listan'\n  },\n  DateField: {\n    invalidDate: 'Ogiltigt datum'\n  },\n  NumberFormat: {\n    locale: 'sv-SE',\n    currency: 'SEK'\n  },\n  DurationField: {\n    invalidUnit: 'Ogiltig enhet'\n  },\n  TimeField: {\n    invalidTime: 'Ogiltig tid'\n  },\n  List: {\n    loading: 'Laddar...'\n  },\n  // needed here due to LoadMaskable\n  GridBase: {\n    loadMask: 'Laddar...',\n    syncMask: 'Sparar ändringar, vänligen vänta...'\n  },\n  PagingToolbar: {\n    firstPage: 'Gå till första sidan',\n    prevPage: 'Gå till föregående sida',\n    page: 'Sida',\n    nextPage: 'Gå till nästa sida',\n    lastPage: 'Gå till sista sidan',\n    reload: 'Ladda om den aktuella sidan',\n    noRecords: 'Inga rader att visa',\n    pageCountTemplate: function pageCountTemplate(data) {\n      return \"av \".concat(data.lastPage);\n    },\n    summaryTemplate: function summaryTemplate(data) {\n      return \"Visar poster \".concat(data.start, \" - \").concat(data.end, \" av \").concat(data.allCount);\n    }\n  },\n  UndoRedo: {\n    Undo: 'Ångra',\n    Redo: 'Gör om',\n    UndoLastAction: 'Ångra senaste åtgärden',\n    RedoLastAction: 'Gör om senast ångrade åtgärden'\n  },\n  //endregion\n  //region Others\n  DateHelper: {\n    locale: 'sv-SE',\n    weekStartDay: 1,\n    // Non-working days which match weekends by default, but can be changed according to schedule needs\n    nonWorkingDays: {\n      0: true,\n      6: true\n    },\n    // Days considered as weekends by the selected country, but could be working days in the schedule\n    weekends: {\n      0: true,\n      6: true\n    },\n    unitNames: [{\n      single: 'millisekund',\n      plural: 'millisekunder',\n      abbrev: 'ms'\n    }, {\n      single: 'sekund',\n      plural: 'sekunder',\n      abbrev: 's'\n    }, {\n      single: 'minut',\n      plural: 'minuter',\n      abbrev: 'min'\n    }, {\n      single: 'timme',\n      plural: 'timmar',\n      abbrev: 'tim'\n    }, {\n      single: 'dag',\n      plural: 'dagar',\n      abbrev: 'd'\n    }, {\n      single: 'vecka',\n      plural: 'vecka',\n      abbrev: 'v'\n    }, {\n      single: 'månad',\n      plural: 'månader',\n      abbrev: 'mån'\n    }, {\n      single: 'kvartal',\n      plural: 'kvartal',\n      abbrev: 'kv'\n    }, {\n      single: 'år',\n      plural: 'år',\n      abbrev: 'år'\n    }, {\n      single: 'årtionde',\n      plural: 'årtionden',\n      abbrev: 'årtionden'\n    }],\n    // Used to build a RegExp for parsing time units.\n    // The full names from above are added into the generated Regexp.\n    // So you may type \"2 v\" or \"2 ve\" or \"2 vecka\" or \"2 vecka\" into a DurationField.\n    // When generating its display value though, it uses the full localized names above.\n    unitAbbreviations: [['ms', 'mil'], ['s', 'sek'], ['m', 'min'], ['t', 'tim', 'h'], ['d'], ['v', 've'], ['må', 'mån'], ['kv', 'kva'], [], []],\n    ordinalSuffix: function ordinalSuffix(number) {\n      var lastDigit = number[number.length - 1];\n      return number + (number !== '11' && number !== '12' && (lastDigit === '1' || lastDigit === '2') ? 'a' : 'e');\n    },\n    parsers: {\n      L: 'YYYY-MM-DD',\n      LT: 'HH:mm'\n    }\n  } //endregion\n\n};\n/* harmony default export */ __webpack_exports__[\"default\"] = (locale);\n\n//# sourceURL=webpack:///../Core/lib/Core/localization/SvSE.js?")},"../Grid/lib/Grid/localization/SvSE.js":
/*!*********************************************!*\
  !*** ../Grid/lib/Grid/localization/SvSE.js ***!
  \*********************************************/
/*! exports provided: default */function(module,__webpack_exports__,__webpack_require__){"use strict";eval("__webpack_require__.r(__webpack_exports__);\n/* harmony import */ var _Core_localization_SvSE_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../../Core/localization/SvSE.js */ \"../Core/lib/Core/localization/SvSE.js\");\n/* harmony import */ var _Core_localization_LocaleHelper_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ../../Core/localization/LocaleHelper.js */ \"../Core/lib/Core/localization/LocaleHelper.js\");\n\n\nvar locale = _Core_localization_LocaleHelper_js__WEBPACK_IMPORTED_MODULE_1__[\"default\"].mergeLocales(_Core_localization_SvSE_js__WEBPACK_IMPORTED_MODULE_0__[\"default\"], {\n  //region Features\n  ColumnPicker: {\n    column: 'Kolumn',\n    columnsMenu: 'Kolumner',\n    hideColumn: 'Dölj kolumn',\n    hideColumnShort: 'Dölj',\n    newColumns: 'Nya kolumner'\n  },\n  Filter: {\n    applyFilter: 'Använd filter',\n    editFilter: 'Redigera filter',\n    filter: 'Filter',\n    on: 'På',\n    before: 'Före',\n    after: 'Efter',\n    equals: 'Lika med',\n    lessThan: 'Mindre än',\n    moreThan: 'Större än',\n    removeFilter: 'Ta bort filter'\n  },\n  FilterBar: {\n    enableFilterBar: 'Visa filterrad',\n    disableFilterBar: 'Dölj filterrad'\n  },\n  Group: {\n    group: 'Gruppera',\n    groupAscending: 'Gruppera stigande',\n    groupDescending: 'Gruppera fallande',\n    groupAscendingShort: 'Stigande',\n    groupDescendingShort: 'Fallande',\n    stopGrouping: 'Sluta gruppera',\n    stopGroupingShort: 'Sluta'\n  },\n  Search: {\n    searchForValue: 'Sök efter värde'\n  },\n  Sort: {\n    sort: 'Sortera',\n    sortAscending: 'Sortera stigande',\n    sortDescending: 'Sortera fallande',\n    multiSort: 'Multisortering',\n    addSortAscending: 'Lägg till stigande',\n    addSortDescending: 'Lägg till fallande',\n    toggleSortAscending: 'Ändra till stigande',\n    toggleSortDescending: 'Ändra till fallande',\n    removeSorter: 'Ta bort sorterare',\n    sortAscendingShort: 'Stigande',\n    sortDescendingShort: 'Fallande',\n    removeSorterShort: 'Ta bort',\n    addSortAscendingShort: '+ Stigande',\n    addSortDescendingShort: '+ Fallande'\n  },\n  //endregion\n  //region Grid\n  GridBase: {\n    loadFailedMessage: 'Ett fel har uppstått, vänligen försök igen!',\n    syncFailedMessage: 'Datasynkronisering misslyckades!',\n    unspecifiedFailure: 'Ospecificerat fel',\n    networkFailure: 'Nätverksfel',\n    parseFailure: 'Det gick inte att bearbeta serversvaret',\n    // moved to Core for LoadMaskable:\n    // loadMask           : 'Laddar...',\n    // syncMask           : 'Sparar ändringar, vänligen vänta...',\n    noRows: 'Inga rader att visa',\n    removeRow: 'Ta bort',\n    moveColumnLeft: 'Flytta till vänstra sektionen',\n    moveColumnRight: 'Flytta till högra sektionen',\n    moveColumnTo: function moveColumnTo(region) {\n      return \"Flytta kolumn till \".concat(region);\n    }\n  },\n  CellMenu: {\n    removeRow: 'Ta bort'\n  },\n  RowCopyPaste: {\n    copyRecord: 'Kopiera',\n    cutRecord: 'Klipp',\n    pasteRecord: 'Klistra'\n  },\n  //endregion\n  //region Export\n  PdfExport: {\n    'Waiting for response from server': 'Väntar på svar från servern...',\n    'Export failed': 'Export misslyckades',\n    'Server error': 'Serverfel',\n    'Generating pages': 'Genererar sidor...'\n  },\n  ExportDialog: {\n    width: '40em',\n    labelWidth: '13em',\n    exportSettings: 'Exportera inställningar',\n    \"export\": 'Exportera',\n    exporterType: 'Styra sidbrytningarna',\n    cancel: 'Avbryt',\n    fileFormat: 'Filformat',\n    rows: 'Кader',\n    alignRows: 'Anpassa raderna',\n    columns: 'Kolumner',\n    paperFormat: 'Pappersformat',\n    orientation: 'Orientering',\n    repeatHeader: 'Upprepa rubriken'\n  },\n  ExportRowsCombo: {\n    all: 'Alla rader',\n    visible: 'Synliga rader'\n  },\n  ExportOrientationCombo: {\n    portrait: 'Stående',\n    landscape: 'Liggande'\n  },\n  SinglePageExporter: {\n    singlepage: 'En sida'\n  },\n  MultiPageExporter: {\n    multipage: 'Flera sidor',\n    exportingPage: function exportingPage(_ref) {\n      var currentPage = _ref.currentPage,\n          totalPages = _ref.totalPages;\n      return \"Exporterar sidan \".concat(currentPage, \"/\").concat(totalPages);\n    }\n  },\n  MultiPageVerticalExporter: {\n    multipagevertical: 'Flera sidor (lodrätt)',\n    exportingPage: function exportingPage(_ref2) {\n      var currentPage = _ref2.currentPage,\n          totalPages = _ref2.totalPages;\n      return \"Exporterar sidan \".concat(currentPage, \"/\").concat(totalPages);\n    }\n  } //endregion\n\n});\n/* harmony default export */ __webpack_exports__[\"default\"] = (locale);\n\n//# sourceURL=webpack:///../Grid/lib/Grid/localization/SvSE.js?")},"./examples/localization/locales/custom.locale.SvSE.js":
/*!*************************************************************!*\
  !*** ./examples/localization/locales/custom.locale.SvSE.js ***!
  \*************************************************************/
/*! no exports provided */function(module,__webpack_exports__,__webpack_require__){"use strict";eval("__webpack_require__.r(__webpack_exports__);\n/* harmony import */ var _lib_Core_localization_LocaleHelper_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../../../lib/Core/localization/LocaleHelper.js */ \"../Core/lib/Core/localization/LocaleHelper.js\");\n/* harmony import */ var _lib_Scheduler_localization_SvSE_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ../../../lib/Scheduler/localization/SvSE.js */ \"./lib/Scheduler/localization/SvSE.js\");\n\n\nvar customSvSELocale = {\n  \"extends\": 'SvSE',\n  App: {\n    'Localization demo': 'Lokalisierungs-Demo'\n  },\n  Button: {\n    'Add column': 'Lägg till kolumn',\n    'Display hints': 'Visa tips',\n    'Remove column': 'Ta bort kolumn',\n    Apply: 'Verkställ'\n  },\n  Checkbox: {\n    'Auto apply': 'Auto applicera',\n    Automatically: 'Automatiskt'\n  },\n  CodeEditor: {\n    'Code editor': 'Kodredigerare',\n    'Download code': 'Ladda ner kod'\n  },\n  Column: {\n    Name: 'Namn',\n    Company: 'Företag'\n  },\n  Combo: {\n    Theme: 'Välj tema',\n    Language: 'Välj språk',\n    Size: 'Välj storlek'\n  },\n  Shared: {\n    'Full size': 'Full storlek',\n    'Locale changed': 'Språk ändrat',\n    'Phone size': 'Telefonstorlek'\n  },\n  Tooltip: {\n    'Click to show info and switch theme or locale': 'Klicka för att visa information och byta tema eller språk',\n    'Click to show the built in code editor': 'Klicka för att visa den inbyggda kodredigeraren',\n    CheckAutoHints: 'Markera för att automatiskt visa tips när du laddar exemplet',\n    Fullscreen: 'Fullskärm'\n  }\n}; // Publishing locales to be loaded automatically (for umd bundles)\n\n_lib_Core_localization_LocaleHelper_js__WEBPACK_IMPORTED_MODULE_0__[\"default\"].publishLocale('SvSE', _lib_Scheduler_localization_SvSE_js__WEBPACK_IMPORTED_MODULE_1__[\"default\"]);\n_lib_Core_localization_LocaleHelper_js__WEBPACK_IMPORTED_MODULE_0__[\"default\"].publishLocale('SvSE-Custom', customSvSELocale);\n\n//# sourceURL=webpack:///./examples/localization/locales/custom.locale.SvSE.js?")},"./lib/Scheduler/localization/SvSE.js":
/*!********************************************!*\
  !*** ./lib/Scheduler/localization/SvSE.js ***!
  \********************************************/
/*! exports provided: default */function(module,__webpack_exports__,__webpack_require__){"use strict";eval("__webpack_require__.r(__webpack_exports__);\n/* harmony import */ var _Grid_localization_SvSE_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../../Grid/localization/SvSE.js */ \"../Grid/lib/Grid/localization/SvSE.js\");\n/* harmony import */ var _Core_localization_LocaleHelper_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ../../Core/localization/LocaleHelper.js */ \"../Core/lib/Core/localization/LocaleHelper.js\");\n\n\nvar locale = _Core_localization_LocaleHelper_js__WEBPACK_IMPORTED_MODULE_1__[\"default\"].mergeLocales(_Grid_localization_SvSE_js__WEBPACK_IMPORTED_MODULE_0__[\"default\"], {\n  Object: {\n    newEvent: 'Ny händelse'\n  },\n  ResourceInfoColumn: {\n    eventCountText: function eventCountText(data) {\n      return data + ' händelse' + (data !== 1 ? 'r' : '');\n    }\n  },\n  Dependencies: {\n    from: 'Från',\n    to: 'Till',\n    valid: 'Giltig',\n    invalid: 'Ogiltig'\n  },\n  DependencyType: {\n    SS: 'SS',\n    SF: 'SA',\n    FS: 'AS',\n    FF: 'AA',\n    StartToStart: 'Start-Till-Start',\n    StartToEnd: 'Start-Till-Avslut',\n    EndToStart: 'Avslut-Till-Start',\n    EndToEnd: 'Avslut-Till-Avslut',\n    \"short\": ['SS', 'SA', 'AS', 'AA'],\n    \"long\": ['Start-Till-Start', 'Start-Till-Avslut', 'Avslut-Till-Start', 'Avslut-Till-Avslut']\n  },\n  EventEdit: {\n    Name: 'Namn',\n    Resource: 'Resurs',\n    Start: 'Start',\n    End: 'Slut',\n    Save: 'Spara',\n    Delete: 'Ta bort',\n    Cancel: 'Avbryt',\n    'Edit event': 'Redigera bokning',\n    Repeat: 'Upprepa'\n  },\n  DependencyEdit: {\n    From: 'Från',\n    To: 'Till',\n    Type: 'Typ',\n    Lag: 'Fördröjning',\n    'Edit dependency': 'Ändra beroende',\n    Save: 'Spara',\n    Delete: 'Ta bort',\n    Cancel: 'Avbryt',\n    StartToStart: 'Start till Start',\n    StartToEnd: 'Start till Slut',\n    EndToStart: 'Slut till Start',\n    EndToEnd: 'Slut till Slut'\n  },\n  EventDrag: {\n    eventOverlapsExisting: 'Överlappar befintlig händelse för den här resursen',\n    noDropOutsideTimeline: 'Händelsen kan inte släppas utanför tidsaxeln'\n  },\n  SchedulerBase: {\n    'Add event': 'Lägg till bokning',\n    'Delete event': 'Ta bort bokning',\n    'Unassign event': 'Ta bort resurskoppling'\n  },\n  // TODO: 'headerContextMenu' is deprecated. Please see https://bryntum.com/docs/scheduler/#Scheduler/guides/upgrades/4.0.0.md for more information.\n  HeaderContextMenu: {\n    pickZoomLevel: 'Välj zoomnivå',\n    activeDateRange: 'Aktivt datumintervall',\n    startText: 'Start datum',\n    endText: 'Slut datum',\n    todayText: 'I dag'\n  },\n  TimeAxisHeaderMenu: {\n    pickZoomLevel: 'Välj zoomnivå',\n    activeDateRange: 'Aktivt datumintervall',\n    startText: 'Start datum',\n    endText: 'Slut datum',\n    todayText: 'I dag'\n  },\n  EventCopyPaste: {\n    copyEvent: 'Kopiera bokning',\n    cutEvent: 'Klipp ut bokning',\n    pasteEvent: 'Klistra in bokning'\n  },\n  EventFilter: {\n    filterEvents: 'Filtrera händelser',\n    byName: 'Med namn'\n  },\n  TimeRanges: {\n    showCurrentTimeLine: 'Visa aktuell tidslinje'\n  },\n  PresetManager: {\n    minuteAndHour: {\n      topDateFormat: 'ddd, DD/MM, h:mm'\n    },\n    hourAndDay: {\n      topDateFormat: 'ddd DD/MM'\n    },\n    weekAndDay: {\n      displayDateFormat: 'HH:mm'\n    }\n  },\n  RecurrenceConfirmationPopup: {\n    'delete-title': 'Borttagning av bokning',\n    'delete-all-message': 'Vill du ta bort alla instanser av denna bokning?',\n    'delete-further-message': 'Vill du ta bort denna och alla framtida instanser av denna bokning, eller bara denna?',\n    'delete-further-btn-text': 'Ta bort alla framtida',\n    'delete-only-this-btn-text': 'Ta bort endast denna',\n    'update-title': 'Redigering av upprepad bokning',\n    'update-all-message': 'Vill du ändra alla instanser av denna bokning?',\n    'update-further-message': 'Vill du ändra på endast denna instans, eller denna och alla framtida?',\n    'update-further-btn-text': 'Alla framtida',\n    'update-only-this-btn-text': 'Endast denna',\n    Yes: 'Ja',\n    Cancel: 'Avbryt',\n    width: 500\n  },\n  RecurrenceLegend: {\n    ' and ': ' och ',\n    // frequency patterns\n    Daily: 'Daglig',\n    'Weekly on {1}': function WeeklyOn1(_ref) {\n      var days = _ref.days;\n      return \"Veckovis p\\xE5 \".concat(days);\n    },\n    'Monthly on {1}': function MonthlyOn1(_ref2) {\n      var days = _ref2.days;\n      return \"M\\xE5ntaligen den \".concat(days);\n    },\n    'Yearly on {1} of {2}': function YearlyOn1Of2(_ref3) {\n      var days = _ref3.days,\n          months = _ref3.months;\n      return \"\\xC5rligen \".concat(days, \" \").concat(months);\n    },\n    'Every {0} days': function Every0Days(_ref4) {\n      var interval = _ref4.interval;\n      return \"Var \".concat(interval, \" dag\");\n    },\n    'Every {0} weeks on {1}': function Every0WeeksOn1(_ref5) {\n      var interval = _ref5.interval,\n          days = _ref5.days;\n      return \"Var \".concat(interval, \" vecka p\\xE5 \").concat(days);\n    },\n    'Every {0} months on {1}': function Every0MonthsOn1(_ref6) {\n      var interval = _ref6.interval,\n          days = _ref6.days;\n      return \"Var \".concat(interval, \" m\\xE5nad \").concat(days);\n    },\n    'Every {0} years on {1} of {2}': function Every0YearsOn1Of2(_ref7) {\n      var interval = _ref7.interval,\n          days = _ref7.days,\n          months = _ref7.months;\n      return \"Var \".concat(interval, \" \\xE5r p\\xE5 \").concat(days, \" av \").concat(months);\n    },\n    // day position translations\n    position1: 'den första',\n    position2: 'den andra',\n    position3: 'den tredje',\n    position4: 'den fjärde',\n    position5: 'den femte',\n    'position-1': 'den sista',\n    // day options\n    day: 'dagen',\n    weekday: 'veckodagen',\n    'weekend day': 'dagen i veckoslut',\n    // {0} - day position info (\"the last\"/\"the first\"/...)\n    // {1} - day info (\"Sunday\"/\"Monday\"/.../\"day\"/\"weekday\"/\"weekend day\")\n    // For example:\n    //  \"the last Sunday\"\n    //  \"the first weekday\"\n    //  \"the second weekend day\"\n    daysFormat: function daysFormat(_ref8) {\n      var position = _ref8.position,\n          days = _ref8.days;\n      return \"\".concat(position, \" \").concat(days);\n    }\n  },\n  RecurrenceEditor: {\n    'Repeat event': 'Upprepa bokning',\n    Cancel: 'Avbryt',\n    Save: 'Spara',\n    Frequency: 'Frekvens',\n    Every: 'Var',\n    DAILYintervalUnit: 'dag',\n    WEEKLYintervalUnit: 'vecka',\n    MONTHLYintervalUnit: 'månad',\n    YEARLYintervalUnit: 'år',\n    Each: 'Varje',\n    'On the': 'På den',\n    'End repeat': 'Avsluta upprepning',\n    'time(s)': 'upprepningar'\n  },\n  RecurrenceDaysCombo: {\n    day: 'dagen',\n    weekday: 'veckodagen',\n    'weekend day': 'dagen i veckoslutet'\n  },\n  RecurrencePositionsCombo: {\n    position1: 'första',\n    position2: 'andra',\n    position3: 'tredje',\n    position4: 'fjärde',\n    position5: 'femte',\n    'position-1': 'sista'\n  },\n  RecurrenceStopConditionCombo: {\n    Never: 'Aldrig',\n    After: 'Efter',\n    'On date': 'På datum'\n  },\n  RecurrenceFrequencyCombo: {\n    Daily: 'Daglig',\n    Weekly: 'Veckovis',\n    Monthly: 'Månatlig',\n    Yearly: 'Årlig'\n  },\n  RecurrenceCombo: {\n    None: 'Ingen',\n    Custom: 'Anpassad...'\n  },\n  //region Features\n  Summary: {\n    'Summary for': function SummaryFor(date) {\n      return \"Sammanfattning f\\xF6r \".concat(date);\n    }\n  },\n  //endregion\n  //region Export\n  ScheduleRangeCombo: {\n    completeview: 'Hela schemat',\n    currentview: 'Aktuell vy',\n    daterange: 'Datumintervall',\n    completedata: 'Hela schemat (alla aktiviteter)'\n  },\n  SchedulerExportDialog: {\n    'Schedule range': 'Tidsintervall',\n    'Export from': 'Från',\n    'Export to': 'Till'\n  },\n  ExcelExporter: {\n    'No resource assigned': 'Ingen resurs tilldelad'\n  },\n  //endregion\n  CrudManagerView: {\n    serverResponseLabel: 'Serversvar:'\n  }\n});\n/* harmony default export */ __webpack_exports__[\"default\"] = (locale);\n\n//# sourceURL=webpack:///./lib/Scheduler/localization/SvSE.js?")}})}));