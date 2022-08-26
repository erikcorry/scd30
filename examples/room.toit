// Copyright (C) 2022 Toitware ApS. All rights reserved.
// Use of this source code is governed by a Zero-Clause BSD license that can
// be found in the EXAMPLES_LICENSE file.

/**
Small example to show the use of the CO2 sensor.

The ESP32 pin connection to the SCD30 sensor is as follows:

- GPIO21 > SDA
- GPIO22 > SCL
- 3.3V > 3V
- GND > GND
*/

import gpio
import i2c
import scd30 show Scd30

co2_level := 0.0

main:
  bus := i2c.Bus
    --sda=gpio.Pin 21
    --scl=gpio.Pin 22

  device := bus.device Scd30.I2C_ADDRESS
  scd30 := Scd30 device

  sleep --ms=5000  // In case continuous measurement mode was not activated.

  while true:
    reading := scd30.read
    if reading.co2 > 2000:
      print "Open your window:     $(reading.co2.to_int)ppm"
    else:
      print "CO2 level is healthy: $(reading.co2.to_int)ppm"
    print "Temperature:          $(%.1f reading.temperature)ºC"
    print "Humidity:             $(%.1f reading.humidity)%"
    sleep --ms=6000
