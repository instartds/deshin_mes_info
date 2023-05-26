
from pulp import *

import pandas as pd
import math

import pyodbc
from datetime import datetime , timedelta

import sys

class SetDefault():

    MIXER_TIME = 120  #  제조 기본 작업 시간
    DAY_CAPA = 450  #  제조 주간 작업 시간 ( DB 에 없을 경우 사용 )
    NIGHT_CAPA = 630  #  제조 야근 작업 시간 ( DB 에 없을 경우 사용 )
    SETUP_TIME = 30   # 준비 시간  ( DB 에 없을 경우 사용 )
    # NOT_NEW_TASK = 10   # 다음 작업 최소 준비시간  ( DB 에 없을 경우 사용 )

    def __init__(self,aps_key, comp_code, div_code, work_shop_code, prog_work_code,
                        split_type ,validate, schedule_num,base_start_day,remaining_time,debug):
        self.aps_key = aps_key
        self.comp_code = comp_code
        self.div_code = div_code
        self.work_shop_code = work_shop_code
        self.prog_work_code = prog_work_code
        self.split_type = split_type
        self.validate = validate
        self.schedule_num = schedule_num
        self.base_start_day = base_start_day
        self.remaining_time = int(remaining_time)
        self.debug = debug
        if self.debug == 'Y':
            self.DEBUG = True
        else:
            self.DEBUG = False


