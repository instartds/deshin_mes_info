
from pulp import *
# import numpy as np
import pandas as pd
import math
# import pymysql
import pyodbc
from datetime import datetime , timedelta

import sys

def connect_mssql():
    try:
        server = 'tcp:210.122.45.125,9025'
        user = 'unilite'
        password = 'UNILITE'
        db = 'OMEGAPLUS_KODI2'

        ms_con = pyodbc.connect(
            'DRIVER={ODBC Driver 13 for SQL Server};SERVER=' + server + ';DATABASE=' + db + ';UID=' + user + ';PWD=' + password)
        return ms_con
    except:
        return False

def log_msg(ms_con, comp_code,div_code,aps_key,err_type,err_code,err_module,err_table,err_desc):
    if ms_con:

        curs = ms_con.cursor()
        sql = "INSERT INTO MRP510T (COMP_CODE, DIV_CODE, APS_CODE,ERR_TYPE,ERR_CODE,ERR_MODULE,ERR_TABLE,ERR_DESC) "\
                "VALUES ( '{}' , '{}' ,'{}','{}' , '{}' ,'{}','{}' , '{}' )"\
            .format(comp_code,div_code,aps_key,err_type,err_code,err_module,err_table,err_desc)
        print(sql)
        curs.execute(sql)
        ms_con.commit()

def check_dup(fix_prod_0 , plan_id):  # 이미 지정되었는지 체크

    for ii in range(len(fix_prod_0)):
        if fix_prod_0[ii][2] == plan_id:
            return False
    return True

def check_due_date(assign_list,confirm_df,free_df,fac_list,fix_prod_0 , fac_no, cur_plan_id):  # 해당 설비에 납기가 충분한지 check

    assign_prod = 0

    for jj in range(len(assign_list)):   # 이미 설비에 확정된 제품을 찾아서 종료일자를 확인한다
        if assign_list[jj][1] == fac_no:
            assign_plan_id = assign_list[jj][2]
            assign_prod = 1

    if assign_prod == 1:
        assign_end_date = confirm_df[confirm_df['PLAN_INPUT_ID'] == assign_plan_id]['END_DATE'].values[0]
        assign_end_time = confirm_df[confirm_df['PLAN_INPUT_ID'] == assign_plan_id]['END_TIME'].values[0]

    product_no = -1
    assign_product_minute = 0
    for ii in range(len(fix_prod_0)):  # 신규로 설비에 확정된 제품의 생산 시간 누적
        print(f" check_fix : {ii} : {fix_prod_0[ii][1] } : {fac_no}")

        if fix_prod_0[ii][1] == fac_no:    # 같은 호기 배정된 제품의 생산량 과 납기 체크

            product_no = ii
            plan_id = fix_prod_0[ii][2]

            assign_prod_time = free_df[free_df['PLAN_INPUT_ID'] == plan_id]['PROD_TIME'].values[0]  # 확정 오더 원료

            assign_product_minute += assign_prod_time

            setup_time = fac_list.iloc[fac_no]['SETUP_TIME']
            clean_time = fac_list.iloc[fac_no]['CLEAN_TIME']

            assign_product_minute += setup_time + clean_time

            print(f" assign_product_minute : {fac_no} : {assign_prod_time} : {setup_time} : {clean_time}  ========")

    # 설비에 할당해야 할 제품. cur_plan_id =  현 제품

    cur_prod_time = free_df[free_df['PLAN_INPUT_ID'] == cur_plan_id]['PROD_TIME'].values[0]  # 확정 오더 원료
    cur_due_date = free_df[free_df['PLAN_INPUT_ID'] == cur_plan_id]['DUE_DATE'].values[0]  # 확정 오더 원료

    total_product_minute = cur_prod_time + assign_product_minute   # 총 걸리는 생산 시간 : 현 제품 포함
    end_time = datetime.strptime(assign_end_date + assign_end_time , "%Y%m%d%H%M%S")

    cur_end_time = end_time + timedelta(minutes=total_product_minute)
    cur_end_date = datetime.strftime(cur_end_time,"%Y%m%d")

    # 주말인 경우 하루씩 추가해준다
    dt_index = pd.date_range(start=assign_end_date, end=cur_end_date)
    dt_list = dt_index.strftime("%Y%m%d").tolist()

    due_delta = 0
    for day in dt_list:
        week = datetime.strptime(day,"%Y%m%d").weekday()   # 요일 체크
        if week == 6 or week == 5:   # 토요일 , 일요일인 경우
            due_delta += 1

    # cur_end_time = end_time + timedelta(days=due_delta)
    cur_end_time = cur_end_time + timedelta(days=due_delta)
    # 주말 계산 루틴  ---  공휴일은 계산 안 했음

    cur_end_date = datetime.strftime(cur_end_time,"%Y%m%d")
    cur_end_time = datetime.strftime(cur_end_time,"%H%M%S")

    if cur_end_date > cur_due_date:
        print(f" ===  due date over : {fac_no} : {cur_plan_id} : {cur_end_date} : {cur_due_date}")
        return False
    print(f" === due date ok : {fac_no} : {cur_plan_id} :   {cur_end_date} : {cur_due_date} ")
    return True

