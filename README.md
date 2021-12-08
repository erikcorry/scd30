# SCD30 driver

Driver for the [SCD30 sensor](https://www.sensirion.com/en/environmental-sensors/carbon-dioxide-sensors/carbon-dioxide-sensors-scd30/).

## Connect the sensor

The ESP32 pin connection to the SCD30 sensor is as follows:

- GPIO21 > SDA
- GPIO22 > SCL
- 3.3V > 3V
- GND > GND

## Install the driver via the Toit Package Registry

toit pkg install github.com/toitware/bme280-driver
