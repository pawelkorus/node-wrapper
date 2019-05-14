#!/usr/bin/env bats

load 'test_helper/bats-support/load'
load 'test_helper/bats-assert/load'

SCRIPT_UNDER_TEST="$BATS_TEST_DIRNAME/../node-wrapper-docker.sh"
NWDRC_PATH="$BATS_TMPDIR/.nwdrc"

mock_docker() {
    docker() { echo "$@"; }
    export -f docker
}

setup_nwdrc() {
    echo $1 > $NWDRC_PATH
    export NWDRC_PATH
}

setup() {
    v_current_user_id=$(id -u)
    v_current_group_id=$(id -g)

    touch $NWDRC_PATH
}

teardown() {
    rm $NWDRC_PATH
    
    unset docker
    unset NWDRC_PATH
}

@test "should call docker with default image and pass all arguments" {
    mock_docker

    run bash -e $SCRIPT_UNDER_TEST test

    assert_line "run --rm -v $PWD:/usr/src/app -w /usr/src/app --user $v_current_user_id:$v_current_group_id node:lts-slim node-wrapper-docker.sh test"
}

@test "should use node image and node version from .nwdrc" {
    mock_docker
    setup_nwdrc "version_test"

    run bash -e $SCRIPT_UNDER_TEST test

    assert_line --partial "run --rm -v $PWD:/usr/src/app -w /usr/src/app --user $v_current_user_id:$v_current_group_id node:version_test node-wrapper-docker.sh test"
}

@test "should read image and version from .nwdrc" {
    mock_docker
    setup_nwdrc "image_test:version_test"

    run bash -e $SCRIPT_UNDER_TEST test

    assert_line "run --rm -v $PWD:/usr/src/app -w /usr/src/app --user $v_current_user_id:$v_current_group_id image_test:version_test node-wrapper-docker.sh test"
}

