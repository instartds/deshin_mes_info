/**
 * The root saga
 */
// libraries
import { takeEvery } from 'redux-saga/effects';

// our stuff
import { loadDataSaga } from './loadData.js';
import { reloadDataSaga } from './reloadData.js';
import { LOAD_DATA, RELOAD_DATA } from '../actions/actionTypes.js';

export function* watchSagas() {
    yield takeEvery(LOAD_DATA, loadDataSaga);
    yield takeEvery(RELOAD_DATA, reloadDataSaga);
}
