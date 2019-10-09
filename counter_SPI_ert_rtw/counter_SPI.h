/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * File: counter_SPI.h
 *
 * Code generated for Simulink model 'counter_SPI'.
 *
 * Model version                  : 1.24
 * Simulink Coder version         : 8.14 (R2018a) 06-Feb-2018
 * C/C++ source code generated on : Tue Jun 26 12:59:36 2018
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#ifndef RTW_HEADER_counter_SPI_h_
#define RTW_HEADER_counter_SPI_h_
#include <string.h>
#include <float.h>
#include <stddef.h>
#ifndef counter_SPI_COMMON_INCLUDES_
# define counter_SPI_COMMON_INCLUDES_
#include "rtwtypes.h"
#include "rtw_extmode.h"
#include "sysran_types.h"
#include "dt_info.h"
#include "ext_work.h"
#include "MW_SPI.h"
#include "MW_SPI_Helper.h"
#endif                                 /* counter_SPI_COMMON_INCLUDES_ */

#include "counter_SPI_types.h"

/* Shared type includes */
#include "multiword_types.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetFinalTime
# define rtmGetFinalTime(rtm)          ((rtm)->Timing.tFinal)
#endif

#ifndef rtmGetRTWExtModeInfo
# define rtmGetRTWExtModeInfo(rtm)     ((rtm)->extModeInfo)
#endif

#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   ((rtm)->errorStatus = (val))
#endif

#ifndef rtmGetStopRequested
# define rtmGetStopRequested(rtm)      ((rtm)->Timing.stopRequestedFlag)
#endif

#ifndef rtmSetStopRequested
# define rtmSetStopRequested(rtm, val) ((rtm)->Timing.stopRequestedFlag = (val))
#endif

#ifndef rtmGetStopRequestedPtr
# define rtmGetStopRequestedPtr(rtm)   (&((rtm)->Timing.stopRequestedFlag))
#endif

#ifndef rtmGetT
# define rtmGetT(rtm)                  ((rtm)->Timing.taskTime0)
#endif

#ifndef rtmGetTFinal
# define rtmGetTFinal(rtm)             ((rtm)->Timing.tFinal)
#endif

#ifndef rtmGetTPtr
# define rtmGetTPtr(rtm)               (&(rtm)->Timing.taskTime0)
#endif

/* Block signals (default storage) */
typedef struct {
  real_T storedValuesOut;              /* '<Root>/MATLAB Function' */
  real_T data2;                        /* '<Root>/MATLAB Function' */
  real_T data3;                        /* '<Root>/MATLAB Function' */
  real_T data4;                        /* '<Root>/MATLAB Function' */
  uint8_T SPIMasterTransfer[4];        /* '<Root>/SPI Master Transfer' */
  uint8_T SPIMasterTransfer1[2];       /* '<Root>/SPI Master Transfer1' */
} B_counter_SPI_T;

/* Block states (default storage) for system '<Root>' */
typedef struct {
  codertarget_raspi_internal_SP_T obj; /* '<Root>/SPI Master Transfer' */
  codertarget_raspi_internal_SP_T obj_m;/* '<Root>/SPI Master Transfer1' */
  struct {
    void *LoggedData[3];
  } Scope_PWORK;                       /* '<Root>/Scope' */

  struct {
    void *LoggedData;
  } Scope1_PWORK;                      /* '<Root>/Scope1' */
} DW_counter_SPI_T;

/* Parameters (default storage) */
struct P_counter_SPI_T_ {
  uint8_T ReadCounter_Value[4];        /* Computed Parameter: ReadCounter_Value
                                        * Referenced by: '<Root>/Read Counter'
                                        */
  uint8_T Constant_Value[2];           /* Computed Parameter: Constant_Value
                                        * Referenced by: '<Root>/Constant'
                                        */
};

/* Real-time Model Data Structure */
struct tag_RTM_counter_SPI_T {
  const char_T *errorStatus;
  RTWExtModeInfo *extModeInfo;

  /*
   * Sizes:
   * The following substructure contains sizes information
   * for many of the model attributes such as inputs, outputs,
   * dwork, sample times, etc.
   */
  struct {
    uint32_T checksums[4];
  } Sizes;

  /*
   * SpecialInfo:
   * The following substructure contains special information
   * related to other components that are dependent on RTW.
   */
  struct {
    const void *mappingInfo;
  } SpecialInfo;

  /*
   * Timing:
   * The following substructure contains information regarding
   * the timing information for the model.
   */
  struct {
    time_T taskTime0;
    uint32_T clockTick0;
    time_T stepSize0;
    time_T tFinal;
    boolean_T stopRequestedFlag;
  } Timing;
};

/* Block parameters (default storage) */
extern P_counter_SPI_T counter_SPI_P;

/* Block signals (default storage) */
extern B_counter_SPI_T counter_SPI_B;

/* Block states (default storage) */
extern DW_counter_SPI_T counter_SPI_DW;

/* Model entry point functions */
extern void counter_SPI_initialize(void);
extern void counter_SPI_step(void);
extern void counter_SPI_terminate(void);

/* Real-time Model object */
extern RT_MODEL_counter_SPI_T *const counter_SPI_M;

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Use the MATLAB hilite_system command to trace the generated code back
 * to the model.  For example,
 *
 * hilite_system('<S3>')    - opens system 3
 * hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'counter_SPI'
 * '<S1>'   : 'counter_SPI/MATLAB Function'
 */
#endif                                 /* RTW_HEADER_counter_SPI_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
