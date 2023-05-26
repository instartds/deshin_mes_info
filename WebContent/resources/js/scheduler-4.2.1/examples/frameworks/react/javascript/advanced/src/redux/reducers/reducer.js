/**
 * The reducer used by Redux
 */
// action types
import {
    SET_LOCALE,
    ZOOM_IN,
    ZOOM_OUT,
    RELOAD_DATA,
    DATA_LOADED,
    DATA_LOAD_FAILED,
    CLEAR_ERROR
} from '../actions/actionTypes.js';

const initialState = {
    locale       : localStorage.getItem('i18nextLng') || 'en',
    zoomLevel    : 15,
    minZoomLevel : 12,
    maxZoomLevel : 18,
    dataUrl      : 'data/data.json',
    data         : {},
    err          : ''
};

/**
 * Returns new object that is the passed state updated with the passed item
 * @param {Object} state
 * @param {Object} item
 */
const updateState = function(state, item) {
    return { ...state, ...item };
};

/**
 * Handles zooming by updating zoomLevel in state
 * @param {Object} state
 * @param {Number} increment
 * @return {Object} The new updated state
 */
const zoom = (state, increment = 1) => {
    let zoomLevel = state.zoomLevel + increment;
    zoomLevel = zoomLevel > state.maxZoomLevel ? state.maxZoomLevel : zoomLevel;
    zoomLevel = zoomLevel < state.minZoomLevel ? state.minZoomLevel : zoomLevel;
    return updateState(state, { zoomLevel : zoomLevel });
};

/**
 * @param {Object} state
 * @param {Object} action
 * @return {Object} The new updated state
 */
const reducer = (state = initialState, action) => {
    switch (action.type) {
        case SET_LOCALE:
            return updateState(state, { locale : action.locale });

        case ZOOM_IN:
            return zoom(state);

        case ZOOM_OUT:
            return zoom(state, -1);

        case RELOAD_DATA:
            return updateState(state, { dataUrl : action.dataUrl });

        case DATA_LOADED:
            return updateState(state, { data : action.data });

        case DATA_LOAD_FAILED:
            return updateState(state, { err : action.err, dataUrl : initialState.dataUrl });

        case CLEAR_ERROR:
            return updateState(state, { err : '' });

        default:
            return state;
    }
};

export default reducer;