def cal_lp_final( lot_no,work_shop_code, order_table, fac_capa, fix_prod_0 , var_type,repeat):
    # 제품별 생산 에 걸리는 시간 계산 ( 분으로 계산 )
    # 생산 수량을 싸이클 타임(초)으로 나누면   총 생산 시간(분)이 된다
    print(f"============LP START===  {work_shop_code} ==================")
    print("============order table ==================")
    print(order_table)

    print("============fac_capa table ==================")
    print(fac_capa)

    print("============fix table ==================")
    print(fix_prod_0)
    # 생산 제품의 갯수 ( 1부터 시작해서 +1 을 함 )
    n_a_len = len(order_table) + 1
    # 설비의 갯수 ( 1부터 시작해서 +1 을 함 )
    n_f_len = len(fac_capa) + 1
    # LpProblem 함수를 이용해서 목적식의 종류?를 지정해줍니다
    model = LpProblem(lot_no+work_shop_code, LpMinimize)  # ("아무거나이름",최소최대,,,)

    n_order = range(1, n_a_len)  # 제품 갯수

    n_facility = range(1, n_f_len)  # 설비 갯수

    # 총 변수의 형태와 갯수 선언 0 또는 1
    prod_var = LpVariable.dicts("prod", (n_order, n_facility), cat=var_type , lowBound=0)

    ## 목적 함수 - 설비 가동시간의 합 이 최소화
    model += lpSum(prod_var[r][c] * order_table.iloc[r-1]['AMOUNT'] for c in n_facility for r in
                   n_order), "Total_Time_for_Capacity"

    ## 지정된 제약 조건 처리

    fix_len = len(fix_prod_0)

    if fix_len > 0:
        for i in range(fix_len):
            row = fix_prod_0[i][0]
            col = fix_prod_0[i][1]
            fix = fix_prod_0[i][2]
            print(f' {i} : ( {row} , {col} , {fix} )')

            model += prod_var[row][col] == fix

    for r in n_order:
        model += lpSum(prod_var[r][c] for c in n_facility) == 1

    #   sum ( order[] / cycle_time[] * prod_var )  <= capa[]
    # 제품의 총 생산 시간 보다  설비 최대 가동 시간이 커야 한다
    for c in n_facility:
        model += lpSum(prod_var[r][c] * order_table.iloc[r-1]['AMOUNT'] for r in n_order) <= fac_capa.iloc[c-1][
            'ALL_CAPA']

    ''' 추가로 들어가야 되는 루틴'''
    # max_prod = 0
    # max_i = 0
    # for c in n_facility:  # 1 ~ 12
    #     prod_sum = 0
    #     for r in n_order:  # 1 ~ 44
    #         if (value(prod_var[r][c]) == 1):
    #             prod_time = order_df.iloc[r - 1]['PROD_TIME']  # 해당 제품의 생산시간
    #             prod_sum += prod_time
    #     if prod_sum > max_prod:
    #         max_prod = prod_sum
    #         max_i = c
    #         print("=============max prod time ============")
    #         print(f"  {max_i} : {prod_sum}   :{max_prod}")
    # # 추가 조건 ( 한 설비의 최대 MAX 값 제약 )
    # model += lpSum(prod_var[r][max_i] * order_df.iloc[r - 1]['PROD_TIME'] for r in n_order) + 1 <= max_prod


    # 한 설비에 할당된 제품이 전체 생산량보다 작아야 한다. 한 설비에 모든 제품이 몰릴수 있음
    # for c in n_facility:
    #     model += lpSum(prod_var[r][c] * order_table.iloc[r-1]['AMOUNT']  for r in n_order) + 1 <= lpSum(
    #         prod_var[r][c] *  order_table.iloc[r-1]['AMOUNT'] for r in n_order for c in n_facility)

    ##  n호기가 n+1호기보다 더 배정이 많이 되게 즉 n 호기 합 >= n+1 호기 합
    #  설비별로 용량을 정할 수 있다.
    # for c in range(1, n_f_len - 1):
    #     model += lpSum(prod_var[r][c] * order_table.iloc[r-1]['AMOUNT'] for r in n_order) >= lpSum(
    #         prod_var[r][c + 1] * order_table.iloc[r-1]['AMOUNT'] for r in n_order)
    # variable_names = [ str(format(i,"02")) +str(format(j,"02") ) for i in range(1,n_order +1) for j in range(1,n_facility+1) ]
    #

    # lp파일을 저장하는 코드
    model.solve()

    # 최적해 구하기
    for v in model.variables():
        print(v.name, "=", v.varValue)

    print("Total Time for Capacity = ", value(model.objective))

    print("Status:", LpStatus[model.status])

    assign_list = []
    for r in n_order:
        for c in n_facility:
            print( f"  {r}   , {c}  :  {value(prod_var[r][c])}  ")
            assign_list.append( ( r , c , value(prod_var[r][c]) ) )

    return LpStatus[model.status] , assign_list

def cal_lp( lot_no,work_shop_code, order_table, fac_capa, fix_prod_0 , var_type):
    # 제품별 생산 에 걸리는 시간 계산 ( 분으로 계산 )
    # 생산 수량을 싸이클 타임(초)으로 나누면   총 생산 시간(분)이 된다
    print(f"============LP START===  {work_shop_code} ==================")
    print("============order table ==================")
    print(order_table)

    print("============fac_capa table ==================")
    print(fac_capa)

    print("============fix table ==================")
    print(fix_prod_0)
    # 생산 제품의 갯수 ( 1부터 시작해서 +1 을 함 )
    n_a_len = len(order_table) + 1
    # 설비의 갯수 ( 1부터 시작해서 +1 을 함 )
    n_f_len = len(fac_capa) + 1
    # LpProblem 함수를 이용해서 목적식의 종류?를 지정해줍니다
    model = LpProblem(lot_no+work_shop_code, LpMinimize)  # ("아무거나이름",최소최대,,,)

    n_order = range(1, n_a_len)  # 제품 갯수

    n_facility = range(1, n_f_len)  # 설비 갯수

    # 총 변수의 형태와 갯수 선언 0 또는 1
    prod_var = LpVariable.dicts("prod", (n_order, n_facility), cat=var_type , lowBound=0)

    ## 목적 함수 - 설비 가동시간의 합 이 최소화
    model += lpSum(prod_var[r][c] * order_table.iloc[r-1]['AMOUNT'] for c in n_facility for r in
                   n_order), "Total_Time_for_Capacity"

    ## 지정된 제약 조건 처리

    fix_len = len(fix_prod_0)

    if fix_len > 0:
        for i in range(fix_len):
            row = fix_prod_0[i][0]
            col = fix_prod_0[i][1]
            fix = fix_prod_0[i][2]
            print(f' {i} : ( {row} , {col} , {fix} )')

            model += prod_var[row][col] == fix

    for r in n_order:
        model += lpSum(prod_var[r][c] for c in n_facility) == 1

    #   sum ( order[] / cycle_time[] * prod_var )  <= capa[]
    # 제품의 총 생산 시간 보다  설비 최대 가동 시간이 커야 한다
    for c in n_facility:
        model += lpSum(prod_var[r][c] * order_table.iloc[r-1]['AMOUNT'] for r in n_order) <= fac_capa.iloc[c-1][
            'ALL_CAPA']

    # 한 설비에 할당된 제품이 전체 생산량보다 작아야 한다. 한 설비에 모든 제품이 몰릴수 있음
    # for c in n_facility:
    #     model += lpSum(prod_var[r][c] * order_table.iloc[r-1]['AMOUNT']  for r in n_order) + 1 <= lpSum(
    #         prod_var[r][c] *  order_table.iloc[r-1]['AMOUNT'] for r in n_order for c in n_facility)

    ##  n호기가 n+1호기보다 더 배정이 많이 되게 즉 n 호기 합 >= n+1 호기 합
    #  설비별로 용량을 정할 수 있다.
    # for c in range(1, n_f_len - 1):
    #     model += lpSum(prod_var[r][c] * order_table.iloc[r-1]['AMOUNT'] for r in n_order) >= lpSum(
    #         prod_var[r][c + 1] * order_table.iloc[r-1]['AMOUNT'] for r in n_order)
    # variable_names = [ str(format(i,"02")) +str(format(j,"02") ) for i in range(1,n_order +1) for j in range(1,n_facility+1) ]
    #

    # lp파일을 저장하는 코드
    model.solve()

    # 최적해 구하기
    for v in model.variables():
        print(v.name, "=", v.varValue)

    print("Total Time for Capacity = ", value(model.objective))

    print("Status:", LpStatus[model.status])

    assign_list = []
    for r in n_order:
        for c in n_facility:
            print( f"  {r}   , {c}  :  {value(prod_var[r][c])}  ")
            assign_list.append( ( r , c , value(prod_var[r][c]) ) )

    return LpStatus[model.status] , assign_list

