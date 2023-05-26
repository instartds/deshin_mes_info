/**
 * load data saga
 */
import { put } from 'redux-saga/effects';
import { dataLoaded, dataLoadFailed } from '../actions/actions.js';
import axios from 'axios';

export function* loadDataSaga(action) {
    try {
        const response = yield axios.get('data/data.json');
        yield put(dataLoaded(response.data));
    }
    catch(err) {
        yield put(dataLoadFailed(err));
    }
}
