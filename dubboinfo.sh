#!/bin/bash

ip=$1

 >dubboinfo.txt

if [ $# = 0 ] ; then
    echo "缺少参数ip, 请输入服务ip地址"
    exit 1
fi    
cat service.txt|while read linee
do
    >temp
    >temp1
    >temp2
    service=`echo $linee|awk '{print $1}'`
    port=`echo $linee|awk '{print $2}'`
    echo "++++++++++++++++++++++++++++++++++++++++++++" >>dubboinfo.txt
    echo "服务名:"$service "端口:" $port >> dubboinfo.txt
    echo "++++++++++++++++++++++++++++++++++++++++++++" >>dubboinfo.txt
    echo ls -l| nc -i 1 $ip $port|awk '{print $1"\n"}' >> temp
    sed '/^$/d' temp|sed '$d' >> temp1
    for line in `cat temp1`
    do
        echo "facade名:"$line "方法列表如下:"> temp2
        echo "====================================" >> temp2
        echo ls -l $line|nc -i 1 $ip $port >> temp2
        sed '$d' temp2 >> dubboinfo.txt
        echo "" >> dubboinfo.txt
    done
done
echo ">>>>>>>>>统计>>>>>>>>>>>>>" >>dubboinfo.txt
server_count=`grep -n "服务名" dubboinfo.txt|wc -l`
facade_count=`grep -n "方法列表" dubboinfo.txt|wc -l`
method_count=`grep -n "(" dubboinfo.txt|wc -l`

echo "服务数统计:" $server_count  >> dubboinfo.txt
echo "facade数统计:" $facade_count >> dubboinfo.txt
echo "方法列表统计:" $method_count >>dubboinfo.txt
rm -f temp*