# 생산 제품 수량

def get_order(ms_con, comp_code,div_code,work_shop_code,schedule_num):
    print("comp_code:", comp_code)
    print("div_code:", div_code)
    print("work_shop_code:", work_shop_code)
    print("schedule_num:", schedule_num)
    if ms_con:

        # t_ppl100t 에서 필요한 데이터만 가져와서 aps_input table 에 넣음
        # 1 - drop table aps_input
        # 2 - SELECT  SCHEDULE_NO, COMP_CODE, DIV_CODE, WK_PLAN_NUM, WORK_SHOP_CODE, ITEM_CODE, WK_PLAN_Q, \
        #         PRODT_PLAN_DATE, ORDER_NUM, SEQ, INSERT_DB_USER, INSERT_DB_TIME, UPDATE_DB_USER, UPDATE_DB_TIME
        # INTO    APS_INPUT     FROM    T_PPL100T
        print("schedule_num:", schedule_num)
        sql = "SELECT COMP_CODE , DIV_CODE , WORK_SHOP_CODE , WK_PLAN_NUM, ITEM_CODE , WK_PLAN_Q  AS AMOUNT,"\
                "PRODT_PLAN_DATE AS DUE_DATE, ORDER_NUM , SEQ  "\
                "FROM T_PPL100T WITH (NOLOCK)"\
                "WHERE COMP_CODE = '{}' AND DIV_CODE = '{}' and WORK_SHOP_CODE = '{}'" \
                "AND SCHEDULE_NUM= '{}' " \
                .format(comp_code,div_code,work_shop_code,schedule_num)

        order_data = pd.read_sql_query(sql, ms_con)

        return order_data
    else:
        return -1

def get_fac_basecapa_list(ms_con, comp_code, div_code, work_shop_code,prog_work_code):

    if ms_con:

        sql = "SELECT DISTINCT A.WORK_SHOP_CODE , A.EQU_CODE ,A.STD_MEN,  A.STD_PRODT_Q as ONE_CAPA " \
              "FROM PBS410T A INNER JOIN EQU200T B " \
              "ON A.EQU_CODE = B.EQU_CODE AND A.COMP_CODE = B.COMP_CODE "\
              "AND A.DIV_CODE = B.DIV_CODE AND A.WORK_SHOP_CODE = B.WORK_SHOP_CODE "\
              "AND A.PROG_WORK_CODE = B.PROG_WORK_CODE "\
              "WHERE A.COMP_CODE = '{}' AND A.DIV_CODE = '{}' AND A.WORK_SHOP_CODE = '{}' AND A.PROG_WORK_CODE = '{}'"\
                .format(comp_code,div_code,work_shop_code,prog_work_code )
        fac_basecapa_data = pd.read_sql_query(sql, ms_con)

        return fac_basecapa_data
    else:
        return -1

# 제품에 설정되지 않은  설비를 배제하는 플래그를 지정한다 ( 0 )
def fix_prod_0_fac(ms_con,comp_code,div_code,work_shop_code, prog_work_code, order_df, fac_list , lot_no):

    fix_prod_0 = []
    if ms_con:
        curs = ms_con.cursor()    # 전체 설비 갯수를 카운트 함

        sql = " SELECT distinct equ_code FROM EQU200T WHERE COMP_CODE = '{}' " \
              "AND DIV_CODE = '{}' AND WORK_SHOP_CODE = '{}' AND PROG_WORK_CODE = '{}' " \
            .format(comp_code, div_code, work_shop_code,prog_work_code)

        print(sql)
        curs.execute(sql)
        row = curs.fetchall()
        equ_code_cnt = len(row)
        print(f" EQU_CODE LIST COUNT : {equ_code_cnt}")

        for ii in range(len(order_df)):   ## 오더 제품 전체
            item_code = order_df.iloc[ii]['ITEM_CODE']

            if ms_con:
                curs = ms_con.cursor()
    # 해당 제품이 할당되지 않은 설비 리스트 . 전체 설비리스트 - 제품 할당 설비 리스트 => 할당 안된 설비 리스트
                sql = " SELECT EQU_CODE  FROM EQU200T WHERE COMP_CODE = '{}' "\
                        "AND DIV_CODE = '{}' AND WORK_SHOP_CODE = '{}' AND PROG_WORK_CODE = '{}' "\
                        "EXCEPT  SELECT EQU_CODE FROM PBS410T "\
                        "WHERE COMP_CODE = '{}' AND DIV_CODE = '{}' "\
                        "AND WORK_SHOP_CODE = '{}' AND PROG_WORK_CODE = '{}' AND ITEM_CODE = '{}'  "\
                    .format(comp_code,div_code,work_shop_code,prog_work_code,
                            comp_code,div_code,work_shop_code,prog_work_code,item_code)

                # print("=================found fac sql =============")
                # print(sql)
                curs.execute(sql)
                row = curs.fetchall()
                not_equ_code_cnt = len(row)   # 제품에 할당 안된 설비 갯수

                # print(f" {equ_code_cnt}  : {not_equ_code_cnt}")

                if equ_code_cnt == not_equ_code_cnt:   # 전체 설비 수와 할당 안된 설비 수가 같으면 , 제품에 할당된 설비가 없는 것, 일단 다 허용으로 넘어감.
                    print(f" [WARN] : 제품 [{item_code}] 에 할당된 설비가 하나도 없습니다  [PBS410T] ")
                    err_msg = '제품 [' + item_code + '[에 할당된 설비가 하나도 없습니다 '
                    log_msg(ms_con,comp_code,div_code,lot_no,'WARN','W010','FIX_PROD_0_FAC','PBS410T',err_msg)

                if equ_code_cnt > not_equ_code_cnt:  # 전체 설비 수 보다 할당 안된 설비 갯수가 적으면 , 그 설비에는 제품 할당을 안 한다
                    if len(row) > 0:
                        for k in range(len(row)):
                            found_fac = row[k][0]
                            for jj in range(len(fac_list)):
                                if fac_list.iloc[jj]['EQU_CODE'] == found_fac:
                                    print("====found can not assign fac =========")
                                    print( f' {item_code} : {found_fac} {ii+1}  {jj+1}  ' )
                                    fix_prod_0.append( (ii+1, jj+1 , 0) )
        return fix_prod_0

# 제품에 기본으로 설정된 설비에 배정한다

