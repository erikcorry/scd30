# SCD30 driver

Driver for the [SCD30 sensor](https://www.sensirion.com/en/environmental-sensors/carbon-dioxide-sensors/carbon-dioxide-sensors-scd30/).

## Usage

The ESP32 pin connection to the SCD30 sensor is as follows:

- GPIO21 > SDA
- GPIO22 > SCL
- 3.3V > 3V
- GND > GND

`import scd30

main:
...
`

See the `examples` folder for more examples

Installation: `toit pkg install github.com/qvisten999/scd30`

## References

[Datasheet](https://www.sensirion.com/en/environmental-sensors/carbon-dioxide-sensors/carbon-dioxide-sensors-scd30/)

## Features and bugs

Use the [issue tracker](https://github.com/qvisten999/scd30/issues/) if you find bugs or missing features.
