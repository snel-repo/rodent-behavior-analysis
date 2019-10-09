/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * File: counter_SPI.c
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

#include "counter_SPI.h"
#include "counter_SPI_private.h"
#include "counter_SPI_dt.h"

/* Block signals (default storage) */
B_counter_SPI_T counter_SPI_B;

/* Block states (default storage) */
DW_counter_SPI_T counter_SPI_DW;

/* Real-time model */
RT_MODEL_counter_SPI_T counter_SPI_M_;
RT_MODEL_counter_SPI_T *const counter_SPI_M = &counter_SPI_M_;

/* Forward declaration for local functions */
static void SystemProp_matlabCodegenSetAnyP(codertarget_raspi_internal_SP_T *obj,
  boolean_T value);
static void counter_SPI_SystemCore_release(const codertarget_raspi_internal_SP_T
  *obj);
static void counter_SPI_SystemCore_delete(const codertarget_raspi_internal_SP_T *
  obj);
static void matlabCodegenHandle_matlabCodeg(codertarget_raspi_internal_SP_T *obj);
static void SystemProp_matlabCodegenSetAnyP(codertarget_raspi_internal_SP_T *obj,
  boolean_T value)
{
  /* Start for MATLABSystem: '<Root>/SPI Master Transfer' */
  obj->matlabCodegenIsDeleted = value;
}

static void counter_SPI_SystemCore_release(const codertarget_raspi_internal_SP_T
  *obj)
{
  uint32_T PinNameLoc;
  uint32_T MOSIPinLoc;
  uint32_T MISOPinLoc;
  uint32_T SCKPinLoc;

  /* Start for MATLABSystem: '<Root>/SPI Master Transfer' */
  if ((obj->isInitialized == 1) && obj->isSetupComplete) {
    PinNameLoc = SPI0_CE0;
    MOSIPinLoc = MW_UNDEFINED_VALUE;
    MISOPinLoc = MW_UNDEFINED_VALUE;
    SCKPinLoc = MW_UNDEFINED_VALUE;
    MW_SPI_Close(obj->MW_SPI_HANDLE, MOSIPinLoc, MISOPinLoc, SCKPinLoc,
                 PinNameLoc);
  }

  /* End of Start for MATLABSystem: '<Root>/SPI Master Transfer' */
}

static void counter_SPI_SystemCore_delete(const codertarget_raspi_internal_SP_T *
  obj)
{
  /* Start for MATLABSystem: '<Root>/SPI Master Transfer' */
  counter_SPI_SystemCore_release(obj);
}

static void matlabCodegenHandle_matlabCodeg(codertarget_raspi_internal_SP_T *obj)
{
  /* Start for MATLABSystem: '<Root>/SPI Master Transfer' */
  if (!obj->matlabCodegenIsDeleted) {
    SystemProp_matlabCodegenSetAnyP(obj, true);
    counter_SPI_SystemCore_delete(obj);
  }

  /* End of Start for MATLABSystem: '<Root>/SPI Master Transfer' */
}