def fix_prod_1_fac(ms_con, comp_code, div_code, work_shop_code, prog_work_code, order_df, fac_list, lot_no):
    fix_prod_1 = []
    if ms_con:
        curs = ms_con.cursor()  # 전체 설비 갯수를 카운트 함

        sql = " SELECT distinct equ_code FROM EQU200T WHERE COMP_CODE = '{}' " \
              "AND DIV_CODE = '{}' AND WORK_SHOP_CODE = '{}' AND PROG_WORK_CODE = '{}' " \
            .format(comp_code, div_code, work_shop_code, prog_work_code)

        print(sql)
        curs.execute(sql)
        row = curs.fetchall()
        equ_code_cnt = len(row)
        print(f" EQU_CODE LIST COUNT : {equ_code_cnt}")

        for ii in range(len(order_df)):  ## 오더 제품 전체
            item_code = order_df.iloc[ii]['ITEM_CODE']

            if ms_con:
                curs = ms_con.cursor()
                # 해당 제품이 할당되지 않은 설비 리스트 . 전체 설비리스트 - 제품 할당 설비 리스트 => 할당 안된 설비 리스트
                sql = " SELECT EQU_CODE  FROM EQU200T WHERE COMP_CODE = '{}' " \
                      "AND DIV_CODE = '{}' AND WORK_SHOP_CODE = '{}' AND PROG_WORK_CODE = '{}' " \
                      "EXCEPT  SELECT EQU_CODE FROM PBS410T " \
                      "WHERE COMP_CODE = '{}' AND DIV_CODE = '{}' " \
                      "AND WORK_SHOP_CODE = '{}' AND PROG_WORK_CODE = '{}' AND ITEM_CODE = '{}'  " \
                    .format(comp_code, div_code, work_shop_code, prog_work_code,
                            comp_code, div_code, work_shop_code, prog_work_code, item_code)

                # print("=================found fac sql =============")
                # print(sql)
                curs.execute(sql)
                row = curs.fetchall()
                not_equ_code_cnt = len(row)  # 제품에 할당 안된 설비 갯수

                # print(f" {equ_code_cnt}  : {not_equ_code_cnt}")

                if equ_code_cnt == not_equ_code_cnt:  # 전체 설비 수와 할당 안된 설비 수가 같으면 , 제품에 할당된 설비가 없는 것, 일단 다 허용으로 넘어감.
                    print(f" [WARN] : 제품 [{item_code}] 에 할당된 설비가 하나도 없습니다  [PBS410T] ")
                    err_msg = '제품 [' + item_code + '[에 할당된 설비가 하나도 없습니다 '
                    log_msg(ms_con, comp_code, div_code, lot_no, 'WARN', 'W010', 'FIX_PROD_0_FAC', 'PBS410T', err_msg)

                if equ_code_cnt > not_equ_code_cnt:  # 전체 설비 수 보다 할당 안된 설비 갯수가 적으면 , 그 설비에는 제품 할당을 안 한다
                    if len(row) > 0:
                        for k in range(len(row)):
                            found_fac = row[k][0]
                            for jj in range(len(fac_list)):
                                if fac_list.iloc[jj]['EQU_CODE'] == found_fac:
                                    print("====found can not assign fac =========")
                                    print(f' {item_code} : {found_fac} {ii + 1}  {jj + 1}  ')
                                    fix_prod_1.append((ii + 1, jj + 1, 0))
        return fix_prod_1

def get_base_end_date():
    return '20210601'

def get_base_end_time():
    return 0

def get_base_start_date():
    return '20210601'

def get_base_start_time():
    return 0

def get_next_date(ms_con,comp_code,div_code,work_shop_code,equ_code,start_date):

    if ms_con:
        curs = ms_con.cursor()
        # 생산계획 테이블에서 해당 설비, 해당 제품의 확정된 생산계획의 마지막 종료일자와 시간을 가져온다
        sql = "SELECT WORK_DATE , (CASE WHEN OVER_TIME_YN = 'N' THEN STD_CAPA_TIME ELSE OVER_CAPA_TIME END) " \
              "AS STD_CAPA_TIME  FROM PBS510T " \
              "WHERE COMP_CODE ='{}' AND DIV_CODE = '{}' AND EQU_CODE = '{}' " \
              "AND WORK_DATE = " \
              "( SELECT MIN(WORK_DATE) AS START_DATE  FROM PBS510T  " \
              "WHERE COMP_CODE ='{}' AND DIV_CODE = '{}' AND EQU_CODE = '{}' " \
              "AND WORK_TYPE = '2' AND  WORK_DATE > '{}' )" \
            .format(comp_code, div_code, equ_code,comp_code, div_code, equ_code, start_date)

        print("==========minimum next date =============")
        print(sql)
        curs.execute(sql)
        row = curs.fetchall()
        if len(row) > 0:
            next_date = row[0][0]
            next_capa = row[0][1]
        else:
            next_date = start_date
            next_capa = 630

        print(f" return value next_date : {next_date}  next_capa : {next_capa}")
        return next_date,next_capa

def get_base_capa():
    return 450

def get_std_capa_time(ms_con,comp_code,div_code,work_shop_code,equ_code,start_date):

    if ms_con:
        curs = ms_con.cursor()
        # 현재 날짜의 총 capa ( 분 ) 를 가져온다
        # SELECT     over_time_yn, std_capa_time, over_capa_time,
        # (CASE WHEN over_time_yn = 'N' THEN std_capa_time ELSE over_capa_time END) as capa
        # FROM     PBS510T
        sql = "SELECT (CASE WHEN OVER_TIME_YN = 'N' THEN STD_CAPA_TIME ELSE STD_CAPA_TIME + OVER_CAPA_TIME END) " \
              "AS STD_CAPA_TIME " \
              "FROM PBS510T "\
              "WHERE COMP_CODE ='{}' AND DIV_CODE = '{}' AND EQU_CODE = '{}' " \
              "AND WORK_TYPE = '2' AND  WORK_DATE = '{}' " \
            .format(comp_code, div_code, equ_code, start_date)

        print("==========standard capa today =============")
        print(sql)
        curs.execute(sql)
        row = curs.fetchall()

        if row == None:
            print(f" ===   get_std_capa_time None : {row}   ===")
            std_capa = get_base_capa()
            return std_capa

            # std_capa = int(row[0][0] )
        else:
            print(f" ===   get_std_capa_time OK : {row}   ===")
            print(f" row[0][0]  : {row[0][0]}")
            return row[0][0]

    # return row[0][0]

def get_end_date(ms_con, comp_code,div_code,work_shop_code,equ_code,start_date,start_time,plan_time,overtime):

    # 시작일자를 가지고, 설비 캘린더를 참조해서 plan_time 만큼 더한 종료일자를 계산한다.
    # START_DATE 형식  20210521  , START_TIME 형식  08:30:00
    # PLAN_TIME : 분
    # 현재 날짜의 총 capa ( 분 )
    std_capa = get_std_capa_time(ms_con,comp_code,div_code,work_shop_code,equ_code,start_date)

    # end_time = start_time + timedelta(minutes=plan_time)
    if start_time + plan_time > std_capa:    # 현재 날짜 capa 보다 생산시간이 크면
        end_date,std_capa = get_next_date(ms_con,comp_code,div_code,work_shop_code,equ_code,start_date)  # 다음 날짜와 capa 를 가져옴
        end_time = plan_time
    else:
        end_time = start_time + plan_time
        end_date = start_date

