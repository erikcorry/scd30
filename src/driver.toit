// Copyright (C) 2022 Toitware ApS. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import serial
import binary

class Measurements:
    co2         /float
    temperature /float
    humidity    /float

    constructor .co2 .humidity .temperature:

/**
Driver for the Sensirion SCD30 Sensor Module.
*/
class Scd30:
  static I2C_ADDRESS ::= 0x61

  // Available commands.
  static COMMAND_GET_DATA_READY_ ::= #[0x02, 0x02]
  static COMMAND_READ_MEASUREMENT_ ::= #[0x03, 0x00]
  static COMMAND_SET_CONTINUOUS_AND_PRESSURE_ ::= #[0x00, 0x10]

  device_/serial.Device
  pressure_/int := ?

  /**
  Creates a driver and initializes the ambient pressure (in millibar
    or hectopascal).
  */
  constructor device/serial.Device --pressure/int=1013:
    device_ = device
    if not 0 < pressure < 0x10000: throw "OUT_OF_RANGE"
    pressure_ = pressure
    set_pressure_

  /**
  Returns whether data is ready.
  */
  is_ready_ -> bool:
    device_.write COMMAND_GET_DATA_READY_
    data := device_.read 3
    check_crc_ data
    value := binary.BIG_ENDIAN.int16 data 0
    return value == 1

  wait_for_ready_ -> none:
    for i := 0; not is_ready_; i++:
      if i == 100: throw "Device is not getting ready."
      sleep --ms=20

  pressure= value/int:
    pressure_ = value
    set_pressure_

  set_pressure_ -> none:
    // Set continuous mode with the given (or default) air pressure.
    pressure_bytes := ByteArray 2
    binary.BIG_ENDIAN.put_int16 pressure_bytes 0 pressure_
    command := COMMAND_SET_CONTINUOUS_AND_PRESSURE_ + pressure_bytes + #[compute_crc8_ pressure_bytes]
    device_.write command

  pressure -> int:
    return pressure_

  /**
  Reads the measurements from the sensor.
  Waits until data is available and returns an object containing the CO2, temperature and humidity.
  */
  read -> Measurements:
    wait_for_ready_

    device_.write COMMAND_READ_MEASUREMENT_
    data := device_.read 18

    check_crc_ data[0..3]
    check_crc_ data[3..6]
    co2_data := data[0..2] + data[3..5]
    co2 := binary.BIG_ENDIAN.float32 co2_data 0

    check_crc_ data[6..9]
    check_crc_ data[9..12]
    temperature_data := data[6..8] + data[9..11]
    temperature := binary.BIG_ENDIAN.float32 temperature_data 0

    check_crc_ data[12..15]
    check_crc_ data[15..18]
    humidity_data := data[12..14] + data[15..17]
    humidity := binary.BIG_ENDIAN.float32 humidity_data 0

    return Measurements co2 humidity temperature

  /**
  Checks checksum and throws if wrong.
  */
  check_crc_ data/ByteArray -> none:
    crc := compute_crc8_ data[..data.size - 1]
    if crc != data.last: throw "Bad CRC"

  /**
  Computes the CRC8 checksum.
  */
  compute_crc8_ data/ByteArray -> int:
    crc := 0xFF
    for x := 0; x < data.size; x++:
      crc ^= data[x]
      for i := 0; i < 8; i++:
        if (crc & 0x80) != 0:
          crc = (crc << 1) ^ 0x31
        else:
          crc <<= 1
        crc &= 0xFF

    return crc