/* Model step function */
void counter_SPI_step(void)
{
  uint8_T rdDataRaw[4];
  uint32_T PinNameLoc;
  uint8_T status;
  MW_SPI_Mode_type ClockModeValue;
  MW_SPI_FirstBitTransfer_Type MsbFirstTransferLoc;
  uint8_T rdDataRaw_0[2];

  /* Start for MATLABSystem: '<Root>/SPI Master Transfer' incorporates:
   *  Constant: '<Root>/Read Counter'
   */
  PinNameLoc = SPI0_CE0;
  MW_SPI_SetSlaveSelect(counter_SPI_DW.obj.MW_SPI_HANDLE, PinNameLoc, true);
  ClockModeValue = MW_SPI_MODE_0;
  MsbFirstTransferLoc = MW_SPI_MOST_SIGNIFICANT_BIT_FIRST;
  status = MW_SPI_SetFormat(counter_SPI_DW.obj.MW_SPI_HANDLE, 8, ClockModeValue,
    MsbFirstTransferLoc);
  if (!(status != 0)) {
    MW_SPI_MasterWriteRead_8bits(counter_SPI_DW.obj.MW_SPI_HANDLE,
      counter_SPI_P.ReadCounter_Value, rdDataRaw, 4U);
  }

  memcpy((void *)&counter_SPI_B.SPIMasterTransfer[0], (void *)&rdDataRaw[0],
         (uint32_T)((size_t)4 * sizeof(uint8_T)));

  /* End of Start for MATLABSystem: '<Root>/SPI Master Transfer' */

  /* MATLAB Function: '<Root>/MATLAB Function' */
  counter_SPI_B.storedValuesOut = ((counter_SPI_B.SPIMasterTransfer[1] << 16) +
    (counter_SPI_B.SPIMasterTransfer[2] << 8)) +
    counter_SPI_B.SPIMasterTransfer[3];
  counter_SPI_B.data2 = counter_SPI_B.SPIMasterTransfer[1];
  counter_SPI_B.data3 = counter_SPI_B.SPIMasterTransfer[2];
  counter_SPI_B.data4 = counter_SPI_B.SPIMasterTransfer[3];

  /* MATLABSystem: '<Root>/SPI Master Transfer1' incorporates:
   *  Constant: '<Root>/Constant'
   */
  PinNameLoc = SPI0_CE0;
  MW_SPI_SetSlaveSelect(counter_SPI_DW.obj_m.MW_SPI_HANDLE, PinNameLoc, true);
  ClockModeValue = MW_SPI_MODE_0;
  MsbFirstTransferLoc = MW_SPI_MOST_SIGNIFICANT_BIT_FIRST;
  status = MW_SPI_SetFormat(counter_SPI_DW.obj_m.MW_SPI_HANDLE, 8,
    ClockModeValue, MsbFirstTransferLoc);
  if (!(status != 0)) {
    MW_SPI_MasterWriteRead_8bits(counter_SPI_DW.obj_m.MW_SPI_HANDLE,
      counter_SPI_P.Constant_Value, rdDataRaw_0, 2U);
  }

  memcpy((void *)&counter_SPI_B.SPIMasterTransfer1[0], (void *)&rdDataRaw_0[0],
         (uint32_T)((size_t)2 * sizeof(uint8_T)));

  /* End of MATLABSystem: '<Root>/SPI Master Transfer1' */

  /* External mode */
  rtExtModeUploadCheckTrigger(1);

  {                                    /* Sample time: [0.002s, 0.0s] */
    rtExtModeUpload(0, counter_SPI_M->Timing.taskTime0);
  }

  /* signal main to stop simulation */
  {                                    /* Sample time: [0.002s, 0.0s] */
    if ((rtmGetTFinal(counter_SPI_M)!=-1) &&
        !((rtmGetTFinal(counter_SPI_M)-counter_SPI_M->Timing.taskTime0) >
          counter_SPI_M->Timing.taskTime0 * (DBL_EPSILON))) {
      rtmSetErrorStatus(counter_SPI_M, "Simulation finished");
    }

    if (rtmGetStopRequested(counter_SPI_M)) {
      rtmSetErrorStatus(counter_SPI_M, "Simulation finished");
    }
  }

  /* Update absolute time for base rate */
  /* The "clockTick0" counts the number of times the code of this task has
   * been executed. The absolute time is the multiplication of "clockTick0"
   * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
   * overflow during the application lifespan selected.
   */
  counter_SPI_M->Timing.taskTime0 =
    (++counter_SPI_M->Timing.clockTick0) * counter_SPI_M->Timing.stepSize0;
}

