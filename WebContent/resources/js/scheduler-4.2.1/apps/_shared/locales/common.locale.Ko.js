import LocaleManager from '../../../lib/Core/localization/LocaleManager.js';
//<umd>
import LocaleHelper from '../../../lib/Core/localization/LocaleHelper.js';
import En from '../../../lib/Scheduler/localization/En.js';
import SharedEn from './shared.locale.En.js';

const examplesEnLocale = LocaleHelper.mergeLocales(SharedKo, {

    extends : 'Ko',

    Button : {
        'Add column'    : '컬럼 추가',
        'Remove column' : '컬럼 삭제'
    },

    Column : {
        
    },

    Combo : {
        'Group by' : '그룹'
    },

    EventEdit : {
        Location : 'Location'
    },

    MenuItem : {
        'Custom header item' : '헤더 설정',
        'Custom cell action' : '셀 실행'
    },

    Slider : {
        'Font size' : 'Font size'
    }
});

LocaleHelper.publishLocale('Ko', Ko);
LocaleHelper.publishLocale('KoApps', AppsKoLocale);

export default examplesEnLocale;
//</umd>

LocaleManager.extendLocale('Ko', appsKoLocale);
