import { BrowserModule } from '@angular/platform-browser';
import { NgModule, ErrorHandler } from '@angular/core';
import { AppErrorHandler } from './error.handler';
import { HttpModule } from '@angular/http';

import { AppComponent } from './app.component';
import {
    BryntumButtonComponent,
    BryntumDemoHeaderComponent,
    BryntumFullscreenButtonComponent,
    BryntumSliderComponent,
    BryntumSchedulerComponent,
    BryntumContainerComponent
} from '@bryntum/scheduler-angular/bundles/bryntum-scheduler-angular.umd.js';

@NgModule({
    declarations : [
        AppComponent,
        BryntumButtonComponent,
        BryntumDemoHeaderComponent,
        BryntumFullscreenButtonComponent,
        BryntumSliderComponent,
        BryntumSchedulerComponent,
        BryntumContainerComponent
    ],
    imports : [
        BrowserModule,
        HttpModule
    ],
    providers : [{ provide : ErrorHandler, useClass : AppErrorHandler }],
    bootstrap : [AppComponent]
})
export class AppModule { }