/* Model initialize function */
void counter_SPI_initialize(void)
{
  /* Registration code */

  /* initialize real-time model */
  (void) memset((void *)counter_SPI_M, 0,
                sizeof(RT_MODEL_counter_SPI_T));
  rtmSetTFinal(counter_SPI_M, -1);
  counter_SPI_M->Timing.stepSize0 = 0.002;

  /* External mode info */
  counter_SPI_M->Sizes.checksums[0] = (2668201857U);
  counter_SPI_M->Sizes.checksums[1] = (3454687073U);
  counter_SPI_M->Sizes.checksums[2] = (1431664953U);
  counter_SPI_M->Sizes.checksums[3] = (766520679U);

  {
    static const sysRanDType rtAlwaysEnabled = SUBSYS_RAN_BC_ENABLE;
    static RTWExtModeInfo rt_ExtModeInfo;
    static const sysRanDType *systemRan[4];
    counter_SPI_M->extModeInfo = (&rt_ExtModeInfo);
    rteiSetSubSystemActiveVectorAddresses(&rt_ExtModeInfo, systemRan);
    systemRan[0] = &rtAlwaysEnabled;
    systemRan[1] = &rtAlwaysEnabled;
    systemRan[2] = &rtAlwaysEnabled;
    systemRan[3] = &rtAlwaysEnabled;
    rteiSetModelMappingInfoPtr(counter_SPI_M->extModeInfo,
      &counter_SPI_M->SpecialInfo.mappingInfo);
    rteiSetChecksumsPtr(counter_SPI_M->extModeInfo,
                        counter_SPI_M->Sizes.checksums);
    rteiSetTPtr(counter_SPI_M->extModeInfo, rtmGetTPtr(counter_SPI_M));
  }

  /* block I/O */
  (void) memset(((void *) &counter_SPI_B), 0,
                sizeof(B_counter_SPI_T));

  /* states (dwork) */
  (void) memset((void *)&counter_SPI_DW, 0,
                sizeof(DW_counter_SPI_T));

  /* data type transition information */
  {
    static DataTypeTransInfo dtInfo;
    (void) memset((char_T *) &dtInfo, 0,
                  sizeof(dtInfo));
    counter_SPI_M->SpecialInfo.mappingInfo = (&dtInfo);
    dtInfo.numDataTypes = 15;
    dtInfo.dataTypeSizes = &rtDataTypeSizes[0];
    dtInfo.dataTypeNames = &rtDataTypeNames[0];

    /* Block I/O transition table */
    dtInfo.BTransTable = &rtBTransTable;

    /* Parameters transition table */
    dtInfo.PTransTable = &rtPTransTable;
  }

  {
    codertarget_raspi_internal_SP_T *obj;
    uint32_T SSPinNameLoc;
    uint32_T MOSIPinLoc;
    uint32_T MISOPinLoc;
    uint32_T SCKPinLoc;

    /* Start for MATLABSystem: '<Root>/SPI Master Transfer' */
    counter_SPI_DW.obj.matlabCodegenIsDeleted = true;
    counter_SPI_DW.obj.isInitialized = 0;
    counter_SPI_DW.obj.matlabCodegenIsDeleted = false;
    obj = &counter_SPI_DW.obj;
    counter_SPI_DW.obj.isSetupComplete = false;
    counter_SPI_DW.obj.isInitialized = 1;
    SSPinNameLoc = SPI0_CE0;
    MOSIPinLoc = MW_UNDEFINED_VALUE;
    MISOPinLoc = MW_UNDEFINED_VALUE;
    SCKPinLoc = MW_UNDEFINED_VALUE;
    obj->MW_SPI_HANDLE = MW_SPI_Open(0U, MOSIPinLoc, MISOPinLoc, SCKPinLoc,
      SSPinNameLoc, true, 0);
    MW_SPI_SetBusSpeed(counter_SPI_DW.obj.MW_SPI_HANDLE, 500000U);
    counter_SPI_DW.obj.isSetupComplete = true;

    /* Start for MATLABSystem: '<Root>/SPI Master Transfer1' */
    counter_SPI_DW.obj_m.matlabCodegenIsDeleted = true;
    counter_SPI_DW.obj_m.isInitialized = 0;
    counter_SPI_DW.obj_m.matlabCodegenIsDeleted = false;
    obj = &counter_SPI_DW.obj_m;
    counter_SPI_DW.obj_m.isSetupComplete = false;
    counter_SPI_DW.obj_m.isInitialized = 1;
    SSPinNameLoc = SPI0_CE0;
    MOSIPinLoc = MW_UNDEFINED_VALUE;
    MISOPinLoc = MW_UNDEFINED_VALUE;
    SCKPinLoc = MW_UNDEFINED_VALUE;
    obj->MW_SPI_HANDLE = MW_SPI_Open(0U, MOSIPinLoc, MISOPinLoc, SCKPinLoc,
      SSPinNameLoc, true, 0);
    MW_SPI_SetBusSpeed(counter_SPI_DW.obj_m.MW_SPI_HANDLE, 500000U);
    counter_SPI_DW.obj_m.isSetupComplete = true;
  }
}

/* Model terminate function */
void counter_SPI_terminate(void)
{
  /* Terminate for MATLABSystem: '<Root>/SPI Master Transfer' */
  matlabCodegenHandle_matlabCodeg(&counter_SPI_DW.obj);

  /* Terminate for MATLABSystem: '<Root>/SPI Master Transfer1' */
  matlabCodegenHandle_matlabCodeg(&counter_SPI_DW.obj_m);
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
