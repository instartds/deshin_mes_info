import { NgModule, ErrorHandler } from '@angular/core';
import { AppErrorHandler } from './error.handler';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { BryntumSchedulerModule } from '@bryntum/scheduler-angular';

import { AppComponent } from './app.component';
import { HomeComponent } from './home/home.component';
import { SchedulerComponent } from './scheduler/scheduler.component';

@NgModule({
    declarations : [AppComponent, HomeComponent, SchedulerComponent],
    imports      : [BrowserModule, AppRoutingModule, BryntumSchedulerModule],
    providers    : [{ provide : ErrorHandler, useClass : AppErrorHandler }],
    bootstrap    : [AppComponent]
})
export class AppModule {}
