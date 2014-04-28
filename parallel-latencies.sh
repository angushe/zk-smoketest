declare -a pids

count=${1:-1}
for x in $(seq 1 $count); do
  PYTHONPATH=lib.linux-x86_64-2.6/ LD_LIBRARY_PATH=lib.linux-x86_64-2.6/ ./zk-latencies.py --config '/etc/zookeeper/conf/zoo.cfg' --root_znode="/zk-latencies-$x" "$@" &
  pids[$x]=$!
done


FAILED=""
for x in $(seq 1 $count); do
    if ! wait ${pids[$x]}; then
        FAILED="failed"
    fi  
done
[ -z FAILED ] || exit 1