def get_late_date(ms_con,comp_code,div_code,work_shop_code,prog_work_code,equ_code):

    if ms_con:
        curs = ms_con.cursor()
        # 생산계획 테이블에서 해당 설비, 해당 제품의 확정된 생산계획의 마지막 종료일자와 시간을 가져온다
        sql = " SELECT MAX(PLAN_END_DATE) AS END_DATE FROM PPL350T " \
              "WHERE COMP_CODE = '{}' AND DIV_CODE = '{}' " \
              "AND WORK_SHOP_CODE = '{}' AND EQU_CODE = '{}' AND CONFIRM_YN IN ( 'Y' , 'P') " \
            .format(comp_code, div_code, work_shop_code, equ_code)

        # print("========get_late_date=========MAX END DATE=============")
        # print(sql)
        curs.execute(sql)
        row = curs.fetchall()
        if row[0][0] == None:
            print(" sql fetch not : 0 ")
            end_date = get_base_end_date()
            end_time = get_base_end_time()
        elif len(row) > 0:
            end_date = row[0][0]
            sql = " SELECT MAX(PLAN_END_TIME) AS SUM_TIME  FROM PPL350T " \
                  "WHERE COMP_CODE = '{}' AND DIV_CODE = '{}' " \
                  "AND WORK_SHOP_CODE = '{}' AND EQU_CODE = '{}' " \
                  "AND PLAN_END_DATE = '{}' AND CONFIRM_YN IN ( 'Y' , 'P' ) " \
                .format(comp_code, div_code, work_shop_code, equ_code,end_date)
            # print("======get_late_date===========MAX PLAN_SUM_TIME=============")
            # print(sql)
            curs.execute(sql)
            row = curs.fetchall()
            if row[0][0] == None:
                end_time = get_base_end_time()
            else :
                end_time = row[0][0]

        return end_date, end_time

def get_over_limit_time(ms_con,comp_code,div_code,work_shop_code,prog_work_code,equ_code,end_date):

    if ms_con:
        curs = ms_con.cursor()
        # 생산계획 테이블에서 해당 설비, 해당 제품의 확정된 생산계획의 마지막 종료일자와 시간을 가져온다
        sql = " SELECT OVER_TIME_YN FROM PBS510T " \
              "WHERE COMP_CODE = '{}' AND DIV_CODE = '{}' " \
              "AND EQU_CODE = '{}' AND WORK_DATE = '{}' " \
            .format(comp_code, div_code,  equ_code,end_date)

        # print("========overtime yes no =========pbs510t=============")
        # print(sql)
        curs.execute(sql)
        row = curs.fetchone()
        if row[0] == None:
            print(" sql fetch not : 0 ")
            over_time_yes = 'N'
        else:
            over_time_yes = row[0]

        if over_time_yes == 'N':
            sql = " SELECT OVER_TIME_DAY FROM PBS200T " \
                  "WHERE COMP_CODE = '{}' AND DIV_CODE = '{}' " \
                  "AND WORK_SHOP_CODE = '{}' AND PROG_WORK_CODE = '{}' " \
                .format(comp_code, div_code,  work_shop_code,prog_work_code)
        else:
            sql = " SELECT OVER_TIME_NIGHT FROM PBS200T " \
                  "WHERE COMP_CODE = '{}' AND DIV_CODE = '{}' " \
                  "AND WORK_SHOP_CODE = '{}' AND PROG_WORK_CODE = '{}' " \
                .format(comp_code, div_code,  work_shop_code,prog_work_code)

        # print("========overtime yes no =========pbs510t=============")
        # print(sql)
        curs.execute(sql)
        row = curs.fetchone()
        if row[0] == None:
            print(" sql fetch not : 0 ")
            over_time = 'N'
        else:
            over_time = row[0]
        return over_time
    else:
        return 0

def get_next_start_date(ms_con, comp_code,div_code,lot_no,work_shop_code,prog_work_code,equ_code,end_date,total_time,plan_time,item_code):

    # print("=============    get_next_start_date   =============")
    # 해당 날짜의 작업 시간 가져옴 ( 주간 정상, 야간근무 구분 )
    std_capa_time = get_std_capa_time(ms_con,comp_code,div_code,work_shop_code,equ_code,end_date)

    # 시간 초과 허용 오버 타임
    over_limit_time = get_over_limit_time(ms_con,comp_code,div_code,work_shop_code,prog_work_code,equ_code,end_date)

    if total_time + plan_time > std_capa_time + over_limit_time :  # 현재 날짜 capa + 허용 오버시간 보다 생산시간이 크면
        # 설비캘린더에서 다음 생산 가능한 날짜를 가져오고, 시작은 0 부터, 종료는 생산시간만큼
        start_date, std_capa = get_next_date(ms_con, comp_code, div_code, work_shop_code, equ_code,end_date)  # 다음 날짜와 capa 를 가져옴
        start_time = 0

        # 다음날로 넘어가면 제품 연속 생산이 아닌것으로 판단함.
        end_time = get_plan_time(ms_con,comp_code, div_code, lot_no,work_shop_code, prog_work_code,  equ_code,item_code, 'DIFF')

        end_date = start_date

    else:  # 당일 생산시간을 더 해도 넘치지 않으면 , 넘쳐도 오버시간 허용이 되면
        start_date = end_date
        start_time = total_time
        end_time = start_time + plan_time
        end_date = end_date
    return start_date, start_time, end_date, end_time

def  get_plan_time(ms_con,comp_code,div_code, lot_no,work_shop_code,prog_work_code, equ_code,item_code,diff):

    if ms_con:
        curs = ms_con.cursor()
        # 생산계획 테이블에서 해당 설비, 해당 제품의 확정된 생산계획의 마지막 종료일자와 시간을 가져온다

        if diff == 'SAME_ITEM' :   # 바로 앞 제품이 같은 제품
            sql = " SELECT MULTI_PRODT_CT FROM PBS410T " \
                  "WHERE COMP_CODE = '{}' AND DIV_CODE = '{}' " \
                  "AND EQU_CODE = '{}' AND WORK_SHOP_CODE = '{}'  " \
                  "AND PROG_WORK_CODE = '{}' AND ITEM_CODE = '{}' " \
                .format(comp_code, div_code,equ_code, work_shop_code, prog_work_code,item_code)
        else:    # 바로 앞 제품이 다른 제품
            sql = " SELECT SINGLE_PRODT_CT FROM PBS410T " \
                  "WHERE COMP_CODE = '{}' AND DIV_CODE = '{}' " \
                  "AND EQU_CODE = '{}' AND WORK_SHOP_CODE = '{}'  " \
                  "AND PROG_WORK_CODE = '{}' AND ITEM_CODE = '{}' " \
                .format(comp_code, div_code,equ_code, work_shop_code, prog_work_code,item_code)

        print(sql)

        try:
            curs.execute(sql)
            row = curs.fetchone()
            plan_time = row[0]
        except:
            plan_time = 120  # 오류시 기본 시간으로 계산
            err_msg = '해당 제품 코드 [' + item_code + '] [' + equ_code + ']  없음'
            log_msg(ms_con,comp_code,div_code,lot_no,'ERR','E010','GET_PLAN_TIME','PBS410T',err_msg)
            print(f" [ERR] : [get_plan_time] : [{item_code}] 해당 제품 코드 없음  PBS410T")

    return plan_time

