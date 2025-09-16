#! /bin/bash

asd &&
code-server \
    --auth none \
    --bind-addr 0.0.0.0:8081 \
    --disable-telemetry \
    --app-name "Aerospike Education" \
    --disable-getting-started-override \
    /home/aero_edu/projects/vest-vault.code-workspace &&
exec "$@"
