const CS_MODE_SINGLE = 0x01
const CS_MODE_DUAL = 0x02
const CS_MODE_QUAD = 0x04
const CS_MODE_OCT = 0x08
const CS_MASKED_MODE = Float32(0x00000000)
const CS_MODE_RESERVED = 0x10
const CS_MODE_EXPERT_HISTOGRAM = 0x20
const CS_MODE_SINGLE_CHANNEL2 = 0x40
const CS_MODE_POWER_ON = 0x80
const CS_MODE_REFERENCE_CLK = 0x0400
const CS_MODE_CS3200_CLK_INVERT = 0x0800
const TIMESTAMP_GCLK = 0x00
const TIMESTAMP_FREERUN = 0x10
const TIMESTAMP_DEFAULT = TIMESTAMP_GCLK | TIMESTAMP_FREERUN
const TIMESTAMP_MCLK = 0x01
const TIMESTAMP_SEG_RESET = 0x00
#-------------------------------------------------------------------------------
const TxMODE_DATA_ANALOGONLY = 0x00
const TxMODE_DEFAULT = TxMODE_DATA_ANALOGONLY
const TxMODE_SLAVE = 0x80000000
const TxMODE_MULTISEGMENTS = 0x40000000
const TxMODE_DATA_FLOAT = 0x01
const TxMODE_TIMESTAMP = 0x02
const TxMODE_DATA_16 = 0x04
const TxMODE_DATA_ONLYDIGITAL = 0x08
const TxMODE_DATA_32 = 0x10
const TxMODE_DATA_FFT = 0x30
const TxMODE_DATA_INTERLEAVED = 0x40
const TxMODE_SEGMENT_TAIL = 0x80
const TxMODE_HISTOGRAM = 0x0100
const TxMODE_DATA_64 = 0x0200
const TxMODE_DEBUG_DISP = 0x10000000
const TxFORMAT_OCTAL_INTERLEAVED = 0x12345678
const TxFORMAT_QUAD_INTERLEAVED = 0x11223344
const TxFORMAT_COBRA_DUAL_INTERLEAVED = 0x11112222
const TxFORMAT_DUAL_INTERLEAVED = 0x11221122
const TxFORMAT_NON_INTERLEAVED = 0x11111111
const TxFORMAT_SINGLE = 0x11111111
const TxFORMAT_STACKED = Float32(0x07ffffff)
#-------------------------------------------------------------------------------
const CS_CHAN_1 = 1
const CS_CHAN_2 = 2
const CS_FILTER_OFF = 0
const CS_FILTER_ON = 1
const CS_COUPLING_DC = 0x01
const CS_COUPLING_AC = 0x02
const CS_COUPLING_MASK = 0x03
const CS_DIFFERENTIAL_INPUT = 0x04
const CS_DIRECT_ADC_INPUT = 0x08
const CS_REAL_IMP_1M_OHM = 1000000
const CS_REAL_IMP_50_OHM = 50
const CS_REAL_IMP_1K_OHM = 1000
const CS_GAIN_100_V = 100000
const CS_GAIN_40_V = 40000
const CS_GAIN_20_V = 20000
const CS_GAIN_10_V = 10000
const CS_GAIN_8_V = 8000
const CS_GAIN_5_V = 5000
const CS_GAIN_4_V = 4000
const CS_GAIN_3_V = 3000
const CS_GAIN_2_V = 2000
const CS_GAIN_1_V = 1000
const CS_GAIN_800_MV = 800
const CS_GAIN_500_MV = 500
const CS_GAIN_400_MV = 400
const CS_GAIN_200_MV = 200
const CS_GAIN_100_MV = 100
const CS_GAIN_50_MV = 50
const CS_GAIN_CMOS = 2500
const CS_GAIN_TTL = 1500
const CS_GAIN_PECL = 3000
const CS_GAIN_LVDS = 0
const CS_GAIN_ECL = -2000
#-------------------------------------------------------------------------------
const CS_TRIG_COND_NEG_SLOPE = 0
const CS_TRIG_COND_POS_SLOPE = 1
const CS_TRIG_COND_PULSE_WIDTH = 2
const CS_MAX_TRIG_COND = 3
const CS_RELATION_OR = 0
const CS_RELATION_AND = 1
const CS_EVENT1 = 2
const CS_EVENT2 = 3
const CS_TRIG_ENGINES_DIS = 0
const CS_TRIG_ENGINES_EN = 1
const CS_TRIG_SOURCE_DISABLE = 0
const CS_TRIG_SOURCE_CHAN_1 = 1
const CS_TRIG_SOURCE_CHAN_2 = 2
const CS_TRIG_SOURCE_EXT = -1
#-------------------------------------------------------------------------------
const CS_BOARD_INFO = 1
const CS_SYSTEM = 3
const CS_CHANNEL = 4
const CS_TRIGGER = 5
const CS_ACQUISITION = 6
const CS_PARAMS = 7
const CS_FIR_CONFIG = 8
const CS_EXTENDED_BOARD_OPTIONS = 9
const CS_TIMESTAMP_TICKFREQUENCY = 10
const CS_CHANNEL_ARRAY = 11
const CS_TRIGGER_ARRAY = 12
const CS_SMT_ENVELOPE_CONFIG = 13
const CS_SMT_HISTOGRAM_CONFIG = 14
const CS_FFT_CONFIG = 15
const CS_FFTWINDOW_CONFIG = 16
const CS_MULREC_AVG_COUNT = 17
const CS_TRIG_OUT_CFG = 18
const CS_GET_SEGMENT_COUNT = 19
const CS_ONE_SAMPLE_DEPTH_RESOLUTION = 20
#-------------------------------------------------------------------------------
const CS_TRIGGERED_INFO = 200
const CS_SEGMENTTAIL_SIZE_BYTES = 201
const CS_STREAM_SEGMENTDATA_SIZE_SAMPLES = 202
const CS_STREAM_TOTALDATA_SIZE_BYTES = 203
const CS_IDENTIFY_LED = 204
const CS_CAPTURE_MODE = 205
const CS_DATAPACKING_MODE = 206
const CS_GET_DATAFORMAT_INFO = 207
#-------------------------------------------------------------------------------
const CS_CURRENT_CONFIGURATION = 1
const CS_ACQUISITION_CONFIGURATION = 2
const CS_ACQUIRED_CONFIGURATION = 3
#-------------------------------------------------------------------------------
const ACTION_COMMIT = 1
const ACTION_START = 2
const ACTION_FORCE = 3
const ACTION_ABORT = 4
const ACTION_CALIB = 5
const ACTION_RESET = 6
const ACTION_COMMIT_COERCE = 7
const ACTION_TIMESTAMP_RESET = 8
const ACTION_HISTOGRAM_RESET = 9
const ACTION_ENCODER1_COUNT_RESET = 10
const ACTION_ENCODER2_COUNT_RESET = 11
const ACTION_HARD_RESET = 12
const ACQ_STATUS_READY = 0
const ACQ_STATUS_WAIT_TRIGGER = 1
const ACQ_STATUS_TRIGGERED = 2
const ACQ_STATUS_BUSY_TX = 3
const ACQ_STATUS_BUSY_CALIB = 4
#-------------------------------------------------------------------------------
const CS_TIMEOUT_DISABLE = -1
const ACQ_EVENT_TRIGGERED = 0
const ACQ_EVENT_END_BUSY = 1
const ACQ_EVENT_END_TXFER = 2
const ACQ_EVENT_ALARM = 3
const NUMBER_ACQ_EVENTS = 4
#-------------------------------------------------------------------------------
const CAPS_SAMPLE_RATES = 0x00010000
const CAPS_INPUT_RANGES = 0x00020000
const CAPS_IMPEDANCES = 0x00030000
const CAPS_COUPLINGS = 0x00040000
const CAPS_ACQ_MODES = 0x00050000
const CAPS_TERMINATIONS = 0x00060000
const CAPS_FLEXIBLE_TRIGGER = 0x00070000
const CAPS_BOARD_TRIGGER_ENGINES = 0x00080000
const CAPS_TRIGGER_SOURCES = 0x00090000
const CAPS_FILTERS = 0x000a0000
const CAPS_MAX_SEGMENT_PADDING = 0x000b0000
const CAPS_DC_OFFSET_ADJUST = 0x000c0000
const CAPS_CLK_IN = 0x000d0000
const CAPS_BOOTIMAGE0 = 0x000e0000
const CAPS_AUX_CONFIG = 0x000f0000
const CAPS_CLOCK_OUT = 0x00100000
const CAPS_TRIG_OUT = 0x00110000
const CAPS_TRIG_ENABLE = 0x00120000
const CAPS_AUX_OUT = 0x00130000
const CAPS_AUX_IN_TIMESTAMP = 0x00140000
const CAPS_FWCHANGE_REBOOT = 0x00150000
const CAPS_EXT_TRIGGER_UNIPOLAR = 0x00160000
const CAPS_TRIG_ENGINES_PER_CHAN = 0x00200000
const CAPS_MULREC = 0x00400000
const CAPS_TRIGGER_RES = 0x00410000
const CAPS_MIN_EXT_RATE = 0x00420000
const CAPS_SKIP_COUNT = 0x00430000
const CAPS_MAX_EXT_RATE = 0x00440000
const CAPS_TRANSFER_EX = 0x00450000
const CAPS_STM_TRANSFER_SIZE_BOUNDARY = 0x00460000
const CAPS_STM_MAX_SEGMENTSIZE = 0x00470000
const CAPS_SINGLE_CHANNEL2 = 0x00480000
const CAPS_SELF_IDENTIFY = 0x00490000
const CAPS_MAX_PRE_TRIGGER = 0x004a0000
const CAPS_DEPTH_INCREMENT = 0x004b0000
const CAPS_TRIGGER_DELAY_INCREMENT = 0x004c0000
#-------------------------------------------------------------------------------
const CS_NO_FILTER = Float32(0x0fffffff)
const CS_NO_EXTTRIG = Float32(0x0fffffff)
const CS_MODE_NO_DDC = 0x00
const CS_DDC_MODE_ENABLE = 0x01
const CS_DDC_MODE_CH1 = 0x01
const CS_DDC_MODE_CH2 = 0x02
const CS_DDC_DEBUG_MUX = 0x03
const CS_DDC_DEBUG_NCO = 0x04
const CS_DDC_MODE_LAST = 0x04
const CS_DDC_MUX_ENABLE = 0x02
const CS_DDC_CORE_CONFIG = 300
const CS_DDC_FIR_COEF_CONFIG = 301
const CS_DDC_CFIR_COEF_CONFIG = 302
const CS_DDC_PFIR_COEF_CONFIG = 303
const CS_DDC_WRITE_FIFO_DATA = 305
const CS_DDC_READ_FIFO_DATA = 306
const SIZE_OF_FIR_COEFS = 96
const SIZE_OF_CFIR_COEFS = 21
const SIZE_OF_PFIR_COEFS = 63
const DDC_FILTER_COEFS_MAX_SIZE = SIZE_OF_FIR_COEFS + SIZE_OF_CFIR_COEFS +
                                  SIZE_OF_PFIR_COEFS
