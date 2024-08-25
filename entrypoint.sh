#!/bin/bash

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

until pgrep "dockerd" >/dev/null; do sleep 0.5; done

# Execute specified command
"$@"
