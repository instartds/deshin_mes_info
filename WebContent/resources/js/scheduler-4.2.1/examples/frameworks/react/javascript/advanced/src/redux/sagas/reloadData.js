/**
 * reload data saga
 */
import { put } from 'redux-saga/effects';
import { dataLoaded, dataLoadFailed } from '../actions/actions.js';
import axios from 'axios';

export function* reloadDataSaga(action) {
    try {
        const response = yield axios.get(action.dataUrl);
        yield put(dataLoaded(response.data));
    }
    catch(err) {
        yield put(dataLoadFailed(err));
    }
}