const DDC_CORE_CONFIG_OFFSET = DDC_FILTER_COEFS_MAX_SIZE
const CS_DDC_CONFIG = 400
const CS_DDC_SEND_CMD = 401
const CS_DDC_SCALE_OVERFLOW_STATUS = 402
const CS_PE_ENABLE = 1
const CS_PE_DISABLE = 0
const CS_ENCODER1_COUNT_RESET = 300
const CS_ENCODER2_COUNT_RESET = 301
const CS_ENCODER1_CONFIG = 302
const CS_ENCODER2_CONFIG = 303
const CS_ENCODER1_COUNT = 304
const CS_ENCODER2_COUNT = 305
const CS_PE_INPUT_TYPE_STEPANDDIRECTION = 0
const CS_PE_INPUT_TYPE_QUADRATURE = 1
const CS_PE_ENCODER_MODE_STAMP = 0
const CS_PE_ENCODER_MODE_TOP = 1
#-------------------------------------------------------------------------------
const CS_OCT_ENABLE = 1
const CS_OCT_DISABLE = 0
const CS_OCT_MODE0 = 0
const CS_OCT_MODE1 = 1
const CS_OCT_CORE_CONFIG = 330
const CS_OCT_RECORD_LEN = 331
const CS_OCT_CMD_MODE = 332
