/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * File: counter_SPI_types.h
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

#ifndef RTW_HEADER_counter_SPI_types_h_
#define RTW_HEADER_counter_SPI_types_h_
#include "rtwtypes.h"
#include "multiword_types.h"

/* Custom Type definition for MATLABSystem: '<Root>/SPI Master Transfer' */
#include "MW_SVD.h"
#include <stddef.h>
#ifndef typedef_codertarget_raspi_internal_Ha_T
#define typedef_codertarget_raspi_internal_Ha_T

typedef struct {
  int32_T __dummy;
} codertarget_raspi_internal_Ha_T;

#endif                                 /*typedef_codertarget_raspi_internal_Ha_T*/

#ifndef typedef_codertarget_raspi_internal_SP_T
#define typedef_codertarget_raspi_internal_SP_T

typedef struct {
  boolean_T matlabCodegenIsDeleted;
  int32_T isInitialized;
  boolean_T isSetupComplete;
  codertarget_raspi_internal_Ha_T Hw;
  MW_Handle_Type MW_SPI_HANDLE;
} codertarget_raspi_internal_SP_T;

#endif                                 /*typedef_codertarget_raspi_internal_SP_T*/

/* Parameters (default storage) */
typedef struct P_counter_SPI_T_ P_counter_SPI_T;

/* Forward declaration for rtModel */
typedef struct tag_RTM_counter_SPI_T RT_MODEL_counter_SPI_T;

#endif                                 /* RTW_HEADER_counter_SPI_types_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
