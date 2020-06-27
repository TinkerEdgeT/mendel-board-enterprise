@ECHO OFF

ECHO.
ECHO.
ECHO ###################################
ECHO #### START TO FLASH u-boot.imx ####
ECHO ###################################
ECHO.
ECHO.

fastboot flash bootloader0 u-boot.imx
IF NOT %ERRORLEVEL% == 0  (
  ECHO "flash u-boot.imx FAILED, EXIT!"
  PAUSE
  GOTO END
)

fastboot reboot-bootloader
PING 127.0.0.1 -n 3

ECHO.
ECHO.
ECHO ##############################
ECHO #### u-boot.imx FLASH OK! ####
ECHO ##############################
ECHO.
ECHO.


ECHO.
ECHO.
ECHO ############################################
ECHO #### START TO FLASH PARTITION TABLE!!  ####
ECHO ############################################
ECHO.
ECHO.

set GPT_FILE=partition-table-8gb.img
ECHO gpt_file = %GPT_FILE%
fastboot flash gpt partition-table-8gb.img
IF NOT %ERRORLEVEL% == 0  (
  ECHO "flash gpt FAILED, EXIT!"
  PAUSE
  GOTO END
)

fastboot reboot-bootloader
PING 127.0.0.1 -n 3

ECHO.
ECHO.
ECHO ####################################
ECHO #### CREATE PARTITION TABLE OK! ####
ECHO ####################################
ECHO.
ECHO.

ECHO.
ECHO.
ECHO ####################################
ECHO #### START TO Erase MISC!!      ####
ECHO ####################################
ECHO.
ECHO.

fastboot erase misc
IF NOT %ERRORLEVEL% == 0  (
  ECHO " erase misc FAILED, EXIT!"
  PAUSE
  GOTO END
)

ECHO.
ECHO.
ECHO ##############################
ECHO #### Erase MISC OK!       ####
ECHO ##############################
ECHO.
ECHO.

ECHO.
ECHO.
ECHO ####################################
ECHO #### START TO BOOT / ROOTFS     ####
ECHO ####################################
ECHO.
ECHO.

::fastboot flash boot boot_arm64.img
fastboot erase boot
IF NOT %ERRORLEVEL% == 0  (
  ECHO "erase boot FAILED, EXIT!"
  PAUSE
  GOTO END
)

::fastboot flash rootfs rootfs_arm64.img
::IF NOT %ERRORLEVEL% == 0  (
::  ECHO "flash rootfs FAILED, EXIT!"
::  PAUSE
::  GOTO END
::)

ECHO.
ECHO.
ECHO ##############################################
ECHO #### BOOT / ROOTFS FLASHING OK! ####
ECHO ##############################################
ECHO.
ECHO.

fastboot reboot
PAUSE

:END