def set_daily_plan(ms_con,plan_df):

    plan_table = pd.DataFrame( columns = ("comp_code","div_code","plan_no","order_no","work_shop_code",
                                       "prog_work_code","equ_code","aps_key","item_code","order_qty",
                                       "due_date","plan_qty","plan_cnt", "start_date","start_time",
                                       "end_date","end_time","plan_time","cycle_time","work_men","confirm") )

    daily_plan = plan_df.sort_values( by=['equ_code','item_code','plan_cnt'], ignore_index=True )

    overtime = 'N'
    old_equ_code = ''
    old_start_date = ''

    for ii in range(len(daily_plan)):

        comp_code = daily_plan.iloc[ii]['comp_code']
        div_code = daily_plan.iloc[ii]['div_code']
        work_shop_code = daily_plan.iloc[ii]['work_shop_code']
        prog_work_code = daily_plan.iloc[ii]['prog_work_code']
        equ_code = daily_plan.iloc[ii]['equ_code']
        item_code = daily_plan.iloc[ii]['item_code']
        aps_key = daily_plan.iloc[ii]['aps_key']
        # plan_time = daily_plan.iloc[ii]['plan_time']

        if ii == 0:  # 처음 시작은 무조건 다른 제품
            plan_time = get_plan_time(ms_con, comp_code, div_code, aps_key,work_shop_code, prog_work_code, equ_code,
                                      item_code, 'DIFF')
        else:

            if daily_plan.iloc[ii - 1]['item_code'] == item_code:
                plan_time = get_plan_time(ms_con,comp_code, div_code, aps_key,work_shop_code, prog_work_code,  equ_code,
                                          item_code, 'SAME_ITEM')
            else:
                plan_time = get_plan_time(ms_con,comp_code, div_code, aps_key,work_shop_code, prog_work_code, equ_code,
                                          item_code, 'DIFF')

        if equ_code != old_equ_code :  # 해당 설비 처음 생산 계획이면,
            last_end_date , last_end_time = get_late_date(ms_con, comp_code,div_code,work_shop_code,prog_work_code,equ_code) #그 전에 확정된 설비 생산계획의 제일 마지막 종료일자를 가져온다
        else :  # 설비가 같으면

            # 해당 설비의 바로 앞 종료시간 가져오기
            last_end_date = plan_table.iloc[ii-1]['end_date']
            last_end_time = plan_table.iloc[ii-1]['end_time']

        # total_time = total_time + last_end_time  # 해당 설비 총 소요시간

        # 현재 제품의 시작일자와 소요시간, 종료일자 , 종료 소요 시간
        start_date, start_time , end_date, end_time = \
            get_next_start_date(ms_con, comp_code,div_code,aps_key,work_shop_code,prog_work_code,
                                equ_code, last_end_date,last_end_time,plan_time,item_code)

        if old_start_date != start_date :
            if ii > 0:
                plan_time = end_time - start_time
        order_amount = daily_plan.iloc[ii]['order_qty']
        # item_code = daily_plan.iloc[ii]['item_code']
        plan_no = daily_plan.iloc[ii]['plan_no']

        order_no = daily_plan.iloc[ii]['order_no']
        plan_qty = daily_plan.iloc[ii]['plan_qty']
        plan_cnt = daily_plan.iloc[ii]['plan_cnt']
        due_date = daily_plan.iloc[ii]['due_date']
        # equ_code = daily_plan.iloc[ii]['equ_code']
        cycle_time = daily_plan.iloc[ii]['cycle_time']
        work_men = daily_plan.iloc[ii]['work_men']

        plan_list = [comp_code, div_code, plan_no, order_no, work_shop_code,
                     prog_work_code,equ_code, aps_key, item_code, order_amount,
                     due_date, plan_qty, plan_cnt, start_date, start_time,
                     end_date, end_time, plan_time, cycle_time, work_men, 'P']

        plan_table.loc[ii] = plan_list
        old_equ_code = equ_code
        old_start_date = start_date

    print("set daily plan output")
    # print(plan_table)
    # plan_table.to_excel('C:/MYBOX/NaverCloud/CODI/APS/output/daily_plan.xlsx', sheet_name='plan_df', index=False)

    return plan_table