class CODI_LP():

    def __init__(self):

        super().__init__()

        self.TODAY = format(datetime.today(), '%Y%m%d')

        self.cycle_time = 0  # 참고용

    def connect_mssql(self):
        try:
            server = 'tcp:211.115.212.14,1433'
            #server = 'tcp:210.122.45.125,9025'
            user = 'unilite'
            password = 'UNILITE'
            db = 'OMEGAPLUS_KODI2_TEST2'
            #db = 'OMEGAPLUS_KODI2'

            ms_con = pyodbc.connect(
                'DRIVER={ODBC Driver 13 for SQL Server};SERVER=' + server + ';DATABASE=' + db + ';UID=' + user + ';PWD=' + password)
            return ms_con
        except:
            return False

    def check_base_day(self,ms_con, base_start_day):
        print(f" before base start day : [{base_start_day}]")

        if ms_con:

            curs = ms_con.cursor()
            sql = "select work_date from pbs510t"
            if base.DEBUG :
                print(sql)
            curs.execute(sql)
            ms_con.commit()

        print(f" after base start day : [{base_start_day}]")

    def log_msg(self,ms_con, err_type,err_code,err_module,err_table,err_desc):

        if ms_con:

            curs = ms_con.cursor()
            sql = "INSERT INTO MRP510T (COMP_CODE, DIV_CODE, APS_CODE,ERR_TYPE,ERR_CODE,ERR_MODULE,ERR_TABLE,ERR_DESC) " \
                    "VALUES ( '{}' , '{}' ,'{}','{}' , '{}' ,'{}','{}' , '{}' )" \
                .format(base.comp_code,base.div_code,base.aps_key,err_type,err_code,err_module,err_table,err_desc)
            if base.DEBUG :
                print(sql)
            curs.execute(sql)
            ms_con.commit()

    def check_dup(self,fix_prod_0 , plan_id):  # 이미 지정되었는지 체크

        for ii in range(len(fix_prod_0)):
            if fix_prod_0[ii][2] == plan_id:
                return False
        return True

    def cal_lp(self,  order_table, fac_capa, fix_prod_0 , var_type):
        # 제품별 생산 에 걸리는 시간 계산 ( 분으로 계산 )
        # 생산 수량을 싸이클 타임(초)으로 나누면   총 생산 시간(분)이 된다
        if base.DEBUG :
            print(f"[cal_lp]============LP START===  {base.work_shop_code} ==================")
            print("[cal_lp]============order table ==================")
            print(order_table)

            print("[cal_lp]============fac_capa table ==================")
            print(fac_capa)
            if base.DEBUG:
                print("[cal_lp]============fix table ==================")
                print(fix_prod_0)
                # fac_capa.to_excel('C:/MYBOX/NaverCloud/CODI/APS/output/lp_fac_capa_' + base.work_shop_code + '.xlsx',
                #                   sheet_name='fac_capa', index=False)
        # 생산 제품의 갯수 ( 1부터 시작해서 +1 을 함 )
        n_a_len = len(order_table) + 1
        # 설비의 갯수 ( 1부터 시작해서 +1 을 함 )
        n_f_len = len(fac_capa) + 1
        # LpProblem 함수를 이용해서 목적식의 종류?를 지정해줍니다
        model = LpProblem(base.aps_key+base.work_shop_code, LpMinimize)  # ("아무거나이름",최소최대,,,)

        n_order = range(1, n_a_len)  # 제품 갯수

        n_facility = range(1, n_f_len)  # 설비 갯수

        # 총 변수의 형태와 갯수 선언 0 또는 1
        prod_var = LpVariable.dicts("prod", (n_order, n_facility), cat=var_type , lowBound=0)

        ## 목적 함수 - 설비 가동시간의 합 이 최소화 - 일
        # model += lpSum(prod_var[r][c] * order_table.iloc[r-1]['AMOUNT'] for c in n_facility for r in
        #                n_order), "Total_Time_for_Capacity"

        ## 지정된 제약 조건 처리
        # 들어갈 수 없는 설비 체크
        fix_len = len(fix_prod_0)

        if fix_len > 0:
            for i in range(fix_len):
                row = fix_prod_0[i][0]
                col = fix_prod_0[i][1]
                fix = fix_prod_0[i][2]
                if base.DEBUG :
                    print(f" FIX 0 : [{i}] : [{row}] [{col}] [{fix}]")

                model += prod_var[row][col] == fix

        ## 지정된 제약 조건 처리
        # 해당 제품에 지정된 설비 체크
        # fix_len = len(fix_prod_1)
        #
        # if fix_len > 0:
        #     for i in range(fix_len):
        #         row = fix_prod_1[i][0]
        #         col = fix_prod_1[i][1]
        #         fix = fix_prod_1[i][2]
        #         print(f" FIX 1 : [{i}] : [{row}] [{col}] [{fix}]")
        #
        #         model += prod_var[row][col] == fix

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
        # if base.DEBUG :
        #     model.writeLP(f"{base.aps_key}{base.work_shop_code}.lp")

        # lp파일을 저장하는 코드
        model.solve()

        # 최적해 구하기
        if base.DEBUG :
            for v in model.variables():
                print(v.name, "=", v.varValue)

        # print("Total Time for Capacity = ", value(model.objective))
        if base.DEBUG :
            print("[cal_lp] Status:", LpStatus[model.status])

        assign_list = []
        for r in n_order:
            for c in n_facility:
                assign_list.append( ( r , c , value(prod_var[r][c]) ) )
                if base.DEBUG :
                    print(f"[cal_lp]  {r}   , {c}  :  {value(prod_var[r][c])}  ")

        return LpStatus[model.status] , assign_list

    # 생산 제품 수량

    def get_order(self,ms_con ):

        if ms_con:

            if base.DEBUG :
                print("schedule_num:", base.schedule_num)

            sql = "SELECT COMP_CODE , DIV_CODE , WORK_SHOP_CODE , WK_PLAN_NUM, ITEM_CODE , WK_PLAN_Q  AS AMOUNT,"\
                    "PRODT_PLAN_DATE AS DUE_DATE, ORDER_NUM , SEQ  "\
                    "FROM T_PPL100T WITH (NOLOCK)"\
                    "WHERE COMP_CODE = '{}' AND DIV_CODE = '{}' and WORK_SHOP_CODE = '{}'" \
                    "AND SCHEDULE_NUM= '{}' " \
                    .format(base.comp_code,base.div_code,base.work_shop_code,base.schedule_num)

            order_df = pd.read_sql_query(sql, ms_con)

            return order_df
        else:
            return -1

    def get_fac_basecapa_list(self,ms_con):

        if ms_con:
            # 20210716 수정. 기존거 주석 처리
            # sql = "SELECT DISTINCT WORK_SHOP_CODE, EQU_CODE , STD_MEN, NET_CT_S, ACT_SET_M," \
            #       " ACT_OUT_M , STD_PRODT_Q as ONE_CAPA FROM PBS410T "\
            #       "WHERE COMP_CODE = '{}' AND DIV_CODE = '{}' AND WORK_SHOP_CODE = '{}' " \
            #       "AND PROG_WORK_CODE = '{}' AND ITEM_CODE IN " \
            #       "( SELECT ITEM_CODE FROM T_PPL100T WITH (NOLOCK) WHERE SCHEDULE_NUM = '{}' )"\
            #     .format(base.comp_code,base.div_code,base.work_shop_code,base.prog_work_code,base.schedule_num )

            sql = "SELECT EQU_CODE, MIN(STD_PRODT_Q) as ONE_CAPA FROM PBS410T "\
                  "WHERE COMP_CODE = '{}' AND DIV_CODE = '{}' AND WORK_SHOP_CODE = '{}' " \
                  "AND PROG_WORK_CODE = '{}' AND USE_YN = 'Y' AND ITEM_CODE IN " \
                  "( SELECT ITEM_CODE FROM T_PPL100T WITH (NOLOCK) WHERE SCHEDULE_NUM = '{}' ) " \
                  "GROUP BY EQU_CODE "\
                .format(base.comp_code,base.div_code,base.work_shop_code,base.prog_work_code,base.schedule_num )

            fac_basecapa_data = pd.read_sql_query(sql, ms_con)

            return fac_basecapa_data
        else:
            return -1

    # 제품에 설정되지 않은  설비를 배제하는 플래그를 지정한다 ( 0 )
    def fix_prod_0_fac(self,ms_con, order_df, fac_list ):

        fix_prod_0 = []

        for ii in range(len(order_df)):   ## 오더 제품 전체

            item_code = order_df.iloc[ii]['ITEM_CODE']

            curs = ms_con.cursor()

            sql = "SELECT  equ_code FROM pbs410t WHERE COMP_CODE = '{}' AND DIV_CODE = '{}' " \
                  "AND WORK_SHOP_CODE = '{}' AND PROG_WORK_CODE = '{}' "\
                   "AND ITEM_CODE IN (SELECT ITEM_CODE FROM T_PPL100T  WITH (NOLOCK) WHERE SCHEDULE_NUM ='{}') " \
                   "EXCEPT " \
                   "SELECT equ_code FROM PBS410T WHERE COMP_CODE = '{}' AND DIV_CODE = '{}' " \
                  "AND WORK_SHOP_CODE = '{}' AND PROG_WORK_CODE = '{}'  AND ITEM_CODE ='{}' " \
                .format(base.comp_code,base.div_code,base.work_shop_code,base.prog_work_code,base.schedule_num,
                        base.comp_code,base.div_code,base.work_shop_code,base.prog_work_code,item_code)

            if base.DEBUG :
                print("  [fix_prod_0_fac]  found fix 0 sql =============")
                print(sql)
            try:
                curs.execute(sql)
                row = curs.fetchall()

                if len(row) > 0:
                    for k in range(len(row)):
                        found_fac = row[k][0]
                        for jj in range(len(fac_list)):
                            if fac_list.iloc[jj]['EQU_CODE'] == found_fac:
                                fix_prod_0.append( (ii+1, jj+1 , 0) )
                                if base.DEBUG :
                                    print( f"  [fix_prod_0_fac]  found fix 0 : {item_code} : [{found_fac}] [{ii+1}] [{jj+1}]  " )
            except Exception as e:
                print(f" [fix_prod_0_fac] Exception 1 {e}")


            sql = "SELECT equ_code FROM PBS410T WHERE COMP_CODE = '{}' AND DIV_CODE = '{}' " \
                  "AND WORK_SHOP_CODE = '{}' AND PROG_WORK_CODE = '{}' AND ITEM_CODE ='{}' AND USE_YN = 'N' " \
                .format(base.comp_code, base.div_code, base.work_shop_code, base.prog_work_code,item_code)

            if base.DEBUG :
                print("  [fix_prod_0_fac] found ")
                print(sql)
            try:
                curs.execute(sql)
                row = curs.fetchall()

                if len(row) > 0:
                    for k in range(len(row)):
                        found_fac = row[k][0]
                        for jj in range(len(fac_list)):
                            if fac_list.iloc[jj]['EQU_CODE'] == found_fac:
                                fix_prod_0.append((ii + 1, jj + 1, 0))
                                if base.DEBUG :
                                    print(f"[fix_prod_0_fac]  found fix 0 : {item_code} : [{found_fac}] [{ii + 1}] [{jj + 1}]  ")
            except Exception as e:
                print(f" [fix_prod_0_fac] Exception 2 {e}")

        return fix_prod_0

    # 제품에 무조건 배정되는 설비에 대한 플래그를 지정한다 (1)
    def fix_prod_1_fac(self,ms_con, order_df, fac_list):

        fix_prod_1 = []
        for ii in range(len(order_df)):   ## 오더 제품 전체

            item_code = order_df.iloc[ii]['ITEM_CODE']

            curs = ms_con.cursor()

            sql = "SELECT equ_code FROM PBS410T WHERE COMP_CODE = '{}' AND DIV_CODE = '{}' " \
                  "AND WORK_SHOP_CODE = '{}' AND PROG_WORK_CODE = '{}'  AND ITEM_CODE ='{}' " \
                  "AND USE_YN = 'Y' " \
                .format(base.comp_code,base.div_code,base.work_shop_code,base.prog_work_code,item_code)

            if base.DEBUG :
                print(" [fix_prod_1_fac]   found FIX 1 sql =============")
                print(sql)
            try:
                curs.execute(sql)
                row = curs.fetchone()

                found_fac = row[0]

                for jj in range(len(fac_list)):
                    if fac_list.iloc[jj]['EQU_CODE'] == found_fac:
                        fix_prod_1.append( (ii+1, jj+1 , 1) )
                        if base.DEBUG :
                            print( f"[fix_prod_1_fac]    found fix 1 : {item_code} : [{found_fac}] [{ii+1}] [{jj+1}]  " )
            except:
                pass
        return fix_prod_1

    def get_base_end_date(self):
        return base.base_start_day

    def get_base_end_time(self):
        return 0

    def get_base_start_date(self):
        return base.base_start_day

    def get_base_start_time(self):
        return 0

    def get_next_date(self,ms_con,equ_code,start_date):

        if ms_con:
            curs = ms_con.cursor()
            # 생산계획 테이블에서 해당 설비, 해당 제품의 확정된 생산계획의 마지막 종료일자와 시간을 가져온다
            sql = "SELECT WORK_DATE , (CASE WHEN OVER_TIME_YN = 'N' THEN STD_CAPA_TIME ELSE OVER_CAPA_TIME END) " \
                  "AS STD_CAPA_TIME  FROM PBS510T " \
                  "WHERE COMP_CODE ='{}' AND DIV_CODE = '{}' AND EQU_CODE = '{}' " \
                  "AND STD_CAPA_TIME > 0" \
                  "AND WORK_DATE = " \
                  "( SELECT MIN(WORK_DATE) AS START_DATE  FROM PBS510T  " \
                  "WHERE COMP_CODE ='{}' AND DIV_CODE = '{}' AND EQU_CODE = '{}' " \
                  "AND WORK_TYPE = '2' AND  WORK_DATE > '{}' )" \
                .format(base.comp_code, base.div_code, equ_code,base.comp_code, base.div_code, equ_code, start_date)

            if base.DEBUG :
                print("  [get_next_date]  minimum next date SQL =============")
                print(sql)
            curs.execute(sql)
            row = curs.fetchall()
            if len(row) > 0:
                next_date = row[0][0]
                next_capa = row[0][1]
            else:
                next_date = start_date
                next_capa = base.NIGHT_CAPA

            if base.DEBUG :
                print(f" [get_next_date]   return value next_date : {next_date}  next_capa : {next_capa}")
            return next_date,next_capa

    # def get_base_capa(self):
    #     return 450

    def get_std_capa_time(self,ms_con,equ_code,start_date):

        if ms_con:
            try:
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
                    .format(base.comp_code, base.div_code, equ_code, start_date)

                if base.DEBUG :
                    print("[get_std_capa_time]  standard capa today SQL  ")
                    print(sql)
                curs.execute(sql)
                row = curs.fetchall()

                # std_capa = int(row[0][0] )
                if base.DEBUG :
                    print(f" [get_std_capa_time]   OK : {row}   ===")
                    print(f" [get_std_capa_time]  row[0][0]  : {row[0][0]}")
                return row[0][0]
            except:
                if base.DEBUG :
                    print(f" ===   get_std_capa_time None : {row}   ===")
                std_capa = base.DAY_CAPA  #테이블에서 못 읽은 경우에 self.get_base_capa()
                return std_capa

    def get_setup_time(self,ms_con,equ_code,item_code):

        if ms_con:
            try:
                curs = ms_con.cursor()
                # 현재 날짜의 총 capa ( 분 ) 를 가져온다
                # SELECT     over_time_yn, std_capa_time, over_capa_time,
                # (CASE WHEN over_time_yn = 'N' THEN std_capa_time ELSE over_capa_time END) as capa
                # FROM     PBS510T
                sql = "SELECT ACT_SET_M , ACT_OUT_M  FROM PBS410T "\
                      "WHERE COMP_CODE ='{}' AND DIV_CODE = '{}' " \
                      "AND WORK_SHOP_CODE = '{}' AND PROG_WORK_CODE = '{}' " \
                      "AND EQU_CODE = '{}' AND ITEM_CODE = '{}' " \
                    .format(base.comp_code, base.div_code,base.work_shop_code,base.prog_work_code, equ_code, item_code)

                if base.DEBUG :
                    print(" [get_setup_time]  setup time today SQL")
                    print(sql)
                curs.execute(sql)
                row = curs.fetchone()

                # std_capa = int(row[0][0] )
                if base.DEBUG :
                    print(f" [get_setup_time]  setup time  OK : {row}   ===")
                    print(f" [get_setup_time]  row[0] row[1]  : {row[0]} {row[1]}")
                return row[0] ,row[1]
            except:
                if base.DEBUG :
                    print(f" [get_setup_time] setup time  None : {row}   ===")
                setup_time = base.SETUP_TIME  #테이블에서 못 읽은 경우에 self.get_base_capa()
                return setup_time, 0

    def get_end_date(self,ms_con, equ_code,start_date,start_time,plan_time,overtime):

        # 시작일자를 가지고, 설비 캘린더를 참조해서 plan_time 만큼 더한 종료일자를 계산한다.
        # START_DATE 형식  YYYYMMDD  , START_TIME 형식 HH:MM:SS
        # PLAN_TIME : 분
        # 현재 날짜의 총 capa ( 분 )
        std_capa = self.get_std_capa_time(ms_con,equ_code,start_date)

        # end_time = start_time + timedelta(minutes=plan_time)
        if start_time + plan_time > std_capa:    # 현재 날짜 capa 보다 생산시간이 크면
            end_date,std_capa = self.get_next_date(ms_con,equ_code,start_date)  # 다음 날짜와 capa 를 가져옴
            end_time = plan_time
        else:
            end_time = start_time + plan_time
            end_date = start_date

    def get_late_date(self,ms_con,equ_code):

        if ms_con:

            try:
                curs = ms_con.cursor()
                # 생산계획 테이블에서 해당 설비, 해당 제품의 확정된 생산계획의 마지막 종료일자와 시간을 가져온다
                sql = " SELECT MAX(PLAN_END_DATE) AS END_DATE FROM PPL350T " \
                      "WHERE COMP_CODE = '{}' AND DIV_CODE = '{}' " \
                      "AND WORK_SHOP_CODE = '{}' AND EQU_CODE = '{}' AND CONFIRM_YN IN ( 'Y' , 'P') " \
                    .format(base.comp_code, base.div_code, base.work_shop_code, equ_code)

                if base.DEBUG :
                    print("========get_late_date=========MAX END DATE=============")
                    print(sql)

                curs.execute(sql)
                row = curs.fetchall()

                if len(row) > 0:

                    end_date = row[0][0]   # 설비의 최종 생산일자
                    # 설비 최종 생산 일자가 기본 첫 생산 일자 보다 앞이면 생산 일자는 기본 시작 일자로 지정한다.

                    if end_date < base.base_start_day :
                        end_date = self.get_base_end_date()
                        end_time = self.get_base_end_time()
                    else:
                        # 최종 생산 시간
                        sql = " SELECT MAX(PLAN_END_TIME) AS SUM_TIME  FROM PPL350T " \
                              "WHERE COMP_CODE = '{}' AND DIV_CODE = '{}' " \
                              "AND WORK_SHOP_CODE = '{}' AND EQU_CODE = '{}' " \
                              "AND PLAN_END_DATE = '{}' AND CONFIRM_YN IN ( 'Y' , 'P' ) " \
                            .format(base.comp_code, base.div_code, base.work_shop_code, equ_code, end_date)
                        if base.DEBUG :
                            print("======get_late_date===========MAX PLAN_SUM_TIME=============")
                            print(sql)
                        try:
                            curs.execute(sql)
                            row = curs.fetchall()
                            if row[0][0] is not None:
                                end_time = row[0][0]
                        except:  # sql query 값이 없으면
                            end_time = self.get_base_end_time()

            except:   # sql query 값이 없으면
                if base.DEBUG :
                    print(" sql fetch not : 0 ")
                end_date = self.get_base_end_date()
                end_time = self.get_base_end_time()

            return end_date, end_time

    def get_over_limit_time(self,ms_con,equ_code,end_date):

        if ms_con:
            try:
                curs = ms_con.cursor()
                # 생산계획 캘린더에서 해당 날짜,  해당 설비의 야근 여부를 가져옴
                sql = " SELECT OVER_TIME_YN FROM PBS510T " \
                      "WHERE COMP_CODE = '{}' AND DIV_CODE = '{}' " \
                      "AND EQU_CODE = '{}' AND WORK_DATE = '{}' AND STD_CAPA_TIME > 0" \
                    .format(base.comp_code, base.div_code,  equ_code,end_date)

                if base.DEBUG :
                    print("========overtime yes no =========pbs510t=============")
                    print(sql)
                curs.execute(sql)
                row = curs.fetchone()
                over_time_yes = row[0]
            except:
                if base.DEBUG :
                    print(" sql PBS510T fetch overtime not : 0 ")
                over_time_yes = 'N'

            try:
                if over_time_yes == 'N':   # 해당 날짜가 주간 근무인 경우, 해당 공정의 주간 근무 허용 오버 시간
                    sql = " SELECT OVER_TIME_DAY FROM PBS200T " \
                          "WHERE COMP_CODE = '{}' AND DIV_CODE = '{}' " \
                          "AND WORK_SHOP_CODE = '{}' AND PROG_WORK_CODE = '{}' " \
                        .format(base.comp_code, base.div_code,  base.work_shop_code,base.prog_work_code)
                else:  # 해당 날짜가 야간 근무인 경우, 해당 공정의 야간 근무 허용 오버 시간
                    sql = " SELECT OVER_TIME_NIGHT FROM PBS200T " \
                          "WHERE COMP_CODE = '{}' AND DIV_CODE = '{}' " \
                          "AND WORK_SHOP_CODE = '{}' AND PROG_WORK_CODE = '{}' " \
                        .format(base.comp_code, base.div_code,  base.work_shop_code,base.prog_work_code)

                curs.execute(sql)
                row = curs.fetchone()
                # if row[0] == None:
                over_time = row[0]
            except:
                if base.DEBUG :
                    print(" sql PBS200T fetch not EXCEPT : 0 ")
                over_time = 0

            return over_time
        else:
            return 0

    def get_next_start_date_2(self,ms_con, equ_code,item_code,daily_plan):

        last_end_date = base.base_start_day
        last_end_time = 0

        if ms_con:
            curs = ms_con.cursor()
            # 생산계획 테이블에서 확정된 해당 제품, 해당 설비의 제일 마지막 일자와 시간을 가져온다
            sql = "select max(plan_end_date) AS plan_end_date , max(plan_end_time) as plan_end_time from ppl350t " \
                  "where comp_code = '{}' and div_code = '{}' and equ_code = '{}'  AND CONFIRM = '{}'" \
                  "and plan_end_date = ( select max(plan_end_date)  from ppl350t " \
                  "where comp_code = '{}' and div_code = '{}' and equ_code = '{}' AND CONFIRM = '{}' )" \
                .format(base.comp_code,base.div_code,equ_code,'P',base.comp_code,base.div_code,equ_code,'P')
            try:
                if base.DEBUG :
                    print("next start2 SQL ")
                    print(sql)
                curs.execute(sql)
                row = curs.fetchone()
                if base.DEBUG :
                    print(f"next start2 SQL : [{row}] : [{row[0]}] , [{row[1]}] ")
                last_end_date = row[0]
                last_end_time = int(row[1])
            except:
                pass
            # 현재까지 할당한 생산계획에서 같은 설비, 같은 아이템의 제일 마지막 시간을 가져온다
            for ii in range(len(daily_plan)):
                d_equ_code = daily_plan.iloc[ii]['equ_code']
                if d_equ_code == equ_code :
                    d_end_date = str(daily_plan.iloc[ii]['end_date'])
                    d_end_time = int(daily_plan.iloc[ii]['end_time'])
                    if base.DEBUG :
                        print(f" d_end_date [{d_end_date}] [{last_end_date}] [{d_end_time}] [{last_end_time}]")
                    # 계획 테이블과 현재 계획 리스트 중 가장 늦은 일자를 마지막 생산계획 시간으로
                    if d_end_date > str(last_end_date) :
                        last_end_date = d_end_date
                        last_end_time = d_end_time
                    if d_end_date == str(last_end_date) :
                        last_end_date = d_end_date
                        if d_end_time > last_end_time:
                            last_end_time = d_end_time

        return last_end_date,int(last_end_time)

    def get_next_start_date(self,ms_con, equ_code,end_date,total_time,plan_time,setup_time,item_code,plan_qty):

        # print("=============    get_next_start_date   =============")
        # 해당 날짜의 작업 시간 가져옴 ( 주간 정상, 야간근무 구분 )  450
        std_capa_time = self.get_std_capa_time(ms_con,equ_code,end_date)

        # 시간 초과 허용 오버 타임   30
        over_limit_time = self.get_over_limit_time(ms_con,equ_code,end_date)

        if total_time + plan_time  >= std_capa_time + over_limit_time :  # 현재 날짜 capa + 허용 오버시간 보다 생산시간이 크면
            # 설비캘린더에서 다음 생산 가능한 날짜를 가져오고, 시작은 0 부터, 종료는 생산시간만큼
            start_date, std_capa = self.get_next_date(ms_con,  equ_code,end_date)  # 다음 날짜와 capa 를 가져옴
            start_time = 0

            # 다음날로 넘어가면 제품 연속 생산이 아닌것으로 판단함.  setup 타입 추가
            end_time = self.get_plan_time(ms_con, equ_code,item_code,plan_qty, 'DIFF')
            end_time = end_time + setup_time
            end_date = start_date

        else:  # 당일 생산시간을 더 해도 넘치지 않으면 , 넘쳐도 오버시간 허용이 되면
            start_date = end_date
            start_time = total_time
            end_time = start_time + plan_time
            end_date = end_date
        return start_date, start_time, end_date, end_time

    def get_BATCH_PRODT_YN(self , ms_con, equ_code, item_code):

        if ms_con:

            curs = ms_con.cursor()
            sql = " SELECT BATCH_PRODT_YN FROM PBS410T " \
                  "WHERE COMP_CODE = '{}' AND DIV_CODE = '{}' " \
                  "AND EQU_CODE = '{}' AND WORK_SHOP_CODE = '{}'  " \
                  "AND PROG_WORK_CODE = '{}' AND ITEM_CODE = '{}' " \
                .format(base.comp_code, base.div_code, equ_code, base.work_shop_code, base.prog_work_code, item_code)

            curs.execute(sql)
            row = curs.fetchone()
            batch_prodt_yn = row[0]

            return batch_prodt_yn

    def  get_plan_time(self,ms_con, equ_code,item_code,plan_qty,diff):

        plan_time = base.MIXER_TIME  # 오류시 기본 시간으로 계산

        if ms_con:
            curs = ms_con.cursor()

            # 해당 공정이 기본 시간 계산 공정인지, 수량 * cycle Time 공정인지 플래그 확인
            batch_prodt_yn = self.get_BATCH_PRODT_YN( ms_con, equ_code, item_code)

            try:
                if batch_prodt_yn =='Y':  # 기본 시간 체크 공정인 경우 - 제조공정
                    # 생산계획 테이블에서 해당 설비, 해당 제품의 확정된 생산계획의 마지막 종료일자와 시간을 가져온다
                    # 제조 공정인 경우  , 기본 cycle time 을 가져온다. 120분 또는 90 분 - 1회 생산량 기준
                    if diff == 'SAME_ITEM' :   # 바로 앞 제품이 같은 제품
                        sql = " SELECT MULTI_PRODT_CT as plan_time FROM PBS410T " \
                              "WHERE COMP_CODE = '{}' AND DIV_CODE = '{}' " \
                              "AND EQU_CODE = '{}' AND WORK_SHOP_CODE = '{}'  " \
                              "AND PROG_WORK_CODE = '{}' AND ITEM_CODE = '{}' " \
                            .format(base.comp_code, base.div_code,equ_code, base.work_shop_code, base.prog_work_code,item_code)
                    else:    # 바로 앞 제품이 다른 제품
                        sql = " SELECT MULTI_PRODT_CT as plan_time FROM PBS410T " \
                              "WHERE COMP_CODE = '{}' AND DIV_CODE = '{}' " \
                              "AND EQU_CODE = '{}' AND WORK_SHOP_CODE = '{}'  " \
                              "AND PROG_WORK_CODE = '{}' AND ITEM_CODE = '{}' " \
                            .format(base.comp_code, base.div_code,equ_code, base.work_shop_code, base.prog_work_code,item_code)

                    curs.execute(sql)
                    row = curs.fetchone()
                    plan_time = row[0]
                    plan_time = int(math.ceil(plan_time))
                    if base.DEBUG :
                        print(f" batch_prodt_yn is Y :  [get_plan_time] : [{equ_code}]  [{base.work_shop_code}] [{item_code}] : [{plan_time}]  {diff}")

                else:
                    # 제조 공정이 아닌 경우, 남은 생산량과 개당 cycle time 을 기준으로 생산 시간을 계산한다.
                    if diff == 'SAME_ITEM' :   # 바로 앞 제품이 같은 제품
                        sql = " SELECT ( net_ct_s * {} ) / 60 as plan_time FROM PBS410T " \
                              "WHERE COMP_CODE = '{}' AND DIV_CODE = '{}' " \
                              "AND EQU_CODE = '{}' AND WORK_SHOP_CODE = '{}'  " \
                              "AND PROG_WORK_CODE = '{}' AND ITEM_CODE = '{}' " \
                            .format(plan_qty,base.comp_code, base.div_code,equ_code, base.work_shop_code, base.prog_work_code,item_code)
                    else:    # 바로 앞 제품이 다른 제품인 경우 준비 시간 더해 줌 ( act_set_m )
                        sql = " SELECT ( ( net_ct_s * {} ) / 60 ) + act_set_m as plan_time FROM PBS410T " \
                              "WHERE COMP_CODE = '{}' AND DIV_CODE = '{}' " \
                              "AND EQU_CODE = '{}' AND WORK_SHOP_CODE = '{}'  " \
                              "AND PROG_WORK_CODE = '{}' AND ITEM_CODE = '{}' " \
                            .format(plan_qty,base.comp_code, base.div_code,equ_code, base.work_shop_code, base.prog_work_code,item_code)
                # print(sql)

                    curs.execute(sql)
                    row = curs.fetchone()
                    plan_time = row[0]
                    plan_time = int(math.ceil(plan_time))
                    if base.DEBUG :
                        print(f"batch_prodt_yn is N :   [get_plan_time] : [{equ_code}]  [{base.work_shop_code}] [{item_code}] : [{plan_time}] {diff}")

            except:
                plan_time = base.MIXER_TIME  # 오류시 기본 시간으로 계산
                err_msg = f"해당 제품 코드 [{item_code}] : [{equ_code}]  없음"
                self.log_msg(ms_con,'ERR','E010','GET_PLAN_TIME','PBS410T',err_msg)
                if base.DEBUG :
                    print(f" [ERR] : [get_plan_time] : [{item_code}] 해당 제품 코드 없음  PBS410T")

        return plan_time

    def get_daily_capa(self, ms_con, equ_code, cycle_time , start_date,item_code):

        # 성형과 포장 공정만 사용한다. 준비시간이 필요 없다. 정리시간만 계산한다
        work_time = self.get_std_capa_time(ms_con, equ_code, start_date)

        ( setup_time , clean_time )= self.get_setup_time( ms_con, equ_code, item_code)
        work_time = ( work_time - int(clean_time) ) * 60    # 분을 초로 환산  27,000  450분 ( 준비시간 제외 )
        print(f" get_daily_capa : [{work_time}] [{cycle_time}]")
        daily_capa = float(work_time / cycle_time )
        daily_capa = int(math.trunc(daily_capa))

        return daily_capa

    def get_tomorrow_capa(self, ms_con, start_day, equ_code):

        if ms_con:
            curs = ms_con.cursor()
            sql = "SELECT WORK_DATE , (CASE WHEN OVER_TIME_YN = 'N' THEN STD_CAPA_TIME ELSE OVER_CAPA_TIME END) " \
                  "AS STD_CAPA_TIME  FROM PBS510T " \
                  "WHERE COMP_CODE ='{}' AND DIV_CODE = '{}' AND EQU_CODE = '{}' AND WORK_DATE > '{}' AND WORK_TYPE = '2' AND STD_CAPA_TIME > 0 "\
                .format(base.comp_code,base.div_code,equ_code,start_day)
            try:
                if base.DEBUG :
                    print(sql)
                curs.execute(sql)
                row = curs.fetchone()
                if len(row) > 0:
                    next_date = row[0]
                    next_capa = row[1]
            except:
                next_date = start_day
                next_capa = base.DAY_CAPA
            return next_date, next_capa

    def set_daily_plan(self,ms_con,plan_df,batch_prodt_yn):

        plan_table = pd.DataFrame( columns = ("comp_code","div_code","plan_no","order_no","order_seq",
                                              "work_shop_code","prog_work_code","equ_code","aps_key",
                                              "item_code","order_qty","due_date","plan_qty","plan_cnt",
                                              "start_date","start_time","end_date","end_time","plan_time"
                                              ,"cycle_time","act_set_m","act_out_m","work_men","confirm") )

        daily_plan = plan_df.sort_values( by=['equ_code','due_date','item_code'], ignore_index=True )

        overtime = 'N'
        old_equ_code = ''
        old_start_date = ''

        if batch_prodt_yn == 'Y':   #제조

            for ii in range(len(daily_plan)):

                equ_code = daily_plan.iloc[ii]['equ_code']
                item_code = daily_plan.iloc[ii]['item_code']
                plan_qty = daily_plan.iloc[ii]['plan_qty']
                # clean_time = daily_plan.iloc[ii]['act_out_m']
                # # plan_time = daily_plan.iloc[ii]['plan_time']
                (setup_time, clean_time) = self.get_setup_time(ms_con, equ_code, item_code)

                if ii == 0:  # 처음 시작은 무조건 다른 제품   90분에 setup time 반영해야 함
                    plan_time = self.get_plan_time(ms_con,  equ_code, item_code,plan_qty, 'DIFF')
                    plan_time = plan_time + setup_time + clean_time

                else:
                    if daily_plan.iloc[ii - 1]['item_code'] == item_code:   # 같으면 90 분 setup time 없음
                        plan_time = self.get_plan_time(ms_con,  equ_code,item_code,plan_qty, 'SAME_ITEM')
                        plan_time = plan_time + clean_time
                    else:  # 다른 제품  90분 + setup time
                        plan_time = self.get_plan_time(ms_con,equ_code,item_code,plan_qty, 'DIFF')
                        plan_time = plan_time + setup_time + clean_time

                if equ_code != old_equ_code :  # 해당 설비 처음 생산 계획이면,
                    last_end_date , last_end_time = self.get_late_date(ms_con, equ_code) #그 전에 확정된 설비 생산계획의 제일 마지막 종료일자를 가져온다
                else :  # 설비가 같으면
                    # 해당 설비의 바로 앞 종료시간 가져오기
                    last_end_date = plan_table.iloc[ii-1]['end_date']
                    last_end_time = plan_table.iloc[ii-1]['end_time']

                # total_time = total_time + last_end_time  # 해당 설비 총 소요시간

                # 현재 제품의 시작일자와 소요시간, 종료일자 , 종료 소요 시간
                start_date, start_time , end_date, end_time = \
                    self.get_next_start_date(ms_con, equ_code, last_end_date,last_end_time,plan_time,setup_time,item_code,plan_qty)

                if old_start_date != start_date :
                    if ii > 0:
                        plan_time = end_time - start_time
                else:
                    setup_time = 0
                order_amount = daily_plan.iloc[ii]['order_qty']
                # item_code = daily_plan.iloc[ii]['item_code']
                plan_no = daily_plan.iloc[ii]['plan_no']

                order_no = daily_plan.iloc[ii]['order_no']
                order_seq = daily_plan.iloc[ii]['order_seq']
                # plan_qty = daily_plan.iloc[ii]['plan_qty']
                plan_cnt = daily_plan.iloc[ii]['plan_cnt']
                due_date = daily_plan.iloc[ii]['due_date']
                # equ_code = daily_plan.iloc[ii]['equ_code']
                cycle_time = daily_plan.iloc[ii]['cycle_time']
                work_men = daily_plan.iloc[ii]['work_men']
                plan_time = plan_time - setup_time - clean_time
                plan_list = [base.comp_code, base.div_code, plan_no, order_no,order_seq, base.work_shop_code,
                             base.prog_work_code,equ_code, base.aps_key, item_code, order_amount,
                             due_date, plan_qty, plan_cnt, start_date, start_time,
                             end_date, end_time, plan_time, cycle_time,setup_time,clean_time, work_men, base.validate]

                plan_table.loc[ii] = plan_list
                old_equ_code = equ_code
                old_start_date = start_date

        elif batch_prodt_yn == 'N':  # 성형 , 포장

            cnt = 0

            old_item_code = ''
            old_equ_code = ''
            for ii in range(len(daily_plan)):

                equ_code = daily_plan.iloc[ii]['equ_code']     # 설비 코드
                item_code = daily_plan.iloc[ii]['item_code']   # 제품 코드
                order_qty = daily_plan.iloc[ii]['order_qty']   # 주문 수량
                cycle_time = daily_plan.iloc[ii]['cycle_time']   # 주문 수량
                remain_qty = order_qty # s남은 수량 계산
                if base.DEBUG :
                    print(f" START DAILY SPLIT : {item_code} {equ_code} {order_qty}")
                plan_cnt = 0

                while remain_qty > 0 :
                    # 작업 할 수 있는 가장 늦은 작업 일자와 사용 시간을 가져온다  0715  , 0
                    start_day , use_time = self.get_next_start_date_2(ms_con, equ_code,item_code,plan_table)
                    # 해당 날짜의 총 작업 시간  450
                    work_time = self.get_std_capa_time( ms_con,equ_code,start_day)
                    # 해당 공정에 준비 시간 가져옴   15  ,  5
                    (setup_time ,clean_time ) = self.get_setup_time(ms_con,equ_code,item_code)
                    # 해당 작업일에 남아 있는 시간 계산 , 종료 시간
                    if ( old_item_code != item_code and old_equ_code != equ_code ) or \
                            ( old_item_code != item_code and old_equ_code == equ_code ) or \
                            ( old_item_code == item_code and old_equ_code != equ_code ):
                        # 같은 설비에 품목이 교체 되면, 품목 교체 시간을 SETUP 시간에 더 해준다
                        if ii > 0 :  # 첫번째 제품이 아니면
                            use_time = use_time + setup_time  # 품목 교체 시간

                    else:
                        setup_time = 0

                    remain_plan_time = work_time - use_time - setup_time - clean_time

                    if base.DEBUG :
                        print(f" Time : [{equ_code}] [{item_code}] [{remain_qty}] [{start_day}]  [{work_time}] [{setup_time}]  [{clean_time}] [{remain_plan_time}] [{use_time}]")
                    # 남은 시간이 사용자 지정시간 보다 적으면 날짜를 해당 설비 다음 일자로 , 생산 가능 시간은 다음 날 전체 시간 - 준비시간
                    # 생산 가능 시간 = plan_time   => 제품 교체가 아니고 동일 제품이면 ???? 바로 시작해야 하는데 ???

                    # 시간 초과 허용 오버 타임 - base.remaining_time 대신 추가해야 하는 로직임
                    # over_limit_time = self.get_over_limit_time(ms_con, equ_code, start_day)

                    if remain_plan_time <= base.remaining_time  :
                        start_day , work_time  = self.get_tomorrow_capa(ms_con,start_day,equ_code)
                        plan_time = work_time - clean_time  # setup time 은 없다
                        start_plan_time = 0
                    else:
                        plan_time = remain_plan_time
                        start_plan_time = use_time
                    # 실제 가능한 생산 수량
                    plan_qty = int( math.ceil( float( (plan_time * 60) / cycle_time ) ) )

                    # 작업 할 수 있는 수량이 남은 수량보다 크면, 남은 수량만큼만 작업한다. 작업시간 다시 계산

                    if plan_qty > remain_qty:
                        plan_qty = remain_qty
                        plan_time = int (  ( remain_qty  * float(cycle_time) ) / 60  )
                        remain_qty = 0
                    else:
                        plan_time = int (  ( plan_qty  * float(cycle_time) ) / 60  )
                        remain_qty = remain_qty - plan_qty

                    order_amount = daily_plan.iloc[ii]['order_qty']
                    # item_code = daily_plan.iloc[ii]['item_code']
                    plan_no = daily_plan.iloc[ii]['plan_no']

                    order_no = daily_plan.iloc[ii]['order_no']
                    order_seq = daily_plan.iloc[ii]['order_seq']
                    # plan_qty = daily_plan.iloc[ii]['plan_qty']
                    plan_cnt += 1
                    due_date = daily_plan.iloc[ii]['due_date']

                    work_men = daily_plan.iloc[ii]['work_men']

                    # 8.22  수정  setup_time + clean_time
                    end_plan_time = start_plan_time + plan_time + setup_time + clean_time
                    # 8.22  수정 => 막음
                    # plan_time = plan_time - setup_time - clean_time
                    plan_list = [base.comp_code, base.div_code, plan_no, order_no, order_seq, base.work_shop_code,
                                 base.prog_work_code, equ_code, base.aps_key, item_code, order_amount,
                                 due_date, plan_qty, plan_cnt, start_day, start_plan_time,
                                 start_day, end_plan_time, plan_time, cycle_time, setup_time,clean_time,
                                 work_men,base.validate ]

                    plan_table.loc[cnt] = plan_list
                    cnt += 1
                    old_equ_code = equ_code
                    old_item_code = item_code
                    if base.DEBUG :
                        print(f" DAILY SPLIT PLAN : {cnt} {order_qty} {plan_qty} {remain_qty}")

        # print("set daily plan output")
        # print(plan_table)
        # if base.DEBUG :
        #     plan_table.to_excel('C:/MYBOX/NaverCloud/CODI/APS/output/daily_plan_'+base.work_shop_code+'.xlsx', sheet_name='daily_plan', index=False)

        return plan_table

    def split_first_plan(self,ms_con, assign_list, order_df, fac_capa_df):

        # 제품 오더 수량이 설비 1회 생산량 보다 많으므로 설비 1회 생산량 기준으로 생산 계획을 나눈다
        # 실제 일일 생산 계획이 된다
        if base.DEBUG :
            print(" split_first_plan Start.........")
        df_count = 0 # dataframe 의 row

        # cycle_time = self.get_BATCH_PRODT_YN()
        assign_len = len(assign_list)  # 제품에 할당된 설비 리스트

        plan_df = pd.DataFrame( columns = ("comp_code","div_code","plan_no","order_no","order_seq",
                                           "work_shop_code","prog_work_code","equ_code","aps_key",
                                           "item_code","order_qty","due_date","plan_qty","plan_cnt",
                                           "start_date","start_time","end_date","end_time","plan_time",
                                           "cycle_time","act_set_m","act_out_m","work_men","confirm") )

        if assign_len > 0:

            for i in range(assign_len):   # 할당된 제품과 설비 리스트

                product_no = assign_list[i][0]-1   # 0 부터 시작한다 ,order list 의 제품 번호
                equ_no = assign_list[i][1]-1       # 0 부터 시작한다  fac_capa 의 설비 번호
                assign_ratio = assign_list[i][2]   # 배부 비율 ( 1.0 )

                if assign_ratio > 0.0:  # 제품별 ( 한 제품이 두 번 나올수 있음 )  최대값은 1 ( 한 제품 한 설비 ) 1보다 작으면 한 설비 이상에 할당된다.

                    order_amount = order_df.iloc[product_no]['AMOUNT']
                    item_code = order_df.iloc[product_no]['ITEM_CODE']
                    plan_no = order_df.iloc[product_no]['WK_PLAN_NUM']
                    order_no = order_df.iloc[product_no]['ORDER_NUM']
                    order_seq = order_df.iloc[product_no]['SEQ']
                    due_date = order_df.iloc[product_no]['DUE_DATE']
                    equ_code = fac_capa_df.iloc[equ_no]['EQU_CODE']

                    curs = ms_con.cursor()
                    sql = "select std_prodt_q ,std_men, net_ct_s , act_set_m , act_out_m , batch_prodt_yn " \
                          "from pbs410t where comp_code = '{}' and div_code = '{}' and work_shop_code = '{}' " \
                          "and prog_work_code = '{}' and item_code = '{}' and equ_code = '{}' ".\
                        format(base.comp_code,base.div_code, base.work_shop_code,base.prog_work_code,item_code,equ_code)

                    curs.execute(sql)
                    row = curs.fetchone()
                    if row is not None:
                        equ_one_capa = row[0]
                        work_men = row[1]
                        cycle_time = row[2]
                        act_set_m = row[3]
                        act_out_m = row[4]
                        batch_prodt_yn = row[5]
                    else:
                        print(f"PBS410T read Error : [{equ_code}] [{item_code}]")
                        exit(-1)
                    #
                    # equ_one_capa = fac_capa_df.iloc[equ_no]['ONE_CAPA']
                    # work_men = fac_capa_df.iloc[equ_no]['STD_MEN']
                    # cycle_time = fac_capa_df.iloc[equ_no]['NET_CT_S']
                    # act_set_m = fac_capa_df.iloc[equ_no]['ACT_SET_M']
                    # act_out_m = fac_capa_df.iloc[equ_no]['ACT_OUT_M']
                    # total_capa = fac_capa_df.iloc[equ_no]['ALL_CAPA']
                    #
                    # batch_prodt_yn = self.get_BATCH_PRODT_YN(ms_con, equ_code, item_code)

                    if batch_prodt_yn =='Y':   # 제조 공정

                        product_amount = round( order_amount * assign_ratio )  # 해당 설비 해당 배정된 양만큼의 제품 생산 수량 계산

                        product_count = int ( math.ceil(product_amount / float(equ_one_capa) ) )  # 작업 횟수 = 생산 수량 / 해당 설비 1회 capa

                        if base.DEBUG :
                            print(f" ASSIGN : {i} : {product_no} : {equ_no} : {equ_code} : {item_code} :{equ_one_capa} : {product_amount}: {product_count}")

                        # 제품 별 설비별 할당 전체 - 일단 막아놓는다 - 확인용
                        # print(f" {i} : ( {product_no} : {equ_no} : {repeat} : {assign_ratio} :  "
                        #       f"{order_df.iloc[product_no]['WK_PLAN_NUM']}  : 제품 : {item_code} : "
                        #       f"총 수량 : {order_amount} : 납기 : {due_date} : "
                        #       f" 생산수량 : {product_amount} : 생산 횟수 : {product_count} : "
                        #       f" 설비 : {equ_code}  : 작업인원 : {work_men} : "
                        #       f" NET_CT_S : {net_ct_s} : ACT_CT_S : {act_ct_s} "
                        #       f" 1회 CAPA : {equ_one_capa} : ALL CAPA : {total_capa} " )

                        remain_product = int(product_amount)  #현재 남은 생산량 , 처음에는 전체 생산량과 같음

                        # 설비 1회 생산량 계산
                        if remain_product < equ_one_capa:   # 남은 생산량이 설비 capa 보다 작으면
                            plan_qty = remain_product  # 1회 생산량은 전체 생산량이 되고
                        else :                                # 1회 생산량이 capa 보다 크면
                            plan_qty = equ_one_capa    # 1회 생산량은 설비 1회 capa

                        for pc in range(product_count):  # 설비 1회 가동시마다 계산

                            # 생산에 걸리는 시간 계산 - 바로 앞 제품이랑 같은지 다른지 구분이 필요함.
                            if df_count == 0 :  # 처음 시작은 무조건 다른 제품
                                plan_time = self.get_plan_time(ms_con, equ_code,item_code, plan_qty,'DIFF')
                            else :
                                if plan_df.loc[df_count-1]['item_code'] == item_code :
                                    plan_time = self.get_plan_time(ms_con,equ_code,item_code,plan_qty,'SAME_ITEM')
                                else:
                                    plan_time = self.get_plan_time(ms_con, equ_code,item_code,plan_qty,'DIFF')
                            # print(f"  plan time == {plan_time}   ==  {act_set_m}")
                            plan_cnt = pc + 1
                            # 실제 생산계획 포맷대로 출력
                            # print(f"{comp_code} , {div_code} , {order_no} , {plan_no} , {aps_key} , {work_shop_code} , "
                            #       f"{equ_code} , {item_code} , {order_amount} , {due_date} , {plan_qty} , "
                            #       f"{plan_cnt} , 0000-00-00 , 00:00:00 , 0000-00-00 , 00:00:00 , "
                            #       f"{plan_time} ,  {act_ct_s} , {work_men} " )

                            plan_list = [base.comp_code, base.div_code, plan_no , order_no ,order_seq,base.work_shop_code ,
                                         base.prog_work_code, equ_code, base.aps_key ,item_code ,order_amount,
                                             due_date , plan_qty , plan_cnt , base.base_start_day,0,
                                             base.base_start_day,0,plan_time, cycle_time,act_set_m,act_out_m, work_men,base.validate ]
                            # print( plan_list )
                            plan_df.loc[df_count] = plan_list
                            df_count += 1
                            # 남은 생산량
                            remain_product = int( remain_product - plan_qty )

                            # 설비 1회 생산량 계산
                            if remain_product < equ_one_capa:   # 남은 생산량이 설비 1회 capa 보다 작으면
                                plan_qty = remain_product  # 1회 생산량은 전체 생산량이 되고
                            else :                                # 1회 생산량이 capa 보다 크면
                                plan_qty = equ_one_capa    # 1회 생산량은 설비 1회 capa
                    else:   # 성형공정, 포장공정 - 하루 생산량을 cycle Time 으로 계산해야 함
                        product_amount = round(order_amount * assign_ratio)  # 해당 설비 해당 배정된 양만큼의 제품 생산 수량 계산

                        equ_one_capa = self.get_daily_capa( ms_con, equ_code, cycle_time,base.base_start_day,item_code)
                        print(f"equ one capa : [{equ_one_capa}]  [{equ_code}] [{cycle_time}]  [{item_code}]  [{base.base_start_day}]")
                        plan_time = int( equ_one_capa / cycle_time )
                        product_count = int(math.ceil(product_amount / equ_one_capa))  # 작업 횟수 = 생산 수량 / 해당 설비 1회 capa

                        plan_list = [base.comp_code, base.div_code, plan_no, order_no, order_seq,
                                     base.work_shop_code,base.prog_work_code, equ_code, base.aps_key,
                                     item_code, product_amount,due_date, equ_one_capa, product_count,
                                     base.base_start_day, 0,base.base_start_day, 0, plan_time,
                                     cycle_time, act_set_m,act_out_m,work_men, base.validate]
                        # print( plan_list )
                        plan_df.loc[i] = plan_list

        if base.DEBUG :
            print("split first plan output")
            # plan_df.to_excel('C:/MYBOX/NaverCloud/CODI/APS/output/split_first_'+base.work_shop_code+'.xlsx', sheet_name='plan_df', index=False)

        # print(plan_df)

        daily_plan = self.set_daily_plan(ms_con, plan_df,batch_prodt_yn)

        return daily_plan

    def check_due_time(self, order_df , plan_df):

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
            if base.DEBUG :
                print(f"===check due date [{ii}] : [{item_code}] : [{plan_no}] : [{due_date}] : [{end_date}] :[{shortage}]   ")

            if shortage < min_shortage:
                min_shortage = shortage
                key_ii = ii

        return min_shortage , key_ii

    def run_aps(self):
        # def run_aps(self, aps_key, comp_code, div_code, work_shop_code, prog_work_code, split_type, validate,
        #             schedule_num, base_start_day):

        # 기본 시작일 설정
        if base.DEBUG :
            print(f"aps_key = {base.aps_key}")
            print(f"comp_code = {base.comp_code}")
            print(f"div_code = {base.div_code}")
            print(f"work_shop_code = {base.work_shop_code}")
            print(f"prog_work_code = {base.prog_work_code}")
            print(f"split_type = {base.split_type}")
            print(f"validate = {base.validate}")
            print(f"schedule_num = {base.schedule_num}")
            print(f"base_start_day = {base.base_start_day}")

        ms_con = self.connect_mssql()

        if ms_con:
            if base.split_type == 'B':
                var_type = 'Binary'
            else:
                var_type = 'Continuous'

            if base.DEBUG :
                print(f"========== {base.work_shop_code}     START =========")

            order_df = self.get_order(ms_con) # 수주 계획 읽어 옴
            if base.DEBUG :
                print("===============order list ==============")
                print(order_df)
            if len(order_df) < 1 :
                if base.DEBUG :
                    print("Order Data not exists")
                err_msg = 'Order Data Not Exists...'
                self.log_msg(ms_con,'ERR','E001','RUN_APS','T_PPL100T',err_msg)
                return -2001

            fac_capa_list = self.get_fac_basecapa_list(ms_con) # 사용 가능한 전체 설비 리스트

            if base.DEBUG :
                print("===============fac_capa_list  ==============")
                print(fac_capa_list)
                # fac_capa_list.to_excel('C:/MYBOX/NaverCloud/CODI/APS/output/fac_capa_' + base.work_shop_code + '.xlsx',
                #                  sheet_name='fac_capa', index=False)

            if len(fac_capa_list) < 1 :
                if base.DEBUG :
                    print("fac_capa_list Data not exists")
                err_msg = 'fac_capa_list Data Not Exists...'
                self.log_msg(ms_con,'ERR','E002','RUN_APS','EQU200T',err_msg)
                return -2002

            # 제품별 설비별 CAPA
            # sql = "SELECT  EQU_CODE, ITEM_CODE, DEFAULT_YN, STD_MEN, STD_PRODT_Q, NET_UPH, NET_CT_M, NET_CT_S "\
            #         "FROM PBS410T WHERE comp_code = 'MASTER' AND DIV_CODE = '02' AND WORK_SHOP_CODE = '{}' "\
            #         "and item_code = 'M2215'".format(comp_code,div_code,work_shop_code )
            #
            # 제품에 할당되지 않은 설비 체크 - 해당 제품 , 설비 에는 0 으로 셋팅 - 할당 안 되도록
            fix_prod_0 = self.fix_prod_0_fac(ms_con,order_df, fac_capa_list)
            # 제품에 무조건 할당해야하는  설비 체크 - 해당 제품 , 설비 에는 1 로 셋팅 - 우선 지정 설비
            # fix_prod_1 = self.fix_prod_1_fac(ms_con,order_df, fac_capa_list)

        # 설비 capa 가 하루에 다 안 될 수 있기에, 1시간씩 누적하면서 조건을 만족하는지 loop

            repeat = 1 # 1회 가동 설비 capa

            while True:

                if base.DEBUG :
                    print("LP CALL      : #",repeat)

                fac_capa_df = fac_capa_list.copy()

                all_capa = fac_capa_df['ONE_CAPA'].iloc[::] * repeat

                fac_capa_df.insert(len(fac_capa_df.columns), 'ALL_CAPA', all_capa)

                status , assign_list = self.cal_lp( order_df, fac_capa_df, fix_prod_0,var_type)

                if status == 'Optimal':
                    if base.DEBUG :
                        print("====Optimal OK === " , repeat )
                    break
                else:
                    if base.DEBUG :
                        print("====not enough , loop === " , repeat )
                    pass
                repeat += 1

            # print(f" fac capa df  {repeat} ")
            # print(fac_capa_df)

            plan_df = self.split_first_plan(ms_con, assign_list, order_df, fac_capa_df)

            # 부족한 시간을 계산한다. 부족한 시간만큼 PBS510T 의 야근 플래그를 변경해서 재 작업 함
            # 부족한 시간을 계산해서 리턴 해 줌. 리턴 받으면 부족한 시간 만큼 PBS510T 캘린더 야근 허용을 변경해서 다시 작업함

            if base.DEBUG :
                print("===========ASSIGN LIST =============")
                print(assign_list)

            shortage ,index = self.check_due_time(order_df, plan_df)

            if shortage < 2 :
                print(f"납기가 부족합니다  : {shortage} ")
                print(plan_df.iloc[index])
            else:
                print(f" 최소 여유 납기 : {shortage}")
                print(plan_df.iloc[index])

            if base.validate == 'Y' :
                confirm_yn = 'V'  # validation 만
            elif base.validate == 'P' :
                confirm_yn = 'P'  # 가 확정 상태
            else:
                confirm_yn = 'N'  #
            print("===========INSERT TABLE =============")
            curs = ms_con.cursor()
            for ii in range(len(plan_df)):
                sql = "INSERT INTO PPL350T (COMP_CODE, DIV_CODE, WK_PLAN_NUM, ORDER_NUM, SEQ, WORK_SHOP_CODE, EQU_CODE,"\
                      "ITEM_CODE, ORDER_Q, DVRY_DATE, LOT_Q, LOT_COUNT, PLAN_START_DATE, PLAN_START_TIME,PLAN_END_DATE, "\
                      "PLAN_END_TIME, PLAN_TIME, CYCLE_TIME, ACT_SET_M, ACT_OUT_M,WORK_MEN, CONFIRM_YN,MRP_CONTROL_NUM)"\
                      "VALUES ( '{}' , '{}' , '{}' , '{}' , {} , '{}' , '{}' ,  '{}' , {} , '{}' , {} , {}, "\
                      " '{}' , '{}' , '{}' , '{}' , {} , {} , {} , {} ,{} ,'{}','{}' )"\
                        .format (base.comp_code,base.div_code,plan_df.iloc[ii]['plan_no'],plan_df.iloc[ii]['order_no'],
                                 plan_df.iloc[ii]['order_seq'],plan_df.iloc[ii]['work_shop_code'],
                                 plan_df.iloc[ii]['equ_code'],plan_df.iloc[ii]['item_code'],plan_df.iloc[ii]['order_qty'],
                                 plan_df.iloc[ii]['due_date'],plan_df.iloc[ii]['plan_qty'],plan_df.iloc[ii]['plan_cnt'],
                                 plan_df.iloc[ii]['start_date'],plan_df.iloc[ii]['start_time'],plan_df.iloc[ii]['end_date'],
                                 plan_df.iloc[ii]['end_time'],plan_df.iloc[ii]['plan_time'],plan_df.iloc[ii]['cycle_time'],
                                 plan_df.iloc[ii]['act_set_m'],plan_df.iloc[ii]['act_out_m'],
                                 plan_df.iloc[ii]['work_men'],confirm_yn,plan_df.iloc[ii]['aps_key'])

                # print(sql)
                curs.execute(sql)
            ms_con.commit()
            ms_con.close()

            if base.DEBUG :
                print("======END=======")
            return shortage
        else:
            if base.DEBUG :
                print( "MS-SQL Connect Error")

            return -1000
        # 포장라인 LP

