/**
 * Action creators
 */
import {
    SET_LOCALE,
    LOAD_DATA,
    ZOOM_IN,
    ZOOM_OUT,
    DATA_LOADED,
    DATA_LOAD_FAILED,
    RELOAD_DATA
} from './actionTypes.js';

export const setLocale = locale => {
    return {
        type   : SET_LOCALE,
        locale : locale
    };
};

export const zoomIn = () => {
    return {
        type : ZOOM_IN
    };
};

export const zoomOut = () => {
    return {
        type : ZOOM_OUT
    };
};

export const loadData = () => {
    return {
        type : LOAD_DATA
    };
};

export const reloadData = dataUrl => {

    return {
        type    : RELOAD_DATA,
        dataUrl : dataUrl
    };
};

export const dataLoaded = data => {
    return {
        type : DATA_LOADED,
        data : data
    };
};

export const dataLoadFailed = (err) => {
    return {
        type : DATA_LOAD_FAILED,
        err  : err
    };
};

export const clearError = () => {
    return {
        type : 'CLEAR_ERROR'
    };
};
