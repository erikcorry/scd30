// Copyright (C) 2021 Toitware ApS. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be found
// in the LICENSE file.

import gpio
import i2c
import .scd30

co2_level_ := 0.0

main:
  bus := i2c.Bus
    --sda=gpio.Pin 21
    --scl=gpio.Pin 22

  device := bus.device Scd30.I2C_ADDRESS
  scd30 := Scd30 device

  while true:
    co2_level_ = scd30.read.co2
    if co2_level_ > 2000:
      print "Open your window"
    else:
      print "CO2 level is healthy"
    sleep --ms=60000