def split_first_plan(aps_key,comp_code,div_code, work_shop_code,prog_work_code,ms_con, assign_list, order_df, fac_capa_df):

    # 제품 오더 수량이 설비 1회 생산량 보다 많으므로 설비 1회 생산량 기준으로 생산 계획을 나눈다
    # 실제 일일 생산 계획이 된다
    print(" split_first_plan Start.........")
    df_count = 0 # dataframe 의 row

    assign_len = len(assign_list)  # 제품에 할당된 설비 리스트

    plan_df = pd.DataFrame( columns = ("comp_code","div_code","plan_no","order_no","work_shop_code","prog_work_code",
                                       "equ_code","aps_key","item_code","order_qty",
                                       "due_date","plan_qty","plan_cnt", "start_date","start_time",
                                       "end_date","end_time","plan_time","cycle_time","work_men","confirm") )

    if assign_len > 0:

        for i in range(assign_len):   # 할당된 제품과 설비 리스트

            product_no = assign_list[i][0]-1   # 0 부터 시작한다
            equ_no = assign_list[i][1]-1       # 0 부터 시작한다
            assign_ratio = assign_list[i][2]

            if assign_ratio > 0.0:  # 제품별 ( 한 제품이 두 번 나올수 있음 )  최대값은 1 ( 한 제품 한 설비 ) 1보다 작으면 한 설비 이상에 할당된다.

                order_amount = order_df.iloc[product_no]['AMOUNT']
                item_code = order_df.iloc[product_no]['ITEM_CODE']
                plan_no = order_df.iloc[product_no]['WK_PLAN_NUM']
                order_no = order_df.iloc[product_no]['ORDER_NUM']
                equ_one_capa = fac_capa_df.iloc[equ_no]['ONE_CAPA']
                due_date = order_df.iloc[product_no]['DUE_DATE']
                equ_code = fac_capa_df.iloc[equ_no]['EQU_CODE']
                work_men = fac_capa_df.iloc[equ_no]['STD_MEN']
                total_capa = fac_capa_df.iloc[equ_no]['ALL_CAPA']


                product_amount = round( order_df.iloc[product_no]['AMOUNT'] * assign_ratio )  # 해당 설비 해당 배정된 양만큼의 제품 생산 수량 계산

                product_count = int ( math.ceil(product_amount / fac_capa_df.iloc[equ_no]['ONE_CAPA']) )  # 작업 횟수 = 생산 수량 / 해당 설비 1회 capa

                print(f" ASSIGN : {i} : {product_no} : {equ_no} : {equ_code} : {item_code} :{equ_one_capa} : {product_amount}: {product_count}")

                # 제품 별 설비별 할당 전체 - 일단 막아놓는다 - 확인용
                # print(f" {i} : ( {product_no} : {equ_no} : {repeat} : {assign_ratio} :  "
                #       f"{order_df.iloc[product_no]['WK_PLAN_NUM']}  : 제품 : {item_code} : "
                #       f"총 수량 : {order_amount} : 납기 : {due_date} : "
                #       f" 생산수량 : {product_amount} : 생산 횟수 : {product_count} : "
                #       f" 설비 : {equ_code}  : 작업인원 : {work_men} : "
                #       f" NET_CT_S : {net_ct_s} : ACT_CT_S : {act_ct_s} "
                #       f" 1회 CAPA : {equ_one_capa} : ALL CAPA : {total_capa} " )

                remain_product = product_amount  #현재 남은 생산량 , 처음에는 전체 생산량과 같음

                # 설비 1회 생산량 계산
                if remain_product < equ_one_capa:   # 남은 생산량이 설비 capa 보다 작으면
                    plan_qty = remain_product  # 1회 생산량은 전체 생산량이 되고
                else :                                # 1회 생산량이 capa 보다 크면
                    plan_qty = equ_one_capa    # 1회 생산량은 설비 1회 capa

                for pc in range(product_count):  # 설비 1회 가동시마다 계산

                    # 생산에 걸리는 시간 계산 - 바로 앞 제품이랑 같은지 다른지 구분이 필요함.
                    if df_count == 0 :  # 처음 시작은 무조건 다른 제품
                        plan_time = get_plan_time(ms_con, comp_code, div_code,aps_key, work_shop_code, prog_work_code, equ_code,
                                                  item_code, 'DIFF')
                    else :
                        if plan_df.loc[df_count-1]['item_code'] == item_code :
                            plan_time = get_plan_time(ms_con, comp_code,div_code, aps_key,work_shop_code,prog_work_code,equ_code,item_code,'SAME_ITEM')
                        else:
                            plan_time = get_plan_time(ms_con, comp_code,div_code, aps_key,work_shop_code,prog_work_code, equ_code,item_code,'DIFF')
                    # print(f"  plan time == {plan_time}   ==  {act_set_m}")
                    plan_cnt = pc + 1
                    # lot_no 는 처음 aps 돌릴때 받는다
                    # lot_no = equ_code + item_code + str(format(plan_cnt,"03"))
                    # 실제 생산계획 포맷대로 출력
                    # print(f"{comp_code} , {div_code} , {order_no} , {plan_no} , lot_no , {work_shop_code} , "
                    #       f"{equ_code} , {item_code} , {order_amount} , {due_date} , {plan_qty} , "
                    #       f"{plan_cnt} , 0000-00-00 , 00:00:00 , 0000-00-00 , 00:00:00 , "
                    #       f"{plan_time} ,  {act_ct_s} , {work_men} " )

                    plan_list = [comp_code, div_code, plan_no , order_no ,work_shop_code ,prog_work_code,
                                      equ_code, aps_key ,item_code ,order_amount,
                                     due_date , plan_qty , plan_cnt , '2021-05-20',0,
                                     '2021-05-21',0,plan_time, 0, work_men,'P' ]
                    # print( plan_list )
                    plan_df.loc[df_count] = plan_list
                    df_count += 1
                    # 남은 생산량
                    remain_product = remain_product - plan_qty

                    # 설비 1회 생산량 계산
                    if remain_product < equ_one_capa:   # 남은 생산량이 설비 1회 capa 보다 작으면
                        plan_qty = remain_product  # 1회 생산량은 전체 생산량이 되고
                    else :                                # 1회 생산량이 capa 보다 크면
                        plan_qty = equ_one_capa    # 1회 생산량은 설비 1회 capa

    # print("split first plan output")
    # plan_df.to_excel('C:/MYBOX/NaverCloud/CODI/APS/output/split_first.xlsx', sheet_name='plan_df', index=False)

    print(plan_df)

    daily_plan = set_daily_plan(ms_con, plan_df)

    return daily_plan

def check_due_time(aps_key,order_df , plan_df):

    min_shortage = 100
    key_ii = -1
    # # plan df 제품의 생산일자가 오더 테이블의 납기보다 몇 시간(일 기준) 오버하는지 계산한다
    for ii in range(len(plan_df)):
        item_code = plan_df.iloc[ii]['item_code']
        end_date = plan_df.iloc[ii]['end_date']
        plan_no = plan_df.iloc[ii]['plan_no']

        is_plan_num = order_df['WK_PLAN_NUM'] == plan_no
        is_item_code = order_df['ITEM_CODE'] == item_code

        due_date = order_df[is_plan_num & is_item_code]['DUE_DATE'].values[0]


        due_datetime = datetime.strptime(due_date,'%Y%m%d')
        end_datetime = datetime.strptime(end_date, '%Y%m%d')

        shortage = (due_datetime - end_datetime).days
        print(f"===check due date [{ii}] : [{item_code}] : [{plan_no}] : [{due_date}] : [{end_date}] :[{shortage}]   ")

        if shortage < min_shortage:
            min_shortage = shortage
            key_ii = ii

    return min_shortage , key_ii

