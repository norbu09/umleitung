#!/bin/sh
export MOCHIWEB_IP="127.0.0.1"
cd `dirname $0`
exec erl -pa $PWD/ebin $PWD/deps/*/ebin -boot start_sasl -s umleitung
