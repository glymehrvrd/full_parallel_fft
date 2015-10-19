/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x7708f090 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "D:/dell/Documents/ISE Projects/fft/fft/Dff_preload_1_init_1.vhd";



static void work_a_3037227510_3212880686_p_0(char *t0)
{
    char *t1;
    char *t2;
    int t3;
    unsigned int t4;
    unsigned int t5;
    unsigned int t6;
    unsigned char t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;

LAB0:    xsi_set_current_line(18, ng0);

LAB3:    t1 = (t0 + 1992U);
    t2 = *((char **)t1);
    t3 = (0 - 0);
    t4 = (t3 * -1);
    t5 = (1U * t4);
    t6 = (0 + t5);
    t1 = (t2 + t6);
    t7 = *((unsigned char *)t1);
    t8 = (t0 + 3816);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = t7;
    xsi_driver_first_trans_fast_port(t8);

LAB2:    t13 = (t0 + 3720);
    *((int *)t13) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_3037227510_3212880686_p_1(char *t0)
{
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    unsigned char t8;
    char *t9;
    unsigned char t10;
    unsigned char t11;
    char *t12;
    unsigned char t13;
    unsigned char t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;
    char *t20;

LAB0:    xsi_set_current_line(22, ng0);
    t2 = (t0 + 1152U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 3736);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(23, ng0);
    t4 = (t0 + 1512U);
    t9 = *((char **)t4);
    t10 = *((unsigned char *)t9);
    t11 = (t10 == (unsigned char)2);
    if (t11 == 1)
        goto LAB11;

LAB12:    t4 = (t0 + 1672U);
    t12 = *((char **)t4);
    t13 = *((unsigned char *)t12);
    t14 = (t13 == (unsigned char)3);
    t8 = t14;

LAB13:    if (t8 != 0)
        goto LAB8;

LAB10:    t2 = (t0 + 1352U);
    t4 = *((char **)t2);
    t1 = *((unsigned char *)t4);
    t3 = (t1 == (unsigned char)3);
    if (t3 != 0)
        goto LAB14;

LAB15:
LAB9:    goto LAB3;

LAB5:    t4 = (t0 + 1192U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB7;

LAB8:    xsi_set_current_line(24, ng0);
    t4 = xsi_get_transient_memory(1U);
    memset(t4, 0, 1U);
    t15 = t4;
    memset(t15, (unsigned char)3, 1U);
    t16 = (t0 + 3880);
    t17 = (t16 + 56U);
    t18 = *((char **)t17);
    t19 = (t18 + 56U);
    t20 = *((char **)t19);
    memcpy(t20, t4, 1U);
    xsi_driver_first_trans_fast(t16);
    goto LAB9;

LAB11:    t8 = (unsigned char)1;
    goto LAB13;

LAB14:    xsi_set_current_line(26, ng0);
    t2 = (t0 + 1032U);
    t5 = *((char **)t2);
    t6 = *((unsigned char *)t5);
    t2 = (t0 + 3880);
    t9 = (t2 + 56U);
    t12 = *((char **)t9);
    t15 = (t12 + 56U);
    t16 = *((char **)t15);
    *((unsigned char *)t16) = t6;
    xsi_driver_first_trans_delta(t2, 0U, 1, 0LL);
    goto LAB9;

}


extern void work_a_3037227510_3212880686_init()
{
	static char *pe[] = {(void *)work_a_3037227510_3212880686_p_0,(void *)work_a_3037227510_3212880686_p_1};
	xsi_register_didat("work_a_3037227510_3212880686", "isim/test_fft_pt2_isim_beh.exe.sim/work/a_3037227510_3212880686.didat");
	xsi_register_executes(pe);
}
