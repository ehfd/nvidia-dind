#!/bin/sh

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

function INFO(){
    local function_name="${FUNCNAME[1]}"
    local msg="$1"
    timeAndDate=`date`
    echo "[$timeAndDate] [INFO] [${0}] $msg"
}


function DEBUG(){
    local function_name="${FUNCNAME[1]}"
    local msg="$1"
    timeAndDate=`date`
    echo "[$timeAndDate] [DEBUG] [${0}] $msg"
}

function ERROR(){
    local function_name="${FUNCNAME[1]}"
    local msg="$1"
    timeAndDate=`date`
    echo "[$timeAndDate] [ERROR]  $msg"
}