def run_aps( aps_key,comp_code, div_code, work_shop_code, prog_work_code , split_type,validate, schedule_num):

    ms_con = connect_mssql()

    if ms_con:
        if split_type == 'B':
            var_type = 'Binary'
        else:
            var_type = 'Continuous'

        print(f"========== {work_shop_code}     START =========")

        order_df = get_order(ms_con, comp_code,div_code, work_shop_code, schedule_num) # 수주 계획 읽어 옴
        print("===============order list ==============")
        print(order_df)
        if len(order_df) < 1 :
            print("Order Data not exists")
            err_msg = 'Order Data Not Exists...'
            log_msg(ms_con,comp_code,div_code,aps_key,'ERR','E001','RUN_APS','T_PPL100T',err_msg)
            return -2001

        fac_capa_list = get_fac_basecapa_list(ms_con, comp_code, div_code, work_shop_code,prog_work_code) # 사용 가능한 전체 설비 리스트

        print("===============fac_capa_list  ==============")
        print(fac_capa_list)
        if len(fac_capa_list) < 1 :
            print("fac_capa_list Data not exists")
            err_msg = 'fac_capa_list Data Not Exists...'
            log_msg(ms_con,comp_code,div_code,aps_key,'ERR','E002','RUN_APS','EQU200T',err_msg)
            return -2002

        # 제품별 설비별 CAPA
        # sql = "SELECT  EQU_CODE, ITEM_CODE, DEFAULT_YN, STD_MEN, STD_PRODT_Q, NET_UPH, NET_CT_M, NET_CT_S "\
        #         "FROM PBS410T WHERE comp_code = 'MASTER' AND DIV_CODE = '02' AND WORK_SHOP_CODE = '{}' "\
        #         "and item_code = 'M2215'".format(comp_code,div_code,work_shop_code )
        #
        # 제품에 할당되지 않은 설비 체크 - 해당 제품 , 설비 에는 0 으로 셋팅 - 할당 안 되도록
        fix_prod_0 = fix_prod_0_fac(ms_con,comp_code,div_code,work_shop_code, prog_work_code,order_df, fac_capa_list , aps_key)
        # fix_prod_0 = []

    # 설비 capa 가 하루에 다 안 될 수 있기에, 1시간씩 누적하면서 조건을 만족하는지 loop

        repeat = 1 # 1회 가동 설비 capa
        while True:
            print("LP CALL      : #",repeat)
            fac_capa_df = fac_capa_list.copy()
            all_capa = fac_capa_df['ONE_CAPA'].iloc[::] * repeat
            fac_capa_df.insert(len(fac_capa_df.columns), 'ALL_CAPA', all_capa)

            status , assign_list = cal_lp(aps_key,work_shop_code,  order_df, fac_capa_df, fix_prod_0,var_type)
            if status == 'Optimal':
                print("====Optimal OK === " , repeat )

                break
            else:
                print("====not enough , loop === " , repeat )
            repeat += 1

        # print(f" fac capa df  {repeat} ")
        # print(fac_capa_df)

        # cal_lp_final(lot_no,work_shop_code,  order_df, fac_capa_df, fix_prod_0,var_type,repeat)

        plan_df = split_first_plan(aps_key,comp_code,div_code,work_shop_code, prog_work_code,ms_con, assign_list, order_df, fac_capa_df)

        # 부족한 시간을 계산한다. 부족한 시간만큼 PBS510T 의 야근 플래그를 변경해서 재 작업 함
        # 부족한 시간을 계산해서 리턴 해 줌. 리턴 받으면 부족한 시간 만큼 PBS510T 캘린더 야근 허용을 변경해서 다시 작업함

        # plan_df.to_excel( 'C:/MYBOX/NaverCloud/CODI/APS/Daily_Plan_APS.xlsx' , sheet_name = 'Daily_Plan' , index=False)
        print("===========ASSIGN LIST =============")
        print(assign_list)

        # print( "======order df ========")
        # order_df.to_excel('C:/MYBOX/NaverCloud/CODI/APS/output/order_df.xlsx', sheet_name='order_df', index=False)
        # print( "======split_first_plan ========")
        # plan_df.to_excel('C:/MYBOX/NaverCloud/CODI/APS/output/plan_df.xlsx', sheet_name='plan_df', index=False)

        shortage ,index = check_due_time(aps_key,order_df, plan_df)

        if shortage < 2 :
            print(f"납기가 부족합니다  : {shortage} ")
            print(plan_df.iloc[index])
        else:
            print(f" 최소 여유 납기 : {shortage}")
            print(plan_df.iloc[index])

        if validate == 'Y' :
            confirm_yn = 'V'
        else:
            confirm_yn = 'P'
        print("===========INSERT TABLE =============")
        curs = ms_con.cursor()
        for ii in range(len(plan_df)):
            sql = "INSERT INTO PPL350T (COMP_CODE, DIV_CODE, WK_PLAN_NUM, ORDER_NUM, SEQ, WORK_SHOP_CODE, EQU_CODE,"\
                  "LOT_NO, ITEM_CODE, ORDER_Q, DVRY_DATE, LOT_Q, LOT_COUNT, PLAN_START_DATE, PLAN_START_TIME, "\
                  "PLAN_END_DATE, PLAN_END_TIME, PLAN_TIME, CYCLE_TIME, WORK_MEN, CONFIRM_YN)"\
                  "VALUES ( '{}' , '{}' , '{}' , '{}' , {} , '{}' , '{}' , '{}' , '{}' , {} , '{}' , {} , {}, "\
                  " '{}' , '{}' , '{}' , '{}' , {} , {} , {} , '{}' )"\
                    .format (comp_code,div_code,plan_df.iloc[ii]['plan_no'],plan_df.iloc[ii]['order_no'],1,plan_df.iloc[ii]['work_shop_code'],
                             plan_df.iloc[ii]['equ_code'],plan_df.iloc[ii]['aps_key'],plan_df.iloc[ii]['item_code'],plan_df.iloc[ii]['order_qty'],
                             plan_df.iloc[ii]['due_date'],plan_df.iloc[ii]['plan_qty'],plan_df.iloc[ii]['plan_cnt'],
                             plan_df.iloc[ii]['start_date'],plan_df.iloc[ii]['start_time'],plan_df.iloc[ii]['end_date'],plan_df.iloc[ii]['end_time'],
                             plan_df.iloc[ii]['plan_time'],plan_df.iloc[ii]['cycle_time'],plan_df.iloc[ii]['work_men'],confirm_yn)

            # print(sql)
            curs.execute(sql)
        ms_con.commit()
        ms_con.close()

        print("======END=======")
        return shortage
    else:
        print( "MS-SQL Connect Error")

        return -1000
    # 포장라인 LP

if __name__ == "__main__":
    pd.set_option('display.max_row', 5000)
    pd.set_option('display.max_columns', 1000)
    # pd.set_option('mode.chained_assignment', None)  # <==== 경고를 끈다
    backword = 0
    forward = 1
    # assign_prod_fac('CODI','PACK', backword , 'Continuous')
    comp_code = 'MASTER'
    div_code = '02'
    work_shop_code = 'WSH10'
    prog_work_code = 'H120'
    split_type = 'Binary'
    # split_type = 'Continuous'
    validate = 'Y'
    aps_key = 'APS_0608_02'
    schedule_num    = 'setesteststet'
    #aps_key         = sys.argv[1]  #aps_key
    #comp_code       = sys.argv[2]  #법인코드
    #div_code        = sys.argv[3]  #사업장코드
    #work_shop_code  = sys.argv[4]  #작업장코드
    #prog_work_code  = sys.argv[5]  #공정코드
    #schedule_num    = sys.argv[6]  #aps 조건 테이블 t_ppl100t 로그키
    
    free_day = run_aps( aps_key, comp_code, div_code, work_shop_code, prog_work_code, split_type ,validate, schedule_num)

    print(f"program end...  납기 여유 일수 : {free_day} days")
