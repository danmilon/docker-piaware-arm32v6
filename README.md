# flightaware/piaware docker container image #

A [flightaware/piaware](https://github.com/flightaware/piaware) docker
container image, built on top of alpine linux, for the arm32v6 architecture. It
is designed to connect to an existing dump1090 process
(e.g. [danmilon/dump1090-fa-arm32v6](https://cloud.docker.com/repository/docker/danmilon/dump1090-fa-arm32v6/)).

## How to run ##

```
docker run \
  -v $PWD/piaware.conf:/etc/piaware.conf \
  danmilon/piaware-arm32v6
```

Default command is `piaware -plainlog`.

See the [https://uk.flightaware.com/adsb/piaware/advanced_configuration](flightaware
docs) for the possible piaware.conf configuration options.

For example, a common configuration to connect to an external beast
(e.g. dump1090) server:

    feeder-id xxx
    receiver-type other
    receiver-host dump1090-host-or-ip
    receiver-port 30005
    mlat-results no

If multiple rtlsdr devices are connected, you'll need to also set `rtlsdr-device-index`.
The first time you run it, skip the `feeder-id` setting, so that it does a
fresh registration and flightaware will assign it a new feeder-id, which you
then need to set in the configuration file.