if __name__ == "__main__":

    pd.set_option('display.max_row', 5000)
    pd.set_option('display.max_columns', 1000)
    # pd.set_option('mode.chained_assignment', None)  # <==== 경고를 끈다
    backword = 0
    forward = 1

    #comp_code = 'MASTER'
    #div_code = '02'
    #work_shop_code = 'WSH10'
    #prog_work_code = 'H120'
    #split_type = 'B'    # Binary  => 이것도 sys.argv 에 추가 되어야 함
    # #split_type = 'C'  # Continuous
    #validate = 'Y'   #argv[9]    "Y' , 'N' , 'P'
    #aps_key = 'APS20210822230633917'
    #schedule_num  = '20210822231246063314'
    #base_start_day = '20210812'
    #remaining_time = 10
    #debug  = 'Y'
    aps_key         = sys.argv[1]  #aps_key
    comp_code       = sys.argv[2]  #법인코드
    div_code        = sys.argv[3]  #사업장코드
    work_shop_code  = sys.argv[4]  #작업장코드
    prog_work_code  = sys.argv[5]  #공정코드
    schedule_num    = sys.argv[6]  #aps 조건 테이블 t_ppl100t 로그키
    base_start_day  = sys.argv[7]  #기본 시작 일자
    split_type =  sys.argv[8]   # 이것도 필요함 . 제조 는 'B'  , 포장은 'C' 가 될 수 있음
    validate = sys.argv[9]      # 이것도 일단 필요함  . 추후 사용 예정 ( 'Y','N','P' ) - 일단은 'Y' 나 'P' 만 사용
    remaining_time = sys.argv[10]      # 다음날로 이월이 가능한 최소 근무 근무시간
    debug = sys.argv[11]      # debug 용 , default = 'N'

    #print(f" sys.argv  {sys.argv[1]} {sys.argv[2]} {sys.argv[3]} {sys.argv[4]} {sys.argv[5]}"
     #     f" {sys.argv[6]} {sys.argv[7]}  {sys.argv[8]} {sys.argv[9]} {sys.argv[10]} {sys.argv[10]}")

    base = SetDefault(aps_key, comp_code, div_code, work_shop_code, prog_work_code,
                        split_type ,validate, schedule_num,base_start_day,remaining_time,debug)

    codi = CODI_LP()

    free_day = codi.run_aps()

    if base.DEBUG :
        print(f"program end...  납기 여유 일수 : {free_day} days")
